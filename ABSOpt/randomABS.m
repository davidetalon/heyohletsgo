function [ change , nABS] = randomABS(nABS)
%RANDOMABS Summary of this function goes here
%   decrease/hold/increase the number of ABS with uniform probability

increase = [-2 0 2];

%nABS must be positive and not lower or equals the total number of
        %subFrames
        if (nABS <= 0) 
            change = increase(randi(2) + 1);
            nABS = nABS + change;
        elseif (nABS >= 10)
            change = increase(randi(2));
            nABS = nABS + change;
        else
            change = increase(randi(3));
            nABS = futureNABS;
        end
end

