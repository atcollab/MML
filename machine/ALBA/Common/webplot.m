function webplot( min_order, max_order, window, period )
% plots the diagram resonance in top of the current figure
% Inputs:
% min_order
% max_order
% window [qxmin qxmax qymin qymax]
% period 
hold on
for i=max_order:-1:min_order,
    [k, tab] = reson(i,period,window);
end
axis(window);
%WEBPLOT1 Summary of this function goes here
%   Detailed explanation goes here
