%this script reads in GoldenConfig for nominal optics and uses as a
%template to generate GoldenConfig for doublewaist optics

% first run initcrpc with double waist configuration e.g. setoperationalmode(7) in spear3init

load GoldenConfig
quadnames={'QF' 'QD' 'QFC' 'QDX' 'QFX' 'QDY' 'QFY' 'QDZ' 'QFZ' 'QDW'};

switch2sim

for ii=1:length(quadnames)
    rmfield(ConfigSetpoint,quadnames{ii});
    ConfigSetpoint.(quadnames{ii})=getsp(quadnames{ii},'struct');    
    rmfield(ConfigMonitor,quadnames{ii});
    ConfigMonitor.(quadnames{ii})=getsp(quadnames{ii},'struct');
end

ConfigSetpoint
ConfigMonitor

% cd R:\Controls\matlab\acceleratorcontrol\spear3opsdata\DoubleWaist05
% save 'GoldenConfig' ConfigSetpoint ConfigMonitor
