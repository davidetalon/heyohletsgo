function [output_stetes_sequence] = normalize_states(input_states_sequence, S_values,N_values, S_ratio_max,N_ratio_max)

output_stetes_sequence = input_states_sequence;

for j = 1:size(input_states_sequence,1)
   
    output_stetes_sequence(j,1) = round((S_values-1)*(input_states_sequence(j,1)/S_ratio_max))+1;
    output_stetes_sequence(j,2) = round((N_values-1)*(input_states_sequence(j,2)/N_ratio_max))+1;
    output_stetes_sequence(j,3) = input_states_sequence(j,3)/2 + 1;
end

