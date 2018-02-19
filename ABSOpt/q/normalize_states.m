function [output_stetes_sequence] = normalize_states(input_states_sequence, S_values,N_values)

output_stetes_sequence = input_states_sequence;

S_max = 0;
N_max = 0;

%evaluate maximum values
for j = 1:size(input_states_sequence,1)
   
    if input_states_sequence(j,1) > S_max
        S_max = input_states_sequence(j,1)
    end
    if input_states_sequence(j,2) > S_max
         S_max = input_states_sequence(j,2)
    end
    
    
    if input_states_sequence(j,3) > N_max
        S_max = input_states_sequence(j,3)
    end
    if input_states_sequence(j,4) > N_max
         S_max = input_states_sequence(j,4)
    end
    
end


for j = 1:size(input_states_sequence,1)
   
    output_stetes_sequence(j,1) = round(S_values*(input_states_sequence(j,1)/S_max));
    output_stetes_sequence(j,2) = round(S_values*(input_states_sequence(j,2)/S_max));
    output_stetes_sequence(j,3) = round(N_values*(input_states_sequence(j,3)/N_max));
    output_stetes_sequence(j,4) = round(N_values*(input_states_sequence(j,4)/N_max));
    
end

