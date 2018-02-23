S_ratio_max = 5;
N_ratio_max = 4;

q=initialize(S_ratio_max,N_ratio_max);
[states,actions,rewards]=initializeSequences(ABSMetrics);
states = normalize_states(states,S_ratio_max,N_ratio_max);


q = updateQ(q, 0.4, 0.4, states, actions , rewards)