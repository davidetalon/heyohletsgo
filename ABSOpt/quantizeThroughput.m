function [ qThroughput ] = quantizeThroughput( rawS, nLevels )
%QUANTIZETHROUGHPUT Summary of this function goes here
%
% Get the quantize throughput given the raw one using uniform quantizer with nLevels levels.
%
%rawS          raw throughput
%nLevels       number of quantization levels 
%quantizedS    quantized throughput

    qThresholds = zeros(1, nLevels - 1);
    for i = 1:nLevels - 1
        qThresholds(i) = (1/nLevels) * i;
    end

    qThroughput = qThreshold(find(qTresholds > rawS, 1) - 1) + 1/(2*nLevevels);

end