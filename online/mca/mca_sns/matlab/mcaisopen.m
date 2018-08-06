function h = mcaisopen(PVNAMESTRING);
%MCAISOPEN    - Check if a channel to a PV is open with MCAOPEN
%
%   H = MCAISOPEN(PVNAMESTRING) returns an integer handle if open
%   and 0 otherwise.  If more than one channel is open to the 
%   same PV, an array of handles is returned.
%
%   See also MCAINFO MCASTATE

if ~ischar(PVNAMESTRING)
    error('Argument must be a string')
end

[handles, names] = mcaopen;
matchfound = find(strcmp(PVNAMESTRING,names));
if isempty(matchfound)
    h = 0;
else
    h = handles(matchfound);
end;
