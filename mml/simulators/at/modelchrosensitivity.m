function [DSx DSz] = modelchrosensitivity(varargin)
%TUNESENSITIVITY - Computes sextupole change for a given dxi
%
%  INPUTS 
%  1. dxix - horizontal tune change
%  2. dxiz - vertical tune change
%
%  OUTPUTS
%  1. DSx - sextupole change to get dxix
%  2. DSz - sextupole change to get dxiz
%
%  See Also modeltunesensitivity

%
%  Written by Laurent S. Nadolski

if isempty(varargin)
    dxix = 1e-1;
    dxiz = 1e-1;
elseif nvargin == 1
    dxix = dxiz;
end

fprintf('Sextupole change for dxix of %f and dxiz = %f \n',dxix,dxiz);

% get all sextupoles
a = findmemberof('SEXT');

for k = 1:10

    Family = a{k};

    [bx bz] = modeltwiss('beta',Family);
    [etax etaz] = modeldisp(Family);

    L = getleff(Family);
    NQ = length(getspos(Family));

    DSx(k) =  2*pi*dxix/bx(1)/etax(1)/NQ/L(1);
    DSz(k) = -2*pi*dxiz/bz(1)/etax(1)/NQ/L(1);

    fprintf('%s : DSxL = %1.2e DSzL = %1.2e betax = %2.2f m betaz = %2.2f m etax = %2.2f m NQ = %2.0f  L= %1.2e m \n', ...
        Family, DSx(k)*L(1), DSz(k)*L(1), bx(1), bz(1), etax(1), NQ, L(1));
end
