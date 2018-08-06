function [a, h] = mousebox(varargin) 
%MOUSEBOX - Selects a box on a plot
%  [AxisBox, h] = mousebox
%
%  INPUTS
%  1. 'Drawbox' - draws a box around the selected area {Default}
%     'NoDrawbox' - don't draw a box around the selected area
%  2. 'Rescale' - Rescale the axis to the selected area
%     'NoRescale' - Don't rescale the axis to the selected area {Default}
%
%  OUTPUTS
%  1. AxisBox - Coordinates of the selected box (as used by axis)
%  2. h - handle to the box plot (if there is one)
% 

%  Written by Greg Portmann


% Defaults
DrawboxFlag = 1;
ChangeAxisFlag = 0;


% Look for keywords
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif ischar(varargin{i})
        if strcmpi(varargin{i},'Drawbox')
            DrawboxFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'NoDrawbox')
            DrawboxFlag = 0;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Rescale')
            ChangeAxisFlag = 1;
            varargin(i) = [];
        end
    end
end


hAxes = gca;

k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    % button down detected
finalRect = rbbox;                   % return figure units
point2 = get(gca,'CurrentPoint');    % button up detected
point1 = point1(1,1:2);              % extract x and y
point2 = point2(1,1:2);
pp1 = min(point1,point2);            % calculate locations
pp2 = max(point1,point2);            % calculate locations
offset = abs(point1-point2);         % and dimensions
xx = [pp1(1) pp1(1)+offset(1) pp1(1)+offset(1) pp1(1) pp1(1)];
yy = [pp1(2) pp1(2) pp1(2)+offset(2) pp1(2)+offset(2) pp1(2)];

a = [pp1(1) pp2(1) pp1(2) pp2(2)];


if DrawboxFlag
    % Draw a box

    % Remember the hold state then turn hold on
    HoldState = ishold(hAxes);
    hold(hAxes, 'on');

    h = plot(xx, yy);

    % Remember the hold state then turn hold on
    HoldState = ishold(hAxes);
    hold(hAxes, 'on');
else
    h = [];
end

    
if ChangeAxisFlag
    axis(a);
end
