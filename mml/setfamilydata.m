function setfamilydata(Data, Family, Field1, Field2, DeviceList)
%SETFAMILYDATA - Sets data associated with accelerator control 
%
%  When getting data from the accelerator object (AO):
%  setfamilydata(Data, Family, Field1, Field2, DeviceList)
%  setfamilydata(Data, Family, Field1, DeviceList)
%  setfamilydata(Data, Family, Field1)
%  setfamilydata(Data, Family)
%
%  When getting data from the accelerator data stucture (AD):
%  setfamilydata(Data, Field1)
%  setfamilydata(Data, Field1, Field2)
%  setfamilydata(Data, Field1, Field2, Field3)
%  setfamilydata(Data, Field1, Field2, Field3, Field4)
%
%  INPUTS
%  1. Data = Data to set
%     AO.Field1.Field2 = Data
%     AD.Field1.Field2.Field3.Field4 = Data
%
%     If DeviceList exists, then Data is indexed according to DeviceList,
%     AD.Field1(DeviceList) = Data
%           or
%     AD.Field1.Field2(DeviceList) = Data
%                     
%  2. Family = Family Name
%              Data Structure (only the FamilyName field is used)
%              Field
%              Accelerator Object
%
%  3. Field1 = Field name (string)
%
%  4. Field2 = Field name (string)
%
%  5. DeviceList = Device list for that family
%
%  NOTES
%  1. The inputs can be cell arrays
%  2. If Family is a cell array, then DeviceList must also be a cell array,
%           however, Field1 or Field2 can either be a cell array array or a string.
%  3. If the field does not exist, then an error will occur

%  Written by Greg Portmann


if nargin < 2
    error('At least two inputs required');
end


% Cell array input
if iscell(Family)
    if nargin >= 3
        if iscell(Field1)
            if length(Family) ~= length(Field1)
                error('If Field1 is a cell array, then must be the same size as Family');
            end
        end
    end
    if nargin >= 4
        if iscell(Field2)
            if length(Family) ~= length(Field2)
                error('If Field2 is a cell array, then must be the same size as Family');
            end
        end
    end
    if nargin >= 5
        if ~iscell(DeviceList)
            error('If family is a cell array, then DeviceList must be a cell array');
        end
        if length(Family) ~= length(DeviceList)
            error('Family and DeviceList must be the same size cell arrays');
        end
    end
    
    for i = 1:length(Family)
        if nargin == 2
            setfamilydata(Data{i}, Family{i});
        elseif nargin == 3
            if iscell(Field1)
                setfamilydata(Data{i}, Family{i}, Field1{i});
            else
                setfamilydata(Data{i}, Family{i}, Field1);
            end
        elseif nargin == 4
            if iscell(Field1)
                if iscell(Field2)
                    setfamilydata(Data{i}, Family{i}, Field1{i}, Field2{i});
                else
                    setfamilydata(Data{i}, Family{i}, Field1{i}, Field2);
                end                
            else
                if iscell(Field2)
                    setfamilydata(Data{i}, Family{i}, Field1, Field2{i});
                else
                    setfamilydata(Data{i}, Family{i}, Field1, Field2);
                end                
            end
        else
            if iscell(Field1)
                if iscell(Field2)
                    setfamilydata(Data{i}, Family{i}, Field1{i}, Field2{i}, DeviceList{i});
                else
                    setfamilydata(Data{i}, Family{i}, Field1{i}, Field2, DeviceList{i});
                end                
            else
                if iscell(Field2)
                    setfamilydata(Data{i}, Family{i}, Field1, Field2{i}, DeviceList{i});
                else
                    setfamilydata(Data{i}, Family{i}, Field1, Field2, DeviceList{i});
                end                
            end
        end
    end
    return    
end  
% End cell inputs

[FamilyFlag, AO] = isfamily(Family);

if FamilyFlag
    Family = AO.FamilyName;
    AO = getao;
    if nargin == 2
        % Set the entire family cell to Data
        AO.(Family) = Data;
    elseif nargin == 3
        AO.(Family).(Field1) = Data;
    elseif nargin == 4
        if ischar(Field2)
            AO.(Family).(Field1).(Field2) = Data;
        else
            % Field2 is a Element or DeviceList
            if size(Field2,2) == 1
                DeviceList = elem2dev(AO.(Family), Field2); 
            else
                DeviceList = Field2;
            end
            if isempty(DeviceList)
                DeviceList = family2dev(AO.(Family));
            end
            DeviceListTotal = getlist(AO.(Family),0);
            DeviceIndex = findrowindex(DeviceList, DeviceListTotal);

            % If the field doesn't exist yet, then create it (but what's the default???)
            %if ~isfield(AO.(Family), Field1)
            %    AO.(Family).(Field1) = NaN;
            %end

            % If the number of row equal 1, then expand first (This doesn't work for strings)
            if size(AO.(Family).(Field1),1) == 1
                AO.(Family).(Field1) = ones(size(DeviceListTotal,1),1) * AO.(Family).(Field1);
            end
            
            AO.(Family).(Field1)(DeviceIndex,:) = Data;
        end
    elseif nargin == 5
        if size(Field2,2) == 1
            DeviceList = elem2dev(AO.(Family), DeviceList);
        end
        if isempty(DeviceList)
            DeviceList = family2dev(AO.(Family));
        end
        DeviceListTotal = getlist(AO.(Family),0);
        DeviceIndex = findrowindex(DeviceList, DeviceListTotal);

        % If the number of row equal 1, then expand first (This doesn't work for strings)
        if size(AO.(Family).(Field1).(Field2),1) == 1
            AO.(Family).(Field1).(Field2) = ones(size(DeviceListTotal,1),1) * AO.(Family).(Field1).(Field2);
        end

        AO.(Family).(Field1).(Field2)(DeviceIndex,:) = Data;
    end
    setao(AO);
else
    % Check the AD
    AD = getad;
    if nargin == 2
        AD.(Family) = Data;
    elseif nargin == 3
        AD.(Family).(Field1) = Data;
    elseif nargin == 4
        AD.(Family).(Field1).(Field2) = Data;
    end
    setad(AD);
end

