function [Kx, Ky, Kq] = bpm_getgain(Prefix)

% Comes from a where for the different geometrys????

% Arc BPM gain factors on a curved section Bergoz card are X: 0.1613 V/% and Y: 0.1629 V/%
%Kx = 16.13;
%Ky = 16.29;

Kx = 16;
Ky = 16;
Kq = 10;  % as of 2014/11/4 (was 1 previously)


if nargin < 1 || isempty(Prefix)
    Prefix = getfamilydata('BPM','BaseName');
end

if ischar(Prefix)
elseif iscell(Prefix)
    Kx = Kx * ones(length(Prefix),1);
    Ky = Ky * ones(length(Prefix),1);
    Ky = Ky * ones(length(Prefix),1);
else
    % DeviceList input
    Kx = Kx * ones(size(Prefix,1),1);
    Ky = Ky * ones(size(Prefix,1),1);
    Ky = Ky * ones(size(Prefix,1),1);
end