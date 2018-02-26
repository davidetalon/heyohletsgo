function [ nABS, change ] = qLearningABS(nABS, state, policy, S_ratio_max, N_ratio_max, truncate)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

increase = [-2 0 2];
SMax = S_ratio_max * truncate;
NMax = N_ratio_max * truncate;

normalizedState = normalize_one_state(state, 5, 4, SMax, NMax);

action = policy(normalizedState(1), normalizedState(2), normalizedState(3));

if action == 0
    change = 0;
else
    change = increase(action);
end

nABS = nABS + change;


 
end

