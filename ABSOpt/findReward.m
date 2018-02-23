function [ reward ] = findReward( state )
%FINDREWARD Summary of this function goes here
%   Detailed explanation goes here

%state -> SMacro throughput macro
%state -> SMicro Average throughput micros
%state -> nUEMacro number of active UE connected to macro
%state -> nUEMicro average number of active UE connected to micros

%compute the reward 
%reward = - (state.SMacro * state.nUEMicro / (state.SMicro * state.nUEMacro) - 1)^2;
MAX_REWARD = 10;

reward = MAX_REWARD; %if there are 0 users in the system max reward 

if(state.nUEMacro == 0 && state.nUEMicro > 0)
    reward = state.nABS;
elseif(state.nUEMacro >0 && state.nUEMicro == 0)
    reward = 10-state.nABS;
else
    ratio = (state.SMacro * state.nUEMicro / (state.SMicro * state.nUEMacro));

    if ratio<=1
        reward = ratio*MAX_REWARD;
    else
        reward = max(MAX_REWARD*(2 - ratio),0);
    end  
end
    
end

