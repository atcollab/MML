%=============================================================
function varargout = configgui(action, varargin)
%=============================================================
%  configgui - generate gui for configuration control
%  to launch:  >>configgui       (no input arguement)

h=findobj(0,'Tag','cnffig');
if ~isempty(h) cnfdata=getappdata(h,'configguidata'); end

%===========================
%   DRAW MAIN GUI (nargin=0)
%===========================
if nargin==0

if isempty(getao) 
    disp('Warning: Load AcceleratorObjects first');
    return
end

%Clear previous configuration control gui
if ~isempty(h) delete(h); end

%set defaults
cnfdata.field='setpoint';
cnfdata.SetpointData=[];
cnfdata.MonitorData=[];

% generate main figure
cnfdata.handles.figure=configgui('CNFFig');  
setappdata(cnfdata.handles.figure,'configguidata',cnfdata);

configgui('UIControls');


return
end

switch action

%==========================================================
case 'CNFFig'                                       %CNFFig
%==========================================================
%figure initialization

[screen_wide, screen_high]=screensizecm;

fig_start = [0.13*screen_wide 0.16*screen_high];
fig_start = [0.1*screen_wide 0.1*screen_high];
fig_size = [0.5*screen_wide 0.5*screen_high];

h = figure('Visible','off',...
		'units','centimeters','Resize','off',...
		'tag','cnffig',... 
		'NumberTitle','off',...
        'Doublebuffer','on',...
		'Name','Configuration Control Interface',...
		'PaperPositionMode','Auto'); %,'handlevisibility','off');
set(h,'MenuBar','None');
set(h,'Position',[fig_start fig_size],'Visible','on');

varargout{1}=h;

%==========================================================
case 'UIControls'                           %  UIControls
%==========================================================
%UIControls - generate UIControls in gui
[screen_wide, screen_high]=screensizecm;
x0=0.01*screen_wide ; dx=0.04*screen_wide; y0=0.48*screen_high; dy=0.04*screen_high; dely=0.03*screen_high;    

col1_families={'BEND'; 'QF'; 'QD'; 'QFC'; 'SF'; 'SD'};
col2_families={'QDX'; 'QFX'; 'QDY'; 'QFY'; 'QDZ'; 'QFZ'};
col3_families={'HCM'; 'VCM'; 'SFM'; 'SDM'; 'SkewQuad'};
families=[col1_families(:); col2_families(:); col3_families(:)];
cnfdata.families=families;

%check boxes
for k=1:length(col1_families)
cnfdata.handles.([col1_families{k} 'chk'])=uicontrol('Style','checkbox','units', 'centimeters','FontWeight','demi', ...
        'ToolTipString','Check to include in configuration load',...
        'Position',[x0+0.5*dx,y0-(k-0.33)*dely,1.8*dx,dy/2],'HorizontalAlignment','center','String',col1_families{k},...
        'callback','configgui(''CheckValid'')');
cnfdata.handles.([col1_families{k} 'flag'])=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+0.22*dx,y0-(k-0.51)*dely,dx/5,dy/4],'HorizontalAlignment','center','String',' ','BackGroundColor','r','Userdata',0);
   
end

for k=1:length(col2_families)
cnfdata.handles.([col2_families{k} 'chk'])=uicontrol('Style','checkbox','units', 'centimeters','FontWeight','demi', ...
        'ToolTipString','Check to include in configuration load',...
        'Position',[x0+3.0*dx,y0-(k-0.33)*dely,1.8*dx,dy/2],'HorizontalAlignment','center','String',col2_families{k},...
        'callback','configgui(''CheckValid'')');
cnfdata.handles.([col2_families{k} 'flag'])=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+2.7*dx,y0-(k-0.51)*dely,dx/5,dy/4],'HorizontalAlignment','center','String',' ','BackGroundColor','r','Userdata',0);
end

for k=1:length(col3_families)
cnfdata.handles.([col3_families{k} 'chk'])=uicontrol('Style','checkbox','units', 'centimeters','FontWeight','demi', ...
        'ToolTipString','Check to include in configuration load',...
        'Position',[x0+5.5*dx,y0-(k-0.33)*dely,1.8*dx,dy/2],'HorizontalAlignment','center','String',col3_families{k},...
        'callback','configgui(''CheckValid'')');
cnfdata.handles.([col3_families{k} 'flag'])=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+5.2*dx,y0-(k-0.51)*dely,dx/5,dy/4],'HorizontalAlignment','center','String',' ','BackGroundColor','r','Userdata',0);
end

%select all
uicontrol('Style','pushbutton','units', 'centimeters','FontWeight','demi', ...
        'ToolTipString','Select all families to include in configuration load',...
        'Callback','configgui(''SelectAll'')',...
        'Position',[x0+8.5*dx,y0-dely/2,2*dx,dy/2],'HorizontalAlignment','center','String','Select All');

%select none
uicontrol('Style','pushbutton','units', 'centimeters','FontWeight','demi', ...
        'ToolTipString','Select no families to include in configuration load',...
        'Callback','configgui(''SelectNone'')',...
        'Position',[x0+8.5*dx,y0-1.5*dely,2*dx,dy/2],'HorizontalAlignment','center','String','Select None');

%display configuration data
uicontrol('Style','pushbutton','units', 'centimeters','FontWeight','demi', ...
        'ToolTipString','Print configuration data to screen',...
        'Callback','configgui(''ShowConfiguration'')',...
        'Position',[x0+8.25*dx,y0-2.5*dely,2.5*dx,dy/2],'HorizontalAlignment','center','String','Display Configuration');

%list box to display output dialog
ts = ['Program Start-Up: ' datestr(now,0)];
cnfdata.handles.listbox=uicontrol('Style','list','Units','centimeters','Position',[x0+0.5*dx y0-15.8*dely 10*dx 2*dy],'String',{ts});

%configuration display
cnfdata.handles.configname=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+0.5*dx y0-13*dely 8*dx dy/2],'HorizontalAlignment','left','String',' ');

%Get Configuration
uicontrol('Style','text','units', 'centimeters','FontWeight','demi', ...
        'Position',[x0+0.5*dx,y0-7*dely,3.5*dx,dy/2],'HorizontalAlignment','left',...
        'String','Get Configuration from: ');
%machine
cnfdata.handles.GetMachine=uicontrol('Style','PushButton','units', 'centimeters', ...
        'ToolTipString','Acquire configuration from Machine','BackGroundColor',[1 1 1],...
        'Position',[x0+0.5*dx,y0-8*dely,1.2*dx,dy/2],'HorizontalAlignment','center','String','Machine',...
        'Callback','configgui(''GetMachineConfig'')');
cnfdata.handles.GetMachineTime=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+2.0*dx,y0-8*dely,3.0*dx,dy/2],'HorizontalAlignment','center','String','');

%desired
cnfdata.handles.GetDesired=uicontrol('Style','PushButton','units', 'centimeters', ...
        'ToolTipString','Acquire configuration from Desired Setpoints (SPEAR 3)','BackGroundColor',[1 1 1],...
        'Position',[x0+0.5*dx,y0-9*dely,1.2*dx,dy/2],'HorizontalAlignment','center','String','Desired',...
        'Callback','configgui(''GetDesiredConfig'')');
cnfdata.handles.GetDesiredTime=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+2.0*dx,y0-9*dely,3.0*dx,dy/2],'HorizontalAlignment','center','String','');

%file
cnfdata.handles.GetFile=uicontrol('Style','PushButton','units', 'centimeters', ...
        'ToolTipString','Read configuration from file','BackGroundColor',[1 1 1],...
        'Position',[x0+0.5*dx,y0-10*dely,1.2*dx,dy/2],'HorizontalAlignment','center','String','File',...
        'Callback','configgui(''GetFileConfig'')');
cnfdata.handles.GetFileTime=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+2.0*dx,y0-10*dely,3.0*dx,dy/2],'HorizontalAlignment','center','String','');
%golden
cnfdata.handles.GetGolden=uicontrol('Style','PushButton','units', 'centimeters', ...
        'ToolTipString','Read configuration from Golden','BackGroundColor',[1 1 1],...
        'Position',[x0+0.5*dx,y0-11*dely,1.2*dx,dy/2],'HorizontalAlignment','center','String','Golden',...
        'Callback','configgui(''GetGoldenConfig'')');
cnfdata.handles.GetGoldenTime=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+2.0*dx,y0-11*dely,3.0*dx,dy/2],'HorizontalAlignment','center','String','');
%simulator
cnfdata.handles.GetSimulator=uicontrol('Style','PushButton','units', 'centimeters', ...
        'ToolTipString','Acquire configuration from Simulator','BackGroundColor',[1 1 1],...
        'Position',[x0+0.5*dx,y0-12*dely,1.2*dx,dy/2],'HorizontalAlignment','center','String','Simulator',...
        'Callback','configgui(''GetSimulatorConfig'')');
cnfdata.handles.GetSimulatorTime=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+2.0*dx,y0-12*dely,3.0*dx,dy/2],'HorizontalAlignment','center','String','');

%Set Configuration
uicontrol('Style','text','units', 'centimeters','FontWeight','demi', ...
        'Position',[x0+6.5*dx,y0-7*dely,3*dx,dy/2],'HorizontalAlignment','left','String','Set Configuration to: ');
%machine
uicontrol('Style','PushButton','units', 'centimeters', ...
        'ToolTipString','Load configuration to Machine (only selected families)','BackGroundColor',[1 1 1],...
        'Position',[x0+6.5*dx,y0-8*dely,1.2*dx,dy/2],'HorizontalAlignment','center','String','Machine',...
        'Callback','configgui(''SetMachineConfig'')');
cnfdata.handles.LoadMachineTime=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+8.0*dx,y0-8*dely,3.0*dx,dy/2],'HorizontalAlignment','center','String','');

%desired setpoints
uicontrol('Style','PushButton','units', 'centimeters', ...
        'ToolTipString','Load configuration to Desired Setpoints (SPEAR 3, only selected families)','BackGroundColor',[1 1 1],...
        'Position',[x0+6.5*dx,y0-9*dely,1.2*dx,dy/2],'HorizontalAlignment','center','String','Desired',...
        'Callback','configgui(''SetDesiredConfig'')');
cnfdata.handles.LoadDesiredTime=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+8.0*dx,y0-9*dely,3.0*dx,dy/2],'HorizontalAlignment','center','String','');

%file
uicontrol('Style','PushButton','units', 'centimeters', ...
        'ToolTipString','Write configuration to file (all families)','BackGroundColor',[1 1 1],...
        'Position',[x0+6.5*dx,y0-10*dely,1.2*dx,dy/2],'HorizontalAlignment','center','String','File',...
        'Callback','configgui(''SetFileConfig'')');
cnfdata.handles.LoadFileTime=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+8.0*dx,y0-10*dely,3.0*dx,dy/2],'HorizontalAlignment','center','String','');
%golden
uicontrol('Style','PushButton','units', 'centimeters', ...
        'ToolTipString','Write configuration to Golden (all families)','BackGroundColor',[1 1 1],...
        'Position',[x0+6.5*dx,y0-11*dely,1.2*dx,dy/2],'HorizontalAlignment','center','String','Golden',...
        'Callback','configgui(''SetGoldenConfig'')');
cnfdata.handles.LoadGoldenTime=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+8.0*dx,y0-11*dely,3.0*dx,dy/2],'HorizontalAlignment','center','String','');
%simulator
uicontrol('Style','PushButton','units', 'centimeters', ...
        'ToolTipString','Load configuration to Simulator (only selected families)','BackGroundColor',[1 1 1],...
        'Position',[x0+6.5*dx,y0-12*dely,1.2*dx,dy/2],'HorizontalAlignment','center','String','Simulator',...
        'Callback','configgui(''SetSimulatorConfig'')');
cnfdata.handles.LoadSimulatorTime=uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0+8.0*dx,y0-12*dely,3.0*dx,dy/2],'HorizontalAlignment','center','String','');
    
setappdata(h,'configguidata',cnfdata);

%============================================================
case 'CheckValid'
%============================================================
val=get(gcbo,'Value');
if val==1
    family=get(gcbo,'String');
    if get(cnfdata.handles.([family 'flag']),'BackGroundColor')==[1 0 0];  %red
          set(gcbo,'Value',0);
    end
end

%============================================================
case 'GetMachineConfig'
%============================================================
% get configuration from Machine

cnfdata.SetpointData=[];
cnfdata.MonitorData=[];

[cnfdata.SetpointData,cnfdata.MonitorData]=getmachineconfig('online');

setappdata(h,'configguidata',cnfdata);

configgui('ShowActiveFamilies');
configgui('ShowLastGet');

set(cnfdata.handles.GetMachineTime,'String',datestr(now,0));
set(cnfdata.handles.configname,'String', 'Machine Configuration');
configgui('LBox',' Get Configuration from Machine ');

%============================================================
case 'GetDesiredConfig'
%============================================================
% get configuration from Desired Setpoints (SPEAR 3)

%get configuration from machine
configgui('GetMachineConfig');
cnfdata=getappdata(h,'configguidata');

%load Desired values into Data field
ao=getao;
for k=1:length(cnfdata.families)
    family=cnfdata.families{k};
    if isfield(ao.(family),'Desired');
    cnfdata.SetpointData.(family).Data=getpv(family,'Desired',[]);
    cnfdata.MonitorData.(family).Data=cnfdata.SetpointData.(family).Data;
    end
end

setappdata(h,'configguidata',cnfdata);

configgui('ShowActiveFamilies');
configgui('ShowLastGet');


set(cnfdata.handles.configname,'String', 'Desired Setpoint Configuration');
set(cnfdata.handles.GetDesiredTime,'String',datestr(now,0));
configgui('LBox',' Load Desired Setpoints into Machine Configuration');

%============================================================
case 'GetFileConfig'
%============================================================
%load configuration file via browser


DirSpec   =  getfamilydata('Directory','ConfigData');           %default to Configuration data directory
FileName  =  [];                                %no default file
[FileName, DirSpec,FilterIndex]=uigetfile('*.mat','Select Configuration File',[DirSpec FileName]);
FileSpec=[DirSpec FileName];

try
cnf=load([DirSpec FileName]);          %load configuration from archive
catch
return
end

cnfdata.SetpointData=[];
cnfdata.MonitorData=[];

cnfdata.SetpointData=cnf.ConfigSetpoint;
cnfdata.MonitorData =cnf.ConfigMonitor;

set(cnfdata.handles.configname,'String', ['File Configuration: ' FileName]);

setappdata(h,'configguidata',cnfdata);

configgui('ShowActiveFamilies');
configgui('ShowLastGet');


set(cnfdata.handles.GetFileTime,'String',datestr(now,0));
configgui('LBox',' Get Configuration from File ');

%============================================================
case 'GetGoldenConfig'
%============================================================
% get configuration from Golden File (PhysData)
cnfdata.SetpointData=[];
cnfdata.MonitorData=[];

FileName = getfamilydata('OpsData', 'LatticeFile');
DirectoryName = getfamilydata('Directory', 'OpsData');
cnf=load([DirectoryName FileName]);

cnfdata.SetpointData=cnf.ConfigSetpoint;
cnfdata.MonitorData =cnf.ConfigMonitor;

setappdata(h,'configguidata',cnfdata);

configgui('ShowActiveFamilies');
configgui('ShowLastGet');


set(cnfdata.handles.configname,'String', 'File Configuration: Golden');
set(cnfdata.handles.GetGoldenTime,'String',datestr(now,0));
configgui('LBox',' Get Golden Configuration ');

%============================================================
case 'GetSimulatorConfig'
%============================================================
% get configuration from Simulator
cnfdata.SetpointData=[];
cnfdata.MonitorData=[];
[cnfdata.SetpointData,cnfdata.MonitorData]=getmachineconfig('simulator');

setappdata(h,'configguidata',cnfdata);

configgui('ShowActiveFamilies');
configgui('ShowLastGet');

set(cnfdata.handles.configname,'String', 'Simulator Configuration');
set(cnfdata.handles.GetSimulatorTime,'String',datestr(now,0));
configgui('LBox',' Get Configuration from Simulator ');


%============================================================
case 'ShowLastGet'
%============================================================
%Turn last 'Get' pushbutton green

set(cnfdata.handles.GetMachine,'BackGroundColor',[1 1 1]);
set(cnfdata.handles.GetDesired,'BackGroundColor',[1 1 1]);
set(cnfdata.handles.GetFile,'BackGroundColor',[1 1 1]);
set(cnfdata.handles.GetGolden,'BackGroundColor',[1 1 1]);
set(cnfdata.handles.GetSimulator,'BackGroundColor',[1 1 1]);

set(gcbo,'BackGroundColor','g');

%============================================================
case 'SetMachineConfig'
%============================================================
%Set/Load configuration to machine

if      strcmpi(cnfdata.field,'setpoint')
    cnf=cnfdata.SetpointData;
elseif  strcmpi(cnfdata.field,'monitor')
    cnf=cnfdata.MonitorData;
end

%find which families are active
config=[];
for k=1:length(cnfdata.families)
    family=cnfdata.families{k};
    if get(cnfdata.handles.([family 'chk']),'Value')==1
        config.(family)=cnf.(family);
    end
end

if isempty(config)
    configgui('LBox',' No families loaded Online ');
    return
end
    

setmachineconfig(config,'online');

set(cnfdata.handles.LoadMachineTime,'String',datestr(now,0));
configgui('LBox',' Load Configuration to Machine ');

%============================================================
case 'SetDesiredConfig'
%============================================================
%Set configuration to Desired Setpoints (SPEAR 3 application)

for k=1:length(cnfdata.families)
   family=cnfdata.families{k};
   val=get(cnfdata.handles.([family 'chk']),'Value');
   if val==1
       DeviceList=family2dev(family);
       Desired=cnfdata.SetpointData.(family).Data;
       setpv(family,'Desired',Desired,DeviceList);
   end
end

set(cnfdata.handles.LoadDesiredTime,'String',datestr(now,0));
configgui('LBox',' Load Configuration to Desired Setpoints');

%============================================================
case 'SetFileConfig'
%============================================================
%Set/Write configuration to file
    % Determine file and directory name
        FileName = getfamilydata('Default','CNFArchiveFile');
        DirectoryName = getfamilydata('Directory','ConfigData');
        FileName = appendtimestamp(FileName, clock);
        [FileName, DirectoryName] = uiputfile('*.mat','Save Lattice to ...', [DirectoryName FileName]);
        if FileName == 0 
            fprintf('   File not saved (getmachineconfig)\n');
            return;
        end
    
    % Save all data in structure to file
    DirStart = pwd;
    [DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);  
    ConfigSetpoint=cnfdata.SetpointData;
    ConfigMonitor=cnfdata.MonitorData;
    try
    save(FileName, 'ConfigSetpoint', 'ConfigMonitor');
    catch
    cd(DirStart);
    return
    end
    cd(DirStart);

set(cnfdata.handles.LoadFileTime,'String',datestr(now,0));
configgui('LBox',' Write Configuration to File ');

%============================================================
case 'SetGoldenConfig'
%============================================================
%Set/Write configuration to Golden

        FileName = getfamilydata('OpsData','LatticeFile');
        DirectoryName = getfamilydata('Directory','OpsData');
        AnswerString = questdlg(strvcat('Are you sure you want to overwrite the default lattice file?',sprintf('File: %s',[DirectoryName FileName])),'Default Lattice','Yes','No','No');
        if strcmp(AnswerString,'Yes')
            [DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);
            FileName = getfamilydata('OpsData', 'LatticeFile');
            DirectoryName = getfamilydata('Directory', 'OpsData');
            ConfigSetpoint=cnfdata.SetpointData;
            ConfigMonitor=cnfdata.MonitorData;
            save(FileName, 'ConfigMonitor', 'ConfigSetpoint');
        else
            fprintf('   File not saved (getmachineconfig)\n');
            return;
        end

set(cnfdata.handles.LoadGoldenTime,'String',datestr(now,0));
configgui('LBox',' Write Configuration to Golden ');


%============================================================
case 'SetSimulatorConfig'
%============================================================
%Set/Load configuration to simulator

%find which families are active
families=[];
for k=1:length(cnfdata.families)
    family=cnfdata.families{k};
    if get(cnfdata.handles.([family 'chk']),'Value')==1
        families.(['f' num2str(k)])=family;
    end
end

if isempty(families)
    configgui('LBox',' No families loaded to Simulator ');
    return
else
families=struct2cell(families);
end
    
if      strcmpi(cnfdata.field,'setpoint')
    config=cnfdata.SetpointData;
elseif  strcmpi(cnfdata.field,'monitor')
    config=cnfdata.MonitorData;
end

setmachineconfig(families,config,'simulator');

set(cnfdata.handles.LoadSimulatorTime,'String',datestr(now,0));
configgui('LBox',' Load Configuration to Simulator ');

%============================================================
case 'SelectAll'
%============================================================
%select all families for configuration load
for k=1:length(cnfdata.families)
    if get(cnfdata.handles.([cnfdata.families{k} 'flag']),'Userdata')==1;   %contains valid data
       set(cnfdata.handles.([cnfdata.families{k} 'chk']),'Value',1);
    end
end

%============================================================
case 'SelectNone'
%============================================================
%select no families for configuration load
for k=1:length(cnfdata.families)
        set(cnfdata.handles.([cnfdata.families{k} 'chk']),'Value',0);
end

%============================================================
case 'ShowActiveFamilies'
%============================================================
%turn box green for valid families

for k=1:length(cnfdata.families)
set(cnfdata.handles.([cnfdata.families{k} 'flag']),'BackGroundColor','r','Userdata',0);
end

if strcmpi(cnfdata.field,'setpoint');
    if isempty(cnfdata.SetpointData) return; end
    familynames=fieldnames(cnfdata.SetpointData);
elseif strcmpi(cnfdata.field,'monitor');
        if isempty(cnfdata.MonitorData) return; end
familynames=fieldnames(cnfdata.MonitorData);
end

%indicate valid families
for k=1:length(cnfdata.families)
    for l=1:length(familynames)
        if strcmpi(cnfdata.families{k},familynames{l})
            %disp(familynames{l})
            set(cnfdata.handles.([familynames{l} 'flag']),'BackGroundColor','g','Userdata',1);
        end
    end
end

%============================================================
case 'RefreshGUI'
%============================================================
%general refresh callback for sliders and/or edit boxes

%Update Model Kicker Bump Trajectory (dashed red)

%===========================================================
case 'LBox'                          %*** LBox ***
%===========================================================
%load latest sequence of strings into graphical display listbox
comment=varargin{1};
ts = datestr(now,0);
addstr={[ts  ': ' comment]};
str=get(cnfdata.handles.listbox,'String');
str=[str; addstr];
[ione,itwo]=size(str);
nentry=50;
if ione>=nentry                %keep only top entries
str=str(ione-nentry+1:ione,1);
[ione,itwo]=size(str);
end
set(cnfdata.handles.listbox,'String',str,'listboxtop',ione);

%===========================================================
case 'ShowConfiguration'          %*** ShowConfiguration ***
%===========================================================
%display setpoint and monitors for families in cnfdata structure

families=cnfdata.families;

for k=1:length(families)
family=families{k};
if ~isfield(cnfdata.SetpointData,family)   
disp(['   Warning: family not available... ', family]);  
else
 
DeviceList     =family2dev(family);

SetpointPV     =getfamilydata(family,'Setpoint','ChannelNames');
SetpointData   =cnfdata.SetpointData.(family).Data;
PhysicsSetpoint=hw2physics(family,'Setpoint',SetpointData);

MonitorPV      =getfamilydata(family,'Monitor','ChannelNames');
MonitorData    =cnfdata.MonitorData.(family).Data;
PhysicsMonitor =hw2physics(family,'Monitor', MonitorData);

%display hardware values
fprintf('%s\n',['   Family  DeviceList  HWSetpoint PhysicsSetpoint     HWReadback    PhysicsReadback   SP-MON (HW)   SP-MON (Physics)  Setpoint_PV             Monitor_PV']);

  for jj=1:size(DeviceList,1)
    fprintf('%8s    [%2d,%d] %14.5f %14.5f %14.5f %14.5f %14.5f %14.5f %28s %20s\n',...
    family,DeviceList(jj,1),DeviceList(jj,2),SetpointData(jj),PhysicsSetpoint(jj),...
    MonitorData(jj),PhysicsMonitor(jj),SetpointData(jj)-MonitorData(jj),...
    PhysicsSetpoint(jj)-PhysicsMonitor(jj),SetpointPV(jj,:),MonitorPV(jj,:));
  end
  disp(' ');
  
end 

end

%===========================================================
case 'ShowConfiguration_Short'          %*** ShowConfiguration_Short ***
%===========================================================
%display setpoint and monitors for families in cnfdata structure

families=cnfdata.families;
fprintf('%s\n',['   Family     HWSetpoint    PhysicsSetpoint']);

for k=1:length(families)
family=families{k};
if ~isfield(cnfdata.SetpointData,family)   
disp(['   Warning: family not available... ', family]);  
else
 
DeviceList     =family2dev(family);

SetpointPV     =getfamilydata(family,'Setpoint','ChannelNames');
SetpointData   =cnfdata.SetpointData.(family).Data;
PhysicsSetpoint=hw2physics(family,'Setpoint',SetpointData);

MonitorPV      =getfamilydata(family,'Monitor','ChannelNames');
MonitorData    =cnfdata.MonitorData.(family).Data;
PhysicsMonitor =hw2physics(family,'Monitor', MonitorData);

%display hardware values
if ~strcmpi(family,'HCM') & ~strcmpi(family,'VCM')& ~strcmpi(family,'SkewQuad')
   fprintf('%8s  %14.5f %14.5f\n',family,SetpointData(1),PhysicsSetpoint(1));
end
  disp(' ');
  
end 

end
otherwise
disp(['Warning: no CASE found in configgui: ' action]);
disp(action);
end  %end switchyard


