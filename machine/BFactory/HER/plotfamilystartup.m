function plotfamilystartup(handles)
% plotfamilystartup(handles)


%Menu0 = handles.('LatticeConfiguration');

%MenuAdd = uimenu(Menu0, 'Label','Add an Injection Bump - bumpinj');
%set(MenuAdd,'Callback', 'bumpinj');
%set(MenuAdd, 'Separator','Off');


% Add a sector menu
Sections = 25;
L = getfamilydata('Circumference');
try
    Menu0 = handles.figure1;
    Menu0 = uimenu(Menu0, 'Label', 'Section');
    set(Menu0, 'Position', 3);
    set(Menu0, 'Separator', 'On');

    for i = 1:Sections
        d = [0 L/Sections] + (i-1)*L/Sections;
        Menu1 = uimenu(Menu0, 'Label',sprintf('Section %7.1f to %7.1f meters',d));
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f', d),'],guidata(gcbo))']);
    end

    d = 688.5 + [0 89];
    Menu1 = uimenu(Menu0, 'Label',sprintf('IP %6.1f to %6.1f meters',d));
    set(Menu1, 'Separator', 'On');
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f', d),'],guidata(gcbo))']);
catch
end


drawnow;
