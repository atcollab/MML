function [c,b] = addlabel(x, y, DateStr, FontSize)
%ADDLABEL - Adds a label to a figure (arbitrary location)
%  Text_Handle = addlabel(Xpos, Ypos, LabelString, FontSize)
%  Text_Handle = addlabel(Xpos, Ypos, LabelString)
%  Text_Handle = addlabel(LabelString)
%
%  INPUTS
%  1. Xpos = horizontal position normalized units (0-1) {Default: left}
%  2. Ypos = Vertical   position normalized units (0-1) {Default: bottom}
%  3. LabelString = the string added to the figure {Default: the present date}
%  4. FontSize = Font size {Default: 7}
%                use get(Text_Handle, ...) to change other properties
%
%  EXAMPLE
%  1. To add the time and date to the bottom, right side
%     >> addlabel(1, 0, datestr(clock,0));
%
%  NOTES
%  1. To remove latex formating
%     set(Text_Handle, 'Interpret', 'None'); 
%
%  Written by Greg Portmann


if nargin < 1
   x = 0;
   y = 0;
   DateStr = datestr(clock,0);
   FontSize = 7;
elseif nargin == 1
   DateStr = x;
   x = 0;
   y = 0;
   FontSize = 7;
elseif nargin == 2
   DateStr = datestr(clock,0);
   FontSize = 7;
elseif nargin < 4
   FontSize = 7;
end

if ~isstr(DateStr)
  error('Input must be a string')   
end

%a=gca;
Units = get(gcf,'Units');

set(gcf,'Units','Normalized');
d=.015;
b=axes('Parent',gcf,'Units','Normalized','Position',[0+d 0+d 1-2*d 1-2*d]);
axis off
c=text(x,y,DateStr,'Units','Normalized','Position',[x y 0],'FontSize',FontSize,'HorizontalAlignment','left','VerticalAlignment','bottom');

if x < .4
   set(c,'HorizontalAlignment','left');
elseif x < .6
   set(c,'HorizontalAlignment','center');
elseif x > .6
   set(c,'HorizontalAlignment','right');
end
if y > .6
   set(c,'VerticalAlignment','top');
else
   set(c,'VerticalAlignment','bottom');
end

set(gcf,'Units', Units);
%axes(a);

set(b,'HandleVisibility','off');
set(b,'HitTest','off');

