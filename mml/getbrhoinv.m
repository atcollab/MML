function e = getbrhoinv(brho)
%GETBRHOINV - Calculates the energy for a given beam rigidity
%  Energy = getbrhoinv(brho)
%
%  INPUTS
%  1. brho - Beam rigidity
%
%  OUTPUTS
%  1. Energy [GeV]
%
%  See also getbrho, getenergy, getmcf

%  Written by James Safranek, Moohyun Yoon, Greg Portmann
%  Modified by Laurent S. Nadolski (09/02/06 exact computation using kinetic energy correction)


if nargin == 0
    error('Brho input needed.');
end

E0 = .51099906e-3;    % Electron rest mass in GeV
% WARNING AT and other tracking code give kinetic energy and not total energy
e = sqrt(E0^2 + (.299792458 * brho).^2) - E0;        % Laurants total energy
%e = sqrt(E0^2 + (.299792458 * brho).^2);            % Old code


