function gtrack(select)
%GTRACK Track mouse position and show coordinates in figure title.
%
%	GTRACK Activates GTRACK. Once it is active the mouse position is
%	constantly tracked and printed on the figure title. A left-click will
%	print the coordinates in the command line and store them in clickData.
%	GTRACK OFF or clicking the mouse's right button deactivates GTRACK.
%
%
% 2007 Jose F. Pina, Portugal
% 
% REVISION 
%	23-May-2007 - created
%
% CREDITS
%	based on GTRACE
%	http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=3832&objectType=file
% 	Furi Andi Karnapi and Lee Kong Aik
% 	DSP Lab, School of EEE, Nanyang Technological University
% 	Singapore, March 2002

if nargin==0;
	
    currFcn = get(gcf, 'windowbuttonmotionfcn');
    currFcn2 = get(gcf, 'windowbuttondownfcn');
    currTitle = get(get(gca, 'Title'), 'String');

    handles = guidata(gca);
    if (isfield(handles,'ID') & handles.ID==1)
        disp('GTrack is already active.');
        return;
    else
        handles.ID = 1;
        %disp('GTrack started.');
	end

    handles.currFcn = currFcn;
    handles.currFcn2 = currFcn2;
    handles.currTitle = currTitle;
    handles.theState = uisuspend(gcf);
    guidata(gca, handles);

	set(gcf,'Pointer','crosshair');
    set(gcf, 'windowbuttonmotionfcn', 'GTrack(''OnMouseMove'')');        
    set(gcf, 'windowbuttondownfcn', 'GTrack(''OnMouseDown'')');          
	
else
   switch select
   case 'OnMouseMove'
       GTrack_OnMouseMove;
   case 'OnMouseDown'
       GTrack_OnMouseDown;
   case 'off'
	   GTrack_Off
   end
end

%---------------------------------------------------------------------------------------
function GTrack_OnMouseMove

global xInd yInd;

pt = get(gca, 'CurrentPoint');
xInd = pt(1, 1);
yInd = pt(1, 2);
xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');

if xInd < xLim(1) | xInd > xLim(2)
    title('Out of X limit');
    return;
end
if yInd < yLim(1) | yInd > yLim(2)
    title('Out of Y limit');
    return;
end

title(['X = ' num2str(xInd) ', Y = ' num2str(yInd)]);

%---------------------------------------------------------------------------------------
function GTrack_OnMouseDown

global xInd yInd clickData

if strcmp(get(gcf,'SelectionType'),'alt')
	GTrack_Off
	return
end

clickData(end+1).x = xInd;
clickData(end).y = yInd;
fprintf('clickData(%d): X = %f   Y = %f\n',length(clickData),xInd,yInd);



%--------------------------------------------------------------------------
function GTrack_Off

global xInd yInd clickData

handles = guidata(gca);
set(gcf, 'windowbuttonmotionfcn', handles.currFcn);
set(gcf, 'windowbuttondownfcn', handles.currFcn2);
set(gcf,'Pointer','arrow');
title(handles.currTitle);
uirestore(handles.theState);
handles.ID=0;
guidata(gca,handles);
assignin('base','clickData',clickData);
clear global clickData xInd yInd 
