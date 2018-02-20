function [q_values] = initialize(S_macro_max,S_micro_max, N_macro_max, N_micro_max)

N_abs = 10;
N_actions = 3;

q_values = zeros(S_macro_max,S_micro_max, N_macro_max, N_micro_max, N_abs, N_actions);

end

