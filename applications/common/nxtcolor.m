function [color,data_num]= nxtcolor
%NXTCOLOR - Return the next color (string) to be used in a plot
%  [color,data_num]= nxtcolor
%  color = next color to plot
%  data_num = number of lines on plot
%  SMB 25-FEB-1998 Bren@slac.stanford.edu

colors = get(gca,'colororder');
data_num = length(findobj(gca,'Type','line'));
color = colors(rem(data_num,size(colors,1))+1,:);