function plotquad
%PLOTQUAD - Plots the setpoint and monitor for all the quadrupole families (MemberOf 'QUAD') 
%
%  See also plotmemberof


h = plotmemberof('QUAD');

axes(h(1));
title('Quadrupole Families');

