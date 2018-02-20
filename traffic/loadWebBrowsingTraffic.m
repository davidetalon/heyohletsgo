function [trSource] = loadWebBrowsingTraffic (totSimTime, numUsers)

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
  
  
  
  %generate a different traffic model for each user
  for iUser = 1:numUsers  
      
      %initialize sizes and times
      times = 0;
      sizes = pckSizes(1+sum(rand>CumProbSum));
      
      i = 1;
      while times(i) <= totSimTime

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
        times = [times (times(i) + interTime)];

        sizes = [sizes pckSize];
        i = i + 1;
      end
  
      trSource{1, iUser} = times;
      trSource{2, iUser} = sizes;
  end

  % Sort using the time column if it has to be shuffled (e.g. interleaved source)
  % first column is timestamp
  %if (sort);
   % trSource = sortrows(trSource, 1);
  %end

  % Save to MAT file for faster access next round
  path='traffic/webBrowsing.mat';
  save(path, 'trSource');
end
