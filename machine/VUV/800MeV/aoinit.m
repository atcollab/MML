function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)

if nargin < 1
    SubMachineName = '800MeV';
end

OperationalMode = 2; % User = 1, Model = 2


if (strcmp(SubMachineName,'800MeV'))
    vuvinit(OperationalMode);
end