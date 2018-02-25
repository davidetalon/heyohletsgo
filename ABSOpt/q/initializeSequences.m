function [states_sequence, actions_sequence, rewards_sequence] = initializeSequences(raw_data)

number_of_states = size(raw_data.SMacro,1);
states_sequence = zeros(number_of_states,3);
actions_sequence = zeros(number_of_states-1,1);
rewards_sequence = zeros(number_of_states-1,1);

for j = 1:number_of_states
    
    states_sequence(j,1) = raw_data.SMacro(j)/raw_data.SMicro(j);
    states_sequence(j,2) = raw_data.nUEMacro(j)/raw_data.nUEMicro(j);
    states_sequence(j,3) = raw_data.nABS(j+1);
    
    if j > 2
        actions_sequence(j-2) = ((raw_data.nABS(j)-raw_data.nABS(j-1) + 2)/2)+1;
    end
    
    if j < number_of_states
        rewards_sequence(j) = raw_data.Reward(j+1);
    end
        
end

    actions_sequence(number_of_states-1) = ((raw_data.nABS(number_of_states+1)-raw_data.nABS(number_of_states) + 2)/2)+1;

