function mycallback_steerette_orbites(arg1,arg2,hObject, eventdata, handles)


handles.mode = getappdata(handles.figure1,'Mode');

BPMx = getappdata(handles.figure1,'BPMx');
BPMz = getappdata(handles.figure1,'BPMz');

% replot des orbites
h3     = get(handles.axes3,'Children');
hline2 = findobj(h3,'-regexp','Tag','line[1,2,3]');
h8     = get(handles.axes8,'Children');
hline8 = findobj(h8,'-regexp','Tag','line[8]');

if strcmp(handles.mode,'Model')

    % calcul nouvelles orbites
    X0 = getappdata(handles.figure1,'orbite_entry');
    nP = size(X0,2);
    BPMindex = family2atindex('BPMx');
    global THERING
    nbtour = 1;
    X01 = zeros(nbtour, 6, nP*length(BPMindex));

    for k=1:nbtour,
        X01(k,:,:) = linepass(THERING, X0, BPMindex);
        %X0 = X01(k,:,end)';
    end
    Xa = squeeze(X01(1,1,:));
    Za = squeeze(X01(1,3,:));
    if nP>1
        X = [];
        Z = [];
        for nBPM = 1:length(BPMindex)
            X = [X mean(Xa((nP*(nBPM-1)+1):nP*nBPM))];
            Z = [Z mean(Za((nP*(nBPM-1)+1):nP*nBPM))];
        end
        orbite_x = X'*1000;
        orbite_z = Z'*1000;
        orbite_sum = 1e6*(0.75 + 0.5*rand(length(BPMindex),1))';
    else
        orbite_x = Xa*1000;
        orbite_z = Za*1000;
        orbite_sum = 1e6*(0.75 + 0.5*rand(length(BPMindex),1))';
    end
    
    xdata = BPMx.Position;
    ydata = BPMz.Position;
    sdata = BPMx.Position;
    
else
        % test anneau
        %BPMx.DeviceList = [1     2;1     3;1     4;1     5;1     6]
        
        sleep(2); % test : attente de 2 seconde pour que les alims 
        % se mettent à leur valeurs et les BPM rafraichissent
        %[X Z Sum] = anabpmfirstturn( BPMx.DeviceList,'MaxSum','NoDisplay'); % ancienne version
        %

        if strcmp(handles.orbite,'transport - max Sum') % orbite à corriger type transport
            %[X] = anabpmfirstturn( BPMx.DeviceList );
            %[X] = anabpmfirstturn( liste_dev_BPM,'NoDisplay' ); % X en mm premier tour ANCIENNE VERSION
            nbturns = 1;
            [X Z Sum idx] = anabpmnfirstturns( BPMx.DeviceList,nbturns,'NoDisplay2'); % X en mm premier tour
            idx
            
        elseif strcmp(handles.orbite,'transport - tour fixe') % orbite à corriger type transport
            ifirstturn = str2num(get(handles.tour_fixe_T_edit,'String')); % numero du premier tour
            nbturns = 1;
            [X Z Sum] = anabpmnfirstturns( BPMx.DeviceList,nbturns,ifirstturn,'NoDisplay2','NoMaxSum'); % X en mm premier tour
            
        else
            % moyenne de l'orbite à corriger sur n tours
            ifirstturn = str2num(get(handles.tour_fixe_OF_edit,'String')); % numero du premier tour
            nturns = str2num(get(handles.Ntours_edit,'String'));
            [X Z Sum] = anabpmnfirstturns(BPMx.DeviceList,nturns,ifirstturn,'NoDisplay2','NoMaxSum');
            X = mean(X) ;% moyenne par BPM
            Z = mean(Z);
            Sum = mean(Sum);
            
        end

        orbite_x = X';
        orbite_z = Z';
        orbite_sum = Sum';

        xdata  = getspos('BPMx',BPMx.DeviceList);
        ydata  = getspos('BPMz',BPMz.DeviceList);
        sdata  = getspos('BPMx',BPMx.DeviceList);

end

setappdata(handles.figure1,'orbite_x',orbite_x);
setappdata(handles.figure1,'orbite_z',orbite_z);

% xdata = BPMx.Position;
% ydata = BPMz.Position;
% sdata = BPMx.Position;
% %xdata = 1:length(orbite_x);
% %ydata = 1:length(orbite_z);
% %sdata = 1:length(orbite_sum);


% linegraphes
set(hline2(3),'XData',xdata,'YData',orbite_x,'Visible','On');
set(hline2(2),'XData',ydata,'YData',orbite_z,'Visible','On');
set(hline8(1),'XData',sdata,'YData',orbite_sum,'Visible','On');