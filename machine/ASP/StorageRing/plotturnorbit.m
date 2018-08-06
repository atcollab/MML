function [varargout] = plotturnorbit(turns)

if ~exist('turns','var')
    disp('Error using plotturnoribt usage is: plotturnoribt(turns)');
    return
end

period = 1/1387927.777;

ind = find(getfamilydata('BPMx','Status'));
deviceList = getfamilydata('BPMx','DeviceList');
spos = getfamilydata('BPMx','Position');

% wflength = 6663;
% 
% % Set length of the waveform
% setlibera('TT_CAPLEN_S_SP',wflength,deviceList(ind,:));
% setlibera('TT_LENGTH_S_SP',wflength,deviceList(ind,:));
%
% setlibera('TT_READY_STATUS',0,deviceList(ind,:));
% setlibera('TT_ARM_CMD',1,deviceList(ind,:));

finished_num = getlibera('DD3_FINISHED_MONITOR',deviceList);
setlibera('DD3_ON_NEXT_TRIG_CMD',1,deviceList);
pause(1);

ii = 0;
while any(getlibera('DD3_FINISHED_MONITOR',deviceList) == finished_num)
    pause(0.3);
    ii = ii + 1;
    if ii > 20
        disp('Some bpms did not change ready status for TBT');
        return
    end
end

if strcmpi(getunits('BPMx'),'Physics')
    units_conversion = 1e-9; % in meters
    unitsstr = 'm';
else
    units_conversion = 1e-6; % hardware in mm
    unitsstr = 'mm';
end

for i=1:length(ind)
    % Try to avoid memory problems
    tbtsum(i,:) = getlibera('DD3_SUM_MONITOR',deviceList(ind(i),:));
    tbtx(i,:) = getlibera('DD3_X_MONITOR',deviceList(ind(i),:))*units_conversion;
    tbty(i,:) = getlibera('DD3_Y_MONITOR',deviceList(ind(i),:))*units_conversion;
end


for i=1:length(ind)
    switch deviceList(ind(i),1)
        case [5 6 7 8 9 10 11 13 14]
            tbtsum(i,:) = circshift(tbtsum(i,:),[0 -1]);
            tbtx(i,:) = circshift(tbtx(i,:),[0 -1]);
            tbty(i,:) = circshift(tbty(i,:),[0 -1]);
        case 12
            tbtsum(i,:) = circshift(tbtsum(i,:),[0 -2]);
            tbtx(i,:) = circshift(tbtx(i,:),[0 -2]);
            tbty(i,:) = circshift(tbty(i,:),[0 -2]);
    end 
end

turnsind = turns;
closedorbitx = mean(tbtx(:,turnsind),2);
closedorbity = mean(tbty(:,turnsind),2);

if length(turns) > 10
    circumference = 2.159946602239996e+02;
    ds = circumference/98;
    nturns = length(turns);
    
    catxturn = reshape(tbtx(:,turnsind),nturns*length(ind),1);
    catyturn = reshape(tbty(:,turnsind),nturns*length(ind),1);
    
    spos = getfamilydata('BPMx','Position');
    catspos = [];
    catclosedorbitx = [];
    catclosedorbity = [];
    for i=1:length(turnsind)
        catclosedorbitx = [catclosedorbitx; closedorbitx];
        catclosedorbity = [catclosedorbity; closedorbity];
        catspos = [catspos; spos(ind)+(i-1)*circumference];
    end
    spos_even = [ds:ds:ds*98*nturns];
    
    interp_xpos = interp1(catspos,catxturn,spos_even,'pchip','extrap');
    interp_ypos = interp1(catspos,catyturn,spos_even,'pchip','extrap');
    
    interp_closedxpos = interp1(catspos,catclosedorbitx,spos_even,'pchip','extrap');
    interp_closedypos = interp1(catspos,catclosedorbity,spos_even,'pchip','extrap');

    interp_xpos = interp_xpos - interp_closedxpos;
    interp_ypos = interp_ypos - interp_closedypos;
    
    % Tune measurement stuff
    npoints = 2^(floor(log2(98*length(turns))));
    figure;
    subplot(2,1,1);
    YY = fft(interp_xpos(1:npoints));
    Pyy = YY.*conj(YY)/npoints;
    f = 98*[0:npoints/2]/npoints;
    plot(f,Pyy(1:npoints/2+1))
    [temp xtuneind] = max(Pyy(3:npoints/2+1));
    xtuneind = xtuneind + 2;
    xtune = f(xtuneind);

    subplot(2,1,2);
    YY = fft(interp_ypos(1:npoints));
    Pyy = YY.*conj(YY)/npoints;
    f = 98*[0:npoints/2]/npoints;
    plot(f,Pyy(1:npoints/2+1))
    [temp ytuneind] = max(Pyy(3:npoints/2+1));
    ytuneind = ytuneind + 2;
    ytune = f(ytuneind);

else
    xtune = NaN;
    ytune = NaN;
end

hh=figure('Position',[0 500 1500 500]);
subplot(2,1,1);
plot(spos(ind),tbtx(:,turnsind));
hold on;
plot(spos(ind),closedorbitx,'b','LineWidth',2);
hold off;
title(sprintf('Horizontal Tune = %5.2f',xtune));
ylabel(sprintf('X pos (%s)',unitsstr));
axis tight;
subplot(2,1,2);
plot(spos(ind),tbty(:,turnsind));
hold on;
plot(spos(ind),closedorbity,'b','LineWidth',2);
hold off;
title(sprintf('Vertical Tune = %5.2f',ytune));
ylabel(sprintf('Y pos (%s)',unitsstr));
xlabel('s (m)');
axis tight;

% plotelementsat;


% hh=figure('Position',[0 500 1500 500]);
% subplot(2,1,1);
% plot(spos(ind),tbtx(:,turnsind)-repmat(closedorbitx,1,length(turnsind)));
% hold on;
% plot(spos(ind),closedorbitx,'b','LineWidth',2);
% hold off;
% title(sprintf('Horizontal Tune = %5.2f',xtune));
% ylabel(sprintf('X pos (%s)',unitsstr));
% axis tight;
% subplot(2,1,2);
% plot(spos(ind),tbty(:,turnsind)-repmat(closedorbity,1,length(turnsind)));
% hold on;
% plot(spos(ind),closedorbity,'b','LineWidth',2);
% hold off;
% title(sprintf('Vertical Tune = %5.2f',ytune));
% ylabel(sprintf('Y pos (%s)',unitsstr));
% xlabel('s (m)');
% axis tight;


% if nargout > 0
%     varargout{1} = [closedorbitx closedorbity];
% end
% if nargout > 1
%     varargout{2} = tbtx(:,turnsind);
%     varargout{3} = tbty(:,turnsind);
%     varargout{4} = spos(ind);
% end

if nargout > 0
    varargout{1} = tbtx(:,turnsind);
end

clear tbtsum tbtx tbty;