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
%  2024apr30 oblanco, use total energy from AT. https://github.com/atcollab/at/discussions/671

if nargin == 0
    error('Brho input needed.');
end

emassGeV = PhysConstant.electron_mass_energy_equivalent_in_MeV.value*1e-3;
lightspeed = PhysConstant.speed_of_light_in_vacuum.value;
e = sqrt(emassGeV.^2 + (brho * lightspeed*1e-9).^2);
