%Parameters
SEQUENCE_LENGTH = 100000;
S_ratio_values = 5;
N_ratio_values = 4;
ABS_values = 6;
alpha = 1;
discount_factor = 0.4;

%initialize q matrices
q=initialize(S_ratio_values,N_ratio_values);

states=zeros(SEQUENCE_LENGTH,3);

for i=1:SEQUENCE_LENGTH
    states(i,1) = randi(S_ratio_values);
    states(i,2) = randi(N_ratio_values);
    states(i,3) = randi(ABS_values);
end

actions=zeros(SEQUENCE_LENGTH-1,1);

for i=1:SEQUENCE_LENGTH-1
    actions(i) = randi(3);
end

rewards=actions;

for i=1:SEQUENCE_LENGTH-1
    if rewards(i) == 2
        rewards(i) = 10;
    else
        rewards(i) = 0;
    end
end

q = updateQ(q, alpha, discount_factor, states, actions, rewards);
