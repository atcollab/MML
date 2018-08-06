function plotfamilystartup(handles)
% plotfamilystartup(handles)
% TLSMenu=uimenu(handles.('figure1'), 'Label', 'Access Mode');
% 
% SubMenu = uimenu(TLSMenu, 'Label','Old Control System');
% set(SubMenu,'Callback', 'mode(1)');
% set(SubMenu, 'Separator','On');
% 
% SubMenu = uimenu(TLSMenu, 'Label','EPICS Control System');
% set(SubMenu,'Callback', 'mode(2)');
% set(SubMenu, 'Separator','On');

TLSMenu=uimenu(handles.('figure1'), 'Label', 'Applications');

SubMenu = uimenu(TLSMenu, 'Label','Orbit Control Interface');
set(SubMenu,'Callback', 'orbitgui_TLS');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','Beam Based Alignment');
set(SubMenu,'Callback', 'BBA');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','Beta Function Measurement');
set(SubMenu,'Callback', 'measbeta_tls');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','Dispersion Function Measurement');
set(SubMenu,'Callback', 'measdisp_tls');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','Chromaticity Measurement and Correction');
set(SubMenu,'Callback', 'measchro_tls');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','Tune Control');
set(SubMenu,'Callback', 'tune');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','Beam Steering Interface --- RESOLVE');
set(SubMenu,'Callback', 'FTG');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','Local Orbit Bump');
set(SubMenu,'Callback', 'Local_Bump');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','RF Frequency Optimization GUI');
set(SubMenu,'Callback', 'RF_OPT');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','RF Frequency Optimization GUI with Orbit Correction');
set(SubMenu,'Callback', 'RF_OC');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','Orbit Correction GUI ( MICADO Method )');
set(SubMenu,'Callback', 'micado');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','Orbit Correction GUI ( Simple Bound Constraints Optimization Method )');
set(SubMenu,'Callback', 'sbc');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','Lifetime Measurement GUI');
set(SubMenu,'Callback', 'measlifetime_tls');
set(SubMenu, 'Separator','On');

SubMenu = uimenu(TLSMenu, 'Label','Frequency Map Analysis GUI');
set(SubMenu,'Callback', 'FMA');
set(SubMenu, 'Separator','On');

Menu0 = handles.('LatticeConfiguration');

%MenuAdd = uimenu(Menu0, 'Label','Add an Injection Bump - bumpinj');
%set(MenuAdd,'Callback', 'bumpinj');
%set(MenuAdd, 'Separator','Off');

% Add a sector menu
% Using a [Arc Straight] nomenclature
Sectors = 6;
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
    Extra = 8;
    for i = 1:Sectors-1
        Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',i));
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[-Extra Extra]+i*L/Sectors),'],guidata(gcbo))']);
    end
    i = Sectors;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[L-Extra L]),'],guidata(gcbo))']);
end


drawnow;
