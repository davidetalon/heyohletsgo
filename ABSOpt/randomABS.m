function [ change ] = randomABS()
%RANDOMABS Summary of this function goes here
%   decrease/hold/increase the number of ABS with uniform probability

increase = [-1 0 1];
change = increase(randi(3));

end

