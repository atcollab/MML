function disp(DataObj)
%DISP - Display of a middle layer object
%  disp(AccObj)
%
%  Written by Greg Portmann


%if size(DataObj.DeviceList,1) > 10
%    fprintf('   %s (%d elements)  mean=%f %s  std=%f %s\n', DataObj.FamilyName, size(DataObj.DeviceList,1), mean(DataObj.Data), DataObj.UnitsString, std(DataObj.Data), DataObj.UnitsString);
%end

%for i = 1:size(DataObj.DeviceList,1)
%    fprintf('   %s(%d,%d) = %f\n', DataObj.FamilyName, DataObj.DeviceList(i,:), DataObj.Data(i));
%end

if any(size(DataObj) > 1)
    
    for i = 1:size(DataObj,1)
        for j = 1:size(DataObj,2)
            disp(DataObj(i,j));
        end
    end
    
else
    
    Families = fieldnames(DataObj);
    %if isempty(Families)
    %   fprintf('[]\n');
    %   return
    %end    
    %Data = [];
    %DeviceList = [];
    for i = 1:length(Families)
        %Data = [Data; DataObj.(Families{i}).Data];
        %DeviceList = [DeviceList; DataObj.(Families{i}).DeviceList];
        
        a = DataObj.(Families{i}).Data;
        %    if size(a,2) > 1
        %fprintf('%s\n', Families{i});
        if isempty(a)
            fprintf('[]\n');
        else
            disp(a);
        end
        %else
        %    for j = 1:size(a,1)
        %        fprintf('%s[%d %d] = %f\n', DataObj.(Families{i}).FamilyName, DataObj.(Families{i}).DeviceList(j,:), a(j,:));
        %        %fprintf(' %f', a(j,:));
        %        %fprintf('\n');
        %     end
        %end
    end
end




% if strcmpi(DataObj.UnitsString, 'mm')
%     a = [DeviceList Data];
%     fprintf(' %3d  %3d  %10.6f\n', a');
% else
%     %DataObj.Data
%     a = [DataObj.DeviceList DataObj.Data];
%     fprintf('%3d  %3d  %f\n', a');
% end
