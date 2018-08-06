function FileName = bpm_meas_staticgain_dualtone(Dev)
% Static Gain Calibration - Matlab script for measurement of static gain 0 to 31 dB range.
%
%
% See also bpm_writefile_attn

% NOTES
% * Possible issue with AFE 13


% If linac or ltb mode, change to sr mode, linac & ltb have no FA data!!!
% 1. Parameters.csv -> like SR
% 2. rtTable.csv    -> like SR
% 3. ptTable.csv    -> like SR
% To make a TL BPM just change Parameters.csv to single pass with stripline geometry

%FileName = bpm_meas_staticgain(65, 4)

% Sector 6 -> 3, 12, 38, 40
%FileName = bpm_meas_staticgain(3, 4)


if nargin == 0
    % Do them all
    Dev = family2dev('BPM');
end

if size(Dev,1) > 1
    for iBPM = 1:size(Dev,1)
        FileName{iBPM} = bpm_meas_staticgain_dualtone(Dev(iBPM,:));
    end
    return
end


IP = getfamilydata('BPM', 'IP', Dev);
IP = IP{1};
BaseName = getfamilydata('BPM', 'BaseName', Dev);
BaseName = BaseName{1};
AFE = getfamilydata('BPM', 'AFE', Dev);
Rev = round(10*rem(AFE,1));
AFE = floor(AFE);


% Start time
TimeStampStart = now;
fprintf('\nMeasurement Started at %s\n', datestr(TimeStampStart,31));
DirStart = pwd;

if isstoragering
    DirName = sprintf('/home/als/physdata/BPM/AttnCalibration/SR/%s', datestr(now, 'yyyy-mm-dd'));
else
    DirName = sprintf('/home/als/physdata/BPM/AttnCalibration/Injector/%s', datestr(now, 'yyyy-mm-dd'));
end
gotodirectory(DirName);


% PT Amplitude
if Rev == 2
    % Attn Table  -- Ext Amp, with 6dB in chassis
    %  BPM     PT
    %    0    127    23k ADC Counts
    %   23      0    20k ADC Counts
    %   31      0     8k ADC Counts
    Attn = [[124:-4:0]; [0:31]];
    
else
    % Rev == 3 or 4
    % PT  Attn
    % BPM Attn
    %Attn = [31:-1:0; 0:31];
    Attn = [[12:-1:1 zeros(1,20)]; 0:31];
end

% Starting 
PTA = getpv('BPM', 'PTA', Dev);
PTB = getpv('BPM', 'PTB', Dev);
PTControl = getpvonline([BaseName,':autotrim:control'], 'double');


% First the Attenuation table must be Unity!!!
%bpm_writefile_attn(AFE, Rev, 'Unity');
% PT must be on
setpvonline([BaseName,':autotrim:control'], 3);
% Pilot tone setup
% RF, lower

if strcmpi(BaseName(1:4), 'IDBPM')
    s = str2num(BaseName(12));
else
    s = str2num(BaseName(10));
end
%PTAttnPV = sprintf('%s:CC:pt%dAtten', BaseName(1:4), s);
PTAttnPV = family2channel('BPM','PTAttn', Dev);

% Set Frequencies
%SR01:CC:ptA:Frequency
setpv(sprintf('%s:CC:ptA:Frequency', BaseName(1:4)), 1);
setpv(sprintf('%s:CC:ptB:Frequency', BaseName(1:4)), 3);

% Set to CMOS output
%setpv(sprintf('%s:CC:ptA%dOutput', BaseName(1:4), s), 1);
%setpv(sprintf('%s:CC:ptB%dOutput', BaseName(1:4), s), 1);
setpv('BPM', 'PTA', 1, Dev);
setpv('BPM', 'PTB', 1, Dev);

% Set pilot tone magnitude
setpvonline(PTAttnPV, Attn(1,1));

% Setup the BPM
bpm_setenv(BaseName, Attn(2,1), 0);
ENV = bpm_getenv(BaseName);

rfMagPV = [
    [BaseName,':ADC0:rfMag     ']
    [BaseName,':ADC1:rfMag     ']
    [BaseName,':ADC2:rfMag     ']
    [BaseName,':ADC3:rfMag     ']
];


ptHiMagPV = [
    [BaseName,':ADC0:ptHiMag   ']
    [BaseName,':ADC1:ptHiMag   ']
    [BaseName,':ADC2:ptHiMag   ']
    [BaseName,':ADC3:ptHiMag   ']
];


ptLoMagPV = [
    [BaseName,':ADC0:ptLoMag   ']
    [BaseName,':ADC1:ptLoMag   ']
    [BaseName,':ADC2:ptLoMag   ']
    [BaseName,':ADC3:ptLoMag   ']
];

GainPV = [
    [BaseName,':ADC0:gainFactor']
    [BaseName,':ADC1:gainFactor']
    [BaseName,':ADC2:gainFactor']
    [BaseName,':ADC3:gainFactor']
];


pause(2);   % Just so the tone & BPM are in steady state 

for i = 1:size(Attn,2)
    fprintf('%2d. PT Attn %3d   BPM Attn %2d   %s\n', i, Attn(1,i), Attn(2,i), datestr(now, 31));
    
    % Set pilot tone magnitude
    setpvonline(PTAttnPV, Attn(1,i));
    
    % BPM Attn - if different
    if getpvonline([BaseName,':attenuation']) ~= Attn(2,i)
        setpvonline([BaseName,':attenuation'], Attn(2,i));
        pause(3);    % ???
    end
    
    pause(1.0)

    a = getpvonline([rfMagPV; ptLoMagPV; ptHiMagPV; GainPV], 0:.1:2);
    a = mean(a,2);
    rfMag(:,i)   = a( 1:4);
    ptLoMag(:,i) = a( 5:8);
    ptHiMag(:,i) = a( 9:12);
    Gain(:,i)    = a(13:16);

end

% Set to PT as the start
setpv('BPM', 'PTA', PTA, Dev);
setpv('BPM', 'PTB', PTB, Dev);
setpvonline([BaseName,':autotrim:control'], PTControl);


TimeStamp = now;
FileName = sprintf('Attenuation_AFE2_Rev%d_SN%03d', Rev, AFE);


% Save data to .csv file recognizable by the BPM
FileNameCSV = [FileName, '.csv'];
fid = fopen(FileNameCSV, 'w');
for i = 1:size(Gain,2)
    fprintf(fid, '%.5f,%.5f,%.4f,%.4f\n', Gain(:,i)');
end
fprintf('   Data saved to %s\n', FileName);
fclose(fid);
clear a ans

% Save with timestamp
FileName = appendtimestamp(FileName, TimeStamp);

% Save data to .csv file recognizable by the BPM
FileNameCSV = [FileName, '.csv'];
fid = fopen(FileNameCSV, 'w');
for i = 1:size(Gain,2)
    fprintf(fid, '%.5f,%.5f,%.4f,%.4f\n', Gain(:,i)');
end
fprintf('   Data saved to %s\n', FileName);
fclose(fid);

Gain'

% Add date to mat file
save(FileName);
cd(DirStart);


