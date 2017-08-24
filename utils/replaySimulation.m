%% replaySimulation
clear all
close all


mode = 'perStation'; %perUser

% Just run me. or select user/station by setting parameter
sUser = 4;
sStation = 3;

%% Initialization
fprintf('Loading results...')
load('results/compiled.mat')
Param.round_duration = 0.001; %seconds
Param.no_rounds = length([ueOut(1,1,:,1)]);
total_time = 0.001*Param.no_rounds; % seconds

fprintf('done.\n')

if isnan(sUser) && isnan(sStation)
fprintf('View parameters not set.\n')
if strcmp(mode,'perStation')
  disp('Which station would you like to display?')
  poss = sprintf('%.0f,',[Stations.NCellID]);
  fprintf('Possibilities: %s',poss(1:end-1))
  sStation = input('\n');
elseif strcmp(mode,'perUser')
  disp('Which user would you like to display?')
  poss = sprintf('%.0f,',[Users.UeId]);
  fprintf('Possibilities: %s',poss(1:end-1))
  sUser = input('\n');
end
end


if strcmp(mode,'perStation')

  station = Stations(sStation);
  
  displayStation(enbOut,Stations,sStation,Param, ueOut, Users)
   
  
elseif strcmp(mode, 'perUser')
  while true
    displayUser(ueOut,Users,sUser,Param)
    fprintf('Replay? (y/n) ')
    rep = input('\n','s');
    if ~strcmp(rep,'y')
      rep = input('Select a different user? (n for exit) \n','s');
      if strcmp(rep,'n')
        break
      else
        sUser = str2num(rep);
      end
    end
  end

end