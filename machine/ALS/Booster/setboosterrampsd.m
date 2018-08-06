function setboosterrampsd(T, Waveform, TableName, egul, eguf)
%SETBOOSTERRAMPSD - Set the booster SD ramp table
%  setboosterrampsd(T, Waveform, TableName, egul, eguf)
%  setboosterrampsd('Zero') -> Zero the SD table
%  setboosterrampsd('Off') -> Disable SF & SD ramping
%  setboosterrampsd('On')  -> Enable  SF & SD ramping
%  
%  INPUTS
%  1. T         - Time period for the Waveform [seconds]
%                 The maximum period for a 10,000 point table is
%                 2^15*10000*10e-9 = 3.2768 seconds
%  2. Waveform  - SD waveform relative to egul, eguf
%  3. TableName - Optional input to specify a table name [string] 
%  4. egul      - Lower voltage minimum {Default: -6} 
%  5. eguf      - Upper voltage maximum {Default:  6} 
%
%  NOTES
%  1. Calls rampgentableload.c which in turn call the subroutine 
%     rampgenTableLoad.  mex rampgentableload.c will recompile both.
%
%  See also setboosterrampsf, setboosterrampqf, setboosterrampqd, setboosterramprf, setboosterrampbend 

%  Written by Greg Portmann
 
DecimateByTen = 1;

if ispc
    uiwait(warndlg({'Unfortunately the table downloads to the mini-IOC','can only be done on a Unix platform at the moment.','           (I''m working on it.  G. Portmann)'}', 'Booster PS Table Load'));
    return
end


% Time period of the ramp [seconds]
% Tdefault =  .8;  % 1 second ramp period
Tdefault =  0.96;  % 1 second ramp period
% Tdefault = 1.6;  % 2 second ramp period

% This is the default gain to be set, ramptable will be scaled by 1/gain before downloading
GainSP = 0.9;

if nargin < 1
    T = Tdefault;
end


% String commands
DisplayOnly = 0;
DisplayFlag = 1;
if ischar(T)
    if any(strcmpi(T, {'Zero','Zeros','Stop'}))
        setboosterrampsd(.8, zeros(1,10000), 'Zero table set by Matlab', -6, 6);
        return;
    elseif strcmpi(T, 'Off')
        setpv('B0102-5:ENABLE_RAMP', 0);
        setpv('B0202-5:ENABLE_RAMP', 0);
        setpv('B0302-5:ENABLE_RAMP', 0);
        setpv('B0402-5:ENABLE_RAMP', 0);
        fprintf('   Ramping for SF & SD disabled.\n');
        return;
    elseif strcmpi(T, 'On')
        setpv('B0102-5:ENABLE_RAMP', 1);
        setpv('B0202-5:ENABLE_RAMP', 1);
        setpv('B0302-5:ENABLE_RAMP', 1);
        setpv('B0402-5:ENABLE_RAMP', 1);
        fprintf('   Ramping for SF & SD enabled.\n');
        return;
    elseif strcmpi(T, 'DisplayOnly')
        DisplayOnly = 1;
        T = Tdefault;
    elseif strcmpi(T, 'Display')
        DisplayFlag = 1;
        T = Tdefault;
    elseif strcmpi(T, 'NoDisplay')
        DisplayFlag = 0;
        T = Tdefault;
    else
        error('Unknown command');
    end
end


if nargin < 2
    Npts = 10000;
else
    Npts = length(Waveform);
end

if nargin < 3
    TableName = sprintf('SD Table from Matlab (%s)', computer);
end

if nargin < 4
    egul =  -6;
end

if nargin < 5
    eguf =  6;
end

% if nargin < 6
%     % b0101-1.als.lbl.gov for HCM1-2
%     % b0101-3.als.lbl.gov for VCM1-2
%     % b0102-3.als.lbl.gov for HCM2-3
%     % b0102-5.als.lbl.gov for VCM2-3
%     % li14-40.als.lbl.gov for RF
%     % B0102-5.als.lbl.gov for SD
%     % B0102-5.als.lbl.gov for SD
%     IOCName = 'B0102-5.als.lbl.gov';
% end
% 0 for SF
% 1 for SD
Channel = 1;


% Sample period = Ndelay*10 nanosecond
% Ndalay must be an integer < 2^15
Ndelay = T / Npts / 10e-9;

if abs(round(Ndelay) - Ndelay) > 1e-10
    % Only warn on small issues, not really small issues.
    fprintf('   Rounding the number of 10 nsec delay steps to an integer.\n');
end
Ndelay = round(Ndelay);

if Ndelay > (2^15 - 500)   % The 500 is just some margin
    error('The number of delay counts between table points is too large, %d, (greater than 2^15)', Ndelay);
end
    

% Make a table
t = linspace(0, T, Npts);


% For testing
if nargin < 2
    %Amp = .25;    % Amplitude/2 in volts
    %Waveform = Amp - Amp * chirp(t, 8/T/10, 1, 8/T);
    %Waveform = Peak * triang(Npts);

    DC = .59*6* 20/800;    
%    DC = .59*6* 24/800;
    % DC = .59*6* 24/800;
    % DC = .59*6* 38/800;
    
    %Peak = .59*6*610/800;
    if T==0.96
        Peak = .59*6*982/800*0.96/0.92;
    else
        Peak = .59*6*671/800;
    end

%    i1 = find(t<.046);  % 46 msec is when the beam arrives
%    i2 = find(t<.8);
    if T==0.96
        i1 = find(t<0.012);
    elseif T>1.0
%        i1 = find(t<.046);
        i1 = find(t<(.046/1.1));
    else
        i1 = find(t<.020);
    end
    i2 = find(t<T/2);
    
    % Previously we needed a minus sign for DAC inversion in the IOC????
    Waveform = [linspace(0,DC,length(i1)) linspace(0,Peak-DC,length(i2)-length(i1))+DC linspace(Peak,0,length(i2))];
    
    
    % IRM Waveform
    % DAC counts (-32768 to 32767) -> (-10 to 10 Volts)
%     t_irm = (0:1400-1)/1000;
%     
%     if T==0.96
%         i1 = find(t_irm<0.010);
%     elseif T>1.0
%         %        i1 = find(t_irm<.046);
%         i1 = find(t_irm<(.046/1.1));
%     else
%         i1 = find(t_irm<.020);
%     end
%     i2 = find(t_irm<T/2);
%     
%     % Waveform in volts
%     Waveform_IRM = [linspace(0,DC,length(i1)) linspace(0,Peak-DC,length(i2)-length(i1))+DC linspace(Peak,0,length(i2))];
% 
%     
%     gg = 0;
%     Waveform_IRM = -1 * Waveform_IRM * 32767 / 10;
%     setpv('irm:117:AWG1:pattern', -1*Waveform_IRM*2*GainSP*.93 * gg);  % Not sure why GainSP=.9 and the extra .93 is needed???
end

if DecimateByTen
    for i = 2:10
        Waveform(i:10:end) = Waveform(i-1:10:end);
    end 
end

% Force the last point in the table to zero.
% The last point is held even if the ramp is disabled
%Waveform(end) = 0;


% Plot
if DisplayFlag
    plot(t, Waveform);
    xlabel('Time [Seconds]');
    ylabel('[Volts]');
    title(sprintf('SD Waveform, %d Points in Table,  %d Delay Counts', Npts, Ndelay));
end

if DisplayOnly
    return;
end


% Last chance to say no
%tmp = questdlg('Change the booster SD ramp table?','setboosterrampsd','Yes','No','No');
%if ~strcmpi(tmp,'Yes')
%    fprintf('   No change made to booster SD ramp table.\n');
%    return
%end


OnFlag = getpv('SD', 'On');
if any(OnFlag==0)
    tmp = questdlg({'At least one of booster SD is not on','Should I turn them on now?'},'setboosterrampsf','Yes','No','No');
    if strcmpi(tmp,'Yes')
        setpv('SD', 'EnableRamp', 0);  % Disable the ramp before turning on or it could glitch
        pause(1);
        setpv('SD', 'Setpoint',  0);
        setpv('SD', 'OnControl', 1);
        pause(3);
    else
        fprintf('   No change made to booster SD ramp table.\n');
        return
    end
end


%%%%%%%%%%%%%%
% Initialize %
%%%%%%%%%%%%%%

% Disable the ramp so that the number of points can be changed and the DAC can be enabled
% Note: this disables SF & SD
% setpv('SD', 'EnableRamp', 1);
setpv('B0102-5:ENABLE_RAMP', 0);
setpv('B0202-5:ENABLE_RAMP', 0);
setpv('B0302-5:ENABLE_RAMP', 0);
setpv('B0402-5:ENABLE_RAMP', 0);
pause(.25);


% Enable the DAC 
% setpv('SD', 'EnableDAC', 1);
setpv('BR1_____SD___REBC01', 1);
setpv('BR2_____SD___REBC01', 1);
setpv('BR3_____SD___REBC01', 1);
setpv('BR4_____SD___REBC01', 1);


% Set the gain
% setpv('SD', 'Gain', 1);
setpv('BR1_____SD___GNAC01', GainSP);
setpv('BR2_____SD___GNAC01', GainSP);
setpv('BR3_____SD___GNAC01', GainSP);
setpv('BR4_____SD___GNAC01', GainSP);


% The the number of points
setpv('B0102-5:SET_TABLE_LEN', Npts);
setpv('B0202-5:SET_TABLE_LEN', Npts);
setpv('B0302-5:SET_TABLE_LEN', Npts);
setpv('B0402-5:SET_TABLE_LEN', Npts);


% Number of delay steps between points
setpv('B0102-5:SET_TABLE_DELAY', Ndelay);
setpv('B0202-5:SET_TABLE_DELAY', Ndelay);
setpv('B0302-5:SET_TABLE_DELAY', Ndelay);
setpv('B0402-5:SET_TABLE_DELAY', Ndelay);


% Enable the ramping
setpv('B0102-5:ENABLE_RAMP', 1);
setpv('B0202-5:ENABLE_RAMP', 1);
setpv('B0302-5:ENABLE_RAMP', 1);
setpv('B0402-5:ENABLE_RAMP', 1);


%%%%%%%%%%%%%%%%%%%%%%%%% 
% Set the SD ramp table %
%%%%%%%%%%%%%%%%%%%%%%%%%
Waveform= -Waveform/GainSP;
rampgentableload(Waveform, '131.243.89.127', Channel, TableName, egul, eguf)
rampgentableload(Waveform, '131.243.89.132', Channel, TableName, egul, eguf)
rampgentableload(Waveform, '131.243.89.137', Channel, TableName, egul, eguf)
rampgentableload(Waveform, '131.243.89.142', Channel, TableName, egul, eguf)
%rampgentableload(Waveform, 'B0102-5', Channel, TableName, egul, eguf)
%rampgentableload(Waveform, 'B0202-5', Channel, TableName, egul, eguf)
%rampgentableload(Waveform, 'B0302-5', Channel, TableName, egul, eguf)
%rampgentableload(Waveform, 'B0402-5', Channel, TableName, egul, eguf)


% Swap the tables
setpv('B0102-5:SWAP_TABLE', 1);
setpv('B0202-5:SWAP_TABLE', 1);
setpv('B0302-5:SWAP_TABLE', 1);
setpv('B0402-5:SWAP_TABLE', 1);
pause(.5);


% Check the final states
fprintf('   BR1_____SD___REBC01     = %d\n', getpv('BR1_____SD___REBC01'));
fprintf('   BR1_____SD___REBM01     = %d\n', getpv('BR1_____SD___REBM01'));
fprintf('   BR1_____SD___GNAC01     = %d\n', getpv('BR1_____SD___GNAC01'));
fprintf('   BR2_____SD___REBC01     = %d\n', getpv('BR2_____SD___REBC01'));
fprintf('   BR2_____SD___REBM01     = %d\n', getpv('BR2_____SD___REBM01'));
fprintf('   BR2_____SD___GNAC01     = %d\n', getpv('BR2_____SD___GNAC01'));
fprintf('   BR3_____SD___REBC01     = %d\n', getpv('BR3_____SD___REBC01'));
fprintf('   BR3_____SD___REBM01     = %d\n', getpv('BR3_____SD___REBM01'));
fprintf('   BR3_____SD___GNAC01     = %d\n', getpv('BR3_____SD___GNAC01'));
fprintf('   BR4_____SD___REBC01     = %d\n', getpv('BR4_____SD___REBC01'));
fprintf('   BR4_____SD___REBM01     = %d\n', getpv('BR4_____SD___REBM01'));
fprintf('   BR4_____SD___GNAC01     = %d\n', getpv('BR4_____SD___GNAC01'));

fprintf('   B0102-5:ENABLE_RAMP     = %d\n', getpv('B0102-5:ENABLE_RAMP'));
fprintf('   B0202-5:ENABLE_RAMP     = %d\n', getpv('B0202-5:ENABLE_RAMP'));
fprintf('   B0302-5:ENABLE_RAMP     = %d\n', getpv('B0302-5:ENABLE_RAMP'));
fprintf('   B0402-5:ENABLE_RAMP     = %d\n', getpv('B0402-5:ENABLE_RAMP'));

fprintf('   B0102-5:SET_TABLE_LEN   = %d\n', getpv('B0102-5:SET_TABLE_LEN'));
fprintf('   B0202-5:SET_TABLE_LEN   = %d\n', getpv('B0202-5:SET_TABLE_LEN'));
fprintf('   B0302-5:SET_TABLE_LEN   = %d\n', getpv('B0302-5:SET_TABLE_LEN'));
fprintf('   B0402-5:SET_TABLE_LEN   = %d\n', getpv('B0402-5:SET_TABLE_LEN'));

fprintf('   B0102-5:SET_TABLE_DELAY = %d\n', getpv('B0102-5:SET_TABLE_DELAY'));
fprintf('   B0202-5:SET_TABLE_DELAY = %d\n', getpv('B0202-5:SET_TABLE_DELAY'));
fprintf('   B0302-5:SET_TABLE_DELAY = %d\n', getpv('B0302-5:SET_TABLE_DELAY'));
fprintf('   B0402-5:SET_TABLE_DELAY = %d\n', getpv('B0402-5:SET_TABLE_DELAY'));

fprintf('   B0102-5:SWAP_TABLE      = %d\n', getpv('B0102-5:SWAP_TABLE'));
fprintf('   B0202-5:SWAP_TABLE      = %d\n', getpv('B0202-5:SWAP_TABLE'));
fprintf('   B0302-5:SWAP_TABLE      = %d\n', getpv('B0302-5:SWAP_TABLE'));
fprintf('   B0402-5:SWAP_TABLE      = %d\n', getpv('B0402-5:SWAP_TABLE'));


