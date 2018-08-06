function ErrorFlag = setam(Family, varargin)
%SETAM - Makes an absolute change to the 'Monitor' field
%
%  See setsp for the details on how to use this function.  Setting the
%  'Monitor' field is a odd thing to do but sometimes it's needed.
%
%  See also getam, getsp, setsp, getpv, setpv

%  Written by G. Portmann


if nargin < 2
    error('Must have at least 2 inputs (Family or Channel Name and newSP).');
end

[ErrorFlag] = setpv(Family, 'Monitor', varargin{:});


