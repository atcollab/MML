function hwinit(varargin)
%HWINIT - Hardware initialization script for the Booster


DisplayFlag = 1;  % Not implemented!!!
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end


fprintf('   Initializing Booster parameters (hwinit)\n')


% Set all UDF fields (labca WarnLevel=14 seems to have removed the need for this!)
% try
%     fprintf('   0. Setting the UDF fields for all families to 0 ... ');
%     resetudferrors;
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n   Error setting the UDF for all families\n');
% end


% Set corrector magnets
try
    fprintf('   1. Setting Booster magnets QF, SF, SD to a 10 Hz scan rate on the monitors ... ');
    %fprintf('   1. Setting Booster magnets HCM, VCM, QF, QD, SF, SD, and BEND to a 10 Hz scan rate on the monitors ... ');
    %setpv(family2channel('HCM',  'Monitor'), 'SCAN', 9);
    %setpv(family2channel('VCM',  'Monitor'), 'SCAN', 9);
    setpv(family2channel('QF',   'Monitor'), 'SCAN', 9);
    %setpv(family2channel('QD',   'Monitor'), 'SCAN', 9);
    setpv(family2channel('SF',   'Monitor'), 'SCAN', 9);
    setpv(family2channel('SD',   'Monitor'), 'SCAN', 9);
    %setpv(family2channel('BEND', 'Monitor'), 'SCAN', 9);
    fprintf('Done\n');
catch
    fprintf(2, '\n   Error setting .SCAN field of booster magnets.\n');
end


% Timing
try
    fprintf('   2. Copy the monitors for the booster timing channels into the setpoints ... ');
    AM = getam('BRTiming');
    setsp('BRTiming', AM);
    fprintf('Done\n');
catch
    fprintf(2, '\n   Error copying the monitors for the booster timing channels into the setpoints.\n');
end


% BEND controller setup
% try
%     fprintf('   3. BEND controller setup ... ');
%     %Table_Len = getam('BR1:B:SET_TABLE_LEN');
%     %setsp('BR1:B:SET_TABLE_LEN', Table_Len);
% 
%     setpv('BR1_____B__PSGNAC00', 0.532935);  % Setpoint gain
%     setpv('BR1_____B__PSOFAC00', );  % Setpoint offset
%     
%     
%     % Offset
%   %  setpv('BR1_____B_PSOFAC00', -236);
%     %setpv('BEND', 'Offset', -236);
%     %
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n   Error setting up the BEND controller defaults.\n');
% end


% % New QF PS controller
% try
%     fprintf('   3. QF PS controller setup (Offset only for now)... ');
%     %     QF_Table_Len = getam('BR1:QF:SET_TABLE_LEN');  % Zero???
%     %     setsp('BR1:QF:SET_TABLE_LEN', QF_Table_Len);
%     %
%     %     % Gain
%     %     setpv('BR1_____QF_PSGNAC00', 0.9653);
%     %
%     % Offset
%     setpv('BR1_____QF_PSOFAC00', -236);
%     %setpv('QF', 'Offset', -236);
%     %
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n   Error setting up the QF PS controller defaults.\n');
% end


% % New QD PS controller
% try
%     fprintf('   3. QD PS controller setup (Offset only for now)... ');
%     %     QD_Table_Len = getam('BR1:QD:SET_TABLE_LEN');  % Zero???
%     %     setsp('BR1:QD:SET_TABLE_LEN', QD_Table_Len);
%     %
%     %     % Gain
%     %     setpv('BR1_____QD_PSGNAC00', 0.8706);
%     %
%     % Offset
%     setpv('BR1_____QD_PSOFAC00', -245);
%     %setpv('QD', 'Offset', -245);
%     %
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n   Error setting up the QD PS controller defaults.\n');
% end


% % Set BPMs
% try
%     fprintf('   3. Setting Booster BPMs to a 10 Hz scan rate ... ');
%     setpv(family2channel('BPMx'),'SCAN', 9);
%     setpv(family2channel('BPMy'),'SCAN', 9);
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n   Error setting .SCAN field of booster BPMs.\n');
% end


% % Set SF & SD on
% try
%     fprintf('   4. Turning SF & SD on (if necessary) ... ');
%     OnFlag = getpv('SF', 'On');
%     if any(OnFlag==0)
%         setpv('SF', 'EnableRamp', 0);  % Disable the ramp before turning on or it could glitch
%         pause(1);
%         setpv('SF', 'Setpoint',  0);
%         setpv('SF', 'OnControl', 1);
%     end
%     OnFlag = getpv('SD', 'On');
%     if any(OnFlag==0)
%         setpv('SD', 'EnableRamp', 0);  % Disable the ramp before turning on or it could glitch
%         pause(1);
%         setpv('SD', 'Setpoint',  0);
%         setpv('SD', 'OnControl', 1);
%     end
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n   Error: trouble turning on SF or SD.\n');
% end


% % Set SF, SD, & RF ramp tables
% try
%     fprintf('   5. Loading the booster SF ramp tables ... ');
%     setboosterrampsf;
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n   Error setting the booster SD ramp table.\n');
% end
% try
%     fprintf('   6. Loading the booster SD ramp tables ... ');
%     setboosterrampsd;
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n   Error setting the booster SF ramp table.\n');
% end
% 

% try
%     fprintf('   7. Loading the booster RF ramp tables ... ');
%     setboosterramprf;
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n   Error setting the booster RF ramp table.\n');
% end


fprintf('\n   HWINIT is done restoring machine defaults.\n');

