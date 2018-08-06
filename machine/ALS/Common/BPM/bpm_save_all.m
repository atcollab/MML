function bpm_save_all

DataDumpDir  = '/home/physdata/BPM/SRData/';

Prefix = getfamilydata('BPM','BaseName');
ADC = bpm_getadc([], [], 0);
TBT = bpm_gettbt([], [], 0);
FA  = bpm_getfa( [], [], 0);
ENV = bpm_getenv([]);

for i = 1:length(TBT)
    Ts(i,1) = TBT{i}.Ts(1);
    fprintf('%s   %s  %s\n', TBT{i}.PVPrefix, ADC{i}.TsStr(1,:), TBT{i}.TsStr(1,:));
end

BCM = getbcm('Struct');

FileName = fullfile(DataDumpDir, 'BPM');
FileName = appendtimestamp(FileName, ADC{1}.Ts(1,1));

save(FileName, 'ADC', 'TBT', 'FA', 'ENV', 'Prefix', 'BCM');



