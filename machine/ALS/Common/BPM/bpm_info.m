function bpm_info(Prefix, varargin)
%BPM_INFO - Prints some info on the BPMs to the screeen

if nargin < 1 || isempty(Prefix)
    Prefix = getfamilydata('BPM','BaseName');
end


for i = 1:length(Prefix)
    
    SoftwareVersion = getpvonline([Prefix{i},':softwareRev'], 'char');
    FirmwareVersion = getpvonline([Prefix{i},':firmwareRev'], 'char');
    
    % I-Q or RMS calculation
    RMSFlag = getpvonline([Prefix{i},':buttonDSP'], 'char');
    
    fprintf('  %3d.  %s  Software Ver %s  Firmare Ver %s   %s\n', i, Prefix{i}, SoftwareVersion, FirmwareVersion, RMSFlag);
end


