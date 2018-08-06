function varargout = mmlviewer(varargin)
% MMLVIEWER M-file for mmlviewer.fig
%      MMLVIEWER, by itself, creates a new MMLVIEWER or raises the existing
%      singleton*.
%
%      H = MMLVIEWER returns the handle to a new MMLVIEWER or the handle to
%      the existing singleton*.
%
%      MMLVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MMLVIEWER.M with the given input arguments.
%
%      MMLVIEWER('Property','Value',...) creates a new MMLVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mmlviewer_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mmlviewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mmlviewer

% Last Modified by GUIDE v2.5 01-Nov-2006 11:34:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mmlviewer_OpeningFcn, ...
    'gui_OutputFcn',  @mmlviewer_OutputFcn, ...
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


% --- Executes just before mmlviewer is made visible.
function mmlviewer_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for mmlviewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

try
    if ~isepics
        set(handles.ListBox5, 'Visible', 'Off');
    else
        set(handles.ListBox5, 'Value', 1);
        set(handles.ListBox5, 'String', '');
    end
    
    set(handles.axes1,'XTickLabel','');
    set(handles.axes1,'YTickLabel','');
    
    % Fill the list boxes
    ViewAO_Callback(hObject, eventdata, handles);
    %ListBox1_Callback(hObject, eventdata, handles);


    % Make Monitor the default, if possible
    Fields = get(handles.ListBox2, 'String');
    if length(Fields) >= 1
        k = find(strcmpi(Fields, 'Monitor'));
        if ~isempty(k)
            set(handles.ListBox2, 'Value', k);
            ListBox2_Callback(hObject, eventdata, handles);
        end
    end

    % Make ChannelNames the default, if possible
    Fields = get(handles.ListBox3, 'String');
    if length(Fields) >= 1
        k = find(strcmpi(Fields, 'ChannelNames'));
        if ~isempty(k)
            set(handles.ListBox3, 'Value', k);
            ListBox3_Callback(hObject, eventdata, handles);
        end
    end

catch
end


% UIWAIT makes mmlviewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = mmlviewer_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
[file, Directory] = uigetfile('*.fig');
if ~isequal(file, 0)
    open([Directory file]);
end



% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
%                      ['Close ' get(handles.figure1,'Name') '...'],...
%                      'Yes','No','Yes');
% if strcmp(selection,'No')
%     return;
% end
delete(handles.figure1)



% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
printdlg(handles.figure1)




% --- Executes on selection change in ListBox1.
function ListBox1_Callback(hObject, eventdata, handles)

RootStruct = getappdata(handles.figure1, 'RootStruct');
Fields = fieldnames(RootStruct);
j = get(handles.ListBox1, 'Value');

Data = RootStruct;

Box0 = handles.ListBox1;
Box1 = handles.ListBox2;
Box2 = handles.ListBox3;

CallNextListBox = ListBoxUpdate(handles, Box0, Box1, Data, j);

if CallNextListBox
    ListBox2_Callback(hObject, eventdata, handles);
else
    set(handles.ListBox3, 'Value', 1);
    set(handles.ListBox3, 'String', '');
    set(handles.ListBox4, 'Value', 1);
    set(handles.ListBox4, 'String', '');
end


% --- Executes on selection change in ListBox2.
function ListBox2_Callback(hObject, eventdata, handles)

RootStruct = getappdata(handles.figure1, 'RootStruct');
Fields = fieldnames(RootStruct);
i = get(handles.ListBox1, 'Value');
j = get(handles.ListBox2, 'Value');
Data = RootStruct.(Fields{i});

Box0 = handles.ListBox2;
Box1 = handles.ListBox3;
Box2 = handles.ListBox4;

CallNextListBox = ListBoxUpdate(handles, Box0, Box1, Data, j, RootStruct, Fields{i});

if CallNextListBox
    ListBox3_Callback(hObject, eventdata, handles);
else
    set(handles.ListBox4, 'Value', 1);
    set(handles.ListBox4, 'String', '');
end

        
% --- Executes on selection change in ListBox3.
function ListBox3_Callback(hObject, eventdata, handles)

RootStruct = getappdata(handles.figure1, 'RootStruct');
Fields1 = fieldnames(RootStruct);
Fields2 = get(handles.ListBox2, 'String');
Fields3 = get(handles.ListBox3, 'String');

i = get(handles.ListBox1, 'Value');
j = get(handles.ListBox2, 'Value');
k = get(handles.ListBox3, 'Value');

Data = RootStruct.(Fields1{i}).(Fields2{j});

Box0 = handles.ListBox3;
Box1 = handles.ListBox4;
Box2 = handles.ListBox5;

CallNextListBox = ListBoxUpdate(handles, Box0, Box1, Data, k, RootStruct.(Fields1{i}), Fields2{j});

if CallNextListBox
    ListBox4_Callback(hObject, eventdata, handles);
end


% --- Executes on selection change in ListBox4.
function ListBox4_Callback(hObject, eventdata, handles)

i = get(handles.ListBox4, 'Value');
Data = get(handles.ListBoxData, 'String');
%DataFields = fieldnames(Data);

if size(Data, 1) == size(get(handles.ListBox4,'String'),1)
    set(handles.ListBoxData, 'Value', i);
end



% --- Executes on selection change in ListBox5.
function ListBox5_Callback(hObject, eventdata, handles)

RootStruct = getappdata(handles.figure1, 'RootStruct');
Fields1 = fieldnames(RootStruct);
Fields2 = get(handles.ListBox2, 'String');

i = get(handles.ListBox1, 'Value');
j = get(handles.ListBox2, 'Value');


EPICSFields = get(handles.ListBox5, 'UserData');
iEPICS = get(handles.ListBox5, 'Value');
setappdata(handles.figure1, 'iEPICS', iEPICS);
if ~isempty(EPICSFields)
    DotField = EPICSFields{iEPICS};
else
    DotField = '';
end


% Get data
try
    %Data = getandplotdata(handles, Fields1{i}, Fields2{j}, DotField, family2dev(Fields1{i},0));
    Data = getandplotdata(handles, Fields1{i}, Fields2{j}, DotField);
catch
    fprintf('   Could not get data for the %s family.\n', Fields1{i});
    return;
end



% --------------------------------------------------------------------
function Graph1_ButtonDown(hObject, eventdata, handles)
CurrentPoint = get(handles.axes1, 'CurrentPoint');
SposMouse = CurrentPoint(1,1);
SposData  = getappdata(handles.figure1, 'SPosX');

MeritFcn = abs(SposData-SposMouse);
i = find(min(MeritFcn) == MeritFcn);
if ~isempty(i)
    set(handles.ListBoxData, 'value', i(1));
    ListBoxData_Callback(hObject, eventdata, handles);
end



% --- Executes on selection change in ListBoxData.
function ListBoxData_Callback(hObject, eventdata, handles)

i = get(handles.ListBoxData, 'Value');
Data = get(handles.ListBox4, 'String');

if isempty(Data)
    % Try list box 3
    Data = get(handles.ListBox3, 'String');
    if size(Data, 1) == size(get(handles.ListBoxData,'String'),1)
        set(handles.ListBox3, 'Value', i);
    end
else
    if size(Data, 1) == size(get(handles.ListBoxData,'String'),1)
        set(handles.ListBox4, 'Value', i);
    end
end



function CallNextListBox = ListBoxUpdate(handles, Box0, Box1, Data, j, Data0, Fields0)

set(handles.ListBox5, 'Value', 1);
set(handles.ListBox5, 'String', '');

CallNextListBox = 0;

if isstruct(Data)
    DataFields = fieldnames(Data);
    DataField = DataFields{j};
    
    SubData = Data.(DataField);

    % Special cases
    if strcmpi(DataField, 'TimeStamp')
        set(Box1, 'Value', 1);
        set(Box1, 'String', datestr(Data.(DataField),31));
        return;
    elseif strcmpi(DataField, 'DataTime')
        set(Box1, 'Value', 1);
        set(Box1, 'String', datestr(Data.(DataField),31));
        
        % Look to match it with ListBoxData
        if size(get(Box1, 'String'),1) == size(get(handles.ListBoxData, 'String'),1)
            set(Box1, 'Value', get(handles.ListBoxData,'Value'));
        end
        return;
    elseif strcmpi(DataField, 't') || strcmpi(DataField, 'tout')
        set(Box1, 'Value', 1);
        set(Box1, 'String', num2str(Data.(DataField)));
        return;
    elseif any(strcmp(DataField, {'Status','DeviceList','ElementList','Position'}))
        set(Box1, 'Value', 1);
        set(Box1, 'String', num2str(Data.(DataField)));
        
        % Look to match it with ListBoxData
        if size(get(Box1, 'String'),1) == size(get(handles.ListBoxData, 'String'),1)
            set(Box1, 'Value', get(handles.ListBoxData,'Value'));
        end
        return;
    end

    % Get Box1 string of cell array of strings
    if isstruct(SubData)
        SubDataField = fieldnames(Data.(DataField));
    else
        if isnumeric(SubData)
            SubDataField = num2str(SubData);
        elseif ischar(SubData)
            SubDataField = SubData;
        elseif isa(Data,'function_handle')
            SubDataField = func2str(SubData);
        elseif iscell(SubData)
            if size(SubData,2) == 1
                SubDataField = SubData(:);
            else
                SubDataField = 'Too big to Display';
            end
        else
            SubDataField = '';
        end
    end
    
    % If the Value of Box1 is getting changed, test for a default
    if get(Box1, 'Value') > size(SubDataField,1)
        set(Box1, 'Value', 1);
        
        % Make Monitor the default, if possible
        set(Box1, 'Value', 1);
        if length(SubDataField) >= 1
            k = find(strcmpi(SubDataField, 'Monitor'));
            if ~isempty(k)
                set(Box1, 'Value', k);
            end
        end

        % Make ChannelNames the default, if possible
        if length(SubDataField) >= 1
            k = find(strcmpi(SubDataField, 'ChannelNames'));
            if ~isempty(k)
                set(Box1, 'Value', k);
            end
        end
    end
    
    % Set Box1
    set(Box1, 'String', SubDataField);
    
    % If appropriate, plot the data
    if strcmp(DataField, 'ChannelNames')
        % Change the Value of Box1 to equal ListBoxData
        if size(get(Box1, 'String'),1) == size(get(handles.ListBoxData, 'String'),1)
            set(Box1, 'Value', get(handles.ListBoxData,'Value'));
        end
        
        % Plot the channels - for control system fields add sub-data fields
        DotField = '';
        if isfield(Data, 'Mode')
            Mode = Data.Mode;
        else
            Mode = 'Online';
        end
        if isepics && strcmpi(Mode, 'Online')
            % I should base this list on the type of channel 
            EPICSFields = {
                'VAL'; 'SCAN';
                'HOPR'; 'LOPR'; 'PREC'; 'DESC'; 
                'HIHI';'LOLO';  'HIGH'; 'LOW'; 'HHSV'; 'LLSV'; 'HSV'; 'LSV'; 'HYST';
                'RVAL'; 'ROFF'; 'ASLO'; 'AOFF'; 'LINR'; 'ESLO'; 'EOFF'; 'EGUL'; 'EGUF'; 
                'MDEL'; 'ADEL';
                'STAT'; 'SEVR'; 'ACKS'; 'UDF';
                'PREC'; 'ORAW'; 'INIT'; 
                'DRVH'; 'DRVL'; 'RBV'; 'EGU'; };
            set(handles.ListBox5, 'String',   EPICSFields);
            set(handles.ListBox5, 'UserData', EPICSFields);
            %iEPICS = get(handles.ListBox5, 'Value');
            iEPICS = getappdata(handles.figure1, 'iEPICS');
            if isempty(iEPICS)
                iEPICS = 1;
            end
            set(handles.ListBox5, 'Value', iEPICS);
            if ~isempty(EPICSFields)
                DotField = EPICSFields{iEPICS};
            end
            set(handles.ListBox5, 'Visible', 'On');
        else
            set(handles.ListBox5, 'Visible', 'Off');
        end

        if isempty(DotField) || strcmpi(DotField, 'VAL')
            % Get data all the data in the family
            try
                DataNew = getandplotdata(handles, Data0.FamilyName, Fields0, '', Data0.DeviceList);
            catch
                %fprintf('%s',lasterr);
                fprintf('   Problem occurred with family %s.\n', Data0.FamilyName);
                return
            end
        else
            % Get control system fields fields
            ListBox5_Callback([], [], handles);
        end

    elseif isnumeric(SubData) && strcmpi(DataField, 'Data')
        plotdatastruct(handles, Data, DataField);

    elseif strcmp(DataField, 'SpecialFunctionGet')
        % Plot the channels
        Data = getandplotdata(handles, Data0.FamilyName, Fields0, '', Data0.DeviceList);
               
    elseif isnumeric(SubData)
        
        set(handles.ListBox5, 'UserData', '');

        if isfield(Data,'FamilyName') && isfield(Data, 'DeviceList')
            PlotData = Data.(DataField);
            s = getspos(Data.FamilyName, Data.DeviceList);
            if size(SubData,1) == length(s) && size(SubData,2) == 1
                plot(handles.axes1, s, PlotData, '.-');
                xlabel(handles.axes1, 'Position [meters]');
                YLabelString = sprintf('%s.%s', Data.FamilyName, DataField);
                ylabel(handles.axes1, YLabelString);

                L = getfamilydata('Circumference');
                if ~isempty(L)
                    a = axis(handles.axes1);
                    axis(handles.axes1, [0 L a(3:4)]);
                end
                
                % Set the callback for mouse clicks on the plot
                setappdata(handles.figure1, 'SPosX', s);
                setappdata(handles.figure1, 'SPosY', PlotData);
                set(handles.axes1, 'ButtonDownFcn', 'mmlviewer(''Graph1_ButtonDown'',gcbo,[],guidata(gcbo))');
                h = get(handles.axes1, 'Children');
                for i = 1:length(h)
                    set(h(i) ,'ButtonDownFcn','mmlviewer(''Graph1_ButtonDown'',gcbo,[],guidata(gcbo))');
                end

                
                % Reset DataBox if the new data is a shorter list
                if get(handles.ListBoxData, 'Value') > size(SubData,1)
                    set(handles.ListBoxData, 'Value', 1);
                end

                DataMat = [];
                for ii = 1:size(Data.DeviceList,1)
                    DataMat = strvcat(DataMat, sprintf('%s(%d,%d) = %+.4e', Data.FamilyName, Data.DeviceList(ii,:), SubData(ii,1)));
                end
                if isempty(get(handles.ListBoxData,'String'))
                    WasEmpty = 1;
                else
                    WasEmpty = 0;
                end
                set(handles.ListBoxData,'String', DataMat);
                %set(handles.ListBoxData, 'String', num2str(Data));
                
                if WasEmpty
                    set(handles.ListBoxData, 'Value', get(Box1, 'Value'));
                else
                    set(Box1, 'Value', get(handles.ListBoxData, 'Value'));
                end
                set(handles.ListBoxData, 'Visible', 'On');

                DataText(handles, SubData);
            end
        end
    else
        CallNextListBox = 1;
    end

else
    % j points to a list
    % Look to match it with ListBoxData
    if size(get(Box0, 'String'),1) == size(get(handles.ListBoxData, 'String'),1)
        set(handles.ListBoxData, 'Value', get(Box0,'Value'));
    end
    
    % There shouldn't be anything in the next box at this point
    set(Box1, 'Value', 1);
    set(Box1, 'String', '');
end



function Data = getandplotdata(handles, Family, Field, SubField, DeviceListTotal)

if nargin < 4
    SubField = '';
end
if strcmpi(SubField, 'VAL')
    SubField = '';
end

if nargin < 5
    DeviceListTotal = family2dev(Family,0);
end

% Get data
try
    % Good channel device list
    DeviceList = family2dev(Family);
    iGood = findrowindex(DeviceList, DeviceListTotal);

    % This only works for scalar data
    Data = NaN * ones(size(DeviceListTotal,1),1);

    if isempty(SubField)
        % Get by family
        if ~isempty(iGood)
            DataGood = getpv(Family, Field, DeviceList);
            Data(iGood,:) = DataGood;
            DataCell = mat2cell(num2str(Data), ones(1,size(Data,1)));

            if strcmpi(get(handles.DataTypeString, 'Checked') , 'On')
                % Put strings in the list box
                DataGoodString = getpv(Family, Field, DeviceList, 'String');
                DataCell(iGood) = mat2cell(DataGoodString, ones(1,size(DataGoodString,1)));
            end
       
        end
        [Units, UnitsString] = getunits(Family, Field);
    else
        % Get by [channel.subfield]
        if ~isempty(iGood)
            ChanNames = family2channel(Family, Field, DeviceList);
            %ChanNames = get(handles.ListBox4, 'String');
            ChanNames = strcat(ChanNames, ['.',SubField]);

            % Try 1 channel name first, so the error condition does not take so long
            try
                DataGood = getpv(deblank(ChanNames(1,:)));

                DataGood = getpv(ChanNames);
                Data(iGood,:) = DataGood;
                DataCell = mat2cell(num2str(Data), ones(1,size(Data,1)));

                if strcmpi(get(handles.DataTypeString, 'Checked') , 'On')
                    % Put strings in the list box
                    DataGoodString = getpv(ChanNames, 'String');
                    DataCell(iGood) = mat2cell(DataGoodString, ones(1,size(DataGoodString,1)));
                end
            catch
                Data = NaN * ones(size(DeviceListTotal,1),1);
                %DataCell = mat2cell(num2str(Data), ones(1,size(Data,1)));
                for i = 1:size(Data)
                    DataCell{i,1} = 'No Data';
                end
            end

        end
        UnitsString = '';
    end
catch
    Data = NaN * ones(size(DeviceListTotal,1),1);
    %DataCell = mat2cell(num2str(Data), ones(1,size(Data,1)));
    for i = 1:size(Data)
        DataCell{i,1} = 'No Data';
    end
end


% Plot
try
    s = getspos(Family, DeviceListTotal);
    if isempty(s)
        s = 1:size(DeviceListTotal,1);
        NoSPositionFlag = 1;
    else
        NoSPositionFlag = 0;
    end
    plot(handles.axes1, s, Data, '.-');
    xlabel(handles.axes1, 'Position [meters]');

    YLabelString = sprintf('%s.%s', Family, Field);
    if ~isempty(SubField)
        YLabelString = sprintf('%s.%s', YLabelString, SubField);
    end
    if ~isempty(UnitsString)
        YLabelString = sprintf('%s [%s]', YLabelString, UnitsString);
    end        

    ylabel(handles.axes1, YLabelString);
    
    if ~NoSPositionFlag
        L = getfamilydata('Circumference');
        if ~isempty(L)
            a = axis(handles.axes1);
            axis(handles.axes1, [0 L a(3:4)]);
        end
    end
    
    % Set the callback for mouse clicks on the plot
    setappdata(handles.figure1, 'SPosX', s);
    setappdata(handles.figure1, 'SPosY', Data);
    set(handles.axes1, 'ButtonDownFcn', 'mmlviewer(''Graph1_ButtonDown'',gcbo,[],guidata(gcbo))');
    h = get(handles.axes1, 'Children');
    for i = 1:length(h)
        set(h(i) ,'ButtonDownFcn','mmlviewer(''Graph1_ButtonDown'',gcbo,[],guidata(gcbo))');
    end
    
    % Data list box

    % Change the value in the data list box before setting the new string
    DataValue = get(handles.ListBoxData, 'Value');
    if DataValue > size(Data,1)
        set(handles.ListBoxData, 'Value', 1);
        DataValue = 1;
    end

    %DataMat = [];
    %for ii = 1:size(DeviceListTotal,1)
    %    DataMat = strvcat(DataMat, sprintf('%s(%d,%d) = %+.4e', Family, DeviceListTotal(ii,:), Data(ii,1)));
    %end
    %set(handles.ListBoxData,'String', DataMat);
    %set(handles.ListBoxData, 'String', num2str(Data));

    CommonNames = family2common(Family, DeviceListTotal);
    for ii = 1:size(DeviceListTotal,1)
        DataCell{ii} = sprintf('%s = %s', CommonNames(ii,:), DataCell{ii});
    end
    %for ii = 1:size(DeviceListTotal,1)
    %    DataCell{ii} = sprintf('%s(%d,%d) = %s', Family, DeviceListTotal(ii,:), DataCell{ii});
    %end
    set(handles.ListBoxData,'String', DataCell);
    set(handles.ListBoxData, 'Visible', 'On');

    DataText(handles, Data, iGood);

catch
    set(handles.ListBoxData, 'Visible', 'Off');
    set(handles.DataText,    'Visible', 'Off');
    error('An error occurred in getandplotdata the %s family', Family);
end



function plotdatastruct(handles, d, Field)

s = getspos(d.FamilyName, d.DeviceList);
plot(handles.axes1, s, d.(Field), '.-');
xlabel(handles.axes1, 'Position [meters]');
ylabel(handles.axes1, sprintf('%s.%s [%s]', d.FamilyName, d.Field, d.UnitsString));

L = getfamilydata('Circumference');
if ~isempty(L)
    a = axis(handles.axes1);
    axis(handles.axes1, [0 L a(3:4)]);
end

% Set the callback for mouse clicks on the plot
setappdata(handles.figure1, 'SPosX', s);
setappdata(handles.figure1, 'SPosY', d.(Field));
set(handles.axes1, 'ButtonDownFcn', 'mmlviewer(''Graph1_ButtonDown'',gcbo,[],guidata(gcbo))');
h = get(handles.axes1, 'Children');
for i = 1:length(h)
    set(h(i) ,'ButtonDownFcn','mmlviewer(''Graph1_ButtonDown'',gcbo,[],guidata(gcbo))');
end

% Data list box
if get(handles.ListBoxData, 'Value') > size(d.Data,1)
    set(handles.ListBoxData, 'Value', 1);
end

DataMat = [];
for ii = 1:size(d.DeviceList,1)
    DataMat = strvcat(DataMat, sprintf('%s(%d,%d) = %+.4e', d.FamilyName, d.DeviceList(ii,:), d.Data(ii,1)));
end
set(handles.ListBoxData,'String', DataMat);
%set(handles.ListBoxData, 'String', num2str(Data));

set(handles.ListBoxData, 'Visible', 'On');

DataText(handles, d.Data);



function DataText(handles, Data, iGood)

if nargin < 3
    iGood = 1:size(Data,1);
end

if isempty(iGood)
    set(handles.DataText, 'Visible', 'Off');
else
    MeanText = sprintf('Mean = %+9.6e', mean(Data(iGood)));
    RMSText  = sprintf('RMS  = %+9.6e', (length(Data(iGood))-1)*std(Data(iGood))/length(Data(iGood)));
    MaxText  = sprintf('Max   = %+9.6e',  max(Data(iGood)));
    MinText  = sprintf('Min    = %+9.6e',  min(Data(iGood)));
    set(handles.DataText, 'String', {MeanText; RMSText; MaxText; MinText});
    set(handles.DataText, 'FontSize', 8);
    if isnan(mean(Data(iGood)))
        set(handles.DataText, 'Visible', 'Off');
    else
        set(handles.DataText, 'Visible', 'On');
    end
end


% --------------------------------------------------------------------
function ViewAO_Callback(hObject, eventdata, handles)

[Fields, RootStruct] = getfamilylist('Cell');
setappdata(handles.figure1, 'RootStruct', RootStruct);

set(handles.ListBox1, 'Value', 1);
set(handles.ListBox1, 'String', Fields);
ListBox1_Callback(hObject, eventdata, handles);

set(handles.ViewAO,         'Checked' , 'On');
set(handles.ViewAD,         'Checked' , 'Off');
set(handles.ViewProduction, 'Checked' , 'Off');
set(handles.ViewInjection,  'Checked' , 'Off');
set(handles.ViewFile,       'Checked' , 'Off');


% --------------------------------------------------------------------
function ViewAD_Callback(hObject, eventdata, handles)

RootStruct = getad;
Fields = fieldnames(RootStruct);
setappdata(handles.figure1, 'RootStruct', RootStruct);

set(handles.ListBox1, 'Value', 1);
set(handles.ListBox1, 'String', Fields);
ListBox1_Callback(hObject, eventdata, handles);

set(handles.ViewAO,         'Checked' , 'Off');
set(handles.ViewAD,         'Checked' , 'On');
set(handles.ViewProduction, 'Checked' , 'Off');
set(handles.ViewInjection,  'Checked' , 'Off');
set(handles.ViewFile,       'Checked' , 'Off');


% --------------------------------------------------------------------
function ViewProduction_Callback(hObject, eventdata, handles)

[RootStruct, Monitor, FileName] = getproductionlattice;
Fields = fieldnames(RootStruct);
setappdata(handles.figure1, 'RootStruct', RootStruct);

set(handles.ListBox1, 'Value', 1);
set(handles.ListBox1, 'String', Fields);
ListBox1_Callback(hObject, eventdata, handles);

set(handles.ViewAO,         'Checked' , 'Off');
set(handles.ViewAD,         'Checked' , 'Off');
set(handles.ViewProduction, 'Checked' , 'On');
set(handles.ViewInjection,  'Checked' , 'Off');
set(handles.ViewFile,       'Checked' , 'Off');


% --------------------------------------------------------------------
function ViewInjection_Callback(hObject, eventdata, handles)

[RootStruct, Monitor, FileName] = getinjectionlattice;
Fields = fieldnames(RootStruct);
setappdata(handles.figure1, 'RootStruct', RootStruct);

set(handles.ListBox1, 'Value', 1);
set(handles.ListBox1, 'String', Fields);
ListBox1_Callback(hObject, eventdata, handles);

set(handles.ViewAO,         'Checked' , 'Off');
set(handles.ViewAD,         'Checked' , 'Off');
set(handles.ViewProduction, 'Checked' , 'Off');
set(handles.ViewInjection,  'Checked' , 'On');
set(handles.ViewFile,       'Checked' , 'Off');


% --------------------------------------------------------------------
function ViewFile_Callback(hObject, eventdata, handles)

[RootStruct, Monitor, FileName] = getlattice;
if FileName == 0
    return;
end
Fields = fieldnames(RootStruct);
setappdata(handles.figure1, 'RootStruct', RootStruct);

set(handles.ListBox1, 'Value', 1);
set(handles.ListBox1, 'String', Fields);
ListBox1_Callback(hObject, eventdata, handles);

set(handles.ViewAO,         'Checked' , 'Off');
set(handles.ViewAD,         'Checked' , 'Off');
set(handles.ViewProduction, 'Checked' , 'Off');
set(handles.ViewInjection,  'Checked' , 'Off');
set(handles.ViewFile,       'Checked' , 'On');


% --------------------------------------------------------------------
function DataTypeDouble_Callback(hObject, eventdata, handles)
set(handles.DataTypeDouble, 'Checked' , 'On');
set(handles.DataTypeString, 'Checked' , 'Off');
ListBox1_Callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function DataTypeString_Callback(hObject, eventdata, handles)
set(handles.DataTypeDouble, 'Checked' , 'Off');
set(handles.DataTypeString, 'Checked' , 'On');
ListBox1_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function PopPlot_Callback(hObject, eventdata, handles)
a = figure;
b = copyobj(handles.axes1, a); 
set(b, 'Position', [0.1300    0.1100    0.7750    0.8150]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');


% --------------------------------------------------------------------
function PopPlotHoldOn_Callback(hObject, eventdata, handles)

% Find the figure that is not the current figure
h = get(0,'children');

a = [];
for i = 1:length(h)
    if h(i)~=handles.figure1 && strcmpi(get(h(i),'Type'),'figure') && strcmpi(get(h(i),'Visible'),'On')
        a = h(i);
        break;
    end
end
if isempty(a)
    PopPlot_Callback(hObject, eventdata, handles);
    return;
end

x = getappdata(handles.figure1, 'SPosX');
y = getappdata(handles.figure1, 'SPosY');

figure(a);
LegendHandle = legend; %findobj(a, 'tag', 'legend');
YLabelOld = get(get(gca,'ylabel'),'String');
YLabelNew = get(get(handles.axes1,'ylabel'),'String');

hold on;
Color = nxtcolor;
plot(x, y, '.-', 'Color', Color);
hold off

axis tight;
L = getfamilydata('Circumference');
if ~isempty(L)
    a = axis(handles.axes1);
    axis(handles.axes1, [0 L a(3:4)]);
end

if isempty(LegendHandle)
    if isempty(YLabelOld)
        LegendCell = {};
    else
        LegendCell = {YLabelOld};
    end
else
    LegendHandle = LegendHandle(1);
    LegendCell = get(LegendHandle, 'String');
    if ~iscell(LegendCell)
        LegendCell = {LegendCell};
    end
end
LegendCell(end+1) = {YLabelNew};
legend(LegendCell);

set(get(gca,'ylabel'),'String','');
