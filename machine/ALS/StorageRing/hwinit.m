function hwinit(varargin)
%HWINIT - This function initializes the storage ring parameters the user operation


CMRampRate = 5;
DisplayFlag = 1;


% for i = length(varargin):-1:1
%     if strcmpi(varargin{i},'Display')
%         DisplayFlag = 1;
%         varargin(i) = [];
%     elseif strcmpi(varargin{i},'NoDisplay')
%         DisplayFlag = 0;
%         varargin(i) = [];
%     end
% end

fprintf('\n');
fprintf('   Initializing storage ring parameters (HWINIT)\n')
%fprintf('\n');


% Set all UDF fields (labca WarnLevel=14 seems to have removed the need for this!)
% if islabca
% try
%     fprintf('   0. run "resetudferrors" to clear all the UDF errors. It will not be run here!!!\n');
%     %fprintf('   0. Setting the UDF fields for all families to 0 ... ');
%     %resetudferrors;
%     %fprintf('Done\n');
% catch
%     fprintf('\n      Error setting the UDF for all families\n\n');
% end
% end

% Set the BPM averaging/timeconstant
try
    BPMFreshDataSamplingPeriod = .5;  % seconds
    fprintf('   1. BPM averaging/timeconstant set for fresh data every %.2f seconds ... ', BPMFreshDataSamplingPeriod);
    setbpmaverages(BPMFreshDataSamplingPeriod);
    fprintf('Done\n');
catch
    fprintf(2, '\n      Error setting BPM averaging/timeconstant.\n\n');
end


% FADs off
% try
fprintf('   2. Setting BPM FADs off ... Currently not being executed!\n');
%     setfad(0);
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n      Error BPM FADs off.\n\n');
% end


% Set corrector magnets to slow mode
fprintf('   3. Setting storage ring corrector magnets HCM and VCM to %.1f amps/sec\n', CMRampRate);
fprintf('      And time constants to zero ... \n');
try
    setpv('HCM', 'RampRate', CMRampRate, [], 0);
    setpv('VCM', 'RampRate', CMRampRate, [], 0);
    fprintf('      Done with ramp rates\n');
catch
    fprintf('\n      Error setting storage ring corrector magnets HCM and VCM ramp rates.\n\n');
end
try
    setpv('HCM', 'TimeConstant', 0, [], 0);
    setpv('VCM', 'TimeConstant', 0, [], 0);
    fprintf('      Done with time constants\n');
catch
    fprintf('\n      Error setting storage ring corrector magnets HCM and VCM time constants.\n\n');
end

% Set the chicanes magnet trim coils ramp rate
try
    %fprintf('   4. Chicanes magnet trim coils set to slow mode (1 Amp/Sec) ... ');
    %setpv('SR04U___HCM2___AC20',0);
    %setpv('SR04U___HCM2___AC30',1);
    %setpv('SR04U___VCM2___AC20',0);
    %setpv('SR04U___VCM2___AC30',1);
    %
    %setpv('SR06U___HCM2___AC20',0);
    %setpv('SR06U___HCM2___AC30',1);
    %setpv('SR06U___VCM2___AC20',0);
    %setpv('SR06U___VCM2___AC30',1);
    %
    %setpv('SR11U___HCM2___AC20',0);
    %setpv('SR11U___HCM2___AC30',1);
    %setpv('SR11U___VCM2___AC20',0);
    %setpv('SR11U___VCM2___AC30',1);
    %fprintf('Done\n');
    
    % This is a temporary solution since orbit feedback does not have a trim channel for these magnets yet
    fprintf('   4. Chicanes magnet trim coils set to fast mode (1000 Amp/Sec) ... ');
%     setpv('SR04U___HCM2___AC20',0);  % No Time Constant for CAEN power supplies
    setpv('SR04U___HCM2___AC30',1000);
%     setpv('SR04U___VCM2___AC20',0);  % No Time Constant for CAEN power supplies
    setpv('SR04U___VCM2___AC30',1000);
    
%    setpv('SR06U___HCM2___AC20',0);  % No Time Constant for CAEN power supplies
    setpv('SR06U___HCM2___AC30',1000);
%    setpv('SR06U___VCM2___AC20',0);  % No Time Constant for CAEN power supplies
    setpv('SR06U___VCM2___AC30',1000);
    
%     setpv('SR11U___HCM2___AC20',0);  % No Time Constant for CAEN power supplies
    setpv('SR11U___HCM2___AC30',1000);
%     setpv('SR11U___VCM2___AC20',0);  % No Time Constant for CAEN power supplies
    setpv('SR11U___VCM2___AC30',1000);
    fprintf('Done\n');
    
catch
    fprintf(2, '\n      Error setting chicanes magnet trim coils in to fast mode.\n\n');
end


% Set power supply ramprates and time constants
try
    fprintf('   5. Setting time constant and ramp rates set for BEND, QF, QD, QFA, QDA, SF, SD, and CHICANE magnets ... ');
    
    setpv('BEND', 'RampRate', 10.5, [1 1], 0);  % Just the normal bend power supply
    setpv('QFA',  'RampRate',  5.9, [], 0);
    setpv('QDA',  'RampRate',  1.0, [], 0);
    setpv('QF',   'RampRate',  1.0, [], 0);
    setpv('QD',   'RampRate',  1.0, [], 0);
    setpv('SF',   'RampRate',  2.0, [], 0);   % 2010-11-04 returned to 2A/s since new supply is fine with that rate %2010-06-28 reduced 3 to 1 due to sensitivity of the SF (Tom S.)
    setpv('SD',   'RampRate',  2.0, [], 0);   % restored 4-25-12 after SD SCR was fixed - T.Scarvie % 2010-11-04 returned to 2A/s so ramping gets all the way down to lower lattice % 2009-11-03 reduced 3 to 1 to help with the filter cap issue (GJP)
    %setpv('SD',   'RampRate',  .75, [], 0);   % 2012-04-10 slowed down at Chris Pappas's request (GJP) - THIS LINE IS ALSO IN SRRAMP.M
    setpv('HCMCHICANE', 'RampRate', 4.0, [4 1;4 3;6 1;6 3], 0);   % [S 2] set as part of the HCM family
    %setpv('VCMCHICANE', 'RampRate', 2.0, [4 1;4 3;6 1], 0);   % no longer a family, use VCM
    
    setpv('BEND', 'TimeConstant', 0, [], 0);
    setpv('QDA',  'TimeConstant', 0, [], 0);
    setpv('QFA',  'TimeConstant', 0, [], 0);
    setpv('QDA',  'TimeConstant', 0, [], 0);
    setpv('QF',   'TimeConstant', 0, [], 0);
    setpv('QD',   'TimeConstant', 0, [], 0);
    setpv('SF',   'TimeConstant', 0, [], 0);
    setpv('SD',   'TimeConstant', 0, [], 0);
    setpv('HCMCHICANE', 'TimeConstant', 0, [4 1;4 3;6 1;6 3], 0);   % [S 2] set as part of the HCM family
    %setpv('VCMCHICANE', 'TimeConstant', 0, [4 1;4 3;6 1], 0);  % no longer a family, use VCM
    fprintf('Done\n');
catch
    fprintf(2, '\n      Error setting time constant and ramp rates set for BEND, QF, QD, QFA, QDA, SF, SD, and CHICANE magnets.\n\n');
end


% Set Superbend maximum current and ramprate
% Added by Christoph Steier, 2001-09-02
try
    fprintf('   6. Setting superbend magnet ramp rates (0.4 A/s) and limits (302 A) ... ');
    setpv('BEND', 'RampRate', 0.4, [4 2; 8 2; 12 2], 0);
    
    %setpv('BSC', 'Limit', 302, [4 2; 8 2; 12 2], 0);  % BSC family may disappear in the future
    setpv('SR04C___BSC_P__AC02', 302);
    setpv('SR08C___BSC_P__AC02', 302);
    setpv('SR12C___BSC_P__AC02', 302);
    
    fprintf('Done\n');
catch
    fprintf(2, '\n      Error setting ramp rate (0.4 A/s) and Limit (302 A) set for Superbend magnets.\n\n');
end


% QFA shunts off
try
    fprintf('   7. Switching QFA shunts off ... ');
    setqfashunt(1, 0, [], 0);
    setqfashunt(2, 0, [], 0);
    fprintf('Done\n');
catch
    fprintf(2, '\n      Error switching QFA shunts off.\n\n');
end


% Set extra PS sum channels to zero
try
    fprintf('   8. Setting feed forward magnet sum channels to zero (HCM, VCM, QF, QD) ... ');
    setpv('HCM', 'FF1', 0);
    setpv('HCM', 'FF2', 0);
    setpv('VCM', 'FF1', 0);
    setpv('VCM', 'FF2', 0);
    % EPU Skew Quad Trim Coils
    setpv('SQEPU', 0);
    setpv('SQEPU', 'RampRate', 100); % set ramprate to fast
    setpv('SR04U___Q1FF___AC00', 0);
    setpv('SR04U___Q1M____AC00', 1);
    setpv('SR04U___Q2FF___AC00', 0);
    setpv('SR04U___Q2M____AC00', 1);
    setpv('SR06U___Q2FF___AC00', 0);
    setpv('SR06U___Q2M____AC00', 1);
    setpv('SR07U___Q1FF___AC00', 0);
    setpv('SR07U___Q1M____AC00', 1);
    setpv('SR07U___Q2FF___AC00', 0);
    setpv('SR07U___Q2M____AC00', 1);
    setpv('SR11U___Q1FF___AC00', 0);
%    setpv('SR11U___Q1M____AC01', 1); %empirical value of 0.3 in use, determined end of October 2014, Tom and Christoph
    setpv('SR11U___Q2FF___AC00', 0);
    setpv('SR11U___Q2M____AC01', 1);
    
    setpv('QF', 'FF', 0);
    setpv('QD', 'FF', 0);
    fprintf('Done\n');
catch
    fprintf(2, '\n      Error setting feed forward corrector magnet channels to zero.\n\n');
end


% Set corrector magnet trim channels to zero
% Added by Tom Scarvie, 2002-04-29
try
    fprintf('   9. Set corrector magnet trim channels to zero ... ');
    setpv('HCM', 'Trim', 0, [], 0);
    setpv('VCM', 'Trim', 0, [], 0);
    fprintf('Done\n');
catch
    fprintf(2, '\n      Error setting corrector magnet trim channels to zero.\n\n');
end


% Set the maximum horizontal speed for the EPU in sector 4 with velocity profile on to 16.7 mm/s
% Added by Christoph Steier, 2000-11-14
% Updated from 3 to 16.7 mm/s on 2008-04-07
try
    fprintf('  10. Setting EPU 4.1 horizontal velocity limit to 16.7 mm/s\n');
    setpv('sr04u:Hor_profile_max_vel', 16.7);
catch
    fprintf(2, '\n   Error setting EPU 4.1, horizontal velocity profile restricted to 16.7 mm/s\n');
end
try
    fprintf('      Setting EPU 4.2 vertical gap limit to 15.17 mm (amp trips at min gap)\n');
    setpv('sr04u2:Vgap_target_min', 15.17);
catch
    fprintf(2, '\n   Error setting EPU 4.2 vertical gap limit to 15.17 mm\n');
end
try
    fprintf('      Setting EPU 4.2 to parallel mode as anti-parallel is not allowed during User Ops\n');
    setpv('SR04U___ODS2M__DC00', 0);
catch
    fprintf(2, '\n   Error setting EPU 4.2 to parallel mode as anti-parallel is not allowed during User Ops\n');
end


% Open the scrapers (BTS horizontal scrapers, JH scrapers, SR03 normal scrapers)
try
    fprintf('  11. Setting the BTS and SR03 scrapers to full open.\n');
    fprintf('      Not changing the Jackson Hole scrapers ... ');
    setpv('BTS_____SCRAP1LAC01.VAL', 17.3);
    setpv('BTS_____SCRAP1RAC01.VAL', 17.9);
    setpv('BTS_____SCRAP2LAC01.VAL', 21.7);
    setpv('BTS_____SCRAP2RAC01.VAL', 16.5);
    %setpv('SR01C___SCRAP1BAC01.VAL', 0);
    %setpv('SR01C___SCRAP1TAC01.VAL', 0);
    %setpv('SR02C___SCRAP1BAC01.VAL', 0);
    %setpv('SR02C___SCRAP1TAC01.VAL', 0);
    %setpv('SR02C___SCRAP6TAC01.VAL', 0);
%     setpv('SR03S___SCRAPT_AC01.VAL', 0); %scrapers locked out as of now due to rad concerns
%     setpv('SR03S___SCRAPB_AC02.VAL', 0);
%     setpv('SR03S___SCRAPH_AC00.VAL', 0);
    %setpv('SR12C___SCRAP6TAC01.VAL', 0);
    fprintf('Done\n');
catch
    fprintf(2, '\n      Error setting the scrapers to open!\n\n');
end


% Quad FF multipliers
try
    fprintf('  12. Setting the FF multipliers for the QF  & QD  families to 1 ... ');
    setpv('QF', 'FFMultiplier', 1);
    setpv('QD', 'FFMultiplier', 1);
    fprintf('Done\n');
catch
    fprintf(2, '\n      Error setting the FF multipliers for the QF & QD families\n\n');
end

% Corrector FF multipliers
try
    fprintf('  13. Setting the FF multipliers for the HCM & VCM families to 1 ...\n');
    setpv('HCM', 'FFMultiplier', 1);
    setpv('VCM', 'FFMultiplier', 1);
%     
%     %EPU 4-1 and EPU 4-2
%     setpv('SR03C___HCM4M__AC00', 1);
%     setpv('SR04U___HCM2M__AC00', 1);
%     
%     setpv('SR03C___VCM4M__AC00', 1);
%     setpv('SR04U___VCM2M__AC00', 1);
%     
%     setpv('SR04C___HCM1M__AC00', 1);
%     setpv('SR04C___VCM1M__AC00', 1);
% 
%     %SR06 IVID and IDQ / EPU 6-2
%     setpv('SR05C___HCM4M__AC00', 1);
%     setpv('SR06U___HCM2M__AC00', 1);
%     
%     setpv('SR05C___VCM4M__AC00', 1);
%     setpv('SR06U___VCM2M__AC00', 1);
%     
%     setpv('SR06C___HCM1M__AC00', 1);
%     setpv('SR06C___VCM1M__AC00', 1);
%     
%     %SR07 EPU 7-2 (downstream PVs missing as of 9-16-2013
%     setpv('SR07U___HCM2M__AC00', 1);
%     setpv('SR07U___VCM2M__AC00', 1);
% %     setpv('SR07C___HCM1M__AC00', 1);
% %     setpv('SR07C___VCM1M__AC00', 1);
%     
%     %EPU 11-1 and EPU 11-2
%     setpv('SR10C___HCM4M__AC00', 1);
%     setpv('SR11U___HCM2M__AC00', 1);
%     setpv('SR11C___HCM1M__AC00', 1);
%     
%     setpv('SR10C___VCM4M__AC00', 1);
%     setpv('SR11U___VCM2M__AC00', 1);
%     setpv('SR11C___VCM1M__AC00', 1);
%     fprintf('Done\n');
catch
    fprintf(2, '\n      Error setting the FF multipliers for the HCM & VCM families\n\n');
end

% setup FOFB parameters
FOFBFreq = 1000;
% PIDs below are known good values for user ops as of 8-1-05
% /1.5 values added 2-18-09 due to FOFB trips during injection pulse + network trouble - T.Scarvie
% *0.8 factors for Pseudo-single Bunch lattice since effective gain of system is higher in that lattice - T.Scarvie
if strcmp(getfamilydata('OperationalMode'), 'Pseudo-Single Bunch (0.18,0.25)')
    HorP = 2/1.5*0.8;
    HorI = 300/1.5*0.8;
    HorD = 0.002/1.5*0.8;
else
    HorP = 2/1.5;
    HorI = 300/1.5;
    HorD = 0.002/1.5;
end
VertP = 1;
VertI = 100;
VertD = 0.0015;

try
    setsp('SR01____FFBFREQAC00', FOFBFreq); % set freq
    fprintf('  14. Fast orbit feedback frequency is set to %.0f Hz.\n', getpv('SR01____FFBFREQAM00'));
    write_pid_ffb2_patch(HorP, HorI, HorD, VertP, VertI, VertD); % set PIDs
    fprintf('  15. Setting FFB gains to Horizontal P=%.2f, I=%.1f, D=%.4f;  Vertical P=%.2f, I=%.1f, D=%.4f\n', HorP, HorI, HorD, VertP, VertI, VertD);
catch
    fprintf(2, '   Trouble setting Fast Orbit Feedback parameters!\n');
end

% Setup Third Harmonic Cavity defaults
fprintf('  16. Setting Third Harmonic Cavity defaults and opening loops.\n');
setpv('SR02C___C1MPOS_AC00', 6.800);
setpv('SR02C___C1MERR_AC00', 1.425);
setpv('SR02C___C2MPOS_AC00', 7.280);
setpv('SR02C___C2MERR_AC00', 1.295);
setpv('SR02C___C3MPOS_AC00', 7.435);
setpv('SR02C___C3MERR_AC00', 1.420);
setpv('SR02C___C1MLOP_BC00', 0);
setpv('SR02C___C2MLOP_BC00', 0);
setpv('SR02C___C3MLOP_BC00', 0);

% RF cavity temperatures
try
    Cavity1 = 35.0; % changed from 51.5 after tests on 4-5-2010 physics shift - see OLOG entry http://www.als.lbl.gov/olog/olog.php?id=53221 for details;
    Cavity2 = 35.0;
    fprintf('  17. RF Cavity Temperatures\n');
    fprintf('      Present monitor   temperatures (%.2f, %.2f)\n', getpv('RF','CavityTemperature1'), getpv('RF','CavityTemperature2'));
    fprintf('      Present setpoint  temperatures (%.2f, %.2f)\n', getpv('RF','CavityTemperature1Control'), getpv('RF','CavityTemperature2Control'));
    fprintf('      Setting RF cavity temperatures (%.2f, %.2f) ... ', Cavity1, Cavity2);
    setpv('RF', 'CavityTemperature1Control', Cavity1);
    setpv('RF', 'CavityTemperature2Control', Cavity2);
    fprintf('Done\n');
catch
    fprintf(2, '\n   Error setting SR RF cavity temperatures.\n\n');
end

% % other RF parameters
% try
%     SR03S___RFPHFB_AC00 = -160;  % changed 8-15-2012 at start of 2-bunch operations to match phase of injector and SR % Was 8 before spliting the planes (Sept 6, 2011) - changed to -118 after fixing ILC scaling factor. Now control system phase matches value on vector voltmeter
%     SR03S___RFPHLP_AC03 = 1.4;  % added this 5-24-16 since recent SR RF HV trip caused it to jump to 0.54 for some unknown reason, T.Scarvie
%     setpv('SR03S___RFPHFB_AC00', SR03S___RFPHFB_AC00);  % Was -107, -136, -140, 105, changed to -140 due wiring changes at the stripline
%     fprintf('  18. Setting RF Phase Loop desired value (SR03S___RFPHFB_AC00) to %.1f.\n', SR03S___RFPHFB_AC00);
%     setpv('SR03S___RFPHLP_AC03', SR03S___RFPHLP_AC03);
%     fprintf('      Setting RF Phase Loop control (SR03S___RFPHLP_AC03) to roughly correct value of %.1f.\n', SR03S___RFPHLP_AC03);    
%     % New value after reuild of the RF waveguides - empirically found based
%     % on locking TFB + LFBs to beam again after shutdown. This works
%     % together with the slow phase loop setpoint remaining at -160 degress
%     SR03S___RFPHSE_AC00 = 1.15;
%     setpv('SR03S___RFPHSE_AC00', SR03S___RFPHSE_AC00);
%     % Old value until October 2015
%     % setpv('SR03S___RFPHSE_AC00', 2.0);
%     
%     %   setpv('SR03S___RFPHLP_AC03', 4.3);
%     fprintf('      Setting RF Phase (SR03S___RFPHSE_AC00) to 1.15.\n');
%     %   fprintf('      Setting RF Phase to 2.0 and Slow RF Phase Loop to 4.30\n');
% catch
%     fprintf(2, '\n   Error setting RF Phase or Slow RF Phase Loop.\n\n');
% end


% Set the golden orbit PVs
fprintf('  19. Setting the golden orbit PVs to match what is in the MML.\n');
try
    setpv('BPMx', 'GoldenSetpoint', getgolden('BPMx'));
    setpv('BPMy', 'GoldenSetpoint', getgolden('BPMy'));
catch
    fprintf('\n   Error setting golden values to BPMs - likely BPMs(6,11) and (6,12).\n\n');
end


% Save the machineconfig to EDM scripts
% Set the golden orbit PVs
fprintf('  20. Writing the production lattice to EDM script files.\n');
setmachineconfig_sr;

% Set the motor chicane speeds to default
fprintf('  21. Setting the motor chicane velocities to default 10.0 deg/s.\n');
try
    setpv('HCMCHICANEM','RampRate',10);
catch
    fprintf('  Trouble setting motor chicane velocities!\n');
end


% DCCT2 Setup?
% SR05W___DCCT2__AC00  ->  NAvg 10?


fprintf('  22. Setting PV limits for SF and SD.\n');
try
    setpv('SR01C___SD_____AC00.DRVL', 0);
    setpv('SR01C___SD_____AC00.DRVH', 378);
    setpv('SR01C___SD_____AC10.DRVL', 0);
    setpv('SR01C___SD_____AC10.DRVH', 378);
    setpv('SR01C___SF_____AC00.DRVL', 0);
    setpv('SR01C___SF_____AC00.DRVH', 378);
    setpv('SR01C___SF_____AC10.DRVL', 0);
    setpv('SR01C___SF_____AC10.DRVH', 378);
catch
    fprintf('  Trouble setting SF or SD PV limits!\n');
end



% Old Cam current monitor still connected with modified PVs (add 'bclean:' to the old PV)
fprintf('  23. Setting cam-bunch scale factors and lifetime alarm limts.\n');
try
    % New system
    if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch') 
        setpv('Cam1_scale_factor', 1);
        setpv('Cam2_scale_factor', 1);
        setpv('Topoff_lifetime_AM.LOW', 1.00);  %Top Off lifetime
        setpv('Topoff_lifetime_AM.LOLO', 0.50);
    else
        setpv('Cam1_scale_factor', 0);
        setpv('Cam2_scale_factor', 1);
        setpv('Topoff_lifetime_AM.LOW', 4.00);  %Top Off lifetime
        setpv('Topoff_lifetime_AM.LOLO', 3.50);
    end

%     % Old system
%     % fprintf('  23. Setting cam-bunch scale factors, ADC offsets, and bucket offset.\n');try
%     % Cam1_scale_factor = getpv('Cam1_scale_factor')
%     % Was  -0.021800000000000
%     % getpv('Cam1_scale_factor')*getdcct/getpv('Cam1_current')RF
%     % Changed to:
%     % setpv('Cam1_scale_factor', -0.010073492740048*1.04);
%     % Empirically determined factors below on 8-24-2010, T.Scarvie
%     % setpv('Cam1_scale_factor', -0.0121);
%     % cam measurement scale factors changed when user timing system failed and was repaired 3/23&24/12
%     if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch') %cam measurement is bunch-length dependent
%         setpv('bclean:Cam1_scale_factor', 0.0865);             % updated cam scaling factors for new lattice (bunches are shorter now -> larger scaling factors)
%         setpv('bclean:Cam2_scale_factor', 0.0865);             % after new feedback kicker attenuators were added, scaling changed a lot
%     else
%         setpv('bclean:Cam1_scale_factor', 0.0865);
%         %setpv('bclean:Cam2_scale_factor', -0.0179*3.2*(1.0));
%         setpv('bclean:Cam2_scale_factor',  0.0865);             %timing shift due to using new SR04 UTR - removed all extra delay cables form ADC input to get less noise, but sign flipped and gain changed. 4-16-15, T.Scarvie %timing shift due to 9-22-14 physics led Mike C. to remove ~1ns fromt the ADC, putting us on the negative peak of the bunch, so flipped the sign - amplitude seems about right
%     end
%     % Changed ADC Offset to -6 and empirically determined factors (note: 13% change) 9-26-2010, GJP
%     % setpv('Cam1_scale_factor', -0.01048);
%     
%     % Cam2_scale_factor = getpv('Cam2_scale_factor')
%     % Was  -0.021800000000000
%     % getpv('Cam2_scale_factor')*getdcct/getpv('Cam2_current')
%     % Changed to:
%     % setpv('Cam2_scale_factor', -0.010112642183812*1.04);
%     % Empirically determined factors below on 8-24-2010, T.Scarvie
%     % setpv('Cam1_scale_factor', -0.0121);
%     % cam measurement scale factors changed when user timing system failed and was repaired 3/23&24/12
%     % Changed ADC Offset to -6 and empirically determined factors (note: 13% change) 9-26-2010, GJP
%     % setpv('Cam2_scale_factor', -0.01048);
%     
%     % ADC Offsets (9-26-2010, GJP)
%     setpv('bclean:Cam1_adc_offset', -6);
%     setpv('bclean:Cam2_adc_offset', -6);
%     
%     %Cam bucket measurement offset (1-27-11, T.Scarvie)
%     setpv('bclean:Cam_bucket_timing_offset',-160-14-2);  % Timing offset jumped by 160 buckets in July 2014 and by 2 buckets in March 2015
catch
    fprintf('  Trouble setting the cam-bunch scale factors and lifetime alarm limits!\n');
end

fprintf('  24. Setting PV limits RF control (HQMOFM is now scaled -10 -> 10 Volts with a voltage divider.\n');
try
    setpv('EG______HQMOFM_AC01.DRVH',  10);
    setpv('EG______HQMOFM_AC01.DRVL', -10);
catch
    fprintf('  Trouble setting HQMOFM PV limits!\n');
end

fprintf('  25. Setting PV alarm limits (.LOW, .LOLO, .HIGH, .HIHI) for SR magnets.\n');
try
    write_alarms_srmags_nominal;
catch
    fprintf('  Trouble setting SR Magnet PV alarm limits!\n');
end


try
    PseudoSingleBunch = getfamilydata('PseudoSingleBunch');
    
    % Initialize bunch cleaner in new TFBX dimtel system for use
    init_bclean_tfb;
    
    if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
        fprintf('  26. Setting bunch cleaning waveform and the bucket numbers.\n');
        WF = bunchcleanerwaveform(0);
%         setpv('bcleanSetPattern', WF(:,2)');
% %         setpv('bcleanPatternOffset', 164);   %bunch cleaner on new timing signal so these numbers changed - 3-23-15, T.Scarvie % experimentally determined offset, that makes bucket numbers in bunch cleaner waveform match actual bucket numbers
%         setpv('bcleanPatternOffset', 108);  % experimentally determined offset, that makes bucket numbers in bunch cleaner waveform match actual bucket numbers
        
        setpv('Cam1_bucket_number', 154);
        setpv('Cam2_bucket_number', 318);
%         setpv('bclean:Cam1_bucket_number', 166);
%         setpv('bclean:Cam2_bucket_number', 147+10);
    elseif ~isempty(PseudoSingleBunch) && strcmpi(PseudoSingleBunch,'On')
        strcmp(getfamilydata('OperationalMode'), 'Pseudo Single Bunch')
        fprintf('  26. Setting cam bucket numbers.\n');
%         fprintf('  26. Setting bunch cleaning waveform and the bucket numbers.\n');
%         b = zeros(1,328);
%         b(1) = 1;
%         b(325:328) = 1;
%         b(320:324) = -1;
%         
%         setpv('bcleanSetPattern', b);
% %        setpv('bcleanPatternOffset', 175);   %bunch cleaner on new timing signal so these numbers changed - 3-23-15, T.Scarvie % experimentally determined offset, that makes bucket numbers in bunch cleaner waveform match actual bucket numbers
%         setpv('bcleanPatternOffset', 11);  % experimentally determined offset, that makes bucket numbers in bunch cleaner waveform match actual bucket numbers
%         
        setpv('Cam1_bucket_number', 316); %bunch cleaner on new timing signal so these numbers changed - 3-23-15, T.Scarvie% nominally empty bucket that is not affected by bunch cleaner noise/distortion
        setpv('Cam2_bucket_number', 318);
%         setpv('bclean:Cam1_bucket_number', 145);  % nominally empty bucket that is not affected by bunch cleaner noise/distortion
%         setpv('bclean:Cam2_bucket_number', 147);
    elseif getpv('Physics10')==2   % single cam bucket, short gap
        fprintf('  26. Setting cam bucket numbers.\n');
        setpv('Cam1_bucket_number', 326);   % nominally empty bucket that is not affected by bunch cleaner noise/distortion
        setpv('Cam2_bucket_number', 318);
%         
%         % Set cleaning values for cam-buckets
%         b = zeros(1,328);
%         b(297:302) =  1;
%         b(320:325) = -1;
%         setpv('bcleanSetPattern', b);
%         setpv('bcleanPatternOffset', 175);
    elseif getpv('Physics10')==3   % single cam bucket in 308, short gap
        fprintf('  26. Setting cam bucket numbers.\n');
%         setpv('Cam1_bucket_number', 327);
%         setpv('Cam1_scale_factor', 0);
%         setpv('Cam2_bucket_number', 308);
%         setpv('bclean:Cam1_bucket_number', 166);
%         setpv('bclean:Cam1_scale_factor', 0);
%         setpv('bclean:Cam2_bucket_number', 147);
%         
        setpv('Cam1_bucket_number', 154);
        setpv('Cam2_bucket_number', 308);
% 
%         % Set cleaning values for cam-buckets
%         b = zeros(1,328);
%         b(297:302) =  1;
%         b(309:314) = -1;
%         setpv('bcleanSetPattern', b);
%         setpv('bcleanPatternOffset', 11+108);
    else
        fprintf('  26. Setting cam bucket numbers.\n');
        setpv('Cam1_bucket_number', 150);
        setpv('Cam2_bucket_number', 318);
%         
%         % Set cleaning values for cam-buckets
%         b = zeros(1,328);
%         b(152:156) =  1;
%         b(320:324) = -1;
%         setpv('bcleanSetPattern', b);
%         setpv('bcleanPatternOffset', 175);
    end
catch
    fprintf('  Trouble setting cam bucket numbers!\n');1000
end

IRM_ESLO = .9993;              % Need to check EOFF!!!
cmm_beam_current_offset =  1.1;  % was -0.0081 before moving to new DCCT (different scaling of PVs)
                                  % -0.0052 before moving the IRM (was -0.0092 before that)
fprintf('  27. Setting cmm:beam_current offset factor to %.02d, IRM gain to %.5f\n', cmm_beam_current_offset, IRM_ESLO);
try
    setpv('cmm:beam_current.F', cmm_beam_current_offset);
    setpv('irm:073:ADC1.ESLO', IRM_ESLO);
catch
    fprintf('  Trouble setting cmm:beam_current offset factor to %.02d\n', cmm_beam_current_offset);
end


fprintf('  28. Setting HCM and VCM monitor ESLO & EOFF to corrector SP-AM discrepancies\n');
try
    % AM calibration
    HCMCalibration;
    VCMCalibration;
catch
    fprintf('  Trouble setting HCM and VCM monitor ESLO & EOFF\n');
end

fprintf('  29. Setting Gun BIAS limit to 18 for two-bunch mode, 23.7 for all other modes.\n');
try    
    if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
        setpvonline('EG______BIAS___AC01.DRVL',18);
    else
        setpvonline('EG______BIAS___AC01.DRVL',23.7);
    end
catch
    fprintf('  Trouble setting EG______BIAS___AC01.DRVL\n');
end
fprintf('  HWINIT is done restoring machine defaults.\n');


% EEBI Initialization
try
    fprintf('   30. Arm the EPBI waveform recorder ... ');
    setpv('EPBI_TR_ARM_BC', 1);
    fprintf('Done\n');
catch
    fprintf(2, '\n      Error arming the EPBI waveform recorder.\n\n');
end


% % BPM Initialization
% try
%     RFAttn500 = 13;
% 
%     %if getdcct < .2
%         fprintf('   31. Initializing the new BPMs for 500 mA ... ');
%         bpminit(RFAttn500);
%     %else
%     %    fprintf('   31. Initializing the new BPMs ... ');
%     %    bpminit;
%     %end
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n      Error initializing the new BPMs.\n\n');
% end
% 
% 
% % Cell Controller Initialization (Done in bpminit at the moment)
% try
%     fprintf('   32. Initializing the BPM cell controllers ... ');
%     cellcontrollerinit;
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n      Error initializing the BPM cell controllers.\n\n');
% end



function HCMCalibration

% Data from measamlinearity
% SR_HCM_Linearity_2013-03-29_11-29-45
Data = [
 1  2 -0.0036950  0.9994457 -40.00000000   0.001220721752
 1  3  0.0004097  0.9994796 -20.00000000   0.000610360876
 1  4  0.0021789  0.9995157 -20.00000000   0.000610360876
 1  5 -0.0004563  0.9995986 -20.00000000   0.000610360876
 1  6 -0.0009663  0.9996405 -20.00000000   0.000610360876
 1  7 -0.0053980  0.9997579 -40.00000000   0.001220721752
 1  8 -0.0037411  0.9994187 -40.00000000   0.001220721752
 2  1  0.0031092  0.9996939 -40.00000000   0.001220721752
 2  2 -0.0048461  0.9996840 -40.00000000   0.001220721752
 2  3 -0.0018655  0.9995348 -20.00000000   0.000610360876
 2  4  0.0017778  0.9996127 -20.00000000   0.000610360876
 2  5 -0.0005126  0.9999359 -20.00000000   0.000610360876
 2  6  0.0000015  0.9997761 -20.00000000   0.000610360876
 2  7 -0.0059730  0.9997207 -40.00000000   0.001220721752
 2  8 -0.0088330  0.9995275 -40.00000000   0.001220721752
 3  1 -0.0059585  0.9998008 -40.00000000   0.001220721752
 3  2 -0.0004163  0.9998736 -40.00000000   0.001220721752
 3  3  0.0021339  0.9997756 -20.00000000   0.000610360876
 3  4  0.0004170  0.9996059 -20.00000000   0.000610360876
 3  5  0.0008287  0.9997243 -20.00000000   0.000610360876
 3  6  0.0004903  0.9999176 -20.00000000   0.000610360876
 3  7  0.0052154  0.9994387 -40.00000000   0.001220721752
 3  8  0.0020766  0.9996559 -40.00000000   0.001220721752
 3 10 -0.0104376  0.9997000 -20.00000000   0.000610360876
 4  1 -0.0122444  1.0425938 -40.00000000   0.001220721752
 4  2  0.0001012  0.9997433 -40.00000000   0.001220721752
 4  3  0.0002826  0.9995572 -20.00000000   0.000610360876
 4  4  0.0016322  0.9997092 -20.00000000   0.000610360876
 4  5  0.0007073  0.9997207 -20.00000000   0.000610360876
 4  6  0.0020648  0.9996924 -20.00000000   0.000610360876
 4  7 -0.0054662  0.9996019 -40.00000000   0.001220721752
 4  8 -0.0023814  0.9995348 -40.00000000   0.001220721752
 5  1 -0.0021375  0.9996287 -40.00000000   0.001220721752
 5  2  0.0021764  0.9997812 -40.00000000   0.001220721752
 5  3  0.0009077  0.9999075   0.00000000   1.000000000000
 5  5  0.0003385  0.9999044   0.00000000   1.000000000000
 5  6  0.0008231  0.9998586   0.00000000   1.000000000000
 5  7 -0.0034948  0.9997070 -40.00000000   0.001220721752
 5  8 -0.0070705  0.9997670 -40.00000000   0.001220721752
 5 10  0.0145669  0.9880377 -20.00000000   0.000610360876
 6  1  0.0001448  0.9996755 -40.00000000   0.001220721752
 6  2  0.0003608  0.9997719 -40.00000000   0.001220721752
 6  3  0.0023006  0.9996594 -20.00000000   0.000610360876
 6  5  0.0013876  0.9997164 -20.00000000   0.000610360876
 6  6  0.0010382  0.9996198 -20.00000000   0.000610360876
 6  7 -0.0020723  0.9994523 -40.00000000   0.001220721752
 6  8  0.0040695  0.9995716 -40.00000000   0.001220721752
 7  1 -0.0013224  0.9996665 -40.00000000   0.001220721752
 7  2 -0.0013995  0.9997887 -40.00000000   0.001220721752
 7  3 -0.0011087  0.9997715 -20.00000000   0.000610360876
 7  4  0.0139045  0.9994198 -20.00000000   0.000610360876
 7  5  0.0008449  0.9997974 -20.00000000   0.000610360876
 7  6  0.0010173  0.9998030 -20.00000000   0.000610360876
 7  7 -0.0044169  0.9994548 -40.00000000   0.001220721752
 7  8 -0.0019018  0.9996571 -40.00000000   0.001220721752
 8  1 -0.0048137  0.9999815 -40.00000000   0.001220721752
 8  2 -0.0048411  1.0000792 -40.00000000   0.001220721752
 8  3 -0.0025057  0.9995886 -20.00000000   0.000610360876
 8  4 -0.0033205  1.0007354 -20.00000000   0.000610360876
 8  5 -0.0002805  0.9999961 -20.00000000   0.000610360876
 8  6 -0.0000983  0.9997681 -20.00000000   0.000610360876
 8  7 -0.0046499  0.9997992 -40.00000000   0.001220721752
 8  8 -0.0070879  0.9997466 -40.00000000   0.001220721752
 9  1  0.0039552  0.9997830 -40.00000000   0.001220721752
 9  2  0.0011551  0.9996409 -40.00000000   0.001220721752
 9  3  0.0023751  0.9997969 -20.00000000   0.000610360876
 9  4 -0.0012967  0.9995691 -20.00000000   0.000610360876
 9  5 -0.0032335  0.9997671 -20.00000000   0.000610360876
 9  6  0.0008152  0.9998516 -20.00000000   0.000610360876
 9  7 -0.0033093  0.9996987 -40.00000000   0.001220721752
 9  8  0.0028469  0.9991287 -40.00000000   0.001220721752
10  1 -0.0023788  0.9997303 -40.00000000   0.001220721752
10  2 -0.0021151  0.9998066 -40.00000000   0.001220721752
10  3  0.0027210  0.9997779 -20.00000000   0.000610360876
10  4  0.0006025  0.9995758 -20.00000000   0.000610360876
10  5  0.0026864  0.9996819 -20.00000000   0.000610360876
10  6 -0.0015412  0.9997520 -20.00000000   0.000610360876
10  7 -0.0077232  0.9998919 -40.00000000   0.001220721752
10  8 -0.0043791  0.9995416 -40.00000000   0.001220721752
10 10  0.7064685  1.0012752 -20.00000000   0.000610360876
11  1  0.0293812  0.9998477 -40.00000000   0.001220721752
11  2 -0.0019937  0.9996853 -40.00000000   0.001220721752
11  3 -0.0019273  0.9965946 -20.00000000   0.000610360876
11  4 -0.0018103  0.9997686 -20.00000000   0.000610360876
11  5 -0.0027207  0.9998356 -20.00000000   0.000610360876
11  6  0.0028017  0.9999368 -20.00000000   0.000610360876
11  7 -0.0003000  0.9997180 -40.00000000   0.001220721752
11  8  0.0023093  0.9998754 -40.00000000   0.001220721752
12  1 -0.0051096  0.9998206 -40.00000000   0.001220721752
12  2  0.0050635  0.9996827 -40.00000000   0.001220721752
12  3  0.0017515  0.9996516 -20.00000000   0.000610360876
12  4  0.0019484  0.9995782 -20.00000000   0.000610360876
12  5 -0.0022358  0.9993932 -20.00000000   0.000610360876
12  6  0.0004534  0.9995219 -20.00000000   0.000610360876
12  7 -0.0019937  0.9996299 -40.00000000   0.001220721752
];


% Remove the Caens and [10 10] had a large offset -- not sure why
DevCaens = [5 3;5 5;5 6;10 10];
i = findrowindex(DevCaens, Data(:,1:2));
Data(i,:) = [];

Offset = -1 * Data(:,3) ./  Data(:,4);
Slope  =  1 ./  Data(:,4);

% LINR = SLOPE (1)
% ao (AC):  RVAL = (VAL - EOFF) / ESLO
% ai (AM): 	VAL = RVAL * ESLO + EOFF

% ai (AM): 	VAL = RVAL * ESLO + EOFF

%a = getpv(family2channel('HCM','Monitor',Data(:,1:2)),'EOFF');
setpv(family2channel('HCM','Monitor',Data(:,1:2)),'EOFF', Slope .* Data(:,5) + Offset);
setpv(family2channel('HCM','Monitor',Data(:,1:2)),'ESLO', Slope .* Data(:,6));

% Restore
%setpv(family2channel('HCM','Monitor',Data(:,1:2)),'EOFF', Data(:,5));
%setpv(family2channel('HCM','Monitor',Data(:,1:2)),'ESLO', Data(:,6));

% Convert to MML 
%Offset = Data(:,3) ./ Data(:,4);
%Gain   = 1 ./ Data(:,4);
%DeviceList = Data(:,1:2);



function [Gain, Offset, DeviceList] = VCMCalibration


% Data from measamlinearity
% SR_VCM_Linearity_2013-03-29_13-00-03
Data = [
 1  2 -0.0121128  1.0118267 -120.00000000   0.003662170000
 1  4 -0.0016863  0.9995326 -20.00000000   0.000610360000
 1  5  0.0012440  0.9994822 -20.00000000   0.000610360000
 1  7 -0.0128360  1.0118769 -120.00000000   0.003662170000
 1  8 -0.0339339  1.0109004 -120.00000000   0.003662170000
 2  1 -0.0026076  1.0116852 -120.00000000   0.003662170000
 2  2 -0.0080077  1.0122830 -120.00000000   0.003662170000
 2  4  0.0021680  0.9999250 -20.00000000   0.000610360000
 2  5  0.0033868  0.9996921 -20.00000000   0.000610360000
 2  7 -0.0095687  1.0118460 -120.00000000   0.003662170000
 2  8 -0.0071815  1.0126200 -120.00000000   0.003662170000
 3  1 -0.0009456  1.0117602 -120.00000000   0.003662170000
 3  2 -0.0152887  1.0126155 -120.00000000   0.003662170000
 3  4 -0.0000998  0.9997392 -20.00000000   0.000610360000
 3  5  0.0007695  0.9999310 -20.00000000   0.000610360000
 3  7 -0.0051534  1.0141227 -120.00000000   0.003662170000
 3  8 -0.0503995  1.0080299 -120.00000000   0.003662170000
 3 10 -0.0171016  1.0004878 -20.00000000   0.000610360000
 4  1 -0.0119622  1.0139394 -120.00000000   0.003662170000
 4  2 -0.0069809  1.0122928 -120.00000000   0.003662170000
 4  4  0.0003972  0.9995287 -20.00000000   0.000610360000
 4  5 -0.0012068  0.9996867 -20.00000000   0.000610360000
 4  7 -0.0045539  1.0131919 -120.00000000   0.003662170000
 4  8 -0.0086309  1.0128215 -120.00000000   0.003662170000
 5  1 -0.0006663  1.0133528 -120.00000000   0.003662170000
 5  2 -0.0108866  1.0134645 -120.00000000   0.003662170000
 5  4  0.0013663  0.9996929 -20.00000000   0.000610360000
 5  5  0.0009534  0.9995922 -20.00000000   0.000610360000
 5  7 -0.0118184  1.0141468 -120.00000000   0.003662170000
 5  8 -0.0134278  1.0125580 -120.00000000   0.003662170000
 5 10  0.0105835  0.9997492 -20.00000000   0.000610360000
 6  1  0.0015235  1.0127243 -120.00000000   0.003662170000
 6  2  0.0013968  1.0126536 -120.00000000   0.003662170000
 6  4  0.0004830  0.9996553 -20.00000000   0.000610360000
 6  5  0.0023525  0.9998106 -20.00000000   0.000610360000
 6  7 -0.0052321  1.0129656 -120.00000000   0.003662170000
 6  8  0.0002531  1.0126529 -120.00000000   0.003662170000
 7  1 -0.0011591  1.0135454 -120.00000000   0.003662170000
 7  2  0.0061577  1.0132941 -120.00000000   0.003662170000
 7  4 -0.0012683  0.9997082 -20.00000000   0.000610360000
 7  5 -0.0019386  0.9997769 -20.00000000   0.000610360000
 7  7 -0.0052338  1.0137174 -120.00000000   0.003662170000
 7  8 -0.0102230  1.0065450 -120.00000000   0.003662170000
 8  1 -0.0131591  1.0136563 -120.00000000   0.003662170000
 8  2 -0.0113685  1.0126721 -120.00000000   0.003662170000
 8  4  0.0021907  0.9997066 -20.00000000   0.000610360000
 8  5  0.0014502  0.9997617 -20.00000000   0.000610360000
 8  7 -0.0154160  1.0121704 -120.00000000   0.003662170000
 8  8 -0.0213588  1.0135911 -120.00000000   0.003662170000
 9  1 -0.0327264  1.0103709 -120.00000000   0.003662170000
 9  2 -0.0210116  1.0125015 -120.00000000   0.003662170000
 9  4 -0.0020751  0.9998151 -20.00000000   0.000610360000
 9  5 -0.0002347  0.9998948 -20.00000000   0.000610360000
 9  7 -0.0256814  1.0104833 -120.00000000   0.003662170000
 9  8 -0.0797548  1.0102850 -120.00000000   0.003662170000
10  1 -0.0035601  1.0124973 -120.00000000   0.003662170000
10  2 -0.0097402  1.0113781 -120.00000000   0.003662170000
10  4  0.0011942  0.9996645 -20.00000000   0.000610360000
10  5 -0.0086246  0.9996688 -20.00000000   0.000610360000
10  7 -0.0250130  1.0122191 -120.00000000   0.003662170000
10  8 -0.0329862  1.0116856 -120.00000000   0.003662170000
10 10 -0.0103018  1.0004670 -20.00000000   0.000610360000
11  1 -0.0015596  1.0123087 -120.00000000   0.003662170000
11  2  0.0006771  1.0109205 -120.00000000   0.003662170000
11  4 -0.0008596  0.9998379 -20.00000000   0.000610360000
11  5  0.0001821  0.9997759 -20.00000000   0.000610360000
11  7  0.0026106  1.0135402 -120.00000000   0.003662170000
11  8  0.0015636  1.0129365 -120.00000000   0.003662170000
12  1 -0.0083779  1.0102633 -120.00000000   0.003662170000
12  2 -0.0178374  1.0110131 -120.00000000   0.003662170000
12  4 -0.0007605  0.9997483 -20.00000000   0.000610360000
12  5  0.0003062  1.0000766 -20.00000000   0.000610360000
12  7 -0.0079261  1.0110363 -120.00000000   0.003662170000
];

Offset = -1 * Data(:,3) ./  Data(:,4);
Slope  =  1 ./  Data(:,4);

% LINR = SLOPE (1)
% ao (AC):  RVAL = (VAL - EOFF) / ESLO
% ai (AM): 	VAL = RVAL * ESLO + EOFF

% ai (AM): 	VAL = RVAL * ESLO + EOFF


setpv(family2channel('VCM','Monitor',Data(:,1:2)),'EOFF',  Slope .* Data(:,5) + Offset);
setpv(family2channel('VCM','Monitor',Data(:,1:2)),'ESLO',  Slope .* Data(:,6));

% Restore
%setpv(family2channel('VCM','Monitor',Data(:,1:2)),'EOFF', Data(:,5));
%setpv(family2channel('VCM','Monitor',Data(:,1:2)),'ESLO', Data(:,6));


function init_bclean_tfb(varargin)
% function init_bclean_tfb(varargin)
%

try
    PseudoSingleBunch = getfamilydata('PseudoSingleBunch');
    setpvonline('IGPF:TFBX:CLEAN:AMPL',1);
    setpvonline('IGPF:TFBX:CLEAN:SPAN',0.04);
    setpvonline('IGPF:TFBX:CLEAN:PERIOD',23000);
    if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
        setpvonline('IGPF:TFBX:CLEAN:PATTERN','156:161 320:325');
    elseif ~isempty(PseudoSingleBunch) && strcmpi(PseudoSingleBunch,'On')
        setpvonline('IGPF:TFBX:CLEAN:PATTERN','320:328');
    elseif getpv('Physics10')==2   % single cam bucket, short gap
        setpvonline('IGPF:TFBX:CLEAN:PATTERN','297:303 320:325');
    elseif getpv('Physics10')==3   % single cam bucket in 308, short gap
        setpvonline('IGPF:TFBX:CLEAN:PATTERN','297:303 310:315');
    else
        setpvonline('IGPF:TFBX:CLEAN:PATTERN','153:157 320:325');
    end
catch
    disp('Error initializing TFBX for bunch cleaning')
end

return
