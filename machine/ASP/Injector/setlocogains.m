function setlocogains(CommandInput, FileName)
%SETLOCOGAINS - Puts the BPM and correctors gain in the middle layer AO
%  setlocogains(CommandInput, FileName)
%  setlocogains or setlocogains('Default')
%  setlocogains(LocoFileName)
%  setlocogains('')
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
    AO.QFA.Gain = ones(size(family2dev('QFA',0),1),1);
    AO.QDA.Gain = ones(size(family2dev('QDA',0),1),1);
    AO.QFB.Gain = ones(size(family2dev('QFB',0),1),1);
 
    AO.SFA.Gain = ones(size(family2dev('SFA',0),1),1);
    AO.SFB.Gain = ones(size(family2dev('SFB',0),1),1);
    AO.SDA.Gain = ones(size(family2dev('SDA',0),1),1);
    AO.SDB.Gain = ones(size(family2dev('SDB',0),1),1);

    
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
    error('   Option not programmed yet');


elseif any(strcmpi(CommandInput, 'SetModel'))
    error('   Option not programmed yet');


elseif any(strcmpi(CommandInput, 'LOCO2Model'))
    error('   Option not programmed yet');


elseif any(strcmpi(CommandInput, 'SetMachine'))
    error('   Option not programmed yet');


else

    error('   Unknown option');

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
    AO.BPMx.Golden = getphysdata('BPMx', 'Golden', BPMxDeviceListTotal);
catch
    AO.BPMx.Golden = zeros(size(BPMxDeviceListTotal,1),1);
end
try
    AO.BPMy.Golden = getphysdata('BPMy', 'Golden', BPMyDeviceListTotal);
catch
    AO.BPMy.Golden = zeros(size(BPMyDeviceListTotal,1),1);
end

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
% AO.HCM.Gain = getgain('HCM', HCMDeviceListTotal);
% AO.VCM.Gain = getgain('VCM', VCMDeviceListTotal);
% AO.HCM.Roll = getroll('HCM', HCMDeviceListTotal);
% AO.VCM.Roll = getroll('VCM', VCMDeviceListTotal);
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


try
    AO.QFA.Gain = getphysdata('QFA', 'Gain', family2dev('QFA',0));
catch
    AO.QFA.Gain = ones(size(family2dev('QFA',0),1),1);
end
try
    AO.QFB.Gain = getphysdata('QFB', 'Gain', family2dev('QFB',0));
catch
    AO.QFB.Gain = ones(size(family2dev('QFB',0),1),1);
end
try
    AO.QDA.Gain = getphysdata('QDA', 'Gain', family2dev('QDA',0));
catch
    AO.QDA.Gain = ones(size(family2dev('QDA',0),1),1);
end
try
    AO.SFA.Gain = getphysdata('SFA', 'Gain', family2dev('SFA',0));
catch
    AO.SFA.Gain = ones(size(family2dev('SFA',0),1),1);
end
try
    AO.SFB.Gain = getphysdata('SFB', 'Gain', family2dev('SFB',0));
catch
    AO.SFB.Gain = ones(size(family2dev('SFB',0),1),1);
end
try
    AO.SDA.Gain = getphysdata('SDA', 'Gain', family2dev('SDA',0));
catch
    AO.SDA.Gain = ones(size(family2dev('SDA',0),1),1);
end
try
    AO.SDB.Gain = getphysdata('SDB', 'Gain', family2dev('SDB',0));
catch
    AO.SDB.Gain = ones(size(family2dev('SDB',0),1),1);
end

        
    
   