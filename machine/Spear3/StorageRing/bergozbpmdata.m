function [x, y, total, q2] = bergozbpmdata( bpmData, bpmNumber )
% function [x, y, total, q2] = bergozbpmdata( bpmData, bpmNumber )
% bergozbpmdata returns the x,y,sum, and quad data of bpmNumber
%  from the data in bpmData, which is obtained from the history PV
%  
% bpmData    three dimensional array of data of the bpm
% bpmNumber  ordinal number of the bpm in the array
% x          x position of data
% y          y position of data
% total      sum of bpm button data
% q2         quadrupole term of bpm data

x = squeeze(bpmData(1, bpmNumber, :));
y = squeeze(bpmData(2, bpmNumber, :));
total = squeeze(bpmData(3, bpmNumber, :));
q2 = squeeze(bpmData(4, bpmNumber, :));