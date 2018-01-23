function [ reward ] = findReward( state )
%FINDREWARD Summary of this function goes here
%   Detailed explanation goes here

%state -> SMacro throughput macro
%state -> SMicro Average throughput micros
%state -> nUEMacro number of active UE connected to macro
%state -> nUEMicro average number of active UE connected to micros

%compute the reward 
reward = - (state.SMacro * state.nUEmicro / (state.Smicro * state.nUEMacro) - 1)^2;


end

