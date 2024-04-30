function brho = getbrho(varargin)
%GETBRHO - Calculations of the beam rigidity
%  brho = getbrho(Energy)
%
%  INPUTS
%  1. energy - optional parameter
%     Calculation of the beam parameters with given energy
%     v, p, and the magnetic rigidity, normalised emittance.
%     Energy is in GeV or can be replaced with strings:
%     'Production'         - Energy of the production lattice
%     'Injection'          - Energy of the injection lattice
%     'Model' or Simulator - Energy based on the model bend magnet (bend2gev('Model'))
%     'Online'             - Energy based on the online bend magnet (bend2gev('Online'))
%     'Present'            - Energy based on the present bend magnet mode (bend2gev)   {Default}
%
%  OUTPUTS
%  1. Calculation of the beam parameters with given energy
%     v,p, and the magnetic rigidity, normalized emittance.
%     (energy is in GeV)
%
%  See also getbrhoinv, getenergy, getmcf

%  Written by James Safranek, Moohyun Yoon, Greg Portmann
%  Modified by Laurent S. Nadolski (09/02/06 exact computation using kinetic energy correction)
%  2024apr30 oblanco, use total energy from AT. https://github.com/atcollab/at/discussions/671


Energy = [];

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Production')
        Energy = getfamilydata('Energy');
    elseif strcmpi(varargin{i},'Injection')
        Energy = getfamilydata('InjectionEnergy');
    elseif strcmpi(varargin{i},'Present')
        Energy = bend2gev;
    elseif strcmpi(varargin{i},'Model') || strcmpi(varargin{i},'Simulator')
        Energy = bend2gev('Model');
    elseif strcmpi(varargin{i},'Online')
        Energy = bend2gev('Online');
    end
end

if length(varargin) >= 1
    if isnumeric(varargin{1})
        Energy = varargin{1};
    end
end

if isempty(Energy)
    Energy = getenergy;
end

lightspeed = PhysConstant.speed_of_light_in_vacuum.value;
emassGeV = PhysConstant.electron_mass_energy_equivalent_in_MeV.value*1e-3;
% Exact formula is mandatory for low energy like in transfer lines
brho = (1e9/lightspeed) * sqrt(Energy.^2 - emassGeV.^2);
