function cap    
%CAP - Clears application data 
%
% Written by Gregory J. Pormann

setappdata(0,'AcceleratorData', []);
setappdata(0,'AcceleratorObjects',[]);

% To really clear it
%rmappdata(0, 'AcceleratorData');
%rmappdata(0, 'AcceleratorObjects');


% % If you want to clear all of appdata for the command window
% VarNameStuct = getappdata(0);
% VarNameCell = fieldnames(VarNameStuct);
% 
% for i = 1:length(VarNameCell)
%     rmappdata(0, VarNameCell{i});
% end
