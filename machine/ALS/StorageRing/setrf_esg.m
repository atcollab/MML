function RF = setrf_esg(rf, RampFlag);
% RFam = setrf_esg(RFac, RampFlag);
%
%  RFac = new RF frequency [MHz]
%  RFam = monitor value for the RF frequency (same as getrf) [MHz]
%  if RampFlag
%     Ramp the RF frequency slowing {default}
%  else
%     Set the RF frequency in one step
%
%  If RFac is a string (like, 'local')
%     RFac = reset  -> turns on  polling (remote mode) then resets the systhesizer
%     RFac = remote -> turns on  polling
%     RFac = local  -> turns off polling
%
%  Note:  The RF must be connected to the variable synthesizer for this function to work
%

SweepModeFlag = 0;
TolSP_AM = .00001;

if nargin < 2
   RampFlag = 1;
end

if SweepModeFlag
   % Using sweep mode
   delMOperRF = 1/(-8.85009765625e-004);
   
   mo0 = getmo;
   rf0 = getrf;
   delMO = delMOperRF*(rf-rf0);
   setmo(mo0+delMO);
   
   mo0 = getmo;
   rf0 = getrf;
   delMO = delMOperRF*(rf-rf0);
   setmo(mo0+delMO);
else
   % Using synthesizer
   MaxStep = .0005;     % MHz
   
   if isstr(rf)
      if strcmp('reset',lower(rf))
         % Reset synthesizer
         disp('  Reset synthesizer (and set to remote mode)');
         setsp('SR03S___RFFREQ_BC01RF', 0); 
         setsp('SR03S___RFFREQ_BC00RF.PROC', 1); 
      elseif strcmp('remote',lower(rf))
         % Set synthesizer to remote mode
         disp('  Set synthesizer to remote (polling)');
         setsp('SR03S___RFFREQ_BC01RF', 0);
         
         % Set present AC (in case it was set while in local)
         RFac = getam('SR03S___RFFREQ_AC00RF');
         setsp('SR03S___RFFREQ_AC00RF', RFac);
      elseif strcmp('local',lower(rf))
         % Set synthesizer to local mode
         disp('  Set synthesizer to local (no polling)');
         setsp('SR03S___RFFREQ_BC01RF', 1); 
      else
         fprintf('  Unknown command: %s\n',rf);
      end
   else
      RFac0   = getam('SR03S___RFFREQ_AC00RF');
      Nsteps = ceil(abs((RFac0-rf)/MaxStep));
      
      % For large setpoint changes, varify RampFlag=1
      if RampFlag==1 & abs(RFac0-rf) > .05
         RampFlag = questdlg(str2mat(sprintf('The RF change is %.5f MHz.',RFac0-rf),'How many steps do you want to make?'),'RF Synthesizer?','1 Step',sprintf('%d Steps',Nsteps),'1 Step');
         if strcmp(RampFlag,'1 Step')
            RampFlag = 0;
         else
            RampFlag = 1;
         end
      end
      
      if RampFlag
         for i = 1:Nsteps
            setsp('SR03S___RFFREQ_AC00RF', RFac0 + i*(rf-RFac0)/Nsteps);
            sleep(.03);
         end
         setsp('SR03S___RFFREQ_AC00RF', rf); 
      else
         setsp('SR03S___RFFREQ_AC00RF', rf); 
      end
   end
end

sleep(1);

if ~isstr(rf)
   if nargout > 0
      RF = getrf;
   end
   %if RF-rf > TolSP_AM
   %  fprintf('  SETRF WARNING:  Setpoint (%f MHz) - Monitor (%f MHz) difference (%f MHz) is out-of-tolerance.\n', RF, rf, RF-rf);
   %  fprintf('  Make sure the synthesizer is setup properly (try "setrf reset", then "setrf(%f)").\n', rf);
   %end
end

