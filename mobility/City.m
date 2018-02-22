classdef City
    
    properties
        Horizontal_streets;
        Vertical_streets; 
        Buildings;
        Track_width;
        Sidewalk_width;
        Horizontal_sidewalks;
        Vertical_sidewalks;
        Horizontal_size;
        Vertical_size;
    end
    
    methods
        
        
        function obj = City(h_size, v_size, h_streets_number, v_streets_number,min_interstreet_space, seed)
            
            rng(seed);
            
            track_width = 5;       %width of a single track in meters
            sidewalk_width = 3;    %width of a single sidewalk in meters
            
            obj.Track_width = track_width;
            obj.Sidewalk_width = sidewalk_width;
            obj.Horizontal_size = h_size;
            obj.Vertical_size = v_size;
            %in every street there are 2 sidewalks and a number between 2
            %and max_track_number*2 tracks
            
            street_width = 2*track_width + 2*sidewalk_width;
            
            if(h_streets_number * street_width + min_interstreet_space*(h_streets_number-1) > h_size ...
                    || v_streets_number * street_width + min_interstreet_space*(h_streets_number-1) > v_size)
                sonohilog('City size too small for streets','ERR');
                return;
            end
            
            slot_size = street_width+min_interstreet_space;
            
            h_slots = floor(h_size/slot_size);
            v_slots = floor(v_size/slot_size);
            
            h_streets_slots = sort(randperm(h_slots,h_streets_number));
            v_streets_slots = sort(randperm(v_slots,v_streets_number));
                   
            obj.Horizontal_streets = zeros(h_streets_number,1); 
            obj.Vertical_streets = zeros(v_streets_number,1);
            obj.Buildings = zeros((h_streets_number+1)*(v_streets_number+1),4);
            
            for j=1:h_streets_number
                obj.Horizontal_streets(j,1) = (h_streets_slots(j)-0.5)*slot_size;
            end
            
            for j=1:v_streets_number
                obj.Vertical_streets(j,1) = (v_streets_slots(j)-0.5)*slot_size;
            end
            
            for j=1:h_streets_number+1
                for i=1:v_streets_number+1
                    x1 = 0;
                    y1 = 0;
                    x2 = 0;
                    y2 = 0;
                    
                    if(j>1)
                        y1 = obj.Horizontal_streets(j-1) + track_width + sidewalk_width;
                    end
                    
                    if(i>1)
                        x1 = obj.Vertical_streets(i-1) + track_width + sidewalk_width;
                    end
                    
                    if(j<=h_streets_number)
                        y2 =  obj.Horizontal_streets(j) - track_width - sidewalk_width;
                    else
                        y2 = v_size;
                    end
                    
                    if(i<=v_streets_number)
                        x2 =  obj.Vertical_streets(i) - track_width - sidewalk_width;
                    else
                        x2 = h_size;
                    end
                    
                    obj.Buildings(j +(i-1)*(h_streets_number+1),1) = x1;
                    obj.Buildings(j +(i-1)*(h_streets_number+1),2) = y1;
                    obj.Buildings(j +(i-1)*(h_streets_number+1),3) = x2;
                    obj.Buildings(j +(i-1)*(h_streets_number+1),4) = y2;
                end
            end
            
            obj.Horizontal_sidewalks = zeros(size(obj.Horizontal_streets,1)*2,1);
            k = 1;
            for i=1:size(obj.Horizontal_streets,1)
                obj.Horizontal_sidewalks(k)= obj.Horizontal_streets(i)-track_width - 0.5*sidewalk_width;
                obj.Horizontal_sidewalks(k+1)= obj.Horizontal_streets(i)+track_width + 0.5*sidewalk_width;
                k = k+2;
            end
            
            obj.Vertical_sidewalks = zeros(size(obj.Vertical_streets,1)*2,1);
            k = 1;
            for i=1:size(obj.Vertical_streets,1)
                obj.Vertical_sidewalks(k)= obj.Vertical_streets(i)-track_width - 0.5*sidewalk_width;
                obj.Vertical_sidewalks(k+1)= obj.Vertical_streets(i)+track_width + 0.5*sidewalk_width;
                k = k+2;
            end
            
            
            
            
            
        end
        
    end
end

