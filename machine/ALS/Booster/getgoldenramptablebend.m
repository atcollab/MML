function [BR_BEND_Ramp_Table] = getgoldenramptablebend
%GETGOLDENRAMPTABLEBEND

% Operations data directory
DirectoryName = getfamilydata('Directory','OpsData');
FileName = [DirectoryName, 'BEND_Ramptable_Golden.mat'];
load(FileName);

