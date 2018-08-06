function plotfamilystartup(handles)
% plotfamilystartup(handles)


global THERING


% Remove injection lattice
% set(handles.LoadtheInjectionLattice, 'Visible', 'Off');
% set(handles.SaveLatticetotheInjectionFile, 'Visible', 'Off');

% Remove production/golden lattice
set(handles.LoadtheGoldenLattice,       'Visible', 'Off');
set(handles.SaveLatticetotheGoldenFile, 'Visible', 'Off');
set(handles.LoadtheInjectionLattice,       'Separator', 'On');
set(handles.SaveLatticetotheInjectionFile, 'Separator', 'On');

% Change cycle to injection lattice
set(handles.StandardizetoGoldenLattice, 'Label', 'Standardize to Injection Lattice - gtbcycle(''Injection'')');
set(handles.StandardizetoGoldenLattice, 'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; gtbcycle(''Injection'',''Display''); catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred standardizing the GTB lattice''); end; set(gcbf,''HandleVisibility'',''Callback'');');

set(handles.StandardizetoUserSelectableLatticeFile, 'Label', 'Standardize to User Selectable Lattice File - gtbcycle('''')');
set(handles.StandardizetoUserSelectableLatticeFile, 'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; gtbcycle('''',''Display''); catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred standardizing the GTB lattice''); end; set(gcbf,''HandleVisibility'',''Callback'');');


% Add a section menu
try
    Menu0 = handles.figure1;
    Menu0 = uimenu(Menu0, 'Label', 'Section');
    set(Menu0, 'Position', 3);
    set(Menu0, 'Separator', 'On');

    Lsi = findcells(THERING, 'FamName', 'START');
    Lei = findcells(THERING, 'FamName', 'END');

    Lstart = findspos(THERING, Lsi)';
    Lend = findspos(THERING, Lei)';


    Menu1 = uimenu(Menu0, 'Label', 'GUN');
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',Lstart(1), Lend(1)),'],guidata(gcbo))']);

    Menu1 = uimenu(Menu0, 'Label', 'LINAC');
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',Lstart(2), Lend(2)),'],guidata(gcbo))']);

    Menu1 = uimenu(Menu0, 'Label', 'LTB');
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',Lstart(3), Lend(3)),'],guidata(gcbo))']);
catch
end