function AccObj1 = mtimes(AccObj1, AccObj2)
%MTIMES - Multiplication (A*B) for AccObj class
%
%  1. AccObj multiplication
%     Multiplying 2 AccObj returns an AccObj
%
%  2. Matrix multiplication
%     c*x or x*c, where x is an AccObj and c 
%     is a matrix returns a double matrix
%
%  NOTES
%  1. 1*x is one way to return the data field as a vector.
%     Same as x(:)
%
%  EXAMPLES
%  1. To get the change in orbit determined from a response
%     matrix due to the present horizontal corrector set:
%        hcm = getsp('HCM','Object'); 
%        R = getrespmat('BPMx', hcm);
%        dx = R * hcm;        % dx is a vector
%
%  Written by Greg Portmann



if isnumeric(AccObj2)
    Families = fieldnames(AccObj1);

    %if isscalar(AccObj2)
    %    for i = 1:length(Families)
    %        if ~isempty(AccObj1.(Families{i}))
    %            AccObj1.(Families{i}).Data = AccObj1.(Families{i}).Data * AccObj2;
    %        end
    %    end
    %else
        d = [];
        for i = 1:length(Families)
            %if ~isempty(AccObj1.(Families{i}))
                d = [d; AccObj1.(Families{i}).Data];
            %end
        end

        AccObj1 = d * AccObj2;
    %end

elseif isnumeric(AccObj1)
    Families = fieldnames(AccObj2);

    %if isscalar(AccObj1)
    %   for i = 1:length(Families)
    %       if ~isempty(AccObj2.(Families{i}))
    %           AccObj2.(Families{i}).Data = AccObj1 * AccObj2.(Families{i}).Data;
    %       end
    %   end
    %   AccObj1 = AccObj2;
    %else
        d = [];
        for i = 1:length(Families)
            %if ~isempty(AccObj2.(Families{i}))
                d = [d; AccObj2.(Families{i}).Data];
            %end
        end

        AccObj1 = AccObj1 * d;
    %end


else
    % Combine the lists
    %error('There is a device in one BPM object that is not is the other.');

    Families = fieldnames(getao);

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


