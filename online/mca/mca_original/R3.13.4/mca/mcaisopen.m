function h = mcaisopen(PVNAMESTRING);
%MCAISOPEN Check if a cahannel to a PV was previously open with MCAOPEN
%   H = MCAISOPEN(PVNAMESTRING) returns an integer handle if open
%   and 0 otherwise. If more than one channel is open to the
%   same PV - an array of handles is returned.
% See also MCAINFO MCASTATE

if ~ischar(PVNAMESTRING)
    error('Argument must ba a string')
end

matchfound = find(strcmp(PVNAMESTRING,mcaopen));

if isempty(matchfound)
    h = 0;
else 
    h = matchfound;
end;  
