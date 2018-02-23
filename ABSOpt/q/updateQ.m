function [new_estimate_q] = updateQ(old_estimate_q, alpha, discount_factor, states_sequence, actions_sequence, rewards_sequence)

new_estimate_q = old_estimate_q;

for j = 1:size(states_sequence,1)-1
    
    state = states_sequence(j,:);
    next_state = states_sequence(j+1,:);
    action = actions_sequence(j);
    reward = rewards_sequence(j);
    
    updateFactor =  reward + discount_factor*max(new_estimate_q(next_state(1),next_state(2),next_state(3),:))- new_estimate_q(state(1),state(2),state(3),action);
    new_estimate_q(state(1),state(2),state(3),action) =  new_estimate_q(state(1),state(2),state(3),action) + alpha*updateFactor;
end
end

