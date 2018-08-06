function hwinit(varargin)
%HWINIT - Hardware initialization script for the GTB


DisplayFlag = 1;
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end


fprintf('   Initializing GTB parameters (hwinit)\n')


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
    fprintf('   1. Setting GTB magnets HCM, VCM, Q, and BEND to a 10 Hz scan rate on the monitors ... ');
    setpv(family2channel('HCM',  'Monitor'), 'SCAN', 9);
    setpv(family2channel('VCM',  'Monitor'), 'SCAN', 9);
    setpv(family2channel('Q',    'Monitor'), 'SCAN', 9);
    setpv(family2channel('BEND', 'Monitor'), 'SCAN', 9);
    fprintf('Done\n');
catch
    fprintf(2, '\n   Error setting .SCAN field of one of the GTB magnet families (BEND, Q, HCM, or VCM).\n');
end


% Set BPMs
try
    fprintf('   2. Setting GTB BPMs to a 10 Hz scan rate ... ');
    setpv(family2channel('BPMx'),'SCAN', 9);
    setpv(family2channel('BPMy'),'SCAN', 9);
    fprintf('Done\n');
catch
    fprintf(2, '\n   Error setting .SCAN field of BTS BPMs.\n');
end


% Booster or Faraday Cup
try
    % Switch to BR (if necessary)
    if getpv('LTB_____BS_LTB_BC22')==0 && getpv('LTB_____BS_FC__BC23')==1 % && getpv('LTB_____BS_FC__BM10')==0 && getpv('LTB_____BS_LTB_BM11')==1 (BM does not appear to work0?)
        fprintf('   3. Beam is switched towards the booster (not the Faraday Cup).\n');
    else
        if getsp('BEND',[3 1]) > 20
            fprintf(2, '   3. Beam is going to the Faraday Cup!\n');
        else
            fprintf('   3. Beam might be going toward the Faraday Cup.  Check again when BS is at operating current.\n');
        end
        % fprintf(2, '      Changing to go toward the booster ... ');
        % % Should ramp BS down to 25.5, then switch setpv('LTB_____BS_LTB_BC22',0) setpv('LTB_____BS_FC__BC23', 1)
        % T_BS = getramptime('BEND', 25.5, [3 1]);
        % BS = getsp('BEND', [3 1]);
        % setsp('BEND', 25.5, [3 1]);
        % if T_BS > 0
        %     pause(T_BS+10);
        % end
        % setpv('LTB_____BS_LTB_BC22',0);
        % setpv('LTB_____BS_FC__BC23', 1);
        % setsp('BEND',BS, [3 1]);
        % fprintf('Done\n');
    end
catch
    fprintf(2, '   Error determining if using the Faraday Cup or if the beam will go to the booster.\n');
end


% Timing  ->  This issue looks like it has been fixed (2009-06-01)
% try
%     fprintf('   3a. Setting GTL_____TIMING_AC03.DRVH to 50 for now!\n');
%     setpv('GTL_____TIMING_AC03.DRVH', 50);
%     pause(.5);
% 
%     fprintf('   3b. Copy the monitors for the timing channels into the setpoints ... ');
%     AM = getam('GunTiming');
%     setsp('GunTiming', AM);
%     
%     AM = getam('BRTiming');
%     setsp('BRTiming', AM);
%     
%     AM = getam('SRTiming');
%     setsp('SRTiming', AM);
%     
%     fprintf('Done\n');
%     
% catch
%     fprintf(2, '\n   Error copying the monitors for the timing channels into the setpoints.\n');
% end



fprintf('   HWINIT is complete.\n');
