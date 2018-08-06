function [Family, Field, DeviceList, UnitsFlag, ModelFlag] = inputparsingffd(varargin)
%INPUTPARSINGFFD - Parses the typical input line of Family, Field, DeviceList
%  [Family, Field, DeviceList, UnitsFlag, ModeFlag] = inputparsingffd(varargin);
%
%  OUTPUTS
%  1. Family
%  2. Field
%  3. DeviceList {Default: Entire family}
%                If DeviceList is a string, then a common name conversion is tried.
%  4. UnitsFlag - Units if the input was a data structure
%  5. ModeFlag - Mode if the input was a data structure
%
%  See also checkforcommonnames

%  Written by Greg Portmann


UnitsFlag = '';
ModelFlag = '';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Family, Data Structure, or AO Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstruct(varargin{1})
    if isfield(varargin{1},'FamilyName') && isfield(varargin{1},'Field')
        % Data structure inputs
        Family = varargin{1}.FamilyName;

        Field = varargin{1}.Field;
        if length(varargin) >= 2
            if ischar(varargin{2})
                Field = varargin{2};
                varargin(2) = [];
            end
        end
        if length(varargin) >= 2
            DeviceList = varargin{2};
        else
            DeviceList = varargin{1}.DeviceList;
        end

        if isfield(varargin{1},'Units')
            UnitsFlag = varargin{1}.Units;
        end
        if isfield(varargin{1},'Mode')
            ModeFlag = varargin{1}.Mode;
        end

    else

        % AO Input
        Family = varargin{1}.FamilyName;

        Field = '';
        if length(varargin) >= 2
            if ischar(varargin{2})
                Field = varargin{2};
                varargin(2) = [];
            end
        end
        if length(varargin) >= 2
            DeviceList = varargin{2};
        else
            DeviceList = varargin{1}.DeviceList;
        end
        if isempty(DeviceList)
            DeviceList = varargin{1}.DeviceList;
        end
    end

else

    % Family input
    Family = varargin{1};

    Field = '';
    if length(varargin) >= 2
        if ischar(varargin{2})
            Field = varargin{2};
            varargin(2) = [];
        end
    end
    if length(varargin) >= 2
        DeviceList = varargin{2};
    else
        DeviceList = [];
    end

end


% Default field
% if isempty(Field)
%     Field = 'Monitor';
% end


% Default device list
if isempty(DeviceList)
    try
        DeviceList = family2dev(Family);
    catch
    end
end

% Convert element list to a device list
if (size(DeviceList,2) == 1) && ~ischar(DeviceList)
    DeviceList = elem2dev(Family, DeviceList);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check DeviceList or Family is a common name list %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Family, DeviceList] = checkforcommonnames(Family, DeviceList);





