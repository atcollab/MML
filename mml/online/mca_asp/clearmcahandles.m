function ClearMCAHandles
%mcamain(0)
%set AcceleratorObjects .Monitor and .Setpoint Handles to NaN


mcamain(0);               %unlock handles
clear functions;          %close all channel access handles



% AO=GETAPPDATA(0,'AcceleratorObjects');
% for ii=1:size(AO,2);
%   if isfield(AO{ii},'Monitor')    
%   if isfield(AO{ii}.Monitor,'Handles')    
%     for jj=1:size(AO{ii}.Monitor.Handles,1)
%     AO{ii}.Monitor.Handles(jj)=NaN;
%     end
%   end 
%   end
%   if isfield(AO{ii},'Setpoint')    
%   if isfield(AO{ii}.Setpoint,'Handles')    
%     for jj=1:size(AO{ii}.Setpoint.Handles,1)
%     AO{ii}.Setpoint.Handles(jj)=NaN;
%     end
%   end
%   end
% end
% setappdata(0,'AcceleratorObjects',AO);

disp(' ');
disp('==> all channel access connections to this MATLAB session closed');
%disp('==> all AcceleratorObjects fields .Monitor.Handles and .Setpoint.Handles set to NaN');

%OpenChannelAccessHandles=mcaopen     %mcaopen command re-initializes polling
