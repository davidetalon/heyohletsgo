function [ x, y, obj ] = city_mobility (obj ,timestep, number_rounds, city)

% Set base seed
rng(obj.Seed);

number_of_steps = ceil(number_rounds*0.001/timestep);

x = zeros(number_of_steps,1);
y = zeros(number_of_steps,1);
v_streets_number = size(city.Vertical_streets,1);
h_streets_number = size(city.Horizontal_streets,1);

user_type = 1; %randi(2); %1 = on foot, 2 in a good car
user_speed = 0;
user_direction = randi(4); %-1 = north, 1 = south, -2 = west, 2 = east
if(user_direction == 4)
    user_direction = -2;
elseif(user_direction ==3)
    user_direction = -1;
end

switch user_type
    case 1
        user_speed = 70;
        obj.Velocity = user_speed;
        x(1) = city.Vertical_sidewalks(randi(v_streets_number*2));
        y(1) = city.Horizontal_sidewalks(randi(h_streets_number*2));
        
        for j = 2:number_of_steps
            
            if(mod(abs(user_direction),2)==1) 
                y(j) = y(j-1) + user_direction*user_speed*timestep;
                x(j) = x(j-1);
                
                if(y(j)> city.Vertical_size)
                    user_direction = -user_direction;
                    y(j) = 2* city.Vertical_size - y(j);
                elseif(y(j)<0)
                    user_direction = -user_direction;
                     y(j) = abs(y(j));
                else
                    for i = 1: size(city.Horizontal_sidewalks,1)
                        if (y(j-1)<city.Horizontal_sidewalks(i) && y(j)>city.Horizontal_sidewalks(i))||...
                                (y(j-1)>city.Horizontal_sidewalks(i) && y(j)<city.Horizontal_sidewalks(i))
                        
                            choice = randi(13);
                            difference = abs(y(j)-city.Horizontal_sidewalks(i));
                            if(choice<=3)
                                user_direction = 2;
                                y(j) = city.Horizontal_sidewalks(i);
                                x(j) = x(j) + difference;
                            elseif(choice<=5)
                                user_direction = -2;
                                y(j) = city.Horizontal_sidewalks(i);
                                x(j) = x(j) - difference;
                            end
                        end
                    end
                end
               
            else
                
                x(j) = x(j-1) + 0.5 * user_direction*user_speed*timestep;
                y(j) = y(j-1);  
                
                if(x(j)> city.Horizontal_size)
                    user_direction = -user_direction;
                    x(j) = 2* city.Horizontal_size - x(j);
                elseif(x(j)<0)
                    user_direction = -user_direction;
                     x(j) = abs(x(j));
                else
                    for i = 1: size(city.Vertical_sidewalks,1)
                        if (x(j-1)<city.Vertical_sidewalks(i) && x(j)>city.Vertical_sidewalks(i))||...
                                (x(j-1)>city.Vertical_sidewalks(i) && x(j)<city.Vertical_sidewalks(i))
                        
                            choice = randi(13);
                            difference = abs(x(j)-city.Vertical_sidewalks(i));
                            if(choice<=3)
                                user_direction = 1;
                                x(j) = city.Vertical_sidewalks(i);
                                y(j) = y(j) + difference;
                            elseif(choice<=5)
                                user_direction = -1;
                                x(j) = city.Vertical_sidewalks(i);
                                y(j) = y(j) - difference;
                            end
                        end
                    end
                end
            end
         end
            
end

end





