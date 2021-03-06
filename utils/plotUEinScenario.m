function plotUEinScenario(ue, Param)

%   PLOT UE IN SCENARIO is used to plot the UE position and their trajectory
%
%   Function fingerprint
%
%   ue			-> UE object
%   Param		-> simulation parameters
%

	x0 = ue.Position(1);
	y0 = ue.Position(2);

	% UE in initial position
	plot(x0, y0, ...
			'Marker', ue.PlotStyle.marker, ...
			'MarkerFaceColor', ue.PlotStyle.colour, ...
			'MarkerEdgeColor', ue.PlotStyle.edgeColour, ...
			'MarkerSize',  ue.PlotStyle.markerSize, ...
			'DisplayName', strcat('UE ', num2str(ue.NCellID)));

	% Trajectory
	plot(ue.Trajectory(:,1), ue.Trajectory(:,2), ...
			'Color', ue.PlotStyle.colour, ...
			'LineStyle', '--', ...
			'LineWidth', ue.PlotStyle.lineWidth,...
			'DisplayName', strcat('UE ', num2str(ue.NCellID), ' trajectory'));
end
