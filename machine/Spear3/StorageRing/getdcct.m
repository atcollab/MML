function [DCCT, DCCTMed, DCCTSlow] = getdcct(varargin)
%GETDCCT - returns the beam current
%  [DCCTfast, DCCTmed, DCCTslow] = getdcct(Flags)
%
%  OUTPUTS
%  1. DCCT = storage ring electron beam current
%  
%  INPUTS
%  1. 'Struct' will return a data structure
%     'Numeric' will return numeric outputs {Defaul}
%  2. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%  3. 'Online' - Get data online (optional override of the mode)
%     'Model'  - Get data from the model (optional override of the mode)
%     'Manual' - Get data manually (optional override of the mode)
%
%  NOTE
%  1. Simulation mode: lifetime is 6 hour, refill at midnight to 1000 mamps
%  2. This function is just an alias for getam('DCCT', ...)
%
%  Written by Greg Portmann


DCCT = getam('DCCT', varargin{:});


if nargout >= 2
    DCCTMed  = getpv('SPEAR:BeamCurrAvgMed');
end
if nargout >= 3
    DCCTSlow = getpv('SPEAR:BeamCurrAvgSlow');
end

