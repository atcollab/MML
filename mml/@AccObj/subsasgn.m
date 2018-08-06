function DataObj = subsasgn(DataObj, index, val)
% SUBSASGN - Define index assignment for AccObj
%
%  Written by Greg Portmann


switch index(1).type
    case '{}'
        % Cell array of AccObj
        % This method will only get called if DataObj was previously defined
        % as an AccObj then one wants to redefine it as a cell array
        tmp = DataObj;
        DataObj = cell(index.subs{:});
        DataObj{index.subs{:}} = tmp;
        
    case '()'
        if isempty(DataObj)
            % Start an array of AccObj
            clear DataObj
            % Build first rows
            tmp = AccObj;
            for i = 1:index.subs{1}
                DataObj(i,1) = tmp;
            end
            % Build the columns
            if length(index.subs) > 1
                % Add new columns
                for cols = 1:index.subs{2}-1
                    DataObj = [DataObj DataObj(:,1)];
                    % Empty the new row
                    tmp = AccObj;
                    for i = 1:size(DataObj,1)
                        DataObj(i,end) = tmp;    
                    end
                end
            end
            % Fill in the data
            DataObj(index.subs{:}) = val;
            
        elseif isa(DataObj, 'AccObj') & isa(val, 'AccObj')
            % If DataObj & val are both AccObj, then keep the array going
            if index.subs{1} > size(DataObj,1) & size(DataObj,2) > 1
                % Add new rows
                for rows = 1:index.subs{1}-size(DataObj,1)
                    DataObj = [DataObj;DataObj(1,:)];
                    % Empty the new row
                    tmp = AccObj;
                    for i = 1:size(DataObj,2)
                        DataObj(end,i) = tmp;    
                    end
                end
            end
            if length(index.subs) > 1
                if index.subs{2} > size(DataObj,2) & size(DataObj,1) > 1
                    % Add new columns
                    for cols = 1:index.subs{2}-size(DataObj,2)
                        DataObj = [DataObj DataObj(:,1)];
                        % Empty the new row
                        tmp = AccObj;
                        for i = 1:size(DataObj,1)
                            DataObj(i,end) = tmp;    
                        end
                    end
                end
            end
            DataObj(index.subs{:}) = val;
            
        else
            % True assignment change of the AccObj input
            Families = fieldnames(DataObj);
            Index1 = index.subs{1};
            if length(index.subs) > 1
                Index2 = index.subs{2};
            else
                Index2 = ':';
            end
            for i = 1:length(Families)
                if iscell(index.subs{1})
                    % If index1 is a cell then it's a device list
                    Index1 = findrowindex(index.subs{1}{1}, DataObj.(Families{i}).DeviceList);
                    if isempty(Index1)
                        error('??? Device not found.');
                    end
                end
                if max(Index1) > size(DataObj.(Families{i}).Data,1)
                    error(sprintf('Index is greater than the number of devices in family %s', Families{i}));
                end
                DataObj.(Families{i}).Data(Index1,Index2) = val;
                if isempty(val)
                    % If val is empty then the request is to remove a device
                    if isempty(DataObj.(Families{i}).Data)
                        % Remove the family if there is no data left
                        DataObj.(Families{i}) = [];
                    else
                        % Remove part of the family
                        DataObj.(Families{i}).DeviceList(Index1,:) = val;
                        DataObj.(Families{i}).Status(Index1,:) = val;
                    end
                end
            end
        end
        
    case '.'
        % AccObj.(Family) input        
        % Assigment change for only one family
        Family = index(1).subs;
        if length(index) > 1
            Index1 = index(2).subs{1};
            if length(index(2).subs) > 1
                Index2 = index(2).subs{2};
            else
                Index2 = ':';
            end
        else
            DataObj.(Family) = [];
            return;
        end
        if iscell(index(2).subs{1})
            % If index1 is a cell then it's a device list
            Index1 = findrowindex(index(2).subs{1}{1}, DataObj.(Family).DeviceList);
            if isempty(Index1)
                error('??? Device not found.');
            end
        end
        if max(Index1) > size(DataObj.(Family).Data,1)
            error('Index is greater than the number of devices');
        end
        DataObj.(Family).Data(Index1,Index2) = val;
        if isempty(val)
            if isempty(DataObj.(Family).Data)
                % Remove the family if there is no data left
                DataObj.(Family) = [];
            else
                % If val is empty then the request is to remove a device
                DataObj.(Family).DeviceList(Index1,:) = val;
                DataObj.(Family).Status(Index1,:) = val;
            end
        end
end
return

