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

% Exact formula is mandatory for low energy like in transfer lines
E0 = .51099906e-3;    % Electron rest mass in GeV
%brho = (10/2.99792458) * sqrt(Energy.^2 - E0.^2);
% WARNING AT and other tracking code give kinetic energy and not total energy
brho = (10/2.99792458) * sqrt((Energy+E0).^2 - E0.^2);


% if nargin == 0
% %     warning('1 input not given (beam energy in GeV): to');    
%     E = getenergy;    
% else
%     E = energy;
% end
% 
% m0 = 9.1093897e-31 ;
% e    = 1.60217733e-19 ;
% c    = 2.99792458e+8 ;
% 
% % t1   = energy*1e9*e;
% % v    = c*sqrt(t1*(2*m0*c*c+t1)/((m0*c*c+t1)^2));
% % gamma= 1./sqrt(1.-v*v/c/c);
% % p    = m0*c*sqrt(gamma*gamma-1.);
% % brho = p/e;
% E = E*1e9*e;
% E0 = m0*c*c;
% 
% brho = sqrt(E*E - E0*E0)/c/e; 
