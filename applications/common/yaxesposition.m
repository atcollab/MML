function yaxesposition(PercentChange, h)
%YAXESPOSITION - Vertical axes scaling for all the axes in a figure
% 
%  INPUTS
%  1. PercentChange - Percentage for scaling (1 means no change) 
%
%  See also yaxes

%  Written by Greg Portmann


if nargin < 2
    h = get(gcf,'children');
end

% set(gcf, 'Units', get(0, 'Units'));
% Pfig = get(gcf, 'Position');
% set(gcf, 'Position', get(0, 'ScreenSize'));
    

% Due to axis being linked, check if someone else changes it first
for i = 1:length(h)
    hget = get(h(i));
    if isfield(hget, 'Position') && ~strcmpi(hget.Tag, 'Legend')
        pstart(i,:) = get(h(i), 'Position');
    else
        pstart(i,:) = [NaN NaN NaN NaN];
    end
end


for i = 1:length(h)
    hget = get(h(i));
    if isfield(hget, 'Position') && ~strcmpi(hget.Tag, 'Legend')
        p = get(h(i), 'Position');
        if all(p==pstart(i,:))
            if PercentChange > 1
                Percent = PercentChange - 1;
                set(h(i), 'Position', [p(1) p(2)-p(4)*Percent/2 p(3) p(4)+p(4)*Percent]);
                %set(h(i), 'Position', [p(1) p(2)-p(4)*Percent/2 p(3) p(4)+p(4)*Percent*1.05]);  % 1.05 is a cluge
            else
                Percent = 1 - PercentChange;
                set(h(i), 'Position', [p(1) p(2)+p(4)*Percent/2 p(3) p(4)-p(4)*Percent]);
                %set(h(i), 'Position', [p(1) p(2)+p(4)*Percent/2 p(3) p(4)-p(4)*Percent*0.95]);  % 0.95 is a cluge
            end
        end
    end
end

%set(gcf,'Position', Pfig);