function [PassMethod, ATIndex, FamName] = getpassmethod(ATIndex, DeviceList)
%GETPASSMETHOD - Gets the PassMethod field
%  [PassMethod, ATIndex, FamName] = getpassmethod(Family, DeviceList)
%  [PassMethod, ATIndex, FamName] = getpassmethod(ATIndex)
%  [PassMethod, ATIndex, FamName] = getpassmethod(FamName)
%
%  INPUTS
%  1. Family, ATIndex, FamName
%  2. DeviceList (optional if using a Family name)
%
%  OUTPUTS
%  1. PassMethod - AT PassMethod field.  String or cell array if more than one.
%  2. ATIndex - AT index in THERING
%  3. FamName - AT family name
%
%  See also setpassmethod, setradiation, getcavity, setcavity

%  Written by Greg Portmann


global THERING

if nargin == 0
    ATIndex = [];
end

if isempty(ATIndex)
    PassMethod = {};
    FamName = {};
    return
end

if ischar(ATIndex)
    if nargin >= 2
        ATIndex = family2atindex(ATIndex, DeviceList);
    else
        ATIndex = family2atindex(ATIndex);
    end
end


% Output
PassMethod = getcellstruct(THERING, 'PassMethod', ATIndex);
FamName    = getcellstruct(THERING, 'FamName',    ATIndex);

if length(PassMethod) == 1
    PassMethod = PassMethod{1};
    FamName    = FamName{1};
end