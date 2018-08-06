function srinit(DisplayFlag)

if nargin < 1
    DisplayFlag = 'Display';
end


% Set BPM averaging to a .5 second 
T = .5;
setbpmaverages(T);
[N, Trb] = getbpmaverages;
if Trb ~= .5
    fprintf('   Problem setting BPM averaging to %f\n', T);
    fprintf('   The present BPM averaging period is %f\n', Trb);
else
    if strcmpi(DisplayFlag,'Display')
        fprintf('   Setting BPM averaging to %f seconds\n', T);
    end
end


% BPM Calibration
X_AslopeSP = 0;
Y_AslopeSP = 0;
X_AoffsetSP = 0;
Y_AoffsetSP = 0;
X_EslopeSP = 14;
Y_EslopeSP = 16.6;
X_EoffsetSP = 0;
Y_EoffsetSP = 0;


% % New Gain and Offsets
% Xgain   = getphysdata('BPMx', 'HardwareGain');
% Ygain   = getphysdata('BPMy', 'HardwareGain');
% Xoffset = getphysdata('BPMx', 'HardwareOffset');
% Yoffset = getphysdata('BPMy', 'HardwareOffset');
% 
% X_EslopeSP  =   Xgain .* X_EslopeSP;
% Y_EslopeSP  =   Ygain .* Y_EslopeSP;
% X_EoffsetSP = - Xgain .* Xoffset;
% Y_EoffsetSP = - Ygain .* Yoffset;
% 
% 
% if 1
%     % Check
%     X_Aslope  = getpv('BPMx','U.ASLO');
%     Y_Aslope  = getpv('BPMy','V.ASLO');
%     X_Aoffset = getpv('BPMx','U.AOFF');
%     Y_Aoffset = getpv('BPMy','V.AOFF');
%     X_Eslope  = getpv('BPMx','U.ESLO');
%     Y_Eslope  = getpv('BPMy','V.ESLO');
%     X_Eoffset = getpv('BPMx','U.EOFF');
%     Y_Eoffset = getpv('BPMy','V.EOFF');
%     if any(abs(X_Eoffset-X_EoffsetSP) > 1e-4)
%         i = find(abs(X_Eoffset-X_EoffsetSP) > 1e-4);
%         DevList = family2dev('BPMx');
%         if length(i) < 10 
%             for j = 1:length(i)
%                 fprintf('   BPMx(%d,%d) offset calibration does not match what is in spear3physdata.\n', DevList(i(j),:));
%             end
%         else
%             fprintf('   BPMx offset calibration does not match what is in spear3physdata.\n');
%         end
%     end
%     if any(abs(Y_Eoffset-Y_EoffsetSP) > 1e-4)
%         i = find(abs(Y_Eoffset-Y_EoffsetSP) > 1e-4);
%         DevList = family2dev('BPMy');
%         if length(i) < 10 
%             for j = 1:length(i)
%                 fprintf('   BPMy(%d,%d) offset calibration does not match what is in spear3physdata.\n', DevList(i(j),:));
%             end
%         else
%             fprintf('   BPMy offset calibration does not match what is in spear3physdata.\n');
%         end
%     end
%     if any(abs(X_Eslope-X_EslopeSP) > 1e-4)
%         fprintf('   BPMx gain calibration problem.\n');
%     end
%     if any(abs(Y_Eslope-Y_EslopeSP) > 1e-4)
%         fprintf('   BPMy gain calibration problem.\n');
%     end
% else
%     % Do the setpoint change which should have happen on EPICS reboot
%     setpv('BPMx', 'U.ASLO', X_AslopeSP);
%     setpv('BPMy', 'V.ASLO', Y_AslopeSP);
%     setpv('BPMx', 'U.AOFF', X_AoffsetSP);
%     setpv('BPMy', 'V.AOFF', Y_AoffsetSP);
%     setpv('BPMx', 'U.ESLO', X_EslopeSP);
%     setpv('BPMy', 'V.ESLO', Y_EslopeSP);
%     setpv('BPMx', 'U.EOFF', X_EoffsetSP);
%     setpv('BPMy', 'V.EOFF', Y_EoffsetSP);
%     
%     if strcmpi(DisplayFlag,'Display')
%         fprintf('   Set the AOFF/EOFF and ASLO/ESLO on all the good statue BPMs.\n');
%     end
% end

% if 1
%     % BPM(8,5) is a temporary BPM measuring BPM noise
%     X_AslopeSP = 0;
%     Y_AslopeSP = 0;
%     X_AoffsetSP = 0;
%     Y_AoffsetSP = 0;
%     X_EslopeSP  =   1.477 .* 14.0;
%     Y_EslopeSP  =   1.477 .* 16.6;
%     X_EoffsetSP = - 1.477 .* 0;
%     Y_EoffsetSP = - 1.477 .* 0;
%     
%     setpv('BPMx', 'U.ASLO', X_AslopeSP,  [8 5]);
%     setpv('BPMy', 'V.ASLO', Y_AslopeSP,  [8 5]);
%     setpv('BPMx', 'U.AOFF', X_AoffsetSP, [8 5]);
%     setpv('BPMy', 'V.AOFF', Y_AoffsetSP, [8 5]);
%     setpv('BPMx', 'U.ESLO', X_EslopeSP,  [8 5]);
%     setpv('BPMy', 'V.ESLO', Y_EslopeSP,  [8 5]);
%     setpv('BPMx', 'U.EOFF', X_EoffsetSP, [8 5]);
%     setpv('BPMy', 'V.EOFF', Y_EoffsetSP, [8 5]);
%     
%     if strcmpi(DisplayFlag,'Display')
%         fprintf('   Set the AOFF/EOFF and ASLO/ESLO on BPM(8,5).\n');
%     end
% end


% Set BPM golden orbit to UDes and VDes
setepicsdes('BPMx');
setepicsdes('BPMy');
if strcmpi(DisplayFlag,'Display')
    fprintf('   Updating the EPICS UDes and VDes (golden orbit) with the Matlab values.\n');
end

% % Set BPMs to use in the RMS calculation (SPEAR:BPMURMS / SPEAR:BPMVRMS)
% setpv('BPMx','UState',family2status('BPMx',family2dev('BPMx',0)), family2dev('BPMx',0));
% setpv('BPMy','VState',family2status('BPMy',family2dev('BPMy',0)), family2dev('BPMy',0));
% if strcmpi(DisplayFlag,'Display')
%     fprintf('   Updating the EPICS UState and VState with the present good status BPMs.\n');
% end

% Set BPMs to use in the RMS calculation (SPEAR:BPMUSOFBRMS / SPEAR:BPMVSOFBRMS)
setpv('BPMx','USOFBState',family2status('BPMx',family2dev('BPMx',0)), family2dev('BPMx',0));
setpv('BPMy','VSOFBState',family2status('BPMy',family2dev('BPMy',0)), family2dev('BPMy',0));
if strcmpi(DisplayFlag,'Display')
    fprintf('   Updating the EPICS USOFBState and VSOFBState with the present good status BPMs.\n');
end


% Make sure the quadrupole shunt is off
try
    setpv('118-QMS1:CurrSetpt', 0);
    if strcmpi(DisplayFlag,'Display')
        fprintf('   QMS power supply set to zero\n');
    end
    
    % I think 32 is the dummy load???
    setpv('118-QMS1:ChanSelect',32);
catch
    fprintf('   Problem with setting QMS power supply to zero\n');
    fprintf('   %s',lasterr);
end


% Magnet ramp rates
NSteps = 400;
setpv('HCM','CurrInterSteps', NSteps);
setpv('VCM','CurrInterSteps', NSteps);
if strcmpi(DisplayFlag, 'Display')
    fprintf('   Set CurrInterSteps to %d in all corrector magnets\n', NSteps);
end


% Magnet calibration???




if strcmpi(DisplayFlag,'Display')
    fprintf('   SRINIT Complete\n');
end

