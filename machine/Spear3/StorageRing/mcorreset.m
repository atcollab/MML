function mcorreset(Family, DeviceList)
%  Reset a family/devicelist
%  mcorreset(Family, DeviceList)
%
%  Reset all the correctors
%  mcorreset

if nargin == 0
    % Reset all correctors
    
    % Set to zero
    setsp('HCM',0);
    setsp('VCM',0);
    
    setpv('HCM','ControlState', 1);
    setpv('VCM','ControlState', 1);
    
    setpv('HCM','CurrScale', 1);
    setpv('VCM','CurrScale', 1);
    
    setpv('HCM','Curr1MuxADC.SCAN', 7);
    setpv('VCM','Curr1MuxADC.SCAN', 7);
    
    setpv('HCM','Curr2MuxADC.SCAN', 7);
    setpv('VCM','Curr2MuxADC.SCAN', 7);
    
    setpv('HCM','VoltMuxADC.SCAN', 7);
    setpv('VCM','VoltMuxADC.SCAN', 7);
    
    setpv('HCM','Curr1MuxState', 0);
    setpv('VCM','Curr1MuxState', 0);
    
    setpv('HCM','Curr2MuxState', 0);
    setpv('VCM','Curr2MuxState', 0);
    
    setpv('HCM','VoltMuxState', 3);
    setpv('VCM','VoltMuxState', 3);

    return
end

if nargin < 2
    DeviceList = [];
end

% Set to zero
sp = getsp(Family, DeviceList);
setsp(Family, 0, DeviceList, 0);

% Reset
setpv(Family,'ControlState', 1, DeviceList);
setpv(Family,'CurrScale', 1, DeviceList);
setpv(Family,'Curr1MuxADC.SCAN', 7, DeviceList);
setpv(Family,'Curr2MuxADC.SCAN', 7, DeviceList);
setpv(Family,'VoltMuxADC.SCAN', 7, DeviceList);
setpv(Family,'Curr1MuxState', 0, DeviceList);
setpv(Family,'Curr2MuxState', 0, DeviceList);
setpv(Family,'VoltMuxState', 3, DeviceList);

% Restore setpoint
sp = setsp(Family, sp, DeviceList, 0);




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