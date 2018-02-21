function [states_sequence, actions_sequence, rewards_sequence] = initializeSequences(raw_data, ratio_limit)

number_of_states = size(raw_data.SMacro,1);
states_sequence = zeros(number_of_states,3);
actions_sequence = zeros(number_of_states-1,1);
rewards_sequence = zeros(number_of_states-1,1);

for j = 1:number_of_states
    
    if raw_data.SMicro(j)>0 && raw_data.SMacro(j)/raw_data.SMicro(j)<ratio_limit
        states_sequence(j,1) = raw_data.SMacro(j)/raw_data.SMicro(j);
    else
        states_sequence(j,1) = ratio_limit;
    end
    
    
    if raw_data.nUEMicro(j)>0 && raw_data.nUEMacro(j)/raw_data.nUEMicro(j)<ratio_limit
         states_sequence(j,2) = raw_data.nUEMacro(j)/raw_data.nUEMicro(j);
    else
         states_sequence(j,2) = ratio_limit;
    end
    
    states_sequence(j,3) = raw_data.nABS(j);
    
    if j ~= 1
        rewards_sequence(j-1) = raw_data.Reward(j-1);
        actions_sequence(j-1) = (raw_data.nABS(j)-raw_data.nABS(j-1) + 2)/2;
    end
end

