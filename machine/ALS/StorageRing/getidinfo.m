function [FFEnableBM, FFEnableBC, GapEnableBM, GapEnableBC, Sector] = getidinfo(Sector)
% function [FFEnableBM, FFEnableBC, GapEnableBM, GapEnableBC, Sector] = getidinfo(Sector)
%

if nargin == 0
	Sector = getlist('IDpos');
end


for i = 1:length(Sector)
   if Sector(i)==5
      % CMM Channels
      [GapMonitor(i,1), GapVelocityMonitor(i,1), GapMoveCount(i,1)] = getid(Sector(i));
      
      ChanName = getname('IDpos', Sector(i), 1);
      GapSetPoint(i,1) = getam(ChanName);
      
      ChanName = sprintf('SR%02dW___GDS1PS_BC00', Sector(i));
      GapDisabledFlag(i,1) = getam(ChanName);
      
      ChanName = sprintf('SR%02dW___GDS1V__AC01', Sector(i));
      GapVelocitySetPoint(i,1) = getam(ChanName);
      
      ChanName = sprintf('SR%02dW___GDS1V__BC01', Sector(i));
      GapReset(i,1) = getam(ChanName);
      
      ChanName = sprintf('SR%02dW___GDS1V__BM02', Sector(i));
      GapLimitFlag(i,1) = getam(ChanName);
      
      ChanName = sprintf('SR%02dW___GDS1E__BC02', Sector(i));
      GapVelocityProfile(i,1) = getam(ChanName);
      
      ChanName = sprintf('SR%02dW___GDS1PS_BC00', Sector(i));
      GapDriveDisable(i,1) = getam(ChanName);
      
      % EPICs Only Channels
      ChanName = sprintf('sr%02dw:FFEnable:bo', Sector(i));
      FFEnableBC(i,1) = getam(ChanName);
      
      ChanName = sprintf('sr%02dw:FFEnable:bi', Sector(i));
      FFEnableBM(i,1) = getam(ChanName);
      
      ChanName = sprintf('cmm:ID%d_opr_grant', Sector(i));
      %ChanName = sprintf('sr%02du:GapEnable:bo', Sector(i));
      GapEnableBC(i,1) = getam(ChanName);
      
      ChanName = sprintf('sr%02dw:GapEnable:bi', Sector(i));
      GapEnableBM(i,1) = getam(ChanName);
      
      ChanName = sprintf('cmm:ID%d_bl_input', Sector(i));
      UserGap(i,1) = getam(ChanName);
      
      ChanName = sprintf('sr%02dw:FFActiveCnt:ai', Sector(i));
      FFActiveCount(i,1) = getam(ChanName);
      
      ChanName = sprintf('sr%02dw:FFError:ai', Sector(i));
      FFError(i,1) = getam(ChanName);
      
      ChanName = sprintf('sr%02dw:FFRead:bo', Sector(i));
      FFTableRead(i,1) = getam(ChanName); 
   else
      % CMM Channels
      [GapMonitor(i,1), GapVelocityMonitor(i,1), GapMoveCount(i,1)] = getid(Sector(i));
      
      ChanName = getname('IDpos', Sector(i), 1);
      GapSetPoint(i,1) = getam(ChanName);
      
      ChanName = sprintf('SR%02dU___GDS1V__AC01', Sector(i));
      GapVelocitySetPoint(i,1) = getam(ChanName);
      
      ChanName = sprintf('SR%02dU___GDS1PS_BC00', Sector(i));
      GapDisabledFlag(i,1) = getam(ChanName);
            
      ChanName = sprintf('SR%02dU___GDS1V__BC01', Sector(i));
      GapReset(i,1) = getam(ChanName);
      
      ChanName = sprintf('SR%02dU___GDS1V__BM02', Sector(i));
      GapLimitFlag(i,1) = getam(ChanName);
      
      ChanName = sprintf('SR%02dU___GDS1E__BC02', Sector(i));
      GapVelocityProfile(i,1) = getam(ChanName);
      
      ChanName = sprintf('SR%02dU___GDS1PS_BC00', Sector(i));
      GapDriveDisable(i,1) = getam(ChanName);

      % EPICs Only Channels
      ChanName = sprintf('sr%02du:FFEnable:bo', Sector(i));
      FFEnableBC(i,1) = getam(ChanName);
      
      ChanName = sprintf('sr%02du:FFEnable:bi', Sector(i));
      FFEnableBM(i,1) = getam(ChanName);
      
      ChanName = sprintf('cmm:ID%d_opr_grant', Sector(i));
      %ChanName = sprintf('sr%02du:GapEnable:bo', Sector(i));
      GapEnableBC(i,1) = getam(ChanName);
      
      ChanName = sprintf('sr%02du:GapEnable:bi', Sector(i));
      GapEnableBM(i,1) = getam(ChanName);
      
      ChanName = sprintf('cmm:ID%d_bl_input', Sector(i));
      UserGap(i,1) = getam(ChanName);
      
      ChanName = sprintf('sr%02du:FFActiveCnt:ai', Sector(i));
      FFActiveCount(i,1) = getam(ChanName);
      
      ChanName = sprintf('sr%02du:FFError:ai', Sector(i));
      FFError(i,1) = getam(ChanName);
      
      ChanName = sprintf('sr%02du:FFRead:bo', Sector(i));
      FFTableRead(i,1) = getam(ChanName);
   end
end


if nargout == 0
   for i = 1:length(Sector)
      fprintf('  Sector %d\n', Sector(i));
      fprintf('  Gap Setpoint = %7.4f [mm]\n', GapSetPoint(i));
      fprintf('  Gap Monitor  = %7.4f [mm]\n', GapMonitor(i));
      fprintf('  User Gap     = %7.4f [mm]\n', UserGap(i));
      fprintf('  Gap Velocity Setpoint = %5.3f [mm/second]\n', GapVelocitySetPoint(i));
      fprintf('  Gap Velocity Monitor  = %5.3f [mm/second]\n', GapVelocityMonitor(i));
      fprintf('  Move Count / Error Monitor = %.1f \n', GapMoveCount(i));
      fprintf('  Reset Flag = %d \n', GapReset(i));
      fprintf('  Limit Flag = %d \n', GapLimitFlag(i));
      fprintf('  Velocity Profile Control = %d \n', GapVelocityProfile(i,1));
      fprintf('  Motor Drive Disable Control = %d \n', GapDriveDisable(i,1));
      
      if Sector(i)==4
         fprintf('  Vertical Home Control = %d \n', scaget('SR04U___GDS1HS_BC03'));
         fprintf('  Vertical Home Status  = %d \n', scaget('SR04U___GDS1HS_BM03'));
         fprintf('  Vertical Servo Amplifier Control = %d \n', scaget('SR04U___GDS1PS_BC04'));
         fprintf('  Vertical Servo Amplifier Status  = %d \n', scaget('SR04U___GDS1PS_BM04'));
         fprintf('  Horizontal User Gap          = %7.4f [mm]\n', scaget('cmm:ID4_bl_input_h'));
         fprintf('  Horizontal Offset Setpoint   = %7.4f [mm]\n', scaget('SR04U___ODS1PS_AC00'));
         fprintf('  Horizontal Offset Monitor    = %7.4f [mm]\n', scaget('SR04U___ODS1PS_AM00'));
         fprintf('  Horizontal Offset Setpoint A = %7.4f [mm]\n', scaget('SR04U___ODA1PS_AC02'));
         fprintf('  Horizontal Offset Monitor  A = %7.4f [mm]\n', scaget('SR04U___ODA1PS_AM00'));
         fprintf('  Horizontal Offset Setpoint B = %7.4f [mm]\n', scaget('SR04U___ODB1PS_AC03'));
         fprintf('  Horizontal Offset Monitor  B = %7.4f [mm]\n', scaget('SR04U___ODB1PS_AM01'));
         fprintf('  Horizontal Velocity Setpoint  = %7.4f [mm/second]\n', scaget('SR04U___ODS1V__AC01'));
         fprintf('  Horizontal Velocity Monitor   = %7.4f [mm/second]\n', scaget('SR04U___ODS1V__AM01'));
         fprintf('  Horizontal Velocity Monitor A = %7.4f [mm/second]\n', scaget('SR04U___ODA1V__AM01'));
         fprintf('  Horizontal Velocity Monitor B = %7.4f [mm/second]\n', scaget('SR04U___ODB1V__AM01'));
         fprintf('  Horizontal Move Count / Error Flag = %.1f \n', scaget('SR04U___ODS1E__AM02'));
         fprintf('  Horizontal Reset Flag = %d \n', scaget('SR04U___ODS1V__BC01'));
         fprintf('  Horizontal Limit Flag = %d \n', scaget('SR04U___ODS1V__BM02'));
         fprintf('  Horizontal Home Control = %d \n', scaget('SR04U___ODS1HS_BC03'));
         fprintf('  Horizontal Home Status  = %d \n', scaget('SR04U___ODS1HS_BM03'));
         fprintf('  Horizontal Servo Amplifier Control = %d \n', scaget('SR04U___ODS1PS_BC04'));
         fprintf('  Horizontal Servo Amplifier Status  = %d \n', scaget('SR04U___ODS1PS_BM04'));
         fprintf('  Horizontal Status Word = %s \n', dec2bin(scaget('SR04U___ODS1ST_AM03'),16));
         fprintf('  Vertical   Status Word = %s \n', dec2bin(scaget('SR04U___GDS1ST_AM03'),16));
         fprintf('                           0123456789ABCDEF\n');
      end
      
      fprintf('  Gap Control  Enabled Control = %d \n', GapEnableBC(i));
      fprintf('  Gap Control  Enabled Monitor = %d \n', GapEnableBM(i));
      fprintf('  Feed Forward Enabled Control = %d \n', FFEnableBC(i));
      fprintf('  Feed Forward Enabled Monitor = %d \n', FFEnableBM(i));
      fprintf('  Feed Forward Active Count = %d \n', FFActiveCount(i));
      fprintf('  Feed Forward Table Read = %d \n', FFTableRead(i));
      fprintf('  Feed Forward Error = %d \n', FFError(i));
      if isunix
         fprintf('  Feed Forward Header: %s \n', getffheader(Sector(i)));
      end
      
      fprintf(' \n');
   end
end
