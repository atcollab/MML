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


% Booster or Faraday Cup
try
    % Switch to BR (if necessary)
    if getpv('LTB_____BS_LTB_BC23')==1 && getpv('LTB_____BS_FC__BC22')==0 % && getpv('LTB_____BS_FC__BM10')==0 && getpv('LTB_____BS_LTB_BM11')==1 (BM does not appear to work0?)
        fprintf('   1. Beam is switched towards the booster (not the Faraday Cup).\n');
        fprintf('      Use setlinacbeamdirection to change the direction.\n');
        
          
    else
        if getsp('BEND',[3 1]) > 20
            fprintf(2, '   1. Beam is going to the Faraday Cup!\n');
        else
            fprintf('   1. Beam might be going toward the Faraday Cup.  Check again when BS is at operating current.\n');
        end
        % fprintf(2, '      Changing to go toward the booster ... ');
        % % Should ramp BS down to 25.5, then switch setpv('LTB_____BS_LTB_BC23',0) setpv('LTB_____BS_FC__BC22', 1)
        % T_BS = getramptime('BEND', 25.5, [3 1]);
        % BS = getsp('BEND', [3 1]);
        % setsp('BEND', 25.5, [3 1]);
        % if T_BS > 0
        %     pause(T_BS+10);
        % end
        % setpv('LTB_____BS_LTB_BC23', 0);
        % setpv('LTB_____BS_FC__BC22', 1);
        % setsp('BEND',BS, [3 1]);
        % fprintf('Done\n');
        % If this fails, power cycle (breaker) the BS magnet
    end
catch
    fprintf(2, '   Error determining if the beam will go to the Faraday Cup or booster.\n');
end


try
    fprintf('   2. Setting SOL monitor calibration.\n');
    SolenoidCalibration;
catch
    fprintf(2, '   Error setting SOL monitor calibration.\n');
end


try
    fprintf('   3. Setting BS, B1, and B2 calibration.\n');
    
    % Treat as a gain for now
    setpv('irm:024:ADC0.ESLO', 29.7462);
    setpv('irm:023:ADC1.ESLO', 29.6076);
    setpv('irm:023:ADC2.ESLO', 21.8460);
    setpv('irm:023:ADC3.ESLO', 29.4602);

catch
    fprintf(2, '   Error setting BS, B1, and B2 calibration.\n');
end


try
    fprintf('   4. Initalize GTB magnet power supply ramp rates.\n');
    setpv('HCM',  'RampRate', 5);
    setpv('VCM',  'RampRate', 5);
    setpv('Q',    'RampRate', 5);
    setpv('BEND', 'RampRate', [2 2 7 20]');
    
    %setpv('irm:023:SlewRate0', 2);  % LTB_BS
    %setpv('irm:023:SlewRate2', 2);  % LTB_B1
    %setpv('irm:024:SlewRate0', 7);  % LTB_B2
    %setpv('LTB:B3:SlewRate',  20);  % LTB_B3
catch
    fprintf(2, '   Error initializing magnet power supply ramp rates.\n');
end


try
    fprintf('   5. Initalize GTB BPMs.\n');
    bpminit;
catch
    fprintf(2, '   Error initializing BPMs.\n');
end
% try  ->  put in bpminit
%     fprintf('   4. Setting GTB BPM offsets.\n');
%     
%     if 0
%         Offset = -1 * [
%             4.7629   -1.7176
%             -2.8162    2.2552
%             -1.1192    0.8359
%             -1.0829    0.3728
%             1.0369    3.3598
%             1.9328    1.4688
%             -0.5251    1.5129
%             2.6773    2.4610
%             1.1835    2.0140
%             0.6943   -1.7660
%             ];
%     else
%         Offset = -1 * [
%             4.7723   -1.7139
%             -2.8160    2.2563
%             -1.1175    0.8222
%             -1.0830    0.3725
%             1.0310    3.3586
%             1.9303    1.4741
%             -0.4897    1.5242
%             2.6766    2.4623
%             1.2129    1.9443
%             0.7223   -1.7867
%             ];
%     end
%     
%     xn = family2channel('BPMx');
%     yn = family2channel('BPMy');
%     
%     for i = 1:length(xn)
%         setpv(xn{i}, 'EOFF', Offset(i,1));
%         setpv(yn{i}, 'EOFF', Offset(i,2));
%     end
% catch
%     fprintf(2, '   Error setting BPM attenuation.\n');
% end



% Set corrector magnets
% try
%     fprintf('   3. Setup for GTB magnets HCM, VCM, Q, BuckingCoil, and BEND ... ');
%     %setpv('HCM', 'RampRate', 4);
%     %setpv('VCM', 'RampRate', 5);
%     %setpv('Q',   'RampRate', 5);
%     
%     setpv(family2channel('HCM', 'BulkControl'), 'ZNAM', 'Off');
%     setpv(family2channel('HCM', 'BulkControl'), 'ONAM', 'On');
%     setpv(family2channel('VCM', 'BulkControl'), 'ZNAM', 'Off');
%     setpv(family2channel('VCM', 'BulkControl'), 'ONAM', 'On');
%     setpv(family2channel('Q',   'BulkControl'), 'ZNAM', 'Off');
%     setpv(family2channel('Q',   'BulkControl'), 'ONAM', 'On');
%     setpv(family2channel('BuckingCoil', 'BulkControl'), 'ZNAM', 'Off');
%     setpv(family2channel('BuckingCoil', 'BulkControl'), 'ONAM', 'On');
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n   Error in GTB magnet setup (BEND, Q, HCM, VCM, BuckingCoil).\n');
% end


% Commented here since it's a menu choice in gtbcontrol
%setcaen('Init GTB');


fprintf('   HWINIT is complete.\n');





function SolenoidCalibration

% LINR = SLOPE (1)
% ao (AC):  RVAL = (VAL - EOFF) / ESLO
% ai (AM): 	VAL = RVAL * ESLO + EOFF

% Original
EOFF0 = 0;
% getpv(family2channel('SOL','Monitor'),'ESLO')
ESLO0 = [
   11.5000
   11.5000
   11.5000
   50.0000
   50.0000
   50.0000
   50.0000];

% Nominal
% AC=getpv(family2channel('SOL','Setpoint'))
AC = [
   31.7998
   86.0500
   73.5455
  278.9058
  238.7614
  266.956
  238.0070
];
% AM=getpv(family2channel('SOL','Monitor'))
AM = [
    31.6208
    82.9706
    68.7070
    269.0945
    263.7672
    268.8493
    211.9398
    ];
AM0 = [
    -0.0013
    0.0665
    -0.0717
    -0.1116
    0.0343
    0.0000
    -0.0525
    ];

% ai (AM): 	VAL = RVAL * ESLO + EOFF
EOFF = -1* AM0;
ESLO = (AC-EOFF) ./ AM;

setpv(family2channel('SOL','Monitor'),'EOFF', -1*AM0);
setpv(family2channel('SOL','Monitor'),'ESLO', ESLO0 .* ESLO);


% family2channel('SOL')
% GTL_____SOL1___AM00
% GTL_____SOL2___AM01
% GTL_____SOL3___AM02
% LN______SOL1___AM00
% LN______SOL2___AM01
% LN______SOL3___AM02
% LN______SOL4___AM03
% 
% getpv(family2channel('SOL'),'EOFF')
%     0.0013
%    -0.0665
%     0.0717
%     0.1116
%    -0.0343
%    -0.0420
%     0.0525
% 
% getpv(family2channel('SOL'),'ESLO')
%    11.5646
%    11.9360
%    12.2979
%    51.8023
%    45.2664
%    51.6394
%    56.1373
