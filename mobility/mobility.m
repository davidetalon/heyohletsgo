function [ obj ] = mobility( obj, Param)


switch Param.mobilityScenario
    case 'pedestrian'
        obj.Velocity = 15; % in m/s
        [x, y] = traffic_mobility(1, obj.Velocity, obj.Seed, Param.mobilityStep);
    case 'vehicular'
        obj.Velocity = 10; % in m/s
        [x, y] = traffic_mobility(2, obj.Velocity, obj.Seed, Param.mobilityStep);
    case 'static'
        obj.Velocity = 0; % in m/s
        [x, y] = traffic_mobility(1, obj.Velocity, obj.Seed, Param.mobilityStep);
    case 'superman'
        obj.Velocity = 100; % in m/s
        [x, y] = traffic_mobility(1, obj.Velocity, obj.Seed, Param.mobilityStep);
    case 'straight'
        obj.Velocity = 10 / 12; % in m/s
        [x, y] = straight_mobility( obj.Velocity, obj.Seed, Param );
    case 'city'
        [x, y, obj] = city_mobility(obj, Param.mobilityStep,Param.schRounds, Param.city);
        x = x';
        y = y';
    otherwise
        sonohilog('Unknown mobility scenario selected','ERR');
        return;
end


obj.Trajectory = [x',y'];
obj.Position = [obj.Trajectory(1, 1) obj.Trajectory(1, 2) Param.ueHeight];

% Plot UE position and trajectory in scenario
if Param.draw
    plotUEinScenario(obj, Param);
end

end
