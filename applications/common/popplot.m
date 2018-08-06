function popplot(hfig, a, b, c)
%POPPLOT - Pops the current axes into a separate figure
%  popplot(hfig, s1, s2, s3)
%
%  INPUTS
%  1. hfig = figure handle to draw plot  {Default: new figure} 
%  2. s1, s2, s3 - same inputs as used by subplot  {Default: 1,1,1}
%
%  Written by Greg Portmann

%fprintf('   Mouse click on a graph to pop it\n');
%ginput(1);


haxes = gca;

if nargin < 1
    hfig = figure;
else
    figure(hfig);
end


% Find axes location 
if nargin < 4
    p = [0.13 0.11 0.775 0.815]; 
else
    h = subplot(a,b,c); 
    p = get(h, 'Position');
    delete(h);
end

try
    b = copyobj(haxes, hfig); 
    set(b, 'Position', p);
catch
    error('Either the figure or axes handle is invalid');
end


% Turn the axis on
set(gca,'XTickLabelmode','auto');
set(gca,'YTickLabelmode','auto');


% subplot(2,1,1)
%set(b, 'Position', [0.1300    0.5811    0.7750    0.3439]);

% subplot(2,1,2)
%set(b, 'Position', [0.1300    0.1100    0.7750    0.3439]);

%orient portrait
