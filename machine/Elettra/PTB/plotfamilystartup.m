function plotfamilystartup(handles)
% plotfamilystartup(handles)


Menu0 = handles.('LatticeConfiguration');

% Remove production/golden lattice since this is for injection only
set(handles.LoadtheGoldenLattice,       'Visible', 'Off');
set(handles.SaveLatticetotheGoldenFile, 'Visible', 'Off');
set(handles.LoadtheInjectionLattice,       'Separator', 'On');
set(handles.SaveLatticetotheInjectionFile, 'Separator', 'On');

% Change cycle to injection lattice
set(handles.StandardizetoGoldenLattice, 'Label', 'Standardize to Injection Lattice - gtbcycle(''Injection'')');
set(handles.StandardizetoGoldenLattice, 'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; gtbcycle(''Injection'',''Display''); catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred standardizing the GTB lattice''); end; set(gcbf,''HandleVisibility'',''Callback'');');

set(handles.StandardizetoUserSelectableLatticeFile, 'Label', 'Standardize to User Selectable Lattice File - gtbcycle('''')');
set(handles.StandardizetoUserSelectableLatticeFile, 'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; gtbcycle('''',''Display''); catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred standardizing the GTB lattice''); end; set(gcbf,''HandleVisibility'',''Callback'');');


% Add a menu
Menu0 = handles.figure1;
Menu0 = uimenu(Menu0, 'Label', 'Section');
set(Menu0, 'Position', 3);
set(Menu0, 'Separator', 'On');

L = getfamilydata('Circumference');

Menu1 = uimenu(Menu0, 'Label', 'P');
set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 11.6690]),'],guidata(gcbo))']);

Menu1 = uimenu(Menu0, 'Label', 'PTB');
set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[11.6690 L]),'],guidata(gcbo))']);


drawnow;
