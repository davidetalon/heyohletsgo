
% ---------------------
	% ABS CHOICE
	% ---------------------
    Param.ABSOptimization = 'random';
    nABS = 4;
    for iRound = 0:1000
        if (mod(iRound, 10)==0)
            %generating Station's masks with dynamic ABS rate
            %choose the ABS optimization policy
            switch Param.ABSOptimization
                case 'random'
                     increase = [-2 0 2];
                
                %nABS must be positive and not lower or equals the total number of
                %subFrames
                if (nABS <= 0) 
                    change = increase(ceil(rand * 2) + 1);
                    nABS = nABS + change;
                elseif (nABS >= 10)
                    change = increase(ceil(rand * 2));
                    nABS = nABS + change;
                else
                    change = increase(ceil(rand * 3));
                    nABS = nABS + change;
                end
                
                case 'QLearning'
                    [nABS, change] = qLearningABS(nABS);
                case 'static'
                    change = 0;
            end
        end
        
        collectio(iRound +1, 1) = nABS;
        collectio(iRound +1, 2) = change;
    end