function plotfamilystartup(handles)
% plotfamilystartup(handles)



% Remove production/golden lattice
set(handles.LoadtheGoldenLattice,       'Visible', 'Off');
set(handles.SaveLatticetotheGoldenFile, 'Visible', 'Off');
set(handles.LoadtheInjectionLattice,       'Separator', 'On');
set(handles.SaveLatticetotheInjectionFile, 'Separator', 'On');

set(handles.StandardizetoGoldenLattice,             'Visible', 'Off');
set(handles.StandardizetoUserSelectableLatticeFile, 'Visible', 'Off');



% Add a sector menu
% Using a [Straight Arc] nomenclature
Sectors = 4;
L = getfamilydata('Circumference');
if ~isempty(L)
    Menu0 = handles.figure1;
    Menu0 = uimenu(Menu0, 'Label', 'Sector');
    set(Menu0, 'Position', 3);
    set(Menu0, 'Separator', 'On');

    Extra = 4;
    i = 1;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);

    i = 2;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[-Extra Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);

    i = 3;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[-Extra Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);

    i = 4;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[-Extra L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);

end



drawnow;
