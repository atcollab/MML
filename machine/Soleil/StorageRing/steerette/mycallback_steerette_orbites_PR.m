function mycallback_steerette_orbites_PR(arg1,arg2,hObject, eventdata, handles)


handles.mode = getappdata(handles.figure1,'Mode');
handles.orbite = getappdata(handles.figure1,'Orbite');

BPMx = getappdata(handles.figure1,'BPMx');
BPMz = getappdata(handles.figure1,'BPMz');
BPMxDeviceListPR = getappdata(handles.figure1,'BPMxDeviceListPR');

% replot des orbites
h11     = get(handles.axes11,'Children');
hline11 = findobj(h11,'-regexp','Tag','line[1,2]');
h13     = get(handles.axes13,'Children');
hline13 = findobj(h13,'-regexp','Tag','line[1,2,3,4]');

if strcmp(handles.orbite,'orbite fermée')
    errordlg('changer le mode orbite en "transport" !','Attention');
    return
else
    if strcmp(handles.mode,'Model')
        errordlg('changer le mode en "online" !','Attention');
        return
    else
        % test anneau
        %BPMx.DeviceList = [1     2;1     3;1     4;1     5;1     6]
        %[X Y Sum] = anabpmnfirstturns(BPMxDeviceListPR,2,'NoDisplay2');   % 2 tours ancienne version
        sleep(2); % test : attente de 2 seconde 
        if strcmp(handles.orbite,'transport - max Sum') % orbite à corriger type transport
            %[X] = anabpmfirstturn( BPMx.DeviceList );
            %[X] = anabpmfirstturn( liste_dev_BPM,'NoDisplay' ); % X en mm premier tour ANCIENNE VERSION
            nbturns = 2;
            [X Y Sum idx] = anabpmnfirstturns( BPMxDeviceListPR,nbturns,'NoDisplay2'); % X en mm premier tour
            idx
            
        else strcmp(handles.orbite,'transport - tour fixe') % orbite à corriger type transport
            ifirstturn = str2num(get(handles.tour_fixe_T_edit,'String')); % numero du premier tour
            nbturns = 2;
            [X Y Sum] = anabpmnfirstturns( BPMxDeviceListPR,nbturns,ifirstturn,'NoDisplay2','NoMaxSum'); % X en mm premier tour
            
        end
        
        %
        orbite_x_1 = X(1,:)';
        orbite_z_1 = Y(1,:)';
        orbite_sum_1 = Sum(1,:)';

        orbite_x_2 = X(2,:)';
        orbite_z_2 = Y(2,:)';
        orbite_sum_2 = Sum(2,:)';

        xdata  = getspos('BPMx',BPMxDeviceListPR);
        ydata  = getspos('BPMz',BPMxDeviceListPR);
        sdata  = getspos('BPMx',BPMxDeviceListPR);

    end

    %setappdata(handles.figure1,'orbite_x',orbite_x);
    %setappdata(handles.figure1,'orbite_z',orbite_z);

    % xdata = BPMx.Position;
    % ydata = BPMz.Position;
    % sdata = BPMx.Position;
    % %xdata = 1:length(orbite_x);
    % %ydata = 1:length(orbite_z);
    % %sdata = 1:length(orbite_sum);

    % linegraphes
    set(hline11(2),'XData',xdata,'YData',orbite_sum_1,'Visible','On');
    set(hline11(1),'XData',xdata,'YData',orbite_sum_2,'Visible','On');
    set(hline13(4),'XData',xdata,'YData',orbite_x_1,'Visible','On');
    set(hline13(3),'XData',xdata,'YData',orbite_x_2,'Visible','On');
    set(hline13(2),'XData',xdata,'YData',orbite_z_1,'Visible','On');
    set(hline13(1),'XData',xdata,'YData',orbite_z_2,'Visible','On');
end