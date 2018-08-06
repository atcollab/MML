function plotfamilystartup(handles)
% plotfamilystartup(handles)


try

    %Menu0 = handles.('LatticeConfiguration');
    %MenuAdd = uimenu(Menu0, 'Label','Add an Injection Bump - bumpinj');
    %set(MenuAdd,'Callback', 'bumpinj');
    %set(MenuAdd, 'Separator','Off');
    

    % Add a sector menu
    Sectors = 30;

    Lshort = 6.6; % Length of short straight
    Llong  = 9.3; % Length of long straight

    L = getfamilydata('Circumference');
    LL = L/15;
    Larc = (L-15*Lshort-15*Llong)/30;
    
    Menu0 = handles.figure1;
    Menu0 = uimenu(Menu0, 'Label','Sector');
    set(Menu0,'Position',3);
    set(Menu0, 'Separator','On');

    % Arcs
    Margin = 5;
    for i = 1:15
        Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',2*i-1));
        if i == 1
            set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0        Larc+Margin]+(i-1)*LL),'],guidata(gcbo))']);
        else
            set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0-Margin Larc+Margin]+(i-1)*LL),'],guidata(gcbo))']);
        end

        Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',2*i));
        %if i == 15
        %    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0-Margin Larc       ]+(i-1)*LL+Larc+Lshort),'],guidata(gcbo))']);
        %else
            set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0-Margin Larc+Margin]+(i-1)*LL+Larc+Lshort),'],guidata(gcbo))']);
        %end
    end
    

    % Straight sections
    Margin = 7;
    for i = 1:15
        Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',2*i-1));
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[Larc-Margin Larc+Lshort+Margin]+(i-1)*LL),'],guidata(gcbo))']);

        Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',2*i));
        if i == 15
            Margin = 0;
        end
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[Larc-Margin Larc+Llong+Margin]+(i-1)*LL+Larc+Lshort),'],guidata(gcbo))']);
    end
    
    drawnow;


catch
end
