function [BR_QF_Ramp_Table, BR_QD_Ramp_Table] = getramptablequad
%GETRAMPTABLEQUAD

BR_QF_Ramp_Table = lcaGet('BR1:QF:RAMPSET', 131072, 'int32');
% BR_QF_Ramp_Voltage = lcaGet('BR1:QF:RAMPI',   131072, 'int32');

BR_QD_Ramp_Table = lcaGet('BR1:QD:RAMPSET', 131072, 'int32');
