function [trSource] = loadWebBrowsingTraffic (nPackets)

%   LOAD WEB BROWSING TRAFFIC is used to get data in terms of 
%   packet size and request time.
%   
%   Requests time are sampled from a poisson random variable with mean
%   lambda. Lambda is sampled from a Gaussian rv.
%   Packets have a fixed lenght which probabilities are the inverse of the length
%   itself.
%
%   Function fingerprint
%   nPackets  -> number of packets generated
%
%   trSource   ->  matrix with frameSizes

  %packet sizes [Kb]
  pckSizes = [10 25 50 75 100 250 500 750 1000 2500 5000 7500]*10^3;
  
  %packet sizes with linearly decreasing probabilities
  pckProb = 1:size(pckSizes,2);
  pckProb = fliplr(pckProb);
  pckProb = pckProb ./sum(pckProb);
  
  %getting comulative probability
  CumProbSum = cumsum(pckProb);
  
  
  %gaussian parameters
  mu = 10;
  sigma = 5;
  
  times = zeros(1, nPackets);
  sizes = zeros(1, nPackets);
  for (i = 1:nPackets)
      
    %sampling packet size
    pckSize = pckSizes(1+sum(rand>CumProbSum));
    
    %avoiding Nan
    interTime = nan;
    while isnan(interTime)
      
      %sampling arrival rate mean
      lambda = normrnd(mu, sigma);
      
      %exponential interarrival times
      interTime = exprnd(1/lambda);
    end
    
    %getting absolute arrival time
    if (i == 1)
      %the first request is at time t=0
      times(i) = 0;
    else
      times(i) = times(i-1) + interTime;
    end
      
    sizes(i) = pckSize;
    
  end

  timesCell = num2cell(times');
  sizeCell = num2cell(sizes');
  
  % Fill in output data cell
  data.time = cell2mat(timesCell);
  data.size = cell2mat(sizeCell);
  % reshape to cell array TODO check this step
  dataCell = struct2cell(data);
  dataSize = size(dataCell);
  dataCell = reshape(dataCell, dataSize(1), []);
  trSource = cell2mat(dataCell');

  % Sort using the time column if it has to be shuffled (e.g. interleaved source)
  % first column is timestamp
  %if (sort);
   % trSource = sortrows(trSource, 1);
  %end

  % Save to MAT file for faster access next round
  path='traffic/webBrowsing.mat';
  save(path, 'trSource');
end
