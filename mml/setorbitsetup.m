function [BPM, CM, Flags, EVectors] = setorbitsetup(varargin)
%SETORBITSETUP - BPM & CM setup function for setorbitgui
%  [BPM, CM, Flags, EVectors] = setorbitsetup
%
%  See also setorbit, setorbitgui, setorbitdefault  

%  Written by Greg Portmann



BPM.BPMxString = {
    'All BPMs';
    };

BPM.BPMyString = BPM.BPMxString;

BPM.BPMx = {
    family2datastruct(gethbpmfamily, 'Monitor');
    };

BPM.BPMy = {
    family2datastruct(getvbpmfamily, 'Monitor');
    };


CM.HCMString = {
    'All Corrector Magnets';
    };

CM.HCM = {
    family2datastruct(gethcmfamily, 'Setpoint');
    };


CM.VCMString = {
    'All Corrector Magnets';
    };

CM.VCM = {
    family2datastruct(getvcmfamily, 'Setpoint');
    };



EVectors.BPMx = zeros(length(BPM.BPMx),1);
EVectors.BPMy = zeros(length(BPM.BPMy),1);

EVectors.HCM = [
    .5e-2  
    ];

EVectors.VCM = [
    .5e-2
    ];


% Defaults
for i = 1:length(BPM.BPMxString)
    Flags{i}.NIter = 1;
    Flags{i}.GoalOrbit = 'Golden';
    Flags{i}.PlaneFlag = 0;
end
Flags{3}.NIter = Inf;
Flags{4}.NIter = Inf;

