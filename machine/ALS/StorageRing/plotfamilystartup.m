function plotfamilystartup(handles)
% plotfamilystartup(handles)


%#function switch2bergoz switch2notbergoz switch2allbpms
%#function buildramptable setskewq setbumps bumpinj
%#function getrf_als setrf_als gettune_als
%#function measchicaneresp copychicanerespfile 


Menu0 = handles.('Initialization');

MenuAdd = uimenu(Menu0, 'Label','Use only Bergoz BPMs - switch2bergoz');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; switch2bergoz; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred setting the BPMs to Bergoz only.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(MenuAdd, 'Separator','On');

MenuAdd = uimenu(Menu0, 'Label','Use only the new (Not Bergoz) BPMs - switch2notbergoz');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; switch2notbergoz; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred setting the BPMs to Not-Bergoz BPMs.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(MenuAdd, 'Separator','Off');

MenuAdd = uimenu(Menu0, 'Label','Use all BPMs - switch2allbpms');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; switch2allbpms; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred setting the BPMs to all BPMs.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(MenuAdd, 'Separator','Off');

%MenuAdd = uimenu(Menu0, 'Label','Main Storage Ring Control Program - srcontrol');
%set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; srcontrol; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred starting srcontrol.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
%set(MenuAdd, 'Separator','On');



Menu0 = handles.LatticeConfiguration;

MenuAdd = uimenu(Menu0, 'Label','Create New Ramp Tables - buildramptable');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; buildramptable; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred building the ramp table.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
%set(MenuAdd,'Callback', 'buildramptable');
set(MenuAdd, 'Separator','On');


% Remove hardware units tabs for chromaticity so people at the ALS don't confuse themselves
set(handles.SteptheChromaticityHW, 'Visible', 'Off');
set(handles.SettheChromaticityHW,  'Visible', 'Off');
set(handles.ChromaticityHW,        'Visible', 'Off');
set(handles.DispersionPhysicsMCF,  'Visible', 'Off');


Menu0 = handles.('CorrecttheOrbit');

MenuAdd = uimenu(Menu0, 'Label','Set the RF frequency - findrf2  (Old method based on sum of the HCM(3,4,5,6))');
set(MenuAdd,'Callback', ['set(gcbf,''HandleVisibility'',''off''); try; findrf2; catch; fprintf(''%s\n'',lasterr); disp(''   An error occured during findrf.'');fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); end; set(gcbf,''HandleVisibility'',''Callback'');']);
set(MenuAdd, 'Separator','Off');
set(MenuAdd,'Position',11);

% MenuAdd = uimenu(Menu0, 'Label','Set the RF frequency - rmdisp(''SetRF'')');
% set(MenuAdd,'Callback', ['set(gcbf,''HandleVisibility'',''off''); try; rmdisp(''SetRF''); catch; fprintf(''%s\n'',lasterr); disp(''   An error occured during findrf.'');fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); end; set(gcbf,''HandleVisibility'',''Callback'');']);
% set(MenuAdd, 'Separator','Off');


MenuAdd = uimenu(Menu0, 'Label','Set User Bumps - setbumps');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; setbumps; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred setting the user bumps.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(MenuAdd, 'Separator','On');

MenuAdd = uimenu(Menu0, 'Label','Add an Injection Bump - bumpinj');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; bumpinj; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred setting the injection bump.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(MenuAdd, 'Separator','On');


MenuAdd = uimenu(Menu0, 'Label','Check the BPMs by generating 3 columns of the response matrix  - checkbpms');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; checkbpms; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred running checkbpms.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(MenuAdd, 'Separator','On');


% Menu0 = handles.('LOCOMenu');
% 
% MenuAdd = uimenu(Menu0, 'Label','Add an Dispersion Wave - setlocodata(''EtaWave'')');
% set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; setlocodata(''EtaWave''); catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred applying the Eta Wave.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
% set(MenuAdd, 'Separator','Off');


Menu0 = handles.('MeasureMenu');

MenuAdd = uimenu(Menu0, 'Label','Chicane to BPM Response Matrix - measchicaneresp');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; measchicaneresp; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred measuring the chicane magnet the BPM response matrix.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(MenuAdd,'Position',11);
set(MenuAdd, 'Separator','Off');

MenuAdd = uimenu(Menu0, 'Label','ID Feed Forward Table - ffgettbl');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; ffgettbl; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred measuring a feed forward table.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(MenuAdd, 'Separator','On');

MenuAdd = uimenu(Menu0, 'Label','EPU Feed Forward Table - ffgettblepugap');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; ffgettblepugap; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred measuring an EPU feed forward table.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(MenuAdd, 'Separator','Off');



Menu0 = handles.NewOperationalFilesMenu;

MenuAdd = uimenu(Menu0, 'Label','9. Copy New Chicane Response Matrix to the Golden - copychicanerespfile');
set(MenuAdd,'Callback', 'set(gcbf,''HandleVisibility'',''off''); try; copychicanerespfile; catch; fprintf(''%s\n'',lasterr); set(gcbf,''HandleVisibility'',''Callback''); disp(''   An error occurred in copychicanerespfile.''); end; set(gcbf,''HandleVisibility'',''Callback'');');
set(MenuAdd, 'Separator','On');


% Add a sector menu
% Using a [Straight Arc] nomenclature
Sectors = 12;
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
    for i = 2:Sectors-1
        Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0-Extra Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    end
    i = Sectors;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[L-L/Sectors-Extra L]),'],guidata(gcbo))']);

    Extra = 11;
    i = 1;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 Extra]),'],guidata(gcbo))']);
    for i = 2:Sectors
        Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',i));
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[-Extra Extra]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    end
end



drawnow;



% try
%     % Add callback on each lattice element
%     % set(h ,'ButtonDownFcn','plotfamily(''Lattice_ButtonDown'',gcbo,[],guidata(gcbo))');
%     h = get(handles.LatticeAxes,'Children');
%     for i = 1:length(h)
%         %ATIndex = get(h(i), 'UserData');
%         set(h(i), 'ButtonDownFcn', 'plotfamily(''Lattice_ButtonDown'',gcbo,[],guidata(gcbo))');
%     end
% catch
% end



