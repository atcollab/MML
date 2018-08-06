function setlocodata(CommandInput, FileName)
%SETLOCODATA - Applies the LOCO calibration data to both the middle layer & the accelerator
%  setlocodata(CommandInput, FileName)
%
%  INPUTS
%  1. CommandInput 
%     'Nominal'    - Sets nominal gains (1) / rolls (0) to the model.
%     'Default'    - Transfer the default gains/roll setting to the Middle 
%                    Layer (Note: usually these come from a PhysData file, 
%                                 but not all accelerators use a PhysData file).
%     'SetGains'   - Set gains/coupling from a LOCO file.
%     'Symmetrize' - Symmetry correction of the lattice based on a LOCO file.
%     'CorrectCoupling' - Coupling correction of the lattice based on a LOCO file.
%     'SetModel'   - Set the model from a LOCO file.  But it only changes
%                    the part of the model that does not get corrected
%                    in 'Symmetrize' (also does a SetGains).
%     'LOCO2Model' - Set the model from a LOCO file (also does a SetGains).
%                    This sets all lattice machines fit in the LOCO run to the model.
%
%  NOTES
%  How one uses this function depends on how LOCO was setup.
%  1. Use setlocodata('Nominal') if no model calibration information is known.
%  2. The most typical situation is to apply:
%         setlocodata('Symmetrize') to the accelerator
%         setlocodata('SetModel')   to the middle layer (usually done in setoperationalmode)
%  3. If a LOCO run was done on the present lattice with no changes made to lattice
%     after LOCO run, then setting all the LOCO fits to the model makes sense.
%         setlocodata('LOCO2Model') 
%  4. This function is obviously very machine dependent.
%
%  Written by Greg Portmann


global THERING

if nargin < 1
    %CommandInput = 'Default';
    ModeCell = {'Nominal - Set Gain=1 & Rolls=0 in the model', 'Default - Default Gains & Rolls', 'SetGains - Set gains/rolls from a LOCO file','Symmetrize - Symmetry correction of the lattice', 'CorrectCoupling - Coupling correction of the lattice', 'SetModel - Set the model from a LOCO file','LOCO2Model - Set the model from a LOCO file (also does a SetGains)','see "help setlocodata" for more details'};
    [ModeNumber, OKFlag] = listdlg('Name','ALS','PromptString', ...
        'Select the proper LOCO set command:', ...
        'SelectionMode','single', 'ListString', ModeCell);
    if OKFlag ~= 1
        fprintf('   setlocodata cancelled\n');
        return
    end
    if ModeNumber == 1
        CommandInput = 'Nominal';
    elseif ModeNumber == 2
        CommandInput = 'Default';
    elseif ModeNumber == 3
        CommandInput = 'SetGains';
    elseif ModeNumber == 4
        CommandInput = 'Symmetrize';
    elseif ModeNumber == 5
        CommandInput = 'CorrectCoupling';
    elseif ModeNumber == 6
        CommandInput = 'SetModel';
    elseif ModeNumber == 7
        CommandInput = 'LOCO2Model';
    elseif ModeNumber == 8
        help setlocodata;
        return
    end
end

if nargin < 2
    FileName = '';
end



% Device list
BPMxDeviceList = family2dev('BPMx');
BPMxDeviceListTotal = family2dev('BPMx',0);

BPMyDeviceList = family2dev('BPMy');
BPMyDeviceListTotal = family2dev('BPMy',0);

HCMDeviceList = family2dev('HCM');
HCMDeviceListTotal = family2dev('HCM',0);
VCMDeviceList = family2dev('VCM');
VCMDeviceListTotal = family2dev('VCM',0);



if any(strcmpi(CommandInput, {'Defaults', 'Default'}))
    fprintf('   Using default BPM and corrector gains in %s.\n', getfamilydata('OpsData','PhysDataFile'));

    % To speed things up, put Gains/Rolls/etc in the AO
    AO = getao;
    AO = getphysdatagains_local(AO);
 

    % Default behavior is what is in physdata.mat
    % Set the roll, crunch to the AT model to be used by getpvmodel, setpvmodel, etc
    setatfield('BPMx', 'GCR', [AO.BPMx.Gain AO.BPMy.Gain AO.BPMx.Crunch AO.BPMx.Roll], BPMxDeviceListTotal);

    % Set the gains to the AT model to be used by getpvmodel, setpvmodel, etc
    % Make sure the Roll field is 1x2 even for single plane correctors

    % First set the cross planes to zero
    setatfield('HCM', 'Roll', 0*AO.HCM.Roll, HCMDeviceListTotal, 1, 2);
    setatfield('VCM', 'Roll', 0*AO.VCM.Roll, VCMDeviceListTotal, 1, 1);

    % Then set the roll field
    setatfield('HCM', 'Roll', AO.HCM.Roll, HCMDeviceListTotal, 1, 1);
    setatfield('VCM', 'Roll', AO.VCM.Roll, VCMDeviceListTotal, 1, 2);

    setao(AO);

elseif any(strcmpi(CommandInput, 'Nominal'))
    fprintf('   Using nominal BPM and corrector Gain=1 and Roll=0\n');

    % To speed things up, put Gains/Rolls/etc in the AO
    AO = getao;

    % Zero or one the gains and rolls
    AO.BPMx.Gain = ones(size(BPMxDeviceListTotal,1),1);
    AO.BPMy.Gain = ones(size(BPMyDeviceListTotal,1),1);
    AO.BPMx.Roll = zeros(size(BPMxDeviceListTotal,1),1);
    AO.BPMy.Roll = zeros(size(BPMyDeviceListTotal,1),1);
    AO.BPMx.Crunch = zeros(size(BPMxDeviceListTotal,1),1);
    AO.BPMy.Crunch = zeros(size(BPMyDeviceListTotal,1),1);

    AO.HCM.Gain = ones(size(HCMDeviceListTotal,1),1);
    AO.VCM.Gain = ones(size(VCMDeviceListTotal,1),1);
    AO.HCM.Roll = zeros(size(HCMDeviceListTotal,1),1);
    AO.VCM.Roll = zeros(size(VCMDeviceListTotal,1),1);

    
    % Set the roll, crunch to the AT model to be used by getpvmodel, setpvmodel, etc
    setatfield('BPMx', 'GCR', [AO.BPMx.Gain AO.BPMy.Gain AO.BPMx.Crunch AO.BPMx.Roll], BPMxDeviceListTotal);

    % Set the gains to the AT model to be used by getpvmodel, setpvmodel, etc
    % Make sure the Roll field is 1x2 even for single plane correctors

    % First set the cross planes to zero
    setatfield('HCM', 'Roll', 0*AO.HCM.Roll, HCMDeviceListTotal, 1, 2);
    setatfield('VCM', 'Roll', 0*AO.VCM.Roll, VCMDeviceListTotal, 1, 1);

    % Then set the roll field
    setatfield('HCM', 'Roll', AO.HCM.Roll, HCMDeviceListTotal, 1, 1);
    setatfield('VCM', 'Roll', AO.VCM.Roll, VCMDeviceListTotal, 1, 2);

    setao(AO);


elseif any(strcmpi(CommandInput, 'SetGains'))

    error('   Function not complete.  Look at the ALS setlocodata for an example.');

elseif any(strcmpi(CommandInput, 'SetModel'))

    error('   Function not complete.  Look at the ALS setlocodata for an example.');

elseif any(strcmpi(CommandInput, 'SetMachine'))

    error('   Function not complete.  Look at the ALS setlocodata for an example.');

elseif any(strcmpi(CommandInput, 'LOCO2Model'))

    error('   Function not complete.  Look at the ALS setlocodata for an example.');

else

    error('   ');

end



function AO = getphysdatagains_local(AO)

% Device list
BPMxDeviceList = family2dev('BPMx');
BPMxDeviceListTotal = family2dev('BPMx',0);

BPMyDeviceList = family2dev('BPMy');
BPMyDeviceListTotal = family2dev('BPMy',0);

HCMDeviceList = family2dev('HCM');
HCMDeviceListTotal = family2dev('HCM',0);
VCMDeviceList = family2dev('VCM');
VCMDeviceListTotal = family2dev('VCM',0);


% Offsets - No conversion required
% AO.BPMx.Offset = getoffset('BPMx', BPMxDeviceListTotal);
% AO.BPMy.Offset = getoffset('BPMy', BPMyDeviceListTotal);
try
    AO.BPMx.Offset = getphysdata('BPMx', 'Offset', BPMxDeviceListTotal);
catch
    AO.BPMx.Offset = zeros(size(BPMxDeviceListTotal,1),1);
end
try
    AO.BPMy.Offset = getphysdata('BPMy', 'Offset', BPMyDeviceListTotal);
catch
    AO.BPMy.Offset = zeros(size(BPMyDeviceListTotal,1),1);
end

try
    AO.BPMx.Gain = getphysdata('BPMx', 'Gain', BPMxDeviceListTotal);
catch
    AO.BPMx.Gain = ones(size(BPMxDeviceListTotal,1),1);
end
try
    AO.BPMy.Gain = getphysdata('BPMy', 'Gain', BPMyDeviceListTotal);
catch
    AO.BPMy.Gain = ones(size(BPMyDeviceListTotal,1),1);
end

try
    AO.BPMx.Roll = getphysdata('BPMx', 'Roll', BPMxDeviceListTotal);
catch
    AO.BPMx.Roll = zeros(size(BPMxDeviceListTotal,1),1);
end
try
    AO.BPMy.Roll = getphysdata('BPMy', 'Roll', BPMyDeviceListTotal);
catch
    AO.BPMy.Roll = zeros(size(BPMyDeviceListTotal,1),1);
end

try
    AO.BPMx.Crunch = getphysdata('BPMx', 'Crunch', BPMxDeviceListTotal);
catch
    AO.BPMx.Crunch = zeros(size(BPMxDeviceListTotal,1),1);
end
try
    AO.BPMy.Crunch = getphysdata('BPMy', 'Crunch', BPMyDeviceListTotal);
catch
    AO.BPMy.Crunch = zeros(size(BPMyDeviceListTotal,1),1);
end



% Gains used by raw2real, real2raw, etc
% Set the gain/roll to the AO
try
    AO.HCM.Gain = getphysdata('HCM', 'Gain', HCMDeviceListTotal);
catch
    AO.HCM.Gain = ones(size(HCMDeviceListTotal,1),1);
end
try
    AO.HCM.Offset = getphysdata('HCM', 'Offset', HCMDeviceListTotal);
catch
    AO.HCM.Offset = zeros(size(HCMDeviceListTotal,1),1);
end
try
    AO.HCM.Roll = getphysdata('HCM', 'Roll', HCMDeviceListTotal);
catch
    AO.HCM.Roll = zeros(size(HCMDeviceListTotal,1),1);
end

try
    AO.VCM.Gain = getphysdata('VCM', 'Gain', VCMDeviceListTotal);
catch
    AO.VCM.Gain = ones(size(VCMDeviceListTotal,1),1);
end
try
    AO.VCM.Offset = getphysdata('VCM', 'Offset', VCMDeviceListTotal);
catch
    AO.VCM.Offset = zeros(size(VCMDeviceListTotal,1),1);
end
try
    AO.VCM.Roll = getphysdata('VCM', 'Roll', VCMDeviceListTotal);
catch
    AO.VCM.Roll = zeros(size(VCMDeviceListTotal,1),1);
end

