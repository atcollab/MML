function [RMN, tout, DataTime, ErrorFlag] = getrmn(varargin)
%GETDCCT - returns the beam current
%  [RMN, tout, DataTime, ErrorFlag] = getdcct(t, InputFlags)
%
%  OUTPUTS
%  1. RMN = storage ring electron beam current
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
%  1. This function is just an alias for getam('RMN', ...)

%
%  Written by Laurent S. Nadolski


if nargout > 2
    [RMN, tout, DataTime, ErrorFlag] = getpv('RMN', 'Monitor', [], varargin{:});
else
    [RMN, tout] = getpv('RMN', 'Monitor', [], varargin{:});
end

