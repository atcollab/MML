function [MachineName, MachineType] = whoami
%WHOAMI - Accelerator name
%  [MachineName, MachineType] = whoami
%
%  See also ismachine, isstoragering, isbooster, istransport 


MachineName = getfamilydata('Machine');

MachineType = getfamilydata('MachineType');
