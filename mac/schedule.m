function [Station, Users] = schedule(Station, Users, Param)

%   SCHEDULE is used to return the allocation of PRBs for a schedule
%
%   Function fingerprint
%   Station					->  base Station
%		Users						-> 	users list
%   Param.prbSym		->  number of OFDM symbols per PRB
%
%   Station		->  station with allocation array with:
%             		--> ueId		id of the UE scheduled in that slot
%									--> mcs 		modulation and coding scheme decided
%									--> modOrd	modulation order as bits/OFDM symbol

% Set a flag for the overall number of valid UE attached
sz = length(extractUniqueIds([Station.Users.UeId]));

% calculate number of available RBs available in the subframe for the PDSCH
res = length(find(abs(Station.Tx.ReGrid) == 0));
prbsAv = floor(res/Param.prbRe);

% get ABS info
% current subframe
currentSubframe = Station.NSubframe;
absValue = Station.ABSMask(currentSubframe + 1); % get a 0 or 1 that corresponds
% to the mask of this subframe

% if the policy is simpleABS, we use the fixed ABS mask from the Station
% properties
switch Param.icScheme
    case 'simpleABS'
        if(strcmp(Station.BsClass, 'micro'))
            % the behavior of the micro is the opposite of that of the macro
            absValue = ~absValue;
        end
        prbsAv = (1 - absValue) * prbsAv; % set the number of available PRBs to
        % zero when the absValue is 1, i.e., when we have an almost blank
        % subframe
    case 'fullReuseABS'
        if(strcmp(Station.BsClass, 'macro')) % micros can always transmit
            prbsAv = (1 - absValue) * prbsAv;
            % set the number of available PRBs to
            % zero when the absValue is 1, i.e., when we have an almost blank
            % subframe
        end
end

switch Param.scheduling
    case 'roundRobin'
       
        maxRounds = sz;
        iUser = Station.RoundRobinDLNext.Index;
        while (iUser <= sz && maxRounds > 0)
            % First off check if we are in an unused position or out
            iUser = checkIndexPosition(Station, iUser, sz);
            
            % find user in main list
            for ixUser = 1:length(Users)
                if Users(ixUser).NCellID == Station.Users(iUser).UeId
                    iCurrUe = ixUser;
                    break;
                end
            end
            
            % If the retransmissions are on, check awaiting retransmissions
            rtxInfo = struct('proto', [], 'identifier', [], 'iUser', -1);
            if Param.rtxOn
                rtxInfo = checkRetransmissionQueues(Station, Users(iCurrUe).NCellID);
            end
            
            % Boolean flags for scheduling for readability
            schedulingFlag = ~Users(iCurrUe).Scheduled;
            noRtxSchedulingFlag = Users(iCurrUe).Queue.Size > 0 && (~Param.rtxOn || ...
                (Param.rtxOn && rtxInfo.proto == 0));
            rtxSchedulingFlag = Param.rtxOn && rtxInfo.proto ~= 0;
            
            % If there are still PRBs available, then we can schedule either a new TB or a RTX
            if prbsAv > 0
                if schedulingFlag && (noRtxSchedulingFlag || rtxSchedulingFlag)
                    modOrd = cqi2modOrd(Users(iCurrUe).Rx.CQI);
                    if noRtxSchedulingFlag
                        prbsNeed = ceil(double(Users(iCurrUe).Queue.Size)/double((modOrd * Param.prbSym)));
                    else
                        % In this case load the TB picked for retransmission
                        tb = [];
                        switch rtxInfo.proto
                            case 1
                                tb = Station.Mac.HarqTxProcesses(rtxInfo.iUser).processes(rtxInfo.identifier).tb;
                            case 2
                                tb = Station.Rlc.ArqTxBuffers(rtxInfo.iUser).tbBuffer(rtxInfo.identifier).tb;
                        end
                        prbsNeed = ceil(length(tb)/(modOrd * Param.prbSym));
                    end
                    if prbsNeed >= prbsAv
                        prbsSch = prbsAv;
                    else
                        prbsSch = prbsNeed;
                    end
                    
                    prbsAv = prbsAv - prbsSch;
                    Users(iCurrUe) = setScheduled(Users(iCurrUe), true);
                    if rtxSchedulingFlag
                        Station = initRetransmission(Station, rtxInfo);
                    end
                    % write to schedule struct
                    for iPrb = 1:Station.NDLRB
                        if Station.ScheduleDL(iPrb).UeId == -1
                            mcs = cqi2mcs(Users(iCurrUe).Rx.CQI);
                            for iSch = 0:prbsSch-1
                                Station.ScheduleDL(iPrb + iSch) = struct(...
                                    'UeId', Users(iCurrUe).NCellID,...
                                    'Mcs', mcs,...
                                    'ModOrd', modOrd);
                            end
                            break;
                        end
                    end
                    
                    % Increment the user counter to serve the next one
                    iUser = iUser + 1;
                    
                    % Check the index of the user to handle a possible reset
                    iUser = checkIndexPosition(Station, iUser, sz);
                    
                end
                maxRounds = maxRounds - 1;
                
            else
                % There are no more PRBs available, this will be the first UE to be scheduled
                % in the next round.
                % Check first whether we went too far in the list and we need to restart
                % from the beginning
                iUser = checkIndexPosition(Station, iUser, sz);
                Station.RoundRobinDLNext.UeId = Station.Users(iUser).UeId;
                Station.RoundRobinDLNext.Index = iUser;
                
                % in both cases, stop the loop
                iUser = sz + 1;
            end
        end
end

    function validIndex = checkIndexPosition(Station, iUser, sz)
        if iUser > sz || Station.Users(iUser).UeId == -1
            % In this case we need to reset to the first active and valid UE
            validUeIndexes = find([Station.Users.UeId] ~= -1);
            validIndex = validUeIndexes(1);
        else
            validIndex = iUser;
        end
    end

end
