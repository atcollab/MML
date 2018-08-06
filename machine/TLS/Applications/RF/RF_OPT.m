function varargout = RF_OPT(varargin)
% RF_OPT MATLAB code for RF_OPT.fig
%      RF_OPT, by itself, creates a new RF_OPT or raises the existing
%      singleton*.
%
%      H = RF_OPT returns the handle to a new RF_OPT or the handle to
%      the existing singleton*.
%
%      RF_OPT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RF_OPT.M with the given input arguments.
%
%      RF_OPT('Property','Value',...) creates a new RF_OPT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RF_OPT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RF_OPT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RF_OPT

% Last Modified by GUIDE v2.5 04-Nov-2011 17:36:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RF_OPT_OpeningFcn, ...
                   'gui_OutputFcn',  @RF_OPT_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before RF_OPT is made visible.
function RF_OPT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RF_OPT (see VARARGIN)

% Choose default command line output for RF_OPT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
RFOPT(handles,'NoSetRF');
% UIWAIT makes RF_OPT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RF_OPT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




function [DeltaRF, BPM, c, DispOrbit] = RFOPT(handles,varargin)
%RMDISP - Removes the portion of the orbit that correlates with the dispersion 
%  [DeltaRF, OrbitRM, c, DispOrbit] = rmdisp(BPMFamily, Orbit, BPMList, Dispersion)
%  [DeltaRF, OrbitRM, c, DispOrbit] = rmdisp(BPMStruct, Dispersion)
%
%  INPUTS
%  1. BPMFamily - Family name {Default: 'BPMx'}
%     BPMStruct - BPM data structure.  When using data structures, the orbit and
%                 BPMList are in the .Data and .DeviceList fields, respectively.
%  2. Orbit - Input orbit  {Default or empty: get the present orbit}
%  3. BPMList - Device or element list of BPMs  {Default or empty: all}
%  4  FLAGS - 'FitMean' or 'FitDispersionOnly' {Default} - Include or don't include the mean in the fit
%             'MeasDisp' - Measure the dispersion
%             'ModelDisp' - Calculate the model dispersion
%             'GoldenDisp' - Use the golden dispersion  {Default}
%             'Display' - Plot orbit information {Default: no display unless there are no outputs}
%             'NoDisplay' - No plot
%             'SetRF' - Sets the RF frequency to the new value (prompts to check the value if 'Display' is on)
%             'NoSetRF' - Don't set the RF frequency
%             (the usual Units and Mode flags: 'Online', 'Model', 'Manual', 'Hardware', 'Physics', etc.)
%  5. Dispersion - Optional input to specify the dispersion
%
%  OUTPUTS
%  1. DeltaRF - Change in RF frequency required to remove the dispersion component of 
%               the orbit.  The units are the in RF frequency units used by getrf/setrf.
%               If DeltaRF = [], the units of dispersion or RF frequency were not unknown.  In
%               which case use c, output 3, to get the change in RF frequency.
%  2. OrbitRM - Estimated orbit with the dispersion orbit removed
%  3. c - fit coefficient,  OrbitRM = Orbit - c * Dispersion
%         c converts to RF frequency change but it depends on the units for the 
%         orbit and dispersion.  For instance, if Orbit is in [mm] and Dispersion is
%         in [mm/MHz], then c is in MHz.  If Orbit is in [m] and Dispersion is in 
%         [meter/(dp/p)], then c is energy shift (DeltaRF = -c*mcf*RF [Hz]).  
%         To correct the orbit, change the RF frequency by negative of the frequency
%         change determined by the c coefficient.
%  3. DispOrbit - Dispersion orbit used in the calculation
%
%  NOTES
%  1. It is unclear to the author if it is better to fit the mean or not.  If the
%     BPM offsets are not known very well then fitting the mean may be better.  That way
%     the dispersion is not used as a way to change the orbit mean (beyond 
%     the mean change due to the shape and sampling of the dispersion function). 
%  2. When fitting the mean the RF frequency change is only based only the dispersion
%     fit coefficient.
%  3. It is best to use structure inputs, since the units are in the structure.  Hence,
%     the DeltaRF can be determined.
%
%  See also setorbit, findrf, plotcm

%  Written by Greg Portmann


% Option to fit the mean as well as the dispersion
% FitMeanFlag = 0 -> only fit the dispersion
% FitMeanFlag = 1 -> fit both the mean and dispersion but only remove the
%                    dispersion coefficient from the orbit
% It can be good fit the mean (at least if BPM offsets are not known), 
% so that the dispersion is not used as a way to change the orbit mean (beyond 
% the mean change due to the shape and sampling of the dispersion function). 
% When using difference orbits, I wouldn't fit the mean.
% Note: fitting the mean and dispersion together is different from removing 
% the mean then fitting the dispersion.
FitMeanFlag = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parsing and checking %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargout == 0 
    DisplayFlag = 1;
else
    DisplayFlag = 0;
end
ChangeRFFlag = 0;
DispFlag = 'GoldenDisp';
StructOutputFlag = 0;
NumericOutputFlag = 0; 
DispOrbitStruct = []; 
InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'SetRF')
        ChangeRFFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoSetRF')
        ChangeRFFlag = 0;
        varargin(i) = [];
        set(handles.RD2,'String',0);
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'ModelDisp')
        DispFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MeasDisp')
        DispFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'FitMean')
        FitMeanFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'FitDispersionOnly')
        FitMeanFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'GoldenDisp')
        DispFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') | strcmpi(varargin{i},'model')
        ModeFlag = 'SIMULATOR';
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        ModeFlag = 'Online';
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Manual')
        ModeFlag = 'Manual';
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        UnitsFlag = 'Physics';
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = 'Hardware';
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        NumericOutputFlag = 1;
        StructOutputFlag = 0;
        varargin(i) = [];
    end
end

if length(varargin) < 1
    varargin = {'BPMx'};
end

if isstruct(varargin{1})
    BPM = varargin{1};
    if ~isfamily(BPM)
        error(sprintf('%s is not a family'), BPM.FamilyName);
    end
    if length(varargin) >= 2
        % Use dispersion for the input line
        DispOrbitStruct = varargin{2};
    end

    % Only change StructOutputFlag if 'numeric' is not on the input line
    if ~NumericOutputFlag
        StructOutputFlag = 1;
    end
else
    if ischar(varargin{1})
        BPM.FamilyName = varargin{1};
    else
        error('First input must be a structure or FamilyName');
    end
    if ~isfamily(BPM.FamilyName)
        error(sprintf('%s is not a BPM family', BPM.FamilyName));
    end
    if length(varargin) >= 2
        BPM.Data = varargin{2};
    else
        BPM = getam(BPM.FamilyName, 'Struct', InputFlags{:});
    end
    if length(varargin) >= 3
        BPM.DeviceList = varargin{3};
    elseif ~isfield(BPM, 'DeviceList')
        BPM.DeviceList = getlist(BPM.FamilyName);
    end
    if length(varargin) >= 4
        % Use dispersion for the input line
        DispOrbitStruct = varargin{4};
    end
end


%%%%%%%%%%%%%%%%%%
% Get Dispersion %
%%%%%%%%%%%%%%%%%%
DispUnitsString = ''; 
if get(handles.control,'Value') == 2
    DispFlag = 'ModelDisp';
elseif get(handles.control,'Value') == 1
    DispFlag = 'GoldenDisp';
end
if isempty(DispOrbitStruct)
    if strcmpi(DispFlag,'ModelDisp')
        DispOrbitStruct = measdisp(BPM, 'Struct', 'Model', InputFlags{:});
        DispUnitsString = DispOrbitStruct.UnitsString;
    elseif strcmpi(DispFlag,'MeasDisp')
        DispOrbitStruct = measdisp(BPM, 'Struct', InputFlags{:});
        DispUnitsString = DispOrbitStruct.UnitsString;
    elseif strcmpi(DispFlag,'GoldenDisp')
        DispOrbitStruct = getdisp(BPM.FamilyName, BPM.DeviceList, 'Struct');
        DispUnitsString = DispOrbitStruct.UnitsString;
    end
end
if isempty(DispOrbitStruct)
    error('Did not find or generate a proper dispersion function');
end

% If dispersion is a structure, just use the .Data field
if isstruct(DispOrbitStruct)
    DispOrbit = DispOrbitStruct.Data;
else
    DispOrbit = DispOrbitStruct;    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fit the orbit into the dispersion function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dot product of dispersion and the orbit can be used
% to find the RF frequency but to find the orbit which best
% correlates to the dispersion use a least squares fit 
% c = BPM.Data' * DispOrbit;  

BPMDataOld = BPM.Data;
set(handles.BD1,'String',mean(BPMDataOld));
set(handles.BD2,'String',std(BPMDataOld));

if FitMeanFlag
    % Fit the mean and the dispersion orbit
    X = [ones(size(DispOrbit)) DispOrbit];
    cfit = X \ BPM.Data; 
    c = cfit(2);
    %BPM.Data = BPM.Data - X * c;
else
    % Fit the dispersion orbit
    cfit = DispOrbit \ BPM.Data; 
    c = cfit;
end

%BPM.Data = BPM.Data - X * c;
BPM.Data = BPM.Data - DispOrbit * c;


% Comput the change in RF frequency
% Units are a big pain the neck when it comes to determining the actual RF change
% Note: this section will depend a little on how the UnitsString is setup
% c units = BPM units / Dispersion units 
RF0 = getrf('Struct', InputFlags{:});
set(handles.RD1,'String',sprintf('%f',RF0.Data));
set(handles.Reset,'UserData',RF0.Data);
DeltaRF = [];            
if ~isfield(BPM,'UnitsString') 
    [units, unitsstring] = getunits(BPM, 'Monitor');
    BPM.UnitsString = unitsstring;  % Hopefully this is true
    %if DisplayFlag
    %    fprintf('   BPM units are defined.  Assuming units are %s.\n', unitsstring);
    %end
end
if ~isempty(BPM.UnitsString) & ~isempty(DispUnitsString)
    % May need to scale by the orbit units
    if strfind(lower(BPM.UnitsString), 'mm') | strfind(lower(BPM.UnitsString), 'millimeter') | strfind(lower(BPM.UnitsString), 'millimeters') 
        % BPM is in mm
        if strfind(DispUnitsString, 'mm') | strfind(DispUnitsString, 'millimeter') | strfind(DispUnitsString, 'millimeters')
            % Dispersion is in mm, hence the units are ok
        elseif strfind(DispUnitsString, 'm') | strfind(DispUnitsString, 'meter') | strfind(DispUnitsString, 'meters')  
            % Dispersion is in meters
            c = c / 1000;
        else
            DeltaRF = [];            
        end
    elseif strfind(lower(BPM.UnitsString), 'm') | strfind(lower(BPM.UnitsString), 'meter') | strfind(lower(BPM.UnitsString), 'meter') 
        % BPM is in meters
        if strfind(lower(DispUnitsString), 'mm') | strfind(lower(DispUnitsString), 'millimeter') | strfind(lower(DispUnitsString), 'millimeters')
            % Dispersion is in mm, hence the units are ok
            c = c * 1000;
        elseif strfind(lower(DispUnitsString), 'm') | strfind(lower(DispUnitsString), 'meter') | strfind(lower(DispUnitsString), 'meters')
            % Dispersion is in meters, hence the units are ok
        else
            DeltaRF = [];            
        end
    end
    
    % Change units to the same as getrf
    if strfind(lower(DispUnitsString), 'mhz')
        if strcmpi(RF0.UnitsString, 'MHz')
            DeltaRF = c;        % c is MHz, DeltaRF is MHz
        elseif strcmpi(RF0.UnitsString, 'Hz')
            DeltaRF = c * 1e6;  % c is MHz, DeltaRF is Hz
        else
            DeltaRF = [];            
        end
    elseif strfind(lower(DispUnitsString), 'hz')
        if strcmpi(RF0.UnitsString, 'MHz')
            DeltaRF = c / 1e6;  % c is Hz, DeltaRF is MHz
        elseif strcmpi(RF0.UnitsString, 'Hz')
            DeltaRF = c;        % c is Hz, DeltaRF is Hz
        else
            DeltaRF = [];            
        end
    elseif strfind(lower(DispUnitsString), 'dp/p')
        DeltaRF = c * getmcf * RF0.Data;  % Units same as RF0
    else
        DeltaRF = [];
    end

    % Return the change in RF required to remove the orbit error
    DeltaRF = -DeltaRF;
else
    DeltaRF = -c;    
end


%%%%%%%%%%%%%%%%%%%%%%
% Output and display %
%%%%%%%%%%%%%%%%%%%%%%
if DisplayFlag
    spos = getspos(BPM);
%     clf reset
    axes(handles.axes1);
    plot(spos, BPMDataOld, 'r', spos, BPM.Data, 'b'); 
    set(handles.axes1,'XLim',[0 getcircumference])
    grid on
%     xlabel('Position [Meters]');
    if isfield(BPM,'UnitsString')
        ylabel(sprintf('%s [%s]', BPM.FamilyName, BPM.UnitsString));
    else
        ylabel(sprintf('%s', BPM.FamilyName));
    end
    legend('Starting Orbit','Dispersion Removed')
%     if length(cfit) == 2
%         title(sprintf('%g + %g * Dispersion',cfit(1), cfit(2)));
%     else
%         title(sprintf('%g * Dispersion',cfit(1)));
%     end
    set(handles.axes1,'XTick',[])
    axes(handles.axes3);
    drawlattice;
    set(handles.axes3,'XTick',[])
    set(handles.axes3,'YTick',[])
    axes(handles.axes2);
    %plot(spos, X * c, 'b'); 
    if strcmpi(getunits('BPMx'), 'Physics')
        plot(spos, DispOrbit * c, 'b'); 
    else
        plot(spos, DispOrbit * c*1000, 'b');
    end
    set(handles.axes2,'XLim',[0 getcircumference])
    grid on
    xlabel('Position [Meters]');
    if isfield(BPM,'UnitsString')
        ylabel(sprintf('Orbit Removed [%s]',BPM.UnitsString));
    else
        ylabel(sprintf('Orbit Removed'));
    end
end


if ~StructOutputFlag
    BPM = BPM.Data;
end


% Set the RF frequency
if ChangeRFFlag
    if ~isempty(DeltaRF)
        if DisplayFlag
            answer = inputdlg({strvcat(strvcat(sprintf('Recommend change in RF is %g %s', DeltaRF, RF0.UnitsString), '  '), 'Change the RF frequency?')},'',1,{sprintf('%g',-DeltaRF)});
            if isempty(answer)
                fprintf('   No change was made to the RF frequency\n');
                return
            end
            DeltaRF = str2num(answer{1});
        end
        steprf(DeltaRF, InputFlags{:});
        RF = getrf;
        set(handles.RD1,'String',sprintf('%f',RF+DeltaRF));
        set(handles.RD2,'String',sprintf('%f',DeltaRF));
    else
        error('RF frequency not changed because of a problem converting the units for dispersion and orbit to RF frequency');
    end
    
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RFOPT(handles,'SetRF');
% [DeltaRF, BPM, c, DispOrbit] = RFOPT(handles,'SetRF','Display');

% while abs(getrf - RF - DeltaRF) > 1e-3
% %     set(handles.RD1,'String',sprintf('%f',getrf));
%     set(handles.RD2,'String',sprintf('%f',getrf-RF));
% end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in control.
function control_Callback(hObject, eventdata, handles)
% hObject    handle to control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns control contents as cell array
%        contents{get(hObject,'Value')} returns selected item from control


% --- Executes during object creation, after setting all properties.
function control_CreateFcn(hObject, eventdata, handles)
% hObject    handle to control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RF = get(handles.Reset,'UserData');
setsp('RF',RF);
set(handles.control,'Value',1);
RFOPT(handles,'NoSetRF');


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BD1_Callback(hObject, eventdata, handles)
% hObject    handle to BD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BD1 as text
%        str2double(get(hObject,'String')) returns contents of BD1 as a double


% --- Executes during object creation, after setting all properties.
function BD1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BD2_Callback(hObject, eventdata, handles)
% hObject    handle to BD2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BD2 as text
%        str2double(get(hObject,'String')) returns contents of BD2 as a double


% --- Executes during object creation, after setting all properties.
function BD2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BD2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RD1_Callback(hObject, eventdata, handles)
% hObject    handle to RD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RD1 as text
%        str2double(get(hObject,'String')) returns contents of RD1 as a double


% --- Executes during object creation, after setting all properties.
function RD1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RD2_Callback(hObject, eventdata, handles)
% hObject    handle to RD2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RD2 as text
%        str2double(get(hObject,'String')) returns contents of RD2 as a double


% --- Executes during object creation, after setting all properties.
function RD2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RD2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
