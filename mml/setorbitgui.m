function varargout = setorbitgui(varargin)
%SETORBITGUI - Orbit correction GUI
%
%  See also setorbit, orbitcorrectionmethods, setorbitdefault, setorbitbump

%  Written by Jacob Pachikara and Greg Portmann


% To do:
% Stop blinking of legends during orbit feedback
% Add ID tune feedforward, etc to setorbit?  (OCS.PreCorrectonFcn, OCS.PostCorrectonFcn)
% Can setorbit working during a ramp?  (ie, check the bend magnet for a change?)


% Last Modified by GUIDE v2.5 09-Jan-2007 11:53:49


% Begin initialization code - DO NOT EDITMENU
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @setorbitgui_OpeningFcn, ...
                   'gui_OutputFcn',  @setorbitgui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDITMENU



% --- Outputs from this function are returned to the command line.
function varargout = setorbitgui_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Outputs from this function are returned to the command line.
function varargout = CloseRequest_Callback(hObject, eventdata, handles) 

RingSetOrbit.RunFlag = -1;
setappdata(0, 'RingSetOrbit', RingSetOrbit);
pause(.1);

delete(handles.figure1);



% --- Executes just before setorbitgui is made visible.
function setorbitgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)7
% varargin   command line arguments to setorbitgui (see VARARGIN)

% Choose default command line output for setorbitgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes setorbitgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


set(handles.RadioButton_Golden,'Value', 1);
set(handles.HorizontalPlane,'Value', 1);
set(handles.VerticalPlane,'Value', 1);
set(handles.ApplyCorrection,'Enable','Off');
set(handles.RemoveCorrection,'Enable','Off');
set(handles.PopUpMenu_Iterations,'Value',1);
set(handles.SaveOrbit,'Enable','Off');
set(handles.RadioButton_Save,'Enable','Off');
set(handles.RadioButton_File,'Enable','Off');
set(handles.SliderCMScaling,'Value',100.0);


% The BPM and CM devices
try
    [BPM, CM, Flags, EVectors] = setorbitsetup;

catch

    Flags{1}.NIter = 3;
    Flags{1}.SVDIndex = [];
    Flags{1}.GoalOrbit = 'Golden';
    Flags{1}.PlaneFlag = 0;

    BPM.BPMxString{1} = sprintf('%s', gethbpmfamily);
    BPM.BPMyString{1} = sprintf('%s', getvbpmfamily);
    BPM.BPMx{1} = getx('Struct');
    BPM.BPMy{1} = gety('Struct');
        
    CM.HCMString{1} = sprintf('%s', gethcmfamily);
    CM.VCMString{1} = sprintf('%s', getvcmfamily);
    CM.HCM{1} = getsp(gethcmfamily, 'Struct');
    CM.VCM{1} = getsp(getvcmfamily, 'Struct');
    
    EVectors = [];
end


% Add number of devices to pulldown lists
for i = 1:length(BPM.BPMxString)
    Data = BPM.BPMx{i};
    if iscell(Data)
        NumberOfDevices = 0;
        for j = 1:length(BPM.BPMxString)
            NumberOfDevices = NumberOfDevices + size(Data{j}.DeviceList,1);
        end
    else
        NumberOfDevices = size(Data.DeviceList,1);
    end
    BPM.BPMxString{i} = sprintf('%s  (%d)', BPM.BPMxString{i}, NumberOfDevices);
end
for i = 1:length(BPM.BPMyString)
    Data = BPM.BPMy{i};
    if iscell(Data)
        NumberOfDevices = 0;
        for j = 1:length(BPM.BPMyString)
            NumberOfDevices = NumberOfDevices + size(Data{j}.DeviceList,1);
        end
    else
        NumberOfDevices = size(Data.DeviceList,1);
    end
    BPM.BPMyString{i} = sprintf('%s  (%d)', BPM.BPMyString{i}, NumberOfDevices);
end
for i = 1:length(CM.HCMString)
    Data = CM.HCM{i};
    if iscell(Data)
        NumberOfDevices = 0;
        for j = 1:length(CM.HCMString)
            NumberOfDevices = NumberOfDevices + size(Data{j}.DeviceList,1);
        end
    else
        NumberOfDevices = size(Data.DeviceList,1);
    end
    CM.HCMString{i} = sprintf('%s  (%d)', CM.HCMString{i}, NumberOfDevices);
end
for i = 1:length(CM.VCMString)
    Data = CM.VCM{i};
    if iscell(Data)
        NumberOfDevices = 0;
        for j = 1:length(CM.VCMString)
            NumberOfDevices = NumberOfDevices + size(Data{j}.DeviceList,1);
        end
    else
        NumberOfDevices = size(Data.DeviceList,1);
    end
    CM.VCMString{i} = sprintf('%s  (%d)', CM.VCMString{i}, NumberOfDevices);
end

% Set pull down strings
set(handles.SelectBPMx, 'String', BPM.BPMxString);
set(handles.SelectBPMy, 'String', BPM.BPMyString);
set(handles.SelectHCM,  'String', CM.HCMString);
set(handles.SelectVCM,  'String', CM.VCMString);

    
% Initialize variables
setappdata(handles.figure1, 'BPMxCell', BPM.BPMx);
setappdata(handles.figure1, 'BPMxCellOriginal', BPM.BPMx);
setappdata(handles.figure1, 'BPMyCell', BPM.BPMy);
setappdata(handles.figure1, 'BPMyCellOriginal', BPM.BPMy);
setappdata(handles.figure1, 'HCMCell', CM.HCM);
setappdata(handles.figure1, 'HCMCellOriginal', CM.HCM);
setappdata(handles.figure1, 'VCMCell', CM.VCM);
setappdata(handles.figure1, 'VCMCellOriginal', CM.VCM);
setappdata(handles.figure1, 'FlagsCell', Flags);
setappdata(handles.figure1, 'EVectors', EVectors);

setappdata(handles.figure1, 'OCS', '');


% Set the edit box equal to the slider value
set(handles.EditCMScaling, 'String', sprintf('%.1f',get(handles.SliderCMScaling,'Value')));


% Resize to less plots
%set(handles.Plots0, 'Checked', 'Off');
%set(handles.Plots3, 'Checked', 'On');
%set(handles.Plots6, 'Checked', 'Off');
FigResize_Callback(hObject, eventdata, handles);


% Update
SelectFlags_Callback(handles.HorizontalPlane, eventdata, handles);


% --------------------------------------------------------------------
function SelectFlags_Callback(hObject, eventdata, handles)
% Plane

% Family = get(hObject,'Tag');
% Family(1:6) = '';
% UpdateFlag = 1;
% if strcmpi(Family, 'BPMx') & ~get(handles.HorizontalPlane, 'Value')
%    UpdateFlag = 0; 
% elseif strcmpi(Family, 'HCM') & ~get(handles.HorizontalPlane, 'Value')
%    UpdateFlag = 0; 
% elseif strcmpi(Family, 'BPMy') & ~get(handles.VerticalPlane, 'Value')
%    UpdateFlag = 0; 
% elseif strcmpi(Family, 'VCM') & ~get(handles.VerticalPlane, 'Value')
%    UpdateFlag = 0; 
% end


% Orbit (Default, can get over written by FlagsCell)
set(handles.RadioButton_Golden, 'Value', 1);
set(handles.RadioButton_Offset, 'Value', 0);
set(handles.RadioButton_File,   'Value', 0);
set(handles.RadioButton_Save,   'Value', 0);


FlagsCell = getappdata(handles.figure1, 'FlagsCell');
if ~isempty(FlagsCell)

    if iscell(FlagsCell)
        i = get(hObject, 'Value');
        if length(FlagsCell) == 1
            Flags = FlagsCell{1};
        else
            Flags = FlagsCell{i};
        end
    else
        Flags = FlagsCell;
    end
    
    % Plane
    %if isfield(Flags, 'PlaneFlag')
    %    if Flags.PlaneFlag == 1
    %        set(handles.HorizontalPlane, 'Value', 1);
    %        set(handles.VerticalPlane,   'Value', 0);
    %    elseif Flags.PlaneFlag == 2
    %        set(handles.HorizontalPlane, 'Value', 0);
    %        set(handles.VerticalPlane,   'Value', 1);
    %    end
    %end

   
    % Orbit
    if isfield(Flags, 'GoalOrbit')
        if strcmpi(Flags.GoalOrbit, 'Golden')
            set(handles.RadioButton_Golden, 'Value', 1);
            set(handles.RadioButton_Offset, 'Value', 0);
            set(handles.RadioButton_File,   'Value', 0);
            set(handles.RadioButton_Save,   'Value', 0);
        elseif strcmpi(Flags.GoalOrbit, 'Offset')
            set(handles.RadioButton_Golden, 'Value', 0);
            set(handles.RadioButton_Offset, 'Value', 1);
            set(handles.RadioButton_File,   'Value', 0);
            set(handles.RadioButton_Save,   'Value', 0);
        end
    end

    % Interations
    if isfield(Flags, 'NIter')
        Flags.NIter = round(Flags.NIter);
        
        if Flags.NIter>15 && Flags.NIter~=Inf
            Flags.NIter = 15;
        end
        if Flags.NIter < 1
            Flags.NIter = 1;
        end
        if Flags.NIter == Inf
            set(handles.PopUpMenu_Iterations, 'Value', 16);
        else
            set(handles.PopUpMenu_Iterations, 'Value', Flags.NIter);
        end
    end
end


% Update the number of SV to use
CalcSVD(handles);


set(handles.GetOrbit,'Enable','On')
if get(handles.HorizontalPlane,'Value') == 1
    set(handles.SelectBPMx, 'Enable', 'On')
    set(handles.SelectHCM,  'Enable', 'On')
else
    set(handles.SelectBPMx, 'Enable', 'Off')
    set(handles.SelectHCM,  'Enable', 'Off')
    if get(handles.VerticalPlane,'Value') == 0
        set(handles.GetOrbit, 'Enable', 'Off')
    end
end

% if get(handles.VerticalPlane,'Value') == 1
%     set(handles.SelectBPMy, 'Enable', 'On')
%     set(handles.SelectVCM,  'Enable', 'On')
% else
%     set(handles.SelectBPMy, 'Enable', 'Off')
%     set(handles.SelectVCM,  'Enable', 'Off')
%     if get(handles.HorizontalPlane,'Value') == 0
%         set(handles.GetOrbit, 'Enable', 'Off')
%     end
% end


% Update the plots
GetOrbit_Callback(hObject, eventdata, handles);

drawnow;





function CalcSVD(handles)
% SVD

SVDStart = str2num(get(handles.Edit_SVD, 'String'));

try
    SVDIndex = 0;
    EVectors = getappdata(handles.figure1, 'EVectors');
    if isstruct(EVectors)
        if get(handles.HorizontalPlane, 'Value') == 1
            SVDIndex = SVDIndex + EVectors.BPMx(get(handles.SelectBPMx,'Value'));
            SVDIndex = SVDIndex + EVectors.HCM(get(handles.SelectHCM,'Value'));
        end
        if get(handles.VerticalPlane, 'Value') == 1
            SVDIndex = SVDIndex + EVectors.BPMy(get(handles.SelectBPMy,'Value'));
            SVDIndex = SVDIndex + EVectors.VCM(get(handles.SelectVCM,'Value'));
        end
    else
        if all(size(EVectors)==[1 1])
            SVDIndex = EVectors;
        else
            SVDIndex = SVDStart;
        end
    end
catch
    SVDIndex = SVDStart;
end

set(handles.Edit_SVD, 'String', num2str(SVDIndex));



% --------------------------------------------------------------------
function HorizontalPlane_Callback(hObject, eventdata, handles)

if get(hObject,'Value')
    set(handles.SelectBPMx, 'Enable', 'On')
    set(handles.SelectHCM,  'Enable', 'On')
    set(handles.GetOrbit,   'Enable', 'On')
else
    set(handles.SelectBPMx, 'Enable', 'Off')
    set(handles.SelectHCM,  'Enable', 'Off')

    % Make sure the RF is out of the fit if the horizontal plane is off
    set(handles.RadioButton_RF, 'Value', 0);
end


if ~get(hObject,'Value') && ~get(handles.VerticalPlane,'Value')
    set(handles.GetOrbit,'Enable','Off')
end

% Update the number of SV to use
CalcSVD(handles);

% Update the plots
GetOrbit_Callback(hObject, eventdata, handles);



% --------------------------------------------------------------------
function VerticalPlane_Callback(hObject, eventdata, handles)

if get(handles.VerticalPlane,'Value')
    set(handles.SelectBPMy, 'Enable', 'On')
    set(handles.SelectVCM,  'Enable', 'On')
    set(handles.GetOrbit,   'Enable', 'On')
else
    set(handles.SelectBPMy, 'Enable', 'Off')
    set(handles.SelectVCM,  'Enable', 'Off')
end

if ~get(hObject,'Value') && ~get(handles.HorizontalPlane,'Value')
    set(handles.GetOrbit,'Enable','Off')
end

% Update the number of SV to use
CalcSVD(handles);

% Update the plots
GetOrbit_Callback(hObject, eventdata, handles);



% --------------------------------------------------------------------
function SliderCMScaling_Callback(hObject, eventdata, handles)
set(handles.EditCMScaling, 'String', sprintf('%.1f',get(handles.SliderCMScaling,'Value')));


% --------------------------------------------------------------------
function EditCMScaling_Callback(hObject, eventdata, handles)
val = str2num(get(handles.EditCMScaling,'String'));
% Determine whether val is a number between 0 and 1
if isnumeric(val) && length(val)==1 && ...
    val >= get(handles.SliderCMScaling,'Min') && ...
    val <= get(handles.SliderCMScaling,'Max')
    set(handles.SliderCMScaling,'Value',val);
end


% --------------------------------------------------------------------
function ScaleCorrectors_Callback(hObject, eventdata, handles)

Gain = get(handles.SliderCMScaling,'Value')/100;

if Gain == 1
    return;
end


% Disable buttons during setpoint change
set(handles.GetOrbit,              'Enable',  'Off');
set(handles.ApplyCorrection,       'Enable',  'Off');
set(handles.RemoveCorrection,      'Enable',  'Off');
set(handles.ScaleCorrectors,       'Enable',  'Off');
set(handles.FileMenu,              'Enable',  'Off');
set(handles.EditMenu,              'Enable',  'Off');
set(handles.LatticeMenu,           'Enable',  'Off');
set(handles.RadioButton_Golden,    'Enable',  'Off');
set(handles.RadioButton_Offset,    'Enable',  'Off');
set(handles.RadioButton_File,      'Enable',  'Off');
set(handles.RadioButton_Save,      'Enable',  'Off');
set(handles.GetFile,               'Enable',  'Off');
set(handles.SaveOrbit,             'Enable',  'Off');
set(handles.Edit_SVD,              'Enable',  'Off');
set(handles.HorizontalPlane,       'Enable',  'Off');
set(handles.VerticalPlane,         'Enable',  'Off');
set(handles.SelectBPMx,            'Enable',  'Off');
set(handles.SelectBPMy,            'Enable',  'Off');
set(handles.SelectHCM,             'Enable',  'Off');
set(handles.SelectVCM,             'Enable',  'Off');
set(handles.PopUpMenu_Iterations,  'Enable',  'Off');
drawnow;


i = 0;
if get(handles.HorizontalPlane,'Value') == 1 
    CMCell = getappdata(handles.figure1, 'HCMCell');
    iCell = get(handles.SelectHCM,'Value');
    Data = CMCell{iCell};
    if iscell(Data)
        % Cells
        for j = 1:length(Data)
            i = i + 1;
            SP{i} = getsp(Data{j}, 'Struct');
        end
    else
        % Data structure
        i = i + 1;
        SP{i} = getsp(Data, 'Struct');
    end
end

if get(handles.VerticalPlane,'Value') == 1
    CMCell = getappdata(handles.figure1, 'VCMCell');
    iCell = get(handles.SelectHCM,'Value');
    Data = CMCell{iCell};
    if iscell(Data)
        % Cells
        for j = 1:length(Data)
            i = i + 1;
            SP{i} = getpv(Data{j}, 'Struct');
        end
    else
        % Data structure
        i = i + 1;
        SP{i} = getpv(Data, 'Struct');
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SaveOrbit the prsent setpoints %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SP_History = getappdata(handles.figure1, 'SP_History');
SPwithRF = SP;
SPwithRF{length(SPwithRF)+1} = getrf('Struct');
SP_History{length(SP_History)+1} = SPwithRF;
setappdata(handles.figure1, 'SP_History', SP_History);
set(handles.RemoveCorrection, 'String', sprintf('Remove Correction %d',length(SP_History)))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set everything again with a wait flag of 0 then -1 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('turnoff','file') == 2
    for i = 1:length(SP)
        turnoff(SP{i}.FamilyName, SP{i}.DeviceList, Gain);
    end
else
    for i = 1:length(SP)
        SP{i}.Data = Gain * SP{i}.Data;
        setpv(SP{i}, 0);
    end
    for i = 1:length(SP)
        setpv(SP{i}, -1);
    end
end

% Get new BPM data and update plots
GetOrbit_Callback(hObject, eventdata, handles);

% Re-enable buttons
set(handles.GetOrbit,              'Enable',  'On');
set(handles.ApplyCorrection,       'Enable',  'On');
set(handles.RemoveCorrection,      'Enable',  'On');
set(handles.ScaleCorrectors,       'Enable',  'On');
set(handles.FileMenu,              'Enable',  'On');
set(handles.EditMenu,              'Enable',  'On');
set(handles.LatticeMenu,           'Enable',  'On');
set(handles.RadioButton_Golden,    'Enable',  'On');
set(handles.RadioButton_Offset,    'Enable',  'On');
set(handles.RadioButton_File,      'Enable',  'On');
set(handles.RadioButton_Save,      'Enable',  'On');
set(handles.GetFile,               'Enable',  'On');
set(handles.SaveOrbit,             'Enable',  'On');
set(handles.Edit_SVD,              'Enable',  'On');
set(handles.HorizontalPlane,       'Enable',  'On');
set(handles.VerticalPlane,         'Enable',  'On');
set(handles.SelectBPMx,            'Enable',  'On');
set(handles.SelectBPMy,            'Enable',  'On');
set(handles.SelectHCM,             'Enable',  'On');
set(handles.SelectVCM,             'Enable',  'On');
set(handles.PopUpMenu_Iterations,  'Enable',  'On');



% --------------------------------------------------------------------
function EditDevice_Callback(hObject, eventdata, handles)
%Family = 'BPMx';
Family = get(hObject,'Tag');
Family(1:4) = '';

DataCell         = getappdata(handles.figure1, [Family, 'Cell']);
DataCellOriginal = getappdata(handles.figure1, [Family, 'CellOriginal']);
iCell = get(handles.(['Select',Family]), 'Value');

Data = DataCell{iCell};
DataOriginal = DataCellOriginal{iCell};
NumberOfDevices = 0;
if iscell(DataOriginal)
    % Cell array
    for i = 1:length(DataOriginal)
        DeviceListTotal = family2dev(DataOriginal{i}.FamilyName);
        %DeviceListTotal = DataOriginal{i}.DeviceList;
        CheckList = zeros(size(DeviceListTotal,1),1);
        iDev = findrowindex(Data{i}.DeviceList, DeviceListTotal);
        CheckList(iDev) = 1;
        Data{i}.DeviceList = editlist(DeviceListTotal, Data{i}.FamilyName, CheckList);
        NumberOfDevices = NumberOfDevices + size(Data{i}.DeviceList,1);
    end
else
    % Data structure
    DeviceListTotal = family2dev(DataOriginal.FamilyName);
    %DeviceListTotal = DataOriginal.DeviceList;
    CheckList = zeros(size(DeviceListTotal,1),1);
    iDev = findrowindex(Data.DeviceList, DeviceListTotal);
    CheckList(iDev) = 1;
    Data.DeviceList = editlist(DeviceListTotal, Data.FamilyName, CheckList);
    NumberOfDevices = NumberOfDevices + size(Data.DeviceList,1);
end

DataCell{iCell} = Data;
setappdata(handles.figure1, [Family, 'Cell'], DataCell);

% Change the number of devices in the pulldown string 
try
    StringCell = get(handles.(['Select',Family]), 'String');
    TitleString = StringCell{iCell};
    i = findstr(TitleString,'(');
    if ~isempty(i)
        TitleString = sprintf('%s  (%d)', TitleString(1:i(end)-1), NumberOfDevices);
        StringCell{iCell} = TitleString;
        set(handles.(['Select',Family]), 'String', StringCell);
    end
catch
end

GetOrbit_Callback(hObject, eventdata, handles);



% --------------------------------------------------------------------
function GetOrbit_Callback(hObject, eventdata, handles)
% setorbit(goalorbit,getx('Struct'),getsp('HCM','struct'),'NoSetSP','FigureHandles',[handles.axes1;handles.axes2;handles.axes3]);

RemoveCorrectionEnable = get(handles.RemoveCorrection, 'Enable');
set(handles.MinimumPeriod,    'Enable', 'Off');
set(handles.RemoveCorrection, 'Enable', 'Off');
set(handles.ApplyCorrection,  'Enable', 'Off');
set(handles.GetOrbit,         'Enable', 'Off');
drawnow;


OCS = getappdata(handles.figure1, 'OCS');
OCS.BPM       = [];
OCS.BPMWeight = [];
OCS.CM        = [];
OCS.CMWeight  = [];
OCS.Eta       = [];


i = 0;
if get(handles.HorizontalPlane,'Value') == 1 
    i = i + 1;

    BPMCell = getappdata(handles.figure1, 'BPMxCell');
    j = get(handles.SelectBPMx,'Value');
    if iscell(BPMCell{j})
        OCS.BPM = BPMCell{j};
    else
        OCS.BPM{i} = BPMCell{j};
    end

    CMCell = getappdata(handles.figure1, 'HCMCell');
    j = get(handles.SelectHCM,'Value');
    if iscell(CMCell{j})
        OCS.CM = CMCell{j};
    else
        OCS.CM{i} = CMCell{j};
    end

    % Use default column weights
    OCS.CMWeight{i} = [];
end

if get(handles.VerticalPlane,'Value') == 1
    i = i + 1;

    BPMCell = getappdata(handles.figure1, 'BPMyCell');
    j = get(handles.SelectBPMy,'Value');
    if iscell(BPMCell{j})
        OCS.BPM = [OCS.BPM BPMCell{j}];
    else
        OCS.BPM{i} = BPMCell{j};
    end
    
    CMCell = getappdata(handles.figure1, 'VCMCell');
    j = get(handles.SelectVCM,'Value');   
    if iscell(CMCell{j})
        OCS.CM = [OCS.CM CMCell{j}];
    else
        OCS.CM{i} = CMCell{j};
    end

    % Use default column weights
    OCS.CMWeight{i} = [];
end

if i==0
    return;
end


%%%%%%%%%%%%%%%%%%%%%%%
% Find the goal orbit %
%%%%%%%%%%%%%%%%%%%%%%%

% Goal orbit: golden orbit 
if get(handles.RadioButton_Golden,'Value') == 1 
    OCS.GoalOrbit = 'Golden';
end

% Goal orbit: offset orbit
if get(handles.RadioButton_Offset,'Value') == 1 
    OCS.GoalOrbit = 'Offset';
end

% Goal orbit: saved orbit 
if get(handles.RadioButton_Save,'Value') == 1
    OCS.GoalOrbit = [];
    bpmsave = getappdata(handles.figure1,'bpmsave');
    ErrorFlag = 0;
    for i = 1:length(OCS.BPM)
        for j = 1:length(bpmsave)
            if strcmp(OCS.BPM{i}.FamilyName, bpmsave{j}.FamilyName)
                [k, iNotFound] = findrowindex(OCS.BPM{i}.DeviceList, bpmsave{j}.DeviceList);
                if isempty(iNotFound)
                    OCS.GoalOrbit{i} = bpmsave{j}.Data(k);
                else
                    uiwait(warndlg({'BPMs not found in the save!','Setting the goal orbit to the golden orbit.'},'SETORBIT','Modal'));
                    set(handles.RadioButton_Golden,'Value', 1)
                    set(handles.RadioButton_Save,'Value', 0)
                    OCS.GoalOrbit = 'golden';
                    ErrorFlag = 1;
                    break;
                end
            end
        end
        if ErrorFlag
            break;
        end
    end
end

% Goal orbit from file
if get(handles.RadioButton_File,'Value') == 1
    FileName = getappdata(handles.figure1, 'FileName');
    OCS.GoalOrbit = [];
    for i = 1:length(OCS.BPM)
        OCS.GoalOrbit{i} = getdata(OCS.BPM{i}, FileName, 'Numeric');
        if any(isnan(OCS.GoalOrbit{i}))
            uiwait(warndlg({'BPMs not found in the file!','Setting the goal orbit to the golden orbit.'},'SETORBIT','Modal'));
            set(handles.RadioButton_Golden,'Value', 1)
            set(handles.RadioButton_Save,'Value', 0)
            OCS.GoalOrbit = 'golden';
            break;
        end
    end
end

OCS.SVDIndex = str2num(get(handles.Edit_SVD,'String'));


% Remove flags for now
if isfield(OCS, 'BPMWeight')
    OCS = rmfield(OCS, 'BPMWeight');
end


% RF flag
if get(handles.RadioButton_RF,'Value') == 1
    OCS.FitRF = 1;
else
    OCS.FitRF = 0;
end


% Update the BPM, CM, and RF
for i = 1:length(OCS.BPM)
    OCS.BPM{i} = getpv(OCS.BPM{i});
end
for i = 1:length(OCS.CM)
    OCS.CM{i} = getpv(OCS.CM{i});
end
OCS.RF = getrf('Struct');


% Iterations
NIter = get(handles.PopUpMenu_Iterations,'Value');
if NIter == 16
    NIter = Inf;
end
OCS.NIter = NIter;


% Update plots
OCS.Handles.TimeStamp = handles.GetOrbit;
setappdata(handles.figure1,'OCS',OCS);
UpdatePlots(handles);
OCS = getappdata(handles.figure1, 'OCS');

set(handles.ApplyCorrection, 'String', 'Apply Correction');
set(handles.GetOrbit,        'String', sprintf('Get Orbit: %s',datestr(OCS.BPM{1}.TimeStamp,0)),'FontSize',9.0);
set(handles.GetOrbit,         'Enable', 'On');
set(handles.MinimumPeriod,    'Enable', 'On');
set(handles.ApplyCorrection,  'Enable', 'On');
set(handles.SaveOrbit,        'Enable', 'On');
set(handles.RemoveCorrection, 'Enable', RemoveCorrectionEnable);



% --------------------------------------------------------------------
function StopCorrection_Callback(hObject, eventdata, handles)
% Stop corrector goes to the matlab command window
RingSetOrbit.RunFlag = -1;
setappdata(0, 'RingSetOrbit', RingSetOrbit);


% --------------------------------------------------------------------
function ApplyCorrection_Callback(hObject, eventdata, handles)

set(handles.figure1, 'HandleVisibility','Callback');


RingSetOrbit.RunFlag = 1;
setappdata(0, 'RingSetOrbit', RingSetOrbit);

OCS = getappdata(handles.figure1, 'OCS');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SaveOrbit the present setpoints %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CM = OCS.CM;
CM{length(CM)+1} = OCS.RF;
SP_History = getappdata(handles.figure1, 'SP_History');
SP_History{length(SP_History)+1} = CM;
setappdata(handles.figure1, 'SP_History', SP_History);
set(handles.RemoveCorrection, 'String', sprintf('Remove Correction %d',length(SP_History)))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make the corrector starting with the present OCS setpoints %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.FileMenu,              'Enable',  'Off');
set(handles.EditBPMx,              'Enable',  'Off');
set(handles.EditBPMy,              'Enable',  'Off');
set(handles.EditHCM,               'Enable',  'Off');
set(handles.EditVCM,               'Enable',  'Off');
set(handles.LatticeMenu,           'Enable',  'Off');
set(handles.RadioButton_Golden,    'Enable',  'Off');
set(handles.RadioButton_Offset,    'Enable',  'Off');
set(handles.RadioButton_File,      'Enable',  'Off');
set(handles.RadioButton_Save,      'Enable',  'Off');
set(handles.GetFile,               'Enable',  'Off');
set(handles.SaveOrbit,             'Enable',  'Off');
set(handles.Edit_SVD,              'Enable',  'Off');
set(handles.HorizontalPlane,       'Enable',  'Off');
set(handles.VerticalPlane,         'Enable',  'Off');
set(handles.SelectBPMx,            'Enable',  'Off');
set(handles.SelectBPMy,            'Enable',  'Off');
set(handles.SelectHCM,             'Enable',  'Off');
set(handles.SelectVCM,             'Enable',  'Off');
set(handles.PopUpMenu_Iterations,  'Enable',  'Off');
set(handles.ScaleCorrectors,       'Enable',  'Off');
set(handles.GetOrbit,              'Enable',  'Off');
set(handles.RemoveCorrection,      'Enable',  'Off');


NIter = get(handles.PopUpMenu_Iterations,'Value');
if NIter == 16
    NIter = Inf;
end
OCS.NIter = NIter;
if NIter > 1
    set(handles.GetOrbit,         'String',  'GetOrbit');
    set(handles.ApplyCorrection,  'Enable',  'Off');
    set(handles.ApplyCorrection,  'Visible', 'Off');
    set(handles.StopCorrection,   'Enable',  'On');
    set(handles.StopCorrection,   'Visible', 'On');
else
    set(handles.ApplyCorrection,  'Enable',  'Off');
end
drawnow;


% MinimumPeriodString = get(handles.MinimumPeriod,'String');
% if isempty(MinimumPeriodString)
%     OCS.MinimumPeriod = [];
% else
%     OCS.MinimumPeriod = str2num(MinimumPeriodString);
% end
% if isempty(OCS.MinimumPeriod) || OCS.MinimumPeriod < 0
%     OCS.MinimumPeriod = 0;
% end


AxesHandles = [handles.axes1;handles.axes2;handles.axes3;];
if strcmpi(get(handles.Plots0,'Checked'),'On')
    OCS = setorbit(OCS, 'NoGetPV', 'NoDisplay');
else
    if strcmpi(get(handles.Plots6,'Checked'),'On')
        % Only update 6 plots if GetOrbit was not already called
        if isempty(findstr(get(get(handles.axes3,'YLabel'),'String'),'Residual'))
            AxesHandles = [handles.axes1;handles.axes2;handles.axes3;handles.axes4;handles.axes5;handles.axes6;];
        end
    end
    OCS = setorbit(OCS, 'NoGetPV', 'FigureHandles', AxesHandles);
end

try
    % If the figure was closed then handles is on longer valie
    setappdata(handles.figure1, 'OCS', OCS);


    %%%%%%%%%%%%%%%%%
    % Update figure %
    %%%%%%%%%%%%%%%%%
    set(handles.FileMenu,              'Enable',  'On');
    set(handles.EditBPMx,              'Enable',  'On');
    set(handles.EditBPMy,              'Enable',  'On');
    set(handles.EditHCM,               'Enable',  'On');
    set(handles.EditVCM,               'Enable',  'On');
    set(handles.LatticeMenu,           'Enable',  'On');
    set(handles.RadioButton_Golden,    'Enable',  'On');
    set(handles.RadioButton_Offset,    'Enable',  'On');
    set(handles.RadioButton_File,      'Enable',  'On');
    set(handles.RadioButton_Save,      'Enable',  'On');
    set(handles.GetFile,               'Enable',  'On');
    set(handles.SaveOrbit,             'Enable',  'On');
    set(handles.Edit_SVD,              'Enable',  'On');
    set(handles.HorizontalPlane,       'Enable',  'On');
    set(handles.VerticalPlane,         'Enable',  'On');
    set(handles.SelectBPMx,            'Enable',  'On');
    set(handles.SelectBPMy,            'Enable',  'On');
    set(handles.SelectHCM,             'Enable',  'On');
    set(handles.SelectVCM,             'Enable',  'On');
    set(handles.PopUpMenu_Iterations,  'Enable',  'On');
    set(handles.ScaleCorrectors,       'Enable',  'On');
    set(handles.RemoveCorrection,      'Enable',  'On');

    set(handles.StopCorrection,   'Visible', 'Off');
    set(handles.StopCorrection,   'Enable',  'Off');

    set(handles.ApplyCorrection,  'Visible', 'On');
    set(handles.ApplyCorrection,  'Enable',  'On');

    set(handles.GetOrbit,         'Enable',  'On');
    set(handles.GetOrbit,         'String', sprintf('Get Orbit: %s',datestr(OCS.BPM{1}.TimeStamp,0)),'FontSize',9.0);
    drawnow;
catch
end


set(handles.figure1, 'HandleVisibility','Off');



% --------------------------------------------------------------------
function RemoveCorrection_Callback(hObject, eventdata, handles)
CM = getappdata(handles.figure1, 'SP_History');
if ~isempty(CM)

    set(handles.GetOrbit,         'Enable', 'Off');
    set(handles.ApplyCorrection,  'Enable', 'Off');
    set(handles.RemoveCorrection, 'Enable', 'Off');
    drawnow;

    % Set (note: RF could be one the CM structures)
    CMlast = CM{end};
    for i = 1:length(CMlast)
        setpv(CMlast{i},  0);
    end
    for i = 1:length(CMlast)
        setpv(CMlast{i}, -1);
    end
    
    % Remove the last set
    CM(end) = [];
    setappdata(handles.figure1, 'SP_History', CM);

    % Get new BPM data and update plots
    GetOrbit_Callback(hObject, eventdata, handles);

    if isempty(CM)
        set(handles.RemoveCorrection, 'Enable', 'Off');
        set(handles.RemoveCorrection, 'String', 'Remove Correction');
    else
        set(handles.RemoveCorrection, 'Enable', 'On');
        set(handles.RemoveCorrection, 'String', sprintf('Remove Correction %d',length(CM)));
    end
    drawnow;
end



% --------------------------------------------------------------------
function GetFile_Callback(hObject, eventdata, handles)

DirectoryName = getfamilydata('Directory','DataRoot');
[FileName, DirectoryName] = uigetfile('*.mat', 'Select a File', DirectoryName);
if FileName == 0 
    return
end
setappdata(handles.figure1, 'FileName', [DirectoryName FileName]);
set(handles.GetFile, 'String', sprintf('File:%s', FileName), 'FontSize', 8.0);
set(handles.RadioButton_File,'Enable','On');


% % Automatically set the filemenu radio button
% set(handles.RadioButton_File,'Value', 1);
% RadioButton_File_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function RadioButton_Offset_Callback(hObject, eventdata, handles)
set(handles.RadioButton_Golden,'Value', 0);
set(handles.RadioButton_File,'Value', 0);
set(handles.RadioButton_Save,'Value', 0);
set(handles.RadioButton_Offset,'Value', 1);

OCS = getappdata(handles.figure1, 'OCS');
if ~isfield(OCS,'BPM')
    return;
end
OCS.GoalOrbit = 'Offset';

% Update plots
setappdata(handles.figure1,'OCS',OCS);
UpdatePlots(handles);



% --------------------------------------------------------------------
function RadioButton_Golden_Callback(hObject, eventdata, handles)
set(handles.RadioButton_Offset,'Value', 0);
set(handles.RadioButton_File,'Value', 0);
set(handles.RadioButton_Save,'Value', 0);
set(handles.RadioButton_Golden,'Value', 1);

OCS = getappdata(handles.figure1, 'OCS');
if ~isfield(OCS,'BPM')
    return;
end
OCS.GoalOrbit = 'Golden';

% Update plots
setappdata(handles.figure1,'OCS',OCS);
UpdatePlots(handles);



% --------------------------------------------------------------------
function RadioButton_File_Callback(hObject, eventdata, handles)
set(handles.RadioButton_Offset,'Value', 0);
set(handles.RadioButton_File,'Value', 1);
set(handles.RadioButton_Save,'Value', 0);
set(handles.RadioButton_Golden,'Value', 0);

OCS = getappdata(handles.figure1,'OCS');
if ~isfield(OCS,'BPM')
    return;
end
FileName = getappdata(handles.figure1, 'FileName');
OCS.GoalOrbit = [];
for i = 1:length(OCS.BPM)
    OCS.GoalOrbit{i} = getdata(OCS.BPM{i}, FileName, 'Numeric');
    if any(isnan(OCS.GoalOrbit{i}))
        uiwait(warndlg({'BPMs not found in the file!','Setting the goal orbit to the golden orbit.'},'SETORBIT','Modal'));
        set(handles.RadioButton_Golden,'Value', 1)
        set(handles.RadioButton_File,'Value', 0)
            OCS.GoalOrbit = 'golden';
            break;
    end
end

setappdata(handles.figure1,'OCS',OCS);

% Update plots
UpdatePlots(handles);



% --------------------------------------------------------------------
function RadioButton_Save_Callback(hObject, eventdata, handles)
set(handles.RadioButton_Golden,'Value', 0);           
set(handles.RadioButton_File,'Value', 0);
set(handles.RadioButton_Offset,'Value', 0);
set(handles.RadioButton_Save,'Value', 1);

OCS = getappdata(handles.figure1,'OCS');
if ~isfield(OCS,'BPM')
    return;
end
OCS.GoalOrbit = [];
bpmsave = getappdata(handles.figure1,'bpmsave');
ErrorFlag = 0;
for i = 1:length(OCS.BPM)
    for j = 1:length(bpmsave)
        if strcmp(OCS.BPM{i}.FamilyName, bpmsave{j}.FamilyName)
            [k, iNotFound] = findrowindex(OCS.BPM{i}.DeviceList, bpmsave{j}.DeviceList);
            if isempty(iNotFound)
                OCS.GoalOrbit{i} = bpmsave{j}.Data(k);
            else
                uiwait(warndlg({'BPMs not found in the save!','Setting the goal orbit to the golden orbit.'},'SETORBIT','Modal'));
                set(handles.RadioButton_Golden,'Value', 1)
                set(handles.RadioButton_Save,'Value', 0)
                OCS.GoalOrbit = 'golden';
                ErrorFlag = 1;
                break;
            end
        end
    end
    if ErrorFlag
        break;
    end
end

setappdata(handles.figure1,'OCS',OCS);

% Update plots
UpdatePlots(handles);


% --------------------------------------------------------------------
function SaveOrbit_Callback(hObject, eventdata, handles)

OCS = getappdata(handles.figure1, 'OCS');
set(handles.SaveOrbit,'String', sprintf('Save: %s',datestr(OCS.CM{1}.TimeStamp,0)),'FontSize',9.0);
bpmsave = OCS.BPM;
setappdata(handles.figure1,'bpmsave',bpmsave);

if get(handles.RadioButton_Save,'Value') == 1                      
    RadioButton_Save_Callback(hObject, eventdata, handles);                                                         
end                                                           
set(handles.RadioButton_Save,'Enable','On');
% set(handles.SaveOrbit,'Enable','Off');

% % Automatically set the save radio button
% set(handles.RadioButton_Save,'Value', 1);
% RadioButton_Save_Callback(hObject, eventdata, handles);



% --------------------------------------------------------------------
function SaveOrbitToFile_Callback(hObject, eventdata, handles)

OCS = getappdata(handles.figure1, 'OCS');
BPMData = OCS.BPM;

DirStart = pwd;
FileName = appendtimestamp('BPMData', BPMData{1}.TimeStamp);
DirectoryName = getfamilydata('Directory', 'DataRoot');
[FileName, DirectoryName] = uiputfile('*.mat', 'Select File (Cancel to not save to a file)', [DirectoryName FileName, '.mat']);
if FileName == 0
    return
end

[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
save(FileName, 'BPMData');
cd(DirStart);
fprintf('   BPM data saved to %s\n', [DirectoryName FileName]);


% --------------------------------------------------------------------
function SaveOCS_Callback(hObject, eventdata, handles)
OCS = getappdata(handles.figure1, 'OCS');

DirStart = pwd;
FileName = appendtimestamp('OCS', OCS.BPM{1}.TimeStamp);
DirectoryName = getfamilydata('Directory', 'DataRoot');
[FileName, DirectoryName] = uiputfile('*.mat', 'Select File (Cancel to not save to a file)', [DirectoryName FileName, '.mat']);
if FileName == 0
    return
end

[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
save(FileName, 'OCS');
cd(DirStart);
fprintf('   OCS structure saved to %s\n', [DirectoryName FileName]);




%%%%%%%%%%%%%
% Pop Plots %
%%%%%%%%%%%%%
function Graph_1_Callback(hObject, eventdata, handles)
a = figure;
b = copyobj(handles.axes1, a); 
set(b, 'Position', [0.1300    0.1100    0.7750    .93*0.8150]);

function Graph_2_Callback(hObject, eventdata, handles)
a = figure;
b = copyobj(handles.axes2, a); 
set(b, 'Position', [0.1300    0.1100    0.7750    0.8150]);

function Graph_3_Callback(hObject, eventdata, handles)
a = figure;
b = copyobj(handles.axes3, a); 
set(b, 'Position', [0.1300    0.1100    0.7750    0.8150]);

function Graph_4_Callback(hObject, eventdata, handles)
a = figure;
b = copyobj(handles.axes4, a); 
set(b, 'Position', [0.1300    0.1100    0.7750    .93*0.8150]);

function Graph_5_Callback(hObject, eventdata, handles)
a = figure;
b = copyobj(handles.axes5, a); 
set(b, 'Position', [0.1300    0.1100    0.7750    0.8150]);

function Graph_6_Callback(hObject, eventdata, handles)
a = figure;
b = copyobj(handles.axes6, a); 
set(b, 'Position', [0.1300    0.1100    0.7750    0.8150]);


function All_Graphs_Callback(hObject, eventdata, handles)
if strcmpi(get(handles.Plots3,'Checked'),'On')
    a = figure;
    b = copyobj(handles.axes1, a);
    set(b, 'Position', [0.1300    0.7093    0.7750    0.2157]);

    b = copyobj(handles.axes2, a);
    set(b, 'Position', [0.1300    0.4096    0.7750    0.2157]);

    b = copyobj(handles.axes3, a);
    set(b, 'Position', [0.1300    0.1100    0.7750    0.2157]);
    
    Data = getappdata(handles.figure1, 'OCS');
    if isfield(Data, 'TimeStamp')
        addlabel(1,0,datestr(OCS.CM{1}.TimeStamp,21));
    end
    orient tall
    
elseif strcmpi(get(handles.Plots6,'Checked'),'On')
    a = figure;
    b = copyobj(handles.axes1, a);
    set(b, 'Position', [0.1300    0.7093    0.3347    0.2157]);

    b = copyobj(handles.axes2, a);
    set(b, 'Position', [0.1300    0.4096    0.3347    0.2157]);

    b = copyobj(handles.axes3, a);
    set(b, 'Position', [0.1300    0.1100    0.3347    0.2157]);

    b = copyobj(handles.axes4, a);
    set(b, 'Position', [0.5703    0.7093    0.3347    0.2157]);

    b = copyobj(handles.axes5, a);
    set(b, 'Position', [0.5703    0.4096    0.3347    0.2157]);

    b = copyobj(handles.axes6, a);
    set(b, 'Position', [0.5703    0.1100    0.3347    0.2157]);

    Data = getappdata(handles.figure1, 'OCS');
    if isfield(Data, 'TimeStamp')
        addlabel(1,0,datestr(OCS.CM{1}.TimeStamp,21));
    end
    
    orient tall
end


% --------------------------------------------------------------------
function Edit_SVD_Callback(hObject, eventdata, handles)
OCS = getappdata(handles.figure1,'OCS');

a = get(handles.Edit_SVD,'String');
if isempty(a)
    OCS.SVDIndex = [];
else
    val = str2num(a);
    if isempty(val) || val < 0 || val == 0
        uiwait(warndlg({'Invalid Singular Value','Setting the value to default'},'SINGULAR VALUE','Modal'));
        OCS.SVDIndex = [];
        set(handles.Edit_SVD,'String','');
    elseif val < 1
        OCS.SVDIndex = val;
    else
        val = ceil(val);
        set(handles.Edit_SVD,'String',num2str(val));
        OCS.SVDIndex = (1:val)';
    end
end


% Update plots
if ~isfield(OCS,'BPM')
    return;
end
setappdata(handles.figure1,'OCS',OCS);
UpdatePlots(handles);


% --------------------------------------------------------------------
function RadioButton_RF_Callback(hObject, eventdata, handles)

RingSetOrbit = getappdata(0, 'RingSetOrbit');

if isfield(RingSetOrbit,'RunFlag') && RingSetOrbit.RunFlag == 1

    % Orbit correction is running.  Request an RF change.
    if get(handles.RadioButton_RF,'Value') == 1
        RingSetOrbit.FitRF = 1;
    else
        RingSetOrbit.FitRF = 0;
    end
    setappdata(0, 'RingSetOrbit', RingSetOrbit);

else

    OCS = getappdata(handles.figure1, 'OCS');

    % Save the starting RF frequency
    OCS.RF = getrf('Struct');

    if ~isfield(OCS,'BPM')
        return;
    end
    if get(handles.RadioButton_RF,'Value') == 1
        OCS.FitRF = 1;
    else
        OCS.FitRF = 0;
    end
    setappdata(handles.figure1,'OCS',OCS);

    % Update plots
    FigResize_Callback(hObject, eventdata, handles);
    UpdatePlots(handles);
end



% --------------------------------------------------------------------
function Print_Callback(hObject, eventdata, handles)

printdlg(handles.figure1)




% --------------------------------------------------------------------
function Plots0_Callback(hObject, eventdata, handles)

if strcmpi(get(handles.Plots0,'Checked'),'Off')
    % Set the menus and graphs
    set(handles.Plots0, 'Checked', 'On');
    set(handles.Plots3, 'Checked', 'Off');
    set(handles.Plots6, 'Checked', 'Off');
    set(handles.Graph_1, 'Enable', 'Off');
    set(handles.Graph_2, 'Enable', 'Off');
    set(handles.Graph_3, 'Enable', 'Off');
    set(handles.Graph_4, 'Enable', 'Off');
    set(handles.Graph_5, 'Enable', 'Off');
    set(handles.Graph_6, 'Enable', 'Off');

    % Save the figure width
    set(handles.figure1, 'Units', 'Characters');
    Pcharacters = get(handles.figure1, 'Position');
    setappdata(handles.figure1, 'FigurePosition', Pcharacters);

    % Get the goal orbit panal position
    set(handles.figure1, 'Units', 'Characters');
    Pcharacters = get(handles.figure1, 'Position');

    % Change the figure size
    Units = get(handles.PanelGoalOrbit, 'Units');
    set(handles.PanelGoalOrbit, 'Units', 'Characters');
    pPanal = get(handles.PanelGoalOrbit, 'Position');
    set(handles.PanelGoalOrbit, 'Units', Units);

    % This also forces a FigResize_Callback
    set(handles.figure1, 'Units', 'Characters');
    set(handles.figure1, 'Position', [Pcharacters(1) Pcharacters(2) 2*pPanal(1)+pPanal(3) Pcharacters(4)]);set(handles.PanelGoalOrbit, 'Units', Units);

    % Figure resize off
    set(handles.figure1, 'Resize', 'Off');
    
    RingSetOrbit = getappdata(0, 'RingSetOrbit');
    if isfield(RingSetOrbit,'RunFlag') && RingSetOrbit.RunFlag == 1
        % If orbit correction is running, change the display
        RingSetOrbit.Display = 0;
        setappdata(0, 'RingSetOrbit', RingSetOrbit);
    end

    %OCS = getappdata(handles.figure1, 'OCS');
    %if isfield(OCS, 'BPM')
    %    UpdatePlots(handles);
    %end
end




% --------------------------------------------------------------------
function Plots3_Callback(hObject, eventdata, handles)

if strcmpi(get(handles.Plots3,'Checked'),'Off')
    if strcmpi(get(handles.Plots0,'Checked'),'On')
        ChangeWidthFlag = 1;
    else
        ChangeWidthFlag = 0;
    end
    
    set(handles.Plots0, 'Checked', 'Off');
    set(handles.Plots3, 'Checked', 'On');
    set(handles.Plots6, 'Checked', 'Off');
    set(handles.Graph_1, 'Enable', 'On');
    set(handles.Graph_2, 'Enable', 'On');
    set(handles.Graph_3, 'Enable', 'On');
    set(handles.Graph_4, 'Enable', 'Off');
    set(handles.Graph_5, 'Enable', 'Off');
    set(handles.Graph_6, 'Enable', 'Off');

    if ChangeWidthFlag
        % This also forces a FigResize_Callback
        FigurePositionOld = getappdata(handles.figure1, 'FigurePosition');
        set(handles.figure1, 'Units', 'Characters');
        Pcharacters = get(handles.figure1, 'Position');
        set(handles.figure1, 'Position', [Pcharacters(1) Pcharacters(2) FigurePositionOld(3) Pcharacters(4)]);
    else
        FigResize_Callback(hObject, eventdata, handles);
    end
    
    % Figure resize on
    set(handles.figure1, 'Resize', 'On');

    RingSetOrbit = getappdata(0, 'RingSetOrbit');
    if isfield(RingSetOrbit,'RunFlag') && RingSetOrbit.RunFlag == 1
        % If orbit correction is running, ask setorbit to change the display
        RingSetOrbit.Display = 1;
        RingSetOrbit.FigureHandles = [handles.axes1; handles.axes2; handles.axes3;];
        setappdata(0, 'RingSetOrbit', RingSetOrbit);
    else
        % Update plots
        OCS = getappdata(handles.figure1, 'OCS');
        if isfield(OCS, 'BPM')
            UpdatePlots(handles);
        end
    end
end


% --------------------------------------------------------------------
function Plots6_Callback(hObject, eventdata, handles)

if strcmpi(get(handles.Plots6,'Checked'),'Off')
    if strcmpi(get(handles.Plots0,'Checked'),'On')
        ChangeWidthFlag = 1;
    else
        ChangeWidthFlag = 0;
    end
    
    set(handles.Plots0, 'Checked', 'Off');
    set(handles.Plots3, 'Checked', 'Off');
    set(handles.Plots6, 'Checked', 'On');
    set(handles.Graph_1, 'Enable', 'On');
    set(handles.Graph_2, 'Enable', 'On');
    set(handles.Graph_3, 'Enable', 'On');
    set(handles.Graph_4, 'Enable', 'On');
    set(handles.Graph_5, 'Enable', 'On');
    set(handles.Graph_6, 'Enable', 'On');

    if ChangeWidthFlag
        % This also forces a FigResize_Callback
        FigurePositionOld = getappdata(handles.figure1, 'FigurePosition');
        set(handles.figure1, 'Units', 'Characters');
        Pcharacters = get(handles.figure1, 'Position');
        set(handles.figure1, 'Position', [Pcharacters(1) Pcharacters(2) FigurePositionOld(3) Pcharacters(4)]);
    else
        FigResize_Callback(hObject, eventdata, handles);
    end

    % Figure resize on
    set(handles.figure1, 'Resize', 'On');

    RingSetOrbit = getappdata(0, 'RingSetOrbit');
    if isfield(RingSetOrbit,'RunFlag') && RingSetOrbit.RunFlag == 1
        % If orbit correction is running, ask setorbit to change the display
        RingSetOrbit.Display = 1;
        RingSetOrbit.FigureHandles = [handles.axes1; handles.axes2; handles.axes3; handles.axes4; handles.axes5; handles.axes6;];
        setappdata(0, 'RingSetOrbit', RingSetOrbit);
    else
        % Update plots
        OCS = getappdata(handles.figure1, 'OCS');
        if isfield(OCS, 'BPM')
            UpdatePlots(handles);
        end
    end
end
        

% --------------------------------------------------------------------
function FigResize_Callback(hObject, eventdata, handles)

if ~isempty(handles)
    % Minimum figure width
    if ~strcmpi(get(handles.Plots0, 'Checked'), 'On')
        FigureMinWidth = 130;
        set(handles.figure1, 'Units', 'Characters');
        Pcharacters = get(handles.figure1,'Position');

        % there is something wrong with vista here - the units are still in normalized ???
        if Pcharacters(3) < FigureMinWidth
            set(handles.figure1, 'Position', [Pcharacters(1) Pcharacters(2) FigureMinWidth Pcharacters(4)]);
        end
    end

    set(handles.axes1, 'Units', 'Normalized');
    set(handles.axes2, 'Units', 'Normalized');
    set(handles.axes3, 'Units', 'Normalized');
    set(handles.axes4, 'Units', 'Normalized');
    set(handles.axes5, 'Units', 'Normalized');
    set(handles.axes6, 'Units', 'Normalized');
    
    set(handles.figure1, 'Units', 'Normalized');
    P = get(handles.figure1,'Position');

    Units = get(handles.PanelGoalOrbit, 'Units');
    set(handles.PanelGoalOrbit, 'Units', 'Normalized');
    pPanal = get(handles.PanelGoalOrbit, 'Position');
    set(handles.PanelGoalOrbit, 'Units', Units);

    Width = 1 - (pPanal(1) + pPanal(3));    
    
    XBuffer1 = .075;
    
    
    if strcmpi(get(handles.Plots0,'Checked'),'On')

        % No plots
        set(handles.Graph_1, 'Visible', 'Off');
        set(handles.Graph_2, 'Visible', 'Off');
        set(handles.Graph_2, 'Visible', 'Off');
        set(handles.Graph_4, 'Visible', 'Off');
        set(handles.Graph_5, 'Visible', 'Off');
        set(handles.Graph_6, 'Visible', 'Off');
        
        set(handles.axes1,'Visible','Off');
        h = get(handles.axes1,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'Off');
        end

        set(handles.axes2,'Visible','Off');
        h = get(handles.axes2,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'Off');
        end

        set(handles.axes3,'Visible','Off');
        h = get(handles.axes3,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'Off');
        end

        set(handles.axes4,'Visible','Off');
        h = get(handles.axes4,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'Off');
        end

        set(handles.axes5,'Visible','Off');
        h = get(handles.axes5,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'Off');
        end

        set(handles.axes6,'Visible','Off');
        h = get(handles.axes6,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'Off');
        end
       
        % Legends
        h = findobj(handles.figure1,'tag','legend');
        for i = 1:length(h)
            set(h(i), 'Visible', 'Off');
        end
    
    elseif strcmpi(get(handles.Plots6,'Checked'),'On')

        % Find the RF plot if it exists
        if get(handles.RadioButton_RF,'Value') == 1
            XBuffer2 = .05;
        else
            XBuffer2 = .02;
        end

        % Find the RF plot if it exists
        hyy = [];
        if get(handles.RadioButton_RF,'Value') == 1
            h = get(handles.figure1,'children');

            for i = 1:length(h);
                try
                    if findstr(get(get(h(i),'ylabel'),'string'),'RF');
                        hyy = h(i);
                        break;
                    end
                catch
                end
            end
        end

        if (Width/2-XBuffer1-XBuffer2) < 0
            return;
        end

        a = [pPanal(1)+pPanal(3)+XBuffer1                    .075 (Width/2-XBuffer1-XBuffer2/2) .25];
        set(handles.axes1, 'Position', a + [0 .6 0 0]);
        set(handles.axes2, 'Position', a + [0 .3 0 0]);
        set(handles.axes3, 'Position', a);

        a = [pPanal(1)+pPanal(3)+XBuffer1+Width/2-XBuffer2/2 .075 (Width/2-XBuffer1-XBuffer2/2) .25];
        set(handles.axes4, 'Position', a + [0 .6 0 0]);   % ??? plotyy error
        set(handles.axes5, 'Position', a + [0 .3 0 0]);
        set(handles.axes6, 'Position', a);

        if ~isempty(hyy)
            set(hyy, 'Position', a + [0 .6 0 0]);
        end
        
        set(handles.Graph_1, 'Visible', 'On');
        set(handles.Graph_2, 'Visible', 'On');
        set(handles.Graph_2, 'Visible', 'On');
        set(handles.Graph_4, 'Visible', 'On');
        set(handles.Graph_5, 'Visible', 'On');
        set(handles.Graph_6, 'Visible', 'On');

        set(handles.axes1,'Visible','On');
        h = get(handles.axes1,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'On');
        end

        set(handles.axes2,'Visible','On');
        h = get(handles.axes2,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'On');
        end

        set(handles.axes3,'Visible','On');
        h = get(handles.axes3,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'On');
        end

        set(handles.axes4,'Visible','On');
        h = get(handles.axes4,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'On');
        end

        set(handles.axes5,'Visible','On');
        h = get(handles.axes5,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'On');
        end

        set(handles.axes6,'Visible','On');
        h = get(handles.axes6,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'On');
        end

       
        % Legends
        h = findobj(handles.figure1,'tag','legend');
        for i = 1:length(h)
            set(h(i), 'Visible', 'On');
        end

    else

        % 3 Plots
        XBuffer2 = .02;

        set(handles.Graph_1, 'Visible', 'On');
        set(handles.Graph_2, 'Visible', 'On');
        set(handles.Graph_2, 'Visible', 'On');
        set(handles.Graph_4, 'Visible', 'Off');
        set(handles.Graph_5, 'Visible', 'Off');
        set(handles.Graph_6, 'Visible', 'Off');
        
        set(handles.axes1,'Visible','On');
        h = get(handles.axes1,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'On');
        end

        set(handles.axes2,'Visible','On');
        h = get(handles.axes2,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'On');
        end

        set(handles.axes3,'Visible','On');
        h = get(handles.axes3,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'On');
        end

        set(handles.axes4,'Visible','Off');
        h = get(handles.axes4,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'Off');
        end

        set(handles.axes5,'Visible','Off');
        h = get(handles.axes5,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'Off');
        end

        set(handles.axes6,'Visible','Off');
        h = get(handles.axes6,'Children');
        for i = 1:length(h)
            set(h(i), 'Visible', 'Off');
        end


        % Legends
        h = findobj(handles.figure1,'tag','legend');
        for i = 1:length(h)
            UserData = get(h(i),'UserData');
            if isstruct(UserData)
                if any(strcmpi(UserData, {'Axes1','Axes2','Axes3'}))
                    set(h(i), 'Visible', 'On');
                else
                    set(h(i), 'Visible', 'Off');
                end
            end
        end


        if (Width-XBuffer1-XBuffer2) < 0
            return;
        end
        a = [pPanal(1)+pPanal(3)+XBuffer1 .075 (Width-XBuffer1-XBuffer2) .25];
        set(handles.axes1, 'Position', a + [0 .6 0 0]);
        set(handles.axes2, 'Position', a + [0 .3 0 0]);
        set(handles.axes3, 'Position', a);
    end
end

drawnow;

%cla(handles.axes4, 'reset');
%cla(handles.axes5, 'reset');
%cla(handles.axes6, 'reset');

     

% --------------------------------------------------------------------
function UpdatePlots(handles)

set(handles.figure1, 'HandleVisibility','On');

OCS = getappdata(handles.figure1,'OCS');

if strcmpi(get(handles.Plots6,'Checked'), 'On')
    OCS = setorbit(OCS, 'NoSetSP', 'NoGetPV', 'FigureHandles', [handles.axes1;handles.axes2;handles.axes3;handles.axes4;handles.axes5;handles.axes6;]);
elseif strcmpi(get(handles.Plots3,'Checked'), 'On')
    OCS = setorbit(OCS, 'NoSetSP', 'NoGetPV', 'FigureHandles', [handles.axes1;handles.axes2;handles.axes3;]);
elseif strcmpi(get(handles.Plots0,'Checked'), 'On')
    OCS = setorbit(OCS, 'NoSetSP', 'NoGetPV', 'NoDisplay', 'FigureHandles', [handles.axes1;handles.axes2;handles.axes3;]);
end

setappdata(handles.figure1,'OCS',OCS);

set(handles.figure1, 'HandleVisibility','Off');



% --------------------------------------------------------------------
function MinimumPeriod_Callback(hObject, eventdata, handles)

MinimumPeriodString = get(handles.MinimumPeriod, 'String');
if isempty(MinimumPeriodString)
    MinimumPeriod = [];
else
    MinimumPeriod = str2num(MinimumPeriodString);
    if MinimumPeriod < 0
        MinimumPeriod = 0;
    end
end
set(handles.MinimumPeriod, 'String', num2str(MinimumPeriod));


RingSetOrbit = getappdata(0, 'RingSetOrbit');
if isfield(RingSetOrbit,'RunFlag') && RingSetOrbit.RunFlag == 1
    % Orbit correction is running.  Request an MinimumPeriod change.
    RingSetOrbit.MinimumPeriod = MinimumPeriod;
    setappdata(0, 'RingSetOrbit', RingSetOrbit);
else
    OCS = getappdata(handles.figure1, 'OCS');
    OCS.MinimumPeriod = MinimumPeriod;
    setappdata(handles.figure1, 'OCS', OCS);
end



% --------------------------------------------------------------------
function CorrectorGain_Callback(hObject, eventdata, handles)

CorrectorGain = str2num(get(handles.CorrectorGain,'String'));
if isnumeric(CorrectorGain) && length(CorrectorGain)==1 && CorrectorGain >= 0 && CorrectorGain <= 100
    set(handles.CorrectorGain, 'Value', CorrectorGain);
else
    set(handles.CorrectorGain, 'String', '100');
end

RingSetOrbit = getappdata(0, 'RingSetOrbit');
if isfield(RingSetOrbit,'RunFlag') && RingSetOrbit.RunFlag == 1
    % Orbit correction is running.  Request an CorrectorGain change.
    RingSetOrbit.CorrectorGain = CorrectorGain/100;
    setappdata(0, 'RingSetOrbit', RingSetOrbit);
else
    OCS = getappdata(handles.figure1, 'OCS');
    OCS.CorrectorGain = CorrectorGain/100;
    setappdata(handles.figure1, 'OCS', OCS);
end




