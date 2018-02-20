function [states_sequence, actions_sequence, rewards_sequence] = initializeSequences(raw_data)

number_of_states = size(raw_data.SMacro,1);
states_sequence = zeros(number_of_states,5);
actions_sequence = zeros(number_of_states-1,1);
rewards_sequence = zeros(number_of_states-1,1);

for j = 1:number_of_states
    
    states_sequence(j,1) = raw_data.SMacro(j);
    states_sequence(j,2) = raw_data.SMicro(j);
    states_sequence(j,3) = raw_data.nUEMacro(j);
    states_sequence(j,4) = raw_data.nUEMicro(j);
    states_sequence(j,5) = raw_data.nABS(j);
    
    if j ~= 1
        rewards_sequence(j-1) = raw_data.Reward(j-1);
        actions_sequence(j-1) = raw_data.nABS(j)-raw_data.nABS(j-1) + 2;
    end
end

