function Mode = family2mode(varargin)
%FAMILY2MODE - Returns the present family mode ('Online', 'Simulator', 'Manual', 'Special', etc)
%  Mode = family2mode(Family, Field)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%              (or a cell array of the above types)
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: 'Monitor'}
%
%  OUTPUTS
%  1. Mode - Mode string corresponding to the Family and Field
% 
%  NOTES
%  1. If the inputs are cell arrays, then the outputs are cell arrays

%  Written by Greg Portmann


Mode = getmode(varargin{:});