function simulate(Param, DataIn, utilLo, utilHi)

%   SIMULATE is used to run a single simulation
%
%   Function fingerprint
%   Param			->  general simulation parameters
%		DataIn		-> 	input data as struct
%   utilLo		-> 	value of low utilisation for this simulation
%		utilHi		->	value for high utilisation for this simulation

trSource = DataIn.trSource;
Stations = DataIn.Stations;
Users = DataIn.Users;
Channel = DataIn.Channel;
ChannelEstimator = DataIn.ChannelEstimator;
SimulationMetrics = MetricRecorder(Param, utilLo, utilHi);

% Create structures to hold transmission data
if (Param.storeTxData)
	[tbMatrix, tbMatrixInfo] = initTbMatrix(Param);
	[cwdMatrix, cwdMatrixInfo] = initCwdMatrix(Param);
end
%[symMatrix, symMatrixInfo] = initSymMatrix(Param);

% create a string to mark the output of this simulation
outPrexif = strcat('utilLo_', num2str(utilLo), '-utilHi_', num2str(utilHi));

if Param.generateHeatMap
	switch Param.heatMapType
		case 'perClass'
			HeatMap = generateHeatMapClass(Stations, Channel, Param);
		case 'perStation'
			HeatMap = generateHeatmap(Stations, Channel, Param);
		otherwise
			sonohilog('Unknown heatMapType selected in simulation parameters', 'ERR')
	end
else
	load('utils/heatmap/HeatMap_eHATA_fBS_pos_5m_res');
end

%generating Station's masks with dynamic ABS rate
%choose the ABS optimization policy
switch Param.ABSOptimization
    case 'random'
        change = randomABS();
    case 'QLearning'
        change = qLearningABS();
    case 'static'
        change = Stations(1).nABS;
end

%nABS must be positive and not lower or equals the total number of
%subFrames
futureNABS = Stations(1).nABS + change;
if(futureNABS < 0) or (futureNABS > Param.schRounds)
    nABS = Stations(1).nABS;
else
    nABS = futureNABS;
end

ABSMask = generateABSMask(Param.schRounds, nABS);

for iStation = 1:length(Stations)
    Stations(iStation).nABS = nABS;
    Stations(iStation).ABSMask = ABSMask;
        
end


% if Param.draw
% 	drawHeatMap(HeatMap, Stations);
% end

% Rounds are 0-based for the subframe indexing, so add 1 when needed
for iRound = 0:(Param.schRounds-1)
	% In each scheduling round, check UEs associated with each station and
	% allocate PRBs through the scheduling function per each station
	sonohilog(sprintf('Round %i/%i',iRound+1,Param.schRounds),'NFO');
	
	% refresh UE-eNodeB association
	simTime = iRound*10^-3;
	if mod(simTime, Param.refreshAssociationTimer) == 0
		sonohilog('Refreshing user association', 'NFO');
		[Users, Stations] = refreshUsersAssociation(Users, Stations, Channel, Param, simTime);
	end
	
	% Update RLC transmission queues for the users and reset the scheduled flag
	for iUser = 1:length(Users)
		queue = updateTrQueue(trSource, simTime, Users(iUser));
		Users(iUser) = setQueue(Users(iUser), queue);
	end
	
	% ---------------------
	% ENODEB SCHEDULE START
	% ---------------------
	for iStation = 1:length(Stations)
		
		% schedule only if at least 1 user is associated
		if ~isempty(find([Stations(iStation).Users.UeId] ~= -1))
			[Stations(iStation), Users] = schedule(Stations(iStation), Users, Param);
		end
		
		% Check utilisation
		sch = find([Stations(iStation).ScheduleDL.UeId] ~= -1);
		utilPercent = 100*find(sch, 1, 'last' )/length(sch);
		
		% check utilPercent and change to 0 if null
		if isempty(utilPercent)
			utilPercent = 0;
		end
		
		% calculate the power that will be used in this round by this eNodeB
		pIn = getPowerIn(Stations(iStation), utilPercent/100);
		
		% store eNodeB-space results
		resultsStore(iStation).util = utilPercent;
		resultsStore(iStation).power = pIn;
		resultsStore(iStation).schedule = Stations(iStation).ScheduleDL;
		
		% Check utilisation metrics and change status if needed
		Stations(iStation) = checkUtilisation(Stations(iStation), utilPercent,...
			Param, utilLo, utilHi, Stations);
	end
	% -------------------
	% ENODEB SCHEDULE END
	% -------------------
	
	% ----------------------------------------------
	% ENODEB DL-SCH & PDSCH CREATION AND MAPPING
	% ----------------------------------------------
	sonohilog('eNodeB DL-SCH & PDSCH creation and mapping', 'NFO');
	[Stations, Users] = enbTxBulk(Stations, Users, Param, simTime);
	
	% ----------------------------------
	% DL CHANNEL SYNCHRONIZATION
	% ------------------------------------
	% Setup the channel based on scheduled users
	Channel = Channel.setupChannelDL(Stations,Users);
	sonohilog('Running sync routine', 'NFO');
	[Users, Channel] = syncRoutine(Stations, Users, Channel, Param);
	
	% ------------------
	% CHANNEL TRAVERSE
	% ------------------
	% Once all eNodeBs have created and stored their txWaveforms, we can go
	% through the UEs and compute the rxWaveforms
	sonohilog(sprintf('Traversing channel in DL (mode: %s)...',Param.channel.modeDL), 'NFO');
	[Stations, Users] = Channel.traverse(Stations, Users, 'downlink');
	
	% ------------
	% UE RECEPTION
	% ------------
	sonohilog('UE reception block', 'NFO');
	Users = ueRxBulk(Stations, Users, ChannelEstimator.Downlink);

	% ----------------
	% UE DATA DECODING
	% ----------------
	sonohilog('UE data decoding block', 'NFO');
	[Stations, Users] = ueDataDecoding(Stations, Users, Param, simTime);
	
	% --------------------------
	% UE UPLINK
	% ---------------------------
	sonohilog('Uplink transmission', 'NFO');
	[Stations, compoundWaveforms, Users] = ueTxBulk(Stations, Users, iRound, mod(iRound,10));

	% ------------------
	% CHANNEL TRAVERSE
	% ------------------
	sonohilog(sprintf('Traversing channel in UL (mode: %s)...',Param.channel.modeUL), 'NFO');
	Channel = Channel.setupChannelUL(Stations,Users,'compoundWaveform',compoundWaveforms);
	[Stations, Users] = Channel.traverse(Stations, Users,'uplink');

	% --------------------------
	% ENODEB RECEPTION
	% ---------------------------
	sonohilog('eNodeB reception block', 'NFO');
	Stations = enbRxBulk(Stations, Users, simTime, ChannelEstimator.Uplink);

	% ----------------
	% ENODEB DATA DECODING
	% ----------------
	sonohilog('eNodeB data decoding block', 'NFO');
	[Stations, Users] = enbDataDecoding(Stations, Users, Param, simTime);

	% --------------------------
	% ENODEB SPACE METRICS RECORDING
	% ---------------------------
	sonohilog('eNodeB-space metrics recording', 'NFO');
	SimulationMetrics = SimulationMetrics.recordEnbMetrics(Stations, iRound);
	
	% --------------------------
	% UE SPACE METRICS RECORDING
	% ---------------------------
	sonohilog('UE-space metrics recording', 'NFO');
	SimulationMetrics = SimulationMetrics.recordUeMetrics(Users, iRound);

	% -----------
	% UE MOVEMENT
	% -----------
	sonohilog('UE movement', 'NFO');
	for iUser = 1:length(Users)
		Users(iUser) = move(Users(iUser), simTime, Param);
	end
	
	% Plot resource grids for all users
	if Param.draw
    delete_figs; % Redraws the plots
		[hScatter(1), hScatter(2)] = plotConstDiagram_rx(Stations,Users);
		[hGrids(1), hGrids(2)] = plotReGrids(Users);
		[hSpectrums(1)] = plotSpectrums(Users,Stations);
	end
	
	
	% --------------------
	% RESET FOR NEXT ROUND
	% --------------------
	sonohilog('Resetting objects for next simulation round', 'NFO');
	for iUser = 1:length(Users)
		Users(iUser) = Users(iUser).reset();
	end
	for iStation = 1:length(Stations)
		Stations(iStation) = Stations(iStation).reset(iRound + 1);
	end
	Channel = Channel.resetChannelModels();
	
end % end round

% Once this simulation set is done, save the output
save(strcat('results/', outPrexif, '.mat'), 'SimulationMetrics');
end
