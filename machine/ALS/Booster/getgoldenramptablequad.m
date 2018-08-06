function [BR_QF_Ramp_Table, BR_QD_Ramp_Table] = getgoldenramptablequad
%GETGOLDENRAMPTABLEQUAD

% Operations data directory
DirectoryName = getfamilydata('Directory','OpsData');
FileName = [DirectoryName, 'QF_Ramptable_Golden.mat'];
load(FileName);

FileName = [DirectoryName, 'QD_Ramptable_Golden.mat'];
load(FileName);


% Christoph's comments:
% Data.Data(:,1)=125*(BENDwave*10/2^23)*1.23395+19.35;
% Data.Data(:,2)=60*(QFwave*10/2^23)*1.2275+9.45;
% Data.Data(:,3)=60*(QDwave*10/2^23)*1.228+9.53;
% 
% However, particularly the offset is pretty controller dependent (maybe
% the ADC offsets are not calibrated in the firmware?) and since there
% have been controller swaps in the last 6 months, this might not be
% accurate anymore.
% 
% In terms of the setpoint waveforms:
% All setpoint waveforms are postive (except for a very small negative
% offset of the first value(s) for one of them). The minimum ramptable
% value of the bend is 4.2e4, for the qf 1.0e5 and for the qd -4.6e4.
% The maximum ramptable value of the bend is 6.9e6, qf 5.6e6 and qd
% 6.7e6.
% 
% The power supply scale factors (BR1_____QF_PSGNAC00, ...) when we shut
% down on Monday (6-13-2011) were: Bend 0.5324, QF 0.9653. QD 0.8701.
