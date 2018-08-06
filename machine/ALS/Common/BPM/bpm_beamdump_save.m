function bpm_beamdump_save
%BPM_BEAMDUMP_SAVE
%
% Also see bpm_beamdump_plot

BeamDumpDir  = '/home/physdata/BeamDump/';

% Note: SR01C:BPM4 is being used for testing.  Typically in a split mode. 
% Note: SR06C:BPM8 is being used for a tune measurement system, hence should ignor here for TBT (ADC & FA ok)

Prefix = getfamilydata('BPM','BaseName');
for i = length(Prefix):-1:1
    if strcmpi(Prefix{i}, 'SR06C:BPM7') || strcmpi(Prefix{i}, 'SR01C:BPM4')
        Prefix(i) = [];
    end
end


for i = 1:length(Prefix)
    ADC{i} = bpm_getadc(Prefix{i}, 20000, 0);
    TBT{i} = bpm_gettbt(Prefix{i}, 20000, 0);
    FA{i}  = bpm_getfa( Prefix{i}, 20000, 0);
    ENV{i} = bpm_getenv(Prefix{i});
    
    Ts(i,1) = TBT{i}.Ts(1);
    fprintf('%s   %s  %s\n', TBT{i}.Prefix, ADC{i}.TsStr(1,:), TBT{i}.TsStr(1,:));
end
% Warning on not all time stamps equal???

FileName = fullfile(BeamDumpDir, 'BeamDump');
FileName = appendtimestamp(FileName, ADC{1}.Ts(1,1));

save(FileName, 'ADC', 'TBT', 'FA', 'ENV', 'Prefix');

fprintf('   Saved data to %s\n', FileName);

