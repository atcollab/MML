function plotfamilystartup(handles)
% plotfamilystartup(handles)

%SPEAR3 Tasks
SPEAR3Menu=uimenu(handles.('figure1'), 'Label', 'SPEAR3 Tasks');

%SPEAR LATTICE
MenuItem=uimenu(SPEAR3Menu, 'Label','SPEAR LATTICE');

%Operational Mode
SubMenu = uimenu(MenuItem, 'Label','Select Operational Mode - setoperationalmode');
set(SubMenu,'Callback', 'setoperationalmode'); 
SubMenu = uimenu(MenuItem, 'Label','Select Operational Mode and Update EPICS Index - setoperationalmode');
set(SubMenu,'Callback', 'OperationalMode2EPICSIndex'); 
%Standardize Lattice
SubMenu = uimenu(MenuItem, 'Label','STDZ SPEAR to Golden - srcycle(''Golden'')');
set(SubMenu,'Callback', 'srcycle(''Golden'')');  
set(SubMenu, 'Separator','On');
SubMenu = uimenu(MenuItem, 'Label','STDZ SPEAR to current LATVALS - srcycle(''desired'')');
set(SubMenu,'Callback', 'srcycle(''Desired'')');
SubMenu = uimenu(MenuItem, 'Label','STDZ SPEAR to current SETPOINTS - srcycle');
set(SubMenu,'Callback', 'srcycle');                 %no input triggers use of setpoints
SubMenu = uimenu(MenuItem, 'Label','STDZ SPEAR to... (browse for lattice) - srcycle('''')');
set(SubMenu,'Callback', 'srcycle('''')');           %[] input triggers use of browser

%Load New Lattice
SubMenu = uimenu(MenuItem,  'Label','Get SPEAR lattice & load to LATVAL - setdesired('''')');
set(SubMenu,'Callback', 'setdesired('''')');        %[] input triggers use of browser
set(SubMenu, 'Separator','On');
SubMenu = uimenu(MenuItem,  'Label','Get SPEAR lattice & load to SETPOINTS - setmachineconfig');
set(SubMenu,'Callback', 'setmachineconfig');        %no input triggers use of setpoints
SubMenu = uimenu(MenuItem,  'Label','Save new SPEAR lattice - getmachineconfig(''Archive'','''')');
set(SubMenu,'Callback', 'getmachineconfig(''Archive'','''')');  %[] input triggers use of browser
set(SubMenu, 'Separator','On');

%BTS
MenuItem=uimenu(SPEAR3Menu, 'Label','BTS Lattice');
SubMenu = uimenu(MenuItem, 'Label','STDZ BTS to... (browse for lattice) - btscycle('''')');
set(SubMenu, 'Enable','Off');

set(SubMenu,'Callback', 'btscycle('''')');
SubMenu = uimenu(MenuItem, 'Label','STDZ BTS to current LATVALS - btscycle(''Desired'')');
set(SubMenu, 'Enable','Off');

set(SubMenu,'Callback', 'btscycle(''Desired'')');
SubMenu = uimenu(MenuItem, 'Label','STDZ BTS to current SETPOINTS - btscycle');
set(SubMenu,'Callback', 'btscycle');
set(SubMenu, 'Enable','Off');

SubMenu = uimenu(MenuItem, 'Label','Get BTS lattice & load to LATVAL - setbtsdes');
set(SubMenu,'Callback', 'setbtsdes');
set(SubMenu, 'Separator','On');
SubMenu = uimenu(MenuItem, 'Label','Get BTS lattice & load to SETPOINTS - setbtsconfig');
set(SubMenu,'Callback', 'setbtsconfig');
SubMenu = uimenu(MenuItem,  'Label','Save new BTS lattice');
set(SubMenu,'Callback', 'savebts');
set(SubMenu, 'Separator','On');


%SOFB
SubMenu = uimenu(SPEAR3Menu, 'Label','SOFB - sofbgui');
set(SubMenu,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; sofbgui; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred launching sofbgui.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(SubMenu, 'Separator','On');

%Monica
% SubMenu = uimenu(SPEAR3Menu, 'Label','Get Monica');
% %set(SubMenu5,'Callback', 'h = figure; try; img=imread(''Monica-Lewinsky'',''jpeg''); imagesc(img); catch');
% set(SubMenu,'Callback', 'h = figure; img=imread(''Monica-Lewinsky'',''jpeg''); imagesc(img); set(h,''Position'',[360   435   362   489])');
% set(SubMenu, 'Separator','On');


% Chicane response matrix
Menu0 = handles.('MeasureMenu');
MenuAdd = uimenu(Menu0, 'Label','Chicane to BPM Response Matrix - measchicanerespmat');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; measchicanerespmat; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred measuring the chicane magnet response.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(MenuAdd,'Position',11);
set(MenuAdd, 'Separator','Off');

Menu0 = handles.('NewOperationalFilesMenu');

MenuAdd = uimenu(Menu0, 'Label','9. Copy New Chicane Response Matrix to the Golden - copychicanerespfile');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; copychicanerespfile; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred in copychicanerespfile.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(MenuAdd, 'Separator','On');


% Add a sector menu
Sectors = 18;
L = getfamilydata('Circumference');
if ~isempty(L)
    Menu0 = handles.figure1;
    Menu0 = uimenu(Menu0, 'Label', 'Sector');
    set(Menu0, 'Position', 3);
    set(Menu0, 'Separator', 'On');

    % Arc sector
    Extra = 4;
    i = 1;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    for i = 2:Sectors-1
        Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0-Extra Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    end
    i = Sectors;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[L-L/Sectors-Extra L]),'],guidata(gcbo))']);

    % Straight section
    Extra = 11;
    i = 1;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 Extra]),'],guidata(gcbo))']);
    for i = 2:Sectors
        Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',i));
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[-Extra Extra]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    end
end



