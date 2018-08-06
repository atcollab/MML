function numFields = fieldcount(MLObj)
% Determines the number of fields in an middle layer object
% Used by child class methods
%
%  Written by Greg Portmann

numFields = length(fieldnames(MLObj));
