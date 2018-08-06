function GeV = getenergymodel(iATIndex)
%GETENERGYMODEL - Returns the model energy in GeV
%  GeV = getenergymodel(ATIndex)
%
%  INPUTS
%  1. ATIndex - AT local to return the energy
%
%  OUTPUTS
%  1. GeV - Energy in GeV
%
%  See also getenergy, setenergymodel

%  Written by Greg Portmann


GeV = [];

global THERING

% Look for .Energy field in the THERING
ATIndex = findcells(THERING, 'Energy');

if ~isempty(ATIndex)
    if nargin < 1 || isempty(iATIndex)
        GeV = THERING{ATIndex(1)}.Energy / 1e+009;
    else
        for i = 1:length(iATIndex)
            GeV(i) = THERING{ATIndex(iATIndex(i))}.Energy / 1e+009;
        end
    end
end


if isempty(GeV)
    % Note: this may become obsolete in the future
    global GLOBVAL
    GeV = GLOBVAL.E0 / 1e+009;
end