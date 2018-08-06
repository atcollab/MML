function varargout = SRUtil(varargin)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/SRUtil.m 1.3 2007/04/17 16:32:29CST summert Exp  $
% ----------------------------------------------------------------------------------------------
% SRUTIL M-file for SRUtil.fig
%      SRUTIL, by itself, creates a new SRUTIL or raises the existing
%      singleton*.
%
%      H = SRUTIL returns the handle to a new SRUTIL or the handle to
%      the existing singleton*.
%
%      SRUTIL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SRUTIL.M with the given input arguments.
%
%      SRUTIL('Property','Value',...) creates a new SRUTIL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SRUtil_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SRUtil_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SRUtil

% Last Modified by GUIDE v2.5 01-Apr-2005 15:10:26
% ----------------------------------------------------------------------------------------------

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SRUtil_OpeningFcn, ...
                   'gui_OutputFcn',  @SRUtil_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SRUtil is made visible.
function SRUtil_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SRUtil (see VARARGIN)

% Choose default command line output for SRUtil
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.('QFABtn'),'Value', 1);
set(handles.('QFBBtn'),'Value', 1);
set(handles.('QFCBtn'),'Value', 1);
set(handles.('SFBtn'),'Value', 1);
set(handles.('SDBtn'),'Value', 1);
set(handles.('VCMBtn'),'Value', 1);
set(handles.('HCMBtn'),'Value', 1);
set(handles.('BENDBtn'),'Value', 1);

set(handles.('BTSQuadsBtn'),'Value', 1);
set(handles.('BTSBendBtn'),'Value', 1);
set(handles.('BTSSteerBtn'),'Value', 1);
set(handles.('BTSKickBtn'),'Value', 1);
set(handles.('BTSSeptBtn'),'Value', 1);
set(handles.('BTSScrapeBtn'),'Value', 1);
set(handles.('ChicanesBtn'),'Value', 1);


% UIWAIT makes SRUtil wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SRUtil_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SaveCfgBtn.
function SaveCfgBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SaveCfgBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[CfgSet,CfgMon] = getclsconfig('Archive');


% --- Executes on button press in RestoreCfgBtn.
function RestoreCfgBtn_Callback(hObject, eventdata, handles)
% hObject    handle to RestoreCfgBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get config structure
varargin = {};
FileName = 'file';
%if nargin == 0
    % Default file
    %FileName = getfamilydata('Default','CNFArchiveFile');
    DirectoryName = getfamilydata('Directory','ConfigData');
    [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file', DirectoryName);
    if FileName == 0
        fprintf('   No change to lattice (srrestore)');
        return
end
load([DirectoryName FileName]);

FieldNameCell = fieldnames(ConfigSetpoint);

for i = 1:length(FieldNameCell)
    % Set the setpoint
    try
        
        if (strcmpi(FieldNameCell{i}, 'BEND') & get(handles.('BENDBtn'),'Value'))| ...
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
            % Add 100 counts to make sure CA processes the record???
            fprintf('setting %s\n',FieldNameCell{i});
            ConfigSetpoint.(FieldNameCell{i}).Data = ConfigSetpoint.(FieldNameCell{i}).Data + 0;
            setpv(ConfigSetpoint.(FieldNameCell{i}), varargin{:});
            

        end
        if  (strcmpi(FieldNameCell{i}, 'HCM') & get(handles.('HCMBtn'),'Value'))| ...
            (strcmpi(FieldNameCell{i}, 'VCM') & get(handles.('VCMBtn'),'Value')) 
            % Add 100 counts to make sure CA processes the record???
            fprintf('setting %s\n',FieldNameCell{i});
            ConfigSetpoint.(FieldNameCell{i}).Data = ConfigSetpoint.(FieldNameCell{i}).Data + 0;
            for j=1:48
              setpv(FieldNameCell{i},'Setpoint',ConfigSetpoint.(FieldNameCell{i}).Data(j), j);
            end
            
            
        end
    catch
        fprintf('   Trouble with setsp(%s), hence ignored (setmachineconfig)\n', FieldNameCell{i});
    end
end

% --- Executes on button press in PwrSupplyBtn.
function PwrSupplyBtn_Callback(hObject, eventdata, handles)
% hObject    handle to PwrSupplyBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
turnOnPs;

% --- Executes on button press in PlotFamilyBtn.
function PlotFamilyBtn_Callback(hObject, eventdata, handles)
% hObject    handle to PlotFamilyBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotfamily;


% --- Executes on button press in ZeroCrctrsBtn.
function ZeroCrctrsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ZeroCrctrsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setpv('HCM','Setpoint',0);
setpv('VCM','Setpoint',0);


% --- Executes on button press in ShwMachDatBtn.
function ShwMachDatBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ShwMachDatBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showmachinedata;


% --- Executes on button press in cycleMagsBtn.
function cycleMagsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cycleMagsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%cyclemags;


% --- Executes on button press in clsInitBtn.
function clsInitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to clsInitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clsinit;


% --- Executes on button press in QFABtn.
function QFABtn_Callback(hObject, eventdata, handles)
% hObject    handle to QFABtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of QFABtn


% --- Executes on button press in QFBBtn.
function QFBBtn_Callback(hObject, eventdata, handles)
% hObject    handle to QFBBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of QFBBtn


% --- Executes on button press in QFCBtn.
function QFCBtn_Callback(hObject, eventdata, handles)
% hObject    handle to QFCBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of QFCBtn


% --- Executes on button press in SDBtn.
function SDBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SDBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SDBtn


% --- Executes on button press in SFBtn.
function SFBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SFBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SFBtn


% --- Executes on button press in VCMBtn.
function VCMBtn_Callback(hObject, eventdata, handles)
% hObject    handle to VCMBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VCMBtn


% --- Executes on button press in HCMBtn.
function HCMBtn_Callback(hObject, eventdata, handles)
% hObject    handle to HCMBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HCMBtn


% --- Executes on button press in BENDBtn.
function BENDBtn_Callback(hObject, eventdata, handles)
% hObject    handle to BENDBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BENDBtn


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10


% --- Executes on button press in BTSQuadsBtn.
function BTSQuadsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to BTSQuadsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BTSQuadsBtn


% --- Executes on button press in BTSBendBtn.
function BTSBendBtn_Callback(hObject, eventdata, handles)
% hObject    handle to BTSBendBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BTSBendBtn


% --- Executes on button press in BTSSteerBtn.
function BTSSteerBtn_Callback(hObject, eventdata, handles)
% hObject    handle to BTSSteerBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BTSSteerBtn


% --- Executes on button press in BTSSeptBtn.
function BTSSeptBtn_Callback(hObject, eventdata, handles)
% hObject    handle to BTSSeptBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BTSSeptBtn


% --- Executes on button press in BTSKickBtn.
function BTSKickBtn_Callback(hObject, eventdata, handles)
% hObject    handle to BTSKickBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BTSKickBtn


% --- Executes on button press in BTSScrapeBtn.
function BTSScrapeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to BTSScrapeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BTSScrapeBtn


% --- Executes on button press in MonSrCrntBtn.
function MonSrCrntBtn_Callback(hObject, eventdata, handles)
% hObject    handle to MonSrCrntBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
secondsStr = get(handles.('NumSecondsFld'),'String');
clsMonitorSrCurrent(str2num(secondsStr));


% --- Executes during object creation, after setting all properties.
function NumSecondsFld_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumSecondsFld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function NumSecondsFld_Callback(hObject, eventdata, handles)
% hObject    handle to NumSecondsFld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumSecondsFld as text
%        str2double(get(hObject,'String')) returns contents of NumSecondsFld as a double


% --- Executes on button press in SaveOrbitBtn.
function SaveOrbitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SaveOrbitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
orbit=saveOrbitAsTxt;


% --- Executes on button press in QCBtn.
function QCBtn_Callback(hObject, eventdata, handles)
% hObject    handle to QCBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clsLoadQcenterData;



% --- Executes on button press in ChicanesBtn.
function ChicanesBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ChicanesBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ChicanesBtn

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/SRUtil.m  $
% Revision 1.3 2007/04/17 16:32:29CST summert 
% no change
% Revision 1.2 2007/03/02 09:17:43CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------

