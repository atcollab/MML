function [varargout] = getblnames
%================================================
% *** initialize photon beamline names ***
%================================================

family='BLOpen';   %...note: all beamline families contain 'common' field
[index,AO]=isfamily(family);

bl(1).name=getfamilydata('BLOpen','CommonNames');
bl(2).name=getfamilydata('BLOpen','CommonNames');

varargout{1}=bl;


