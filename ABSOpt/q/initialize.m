function [q_values] = initialize(S_ratio_max, N_ratio_max)

N_abs = 6; 
N_actions = 3;

q_values = zeros(S_ratio_max, N_ratio_max, N_abs, N_actions);

end

