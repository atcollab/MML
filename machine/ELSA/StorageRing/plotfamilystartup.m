function plotfamilystartup(handles)
% plotfamilystartup(handles)


%Menu0 = handles.('LatticeConfiguration');
%MenuAdd = uimenu(Menu0, 'Label','Add an Injection Bump - bumpinj');
%set(MenuAdd,'Callback', 'bumpinj');
%set(MenuAdd, 'Separator','Off');




% Add a sector menu
Sectors = 2;
L = getfamilydata('Circumference');
if ~isempty(L)
    Menu0 = handles.figure1;
    Menu0 = uimenu(Menu0, 'Label','Sector');
    set(Menu0,'Position',3);
    set(Menu0, 'Separator','On');

    % Arc
    i = 1;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 L/2]),'],guidata(gcbo))']);
    
    i = 2;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[L/2 L]),'],guidata(gcbo))']);

end


drawnow;
