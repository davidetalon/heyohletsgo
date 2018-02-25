function [policy] = computePolicy(q)
policy = zeros(size(q,1),size(q,2),size(q,3));

for i1 = 1:size(q,1)
    for i2 = 1:size(q,2)
        for i3 = 1:size(q,3)
            [m,action] = max(q(i1,i2,i3,:));
            if m <= 0
                action = 0;
            end    
            policy(i1,i2,i3) = action; 
        end
    end
end
end

