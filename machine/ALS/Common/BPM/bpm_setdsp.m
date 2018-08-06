function bpm_setdsp(DSPFlag, Prefix)

% I-Q -> 0
% RMS -> 1

if nargin < 1 || isempty(DSPFlag)
    DSPFlag = 0;
end

if nargin < 2 || isempty(Prefix)
    Prefix = getfamilydata('BPM','BaseName');
end

if ~iscell(Prefix)
    Prefix = mat2cell(Prefix);
end

for i = 1:length(Prefix)
    setpvonline([Prefix{i},':buttonDSP'], DSPFlag);
end


% Prefix{1} = 'SR01C:BPM4';
% setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
% setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
% setpvonline([Prefix{i},':wfr:FA:arm'],  1);
