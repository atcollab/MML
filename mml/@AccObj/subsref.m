function d = subsref(DataObj, index)
% SUBSREF - Define field name indexing for AccObj objects
%
%  Written by Greg Portmann


if any(size(DataObj) > 1)
    % AccObj array
    d = DataObj(index.subs{:});
else
    d = DataObj;
    for i = 1:length(index)
        d = subsreflocal(d, index(i));
    end
end
return


function d = subsreflocal(DataObj, index)

% 1 AccObj
if ischar(index.subs)
    d = DataObj.(index.subs);
    return;
end

if isa(DataObj, 'AccObj')
    Families = fieldnames(DataObj);
    d = [];
    DeviceList = [];

    if iscell(index(1).subs{1})
        % Find by device list
        for i = 1:length(Families)
            if iscell(index(1).subs{1})
                % If index1 is a cell then it's a device list
                Index1 = findrowindex(index(1).subs{1}{1}, DataObj.(Families{i}).DeviceList);
                %if isempty(Index1)
                %    error('??? Device not found.');
                %end
            else
                Index1 = index.subs{1};
            end
            Index2 = ':';
            if length(index.subs) > 1
                if iscell(index.subs{2})
                    Index2 = index.subs{2};
                end
            end            
            d = [d; DataObj.(Families{i}).Data(Index1,Index2)];
            DeviceList = [DeviceList; DataObj.(Families{i}).DeviceList(Index1,:)];      
        end
        if isempty(d)
           error('??? Device not found.');
        end
        % Should also error if an input device was not found anywhere???
    else
        % Find by normal matlab indexing
        for i = 1:length(Families)
            d = [d; DataObj.(Families{i}).Data];
        end
        d = d(index.subs{:});
    end
elseif isstruct(DataObj)
    
    if iscell(index(1).subs{1})
        % Find by device list
        if iscell(index(1).subs{1})
            % If index1 is a cell then it's a device list
            Index1 = findrowindex(index(1).subs{1}{1}, DataObj.DeviceList);
            if isempty(Index1)
                error('??? Device not found.');
            end
        else
            Index1 = index.subs{1};
        end
        Index2 = ':';
        if length(index.subs) > 1
            if iscell(index.subs{2})
                Index2 = index.subs{2};
            end
        end            
        d = DataObj.Data(Index1,Index2);
    else
        Data = DataObj.Data;
        d = Data(index.subs{:});
    end
else
    d = DataObj(index.subs{:});
end
return
