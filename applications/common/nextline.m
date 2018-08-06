function [LineColor, LineStyle, LineNumber] = nextline(LineNumber)
%NEXTLINE - Returns the next line color and type to be used in a plot
%  [LineColor, LineStyle, LineNumber] = nextline(LineNumber)
%  LineColor  - Next color to plot
%  LineStyle  - Next line style
%  LineNumber - Number of lines on plot

%  SMB 25-FEB-1998 Bren@slac.stanford.edu
%  Modified by Greg Portmann

try
    ColorOrder = get(gca,'ColorOrder');
catch
    ColorOrder = get(0,'DefaultAxesColorOrder');
end

StyleOrder = {'-','-.','--',':'};


if nargin == 0
    LineNumber = length(findobj(gca,'Type','line'));
    LineNumber = LineNumber + 1;
end

N_Color = rem(LineNumber-1,size(ColorOrder,1))+1;

N_Style  = ceil(LineNumber / size(ColorOrder,1));
N_Style = rem(N_Style-1,length(StyleOrder))+1;

LineColor = ColorOrder(N_Color,:);
LineStyle = StyleOrder{N_Style};

