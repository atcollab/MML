function varargout = plotbetatune(action, varargin)
%derived from AT program PLOTBETA
%plots UNCOUPLED beta-functions
%Note: uses FINDORBIT4 and LINOPT which assume a no accelerating cavities and no radiation
%
% July 21, 2005 added the following features for PLOTBETATUNE
%  1. tune increment pushbuttons
%  2. tune display fields
%  3. quadrupole strength display fields

global THERING
L = length(THERING);
spos = findspos(THERING,1:L+1);

if nargin==0   action='Initialize'; end
    
switch action

%==========================================================
case 'Initialize'                               %Initialize
%==========================================================
%generate a figure
handles.figure=figure;
set(handles.figure,'Position',[200 200 700 500]);

% plot betax and betay in two subplots
handles.betaxplot = axes('YGrid','on','Position',[0.1 0.7 0.85 0.25],'YLim',[0 30]);
handles.betax   =	line('parent',handles.betaxplot,'XData',spos,'YData',0*spos,'Color','b');
A = axis; A(1) = 0; A(2) = spos(end); axis(A);
ylabel('\beta_x [m]');
title('\beta-functions');

handles.betayplot = axes('YGrid','on','Position',[0.1 0.4 0.85 0.25],'YLim',[0 30]);
handles.betay   =	line('parent',handles.betayplot,'XData',spos,'YData',0*spos,'Color','b');
B = axis; axis([A(1:2) B(3:4)]);
xlabel('s - position [m]');
ylabel('\beta_y [m]');

%create pushbuttons
uicontrol('Style','text','units', 'normalized',...
    'Position',[0.1 0.1 0.1 0.05],'HorizontalAlignment','center','String','Qy');
uicontrol('Style','text','units', 'normalized',...
    'Position',[0.1 0.2 0.1 0.05],'HorizontalAlignment','center','String','Qx');


handles.editQy=uicontrol('Style','edit','units', 'normalized',...
    'Position',[0.2 0.1 0.1 0.05],'HorizontalAlignment','center',...
    'ToolTipString','Enter Vertical Tune Increment','String','0.0');

handles.editQx=uicontrol('Style','edit','units', 'normalized',...
    'Position',[0.2 0.2 0.1 0.05],'HorizontalAlignment','center',...
    'ToolTipString','Enter Horizontal Tune Increment','String','0.0');

handles.showQy=uicontrol('Style','text','units', 'normalized',...
    'Position',[0.3 0.1 0.1 0.05],'HorizontalAlignment','center',...
    'ToolTipString','Calculated Vertical Tune Increment');

handles.showQx=uicontrol('Style','text','units', 'normalized',...
    'Position',[0.3 0.2 0.1 0.05],'HorizontalAlignment','center',...
    'ToolTipString','Calculated Horizontal Tune Increment');

uicontrol('Style','pushbutton','units','normalized', ...
    'Position',[0.1 0.05 0.1 0.05],'String','Update','FontSize',9,'FontWeight','demi',...
    'ToolTipString','Update Optics', 'Callback','plotbetatune(''Update'')');


setappdata(0,'handles', handles);

plotbetatune('Update')

%==========================================================
case 'Update'                               %Update
%==========================================================
handles=getappdata(0,'handles');

dQx=str2double(get(handles.editQx,'string'));
dQy=str2double(get(handles.editQy,'string'));
steptune([dQx,dQy]');

[TD, tune] = twissring(THERING,0,1:L+1);
BETA = cat(1,TD.beta);
S  = cat(1,TD.SPos);

field='betax';   %dynamic referencing
set(handles.(field),'YData',BETA(:,1));
set(handles.showQx,'String',num2str(tune(1)));

set(handles.betay,'YData',BETA(:,2));
set(handles.showQy,'String',num2str(tune(2)));

otherwise
disp(['   Warning: CASE not found in PLOTBETATUNE: ' action]);

end  %end switchyard


