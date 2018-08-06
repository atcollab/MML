function setlocodata(CommandInput, FileName)
%SETLOCODATA - Puts the BPM and correctors gain in the middle layer AO
%  setlocodata(CommandInput, LOCOFileName)
%  setlocodata is the same as setlocodata('Default')
%  setlocodata(LOCOFileName)
%
%  INPUTS
%  1. CommandInput 
%       'Default'    - Transfer the ALSPhysData file gains/coupling setting 
%                      to the Middle Layer.
%       'Nominal'    - Use nomial gains (1) / coupling (0) setting.
%       'SetGains'   - Set gains/coupling from a LOCO file.
%       'SetMachine' - Set the accelerator from a LOCO file.
%       'SetModel'   - Set the model from a LOCO file.  But it only changes
%                      the part of the model that does not get corrected
%                      in 'SetMachine' (Also does a SetGains).
%       'LOCO2Model' - Set the model from a LOCO file (Also does a SetGains).
%
%  Written by Greg Portmann

global THERING

if nargin < 1
    CommandInput = 'Default';
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
    fprintf('   Using nominal BPM and corrector gains (1) and rolls (0).\n');

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

    % Magnet gains set to unity (rolls are set in the AT model)
    AO.QF.Gain = ones(size(family2dev('QF',0),1),1);
    AO.QD.Gain = ones(size(family2dev('QD',0),1),1);
    AO.QFC.Gain = ones(size(family2dev('QFC',0),1),1);
    AO.QFX.Gain = ones(size(family2dev('QFX',0),1),1);
    AO.QDX.Gain = ones(size(family2dev('QDX',0),1),1);
    AO.QFY.Gain = ones(size(family2dev('QFY',0),1),1);
    AO.QDY.Gain = ones(size(family2dev('QDY',0),1),1);
    AO.QFZ.Gain = ones(size(family2dev('QFZ',0),1),1);
    AO.QDZ.Gain = ones(size(family2dev('QDZ',0),1),1);

    AO.SF.Gain = ones(size(family2dev('SF',0),1),1);
    AO.SD.Gain = ones(size(family2dev('SD',0),1),1);
    AO.SFM.Gain = ones(size(family2dev('SFM',0),1),1);
    AO.SDM.Gain = ones(size(family2dev('SDM',0),1),1);

    
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

    if isempty(FileName)
        [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?');
        if FileName == 0
            fprintf('   setlocodata canceled\n');
            return
        end
        FileName = [DirectoryName FileName];
    end

    setlocooutput(FileName);

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


% Golden orbit
try
    AO.BPMx.Golden = getphysdata('BPMx', 'Golden', BPMxDeviceListTotal);
catch
    AO.BPMx.Golden = zeros(size(BPMxDeviceListTotal,1),1);
end
try
    AO.BPMy.Golden = getphysdata('BPMy', 'Golden', BPMyDeviceListTotal);
catch
    AO.BPMy.Golden = zeros(size(BPMyDeviceListTotal,1),1);
end


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

