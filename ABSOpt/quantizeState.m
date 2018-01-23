function [ state ] = quantizeState( rawState )
%FIND_STATE Summary of this function goes here
%   Detailed explanation goes here
%compute the quantized state

%rawState -> SMacro throughput macro
%rawState -> SMicro Average throughput micros
%rawState -> nUEMacro number of active UE connected to macro
%rawState -> nUEMicro average number of active UE connected to micros
%rawState -> ABSRate number of abs frame over the total number of frames

quantizedSMacro = quantizeThroughput(rawState.SMacro);
quantizedSMicro  = quantizeThroughput(rawState.SMicro);

state = [quantizedSMacro quantizedSMicro rawState.nUEMacro rawState.nUEMicro rawState.ABSRate];


end

