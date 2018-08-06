function setpassmethod(ATIndex, PassMethod, DeviceList)
%SETPASSMETHOD - Sets the PassMethod 
%  setpassmethod(Family,  PassMethod, DeviceList)
%  setpassmethod(ATIndex, PassMethod)
%  setpassmethod(FamName, PassMethod)
%
%  INPUTS
%  1. Family, ATIndex, FamName
%  2. PassMethod - String, string matrix, or cell array
%  3. DeviceList (optional if using a Family name)
%
%  See also getpassmethod, getcavity

%  Written by Greg Portmann




global THERING

if nargin < 2
    error('2 inputs required.');
end
if isempty(ATIndex)
    return
end
if isempty(PassMethod)
    return
end


if ischar(ATIndex)
    if nargin >= 3
        ATIndex = family2atindex(ATIndex, DeviceList);
    else
        ATIndex = family2atindex(ATIndex);
    end
end


for i = 1:length(ATIndex)
    if iscell(PassMethod)
        if length(PassMethod) == 1
            THERING = setcellstruct(THERING, 'PassMethod', ATIndex(i), deblank(PassMethod{1}));
        else
            THERING = setcellstruct(THERING, 'PassMethod', ATIndex(i), deblank(PassMethod{i}));
        end
    else
        if size(PassMethod,1) == 1
            THERING = setcellstruct(THERING, 'PassMethod', ATIndex(i), deblank(PassMethod(1,:)));
        else
            THERING = setcellstruct(THERING, 'PassMethod', ATIndex(i), deblank(PassMethod(i,:)));
        end
    end
end


