function [RFpower, RFamp]= getrfpow
% [RFpower, RFamp]= getrfpow
%
% RFpower = RF amplitude in MV
% RFamp   = RF amplitude set value in ??? units
%

RFpower = getam('SR03S___RFAMP__AM01');
RFamp   = getsp('SR03S___RFAMP__AC01');
