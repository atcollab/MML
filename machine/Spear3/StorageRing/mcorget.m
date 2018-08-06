function pv = mcorget(Family, DeviceList)
%  CorrParameters = mcorget(Family, DeviceList)
%
%  To plot results to the screen
%  CorrParameters = mcorget;

if nargin == 0
    % plot
    figure;
    Family = 'HCM';
    pv = mcorget(Family);
    %spos = getspos(Family);
    
    subplot(4,2,1)
    plot(pv(:,1),'.-b');
    hold on;
    i = find(pv(:,9)==1);
    plot(i,pv(i,9),'og');
    i = find(pv(:,9)==0);
    plot(i,pv(i,9),'or');
    axis tight
    ylabel('ControlState (1)');
    title(Family);
    
    subplot(4,2,3)
    plot(pv(:,2),'.-');
    axis tight
    ylabel('CurrScale (1)');
    
    subplot(4,2,5)
    plot(pv(:,3),'.-');
    axis tight
    ylabel('Curr1MuxADC.SCAN (7)');
    
    subplot(4,2,7)
    plot(pv(:,4),'.-');
    axis tight
    ylabel('Curr2MuxADC.SCAN (7)');
    xlabel('Corrector Number');
    
    subplot(4,2,2)
    plot(pv(:,5),'.-');
    axis tight
    ylabel('VoltMuxADC.SCAN (7)');
    title(Family);
    
    subplot(4,2,4)
    plot(pv(:,6),'.-');
    axis tight
    ylabel('Curr1MuxState (0)');
    
    subplot(4,2,6)
    plot(pv(:,7),'.-');
    axis tight
    ylabel('Curr2MuxState (0)');
    
    subplot(4,2,8)
    plot(pv(:,8),'.-');
    axis tight
    ylabel('VoltMuxState (3)');
    xlabel('Corrector Number');
    
    addlabel(0,0,'( ) = Value at reset');
    addlabel(1,0, datestr(clock));
    
    
    figure;
    Family = 'VCM';
    pv = mcorget(Family);
    %spos = getspos(Family);
    
    subplot(4,2,1)
    plot(pv(:,1),'.-');
    hold on;
    i = find(pv(:,9)==1);
    plot(i,pv(i,9),'og');
    i = find(pv(:,9)==0);
    plot(i,pv(i,9),'or');
    axis tight
    ylabel('ControlState (1)');
    title(Family);
    
    subplot(4,2,3)
    plot(pv(:,2),'.-');
    axis tight
    ylabel('CurrScale (1)');
    
    subplot(4,2,5)
    plot(pv(:,3),'.-');
    axis tight
    ylabel('Curr1MuxADC.SCAN (7)');
    
    subplot(4,2,7)
    plot(pv(:,4),'.-');
    axis tight
    ylabel('Curr2MuxADC.SCAN (7)');
    xlabel('Corrector Number');
    
    subplot(4,2,2)
    plot(pv(:,5),'.-');
    axis tight
    ylabel('VoltMuxADC.SCAN (7)');
    title(Family);
    
    subplot(4,2,4)
    plot(pv(:,6),'.-');
    axis tight
    ylabel('Curr1MuxState (0)');
    
    subplot(4,2,6)
    plot(pv(:,7),'.-');
    axis tight
    ylabel('Curr2MuxState (0)');
    
    subplot(4,2,8)
    plot(pv(:,8),'.-');
    axis tight
    ylabel('VoltMuxState (3)');
    xlabel('Corrector Number');
    
    addlabel(0,0,'( ) = Value at reset');
    addlabel(1,0, datestr(clock));
    
    return
end

if nargin < 2
    DeviceList = [];
end


% Setup channels
pv(:,1) = getpv(Family, 'ControlState', DeviceList);
pv(:,2) = getpv(Family, 'CurrScale', DeviceList);
pv(:,3) = getpv(Family, 'Curr1MuxADC.SCAN', DeviceList);
pv(:,4) = getpv(Family, 'Curr2MuxADC.SCAN', DeviceList);
pv(:,5) = getpv(Family, 'VoltMuxADC.SCAN', DeviceList);
pv(:,6) = getpv(Family, 'Curr1MuxState', DeviceList);
pv(:,7) = getpv(Family, 'Curr2MuxState', DeviceList);
pv(:,8) = getpv(Family, 'VoltMuxState', DeviceList);
pv(:,9) = getpv(Family, 'State', DeviceList);  % On/Off monitor




% %setPoints = [0:10:30 20:-10:-30 -20:10:0];
% setPoints = [0:10:20]
% lenSP = length(setPoints);
% curr1 = zeros( 1, lenSP );
% curr2 = zeros( 1, lenSP );
% volt = zeros( 1, lenSP );
% pauseTime = 1;
% pauseShort = 0.2;
% for ind = 1:lenSP,
%     [stat, ans] = system( ['caput ', mCorName, ':CurrSetpt -- ', ...
%         num2str(setPoints(ind)) ] );
%     if ( stat ~= 0 ),
%         fprintf( 1, ans );
%         error( 'could not set CurrSetpt' );
%     end % if ( stat ~= 0 ),
%     pause( pauseTime );
%     [stat, ans] = system( ['caget -w 5 ', mCorName, ':Curr1MuxADC -- '] ); 
%     if ( stat ~= 0 ),
%         fprintf( 1, ans );
%         error( 'could not read Curr1MuxADC' );
%     end % if ( stat ~= 0 ),
%     curr1(ind) = sscanf( ans, '%*s %f' );
%     pause( pauseShort );
%     [stat, ans] = system( ['caget -w 5 ', mCorName, ':Curr2MuxADC -- '] ); 
%     if ( stat ~= 0 ),
%         fprintf( 1, ans );
%         error( 'could not read Curr2MuxADC' );
%     end % if ( stat ~= 0 ),
%     curr2(ind) = sscanf( ans, '%*s %f' );
%     pause( pauseShort );
%     [stat, ans] = system( ['caget -w 5 ', mCorName, ':VoltMuxADC'] ); 
%     if ( stat ~= 0 ),
%         fprintf( 1, ans );
%         error( 'could not read VoltMuxADC' );
%     end % if ( stat ~= 0 ),
%     volt(ind) = sscanf( ans, '%*s %f' );
%     pause( pauseShort );
% end % for ind = 1:lenSP,
% 
% return
% 
% 
% % save data to file
% fId = fopen( [mCorName, '.txt'], 'wt' );
% if ( fId < 0 ),
%     error( ['unable to open ', mCorName, '.txt'] );
% end % if ( fp < 0 ),
% fprintf( fId, ['Corrector Test  ', mCorName, ' on ', date, '\n'] );
% fprintf( fId, '  setpoint    current1    current2    voltage\n' );
% for ind = 1:lenSP,
%     fprintf( fId, '%10.6f  %10.6f  %10.6f  %10.6f\n', ...
%         setPoints(ind), curr1(ind), curr2(ind), volt(ind) );
% end % for ind = 1:lenSP,
% fclose( fId );
% 
% % 01G-COR1H:Curr1MuxADCTbl
% % 01G-COR1H:Curr2MuxADCTbl
% % 01G-COR1H:VoltMuxADCTbl
% [stat, i1] = system( ['caget -w 5 ', mCorName, ':Curr1MuxADCTbl'] );
% i1Dat = sscanf( i1(25:end), '%f' );
% i1Dat = i1Dat(2:end);
% % [stat, i2] = system( 'caget "01G-COR1V:Imux2AdcRawTbl" ' );
% [stat, i2] = system( ['caget -w 5 ', mCorName, ':Curr2MuxADCTbl'] );
% i2Dat = sscanf( i2(25:end), '%f' );
% i2Dat = i2Dat(2:end);
% % [stat, v] = system( 'caget "01G-COR1V:VmuxAdcRawTbl" ' );
% [stat, v] = system( ['caget -w 5 ', mCorName, ':VoltMuxADCTbl'] );
% vDat = sscanf( v(24:end), '%f' );
% vDat = vDat(2:end);
% 
% ind = 1:200;
% t = ind/4;;
% figInd = 0;
% figInd=figInd+1; figure(figInd); clf;
% subplot(3,1,1)
% plot( t, i1Dat(ind) );
% ylabel( 'DAC counts' );
% title( [mCorName, '   Positive Current Shunt'] )
% subplot(3,1,2)
% plot( t, i2Dat(ind) );
% ylabel( 'DAC counts' );
% title( [mCorName, '   Negative Current Shunt'] )
% subplot(3,1,3)
% plot( t, vDat(ind) );
% ylabel( 'DAC counts' );
% title( [mCorName, '   Magnet Voltage'] )
% xlabel( 'time (ms)' );
% set( gcf, 'PaperPosition', [0.2500, 0.2500, 8.0000, 10.5000] );
% 
% print('-f1', '-depsc2', [mCorName, '.eps']);
% 
% return;