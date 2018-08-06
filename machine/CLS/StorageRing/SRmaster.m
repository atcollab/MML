% -------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/SRmaster.m 1.2.1.2 2007/07/06 10:54:48CST Tasha Summers (summert) Exp  $
% -------------------------------------------------------------------------
% 
% SRMASTER M-file for SRmaster.fig
% Re-make and Update of SRUtil May 2007 T.Summers
% -------------------------------------------------------------------------
%
% --- Initialization. -----------------------------------------------------
function varargout = SRmaster(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',mfilename,'gui_Singleton',gui_Singleton, ...
    'gui_OpeningFcn',@SRmaster_OpeningFcn,'gui_OutputFcn', ...
    @SRmaster_OutputFcn,'gui_LayoutFcn',[],'gui_Callback',[]);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before SRmaster is made visible. ----------------------
function SRmaster_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line. --------
function varargout = SRmaster_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in clsInitBtn. -----------------------------
function clsInitBtn_Callback(hObject, eventdata, handles)
clsinit;

% --- Executes on button press in QCBtn. ----------------------------------
function QCBtn_Callback(hObject, eventdata, handles)
clsLoadQcenterData;

% --- Executes on button press in PwrSupplyBtn. ---------------------------
function PwrSupplyBtn_Callback(hObject, eventdata, handles)
turnOnPs; 

% --- Executes on button press in topupBtn. -------------------------------
function topupBtn_Callback(hObject, eventdata, handles)
timeinp = input('Time interval in seconds [30]: ');
if isempty(timeinp)
    timeinp = 30;
end
maxampinp = input('Maximum current in mA [250]: ');
if isempty(maxampinp)
    maxampinp = 250;
end
fprintf('Would work if uncommented! \n');
%timedTopUp(timeinp, maxampinp);

% --- Executes on button press in corcoilBtn. -----------------------------
function corcoilBtn_Callback(hObject, eventdata, handles)
correctorCoils;

% --- Executes on button press in sqcalibBtn. -----------------------------
function sqcalibBtn_Callback(hObject, eventdata, handles)
SQmeasure;

% --- Executes on button press in xsrosrBtn. ------------------------------
function xsrosrBtn_Callback(hObject, eventdata, handles)
% oxsr = questdlg('Using data from which beamline?','Choose beamline',' OSR  ',' XSR  ','Cancel',' XSR  ');
% switch oxsr
%     case ' OSR  '
%         osr;
%     case ' XSR  '
%         whxsr = questdlg('fresnel or look-up?','Choose method','Fresnel','Look-up','Cancel ','Look-up');
%         if whxsr == 'Fresnel'
%             fresnel;
%         elseif whxsr == 'Look-up'
%             flag=0;
%             sigx = input('4-Sigma-X as measured? ');
%             if ~isnumeric(sigx) 
%                 fprintf('Improper data entered \n');
%                 flag=1;
%             end
%             sigy = input('4-Sigma-Y as measured? ');
%             if ~isnumeric(sigy)
%                 fprintf('Improper data entered \n');
%                 flag=1;
%             end
%             if flag==0
%                 fprintf('\n');
%                 xsr(sigx,sigy);
%             end
%         end
%     otherwise
%         fprintf('Cancelled \n');
% end
EmitQe;


% --- Executes on button press in dispdataBtn. ----------------------------
function dispdataBtn_Callback(hObject, eventdata, handles)
DispHardtoPhys;

% --- Executes on button press in bpmtxtBtn.
function bpmtxtBtn_Callback(hObject, eventdata, handles)
BPM2TXT;

% --- Executes on button press in SaveOrbitBtn. ---------------------------
function SaveOrbitBtn_Callback(hObject, eventdata, handles)
orbit=saveOrbitAsTxt;

% --- Executes on button press in quadsBtn. -------------------------------
function quadsBtn_Callback(hObject, eventdata, handles)
quads2;

% --- Executes on button press in dispersionBtn. --------------------------
function dispersionBtn_Callback(hObject, eventdata, handles)
dispersion2;

% --- Executes on button press in chromeBtn. ------------------------------
function chromeBtn_Callback(hObject, eventdata, handles)
chrome;

% --- Executes on button press in SkewQuadBtn. ----------------------------
function SkewQuadBtn_Callback(hObject, eventdata, handles)
setsq;

% --- Executes on button press in PlotFamilyBtn. --------------------------
function PlotFamilyBtn_Callback(hObject, eventdata, handles)
plotfamily;

% --- Executes on button press in clsorbBtn. ------------------------------
function clsorbBtn_Callback(hObject, eventdata, handles)
clsorb;

% --- Radiobuttons for save / restore configurations ----------------------
function QFABtn_Callback(hObject, eventdata, handles)
function QFBBtn_Callback(hObject, eventdata, handles)
function QFCBtn_Callback(hObject, eventdata, handles)
function SDBtn_Callback(hObject, eventdata, handles)
function SFBtn_Callback(hObject, eventdata, handles)
function VCMBtn_Callback(hObject, eventdata, handles)
function HCMBtn_Callback(hObject, eventdata, handles)
function BENDBtn_Callback(hObject, eventdata, handles)
function BTSQuadsBtn_Callback(hObject, eventdata, handles)
function BTSBendBtn_Callback(hObject, eventdata, handles)
function BTSSteerBtn_Callback(hObject, eventdata, handles)
function BTSKickBtn_Callback(hObject, eventdata, handles)
function BTSSeptBtn_Callback(hObject, eventdata, handles)
function BTSScrapeBtn_Callback(hObject, eventdata, handles)
function ChicanesBtn_Callback(hObject, eventdata, handles)

% --- Executes on button press in SaveCfgBtn. -----------------------------
function SaveCfgBtn_Callback(hObject, eventdata, handles)
[CfgSet,CfgMon] = getclsconfig('Archive');

% --- Executes on button press in RestoreCfgBtn. --------------------------
function RestoreCfgBtn_Callback(hObject, eventdata, handles)
varargin = {};
FileName = 'file';
DirectoryName = getfamilydata('Directory','ConfigData');
[FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file', DirectoryName);
if FileName == 0
    fprintf('   No change to lattice (srrestore)');
    return
end
load([DirectoryName FileName]);
FieldNameCell = fieldnames(ConfigSetpoint);
for i = 1:length(FieldNameCell)
    try  % Set the setpoint
        if  (strcmpi(FieldNameCell{i}, 'BEND') & get(handles.('BENDBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'QFA') & get(handles.('QFABtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'QFB') & get(handles.('QFBBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'BTSSEPT') & get(handles.('BTSSeptBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'BTSQUADS') & get(handles.('BTSQuadsBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'BTSBEND') & get(handles.('BTSBendBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'BTSSCRAPE') & get(handles.('BTSSrcapeBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'BTSSTEER') & get(handles.('BTSSteerBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'BTSKICK') & get(handles.('BTSKickBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'SF') & get(handles.('SFBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'SD') & get(handles.('SDBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'CHICANES') & get(handles.('ChicanesBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'QFC') & get(handles.('QFCBtn'),'Value'))
            fprintf('setting %s\n',FieldNameCell{i});
            ConfigSetpoint.(FieldNameCell{i}).Data = ConfigSetpoint.(FieldNameCell{i}).Data;
            setpv(ConfigSetpoint.(FieldNameCell{i}), varargin{:});
        end
        if  (strcmpi(FieldNameCell{i}, 'HCM') & get(handles.('HCMBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'VCM') & get(handles.('VCMBtn'),'Value')) 
            fprintf('setting %s\n',FieldNameCell{i});
            ConfigSetpoint.(FieldNameCell{i}).Data = ConfigSetpoint.(FieldNameCell{i}).Data;
            for j=1:48
              setpv(FieldNameCell{i},'Setpoint',ConfigSetpoint.(FieldNameCell{i}).Data(j), j);
            end         
        end
    catch
        fprintf('   Trouble with setsp(%s), hence ignored (setmachineconfig)\n', FieldNameCell{i});
    end
end

% -------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/SRmaster.m  $
% Revision 1.2.1.2 2007/07/06 10:54:48CST Tasha Summers (summert) 
% 
% Revision 1.2 2007/05/10 13:42:00CST summert 
% 
% Revision 1.1 2007/04/25 13:07:14CST summert 
% Initial revision
% Member added to project e:/Projects/matlab/project.pj
% -------------------------------------------------------------------------


