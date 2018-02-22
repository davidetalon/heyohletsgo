function [newQueue] = updateTrQueue(trafficModel, src, simTime, User)

%   UPDATE TRAFFIC QUEUE is used to update the struct modelling the trx queue
%
%   Function fingerprint
%   src        ->  traffic source as time and size of packets
%   simTime    ->  simulation time
%   User 	     ->  user object
%
%   newQueue	 ->  updated queue

    switch trafficModel
        case 'webBrowsing'
            newQueue = User.Queue;
            if (User.Queue.Size <= 0 && simTime >= User.Queue.Time)
                newQueue.Size = 0;
                for ix = 1:length(src{1, User.NCellID})
                    if (src{1, User.NCellID}(ix) <= simTime)
                        
                        % increase frame size and update frame delivery deadline
                        newQueue.Size = newQueue.Size + src{2, User.NCellID}(ix);
                        newQueue.Time = src{1, User.NCellID}(ix);
                    else
                        % stamp the packet id of the last loaded pck in the queue and exit
                        newQueue.Pkt = newQueue.Pkt + 1;
                        break;
                    end
                end
            end

        otherwise
            newQueue = User.Queue;
            if (User.Queue.Size <= 0 && simTime >= User.Queue.Time)
                newQueue.Size = 0;
                for (ix = 1:length(src))
                    if (src(ix, 1) <= simTime)
                        % increase frame size and update frame delivery deadline
                        newQueue.Size = newQueue.Size + src(ix, 2);
                        newQueue.Time = src(ix, 1);
                    else
                        % stamp the packet id in the queue and exit
                        newQueue.Pkt = newQueue.Pkt + 1;
                        break;
                    end;
                end;
            end;
        end
end
