function AccObj1 = times(AccObj1, AccObj2)
%TIMES - Point wise multiplication (A .* B) for AccObj class
%
%  1. AccObj multiplication (just like *)
%     Multiplying 2 AccObj returns an AccObj
%
%  2. Vector multiplication
%     c.*x or x.*c, where x is an AccObj and c 
%     is a vector returns an AccObj
%
%  Written by Greg Portmann



if isnumeric(AccObj2)
    Families = fieldnames(AccObj1);

    d = [];
    for i = 1:length(Families)
        d = [d; AccObj1.(Families{i}).Data];
    end

    d = d .* AccObj2(:);

    for i = 1:length(Families)
        AccObj1.(Families{i}).Data = d(1:size(AccObj1.(Families{i}).Data,1));
        d(1:size(AccObj1.(Families{i}).Data,1)) = [];
    end

elseif isnumeric(AccObj1)
    Families = fieldnames(AccObj2);

    d = [];
    for i = 1:length(Families)
        d = [d; AccObj2.(Families{i}).Data];
    end
    
    d = AccObj1(:) .* d;
    
    for i = 1:length(Families)
        AccObj2.(Families{i}).Data = d(1:size(AccObj2.(Families{i}).Data,1));
        d(1:size(AccObj2.(Families{i}).Data,1)) = [];
    end
    
    AccObj1 = AccObj2;


else
    % Combine the lists
    %error('There is a device in one BPM object that is not is the other.');

    Families = fieldnames(AccObj1);

    for i = 1:length(Families)
        if ~isempty(AccObj1.(Families{i})) & ~isempty(AccObj2.(Families{i}))
            [DeviceList, i1, i2] = union(AccObj1.(Families{i}).DeviceList, AccObj2.(Families{i}).DeviceList, 'rows');
            Data1 = zeros(size(DeviceList,1),1);
            Data2 = Data1;

            j = findrowindex(AccObj1.(Families{i}).DeviceList, DeviceList);
            Data1(j) = AccObj1.(Families{i}).Data;

            j = findrowindex(AccObj2.(Families{i}).DeviceList, DeviceList);
            Data2(j) = AccObj2.(Families{i}).Data;

            Data = Data1 .* Data2;

            AccObj1.(Families{i}).Data = Data;
            AccObj1.(Families{i}).DeviceList = DeviceList;

        elseif ~isempty(AccObj2.(Families{i}))
            % Move family in AccObj2 to AccObj1  ???
            AccObj1.(Families{i}) = AccObj2.(Families{i});
            AccObj1.(Families{i}).Data = AccObj1.(Families{i}).Data;
        end
    end
    
    d = AccObj1;
end


