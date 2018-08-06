function AccObj1 = minus(AccObj1, AccObj2)
%MINUS - Minus (A-B) for AccObj class
%
%  Written by Greg Portmann



if isnumeric(AccObj2)
    Families = fieldnames(AccObj1);
    for i = 1:length(Families)
        Data = AccObj1.(Families{i}).Data;
        AccObj1.(Families{i}).Data = Data - AccObj2(1:size(Data,1),:);
        AccObj2(1:size(Data,1),:) = [];
    end

elseif isnumeric(AccObj1)
    Families = fieldnames(AccObj2);
    for i = 1:length(Families)
        Data = AccObj2.(Families{i}).Data;
        AccObj2.(Families{i}).Data = AccObj1(1:size(Data,1),:) - Data;
        AccObj1(1:size(Data,1),:) = [];
    end
    AccObj1 = AccObj2;
    
elseif ischar(AccObj2)
    AccObj1.(AccObj2) = [];
    
elseif ischar(AccObj1)
    AccObj2.(AccObj1) = [];
    AccObj1 = AccObj2;
    
else
    % Combine the lists
    %error('There is a device in one BPM object that is not is the other.');

    Families = fieldnames(getao);

    for i = 1:length(Families)
        if ~isempty(AccObj1.(Families{i})) & ~isempty(AccObj2.(Families{i}))
            % Families exist in both inputs
            [DeviceList, i1, i2] = union(AccObj1.(Families{i}).DeviceList, AccObj2.(Families{i}).DeviceList, 'rows');
            Data1 = zeros(size(DeviceList,1),1);
            Data2 = Data1;

            j = findrowindex(AccObj1.(Families{i}).DeviceList, DeviceList);
            Data1(j) = AccObj1.(Families{i}).Data;

            j = findrowindex(AccObj2.(Families{i}).DeviceList, DeviceList);
            Data2(j) = AccObj2.(Families{i}).Data;

            Data = Data1 - Data2;

            AccObj1.(Families{i}).Data = Data;
            AccObj1.(Families{i}).DeviceList = DeviceList;

        elseif ~isempty(AccObj2.(Families{i}))
            % Family is only in input 2
            % Move family in AccObj2 to AccObj1 with a minus sign
            AccObj1.(Families{i}) = AccObj2.(Families{i});
            AccObj1.(Families{i}).Data = -1 * AccObj1.(Families{i}).Data;
        end
    end
end


