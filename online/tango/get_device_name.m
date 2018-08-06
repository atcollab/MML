function [devicelist commonlist] = get_device_name(machine,property,magnet)
%GET_DEVICE_NAME - Gets device list from mapping read in tango database
%
% INPUTS
% 1. FamilyName or cell array of devicenames
% 2. property of the attribute
% 3. magnet: magnet type eg. CH
%
% OUTPUTS
% 1. devicelist: device name 
% 2. commonlist: name in AT
%
% EXAMPLES
% 1. get_device_name('LT1','tracy_correctorH_mapping', AO.CH.FamilyName);
%

%
% Written by Laurent S. Nadolski
map        = tango_get_db_property(machine,property);
sep        = cell2mat(regexpi(map,'::','once'))-1;
devicelist = regexprep(map,[magnet '\d*::'],'')';
nb = length(map);
commonlist = {''};
for k = 1:nb
   commonlist{k} = map{k}(1:sep(k));
end
commonlist = commonlist';
