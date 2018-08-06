function [XData,YData] = clsGetFigData(figfile)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsGetFigData.m 1.2 2007/03/02 09:02:34CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%     [XData,YData] = clsGetFigData(figfile)
%     This functiuon opens the specified figure file and reads out the plot
%     data into XData and YData respectively
%
% ----------------------------------------------------------------------------------------------

format long;
if(~exist(figfile))
    fprintf('No figfile specified');
end    

d = dir(figfile);
for i = 1:length(d)
   fig_handle = openfig(d(i).name);
   h = findobj(gca,'type','line');  %Assuming a single axes
   Ydata{i} = get(h,'YData'); %Cell array
   Xdata{i} = get(h,'XData'); %Cell array
   %close(fig_handle);
end

XData = Xdata{1};
YData = Ydata{1}';

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsGetFigData.m  $
% Revision 1.2 2007/03/02 09:02:34CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------




