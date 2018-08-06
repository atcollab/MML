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


% Default families
HBPMFamily = gethbpmfamily;
VBPMFamily = getvbpmfamily;
HCMFamily = gethcmfamily;
VCMFamily = getvcmfamily;


% Device list
BPMxDeviceList = family2dev(HBPMFamily);
BPMxDeviceListTotal = family2dev(HBPMFamily,0);
BPMyDeviceList = family2dev(VBPMFamily);
BPMyDeviceListTotal = family2dev(VBPMFamily,0);

HCMDeviceList = family2dev(HCMFamily);
HCMDeviceListTotal = family2dev(HCMFamily,0);
VCMDeviceList = family2dev(VCMFamily);
VCMDeviceListTotal = family2dev(VCMFamily,0);



if any(strcmpi(CommandInput, {'Defaults', 'Default'}))

    % Just set to nominal for now
    setlocodata('Nominal');

elseif any(strcmpi(CommandInput, 'Nominal'))
    fprintf('   Using nominal BPM and corrector Gain=1 and Roll=0\n');

    % To speed things up, put Gains/Rolls/etc in the AO
    AO = getao;

    % Zero or one the gains and rolls
    AO.(HBPMFamily).Gain = ones(size(BPMxDeviceListTotal,1),1);
    AO.(VBPMFamily).Gain = ones(size(BPMyDeviceListTotal,1),1);
    AO.(HBPMFamily).Roll = zeros(size(BPMxDeviceListTotal,1),1);
    AO.(VBPMFamily).Roll = zeros(size(BPMyDeviceListTotal,1),1);
    AO.(HBPMFamily).Crunch = zeros(size(BPMxDeviceListTotal,1),1);
    AO.(VBPMFamily).Crunch = zeros(size(BPMyDeviceListTotal,1),1);

    AO.(HCMFamily).Gain = ones(size(HCMDeviceListTotal,1),1);
    AO.(VCMFamily).Gain = ones(size(VCMDeviceListTotal,1),1);
    AO.(HCMFamily).Roll = zeros(size(HCMDeviceListTotal,1),1);
    AO.(VCMFamily).Roll = zeros(size(VCMDeviceListTotal,1),1);

    
    % Set the roll, crunch to the AT model to be used by getpvmodel, setpvmodel, etc
    setatfield(HBPMFamily, 'GCR', [AO.(HBPMFamily).Gain AO.(VBPMFamily).Gain AO.(HBPMFamily).Crunch AO.(HBPMFamily).Roll], BPMxDeviceListTotal);

    % Set the gains to the AT model to be used by getpvmodel, setpvmodel, etc
    % Make sure the Roll field is 1x2 even for single plane correctors

    % First set the cross planes to zero
    setatfield(HCMFamily, 'Roll', 0*AO.(HCMFamily).Roll, HCMDeviceListTotal, 1, 2);
    setatfield(VCMFamily, 'Roll', 0*AO.(VCMFamily).Roll, VCMDeviceListTotal, 1, 1);

    % Then set the roll field
    setatfield(HCMFamily, 'Roll', AO.(HCMFamily).Roll, HCMDeviceListTotal, 1, 1);
    setatfield(VCMFamily, 'Roll', AO.(VCMFamily).Roll, VCMDeviceListTotal, 1, 2);

    setao(AO);


elseif any(strcmpi(CommandInput, 'SetGains'))

    error('   Function not complete.  Look at the ALS setlocodata for an example.');

elseif any(strcmpi(CommandInput, 'SetModel'))

    error('   Function not complete.  Look at the ALS setlocodata for an example.');

elseif any(strcmpi(CommandInput, 'SetMachine'))

    error('   Function not complete.  Look at the ALS setlocodata for an example.');

else

    error('   ');

end



