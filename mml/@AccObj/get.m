function AccObj = get(AccObj, varargin)
%GET - Get an AccObj object
%  AccObj = get(AccObj)
%
%  Written by Greg Portmann

AccObj = getpv(AccObj, varargin{:});

% Families = fieldnames(AccObj);
% 
% for i = 1:length(Families)
%     if ~isempty(AccObj.(Families{i}))
% 
%         DataStruct = getpv(AccObj.(Families{i}).FamilyName, AccObj.(Families{i}).Field, AccObj.(Families{i}).DeviceList, varargin{:}, AccObj.(Families{i}).Units, 'struct');
% 
%         AccObj.(Families{i}).Data = DataStruct.Data;
%         AccObj.(Families{i}).Mode = DataStruct.Mode;
%         AccObj.(Families{i}).DataDescriptor = DataStruct.DataDescriptor;
%         AccObj.(Families{i}).CreatedBy = DataStruct.CreatedBy;
%         AccObj.(Families{i}).t = DataStruct.t;
%         AccObj.(Families{i}).tout = DataStruct.tout;
%         AccObj.(Families{i}).DataTime = DataStruct.DataTime;
%         AccObj.(Families{i}).TimeStamp = DataStruct.TimeStamp;
%     end
% end



