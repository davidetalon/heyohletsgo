function [Station, pid, newTb] = getHarqPid(Station, User, sqn, varargin)

%   GET HARQ PROCESS ID returns the process ID for the combination of UE, eNodeB and SQN
%
%   Function fingerprint
% 	Station			->	the eNodeB object			
%   User      	->  the UE object
% 	sqn					-> 	the SQN for this session
%   varargin		->  variable number of inputs 
%
%   pid					->  the HARQ process ID
%   Station     ->  the updated UE object
%   newTb      	->  boolean for new TB

	% Check if there are any options, otherwise assume default
	outFmt = 'd';
	inFmt = 'd';
	if nargin > 0
		if varargin{1} == 'outFormat'
			outFmt = varargin{2};
		end
		if varargin{3} == 'inFormat'
			inFmt = varargin{4};
		end
	end

	% In case the SQN has been passed as binary, convert it to decimal
	if inFmt == 'b'
		sqn = bi2de(sqn');
	end

	% Find index
	iUser = find([Station.Mac.HarqTxProcesses.receiver] == User.UeId);
	% Find pid
	[Station.Mac.HarqTxProcesses(iUser), harqPid, newTb] = findProcess(Station.Mac.HarqTxProcesses(iUser), sqn);	

	% Finally check the output format
	if outFmt ~= 'd'
		pid = de2bi(harqPid)';
		if length(pid) ~= 3
			pid = cat(1, zeros(3-length(pid), 1), pid);
		end
	else
		pid = harqPid;
	end
end
