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
set(handles.StandardizetoGoldenLattice, 'Label', 'Standardize to Injection Lattice - ltbcycle(''Injection'')');
set(handles.StandardizetoGoldenLattice, 'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; ltbcycle(''Injection'',''Display''); catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred standardizing the LTB lattice''); end; set(gcbf,''HandleVisibility'',''Callback'');');

set(handles.StandardizetoUserSelectableLatticeFile, 'Label', 'Standardize to User Selectable Lattice File - ltbcycle('''')');
set(handles.StandardizetoUserSelectableLatticeFile, 'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; ltbcycle('''',''Display''); catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred standardizing the LTB lattice''); end; set(gcbf,''HandleVisibility'',''Callback'');');


% Add a section menu
try
catch
end