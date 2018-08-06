function [DCCT, tout, DataTime, ErrorFlag] = getdcct(varargin)
%GETDCCT - returns the beam current
%  [DCCT, tout, DataTime, ErrorFlag] = getdcct(t, InputFlags)
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
 
 
DCCT = 2;

%if nargout > 2
%    [DCCT, tout, DataTime, ErrorFlag] = getpv('DCCT', 'Monitor', [], varargin{:});
%else
%    [DCCT, tout] = getpv('DCCT', 'Monitor', [], varargin{:});
%end

