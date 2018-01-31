function [ ABSMask ] = generateABSMask( nSubFrames, nABS )
%GENERATEABSMASK Summary of this function goes here
%   Given the number of SubFrames and the number of ABS subFrames generate a
%   uniformly distribuited ABS mask.
%  

%initialize the mask to all zeros
ABSMask = zeros(1, nSubFrames);

%compute ideal number of zeros between ones
nSpaces = (nSubFrames-nABS)/(nABS+1);

if (nABS > nSubFrames)
   print 'nABS > NSubFrames not allowed';
end  

currentABS = 1;
pos = 1;
while (currentABS <= nABS)
    
    %compute the number of zeros as the lower integer
    nZeros = floor(nSpaces);
    
    %compute the remainder and sum to the next zeros intervale
    remainder = nSpaces - nZeros;
    nSpaces = (nSubFrames-nABS)/(nABS + 1) + remainder;
    
    %skip the selected number of zeros
    pos = pos + nZeros;
    
    ABSMask(pos) = 1;
    pos = pos + 1;
    currentABS = currentABS + 1;
end


