function setboosterrampiepower(IPNumber, N, Waveform, ScaleSet, OffsetSet, FileName)
%SETBOOSTERRAMPIEPOWER - Set the EI Power booster ramp table
%  
%  INPUTS
%  1. IPNumber  - '131.243.89.92' for QF
%                 '131.243.89.93' for BEND {Default}
%  2. N         - Number of points {Default: 50000}
%  3. Waveform  - Waveform in amperes
%  4. ScaleSet  - {Default: 65535}
%  5. OffsetSet - {Default: 0}
%  6. FileName  - {Default: '~alsbase/IEPower/programs/NewRamp.data'}
%
%
%  OUTPUTS
%  For now, the output is a file
%
%  See also setboosterramprf, setboosterrampsf, setboosterrampsd
%


if nargin == 0
    % BEND
    IPNumber = '131.243.89.93';
end

if strcmpi(IPNumber, '131.243.89.92')
    % QD
    MaxAmps = 600;
elseif strcmpi(IPNumber, '131.243.89.93')
    % BEND
    MaxAmps = 1250;
else
    error('IP number unknown');
end

if nargin < 4
    ScaleSet = 65535;
end

if nargin < 5
    OffsetSet = 0;
end

if nargin < 6
    FileName = '~alsbase/IEPower/programs/NewRamp.data';
end


% I'm not sure OffsetSet is programmed correctly yet???
if OffsetSet ~= 0
    error('OffsetSet is programmed yet!');
end
    

if nargin < 3
    fid = fopen('~alsbase/IEPower/programs/test.data', 'rb', 'ieee-le');
    Waveform = fread(fid, 'int16');  % 0-32768
    fclose(fid);
    
    % Convert to amperes
    Waveform = MaxAmps * (Waveform-OffsetSet) / ScaleSet;

    %Amp = 100;
    %Waveform = Amp * triang(Npts);
end

if nargin < 2
    Npts = 50000;
else
    Npts = length(Waveform);
end

% Done with input checking 



% Convert waveform to 0-32768 integer
Waveform = ScaleSet*Waveform/MaxAmps + OffsetSet;


    
% Make a table
%t = linspace(0, T, Npts);
Waveform = Waveform(1:15:end);
if length(Waveform) ~= Npts
    % Stretch or shrink the waveform
    w1 = Waveform(1);
    WaveformOld = Waveform-w1;
    N = length(WaveformOld);
    Waveform = resample(WaveformOld, Npts, N, 20);
    Waveform = Waveform + w1;
    
    subplot(2,1,1);
    plot(Waveform);
    ylabel('New Waveform');
    axis tight;
    subplot(2,1,2);
    plot(WaveformOld);
    ylabel('Old Waveform');
    axis tight
else
    % Plot
    plot(Waveform);
    %xlabel('Time [Seconds]');
    %ylabel('[Volts]');
    title(sprintf('Waveform, %d Points in Table', Npts));
end


% % Last chance to say no
% tmp = questdlg('Change the booster ramp table?','setboosterrampiepower','Yes','No','No');
% if ~strcmpi(tmp,'Yes')
%     fprintf('   No change made to booster ramp table.\n');
%     return
% end

fprintf('   ScaleSet  = %d\n', ScaleSet);
fprintf('   OffsetSet = %d\n', OffsetSet);


% Negative value check
if any(Waveform<0)
    error('Waveform has %d points less than zero.', length(Waveform<0));
end


% Write as 16-bit, signed int, little endian
fid = fopen(FileName, 'wb', 'ieee-le');
fwrite(fid, Waveform, 'int16');  % 0-32768
fclose(fid);


