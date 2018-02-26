%Parameters
NUMBER_OF_FILES = 40;
S_ratio_values = 5;
N_ratio_values = 4;
alpha = 0.4;
discount_factor = 0.9;
T = 0.8;
%initialize q matrices 
q=initialize(S_ratio_values,N_ratio_values);

states={};
actions={};
rewards={};
S_ratio_max = 0;
N_ratio_max = 0;

for iFile = 1:NUMBER_OF_FILES
    
    %Load ABSMetrics from file number iFile
    file_name = strcat('DATA/ABSState',num2str(iFile),'.mat');
    load(file_name);
    [states{iFile},actions{iFile},rewards{iFile}]=initializeSequences(ABSMetrics);
    
    %evaluate maximum values
    for j = 1:size(states{iFile},1)
   
        if states{iFile}(j,1) > S_ratio_max
        S_ratio_max = states{iFile}(j,1);
        end

        if states{iFile}(j,2) > N_ratio_max
            N_ratio_max = states{iFile}(j,2);
        end
    
    end
end

S_ratio_max = T*S_ratio_max;
N_ratio_max = T*N_ratio_max;

for index = 1:NUMBER_OF_FILES
    
     states{index} = normalize_states(states{index},S_ratio_values,N_ratio_values,S_ratio_max,N_ratio_max);

     %Update q values 
     q = updateQ(q, alpha, discount_factor, states{index}, actions{index}, rewards{index});
end


policy = computePolicy(q);
save("ABSOpt/q/qPolicy.mat", "policy", "N_ratio_max", "S_ratio_max", "T");