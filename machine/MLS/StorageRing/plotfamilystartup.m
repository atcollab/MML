function plotfamilystartup(handles)
% plotfamilystartup(handles)


%Menu0 = handles.('LatticeConfiguration');
%MenuAdd = uimenu(Menu0, 'Label','Add a new function here!!!');
%set(MenuAdd,'Callback', 'NewFunctionName');
%set(MenuAdd, 'Separator','Off');


% Add a sector menu
Sectors = getnumberofsectors;
L = getfamilydata('Circumference');

if ~isempty(L)
    Menu0 = handles.figure1;
    Menu0 = uimenu(Menu0, 'Label', 'Sector');
    set(Menu0, 'Position', 3);
    set(Menu0, 'Separator', 'On');

    % Arc
    i = 1;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 L/4]),'],guidata(gcbo))']);
    
    i = 2;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[L/4 L/2]),'],guidata(gcbo))']);

    i = 3;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[L/2 3*L/4]),'],guidata(gcbo))']);

    i = 4;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[3*L/4 L]),'],guidata(gcbo))']);
end


drawnow;
