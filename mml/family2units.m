function [Units, UnitsString] = family2units(varargin)
%FAMILY2UNITS - Return the present family units and units string 
%  [Units, UnitsString] = family2units(Family, Field)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%              (or a cell array of the above types)
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: 'Monitor'}
%
%  OUTPUTS
%  1. Units - Units ('Physics' or 'Hardware') corresponding to the Family and Field
%  2. UnitsSting - Units string corresponding to the Family and Field
% 
%  NOTES
%  1. If the inputs are cell arrays, then the outputs are cell arrays
%  2. Same as getunits

%  Written by Greg Portmann


[Units, UnitsString] = getunits(varargin{:});