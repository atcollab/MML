function setenergymodel(GeV)
%SETENERGYMODEL - Set the energy of the model
%  setenergymodel(GeV)
%
%  INPUTS
%  1. GeV - Energy in GeV
%
%  Keyword can be:
%  'Production' - Energy of the production lattice
%  'Injection'  - Energy of the injection lattice
%
%  See also getenergymodel

%  Written by Greg Portmann


if ischar(GeV)
    if strcmpi(GeV, 'Production')
        GeV = getfamilydata('Energy');
    elseif strcmpi(GeV, 'Injection')
        GeV = getfamilydata('InjectionEnergy');
    else
        GeV = getfamilydata(GeV);
        if isempty(GeV) || ~isnumeric(GeV)
            error('Production, Injection, or something getfamilydata recognizes are the only allowable string inputs.');
        end
    end
end


% GLOBVAL will be obsolete soon
if ~isempty(whos('global','GLOBVAL'))
    global GLOBVAL
    GLOBVAL.E0 = 1e+009 * GeV(end);
end

% Newer AT versions require 'Energy' to be an AT field
global THERING
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), 1e+009 * GeV(end));

 
