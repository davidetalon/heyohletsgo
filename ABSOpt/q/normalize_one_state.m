function [state] = normalize_one_state(state, S_values, N_values, S_ratio_max, N_ratio_max)

    if state(1)>= S_ratio_max
        state(1)= S_ratio_max;
    end
    if state(2)>= N_ratio_max
        state(2)= N_ratio_max;
    end
    
    state(1) = round((S_values-1)*(state(1)/S_ratio_max))+1;
    state(2) = round((N_values-1)*(state(2)/N_ratio_max))+1;
    state(3) = state(3)/2 + 1;
end

