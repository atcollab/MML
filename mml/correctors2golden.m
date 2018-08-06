function correctors2golden
%CORRECTORS2GOLDEN - Sets the default corrector families to the golden configuration values
%  correctors2golden
%
%  See also vcm2golden, hcm2golden

%  Written by Greg Portmann

FileName = getfamilydata('OpsData', 'LatticeFile');
DirectoryName = getfamilydata('Directory', 'OpsData');

load([DirectoryName FileName]);


HCMFamily = gethcmfamily;
VCMFamily = getvcmfamily;


setpv(ConfigSetpoint.(HCMFamily).Setpoint, 0);
setpv(ConfigSetpoint.(VCMFamily).Setpoint, 0);
