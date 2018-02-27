%%---------------
%%Q SCENARIO
%%---------------

%loading utilLow
wBQ = load('wBQ.mat');

%getting s from UtilLow
Qs= wBQ.SimulationMetrics.throughput;
QnUE = wBQ.SimulationMetrics.activeUsers;
BerQ = wBQ.SimulationMetrics.ber;

%summing s per frame
throughputUser = zeros(100, 15);

%compute total throuput per user in a frame
for i = 1:100
    currentFrame = Qs((i-1)*10 + 1: (i*10),:);
    throughputUser(i,:) = sum(currentFrame, 1);
end

throughputQ = sum(throughputUser, 2) / 15;

%%---------------
%%STATIC SCENARIO
%%---------------

wBS = load('wBS.mat');
Ss=wBS.SimulationMetrics.throughput;
BerS = wBS.SimulationMetrics.ber;
%summing s per frame
%throughputS = sum(Ss, 2);

%summing s per frame
throughputUser = zeros(100, 15);

%compute total throuput per user in a frame
for i = 1:100
    currentFrame = Ss((i-1)*10 + 1: (i*10),:);
    throughputUser(i,:) = sum(currentFrame, 1);
end

throughputS = sum(throughputUser, 2) / 15;

%%---------------
%%RANDOM SCENARIO
%%---------------

wBR = load('wBR.mat');
Rs=wBR.SimulationMetrics.throughput;
BerR = wBR.SimulationMetrics.ber;
%summing s per frame
%throughputR = sum(Rs, 2);


%summing s per frame
throughputUser = zeros(100, 15);

%compute total throuput per user in a frame
for i = 1:100
    currentFrame = Rs((i-1)*10 + 1: (i*10),:);
    throughputUser(i,:) = sum(currentFrame, 1);
end

throughputR = sum(throughputUser, 2) / 15;

%plotting
hold all
plot(1:100, throughputQ, 'b');
plot(1:100, throughputS, 'g');
plot(1:100, throughputR, 'r');
%plot(1:1000, throughputQ)
