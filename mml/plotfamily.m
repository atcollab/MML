function varargout = plotfamily(varargin)
%PLOTFAMILY - Plots by middle layer family name
%
%  To restrict the families to certain MemberOf group use:
%  plotfamily MemberName
%
%  FACTS
%  1. Clicking on a data point in the plot will select the device in the
%     listbox.  Clicking in the listbox will allow for a setpoint change.
%
%  2. The lattice plot can also be used to change the setpoint.
%     Just click on an object in the lattice drawing.  To remove the 
%     setpoint widget click on a drift pass or BPM.  Note that HCMs are
%     drawn above the axis and VCMs below.
%
%  3. The "Common Tasks" menu is a launch pad menu.  It actually has nothing
%     to do with of the plotfamily application.  Many of the typical
%     tasks for setup of storage rings are listed in this menu. 
%
%  4. Use plotfamilystartup to customize it for a particular accelerator.
%     (Look at the ALS for an example.)
%
%  5. This application can be compiled to run standalone.

%  Written by Greg Portmann


% Last Modified by GUIDE v2.5 17-Jan-2016 23:00:04


% For the compiler
%#function plotfamilystartup
%#function aoinit setao setoperationalmode srinit
%#function srcycle getmachineconfig setmachineconfig 
%#function setorbitdefault findrf findrf2 rmdisp setgolden setoffset
%#function settune steptune setchro stepchro
%#function plotorbit plotorbitdata plotcm plotgoldenorbit plotoffsetorbit
%#function plotorbit plotdata plotbpmresp plotbpmrespsym
%#function plotlattice plotdisp plotchro
%#function monbpm getbpm monmags
%#function gettune  
%#function measchro plotchro
%#function measdisp plotdisp
%#function measbpmresp meastuneresp quadcenter
%#function copybpmrespfile
%#function copybpmsigmafile
%#function copychrorespfile
%#function copydispersionfile
%#function copydisprespfile
%#function copyinjectionconfigfile
%#function copymachineconfigfile
%#function copytunerespfile
%#function measlocodata locogui buildlocoinput buildloco buildlocofitparameters



% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @plotfamily_OpeningFcn, ...
    'gui_OutputFcn',  @plotfamily_OutputFcn, ...
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


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes just before plotfamily is made visible.
function plotfamily_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotfamily (see VARARGIN)

% Choose default command line output for plotfamily
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotfamily wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%%%%%%%%%%%%%%%
% Set defaults %
%%%%%%%%%%%%%%%%
UpdatePeriod = 1;
set(handles.('UpdatePeriod'),'Label', sprintf('Update Period = %.2f sec',UpdatePeriod));
setappdata(handles.figure1, 'UpdatePeriod', UpdatePeriod);

% Units  (This should get over written by the default for the BPM family)
setappdata(handles.figure1,'UnitsFlag', 2);
set(handles.('PhysicsUnitsFlag'),'Checked','Off');
set(handles.('HardwareUnitsFlag'),'Checked','On');
set(handles.('MicronFlag'),'Checked','Off');

setappdata(handles.figure1,'ChannelA',1);
setappdata(handles.figure1,'ChannelB',2);

% Set the trace 1 defaults
%setappdata(handles.figure1,'Trace1',1);
set(handles.('DisplayDiff'),'Value', 1);
set(handles.('Display1'),'Value', 0);
set(handles.('Display2'),'Value', 0);
setappdata(handles.figure1,'Trace1',3);

setappdata(handles.figure1,'Trace2',4);


% Run initialization if it has not been run (like standalone)
checkforao;


if isempty(varargin)
    MemberofField = 'PlotFamily';
else
    MemberofField = varargin{1};
end

% Build Family menu
FoundOne = 0;
FamilyName = getfamilylist;
for i = 1:size(FamilyName,1)
    Family = deblank(FamilyName(i,:));
    
    try
        spos = getspos(Family);
    catch
        spos = [];
    end
    
    % Only include if there are S-position for the family 
    if ~isempty(spos)
        FieldList = '';
        if ismemberof(Family, MemberofField)
            %if ismemberof(Family, 'plotfamily') | ismemberof(Family, 'Save/Restore') | ismemberof(Family, 'BPM') | ...
            %        ismemberof(Family, 'COR') | ismemberof(Family, 'QUAD') | ...
            %        ismemberof(Family, 'HCM') | ismemberof(Family, 'VCM') | ...
            %        ismemberof(Family, 'SEXT') | ismemberof(Family, 'BEND') | ...
            %        ismemberof(Family, 'SkewQuad') | ismemberof(Family, 'SQSF') | ismemberof(Family, 'SQSD')
            FieldList = 'Monitor';
            FoundOne = 1;
        end
        
        % Look if any other fields are part of the MachineConfig
        AOFamily = getfamilydata(Family);
        FieldNameCell = fieldnames(AOFamily);
        for j = 1:size(FieldNameCell,1)
            if isfield(AOFamily.(FieldNameCell{j}),'MemberOf')
                if any(strcmpi(AOFamily.(FieldNameCell{j}).MemberOf, MemberofField))
                    %if any(strcmpi(AOFamily.(FieldNameCell{j}).MemberOf, MemberofField)) | any(strcmpi(AOFamily.(FieldNameCell{j}).MemberOf, 'Save/Restore'))
                    FieldList = strvcat(FieldList,FieldNameCell{j});
                    FoundOne = 1;
                end
            end
        end
        
        % Remove repeats but keep the row order
        [FieldListUnique, ii, jj] = unique(FieldList, 'rows');
        jj(find(diff(jj)==0)) = [];
        FieldList = FieldListUnique(jj,:);
        
        if size(FieldList,1) == 1
            Menu1 = handles.('BPMxFamily');
            Menu2 = handles.('BPMyFamily');
            h1 = uimenu(Menu1, 'Label',sprintf('%s',Family), 'Callback','plotfamily(''BPMxFamily_Callback'',gcbo,[],guidata(gcbo))');
            h2 = uimenu(Menu2, 'Label',sprintf('%s',Family), 'Callback','plotfamily(''BPMyFamily_Callback'',gcbo,[],guidata(gcbo))');
            set(h1, 'UserData', family2datastruct(Family, deblank(FieldList)));
            set(h2, 'UserData', family2datastruct(Family, deblank(FieldList)));
            
        elseif size(FieldList,1) > 1
            % Build off an extra menu
            Menu1 = handles.('BPMxFamily');
            Menu2 = handles.('BPMyFamily');
            Menu1 = uimenu(Menu1, 'Label', Family);
            Menu2 = uimenu(Menu2, 'Label', Family);
            
            for iField = 1:size(FieldList,1)
                h1 = uimenu(Menu1, 'Label',sprintf('%s.%s',Family,deblank(FieldList(iField,:))), 'Callback','plotfamily(''BPMxFamily_Callback'',gcbo,[],guidata(gcbo))');
                h2 = uimenu(Menu2, 'Label',sprintf('%s.%s',Family,deblank(FieldList(iField,:))), 'Callback','plotfamily(''BPMyFamily_Callback'',gcbo,[],guidata(gcbo))');
                set(h1, 'UserData', family2datastruct(Family, deblank(FieldList(iField,:))));
                set(h2, 'UserData', family2datastruct(Family, deblank(FieldList(iField,:))));
            end
        else
            % Skip family
        end
    end
end


if ~FoundOne
    % if MemberOf came up empty, then put all the families in the menu
    for i = 1:size(FamilyName,1)
        try
            Family = deblank(FamilyName(i,:));
            FamilyStruct = family2datastruct(Family,'Monitor');
            spos = getspos(FamilyStruct);
            if ~isempty(spos)
                h1 = uimenu(handles.('BPMxFamily'), 'Label',Family, 'Callback','plotfamily(''BPMxFamily_Callback'',gcbo,[],guidata(gcbo))');
                h2 = uimenu(handles.('BPMyFamily'), 'Label',Family, 'Callback','plotfamily(''BPMyFamily_Callback'',gcbo,[],guidata(gcbo))');
                set(h1, 'UserData', FamilyStruct);
                set(h2, 'UserData', FamilyStruct);
            end
        catch
            % Skip family
            %fprintf('Skipping family %s',Family);
        end
    end
end


% Initial families
try
    % Default orbit family names
    %BPMxFamily = gethbpmfamily;
    %
    %if isempty(BPMxFamily)
    %    FamilyList = getfamilylist;
    %    BPMxFamily = deblank(FamilyList(1,:));
    %end
    %BPMyFamily = getvbpmfamily;
    %if isempty(BPMyFamily)
    %    FamilyList = getfamilylist;
    %    BPMyFamily = deblank(FamilyList(2,:));
    %end
    %BPMxField = 'Monitor';
    %BPMyField = 'Monitor';
    %BPMxList = family2dev(BPMxFamily, 1);
    %BPMyList = family2dev(BPMyFamily, 1);
    %
    %set(handles.('BPMxFamily'),'Label',sprintf('Plot: %s', BPMxFamily));
    %set(handles.('BPMyFamily'),'Label',sprintf('Plot: %s', BPMyFamily));
    %
    %RawX = family2datastruct(BPMxFamily, BPMxField, BPMxList, UnitsFlag);
    %RawY = family2datastruct(BPMyFamily, BPMyField, BPMyList, UnitsFlag);
    %RawX.Data = zeros(size(BPMxList,1),1);
    %RawY.Data = zeros(size(BPMyList,1),1);
    
    
    % Base on first 2 families
    FamilyHandles = get(handles.('BPMxFamily'),'Children');
    if length(FamilyHandles) >= 1
        RawX = get(FamilyHandles(end),'UserData');
        if isempty(RawX)
            FamilyHandles2 = get(FamilyHandles(end),'Children');
            RawX = get(FamilyHandles2(end),'UserData');
        end
        BPMxFamily = RawX.FamilyName;
    else
        fprintf('   No families in the MML.\n');
    end
    if length(FamilyHandles) >= 2
        RawY = get(FamilyHandles(end-1),'UserData');
        if isempty(RawY)
            FamilyHandles2 = get(FamilyHandles(end-1),'Children');
            RawY = get(FamilyHandles2(end),'UserData');
        end
        BPMyFamily = RawY.FamilyName;
    else
        RawY = RawX;
        BPMyFamily = RawX.FamilyName;
    end

    % Initialize Mode
    % if strcmpi(get(handles.Simulate,'Checked'),'On')
    %     Mode = 'Simulator';
    % else
    %     Mode = 'Online';
    % end
    if strcmpi(RawX.Mode,'SIMULATOR')
        set(handles.Online,'Checked','Off');
        set(handles.Simulate,'Checked','On');
        Mode = 'Simulator';
        SetFigureTitle(handles.figure1, 'Model');
    else
        set(handles.Online,'Checked','On');
        set(handles.Simulate,'Checked','Off');
        Mode = 'Online';
        SetFigureTitle(handles.figure1, 'Online')
    end
        

    % Initialize Units
    if strcmpi(RawX.Units,'Physics')
        setappdata(handles.figure1,'UnitsFlag', 1);
        set(handles.('PhysicsUnitsFlag'),'Checked','On');
        set(handles.('HardwareUnitsFlag'),'Checked','Off');
        set(handles.('MicronFlag'),'Checked','Off');
        UnitsFlag = 'Physics';
    else
        setappdata(handles.figure1,'UnitsFlag', 2);
        set(handles.('PhysicsUnitsFlag'),'Checked','Off');
        set(handles.('HardwareUnitsFlag'),'Checked','On');
        set(handles.('MicronFlag'),'Checked','Off');
        UnitsFlag = 'Hardware';
    end

    set(handles.BPMxFamily,'Label',sprintf('Plot: %s', BPMxFamily));
    set(handles.BPMyFamily,'Label',sprintf('Plot: %s', BPMyFamily));

    % Create the list box string
    RawX = CreateListboxString(RawX);
    RawY = CreateListboxString(RawY);

    setappdata(handles.figure1, 'BPMxFamily', RawX);
    setappdata(handles.figure1, 'BPMyFamily', RawY);

    setappdata(handles.figure1,'RawX', RawX);
    setappdata(handles.figure1,'RawY', RawY);

    setappdata(handles.figure1,'SaveX', RawX);
    setappdata(handles.figure1,'SaveY', RawY);
    set(handles.SaveTime,'String', '');

    setappdata(handles.figure1,'FileX', RawX);
    setappdata(handles.figure1,'FileY', RawY);

    setappdata(handles.figure1,'FileNameX','');
    setappdata(handles.figure1,'FileNameY','');
    
    set(handles.FileNameX,'String', '');
    set(handles.FileNameY,'String', '');

    %p = get(handles.FileNameX,'Position');
    %set(handles.FileNameX,'Position', [p(1) 4 p(3) p(4)]);    % Points
    %set(handles.FileNameX,'Position', [p(1) .8 p(3) p(4)]);   % Characters
    %set(handles.FileNameX,'Position', [p(1) 0.02 p(3) p(4)]); % Normalized
    %p = get(handles.SaveTime,'Position');
    %set(handles.SaveTime,'Position', [p(1) 16.5 p(3) p(4)]);  % Points
    %set(handles.SaveTime,'Position', [p(1) 1.6 p(3) p(4)]);   % Characters
    %set(handles.SaveTime,'Position', [p(1) 0.052 p(3) p(4)]); % Normalized
    
    % Look to see it the AT model needs to be changed for this family
    ATModelNumber = getfamilydata(BPMxFamily, 'AT', 'ATModel');
    if ~isempty(ATModelNumber)
        global THERING THERINGCELL
        THERING = THERINGCELL{ATModelNumber};
        setfamilydata(findspos(THERING,length(THERING)+1), 'Circumference');
    end

catch

    % Starting units
    UnitMenu = getappdata(handles.figure1,'UnitsFlag');
    if UnitMenu == 1
        UnitsFlag = 'Physics';
    else
        UnitsFlag = 'Hardware';
    end

    % Initialize Mode
    if strcmpi(get(handles.Simulate,'Checked'),'On')
        Mode = 'Simulator';
    else
        Mode = 'Online';
    end

end


% % Look for the golden values
% try
%     GoldenValues = getgolden(BPMxFamily, BPMxList, 'Struct');
%     setappdata(handles.figure1,'GoldenX', GoldenValues);
% catch
%     setappdata(handles.figure1,'GoldenX', RawX);
% end
% 
% % Look for the offset values
% try
%     OffsetValues = getoffset(BPMxFamily, BPMxList, 'Struct');
%     setappdata(handles.figure1,'OffsetX', OffsetValues);
% catch
%     if isempty(OffsetValues)
%         try 
%             % If and offset does not exist than try using the setpoint
%             setappdata(handles.figure1,'OffsetX', getsp(BPMxFamily, BPMxList, Mode, 'Struct'));                
%         catch
%             % Use zeros
%             setappdata(handles.figure1,'OffsetX', RawX);
%         end
%     end
% end
% 
% % Look for the golden values
% try
%     GoldenValues = getgolden(BPMyFamily, BPMyList, 'Struct');
%     setappdata(handles.figure1,'GoldenY', GoldenValues);
% catch
%     setappdata(handles.figure1,'GoldenY', RawY);
% end
% 
% % Look for the offset values
% try
%     OffsetValues = getoffset(BPMyFamily, BPMyList, 'Struct');
%     setappdata(handles.figure1,'OffsetY', OffsetValues);
% catch
%     try 
%         % If and offset does not exist than try using the setpoint
%         setappdata(handles.figure1,'OffsetY', getsp(BPMyFamily, BPMyList, Mode, 'Struct'));                
%     catch
%         % Use zeros
%         setappdata(handles.figure1,'OffsetY', RawY);
%     end
% end

L = getfamilydata('Circumference');

try
    s = getspos(RawX);
    setappdata(handles.figure1, 'SPosX', s);
    if isempty(L)
        L = max(s);
    end
    %setappdata(handles.figure1, 'AxisRange1X', [min(s) max(s)]);
catch
    %setappdata(handles.figure1, 'SPosX', 1:size(RawX.DeviceList,1));
end
setappdata(handles.figure1, 'AxisRange1X', [0 L]);

try
    s = getspos(RawY);
    setappdata(handles.figure1, 'SPosY', s);
    %setappdata(handles.figure1, 'AxisRange2X', [min(s) max(s)]);
catch
    %setappdata(handles.figure1, 'SPosY', 1:size(RawY.DeviceList,1));
end
setappdata(handles.figure1, 'AxisRange2X', [0 L]);


% Update time
set(handles.Time, 'String', '');


% Initialize plots
set(handles.Graph1, 'XLim', [0 L]);
set(handles.Graph2, 'XLim', [0 L]);

p1 = [0.07    0.65    0.74    0.29];
set(handles.Graph1, 'Position', p1);
set(handles.Graph3, 'Position', p1);

p2 = [0.07    0.27    0.74    0.29];
set(handles.Graph2, 'Position', p2);
set(handles.Graph4, 'Position', p2);

plot(handles.Graph3, NaN, NaN);
set(handles.Graph3, 'Visible', 'Off');
set(handles.Graph3, 'color', 'none');
set(handles.Graph3, 'XLim', [0 L]);

plot(handles.Graph4, NaN, NaN);
set(handles.Graph4, 'Visible', 'Off');
set(handles.Graph4, 'color', 'none');
set(handles.Graph4, 'XLim', [0 L]);


%axes(handles.LatticeAxes);
try
    % Add the lattice drawing 
    drawlattice(0, 1.1, handles.LatticeAxes);

    % Match with DrawLattice_Callback
    g = .01;
    p1 = [0.07    0.65+g    0.74    0.29-g];
    set(handles.Graph1, 'Position', p1);
    set(handles.Graph3, 'Position', p1);

    p2 = [0.07    0.27      0.74    0.29-g];
    set(handles.Graph2, 'Position', p2);
    set(handles.Graph4, 'Position', p2);

    set(handles.LatticeAxes, 'Units', 'Normalized');
    %P = get(handles.LatticeAxes, 'Position');
    set(handles.LatticeAxes, 'Position', [0.07 0.5744-g 0.74 0.07+2*g]);  % p4 was 0.065
catch
    % Remove the lattice drawing
    d = .015;  % Match with DrawLattice_Callback
    p1 = [0.07    0.65-d    0.74    0.29+d];
    set(handles.Graph1, 'Position', p1);
    set(handles.Graph3, 'Position', p1);

    p2 = [0.07    0.27    0.74    0.29+d];
    set(handles.Graph2, 'Position', p2);
    set(handles.Graph4, 'Position', p2);

    set(handles.DrawLattice, 'Checked', 'Off');
    set(get(handles.LatticeAxes,'Children'), 'Visible' , 'Off');
end

try
    set(handles.LatticeAxes,'Visible','Off');
    set(handles.LatticeAxes,'Color','None');
    set(handles.LatticeAxes,'XMinorTick','Off');
    set(handles.LatticeAxes,'XMinorGrid','Off');
    set(handles.LatticeAxes,'YMinorTick','Off');
    set(handles.LatticeAxes,'YMinorGrid','Off');
    set(handles.LatticeAxes,'XTickLabel',[]);
    set(handles.LatticeAxes,'YTickLabel',[]);
    set(handles.LatticeAxes,'XLim', [0 L]);
    set(handles.LatticeAxes,'YLim', [-1.5 1.5]);


    % Add callback on each lattice element
    % set(handles.LatticeAxes ,'ButtonDownFcn','plotfamily(''Lattice_ButtonDown'',gcbo,[],guidata(gcbo))');
    h = get(handles.LatticeAxes,'Children');
    for i = 1:length(h)
        %ATIndex = get(h(i), 'UserData');
        set(h(i), 'ButtonDownFcn', 'plotfamily(''Lattice_ButtonDown'',gcbo,[],guidata(gcbo))');
    end
catch
end




% % Build middle layer edit menus
% %h = addmenuao(handles.('EditMiddleLayerAO'));
% %set(h, 'Label', 'Middle Layer Family Setup');
% 
% hmenu = handles.('EditMiddleLayerAO');
% LabelString = 'Middle Layer Family Setup';
% ParentLabelString = 'MiddleLayer';
% DataStructure0 = getao;
% if isempty(DataStructure0)
%     aoinit;
% end
% 
% 
% % Build middle menu tree
% DataStructFieldName1 = fieldnames(DataStructure0);
% for i = 1:length(DataStructFieldName1)   
%     DataStructure1 = DataStructure0.(DataStructFieldName1{i});
%     if isstruct(DataStructure1)
%         hmenu1 = uimenu(hmenu, 'Label',DataStructFieldName1{i}, 'Callback','');       
%         DataStructFieldName2 = fieldnames(DataStructure1);
%         for j = 1:length(DataStructFieldName2)
%             DataStructure2 = DataStructure1.(DataStructFieldName2{j});
%             if isstruct(DataStructure2)
%                 hmenu2 = uimenu(hmenu1, 'Label',DataStructFieldName2{j}, 'Callback','');       
%                 DataStructFieldName3 = fieldnames(DataStructure2);
%                 for k = 1:length(DataStructFieldName3)
%                     DataStructure3 = DataStructure2.(DataStructFieldName3{k});
%                     if isstruct(DataStructure3)
%                         hmenu3 = uimenu(hmenu2, 'Label',DataStructFieldName3{k}, 'Callback','');
%                         DataStructFieldName4 = fieldnames(DataStructure3);
%                         for l = 1:length(DataStructFieldName4)
%                             hmenu4 = uimenu(hmenu3, 'Label', DataStructFieldName4{l});
%                             set(hmenu4,'UserData', {DataStructure3.(DataStructFieldName4{l}) , DataStructFieldName1{l}, DataStructFieldName2{k}, DataStructFieldName3{k}, DataStructFieldName4{i}});      
%                             set(hmenu4,'Callback', 'plotfamily(''EditMiddleLayer_Callback'',gcbo,[],guidata(gcbo))');
%                         end
%                     else
%                         hmenu3 = uimenu(hmenu2, 'Label',DataStructFieldName3{k});
%                         set(hmenu3,'UserData', {DataStructure3, DataStructFieldName1{i}, DataStructFieldName2{j}, DataStructFieldName3{k}});      
%                         set(hmenu3,'Callback', 'plotfamily(''EditMiddleLayer_Callback'',gcbo,[],guidata(gcbo))');
%                     end
%                 end
%             else
%                 hmenu2 = uimenu(hmenu1, 'Label',DataStructFieldName2{j});
%                 set(hmenu2,'UserData', {DataStructure2, DataStructFieldName1{i}, DataStructFieldName2{j}});      
%                 set(hmenu2,'Callback', 'plotfamily(''EditMiddleLayer_Callback'',gcbo,[],guidata(gcbo))');
%             end
%         end
%     else
%         hmenu1 = uimenu(hmenu, 'Label', DataStructFieldName1{i});                   
%         set(hmenu1,'UserData', {DataStructure1, DataStructFieldName1{i}});      
%         set(hmenu1,'Callback', 'plotfamily(''EditMiddleLayer_Callback'',gcbo,[],guidata(gcbo))');
%     end
% end


% % Build the AD menu
% set(addmenuad(handles.EditMiddleLayerAD), 'Label', 'Middle Layer Parameter Setup');
set(handles.EditMiddleLayerAO, 'Visible', 'Off');
set(handles.EditMiddleLayerAD, 'Visible', 'Off');


% Machine specific startup function
if exist('plotfamilystartup', 'file')
    plotfamilystartup(handles);
end


% Setup Timer
%UpdatePeriod = 1;
UpdatePeriod = getappdata(handles.figure1, 'UpdatePeriod');

t = timer;
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
set(t, 'TimerFcn', {@OneShot_Callback,handles});
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
%set(t, 'TasksToExecute', 50);
%set(t, 'ErrorFcn', {@Timer_Error,handles});
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'PlotFamilyTimer');

handles.TimerHandle = t;

% Draw the figure
set(handles.figure1, 'Visible', 'On');
drawnow expose

% Save handles
guidata(handles.figure1, handles);


%start(t);



% --------------------------------------------------------------------
function SetFigureTitle(h_fig, ModeString)

MachineName     = getfamilydata('Machine');
SubMachineName  = getfamilydata('SubMachine');
OperationalMode = getfamilydata('OperationalMode');
try
    if isdeployed
        TitleString = sprintf('Plot Family:  %s  -  %s  -  %s  (%s - Standalone)', MachineName, SubMachineName, OperationalMode, ModeString);
    else
        TitleString = sprintf('Plot Family:  %s  -  %s  -  %s  (%s)', MachineName, SubMachineName, OperationalMode, ModeString);
    end
catch
    TitleString = sprintf('Plot Family:  %s  -  %s  -  %s  (%s)', MachineName, SubMachineName, OperationalMode, ModeString);
end

set(h_fig,'Name',TitleString);



% --------------------------------------------------------------------
function Resize_Callback(hObject, eventdata, handles)

% SmallestPositionX = 174.800;
% SmallestPositionY  = 39.7692;
% 
% % Units should be characters anyways
% Units = get(hObject,'Units');
% set(hObject,'Units', 'Characters');
% P = get(hObject, 'Position');
% 
% if P(3) < SmallestPositionX
%    P(3) = SmallestPositionX;
%    
%    if P(1)+P(3) < 0
%    end
% end
% 
% 
% if P(4) < SmallestPositionY
%    P(4) = SmallestPositionY;
% end
% 
% set(hObject, 'Position', P);
% set(hObject, 'Units', Units);



% --- Outputs from this function are returned to the command line.
function varargout = plotfamily_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isfield(handles,'output')
    varargout{1} = handles.output;
end


% --- Executes onoff button press in OnOff.
function EditMiddleLayer_Callback(hObject, eventdata, handles)

Data = get(hObject, 'UserData');

% Get up-to-date data
Data{1} = getfamilydata(Data{2:end});
TitleString = sprintf('%s ',Data{2:end});
AddOpts.Resize='on';
AddOpts.WindowStyle='normal';
AddOpts.Interpreter='tex';

if length(Data) >= 3 && (strcmpi(deblank(Data{3}),'Status') || strcmpi(deblank(Data{3}),'DeviceList') || strcmpi(deblank(Data{3}),'ElementList')) 
    if strcmpi(deblank(Data{3}),'ElementList')
        DeviceList = getfamilydata(deblank(Data{2}), 'ElementList');
    else
        DeviceList = getfamilydata(deblank(Data{2}), 'DeviceList');
    end
    Status = getfamilydata(deblank(Data{2}), 'Status');
    DeviceListNew = editlist(DeviceList, deblank(Data{2}), Status);
    
    [i, iNotFound] = findrowindex(DeviceListNew, DeviceList);
    
    if size(Status,1) == 1
        DeviceListTotal = family2dev(Data{2}, 0);
        Status = zeros(size(DeviceListTotal,1),1);
    else
        Status = 0 * Status;
    end
    Status(i) = 1;
    setfamilydata(Status, deblank(Data{2}), 'Status'); 
    
elseif isnumeric(Data{1})
    answer = inputdlg({sprintf('Change %s ',TitleString)}, 'Edit Middle Layer Family', size(Data{1},1), {num2str(Data{1})}, AddOpts);
    if isempty(answer)
        return
    end
    Data{1} = str2num(answer{1});
    set(hObject, 'UserData', Data);
    setfamilydata(Data{1:end});
elseif strcmpi(Data{2},'Directory')
    answer = uigetdir(Data{1}, sprintf('Change directory location for %s', Data{3}));
    if answer == 0
        return
    end
    Data{1} = answer;
    set(hObject, 'UserData', Data);
    setfamilydata(Data{1:end});    
    
elseif ischar(Data{1})
    answer = inputdlg({sprintf('Change %s ',TitleString)}, 'Edit Middle Layer Family', size(Data{1},1), {num2str(Data{1})}, AddOpts);
    if isempty(answer)
        return
    end
    Data{1} = answer{1};
    set(hObject, 'UserData', Data);
    setfamilydata(Data{1:end});
end


% Reset graphs
BPMxFamily_Callback([], eventdata, handles);
BPMyFamily_Callback([], eventdata, handles);



function Delete_Callback(hObject, eventdata, handles)

% If timer is on, then turn it off by deleting the timer handle
try
    %h = get(gcbf, 'UserData');
    h = get(handles.figure1, 'UserData');
    if isfield(h,'TimerHandle')
        stop(h.TimerHandle);
        delete(h.TimerHandle);
    end
catch
    fprintf('   Trouble stopping the timer on exit.\n');
end



% --- Executes onoff button press in OnOff.
function Timer_Callback(hObject, eventdata, handles)
% Timer method

%disp('Timer executed.');
%handles = get(eventdata, 'UserData');
handles = get(hObject, 'UserData');
plotfamily('OneShot_Callback', hObject, [], handles);


% --- Executes onoff button press in OnOff.
function OnOff_Callback(hObject, eventdata, handles)
% Timer method

% % Update the title bar
% if strcmpi(get(handles.Simulate,'Checked'),'On')
%     SetFigureTitle(handles.figure1, 'Model');
% else
%     SetFigureTitle(handles.figure1, 'Online');
% end

OnFlag = get(handles.OnOff, 'Value');

if OnFlag
    % Turn on updates
    UpdatePeriod = getappdata(handles.figure1, 'UpdatePeriod');
    set(handles.TimerHandle, 'Period', UpdatePeriod);
    set(handles.OnOff, 'String', 'Running');    
    %set(handles.figure1, 'UserData', handles);
    start(handles.TimerHandle);
    
else
    try
        % Turn off updating by deleting timer handle
%         h = get(handles.figure1, 'UserData');
%         stop(h.TimerHandle);
%         delete(h.TimerHandle);
%         h = rmfield(h, 'TimerHandle');
%         set(handles.figure1, 'UserData', h);

        stop(handles.TimerHandle);

        % Change OnOff label string
        set(handles.OnOff, 'String', 'Continuous');
    catch
        fprintf('   Trouble stopping the timer.\n');
    end
end


% % --- Executes onoff button press in OnOff.
% function OnOff_Callback(hObject, eventdata, handles)
% % Uses delay (not Timer)
% 
% OrbitFeedbackFlag = 0;
% 
% % Turn lattice menu back off
% set(handles.('LatticeMenu'),'enable','off');
% 
% if strcmpi(get(handles.Simulate,'Checked'),'On')
%     Mode = 'Simulator';
% else
%     Mode = 'Online';
% end
% 
% BPMxFamily = getappdata(handles.figure1, 'BPMxFamily');
% BPMxList = getappdata(handles.figure1, 'BPMxList');
% BPMyFamily = getappdata(handles.figure1, 'BPMyFamily');
% BPMyList = getappdata(handles.figure1, 'BPMyList');
% 
% OnFlag = get(handles.('OnOff'),'Value');
% if OnFlag
%     % Turn on updates
%     set(handles.('OnOff'), 'String', 'Running')        
% end
% 
% if OrbitFeedbackFlag
%     [Nbpm, Tbpm] = getbpmaverages;
%     Tbpm = max(Tbpm);
% end
% 
% while OnFlag
%     t0 = gettime;
%     OnFlag = get(handles.('OnOff'),'Value');
%     UpdatePeriod = getappdata(handles.figure1, 'UpdatePeriod');    
%     
%     if OnFlag
%         % Get new data
%         try
%             RawX = getam(BPMxFamily, BPMxList, Mode, 'Struct');
%         catch
%             RawX.Data = NaN*zeros(size(BPMxList,1),1);
%             RawX.Units = 'Hardware';
%             RawX.TimeStamp = clock;
%             fprintf('   %s, GETAM trouble in family %s\n', sprintf('%s',datestr(RawX.TimeStamp,14)), BPMxFamily);
%         end
%         setappdata(handles.figure1, 'RawX', RawX);
%         
%         try
%             RawY = getam(BPMyFamily, BPMyList, Mode, 'Struct');
%         catch
%             RawY.Data = NaN*zeros(size(BPMyList,1),1);
%             RawY.Units = 'Hardware';
%             RawY.TimeStamp = clock;
%             fprintf('   %s, GETAM trouble in family %s\n', sprintf('%s',datestr(RawY.TimeStamp,14)), BPMyFamily);
%         end
%         setappdata(handles.figure1, 'RawY', RawY);
%         
%         % For non-BPM the offset (ie, the setpoint) may have changed
%         if ~ismemberof(BPMxFamily,'BPM')
%             % Update the offset to the setpoint
%             setappdata(handles.figure1,'OffsetX', getsp(BPMxFamily, BPMxList, Mode));                
%         end
%         if ~ismemberof(BPMyFamily,'BPM')
%             % Update the offset to the setpoint
%             setappdata(handles.figure1,'OffsetY', getsp(BPMyFamily, BPMyList, Mode));                         
%         end
%         
%         % Update time
%         set(handles.('Time'),'String', sprintf('%s',datestr(RawY.TimeStamp,14)));
%         
%         plotappdatalocal(handles);
%         drawnow;
%         
%         
%         if OrbitFeedbackFlag
%             % One could easily add a orbit feedback step
%             setorbitdefault([], 1, [], 'NoDisplay');
%             pause(2.2*Tbpm);
%         end
%         
%     else
%         set(handles.('OnOff'), 'String', 'Continuous');
%         
%         % Turn lattice menu back on
%         set(handles.('LatticeMenu'),'enable','on');
%         
%         break
%     end
%     
%     % Pause
%     T = UpdatePeriod-(gettime-t0);
%     if T > 0
%         pause(T);
%     end
% end



% --- Executes on button press in OneShot.
function OneShot_Callback(hObject, eventdata, handles)

% To break out of the continuous loop (if in it) 
%set(handles.('OnOff'),'Value', 0);  % Not turned off with timer!


% Get Mode and update the title bar
if strcmpi(get(handles.Simulate,'Checked'),'On')
    SetFigureTitle(handles.figure1, 'Model')
    Mode = 'Simulator';
else
    SetFigureTitle(handles.figure1, 'Online')
    Mode = 'Online';
end

% Get the structures
DataStruct1 = getappdata(handles.figure1, 'BPMxFamily');
DataStruct2 = getappdata(handles.figure1, 'BPMyFamily');

% Get new data
try
    RawX = getpv(DataStruct1, Mode, 'Struct');
    %RawX = getpv(DataStruct1, Mode, UnitsFlag, 'Struct');
catch
    RawX.Data = NaN*zeros(size(DataStruct1.Data,1),1);
    RawX.Units = DataStruct1.Units;
    RawX.UnitsString = DataStruct1.UnitsString;
    RawX.Mode = Mode;
    RawX.TimeStamp = clock;
    fprintf('\n%s\n', lasterr);
    fprintf('   %s, GETPV trouble in family %s\n', sprintf('%s',datestr(RawX.TimeStamp,14)), DataStruct1.FamilyName);
end
setappdata(handles.figure1, 'RawX', RawX);

try
    RawY = getpv(DataStruct2, Mode, 'Struct');
    %RawY = getpv(DataStruct2, Mode, UnitsFlag, 'Struct');
catch
    RawY.Data = NaN*zeros(size(DataStruct2.Data,1),1);
    RawY.Units = DataStruct2.Units;
    RawY.UnitsString = DataStruct2.UnitsString;
    RawY.Mode = Mode;
    RawY.TimeStamp = clock;
    fprintf('\n%s\n', lasterr);
    fprintf('   %s, GETPV trouble in family %s\n', sprintf('%s',datestr(RawY.TimeStamp,14)), DataStruct2.FamilyName);
end
setappdata(handles.figure1, 'RawY', RawY);


% % For non-BPM the offset (ie, the setpoint) may have changed
% if ~isempty(getfamilydata(DataStruct1.FamilyName,'Setpoint'))
%     % Update the offset to the setpoint
%     setappdata(handles.figure1,'OffsetX', getsp(DataStruct1.FamilyName, Mode, DataStruct1.Units, 'Struct'));                
% end
% if ~isempty(getfamilydata(DataStruct2.FamilyName,'Setpoint'))
%     % Update the offset to the setpoint
%     setappdata(handles.figure1,'OffsetY', getsp(DataStruct2.FamilyName, Mode, DataStruct2.Units, 'Struct'));                  
% end


% Update time
set(handles.Time, 'String', sprintf('%s',datestr(RawY.TimeStamp,14)));

plotappdatalocal(handles);
drawnow;



function plotappdatalocal(handles)  

if strcmpi(get(handles.Simulate,'Checked'),'On')
    Mode = 'Simulator';
else
    Mode = 'Online';
end


% Get data from appdata
Trace1 = getappdata(handles.figure1,'Trace1');
Trace2 = getappdata(handles.figure1,'Trace2');
UnitsFlag = getappdata(handles.figure1,'UnitsFlag');

DataStruct1 = getappdata(handles.figure1, 'BPMxFamily');
DataStruct2 = getappdata(handles.figure1, 'BPMyFamily');

RawX = getappdata(handles.figure1, 'RawX');
RawY = getappdata(handles.figure1, 'RawY');

sx = getappdata(handles.figure1, 'SPosX');
sy = getappdata(handles.figure1, 'SPosY');

if isempty(sx)
    error(sprintf('Position along ring information not available for %s family.', RawX.FamilyName));
    %sx = 1:size(RawX.Data,1);
end
if isempty(sy)
    error(sprintf('Position along ring information not available for %s family.', RawY.FamilyName));
    %sy = 1:size(RawY.Data,1);
end

ChannelA = getappdata(handles.figure1, 'ChannelA');
ChannelB = getappdata(handles.figure1, 'ChannelB');

if Trace1 == 1 || Trace1 == 3 || Trace2 == 1 || Trace2 == 3
    if ChannelA == 1
        DataA1 = RawX.Data;
        DataA2 = RawY.Data;
    elseif ChannelA == 2
        %DataA1 = getappdata(handles.figure1,'GoldenX');
        %DataA1 = DataA1.Data;
        %DataA2 = getappdata(handles.figure1,'GoldenY');
        %DataA2 = DataA2.Data;

        if strcmpi(DataStruct1.Field, 'Monitor') && ~isempty(getfamilydata(DataStruct1.FamilyName,'Setpoint'))
            % Display the setpoint golden value
            DataA1 = getgolden(DataStruct1, 'Setpoint', DataStruct1.Units, 'Numeric');
        else
            DataA1 = getgolden(DataStruct1, DataStruct1.Units, 'Numeric');
        end

        if strcmpi(DataStruct2.Field, 'Monitor') && ~isempty(getfamilydata(DataStruct2.FamilyName,'Setpoint'))
            % Display the setpoint golden value
            DataA2 = getgolden(DataStruct2, 'Setpoint', DataStruct2.Units, 'Numeric');
        else
            DataA2 = getgolden(DataStruct2, DataStruct2.Units, 'Numeric');
        end

    elseif ChannelA == 3
        %DataA1 = getappdata(handles.figure1,'OffsetX');
        %DataA1 = DataA1.Data;
        %DataA2 = getappdata(handles.figure1,'OffsetY');
        %DataA2 = DataA2.Data;
        
        if strcmpi(DataStruct1.Field, 'Monitor') && ~isempty(getfamilydata(DataStruct1.FamilyName,'Setpoint'))
            % Update the offset to the setpoint
            DataA1 = getsp(DataStruct1, Mode, DataStruct1.Units, 'Numeric');
        else
            DataA1 = getoffset(DataStruct1, DataStruct1.Units, 'Numeric');
        end
        
        if strcmpi(DataStruct2.Field, 'Monitor') && ~isempty(getfamilydata(DataStruct2.FamilyName,'Setpoint'))
            % Update the offset to the setpoint
            DataA2 = getsp(DataStruct2, Mode, DataStruct2.Units, 'Numeric');
        else
            DataA2 = getoffset(DataStruct2, DataStruct2.Units, 'Numeric');
        end

    elseif ChannelA == 4
        DataA1 = getappdata(handles.figure1,'SaveX');
        DataA1 = DataA1.Data;
        DataA2 = getappdata(handles.figure1,'SaveY');
        DataA2 = DataA2.Data;
    elseif ChannelA == 5
        DataA1 = getappdata(handles.figure1,'FileX');
        DataA1 = DataA1.Data;
        DataA2 = getappdata(handles.figure1,'FileY');
        DataA2 = DataA2.Data;
    else 
        DataA1 = zeros(size(BPMxList,1),1);
        DataA2 = zeros(size(BPMyList,1),1);
    end
end

if Trace1 == 2 || Trace1 == 3 || Trace2 == 2 || Trace2 == 3
    if ChannelB == 1
        DataB1 = RawX.Data;
        DataB2 = RawY.Data;
    elseif ChannelB == 2
        %DataB1 = getappdata(handles.figure1,'GoldenX');
        %DataB1 = DataB1.Data;
        %DataB2 = getappdata(handles.figure1,'GoldenY');
        %DataB2 = DataB2.Data;

        if strcmpi(DataStruct1.Field, 'Monitor') && ~isempty(getfamilydata(DataStruct1.FamilyName,'Setpoint'))
            % Display the setpoint golden value
            DataB1 = getgolden(DataStruct1, 'Setpoint', DataStruct1.Units, 'Numeric');
        else
            DataB1 = getgolden(DataStruct1, DataStruct1.Units, 'Numeric');
        end

        if strcmpi(DataStruct2.Field, 'Monitor') && ~isempty(getfamilydata(DataStruct2.FamilyName,'Setpoint'))
            % Display the setpoint golden value
            DataB2 = getgolden(DataStruct2, 'Setpoint', DataStruct2.Units, 'Numeric');
        else
            DataB2 = getgolden(DataStruct2, DataStruct2.Units, 'Numeric');
        end

    elseif ChannelB == 3
        %DataB1 = getappdata(handles.figure1,'OffsetX');
        %DataB1 = DataB1.Data;
        %DataB2 = getappdata(handles.figure1,'OffsetY');
        %DataB2 = DataB2.Data;

        if strcmpi(DataStruct1.Field, 'Monitor') && ~isempty(getfamilydata(DataStruct1.FamilyName,'Setpoint'))
            % Update the offset to the setpoint
            DataB1 = getsp(DataStruct1.FamilyName, DataStruct1.DeviceList, Mode, DataStruct1.Units, 'Numeric');
        else
            DataB1 = getoffset(DataStruct1, DataStruct1.DeviceList, DataStruct1.Units, 'Numeric');
        end

        if strcmpi(DataStruct2.Field, 'Monitor') && ~isempty(getfamilydata(DataStruct2.FamilyName,'Setpoint'))
            % Update the offset to the setpoint
            DataB2 = getsp(DataStruct2, Mode, DataStruct2.Units, 'Numeric');
        else
            DataB2 = getoffset(DataStruct2, DataStruct2.Units, 'Numeric');
        end
    elseif ChannelB == 4
        DataB1 = getappdata(handles.figure1,'SaveX');
        DataB1 = DataB1.Data;
        
        DataB2 = getappdata(handles.figure1,'SaveY');
        DataB2 = DataB2.Data;

    elseif ChannelB == 5
        DataB1 = getappdata(handles.figure1,'FileX');
        DataB1 = DataB1.Data;
        DataB2 = getappdata(handles.figure1,'FileY');
        DataB2 = DataB2.Data;
    else
        DataB1 = zeros(size(BPMxList,1),1);
        DataB2 = zeros(size(BPMyList,1),1);
    end
end


% First line
if Trace1 == 1
    Data1 = DataA1;
    Data2 = DataA2;
elseif Trace1 == 2
    Data1 = DataB1;
    Data2 = DataB2;
elseif Trace1 == 3
    Data1 = DataA1 - DataB1;
    Data2 = DataA2 - DataB2;
end


% Second line
if Trace2 == 4
    Data3 = NaN * Data1;
    Data4 = NaN * Data2;
else
    if Trace2 == 1
        Data3 = DataA1;
        Data4 = DataA2;
    elseif Trace2 == 2
        Data3 = DataB1;
        Data4 = DataB2;
    elseif Trace2 == 3
        Data3 = DataA1 - DataB1;
        Data4 = DataA2 - DataB2;
    end
end



% if UnitsFlag == 1 && strcmpi(RawX.Units,'Hardware')
%     % Physics units requested, data is in Hardware units
%     Data1 = hw2physics(BPMxFamily, 'Monitor', Data1);
%     Data2 = hw2physics(BPMyFamily, 'Monitor', Data2);
%     Data3 = hw2physics(BPMxFamily, 'Monitor', Data3);
%     Data4 = hw2physics(BPMyFamily, 'Monitor', Data4);
% elseif (UnitsFlag==2 | UnitsFlag==3) && strcmpi(RawX.Units,'Physics')
%     % Hardware units requested, data is in Physics units
%     Data1 = physics2hw(BPMxFamily, 'Monitor', Data1);
%     Data2 = physics2hw(BPMyFamily, 'Monitor', Data2);
%     Data3 = physics2hw(BPMxFamily, 'Monitor', Data3);
%     Data4 = physics2hw(BPMyFamily, 'Monitor', Data4);
% end

UnitsString1 = DataStruct1.UnitsString;
UnitsString2 = DataStruct2.UnitsString;
% if UnitsFlag == 1
%     % Physics units
%     UnitsString1 = getfamilydata(DataStruct1.FamilyName, DataStruct1.Field, 'PhysicsUnits');
%     UnitsString2 = getfamilydata(DataStruct2.FamilyName, DataStruct2.Field, 'PhysicsUnits');
% elseif UnitsFlag == 2
%     % Hardware units
%     UnitsString1 = getfamilydata(DataStruct1.FamilyName, DataStruct1.Field, 'HWUnits');
%     UnitsString2 = getfamilydata(DataStruct2.FamilyName, DataStruct2.Field, 'HWUnits');
if UnitsFlag == 3
    % Hardware units time 1000
    Data1 = 1000 * Data1;
    Data2 = 1000 * Data2;
    Data3 = 1000 * Data3;
    Data4 = 1000 * Data4;
    %UnitsString1 = getfamilydata(DataStruct1.FamilyName, DataStruct1.Field, 'HWUnits');
    %UnitsString2 = getfamilydata(DataStruct2.FamilyName, DataStruct2.Field, 'HWUnits');
    if strcmpi(UnitsString1,'mm')
        UnitsString1 = '\mum';
    else
        %UnitsString1 = ['1000x', UnitsString1];
        UnitsString1 = ['milli', UnitsString1];
    end
    if strcmpi(UnitsString2,'mm')
        UnitsString2 = '\mum';
    else
        %UnitsString2 = ['1000x', UnitsString2];
        UnitsString2 = ['milli', UnitsString2];
    end
end


% Axes 1

% Get line handles (not sure why I need to filter out the non-lines)
h = get(handles.Graph1,'Children');
for i = length(h):-1:1
    hfields = get(h(i));
    if ~any(isfield(hfields, {'XData','xdata'}))
        h(i) = [];
    end
end

AxisRange1X = getappdata(handles.figure1, 'AxisRange1X');

% Bar graph setup
if strcmpi(get(handles.Graph1Bar,'Checked'),'On')
    %  #pts  BarWidth
    Table = [
        0    .01
        24    .025
        48    .05
        120   .10
        1000  .3
        3000  .40
        1e5   .50
        ];
    L = getfamilydata('Circumference');
    WidthScaleFactor = interp1(Table(:,1), Table(:,2), length(Data1), 'linear');
    WidthScaleFactor = WidthScaleFactor * (L/length(sx)) / min(diff(sx));
end


% Don't change the axis (unless it's the first time)
if isempty(h)
    cla(handles.Graph1);
    if strcmpi(get(handles.Graph1Bar,'Checked'),'On')
        % Bar graph
        h(1) = bar(handles.Graph1, sx, Data1(:), WidthScaleFactor);
        hold(handles.Graph1, 'on');
        h(2) = bar(handles.Graph1, sx, Data3(:), WidthScaleFactor/2);
        hold(handles.Graph1, 'off');
        set(h(1),'FaceColor','b');
        set(h(1),'EdgeColor','b');
        if get(handles.Trace2Off, 'Value')
            set(h(2),'FaceColor','k');
            set(h(2),'EdgeColor','k');
        else
            set(h(2),'FaceColor','r');
            set(h(2),'EdgeColor','r');
        end
    else
        h(1) = plot(handles.Graph1, sx, Data1(:),'.-b');
        hold(handles.Graph1, 'on');
        h(2) = plot(handles.Graph1, sx, Data3(:),'.-r');
        hold(handles.Graph1, 'off');
        %set(h(1),'Color','b');
        %set(h(2),'Color','r');
    end

    set(h(1),'UserData', 1);
    set(h(2),'UserData', 2);
    
    % plot(handles.Graph1, sx, Data3,'squarer','MarkerSize',3);
    % plot(handles.Graph1, sx, Data1,'squareb','MarkerSize',3);

    % Set defaults
    set(handles.Graph1, 'Nextplot',      'Add');
    set(handles.Graph1, 'YGrid',         'On');
    set(handles.Graph1, 'YMinorTick',    'On');
    set(handles.Graph1, 'XMinorTick',    'On');
    set(handles.Graph1, 'XAxisLocation', 'Bottom');
    set(handles.Graph1, 'XTickLabel',    '');

    a = axis(handles.Graph1);
    axis(handles.Graph1, [AxisRange1X(1) AxisRange1X(2) a(3) a(4)]);   
    
    if strcmpi(get(handles.('YScaleLog1'),'Checked'),'On')
        set(handles.Graph1,'YScale','Log');
    else
        set(handles.Graph1,'YScale','Linear');
    end
    
    set(handles.Graph1 ,'ButtonDownFcn','plotfamily(''Graph1_ButtonDown'',gcbo,[],guidata(gcbo))');
    h = get(handles.Graph1,'Children');
    for i = 1:length(h)
        set(h(i) ,'ButtonDownFcn','plotfamily(''Graph1_ButtonDown'',gcbo,[],guidata(gcbo))');
    end
else
    % This fixes a weird error
    if get(h(1),'UserData') == 2
        h = h(end:-1:end-1);
    end
    
    a = axis(handles.Graph1);
    set(h(1), 'XData', sx, 'YData', Data1);
    set(h(2), 'XData', sx, 'YData', Data3);

    if strcmpi(get(handles.Graph1Bar,'Checked'),'On')
        set(h(1),'BarWidth',WidthScaleFactor);
        set(h(2),'BarWidth',WidthScaleFactor/2);
        if get(handles.Trace2Off, 'Value')
            set(h(2),'FaceColor','k');
            set(h(2),'EdgeColor','k');
        else
            set(h(2),'FaceColor','r');
            set(h(2),'EdgeColor','r');
        end
    end
    
    axis(handles.Graph1, [AxisRange1X(1) AxisRange1X(2) a(3) a(4)]);
end

h_label=get(handles.Graph1,'ylabel');


if strcmpi(DataStruct1.Field,'Monitor')
    if isempty(UnitsString1)
        set(h_label, 'String', sprintf('%s',      DataStruct1.FamilyName), 'Interpreter','None');
    elseif strcmpi(UnitsString1,'\mum')
        set(h_label, 'String', sprintf('%s [%s]', DataStruct1.FamilyName, UnitsString1), 'Interpreter','Tex');
    else
        set(h_label, 'String', sprintf('%s [%s]', DataStruct1.FamilyName, UnitsString1), 'Interpreter','None');
    end
else
    if isempty(UnitsString1)
        set(h_label, 'String', sprintf('%s.%s',      DataStruct1.FamilyName, DataStruct1.Field), 'Interpreter','None');
    elseif strcmpi(UnitsString1,'\mum')
        set(h_label, 'String', sprintf('%s.%s [%s]', DataStruct1.FamilyName, DataStruct1.Field, UnitsString1), 'Interpreter','Tex');
    else
        set(h_label, 'String', sprintf('%s.%s [%s]', DataStruct1.FamilyName, DataStruct1.Field, UnitsString1), 'Interpreter','None');
    end
end


% Graph 3
if strcmpi(get(handles.('AddPlot1_Nothing'),'Checked'),'Off')
    % Bring Graph 3 forward
    axes(handles.Graph3);
end

% Remove NaN
i = find(~isnan(Data1));
if isempty(i)
    MeanString = '';
    RMSString  = '';
else
    MeanString = sprintf('%+9.6e Mean', mean(Data1(i)));
    RMSString  = sprintf('%+9.6e RMS', (length(Data1(i))-1)*std(Data1(i))/length(Data1(i)));
end
set(handles.Trace1RMS,'String',{MeanString, RMSString});
set(handles.Trace1RMS,'FontSize', 9);

% Set the list box
Value = get(handles.DataList1, 'Value');
set(handles.DataList1, 'Value', Value);
ListBoxTop = get(handles.DataList1, 'ListBoxTop');
if any(iscell(DataStruct1.ListBoxString))
    set(handles.DataList1, 'String', [char(DataStruct1.ListBoxString), num2str(Data1(:),'%+.4e')]);
else
    set(handles.DataList1, 'String', [DataStruct1.ListBoxString, num2str(Data1(:),'%+.4e')]);
end
set(handles.DataList1, 'ListBoxTop', ListBoxTop);


% Axes 2

% Get line handles (not sure why I need to filter out the non-lines)
h = get(handles.Graph2,'Children');
for i = length(h):-1:1
    hfields = get(h(i));
    if ~any(isfield(hfields, {'XData','xdata'}))
        h(i) = [];
    end
end

AxisRange2X = getappdata(handles.figure1, 'AxisRange2X');

% Bar graph setup
if strcmpi(get(handles.Graph2Bar,'Checked'),'On')
    %  #pts  BarWidth
    Table = [
        0    .01
        24    .025
        48    .05
        120   .10
        1000  .3
        3000  .40
        1e5   .50
        ];
    L = getfamilydata('Circumference');
    WidthScaleFactor = interp1(Table(:,1), Table(:,2), length(Data2), 'linear');
    WidthScaleFactor = WidthScaleFactor * (L/length(sy)) / min(diff(sy));
end


if isempty(h)
    cla(handles.Graph2);
    if strcmpi(get(handles.Graph2Bar,'Checked'),'On')
        % Bar graph
        h(1) = bar(handles.Graph2, sy, Data2(:), WidthScaleFactor);
        hold(handles.Graph2, 'on');
        h(2) = bar(handles.Graph2, sy, Data4(:), WidthScaleFactor/2);
        hold(handles.Graph2, 'off');
        set(h(1),'FaceColor','b');
        set(h(1),'EdgeColor','b');
        if get(handles.Trace2Off, 'Value')
            set(h(2),'FaceColor','k');
            set(h(2),'EdgeColor','k');
        else
            set(h(2),'FaceColor','r');
            set(h(2),'EdgeColor','r');
        end
    else
        %h = plot(handles.Graph2, sy, [Data2(:) Data4(:)],'.-');
        %set(h(1),'Color','b');
        %set(h(2),'Color','r');
        
        h(1) = plot(handles.Graph2, sy, Data2(:),'.-b');
        hold(handles.Graph2, 'on');
        h(2) = plot(handles.Graph2, sy, Data4(:),'.-r');
        hold(handles.Graph2, 'off');
    end
    
    set(h(1),'UserData', 1);
    set(h(2),'UserData', 2);
    

    % Set defaults
    set(handles.Graph2, 'Nextplot',      'Add');
    set(handles.Graph2, 'YGrid',         'On');
    set(handles.Graph2, 'YMinorTick',    'On');
    set(handles.Graph2, 'XMinorTick',    'On');
    set(handles.Graph2, 'XAxisLocation', 'Bottom');
    
    a = axis(handles.Graph2);
    axis(handles.Graph2, [AxisRange2X(1) AxisRange2X(2) a(3) a(4)])
    
    if strcmpi(get(handles.('YScaleLog2'),'Checked'),'On')
        set(handles.Graph2,'YScale','Log');
    else
        set(handles.Graph2,'YScale','Linear');
    end

    set(handles.Graph2 ,'ButtonDownFcn','plotfamily(''Graph2_ButtonDown'',gcbo,[],guidata(gcbo))');
    h = get(handles.Graph2,'Children');
    for i = 1:length(h)
        set(h(i) ,'ButtonDownFcn','plotfamily(''Graph2_ButtonDown'',gcbo,[],guidata(gcbo))');
    end
else
    % This fixes a weird error
    if get(h(1),'UserData') == 2
        h = h(end:-1:end-1);
    end
    
    a = axis(handles.Graph2);
    set(h(1), 'XData', sy, 'YData', Data2);
    set(h(2), 'XData', sy, 'YData', Data4);

    if strcmpi(get(handles.Graph2Bar,'Checked'),'On')
        set(h(1),'BarWidth',WidthScaleFactor);
        set(h(2),'BarWidth',WidthScaleFactor/2);
        if get(handles.Trace2Off, 'Value')
            set(h(2),'FaceColor','k');
            set(h(2),'EdgeColor','k');
        else
            set(h(2),'FaceColor','r');
            set(h(2),'EdgeColor','r');
        end
    end

    %% Add the model orbit to the plot
    %[x, y, sx, sy] = modeltwiss('x', 'All');
    %h4 = get(handles.Graph4,'children');
    % Filter non-lines
    %set(h4, 'XData', sx, 'YData', x);
    %axis(h4, [AxisRange2X(1) AxisRange2X(2) a(3) a(4)]);

    axis(handles.Graph2, [AxisRange2X(1) AxisRange2X(2) a(3) a(4)]);
end

h_label = get(handles.Graph2,'ylabel');
if strcmpi(DataStruct2.Field,'Monitor')
    if isempty(UnitsString2)
        set(h_label, 'String', sprintf('%s',      DataStruct2.FamilyName), 'Interpreter','None');
    elseif strcmpi(UnitsString2,'\mum')
        set(h_label, 'String', sprintf('%s [%s]', DataStruct2.FamilyName, UnitsString2), 'Interpreter','Tex');
    else
        set(h_label, 'String', sprintf('%s [%s]', DataStruct2.FamilyName, UnitsString2), 'Interpreter','None');
    end
else
    if isempty(UnitsString2)
        set(h_label, 'String', sprintf('%s.%s',      DataStruct2.FamilyName, DataStruct2.Field), 'Interpreter','None');
    elseif strcmpi(UnitsString2,'\mum')
        set(h_label, 'String', sprintf('%s.%s [%s]', DataStruct2.FamilyName, DataStruct2.Field, UnitsString2), 'Interpreter','Tex');
    else
        set(h_label, 'String', sprintf('%s.%s [%s]', DataStruct2.FamilyName, DataStruct2.Field, UnitsString2), 'Interpreter','None');
    end
end


% Graph 4
if strcmpi(get(handles.('AddPlot2_Nothing'),'Checked'),'Off')
    % Bring Graph 4 forward
    axes(handles.Graph4);
end


% Set the list box header
i = find(~isnan(Data2));
if isempty(i)
    MeanString = '';
    RMSString  = '';
else
    MeanString = sprintf('%+9.6e Mean', mean(Data2(i)));
    RMSString  = sprintf('%+9.6e RMS', (length(Data2(i))-1)*std(Data2(i))/length(Data2(i)));
end
set(handles.Trace2RMS,'String',{MeanString, RMSString});
set(handles.Trace2RMS,'FontSize', 9);


% Set the list box
Value = get(handles.DataList2,'Value');
set(handles.DataList2,'Value', Value);
ListBoxTop = get(handles.DataList2,'ListBoxTop');
if any(iscell(DataStruct2.ListBoxString))
    set(handles.DataList2, 'String', [char(DataStruct2.ListBoxString), num2str(Data2(:),'%+.4e')]);
else
    set(handles.DataList2,'String', [DataStruct2.ListBoxString, num2str(Data2(:),'%+.4e')]);
end
set(handles.DataList2, 'ListBoxTop', ListBoxTop);



% --- Executes on button press in RawOrbit1.
function RawOrbit1_Callback(hObject, eventdata, handles)
set(handles.RawOrbit1,'Value', 1);
set(handles.GoldenOrbit1,'Value', 0);
set(handles.OffsetOrbit1,'Value', 0);
set(handles.SaveOrbit1,'Value', 0);
set(handles.FileOrbit1,'Value', 0);
setappdata(handles.figure1, 'ChannelA', 1);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in GoldenOrbit1.
function GoldenOrbit1_Callback(hObject, eventdata, handles)
set(handles.RawOrbit1,'Value', 0);
set(handles.GoldenOrbit1,'Value', 1);
set(handles.OffsetOrbit1,'Value', 0);
set(handles.SaveOrbit1,'Value', 0);
set(handles.FileOrbit1,'Value', 0);
setappdata(handles.figure1, 'ChannelA', 2);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in OffsetOrbit1.
function OffsetOrbit1_Callback(hObject, eventdata, handles)
set(handles.RawOrbit1,'Value', 0);
set(handles.GoldenOrbit1,'Value', 0);
set(handles.OffsetOrbit1,'Value', 1);
set(handles.SaveOrbit1,'Value', 0);
set(handles.FileOrbit1,'Value', 0);
setappdata(handles.figure1, 'ChannelA', 3);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in SaveOrbit1.
function SaveOrbit1_Callback(hObject, eventdata, handles)
set(handles.RawOrbit1,'Value', 0);
set(handles.GoldenOrbit1,'Value', 0);
set(handles.OffsetOrbit1,'Value', 0);
set(handles.SaveOrbit1,'Value', 1);
set(handles.FileOrbit1,'Value', 0);
setappdata(handles.figure1, 'ChannelA', 4);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in FileOrbit1.
function FileOrbit1_Callback(hObject, eventdata, handles)
set(handles.RawOrbit1,'Value', 0);
set(handles.GoldenOrbit1,'Value', 0);
set(handles.OffsetOrbit1,'Value', 0);
set(handles.SaveOrbit1,'Value', 0);
set(handles.FileOrbit1,'Value', 1);
setappdata(handles.figure1, 'ChannelA', 5);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);


% --- Executes on button press in RawOrbit2.
function RawOrbit2_Callback(hObject, eventdata, handles)
set(handles.RawOrbit2,'Value', 1);
set(handles.GoldenOrbit2,'Value', 0);
set(handles.OffsetOrbit2,'Value', 0);
set(handles.SaveOrbit2,'Value', 0);
set(handles.FileOrbit2,'Value', 0);
setappdata(handles.figure1, 'ChannelB', 1);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in GoldenOrbit2.
function GoldenOrbit2_Callback(hObject, eventdata, handles)
set(handles.RawOrbit2,'Value', 0);
set(handles.GoldenOrbit2,'Value', 1);
set(handles.OffsetOrbit2,'Value', 0);
set(handles.SaveOrbit2,'Value', 0);
set(handles.FileOrbit2,'Value', 0);
setappdata(handles.figure1, 'ChannelB', 2);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in OffsetOrbit2.
function OffsetOrbit2_Callback(hObject, eventdata, handles)
set(handles.RawOrbit2,'Value', 0);
set(handles.GoldenOrbit2,'Value', 0);
set(handles.OffsetOrbit2,'Value', 1);
set(handles.SaveOrbit2,'Value', 0);
set(handles.FileOrbit2,'Value', 0);
setappdata(handles.figure1, 'ChannelB', 3);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in SaveOrbit2.
function SaveOrbit2_Callback(hObject, eventdata, handles)
set(handles.RawOrbit2,'Value', 0);
set(handles.GoldenOrbit2,'Value', 0);
set(handles.OffsetOrbit2,'Value', 0);
set(handles.SaveOrbit2,'Value', 1);
set(handles.FileOrbit2,'Value', 0);
setappdata(handles.figure1, 'ChannelB', 4);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in FileOrbit2.
function FileOrbit2_Callback(hObject, eventdata, handles)
set(handles.RawOrbit2,'Value', 0);
set(handles.GoldenOrbit2,'Value', 0);
set(handles.OffsetOrbit2,'Value', 0);
set(handles.SaveOrbit2,'Value', 0);
set(handles.FileOrbit2,'Value', 1);
setappdata(handles.figure1, 'ChannelB', 5);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in SaveOrbit1Now.
function SaveOrbit1Now_Callback(hObject, eventdata, handles)
RawX = getappdata(handles.figure1,'RawX');
RawY = getappdata(handles.figure1,'RawY');
setappdata(handles.figure1,'SaveX', RawX);
setappdata(handles.figure1,'SaveY', RawY);
if isfield(RawY,'TimeStamp')
    set(handles.SaveTime,'String', sprintf('%s',datestr(RawY.TimeStamp,0)));
else
    set(handles.SaveTime,'String', sprintf('%s',datestr(clock,0)));
end
plotappdatalocal(handles);
%AutoScaleYLocal(handles);


% --- Executes on button press in LoadOrbit1.
function LoadOrbit1_Callback(hObject, eventdata, handles)
UnitMenu = getappdata(handles.figure1,'UnitsFlag');
if UnitMenu == 1
    UnitsFlag = 'Physics';
else
    UnitsFlag = 'Hardware';
end

DataStruct1 = getappdata(handles.figure1, 'BPMxFamily');
DataStruct2 = getappdata(handles.figure1, 'BPMyFamily');

DirectoryName = getfamilydata('Directory','DataRoot');
%DirectoryName = getfamilydata('Directory', 'BPMData');
%FileNameX = getfamilydata('Default', 'BPMFile');
[FileName, DirectoryName] = uigetfile('*.mat', 'Select a File', DirectoryName);
if FileName == 0 
    return
end

% Remove .mat
%if strcmpi(FileNameX(end-3:end), '.mat')
%    FileNameX = FileNameX(1:end-4);  
%end

% Graph 1
try
    DataStruct = getdata(DataStruct1, [DirectoryName FileName], 'Struct');
    if UnitMenu == 1 && strcmpi(DataStruct.Units,'Hardware')
        % Physics units requested
        DataStruct = hw2physics(DataStruct);
    elseif (UnitMenu==2 || UnitMenu==3) && strcmpi(DataStruct.Units,'Physics')
        % Hardware units requested, data is in Physics units
        DataStruct = physics2hw(DataStruct);
    end
    setappdata(handles.figure1, 'FileX', DataStruct);
    setappdata(handles.figure1, 'FileNameX', [DirectoryName FileName]);
catch
end

% Graph 2
try
    DataStruct = getdata(DataStruct2, [DirectoryName FileName], 'Struct');
    if UnitMenu == 1 && strcmpi(DataStruct.Units,'Hardware')
        % Physics units requested
        DataStruct = hw2physics(DataStruct);
    elseif (UnitMenu==2 || UnitMenu==3) && strcmpi(DataStruct.Units,'Physics')
        % Hardware units requested, data is in Physics units
        DataStruct = physics2hw(DataStruct);
    end
    setappdata(handles.figure1, 'FileY', DataStruct);
    setappdata(handles.figure1, 'FileNameY', [DirectoryName FileName]);
catch
end

plotappdatalocal(handles);
%AutoScaleYLocal(handles);
UpdateFileDisplayLocal(handles);


% --- local function to update filenamex on the display.
function UpdateFileDisplayLocal(handles)

FileNameX = getappdata(handles.figure1, 'FileNameX');
FileNameY = getappdata(handles.figure1, 'FileNameY');

if isempty(FileNameX) && isempty(FileNameY)
    set(handles.FileNameX,'String', '');
    set(handles.FileNameY,'String', '');
    drawnow;
    return;
end

if ~isempty(FileNameX)
    % Remove directories
    i = findstr(FileNameX, filesep);
    if ~isempty(i)
        FileNameX = FileNameX(i(end)+1:end);
    end
    
    % Shorten length
    if length(FileNameX) >= 31
        % Remove .mat
        if strcmpi(FileNameX(end-3:end),'.mat')
            FileNameX = FileNameX(1:end-4);  % remove .mat
        end
        
        if length(FileNameX) >= 31
            FileNameX = FileNameX(1:31);
        end
    end

    %set(handles.FileNameX,'String', sprintf('File 1: %s', FileNameX));
    set(handles.FileNameX,'String', sprintf('%s', FileNameX));
else
    set(handles.FileNameX,'String', 'File 1: no data');
end

if ~isempty(FileNameY)
    % Remove directories
    i = findstr(FileNameY,filesep);
    if ~isempty(i)
        FileNameY = FileNameY(i(end)+1:end);
    end
    
    % Shorten length
    if length(FileNameY) >= 31
        % Remove .mat
        if strcmpi(FileNameY(end-3:end),'.mat')
            FileNameY = FileNameY(1:end-4);  % remove .mat
        end
        if length(FileNameY) >= 31
            FileNameY = FileNameY(1:31);
        end
    end
    
    %set(handles.FileNameY,'String', sprintf('File 2: %s', FileNameY));
    set(handles.FileNameY,'String', sprintf('%s', FileNameY));
else
    set(handles.FileNameY,'String', 'File 2: no data');
end

if strcmpi(FileNameX, FileNameY) && ~isempty(FileNameX)
    set(handles.FileNameY,'Visible','off');
    set(handles.FileNameX,'String', sprintf('%s', FileNameX));
    p = get(handles.FileNameX,'Position');
    %set(handles.FileNameX,'Position', [p(1) 4 p(3) p(4)]);   % Points
    %set(handles.FileNameX,'Position', [p(1) .4 p(3) p(4)]);  % Characters
    set(handles.FileNameX,'Position', [p(1) 0.02 p(3) p(4)]); % Normalized
    p = get(handles.SaveTime,'Position');
    %set(handles.SaveTime,'Position', [p(1) 16.5 p(3) p(4)]);   % Points
    %set(handles.SaveTime,'Position', [p(1) 1.6 p(3) p(4)]);    % Characters
    set(handles.SaveTime,'Position', [p(1) 0.052 p(3) p(4)]);   % Normalized
else
    p = get(handles.FileNameX,'Position');
    %set(handles.FileNameX,'Position', [p(1) 10 p(3) p(4)]);  % Points
    %set(handles.FileNameX,'Position', [p(1) 1.1 p(3) p(4)]);  % Characters
    set(handles.FileNameX,'Position', [p(1) 0.025 p(3) p(4)]);  % Normalized
    set(handles.FileNameY,'Visible','on');
    p = get(handles.SaveTime,'Position');
    %set(handles.SaveTime,'Position', [p(1) 20 p(3) p(4)]);  % Points
    %set(handles.SaveTime,'Position', [p(1) 2.0 p(3) p(4)]);  % Characters
    set(handles.SaveTime,'Position', [p(1) 0.055 p(3) p(4)]);  % Normalized
end

drawnow;


% --- Executes on button press in Display1.
function Display1_Callback(hObject, eventdata, handles)
set(handles.DisplayDiff,'Value', 0);
set(handles.Display1,'Value', 1);
set(handles.Display2,'Value', 0);
setappdata(handles.figure1,'Trace1',1);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in Display2.
function Display2_Callback(hObject, eventdata, handles)
set(handles.DisplayDiff,'Value', 0);
set(handles.Display1,'Value', 0);
set(handles.Display2,'Value', 1);
setappdata(handles.figure1,'Trace1',2);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in DisplayDiff.
function DisplayDiff_Callback(hObject, eventdata, handles)
set(handles.DisplayDiff,'Value', 1);
set(handles.Display1,'Value', 0);
set(handles.Display2,'Value', 0);
setappdata(handles.figure1,'Trace1',3);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);


% --- Executes on button press in Trace2A.
function Trace2A_Callback(hObject, eventdata, handles)
set(handles.Trace2A,'Value', 1);
set(handles.Trace2B,'Value', 0);
set(handles.Trace2A_B,'Value', 0);
set(handles.Trace2Off,'Value', 0);
setappdata(handles.figure1,'Trace2',1);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in Trace2B.
function Trace2B_Callback(hObject, eventdata, handles)
set(handles.Trace2A,'Value', 0);
set(handles.Trace2B,'Value', 1);
set(handles.Trace2A_B,'Value', 0);
set(handles.Trace2Off,'Value', 0);
setappdata(handles.figure1,'Trace2',2);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in Trace2A_B.
function Trace2A_B_Callback(hObject, eventdata, handles)
set(handles.Trace2A,'Value', 0);
set(handles.Trace2B,'Value', 0);
set(handles.Trace2A_B,'Value', 1);
set(handles.Trace2Off,'Value', 0);
setappdata(handles.figure1,'Trace2',3);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);

% --- Executes on button press in Trace2Off.
function Trace2Off_Callback(hObject, eventdata, handles)
set(handles.Trace2A,'Value', 0);
set(handles.Trace2B,'Value', 0);
set(handles.Trace2A_B,'Value', 0);
set(handles.Trace2Off,'Value', 1);
setappdata(handles.figure1,'Trace2',4);
plotappdatalocal(handles);
%AutoScaleYLocal(handles);


% --- Executes on selection change in DataList1.
function DataList1_Callback(hObject, eventdata, handles)
if strcmpi(get(handles.Simulate,'Checked'),'On')
    Mode = 'Simulator';
else
    Mode = 'Online';
end

i = get(hObject,'Value');
DataStruct = getappdata(handles.figure1, 'BPMxFamily');

Family = DataStruct.FamilyName;
Field = DataStruct.Field;
List = DataStruct.DeviceList;
[tmp,ao] = isfamily(Family);

if strcmpi(Field, 'Monitor')
    Field = 'Setpoint';
end

if isfield(ao, Field)
    if getappdata(handles.figure1,'UnitsFlag') == 1
        UnitsFlag = 'Physics';
    else
        UnitsFlag = 'Hardware';
    end

    % Get/save the present setpoint then call the GUI for setpoint changes
    try
        SP = getpv(Family, Field, List(i,:), Mode, UnitsFlag, 'Struct');
        set(handles.SetpointSlider,     'UserData', SP);
        set(handles.SetpointPushButton, 'UserData', SP);

        SetpointGUI_Callback(hObject, eventdata, handles);
    catch
        fprintf('   Trouble finding the present value of %s.%s(%d,%d)\n',Family, Field, List(i,:));
    end
end


% --- Executes on selection change in DataList2.
function DataList2_Callback(hObject, eventdata, handles)
if strcmpi(get(handles.Simulate,'Checked'),'On')
    Mode = 'Simulator';
else
    Mode = 'Online';
end

i = get(hObject,'Value');
DataStruct = getappdata(handles.figure1, 'BPMyFamily');

Family = DataStruct.FamilyName;
Field = DataStruct.Field;
List = DataStruct.DeviceList;
[tmp,ao] = isfamily(Family);

if strcmpi(Field, 'Monitor')
    Field = 'Setpoint';
end

if isfield(ao, Field)
    if getappdata(handles.figure1,'UnitsFlag') == 1
        UnitsFlag = 'Physics';
    else
        UnitsFlag = 'Hardware';
    end

    % Get/save the present setpoint then call the GUI for setpoint changes
    try
        SP = getpv(Family, Field, List(i,:), Mode, UnitsFlag, 'Struct');
        set(handles.SetpointSlider, 'UserData', SP);
        set(handles.SetpointPushButton, 'UserData', SP);

        SetpointGUI_Callback(hObject, eventdata, handles);
    catch
        fprintf('   Trouble finding the present value of %s.%s(%d,%d)\n',Family, Field, List(i,:));
    end
end



%%%%%%%%%%%%%%%%%%
% MENU CALLBACKS %
%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function PopPlot_Callback(hObject, eventdata, handles)
a = figure;
b = copyobj(handles.Graph1, a); 
set(b, 'Position', [0.1300    0.5811    0.7750    0.3439]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');

b = copyobj(handles.Graph2, a); 
set(b, 'Position', [0.1300    0.1100    0.7750    0.3439]);
set(b, 'ButtonDownFcn','');
xlabel(b, 'Position [meters]');

Data = getappdata(handles.figure1, 'RawY');
if isfield(Data, 'TimeStamp')
    addlabel(1,0,datestr(Data.TimeStamp,21));
end
orient tall


% --------------------------------------------------------------------
function PopPlot1_Callback(hObject, eventdata, handles)
%set(handles.figure1, 'HandleVisibility','Callback');

a = figure;
b = copyobj(handles.Graph1, a); 
set(b, 'Position',[0.13 0.11 0.775 0.815]); 
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');
Axis1 = axis;

if strcmpi(get(handles.AddPlot1_Nothing,'Checked'),'Off')
    set(b, 'Position',[0.13 0.11 0.775 0.7]); 
    c = copyobj(handles.Graph3, a); 
    
    % Plot on top of each other
    %set(c, 'Position',[0.13 0.11 0.775 0.815]); 
    
    % Separate plots
    set(c, 'Position',[0.13 0.11+.72 0.775 0.12]); 
    
    set(c,'color',[1 1 1]);
    set(c,'Visible','On');   
    set(c,'XAxisLocation','Top');
    set(c,'XTick',get(b,'XTick'));
    %set(c,'XTickLabel',get(b,'XTickLabel'));
    set(c,'XTickLabel',[]);
    set(c,'XMinorTick','On');
    set(c,'XMinorGrid','Off');
    set(c,'XGrid','Off');
    set(c,'YGrid','Off');
    set(c,'XAxisLocation','Bottom');
    set(c,'YAxisLocation','Left');
    %set(c,'YAxisLocation','Right');
    set(c,'YTick',[]);
    set(c,'YMinorTick','Off');
    set(c,'YMinorGrid','Off');
    set(c,'YTickLabel',[]);
    axis(c,'tight');
    Axis2 = axis(c); 
    axis(c,[Axis1(1) Axis1(2) Axis2(3)-.2*(Axis2(4)-Axis2(3)) Axis2(4)+.2*(Axis2(4)-Axis2(3))]);
    
    set(c, 'ButtonDownFcn','');

    if strcmpi(get(handles.AddPlot1_BetaX,'Checked'),'On')
        ylabel(c, 'Beta X');
    end
    if strcmpi(get(handles.AddPlot1_BetaY,'Checked'),'On')
        ylabel(c, 'Beta Y');
    end
    if strcmpi(get(handles.AddPlot1_DispX,'Checked'),'On')
        ylabel(c, 'Disp X');
    end
    if strcmpi(get(handles.AddPlot1_DispY,'Checked'),'On')
        ylabel(c, 'Disp Y');
    end
end
xlabel(b, 'Position [meters]');
Data = getappdata(handles.figure1, 'RawX');
if isfield(Data, 'TimeStamp') && ~isempty(Data.TimeStamp)
    addlabel(1,0,datestr(Data.TimeStamp,21));
end
orient portrait


% --------------------------------------------------------------------
function PopPlot2_Callback(hObject, eventdata, handles)
set(handles.Graph2, 'HandleVisibility', 'Callback'); 

a = figure;
b = copyobj(handles.Graph2, a); 
set(b, 'Position',[0.13 0.11 0.775 0.815]); 
set(b, 'ButtonDownFcn','');
Axis1 = axis;

if strcmpi(get(handles.AddPlot2_Nothing,'Checked'),'Off')
    set(b, 'Position',[0.13 0.11 0.775 0.7]); 
    c = copyobj(handles.Graph4, a); 
    
    % Plot on top of each other
    %set(c, 'Position',[0.13 0.11 0.775 0.815]); 
    
    % Separate plots
    set(c, 'Position',[0.13 0.11+.72 0.775 0.12]); 
    
    set(c,'color',[1 1 1]);
    set(c,'Visible','On');   
    set(c,'XAxisLocation','Top');
    set(c,'XTick',get(b,'XTick'));
    set(c,'XTickLabel',get(b,'XTickLabel'));
    %set(c,'XTickLabel',[]);
    set(c,'XMinorTick','On');
    set(c,'XMinorGrid','Off');
    set(c,'XGrid','Off');
    set(c,'YGrid','Off');
    set(c,'YAxisLocation','Left');

    % Turn y-axis on
    set(c,'YTick',[]);
    set(c,'YMinorTick','Off');
    set(c,'YMinorGrid','Off');
    set(c,'YTickLabel',[]);
    axis(c,'tight');
    Axis2 = axis(c); 
    axis(c,[Axis1(1) Axis1(2) Axis2(3)-.2*(Axis2(4)-Axis2(3)) Axis2(4)+.2*(Axis2(4)-Axis2(3))]);
    
    set(c, 'ButtonDownFcn','');

    if strcmpi(get(handles.AddPlot2_BetaX,'Checked'),'On')
        ylabel(c,'Beta X');
    end
    if strcmpi(get(handles.AddPlot2_BetaY,'Checked'),'On')
        ylabel(c,'Beta Y');
    end
    if strcmpi(get(handles.AddPlot2_DispX,'Checked'),'On')
        ylabel(c,'Disp X');
    end
    if strcmpi(get(handles.AddPlot2_DispY,'Checked'),'On')
        ylabel(c,'Disp Y');
    end
end
xlabel('Position [meters]');
Data = getappdata(handles.figure1, 'RawY');
if isfield(Data, 'TimeStamp') && ~isempty(Data.TimeStamp)
    addlabel(1,0,datestr(Data.TimeStamp,21));
end
orient portrait


% --------------------------------------------------------------------
function Axis1_Callback(hObject, eventdata, handles)
a = axis(handles.Graph1);
a = a(3:4);
answer = inputdlg('New upper graph vertical axis [2 element vector]','',1,{sprintf('[%s]',num2str(a))});
if ~isempty(answer)
    a = str2num(answer{1});
    if length(a) == 2
        set(handles.Graph1, 'YLim', a);
    else
        fprintf('   Vertical axis needs to be a 2 element vector.\n');
    end
end


% --------------------------------------------------------------------
function Axis2_Callback(hObject, eventdata, handles)
a = axis(handles.Graph2);
a = a(3:4);
answer = inputdlg('New lower graph vertical axis [2 element vector]','',1,{sprintf('[%s]',num2str(a))});
if ~isempty(answer)
    a = str2num(answer{1});
    if length(a) == 2
        set(handles.Graph2, 'YLim', a);
    else
        fprintf('   Vertical axis needs to be a 2 element vector.\n');
    end
end


% --------------------------------------------------------------------
function HorizontalAxis_Callback(hObject, eventdata, handles)
a = axis(handles.Graph2);
a = a(1:2);
answer = inputdlg('New horizontal axis [2 element vector]','',1,{sprintf('[%s]',num2str(a))});
if ~isempty(answer)
    a = str2num(answer{1});
    if length(a) == 2
        set(handles.Graph1, 'XLim', a);
        set(handles.Graph2, 'XLim', a);
        set(handles.Graph3, 'XLim', a);
        set(handles.Graph4, 'XLim', a);
        set(handles.LatticeAxes, 'XLim', a);
        setappdata(handles.figure1, 'AxisRange1X', a(:)');
        setappdata(handles.figure1, 'AxisRange2X', a(:)');
    else
        fprintf('   Horizontal axis needs to be a 2 element vector.\n');
    end
end


% --------------------------------------------------------------------
function HorizontalAxisSector_Callback(hObject, eventdata, handles)
a = eventdata;
if length(a) == 2
    set(handles.Graph1, 'XLim', a);
    set(handles.Graph2, 'XLim', a);
    set(handles.Graph3, 'XLim', a);
    set(handles.Graph4, 'XLim', a);
    set(handles.LatticeAxes, 'XLim', a);

    setappdata(handles.figure1, 'AxisRange1X', a(:)');
    setappdata(handles.figure1, 'AxisRange2X', a(:)');
else
    fprintf('   Horizontal axis needs to be a 2 element vector.\n');
end




% --------------------------------------------------------------------
function YScaleLog1_Callback(hObject, eventdata, handles)
if ~strcmpi(get(handles.Graph1Bar,'Checked'),'On')
    set(handles.Graph1,'YScale','Log');
    set(handles.YScaleLog1,'Checked','On');
    set(handles.YScaleLinear1,'Checked','Off');
    drawnow;
else
    fprintf('   Log scale not allowed for bar graphs\n');
end

% --------------------------------------------------------------------
function YScaleLinear1_Callback(hObject, eventdata, handles)
set(handles.Graph1,'YScale','Linear');
set(handles.YScaleLog1,'Checked','Off');
set(handles.YScaleLinear1,'Checked','On');
drawnow;


% --------------------------------------------------------------------
function YScaleLog2_Callback(hObject, eventdata, handles)
if ~strcmpi(get(handles.Graph2Bar,'Checked'),'On')
    set(handles.Graph2,'YScale','Log');
    set(handles.YScaleLog2,'Checked','On');
    set(handles.YScaleLinear2,'Checked','Off');
    drawnow;
else
    fprintf('   Log scale not allowed for bar graphs\n');
end

% --------------------------------------------------------------------
function YScaleLinear2_Callback(hObject, eventdata, handles)
set(handles.Graph2,'YScale','Linear');
set(handles.YScaleLog2,'Checked','Off');
set(handles.YScaleLinear2,'Checked','On');
drawnow;


% --------------------------------------------------------------------
function DataStruct = CreateListboxString(DataStruct)
DataStruct.ListBoxString = strcat(family2common(DataStruct.FamilyName, DataStruct.DeviceList),'=');
% DataStruct.ListBoxString = [];
% for i = 1:size(DataStruct.DeviceList,1)
%     DataStruct.ListBoxString = strvcat(DataStruct.ListBoxString, sprintf('%s(%d,%d) = ', DataStruct.FamilyName, DataStruct.DeviceList(i,1), DataStruct.DeviceList(i,2)));
% end

% --------------------------------------------------------------------
function BPMxFamily_Callback(hObject, eventdata, handles)
UnitMenu = getappdata(handles.figure1,'UnitsFlag');
if UnitMenu == 1
    UnitsFlag = 'Physics';
else
    UnitsFlag = 'Hardware';
end

if strcmpi(get(handles.Simulate,'Checked'),'On')
    Mode = 'Simulator';
else
    Mode = 'Online';
end

if isempty(hObject)
    close(gcbf);
    error('PLOTFAMILY:  Menu corrupted, restart application.');
else
    DataStruct = get(hObject, 'UserData');
end

% Rebuild the data structure in case a status field was changed
DataStruct = family2datastruct(DataStruct.FamilyName, DataStruct.Field);

if isfamily(DataStruct)
    % Create the list box string
    DataStruct = CreateListboxString(DataStruct);

    setappdata(handles.figure1, 'BPMxFamily', DataStruct);
    
    s = getspos(DataStruct);
    setappdata(handles.figure1, 'SPosX', s);
    
    %L = getfamilydata('Circumference');
    %if isempty(L)
    %    setappdata(handles.figure1, 'AxisRange1X', [min(s) max(s)]);
    %else
    %    setappdata(handles.figure1, 'AxisRange1X', [0 L]);
    %end
    
    ZeroData = DataStruct;
    ZeroData.Data = zeros(size(DataStruct.Data,1),1);
    
    % Menu label
    set(handles.BPMxFamily,'Label',sprintf('Plot: %s.%s', DataStruct.FamilyName, DataStruct.Field));
    
    setappdata(handles.figure1,'SaveX', ZeroData);
    tmp = getappdata(handles.figure1,'SaveY');
    tmp.Data = 0 * tmp.Data;
    setappdata(handles.figure1,'SaveY', tmp);
    set(handles.SaveTime,'String', '');
    
%     % Look for the golden values
%     try
%         if strcmpi(DataStruct.Field,'Monitor')
%             % Use the golden setpoint
%             GoldenValues = getgolden(DataStruct.FamilyName, DataStruct.DeviceList, 'Setpoint', UnitsFlag, 'Struct');
%         else
%             GoldenValues = getgolden(DataStruct, UnitsFlag, 'Struct');
%         end
%         setappdata(handles.figure1, 'GoldenX', GoldenValues);
%     catch
%         setappdata(handles.figure1, 'GoldenX', ZeroData);
%     end
% 
%     % Look for the offset values
%     try
%         OffsetValues = getoffset(DataStruct, UnitsFlag, 'Struct');
%         setappdata(handles.figure1, 'OffsetX', OffsetValues);
%     catch
%         try 
%             % If and offset does not exist than try using the setpoint
%             setappdata(handles.figure1, 'OffsetX', getsp(DataStruct.FamilyName, DataStruct.DeviceList, Mode, UnitsFlag, 'Struct'));                
%         catch
%             % Use zeros
%             setappdata(handles.figure1, 'OffsetX', ZeroData);
%         end
%     end
    
    try
        FileName = getappdata(handles.figure1, 'FileName');
        if isempty(FileName)
            FileName = getappdata(handles.figure1, 'FileNameY');
        end
        if isempty(FileName)
            setappdata(handles.figure1,'FileX', ZeroData);
        else
            tmp = getdata(DataStruct, FileName, 'Struct');
            if UnitMenu == 1 && strcmpi(tmp.Units,'Hardware')
                % Physics units requested, data is in Hardware units
                tmp = hw2physics(tmp);
            else
                % Hardware units requested, data is in Physics units
                tmp = physics2hw(tmp);
            end
            setappdata(handles.figure1,'FileX', tmp);
            setappdata(handles.figure1,'FileNameX', FileName);
        end
    catch
        setappdata(handles.figure1,'FileX', ZeroData);
        setappdata(handles.figure1,'FileNameX','');
    end

    % Make sure the scale is linear for bar plots
    if strcmpi(get(handles.Graph1Bar,'Checked'),'On')
        set(handles.Graph1,'YScale','Linear');
        set(handles.YScaleLog1,'Checked','Off');
        set(handles.YScaleLinear1,'Checked','On');
    end

    set(handles.DataList1,'Value', 1);
    set(handles.DataList1,'ListBoxTop', 1);
    UpdateFileDisplayLocal(handles);
    OneShot_Callback(hObject, eventdata, handles);        
    
    % Auto scale y-axis
    % AutoScaleYLocal(handles);
    a = axis(handles.Graph1);
    axis(handles.Graph1, 'auto');
    set(handles.Graph1, 'XLim', a(1:2));
    
else
    fprintf('   %s is not a known family\n', DataStruct.FamilyName);
end


% --------------------------------------------------------------------
function BPMyFamily_Callback(hObject, eventdata, handles)
UnitMenu = getappdata(handles.figure1,'UnitsFlag');
if UnitMenu == 1
    UnitsFlag = 'Physics';
else
    UnitsFlag = 'Hardware';
end

if strcmpi(get(handles.Simulate,'Checked'),'On')
    Mode = 'Simulator';
else
    Mode = 'Online';
end

if isempty(hObject)
    close(gcbf);
    error('PLOTFAMILY:  Menu corrupted, restart application.');
else
    DataStruct = get(hObject, 'UserData');
end

% Rebuild the data structure in case a status field was changed
DataStruct = family2datastruct(DataStruct.FamilyName, DataStruct.Field);

if isfamily(DataStruct)
    % Create the list box string
    DataStruct = CreateListboxString(DataStruct);

    setappdata(handles.figure1, 'BPMyFamily', DataStruct);
    
    s = getspos(DataStruct);
    setappdata(handles.figure1, 'SPosY', s);
    %L = getfamilydata('Circumference');
    %if isempty(L)
    %    setappdata(handles.figure1, 'AxisRange2X', [min(s) max(s)]);
    %else
    %    setappdata(handles.figure1, 'AxisRange2X', [0 L]);
    %end
    
    ZeroData = DataStruct;
    ZeroData.Data = zeros(size(DataStruct.Data,1),1);
    
    % Menu label
    set(handles.BPMyFamily,'Label',sprintf('Plot: %s.%s', DataStruct.FamilyName, DataStruct.Field));
    
    setappdata(handles.figure1,'SaveY', ZeroData);
    tmp = getappdata(handles.figure1,'SaveX');
    tmp.Data = 0 * tmp.Data;
    setappdata(handles.figure1,'SaveX', tmp);
    set(handles.SaveTime,'String', '');
    
%     % Look for the golden values
%     try
%         if strcmpi(DataStruct.Field,'Monitor')
%             % Use the golden setpoint
%             GoldenValues = getgolden(DataStruct.FamilyName, DataStruct.DeviceList, 'Setpoint', UnitsFlag, 'Struct');
%         else
%             GoldenValues = getgolden(DataStruct, UnitsFlag, 'Struct');
%         end
%         setappdata(handles.figure1,'GoldenY', GoldenValues);
%     catch
%         setappdata(handles.figure1, 'GoldenY', ZeroData);
%     end
%     
%     % Look for the offset values
%     try
%         OffsetValues = getoffset(DataStruct, UnitsFlag, 'Struct');
%         setappdata(handles.figure1,'OffsetY', OffsetValues);
%     catch
%         try 
%             % If and offset does not exist than try using the setpoint
%             setappdata(handles.figure1, 'OffsetY', getsp(DataStruct.FamilyName, DataStruct.DeviceList, Mode, UnitsFlag, 'Struct'));                
%         catch
%             % Use zeros
%             setappdata(handles.figure1, 'OffsetY', ZeroData);
%         end
%     end
    
    % Look for file data
    try
        FileName = getappdata(handles.figure1, 'FileNameY');
        if isempty(FileName)
            FileName = getappdata(handles.figure1, 'FileName');
        end
        if isempty(FileName)
            setappdata(handles.figure1, 'FileY', ZeroData);
        else
            tmp = getdata(DataStruct, FileName, 'Struct');
            if UnitMenu == 1 && strcmpi(tmp.Units,'Hardware')
                % Physics units requested, data is in Hardware units
                tmp = hw2physics(tmp);
            else
                % Hardware units requested, data is in Physics units
                tmp = physics2hw(tmp);
            end
            setappdata(handles.figure1, 'FileY', tmp);
            setappdata(handles.figure1, 'FileNameY', FileName);
        end
    catch
        setappdata(handles.figure1, 'FileY', ZeroData);
        setappdata(handles.figure1, 'FileNameY','');
    end
    
    % Make sure the scale is linear for bar plots
    if strcmpi(get(handles.Graph2Bar,'Checked'),'On')
        set(handles.Graph2,'YScale','Linear');
        set(handles.YScaleLog2,'Checked','Off');
        set(handles.YScaleLinear2,'Checked','On');
    end

    set(handles.DataList2, 'Value', 1);
    set(handles.DataList2, 'ListBoxTop', 1);
    UpdateFileDisplayLocal(handles);    
    OneShot_Callback(hObject, eventdata, handles);

    % Auto scale y-axis
    % AutoScaleYLocal(handles);
    a = axis(handles.Graph2);
    axis(handles.Graph2, 'auto');
    set(handles.Graph2, 'XLim', a(1:2));
else
    fprintf('   %s is not a known family\n', DataStruct.FamilyName);
end


% --------------------------------------------------------------------
function BPMxList_Callback(hObject, eventdata, handles)
UnitMenu = getappdata(handles.figure1,'UnitsFlag');
if UnitMenu == 1
    UnitsFlag = 'Physics';
else
    UnitsFlag = 'Hardware';
end

if strcmpi(get(handles.Simulate,'Checked'),'On')
    Mode = 'Simulator';
else
    Mode = 'Online';
end

DataStruct = getappdata(handles.figure1, 'BPMxFamily');
Family = DataStruct.FamilyName;
List = DataStruct.DeviceList;
FullList = family2dev(Family);
CheckList = zeros(size(FullList,1),1);
i = findrowindex(List, FullList);
CheckList(i) = 1;
List = editlist(FullList, Family, CheckList);

DataStruct.Data = NaN * ones(size(List,1),1);  %DataStruct.Data(i);
DataStruct.DeviceList = List;
DataStruct.Status = ones(size(List,1),1);

% Create the list box string
DataStruct = CreateListboxString(DataStruct);

setappdata(handles.figure1, 'BPMxFamily', DataStruct);

s = getspos(DataStruct);
setappdata(handles.figure1, 'SPosX', s);

ZeroData = DataStruct;
ZeroData.Data = zeros(size(DataStruct.Data,1),1);

% % Look for the golden values
% try
%     if strcmpi(DataStruct.Field,'Monitor')
%         % Use the golden setpoint
%         GoldenValues = getgolden(DataStruct.FamilyName, DataStruct.DeviceList, 'Setpoint', UnitsFlag, 'Struct');
%     else
%         GoldenValues = getgolden(DataStruct, UnitsFlag, 'Struct');
%     end
%     setappdata(handles.figure1, 'GoldenX', GoldenValues);
% catch
%     setappdata(handles.figure1, 'GoldenX', ZeroData);
% end
% 
% % Look for the offset values
% try
%     OffsetValues = getoffset(DataStruct, UnitsFlag, 'Struct');
%     setappdata(handles.figure1,'OffsetX', OffsetValues);
% catch
%     try
%         % If and offset does not exist than try using the setpoint
%         setappdata(handles.figure1, 'OffsetX', getsp(DataStruct.FamilyName, DataStruct.DeviceList, Mode, UnitsFlag, 'Struct'));
%     catch
%         % Use zeros
%         setappdata(handles.figure1, 'OffsetX', ZeroData);
%     end
% end


% Changing the list wipes out a save
setappdata(handles.figure1,'SaveX', ZeroData);
tmp = getappdata(handles.figure1,'SaveY');
tmp.Data = 0 * tmp.Data;
setappdata(handles.figure1,'SaveY', tmp);
set(handles.SaveTime,'String', '');

try
    FileName = getappdata(handles.figure1, 'FileNameX');
    if isempty(FileName)
        FileName = getappdata(handles.figure1, 'FileNameY');
    end
    if isempty(FileName)
        setappdata(handles.figure1,'FileX', ZeroData);
    else
        tmp = getdata(DataStruct, FileName, 'Struct');
        if UnitMenu == 1 && strcmpi(tmp.Units,'Hardware')
            % Physics units requested, data is in Hardware units
            tmp = hw2physics(tmp);
        else
            % Hardware units requested, data is in Physics units
            tmp = physics2hw(tmp);
        end
        setappdata(handles.figure1,'FileX', tmp);
        setappdata(handles.figure1,'FileNameX', FileName);
    end
catch
    setappdata(handles.figure1,'FileX', ZeroData);
    setappdata(handles.figure1,'FileNameX','');
end

set(handles.DataList1,'Value', 1);
set(handles.DataList1,'ListBoxTop', 1);
UpdateFileDisplayLocal(handles);
cla(handles.Graph1);
OneShot_Callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function BPMyList_Callback(hObject, eventdata, handles)
UnitMenu = getappdata(handles.figure1,'UnitsFlag');
if UnitMenu == 1
    UnitsFlag = 'Physics';
else
    UnitsFlag = 'Hardware';
end

if strcmpi(get(handles.Simulate,'Checked'),'On')
    Mode = 'Simulator';
else
    Mode = 'Online';
end

DataStruct = getappdata(handles.figure1, 'BPMyFamily');
Family = DataStruct.FamilyName;
List = DataStruct.DeviceList;
FullList = family2dev(Family);
CheckList = zeros(size(FullList,1),1);
i = findrowindex(List, FullList);
CheckList(i) = 1;
List = editlist(FullList, Family, CheckList);

DataStruct.Data = NaN * ones(size(List,1),1);  %DataStruct.Data(i);
DataStruct.DeviceList = List;
DataStruct.Status = ones(size(List,1),1);
%DataStruct.Data = DataStruct.Data(i);

% Create the list box string
DataStruct = CreateListboxString(DataStruct);

setappdata(handles.figure1, 'BPMyFamily', DataStruct);

s = getspos(DataStruct);
setappdata(handles.figure1, 'SPosY', s);

ZeroData = DataStruct;
ZeroData.Data = zeros(size(DataStruct.Data,1),1);


% % Look for the golden values
% try
%     if strcmpi(DataStruct.Field,'Monitor')
%         % Use the golden setpoint
%         GoldenValues = getgolden(DataStruct.FamilyName, DataStruct.DeviceList, 'Setpoint', UnitsFlag, 'Struct');
%     else
%         GoldenValues = getgolden(DataStruct, UnitsFlag, 'Struct');
%     end
%     setappdata(handles.figure1, 'GoldenY', GoldenValues);
% catch
%     setappdata(handles.figure1, 'GoldenY', ZeroData);
% end
% 
% 
% % Look for the offset values
% try
%     OffsetValues = getoffset(DataStruct, UnitsFlag, 'Struct');
%     setappdata(handles.figure1,'OffsetY', OffsetValues);
% catch
%     try
%         % If and offset does not exist than try using the setpoint
%         setappdata(handles.figure1, 'OffsetY', getsp(DataStruct.FamilyName, DataStruct.DeviceList, Mode, UnitsFlag, 'Struct'));
%     catch
%         % Use zeros
%         setappdata(handles.figure1, 'OffsetY', ZeroData);
%     end
% end


% Changing the list wipes out a save
setappdata(handles.figure1,'SaveY', ZeroData);
tmp = getappdata(handles.figure1,'SaveX');
tmp.Data = 0 * tmp.Data;
setappdata(handles.figure1,'SaveX', tmp);
set(handles.SaveTime,'String', '');


try
    FileName = getappdata(handles.figure1, 'FileNameY');
    if isempty(FileName)
        FileName = getappdata(handles.figure1, 'FileName');
    end
    if isempty(FileName)
        setappdata(handles.figure1,'FileY', ZeroData);
    else
            tmp = getdata(DataStruct, FileName, 'Struct');
        if UnitMenu == 1 && strcmpi(tmp.Units,'Hardware')
            % Physics units requested, data is in Hardware units
            tmp = hw2physics(tmp);
        else
            % Hardware units requested, data is in Physics units
            tmp = physics2hw(tmp);
        end
        setappdata(handles.figure1,'FileY', tmp);
        setappdata(handles.figure1,'FileNameY', FileName);
    end
catch
    setappdata(handles.figure1,'FileY', ZeroData);
    setappdata(handles.figure1,'FileNameY','');
end

set(handles.DataList2,'Value', 1);
set(handles.DataList2,'ListBoxTop', 1);
UpdateFileDisplayLocal(handles);
cla(handles.Graph2);
OneShot_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function UpdatePeriod_Callback(hObject, eventdata, handles)
answer = inputdlg('Enter new update period [seconds]','',1,{num2str(getappdata(handles.figure1, 'UpdatePeriod'))});
if ~isempty(answer)
    UpdatePeriod = str2num(answer{1});
    if ~isempty(UpdatePeriod) && UpdatePeriod >= 0
        if UpdatePeriod > 15
            UpdatePeriod = 15;
        end
        set(handles.UpdatePeriod,'Label', sprintf('Update Period = %.2f sec',UpdatePeriod));
        setappdata(handles.figure1, 'UpdatePeriod', UpdatePeriod);
    end
end

% --------------------------------------------------------------------
function PhysicsUnits_Callback(hObject, eventdata, handles)
UnitMenu = 1;
setappdata(handles.figure1,'UnitsFlag', UnitMenu);
set(handles.PhysicsUnitsFlag,'Checked','On');
set(handles.HardwareUnitsFlag,'Checked','Off');
set(handles.MicronFlag,'Checked','Off');

RawX = getappdata(handles.figure1, 'RawX');
RawY = getappdata(handles.figure1, 'RawY');

if strcmpi(RawX.Units,'Hardware')
    % Physics units requested, data is in Hardware units
    setappdata(handles.figure1, 'RawX', hw2physics(RawX));
    setappdata(handles.figure1, 'RawY', hw2physics(RawY));

%     setappdata(handles.figure1, 'OffsetX', hw2physics(getappdata(handles.figure1,'OffsetX')));
%     setappdata(handles.figure1, 'OffsetY', hw2physics(getappdata(handles.figure1,'OffsetY')));
% 
%     setappdata(handles.figure1, 'GoldenX', hw2physics(getappdata(handles.figure1,'GoldenX')));
%     setappdata(handles.figure1, 'GoldenY', hw2physics(getappdata(handles.figure1,'GoldenY')));
    
    setappdata(handles.figure1, 'SaveX', hw2physics(getappdata(handles.figure1,'SaveX')));
    setappdata(handles.figure1, 'SaveY', hw2physics(getappdata(handles.figure1,'SaveY')));

    setappdata(handles.figure1, 'FileX', hw2physics(getappdata(handles.figure1,'FileX')));
    setappdata(handles.figure1, 'FileY', hw2physics(getappdata(handles.figure1,'FileY')));
end

DataStruct1 = getappdata(handles.figure1, 'BPMxFamily');
if strcmpi(DataStruct1.Units,'Hardware')
    % Physics units requested, data is in Hardware units
    setappdata(handles.figure1, 'BPMxFamily', hw2physics(DataStruct1));
end

DataStruct2 = getappdata(handles.figure1, 'BPMyFamily');
if strcmpi(DataStruct2.Units,'Hardware')
    % Physics units requested, data is in Hardware units
    setappdata(handles.figure1, 'BPMyFamily', hw2physics(DataStruct2));
end

plotappdatalocal(handles);
AutoScaleYLocal(handles);

% Turn off the setpoint GUI (or change it to physics units)
TurnOffSetpointGUI_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function HardwareUnits_Callback(hObject, eventdata, handles)
UnitMenu = 2;
setappdata(handles.figure1,'UnitsFlag', UnitMenu);
set(handles.PhysicsUnitsFlag,'Checked','Off');
set(handles.HardwareUnitsFlag,'Checked','On');
set(handles.MicronFlag,'Checked','Off');

RawX = getappdata(handles.figure1, 'RawX');
RawY = getappdata(handles.figure1, 'RawY');

if strcmpi(RawX.Units,'Physics')
    % Hardware units requested, data is in Physics units
    setappdata(handles.figure1, 'RawX', physics2hw(RawX));
    setappdata(handles.figure1, 'RawY', physics2hw(RawY));

%     setappdata(handles.figure1, 'OffsetX', physics2hw(getappdata(handles.figure1,'OffsetX')));
%     setappdata(handles.figure1, 'OffsetY', physics2hw(getappdata(handles.figure1,'OffsetY')));
% 
%     setappdata(handles.figure1, 'GoldenX', physics2hw(getappdata(handles.figure1,'GoldenX')));
%     setappdata(handles.figure1, 'GoldenY', physics2hw(getappdata(handles.figure1,'GoldenY')));
    
    setappdata(handles.figure1, 'SaveX', physics2hw(getappdata(handles.figure1,'SaveX')));
    setappdata(handles.figure1, 'SaveY', physics2hw(getappdata(handles.figure1,'SaveY')));

    setappdata(handles.figure1, 'FileX', physics2hw(getappdata(handles.figure1,'FileX')));
    setappdata(handles.figure1, 'FileY', physics2hw(getappdata(handles.figure1,'FileY')));
end

DataStruct1 = getappdata(handles.figure1, 'BPMxFamily');
if strcmpi(DataStruct1.Units,'Physics')
    % Hardware units requested, data is in Physics units
    setappdata(handles.figure1, 'BPMxFamily', physics2hw(DataStruct1));
end

DataStruct2 = getappdata(handles.figure1, 'BPMyFamily');
if strcmpi(DataStruct2.Units,'Physics')
    % Hardware units requested, data is in Physics units
    setappdata(handles.figure1, 'BPMyFamily', physics2hw(DataStruct2));
end

plotappdatalocal(handles);
AutoScaleYLocal(handles);

% Turn off the setpoint GUI (or change it to physics units)
TurnOffSetpointGUI_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function MicronFlag_Callback(hObject, eventdata, handles)
UnitMenu = 3;
setappdata(handles.figure1,'UnitsFlag', UnitMenu);
set(handles.PhysicsUnitsFlag,'Checked','Off');
set(handles.HardwareUnitsFlag,'Checked','Off');
set(handles.MicronFlag,'Checked','On');

RawX = getappdata(handles.figure1, 'RawX');
RawY = getappdata(handles.figure1, 'RawY');

if strcmpi(RawX.Units,'Physics')
    % Hardware units requested, data is in Physics units
    setappdata(handles.figure1, 'RawX', physics2hw(RawX));
    setappdata(handles.figure1, 'RawY', physics2hw(RawY));

%     setappdata(handles.figure1, 'OffsetX', physics2hw(getappdata(handles.figure1,'OffsetX')));
%     setappdata(handles.figure1, 'OffsetY', physics2hw(getappdata(handles.figure1,'OffsetY')));
% 
%     setappdata(handles.figure1, 'GoldenX', physics2hw(getappdata(handles.figure1,'GoldenX')));
%     setappdata(handles.figure1, 'GoldenY', physics2hw(getappdata(handles.figure1,'GoldenY')));
    
    setappdata(handles.figure1, 'SaveX', physics2hw(getappdata(handles.figure1,'SaveX')));
    setappdata(handles.figure1, 'SaveY', physics2hw(getappdata(handles.figure1,'SaveY')));

    setappdata(handles.figure1, 'FileX', physics2hw(getappdata(handles.figure1,'FileX')));
    setappdata(handles.figure1, 'FileY', physics2hw(getappdata(handles.figure1,'FileY')));
end

DataStruct1 = getappdata(handles.figure1, 'BPMxFamily');
if strcmpi(DataStruct1.Units,'Physics')
    % Hardware units requested, data is in Physics units
    setappdata(handles.figure1, 'BPMxFamily', physics2hw(DataStruct1));
end

DataStruct2 = getappdata(handles.figure1, 'BPMyFamily');
if strcmpi(DataStruct2.Units,'Physics')
    % Hardware units requested, data is in Physics units
    setappdata(handles.figure1, 'BPMyFamily', physics2hw(DataStruct2));
end

plotappdatalocal(handles);
AutoScaleYLocal(handles);
drawnow;


% --------------------------------------------------------------------
function SaveOrbitToFile_Callback(hObject, eventdata, handles)

Data1 = getappdata(handles.figure1, 'RawX');
Data2 = getappdata(handles.figure1, 'RawY');

if isfield(Data1,'TimeStamp')
    DirStart = pwd;
    
    FamilyName1 = Data1.FamilyName;
    FamilyName2 = Data2.FamilyName;
    if strcmpi(FamilyName1, FamilyName2)
        FileName = appendtimestamp(FamilyName1, Data1.TimeStamp);
    else
        FileName = appendtimestamp([FamilyName1,'_',FamilyName2], Data1.TimeStamp);
    end
    DirectoryName = getfamilydata('Directory','DataRoot');
    
    [FileName, DirectoryName] = uiputfile('*.mat', 'Select File (Cancel to not save to a file)', [DirectoryName FileName, '.mat']);
    if FileName == 0 
        %fprintf('   No data saved\n');
        return
    end
    
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    save(FileName, 'Data1', 'Data2');
    cd(DirStart);
    fprintf('   Data saved to %s\n', [DirectoryName FileName]);
else
    fprintf('   No data to save \n');
end


% --------------------------------------------------------------------
function Online_Callback(hObject, eventdata, handles)
set(handles.Online,  'Checked','On');
set(handles.Simulate,'Checked','Off');
SetFigureTitle(handles.figure1, 'Online');
%switch2online;
OneShot_Callback(hObject, eventdata, handles);
plotappdatalocal(handles);

% --------------------------------------------------------------------
function Simulate_Callback(hObject, eventdata, handles)
set(handles.Online,  'Checked','Off');
set(handles.Simulate,'Checked','On');
SetFigureTitle(handles.figure1, 'Model');
%switch2sim;
OneShot_Callback(hObject, eventdata, handles);
plotappdatalocal(handles);

% --------------------------------------------------------------------
function Sim2Machine_Callback(hObject, eventdata, handles)
sim2machine;
OneShot_Callback(hObject, eventdata, handles);
plotappdatalocal(handles);

% --------------------------------------------------------------------
function Machine2Sim_Callback(hObject, eventdata, handles)
machine2sim;
OneShot_Callback(hObject, eventdata, handles);
plotappdatalocal(handles);


% --------------------------------------------------------------------
function HorizontalAxesScaling(hObject, eventdata, handles)
% Graph 1, 2, 3, & 4 axes scaling
py = 0.74;
p1 = get(handles.Graph1,'Position');
p2 = get(handles.Graph2,'Position');
p3 = get(handles.Graph3,'Position');
p4 = get(handles.Graph4,'Position');
pa = get(handles.LatticeAxes,'Position');
if strcmpi(get(handles.AddPlot1_Nothing,'Checked'),'Off') || strcmpi(get(handles.AddPlot2_Nothing,'Checked'),'Off')
    py = py*.93;
end
set(handles.Graph1,     'Position', [p1(1) p1(2) py p1(4)]);
set(handles.Graph2,     'Position', [p2(1) p2(2) py p2(4)]);
set(handles.Graph3,     'Position', [p3(1) p3(2) py p3(4)]);
set(handles.Graph4,     'Position', [p4(1) p4(2) py p4(4)]);
set(handles.LatticeAxes,'Position', [pa(1) pa(2) py pa(4)]);

plotappdatalocal(handles);


% --------------------------------------------------------------------
function AddPlot_Nothing_Callback(hObject, eventdata, handles)

hp = get(hObject, 'Parent');
hp = get(hp, 'Parent');
if strcmp(get(hp,'Label'),'Graph #1')
    plot(handles.Graph3, NaN, NaN)
    set(handles.Graph3,'Visible','Off');
    set(handles.Graph3,'color','none');
    set(handles.AddPlot1_Nothing,'Checked','On');
    set(handles.AddPlot1_BetaX,'Checked','Off');
    set(handles.AddPlot1_BetaY,'Checked','Off');
    set(handles.AddPlot1_DispX,'Checked','Off');
    set(handles.AddPlot1_DispY,'Checked','Off');
else
    plot(handles.Graph4, NaN, NaN)
    set(handles.Graph4,'Visible','Off');
    set(handles.Graph4,'color','none');
    set(handles.AddPlot2_Nothing,'Checked','On');
    set(handles.AddPlot2_BetaX,'Checked','Off');
    set(handles.AddPlot2_BetaY,'Checked','Off');
    set(handles.AddPlot2_DispX,'Checked','Off');
    set(handles.AddPlot2_DispY,'Checked','Off');
end

HorizontalAxesScaling(hObject, eventdata, handles);


% --------------------------------------------------------------------
function AddPlot_Beta_Callback(hObject, eventdata, handles)
% Plot Beta
LineColor = [0 .5 0];

hp = get(hObject,'Parent');
hp = get(hp,'Parent');
hp = get(hp,'Parent');
if strcmp(get(hp,'Label'),'Graph #1')
    hAxes = handles.Graph3;
else
    hAxes = handles.Graph4;
end
[BetaX, BetaY, Sx, Sy] = modelbeta('All','All');
if strcmp(get(hObject,'Label'),'Horizontal')
    plot(hAxes, Sx, BetaX, 'Color',LineColor);
    ylabel(hAxes, '{\it\beta_x} [meters]', 'Color',LineColor);
else
    plot(hAxes, Sy, BetaY, 'Color',LineColor);
    ylabel(hAxes, '{\it\beta_y} [meters]', 'Color',LineColor);
end

if strcmp(get(hp,'Label'),'Graph #1')
    AxisRangeX = getappdata(handles.figure1, 'AxisRange1X');
else
    AxisRangeX = getappdata(handles.figure1, 'AxisRange2X');
end

axis(hAxes, 'auto');
a = axis(hAxes);        
del = a(4) - a(3);
axis(hAxes, [AxisRangeX(1) AxisRangeX(2) a(3)-.4*del a(4)+.4*del]);
AutoScaleVertical(hAxes, .77);

% Set axes defaults
set(hAxes, 'Color', 'none');
set(hAxes, 'Visible', 'On');  % Off to hide axis
set(hAxes, 'YAxisLocation', 'Right');
set(hAxes, 'XGrid', 'Off');
set(hAxes, 'YGrid', 'Off');
set(hAxes, 'XMinorGrid', 'Off');
set(hAxes, 'YMinorGrid', 'Off');
set(hAxes, 'YMinorTick', 'Off');
set(hAxes, 'XMinorTick', 'Off');
set(hAxes, 'XAxisLocation', 'Bottom');
set(hAxes, 'XTickLabel', '');
% set(hAxes, 'YTickLabel', []);
% set(hAxes, 'XTick', []);
% set(hAxes, 'YTick', []);

YTick = get(handles.Graph1, 'YTick');


if strcmp(get(hp,'Label'),'Graph #1')
    set(handles.AddPlot1_Nothing,'Checked','Off');
    if strcmp(get(hObject,'Label'),'Horizontal')
        set(handles.AddPlot1_BetaX,'Checked','On');
        set(handles.AddPlot1_BetaY,'Checked','Off');
    else
        set(handles.AddPlot1_BetaX,'Checked','Off');
        set(handles.AddPlot1_BetaY,'Checked','On');
    end
    set(handles.AddPlot1_DispX,'Checked','Off');
    set(handles.AddPlot1_DispY,'Checked','Off');
    
    set(hAxes ,'ButtonDownFcn','plotfamily(''Graph1_ButtonDown'',gcbo,[],guidata(gcbo))');
    h = get(hAxes,'Children');
    for i = 1:length(h)
        set(h(i) ,'ButtonDownFcn','plotfamily(''Graph1_ButtonDown'',gcbo,[],guidata(gcbo))');
    end
else
    set(handles.AddPlot2_Nothing,'Checked','Off');
    if strcmp(get(hObject,'Label'),'Horizontal')
        set(handles.AddPlot2_BetaX,'Checked','On');
        set(handles.AddPlot2_BetaY,'Checked','Off');
    else
        set(handles.AddPlot2_BetaX,'Checked','Off');
        set(handles.AddPlot2_BetaY,'Checked','On');
    end
    set(handles.AddPlot2_DispX,'Checked','Off');
    set(handles.AddPlot2_DispY,'Checked','Off');
    
    set(hAxes ,'ButtonDownFcn','plotfamily(''Graph2_ButtonDown'',gcbo,[],guidata(gcbo))');
    h = get(hAxes,'Children');
    for i = 1:length(h)
        set(h(i) ,'ButtonDownFcn','plotfamily(''Graph2_ButtonDown'',gcbo,[],guidata(gcbo))');
    end
end

HorizontalAxesScaling(hObject, eventdata, handles);


% --------------------------------------------------------------------
function AddPlot_Dispersion_Callback(hObject, eventdata, handles)
% Plot dispersion in physics units
LineColor = [0 .5 0];

hp = get(hObject,'Parent');
hp = get(hp,'Parent');
hp = get(hp,'Parent');

if strcmp(get(hp,'Label'),'Graph #1')
    hAxes = handles.Graph3;
else
    hAxes = handles.Graph4;
end

[DispX, DispY, Sx, Sy] = modeldisp('All','All','Physics');
if strcmp(get(hObject,'Label'),'Horizontal')
    plot(hAxes, Sx, 100*DispX, 'Color',LineColor);
    ylabel(hAxes, '{\it\eta_x} [cm]', 'Color',LineColor);
else
    plot(hAxes, Sy, 100*DispY, 'Color',LineColor);
    ylabel(hAxes, '{\it\eta_y} [cm]', 'Color',LineColor);
end
if strcmp(get(hp,'Label'),'Graph #1')
    AxisRangeX = getappdata(handles.figure1, 'AxisRange1X');
else
    AxisRangeX = getappdata(handles.figure1, 'AxisRange2X');
end

axis(hAxes, 'auto');
a = axis(hAxes);        
del = a(4) - a(3);
axis(hAxes, [AxisRangeX(1) AxisRangeX(2) a(3)-.4*del a(4)+.4*del]);
AutoScaleVertical(hAxes, .77);

% Set axes defaults
set(hAxes, 'Color', 'none');
set(hAxes, 'Visible', 'On');  % Off to hide axis
set(hAxes, 'YAxisLocation', 'Right');
set(hAxes, 'XGrid', 'Off');
set(hAxes, 'YGrid', 'Off');
set(hAxes, 'XMinorGrid', 'Off');
set(hAxes, 'YMinorGrid', 'Off');
set(hAxes, 'YMinorTick', 'Off');
set(hAxes, 'XMinorTick', 'Off');
set(hAxes, 'XAxisLocation', 'Bottom');
set(hAxes, 'XTickLabel', '');
% set(hAxes, 'YTickLabel', []);
% set(hAxes, 'XTick', []);
% set(hAxes, 'YTick', []);


if strcmp(get(hp,'Label'),'Graph #1')
    set(handles.AddPlot1_Nothing,'Checked','Off');
    if strcmp(get(hObject,'Label'),'Horizontal')
        set(handles.AddPlot1_DispX,'Checked','On');
        set(handles.AddPlot1_DispY,'Checked','Off');
    else
        set(handles.AddPlot1_DispX,'Checked','Off');
        set(handles.AddPlot1_DispY,'Checked','On');
    end
    set(handles.AddPlot1_BetaX,'Checked','Off');
    set(handles.AddPlot1_BetaY,'Checked','Off');
    
    set(hAxes ,'ButtonDownFcn','plotfamily(''Graph1_ButtonDown'',gcbo,[],guidata(gcbo))');
    h = get(hAxes,'Children');
    for i = 1:length(h)
        set(h(i) ,'ButtonDownFcn','plotfamily(''Graph1_ButtonDown'',gcbo,[],guidata(gcbo))');
    end
    
else
    set(handles.AddPlot2_Nothing,'Checked','Off');
    if strcmp(get(hObject,'Label'),'Horizontal')
        set(handles.AddPlot2_DispX,'Checked','On');
        set(handles.AddPlot2_DispY,'Checked','Off');
    else
        set(handles.AddPlot2_DispX,'Checked','Off');
        set(handles.AddPlot2_DispY,'Checked','On');
    end
    set(handles.AddPlot2_BetaX,'Checked','Off');
    set(handles.AddPlot2_BetaY,'Checked','Off');
    
    set(hAxes, 'ButtonDownFcn','plotfamily(''Graph2_ButtonDown'',gcbo,[],guidata(gcbo))');
    h = get(hAxes, 'Children');
    for i = 1:length(h)
        set(h(i), 'ButtonDownFcn', 'plotfamily(''Graph2_ButtonDown'',gcbo,[],guidata(gcbo))');
    end
end

HorizontalAxesScaling(hObject, eventdata, handles);


% --------------------------------------------------------------------
function DrawLattice_Callback(hObject, eventdata, handles)
% Graph size is determined here and in function HorizontalAxesScaling
CheckMark = get(handles.DrawLattice, 'Checked');
if strcmpi(CheckMark, 'On')
    % Remove the lattice drawing
    d = .015;
    p1 = [0.07    0.65-d/2    0.74    0.29+d];
    set(handles.Graph1, 'Position', p1);
    set(handles.Graph3, 'Position', p1);

    p2 = [0.07    0.27        0.74    0.29+d];
    set(handles.Graph2, 'Position', p2);
    set(handles.Graph4, 'Position', p2);

    set(handles.DrawLattice, 'Checked', 'Off');
    set(get(handles.LatticeAxes,'Children'), 'Visible' , 'Off');
else
    % Add the lattice drawing 
    g = .01;
    p1 = [0.07    0.65+g    0.74    0.29-g];
    set(handles.Graph1, 'Position', p1);
    set(handles.Graph3, 'Position', p1);

    p2 = [0.07    0.27      0.74    0.29-g];
    set(handles.Graph2, 'Position', p2);
    set(handles.Graph4, 'Position', p2);

    set(handles.LatticeAxes, 'Units', 'Normalized');
    %P = get(handles.LatticeAxes, 'Position');
    set(handles.LatticeAxes, 'Position', [0.07 0.5744-g 0.74 0.07+2*g]);  % p4 was 0.065

    set(handles.DrawLattice, 'Checked', 'On');
    set(get(handles.LatticeAxes,'Children'), 'Visible' , 'On');
end

HorizontalAxesScaling(hObject, eventdata, handles);


% --------------------------------------------------------------------
function Graph1_ButtonDown(hObject, eventdata, handles)
set(handles.figure1, 'HandleVisibility','Callback');
CurrentPoint = get(gca, 'CurrentPoint');
SposMouse = CurrentPoint(1,1);
SposData = getappdata(handles.figure1, 'SPosX');

MeritFcn = abs(SposData-SposMouse);
i = find(min(MeritFcn) == MeritFcn);
set(handles.DataList1, 'value', i(1));
set(handles.figure1, 'HandleVisibility','Off');

% --------------------------------------------------------------------
function Graph2_ButtonDown(hObject, eventdata, handles)
set(handles.figure1, 'HandleVisibility','Callback');
CurrentPoint = get(gca, 'CurrentPoint');
SposMouse = CurrentPoint(1,1);
SposData = getappdata(handles.figure1, 'SPosY');

MeritFcn = abs(SposData-SposMouse);
i = find(min(MeritFcn) == MeritFcn);
set(handles.DataList2, 'value', i(1));
set(handles.figure1, 'HandleVisibility','Off');


% --- Executes on button press in AutoScale1.
function AutoScale1_Callback(hObject, eventdata, handles)
AutoScaleVertical(handles.Graph1, .95);
AutoScaleVertical(handles.Graph3, .77);

% --- Executes on button press in AutoScale2.
function AutoScale2_Callback(hObject, eventdata, handles)
AutoScaleVertical(handles.Graph2, .95);
AutoScaleVertical(handles.Graph4, .77);

%--------------------------------------------------------
function AutoScaleVertical(h_axis, ScaleFactor)
% Auto-scale y-axis

if nargin < 2
    ScaleFactor = 1;
end

a = axis(h_axis);
% if strcmpi(get(handles.Graph2Line,'Checked'),'On')
%     % Line
%     axis(h_axis, 'auto');
%     set(h_axis, 'XLim', a(1:2));
% else
% Bar

% Get line handles (not sure why I need to filter out the non-lines)
h = get(h_axis,'Children');
for i = length(h):-1:1
    hfields = get(h(i));
    if ~any(isfield(hfields, {'XData','xdata'}))
        h(i) = [];
    end
end

if length(h) > 1
    h = sort(h(end-1:end));
    y1 = get(h(1),'YData');
        y2 = get(h(2),'YData');
    else
        y1 = get(h(1),'YData');
        y2 = y1;
    end
    x = get(h(1),'XData');
    i = find(x>a(1) & x<a(2));
    if ~isempty(i)
        % Select within present x-axis
        y1 = y1(i);
        y2 = y2(i);
    end
    
    MaxY = max([y1(:); y2(:)]);
    MinY = min([y1(:); y2(:)]);

    if isnan(MinY) || isnan(MaxY)
        axis(h_axis, 'auto');
        set(h_axis, 'XLim', a(1:2));
    else
        %if abs(MaxY-MinY) < eps
        %    MaxY = MaxY + .5;
        %    MinY = MinY - .5;
        %else
            % Add a buffer
            Delta = MaxY - MinY;
            if Delta == 0
                Delta = 1e-13; %eps;
            end
            MaxY = MaxY + (1-ScaleFactor) * Delta;
            MinY = MinY - (1-ScaleFactor) * Delta;
        %end
        set(h_axis, 'YLim', [MinY MaxY]);
    end
%end
 
% % Auto-scale y-axis
% axis(handles.Graph2, 'auto');
% a = axis(handles.Graph2);
% axis(handles.Graph2, [AxisRange2X(1) AxisRange2X(2) a(3) a(4)]);
% a = axis(handles.Graph4);
% axis(handles.Graph4, [AxisRange2X(1) AxisRange2X(2) a(3) a(4)]);



% --- Executes on button press in AutoScale1.
function AutoScaleH_Callback(hObject, eventdata, handles)

% Auto scale X-axis to the full range
L = getfamilydata('Circumference');
if isempty(L)
    DataStruct = getappdata(handles.figure1, 'BPMxFamily');
    s = getspos(DataStruct);
    AxisRangeX = [min(s) max(s)];
else
    AxisRangeX = [0 L];
end
setappdata(handles.figure1, 'AxisRange1X', AxisRangeX);
setappdata(handles.figure1, 'AxisRange2X', AxisRangeX);


% Set x-axis for everybody else
set(handles.Graph1,      'XLim', AxisRangeX);
set(handles.Graph2,      'XLim', AxisRangeX);
set(handles.Graph3,      'XLim', AxisRangeX);
set(handles.Graph4,      'XLim', AxisRangeX);
set(handles.LatticeAxes, 'XLim', AxisRangeX);

% % Auto scale X-axis to the full range
% L = getfamilydata('Circumference');
% if isempty(L)
%     DataStruct = getappdata(handles.figure1, 'BPMyFamily');
%     s = getspos(DataStruct);
%     AxisRange2X = [min(s) max(s)];
% else
%     AxisRange2X = [0 L];
% end
% setappdata(handles.figure1, 'AxisRange2X', AxisRange2X);
% 
% Set x-axis for everybody else
%set(handles.Graph1,      'XLim', [AxisRange2X(1) AxisRange2X(2)]);
%set(handles.Graph3,      'XLim', [AxisRange2X(1) AxisRange2X(2)]);
%set(handles.LatticeAxes, 'XLim', [AxisRange2X(1) AxisRange2X(2)]);


function AutoScaleYLocal(handles)
a = axis(handles.Graph1);
axis(handles.Graph1, 'auto');
set(handles.Graph1, 'XLim', a(1:2));

a = axis(handles.Graph2);
axis(handles.Graph2, 'auto');
set(handles.Graph2, 'XLim', a(1:2));



% --- Executes on button press in Graph1ZoomInVertical.
function Graph1ZoomInVertical_Callback(hObject, eventdata, handles)
a = axis(handles.Graph1);
ChangeFactor = 1.15;
del = (1/ChangeFactor-1)*(a(4)-a(3));
axis((handles.Graph1), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
set(hObject, 'Value', 0);


% --- Executes on button press in Graph1ZoomOutVertical.
function Graph1ZoomOutVertical_Callback(hObject, eventdata, handles)
a = axis(handles.Graph1);
ChangeFactor = 1.15;
del = (ChangeFactor-1)*(a(4)-a(3));
axis((handles.Graph1), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
set(hObject, 'Value', 0);


% --- Executes on button press in Graph2ZoomInVertical.
function Graph2ZoomInVertical_Callback(hObject, eventdata, handles)
a = axis(handles.Graph2);
ChangeFactor = 1.15;
del = (1/ChangeFactor-1)*(a(4)-a(3));
axis((handles.Graph2), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
set(hObject, 'Value', 0);


% --- Executes on button press in Graph2ZoomOutVertical.
function Graph2ZoomOutVertical_Callback(hObject, eventdata, handles)
a = axis(handles.Graph2);
ChangeFactor = 1.15;
del = (ChangeFactor-1)*(a(4)-a(3));
axis((handles.Graph2), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
set(hObject, 'Value', 0);


% --- Executes on button press in Graph1ZoomInVertical.
function Graph1OffsetUpVertical_Callback(hObject, eventdata, handles)
ChangeFactor = 1.1;
a1 = axis(handles.Graph1);
del1 = (ChangeFactor-1)*(a1(4)-a1(3));
axis(handles.Graph1, [a1(1) a1(2) a1(3)+del1 a1(4)+del1]);
set(hObject, 'Value', 0);

% --- Executes on button press in Graph1ZoomOutVertical.
function Graph1OffsetDownVertical_Callback(hObject, eventdata, handles)
ChangeFactor = 1.1;
a1 = axis(handles.Graph1);
del1 = (1/ChangeFactor-1)*(a1(4)-a1(3));
axis(handles.Graph1, [a1(1) a1(2) a1(3)+del1 a1(4)+del1]);
set(hObject, 'Value', 0);


% --- Executes on button press in Graph1ZoomInVertical.
function Graph2OffsetUpVertical_Callback(hObject, eventdata, handles)
ChangeFactor = 1.1;
a1 = axis(handles.Graph2);
del1 = (ChangeFactor-1)*(a1(4)-a1(3));
axis(handles.Graph2, [a1(1) a1(2) a1(3)+del1 a1(4)+del1]);
set(hObject, 'Value', 0);

% --- Executes on button press in Graph1ZoomOutVertical.
function Graph2OffsetDownVertical_Callback(hObject, eventdata, handles)
ChangeFactor = 1.1;
a1 = axis(handles.Graph2);
del1 = (1/ChangeFactor-1)*(a1(4)-a1(3));
axis(handles.Graph2, [a1(1) a1(2) a1(3)+del1 a1(4)+del1]);
set(hObject, 'Value', 0);


% --- Executes on button press in HorizontalOffsetRight.
function HorizontalOffsetRight_Callback(hObject, eventdata, handles)
ChangeFactor = 1.05;
a1 = axis(handles.Graph1);
a2 = axis(handles.Graph2);
a3 = axis(handles.Graph3);
a4 = axis(handles.Graph4);
del1 = (ChangeFactor-1)*(a1(2)-a1(1));
del2 = (ChangeFactor-1)*(a2(2)-a2(1));
axis(handles.Graph1, [a1(1)+del1 a1(2)+del1 a1(3) a1(4)]);
axis(handles.Graph3, [a1(1)+del1 a1(2)+del1 a3(3) a3(4)]);
axis(handles.Graph2, [a2(1)+del2 a2(2)+del2 a2(3) a2(4)]);
axis(handles.Graph4, [a2(1)+del2 a2(2)+del2 a4(3) a4(4)]);
set(handles.LatticeAxes, 'XLim', [a2(1)+del2 a2(2)+del2]);
setappdata(handles.figure1, 'AxisRange1X', [a1(1)+del1 a1(2)+del1]);
setappdata(handles.figure1, 'AxisRange2X', [a2(1)+del2 a2(2)+del2]);

function HorizontalOffsetLeft_Callback(hObject, eventdata, handles)
ChangeFactor = 1.05;
a1 = axis(handles.Graph1);
a2 = axis(handles.Graph2);
a3 = axis(handles.Graph3);
a4 = axis(handles.Graph4);
del1 = (1/ChangeFactor-1)*(a1(2)-a1(1));
del2 = (1/ChangeFactor-1)*(a2(2)-a2(1));
axis(handles.Graph1, [a1(1)+del1 a1(2)+del1 a1(3) a1(4)]);
axis(handles.Graph3, [a1(1)+del1 a1(2)+del1 a3(3) a3(4)]);
axis(handles.Graph2, [a2(1)+del2 a2(2)+del2 a2(3) a2(4)]);
axis(handles.Graph4, [a2(1)+del2 a2(2)+del2 a4(3) a4(4)]);
set(handles.LatticeAxes, 'XLim', [a2(1)+del2 a2(2)+del2]);
setappdata(handles.figure1, 'AxisRange1X', [a1(1)+del1 a1(2)+del1]);
setappdata(handles.figure1, 'AxisRange2X', [a2(1)+del2 a2(2)+del2]);

function Graph1ZoomInHorizontal_Callback(hObject, eventdata, handles)
ChangeFactor = 1.3;
a1 = axis(handles.Graph1);
a2 = axis(handles.Graph2);
a3 = axis(handles.Graph3);
a4 = axis(handles.Graph4);
del1 = (1/ChangeFactor-1)*(a1(2)-a1(1));
del2 = (1/ChangeFactor-1)*(a2(2)-a2(1));
axis(handles.Graph1, [a1(1)-del1/2 a1(2)+del1/2 a1(3) a1(4)]);
axis(handles.Graph3, [a1(1)-del1/2 a1(2)+del1/2 a3(3) a3(4)]);
axis(handles.Graph2, [a2(1)-del2/2 a2(2)+del2/2 a2(3) a2(4)]);
axis(handles.Graph4, [a2(1)-del2/2 a2(2)+del2/2 a4(3) a4(4)]);
set(handles.LatticeAxes, 'XLim', [a2(1)-del2/2 a2(2)+del2/2]);
setappdata(handles.figure1, 'AxisRange1X', [a1(1)-del1/2 a1(2)+del1/2]);
setappdata(handles.figure1, 'AxisRange2X', [a2(1)-del2/2 a2(2)+del2/2]);

function Graph1ZoomOutHorizontal_Callback(hObject, eventdata, handles)
ChangeFactor = 1.3;
a1 = axis(handles.Graph1);
a2 = axis(handles.Graph2);
a3 = axis(handles.Graph3);
a4 = axis(handles.Graph4);
del1 = (ChangeFactor-1)*(a1(2)-a1(1));
del2 = (ChangeFactor-1)*(a2(2)-a2(1));
axis(handles.Graph1, [a1(1)-del1/2 a1(2)+del1/2 a1(3) a1(4)]);
axis(handles.Graph3, [a1(1)-del1/2 a1(2)+del1/2 a3(3) a3(4)]);
axis(handles.Graph2, [a2(1)-del2/2 a2(2)+del2/2 a2(3) a2(4)]);
axis(handles.Graph4, [a2(1)-del2/2 a2(2)+del2/2 a4(3) a4(4)]);
set(handles.LatticeAxes, 'XLim', [a2(1)-del2/2 a2(2)+del2/2]);
setappdata(handles.figure1, 'AxisRange1X', [a1(1)-del1/2 a1(2)+del1/2]);
setappdata(handles.figure1, 'AxisRange2X', [a2(1)-del2/2 a2(2)+del2/2]);


% Just in Lattice menu (Not plotfamily)
function Switch2HW_Callback(hObject, eventdata, handles)
switch2hw;

function Switch2Physics_Callback(hObject, eventdata, handles)
switch2physics;

function Switch2Online_Callback(hObject, eventdata, handles)
switch2online;

function Switch2Sim_Callback(hObject, eventdata, handles)
switch2sim;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setpoint change callbacks %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function Lattice_ButtonDown(hObject, eventdata, handles)
% Change setpoint request
ErrorFlag = 0;

% Only works on setpoint fields (at the moment)
Field = 'Setpoint';

try
    ATIndex = get(hObject, 'UserData');

    CurrentPoint = get(handles.LatticeAxes, 'CurrentPoint');
    SposMouse = CurrentPoint(1,1);
    
    [Family, List] = atindex2family(ATIndex);

    if isempty(Family) || isempty(List)
        ErrorFlag = 1;
    else

        List = List(1,:);

        HCMFamily = gethcmfamily;
        VCMFamily = getvcmfamily;
        if any(strcmpi(Family, {HCMFamily, VCMFamily}))
            % A corrector was found (how do I know if it's a HCM or VCM?  AT does not differentiate)
            if strcmpi(Family, HCMFamily) && CurrentPoint(1,2)<0
                % It should be a VCM family
                DevList = family2dev(VCMFamily);
                [i, col] = find(ATIndex == family2atindex(VCMFamily,DevList));
                if ~isempty(i)
                    Family = VCMFamily;
                    List = DevList(i,:);
                end
            elseif strcmpi(Family, VCMFamily) && CurrentPoint(1,2)>0
                % It should be a HCM family
                DevList = family2dev(HCMFamily);
                [i, col] = find(ATIndex == family2atindex(HCMFamily,DevList));
                if ~isempty(i)
                    Family = HCMFamily;
                    List = DevList(i,:);
                end
            end
        end

        [FamilyFlag,ao] = isfamily(Family);

        if isfield(ao, Field)
            % Get/save the present setpoint then call the GUI for setpoint changes
            if strcmpi(get(handles.Simulate,'Checked'),'On')
                Mode = 'Simulator';
            else
                Mode = 'Online';
            end
            if strcmpi(get(handles.PhysicsUnitsFlag,'Checked'),'On')
                %if getappdata(handles.figure1,'UnitsFlag') == 1
                UnitsFlag = 'Physics';
            else
                UnitsFlag = 'Hardware';
            end

            SP = getpv(Family, Field, List, Mode, UnitsFlag, 'Struct');
            set(handles.SetpointSlider,     'UserData', SP);
            set(handles.SetpointPushButton, 'UserData', SP);
            SetpointGUI_Callback(hObject, eventdata, handles);
        else
            ErrorFlag = 1;
        end
    end
catch
    ErrorFlag = 1;
    fprintf('\n%s\n', lasterr);
    fprintf('There was a problem getting %s.%s(%d,%d)\n', Family, Field, List);
end

if ErrorFlag
    % Turn off the setpoint GUI
    TurnOffSetpointGUI_Callback(hObject, eventdata, handles);
end


% --------------------------------------------------------------------
function SetpointGUI_Callback(hObject, eventdata, handles)

if strcmpi(get(handles.DisabledSetpointChanges,'Checked'),'Off')
    SP = get(handles.SetpointSlider, 'UserData');

    % Use slider and edit box
    set(handles.SetpointSlider, 'UserData', SP);
    try
        MaxPV = maxpv(SP);
        MinPV = minpv(SP);
        %if isinf(MaxPV) && ~isnan(MaxPV)
        %    MaxPV = 1e10; %SP.Data + abs(SP.Data);
        %end
        %if isinf(MinPV) && ~isnan(MinPV)
        %    MinPV = -1e10; %SP.Data - abs(SP.Data);;
        %end

        if MaxPV < MinPV
            tmp = MaxPV;
            MaxPV = MinPV;
            MinPV = tmp;
        end

        if isnumeric(MaxPV) && isnumeric(MinPV) && ~isinf(MaxPV) && ~isinf(MinPV) && ~isnan(MaxPV) && ~isnan(MinPV) && (MaxPV-MinPV)~=0
            Range = abs(MaxPV-MinPV);
            if Range == 1
                StepSize = 1;
            else
                StepSize = Range/5000;
            end
        else
            StepSize = 1;
        end
        set(handles.SetpointStepSize, 'String', num2str(StepSize));
        %set(handles.SetpointStepSize, 'String', sprintf('%f',StepSize));
    catch
        MaxPV = Inf; % 1e10; % SP.Data + abs(SP.Data);
        MinPV =-Inf; %-1e10; % SP.Data - abs(SP.Data);
    end

    set(handles.SetpointMax, 'String', sprintf('%f',MaxPV));
    set(handles.SetpointMin, 'String', sprintf('%f',MinPV));

    if ~isinf(MaxPV) && ~isnan(MaxPV) && (MaxPV-MinPV)~=0
        set(handles.SetpointSlider, 'Max', MaxPV);
    end
    if ~isinf(MinPV) && ~isnan(MaxPV) && (MaxPV-MinPV)~=0
        set(handles.SetpointSlider, 'Min', MinPV);
    end
    SetpointRange_Callback(hObject, eventdata, handles);

    set(handles.SetpointFamily, 'String', sprintf('%s.%s', deblank(family2common(SP.FamilyName, SP.DeviceList)), SP.Field));
    %set(handles.SetpointFamily, 'String', sprintf('%s.%s(%d,%d)', SP.FamilyName, SP.Field, SP.DeviceList));
    try
        set(handles.SetpointFamily,  'TooltipString', sprintf('%s', family2channel(SP)));
    catch
        set(handles.SetpointFamily,  'TooltipString', '');
    end
    set(handles.SetpointUnits,   'String', [SP.UnitsString, '/step']);
    set(handles.SetpointEditBox, 'String', sprintf('%f', SP.Data));
    if isempty(SP.UnitsString)
        set(handles.SetpointEditBox, 'TooltipString', 'New setpoint');
    else
        set(handles.SetpointEditBox, 'TooltipString', sprintf('New setpoint [%s]', SP.UnitsString));
    end
    
    set(handles.SetpointPushButton, 'String', sprintf('%f', SP.Data));
    set(handles.SetpointPushButton, 'TooltipString', sprintf('Restore original setpoint to %f %s', SP.Data, SP.UnitsString));


    set(handles.SetpointEditBox,   'Visible', 'On');
    set(handles.SetpointFamily,    'Visible', 'On');
    set(handles.SetpointUnits,     'Visible', 'On');
    set(handles.SetpointSlider,    'Visible', 'On');
    set(handles.SetpointMax,       'Visible', 'On');
    set(handles.SetpointMin,       'Visible', 'On');
    set(handles.SetpointFrame,     'Visible', 'On');
    set(handles.SetpointStepSize,  'Visible', 'On');
    set(handles.SetpointPushButton,'Visible', 'On');

    % Change the save and file text to make room for the slider
    p = get(handles.SaveTime, 'Position');
    set(handles.SaveTime, 'Position',  [p(1) p(2) .353*p(3) p(4)]);
    p = get(handles.FileNameX, 'Position');
    set(handles.FileNameX, 'Position', [p(1) p(2) .353*p(3) p(4)]);
    p = get(handles.FileNameY, 'Position');
    set(handles.FileNameY, 'Position', [p(1) p(2) .353*p(3) p(4)]);

    % % Other method: use input dialog box
    % answer = inputdlg(sprintf('Enter new setpoint for %s.%s(%d,%d) in %s (%s):', SP.FamilyName, SP.Field, SP.DeviceList, SP.UnitsString, SP.Mode),'FAMILYPLOT',1,{sprintf('%s',num2str(SP.Data))});
    % if ~isempty(answer)
    %     NewSP = str2num(answer{1});
    %     if ~isempty(NewSP)
    %         SP.Data = NewSP
    %         set(handles.SetpointSlider,  'UserData', SP);
    %         ChangeSetpointPlotfamily(hObject, eventdata, handles);
    %         %setpv(Family, Field, NewSP, List, Mode);
    %     end
    % end
end


% --------------------------------------------------------------------
function SetpointRange_Callback(hObject, eventdata, handles)

MaxPV = str2num(get(handles.SetpointMax,'String'));
MinPV = str2num(get(handles.SetpointMin,'String'));

if isnumeric(MaxPV) && isnumeric(MinPV) && ~isinf(MaxPV) && ~isinf(MinPV) && ~isnan(MaxPV) && ~isnan(MinPV) && (MaxPV-MinPV)~=0
    if MaxPV < MinPV
        fprintf('   Maximum range must be greater than the minimum range.\n');
        MaxPV = get(handles.SetpointSlider, 'Max');
        MinPV = get(handles.SetpointSlider, 'Min');
        set(handles.SetpointMax, 'String', sprintf('%f',MaxPV));
        set(handles.SetpointMin, 'String', sprintf('%f',MinPV));
    else
        StepSize = abs(str2num(get(handles.SetpointStepSize, 'String')));
        Range = abs(MaxPV-MinPV);
        if isempty(StepSize) || ~isnumeric(StepSize)
            fprintf('   Step size is not a numeric value.  Overwriting with the default step size.\n');
            StepSize = Range/1000;
        end
        set(handles.SetpointStepSize, 'String', num2str(StepSize));
        %set(handles.SetpointStepSize, 'String', sprintf('%f',StepSize));
        Steps = Range/StepSize;
        if Steps < 10
            Steps = 10;
        end
        set(handles.SetpointSlider, 'Max', MaxPV);
        set(handles.SetpointSlider, 'Min', MinPV);
        set(handles.SetpointSlider, 'SliderStep', [1/Steps 10/Steps]);
        %set(handles.SetpointSlider, 'SliderStep', [.001 .01]);

        SP = get(handles.SetpointSlider, 'UserData');
        set(handles.SetpointSlider,  'Value',  SP.Data);
        
        set(handles.SetpointSlider, 'Enable', 'On');
    end
else
    set(handles.SetpointSlider, 'Enable', 'Off');
end



% --------------------------------------------------------------------
function SetpointSlider_Callback(hObject, eventdata, handles)

% Get setpoint from the slider
NewSP = get(handles.SetpointSlider, 'Value');

SP = get(handles.SetpointSlider, 'UserData');
SP.Data = NewSP;

% Update Slider
set(handles.SetpointSlider, 'UserData', SP);
set(handles.SetpointSlider, 'Value', NewSP);

% Update EditBox
set(handles.SetpointEditBox, 'String', sprintf('%f', SP.Data));

% Make setpoint change
ChangeSetpointPlotfamily(hObject, eventdata, handles);


% --------------------------------------------------------------------
function SetpointEditBox_Callback(hObject, eventdata, handles)

% Get setpoint from the editbox
ValueStr = get(handles.SetpointEditBox, 'String');

if ~isempty(ValueStr)
    NewSP = str2num(ValueStr);

    SP = get(handles.SetpointSlider, 'UserData');
    SP.Data = NewSP;

    % Check range (if slider is enabled)
    ChangeFlag = 1;
    if strcmpi(get(handles.SetpointSlider,'Enable'), 'On')
        MaxPV = str2num(get(handles.SetpointMax,'String'));
        MinPV = str2num(get(handles.SetpointMin,'String'));
        if isnumeric(MaxPV) && isnumeric(MinPV) && ~isinf(MaxPV) && ~isinf(MinPV) && ~isnan(MaxPV) && ~isnan(MinPV)
            if MaxPV < NewSP  || NewSP < MinPV
                fprintf('   The requested setpoint is outside the limits.  Requested cancelled.\n');
                ChangeFlag = 0;
                OldSP = get(handles.SetpointSlider, 'Value');
                set(handles.SetpointEditBox, 'String', sprintf('%f',OldSP));
            end
        end
    end

    % Update Slider
    if ChangeFlag
        set(handles.SetpointSlider, 'UserData', SP);

        % Don't change the slider if it's not enabled
        if strcmpi(get(handles.SetpointSlider,'Enable'), 'On')
            set(handles.SetpointSlider, 'Value', NewSP);
        end

        % Make setpoint change
        ChangeSetpointPlotfamily(hObject, eventdata, handles);
    end
end


% --------------------------------------------------------------------
function SetpointPushButton_Callback(hObject, eventdata, handles)

% Get setpoint from the pushbutton
SP = get(handles.SetpointPushButton, 'UserData');

% Update Slider if it's enabled
if strcmpi(get(handles.SetpointSlider,'Enable'), 'On')
    set(handles.SetpointSlider, 'Value', SP.Data);
end

% Store the setpoint change and update the editbox
set(handles.SetpointSlider, 'UserData', SP);
set(handles.SetpointEditBox, 'String', sprintf('%f',SP.Data));

% Make setpoint change
ChangeSetpointPlotfamily(hObject, eventdata, handles);


% --------------------------------------------------------------------
function ChangeSetpointPlotfamily(hObject, eventdata, handles)

SP = get(handles.SetpointSlider, 'UserData');

% Get the present mode (units are stored with the data)
if strcmpi(get(handles.Simulate,'Checked'),'On')
    Mode = 'Simulator';
else
    Mode = 'Online';
end


% Make the setpoint change
setpv(SP, 0, Mode);


% Update plots
OneShot_Callback(hObject, eventdata, handles);

if strcmpi(get(handles.AddPlot1_BetaX,'Checked'),'On')
    AddPlot_Beta_Callback(handles.AddPlot1_BetaX, eventdata, handles);
end
if strcmpi(get(handles.AddPlot2_BetaX,'Checked'),'On')
    AddPlot_Beta_Callback(handles.AddPlot2_BetaX, eventdata, handles);
end
if strcmpi(get(handles.AddPlot1_BetaY,'Checked'),'On')
    AddPlot_Beta_Callback(handles.AddPlot1_BetaY, eventdata, handles);
end
if strcmpi(get(handles.AddPlot2_BetaY,'Checked'),'On')
    AddPlot_Beta_Callback(handles.AddPlot2_BetaY, eventdata, handles);
end

if strcmpi(get(handles.AddPlot1_DispX,'Checked'),'On')
    AddPlot_Dispersion_Callback(handles.AddPlot1_DispX, eventdata, handles);
end
if strcmpi(get(handles.AddPlot2_DispX,'Checked'),'On')
    AddPlot_Dispersion_Callback(handles.AddPlot2_DispX, eventdata, handles);
end
if strcmpi(get(handles.AddPlot1_DispY,'Checked'),'On')
    AddPlot_Dispersion_Callback(handles.AddPlot1_DispY, eventdata, handles);
end
if strcmpi(get(handles.AddPlot2_DispY,'Checked'),'On')
    AddPlot_Dispersion_Callback(handles.AddPlot2_DispY, eventdata, handles);
end



% --------------------------------------------------------------------
function Graph1Line_Callback(hObject, eventdata, handles)
set(handles.Graph1Line,'Checked','On');
set(handles.Graph1Bar, 'Checked','Off');
cla(handles.Graph1);

% Update plot
OneShot_Callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function Graph1Bar_Callback(hObject, eventdata, handles)
set(handles.Graph1Line,'Checked','Off');
set(handles.Graph1Bar, 'Checked','On');
cla(handles.Graph1);

% Make sure the scale is linear for bar plots
set(handles.Graph1,'YScale','Linear');
set(handles.YScaleLog1,'Checked','Off');
set(handles.YScaleLinear1,'Checked','On');

% Update plot
OneShot_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function Graph2Line_Callback(hObject, eventdata, handles)
set(handles.Graph2Line,'Checked','On');
set(handles.Graph2Bar, 'Checked','Off');
cla(handles.Graph2);

% Update plot
OneShot_Callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function Graph2Bar_Callback(hObject, eventdata, handles)
set(handles.Graph2Line,'Checked','Off');
set(handles.Graph2Bar, 'Checked','On');
cla(handles.Graph2);

% Make sure the scale is linear for bar plots
set(handles.Graph2,'YScale','Linear');
set(handles.YScaleLog2,'Checked','Off');
set(handles.YScaleLinear2,'Checked','On');

% Update plot
OneShot_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function DisabledSetpointChanges_Callback(hObject, eventdata, handles)
if strcmpi(get(handles.DisabledSetpointChanges,'Checked'),'Off')
    set(handles.DisabledSetpointChanges,'Checked','On');
    TurnOffSetpointGUI_Callback(hObject, eventdata, handles);
else
    set(handles.DisabledSetpointChanges,'Checked','Off');
end


% --------------------------------------------------------------------
function TurnOffSetpointGUI_Callback(hObject, eventdata, handles)
% Turn off the setpoint GUI
if strcmpi(get(handles.SetpointEditBox,'Visible'),'On')
    set(handles.SetpointEditBox,   'Visible', 'Off');
    set(handles.SetpointFamily,    'Visible', 'Off');
    set(handles.SetpointUnits,     'Visible', 'Off');
    set(handles.SetpointSlider,    'Visible', 'Off');
    set(handles.SetpointMax,       'Visible', 'Off');
    set(handles.SetpointMin,       'Visible', 'Off');
    set(handles.SetpointFrame,     'Visible', 'Off');
    set(handles.SetpointStepSize,  'Visible', 'Off');
    set(handles.SetpointPushButton,'Visible', 'Off');

    % Change the save and file text back to full size
    p = get(handles.SaveTime, 'Position');
    set(handles.SaveTime, 'Position',  [p(1) p(2) p(3)/.353 p(4)]);
    p = get(handles.FileNameX, 'Position');
    set(handles.FileNameX, 'Position', [p(1) p(2) p(3)/.353 p(4)]);
    p = get(handles.FileNameY, 'Position');
    set(handles.FileNameY, 'Position', [p(1) p(2) p(3)/.353 p(4)]);

    drawnow;
end

