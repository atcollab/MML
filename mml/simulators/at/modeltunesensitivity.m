function [DKx DKz]=modeltunesensitivity(varargin)
%TUNESENSITIVITY - Computes quadrupole change for a given dnu
%
%  INPUTS 
%  1. dnux - horizontal tune change
%  2. dnuz - vertical tune change
%
%  OUTPUTS
%  1. DKx - gradient change to get dnux
%  2. DKz - gradient change to get dnuz

%  Written by Laurent S. Nadolski

if isempty(varargin)
    dnux = 1e-2;
    dnuz = 1e-2;
elseif nvargin == 1
    dnuz = dnuz;
end

fprintf('Quadrupole change for dnux of %f and dnuz = %f \n',dnux,dnuz);

a = findmemberof('QUAD');

for k = 1:10

    Family = a{k};

    [betax betaz]= modeltwiss('beta',Family);
    bx = (betax(1)+betax(2))/2;
    bz = (betaz(1)+betaz(2))/2;

    L = getleff(Family);
    NQ = length(getspos(Family));

    DKx(k) = 4*pi*dnux/bx/NQ/L(1);
    DKz(k) = 4*pi*dnuz/bz/NQ/L(1);

    fprintf('%s : DKx = %1.2e DKz = %1.2e betax = %2.2f m betaz = %2.2f m  NQ = %2.0f  L= %1.2f m \n', ...
        Family, DKx(k), DKz(k), bx, bz, NQ, L(1));
end


