function [Tune, tout, DataTime, ErrorFlag] = gettune_sps(FamilyName, Field, DeviceList, t)
%  SPS Storage Ring Tune Measurement
%
% |  Lower Fractional Tune, usually Horizontal |
% |                                            | = gettune_sps
% | Higher Fractional Tune, usually Vertical   |
%
%

t0 = clock;
tout = [];
DataTime = [];
ErrorFlag = 0;

% f0 = RF frequency = 118.004 MHz
f0 = getrf('Hardware');

% frev = revolution frequency = RF frequency /32
frev = f0 / 32;

[fx, fy] = Read_fxfy_local;
Tune = [1 - (fx-f0)/frev
        1 - (fy-f0)/frev];

% This is just the MML time stamp
tout = etime(clock, t0);
if nargout >= 3
    % DataTime is the time on computer taking the data but
    % reference it w.r.t. the time zone where Matlab is running
    DateNumber1970 = 719529;  %datenum('1-Jan-1970');
    days = datenum(t0(1:3)) - DateNumber1970;
    t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
    TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
    DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);
end

function [fx, fy] = Read_fxfy_local

% ON RF-KO
da = opcda('localhost','RSLinx Remote OPC Server');
connect(da);
grp = addgroup(da);
item1 = additem(grp,'[STR-DCS]STR_RFKO.PowerOn_Command_Manual');
RFKO = get(item1);
write(item1,1);
pause(10);
RFKO = RFKO.Value;
disconnect(da);


%-- OPEN Connection --%
g=visa('ni','GPIB0::1::INSTR'); %-- GPIB0 Address 1 use NI-GPIB vendor --%
fopen(g);

%-- Send Command for Config. --%
fprintf(g,'SW500MSRB1KZVB1KZ'); %-- Sweep 500 ms RBW 1kHz VBW 1 kHz --%
fprintf(g,'RE10DMMGTL40DM'); %-- Ref.Level -10 dBm TG. Level -40 dBm --%
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Get_current_pushbutton.

%-- Find fy --%
fprintf(g,'MOSHARFRCF118.7MZSP500KZ'); %-- Marker Off,Average Off, Free Run, Center Freq. 118.55 MHz Span Freq. 120 kHz --%
pause(3);
fprintf(g,'AR16HZ'); %-- Average 16 --%
pause(11); %-- Waiting on M/C Average Observe from Actual control (can adj.) --%
fprintf(g,'SI'); %-- Stop --%
pause(1);
fprintf(g,'MKPSMF'); %-- Marker On,Peak Search and Query Marker Frequency --%
d=fscanf(g); %--Read --%
fys(1,1)=sscanf(d,'%*s %f %*s'); %-- keep it in variable column 1--%
fprintf(g,'MFLD73C40E0099DC'); %-- Query Marker Level --%
l=fscanf(g); %-- Read --%
fys(1,2)=sscanf(l,'%f %*s'); %-- keep it in variable column 2 --%
fprintf(g,'MK'); %-- EXIT Peak Search Mode --%

%-- Find fx --%
fprintf(g,'MOSHARFRCF118.9MZSP300KZ'); %-- Marker Off,Average Off, Free Run, Center Freq. 118.95 MHz Span Freq. 120 kHz --%
pause(3);
fprintf(g,'AR16HZ'); %-- Average 16 --%
pause(11); %-- Waiting on M/C Average Observe from Actual control (can adj.) --%
fprintf(g,'SI');  %-- Stop --%
pause(1);
fprintf(g,'MKPSMF'); %-- Marker On,Peak Search and Query Marker Frequency --%
d=fscanf(g); %--Read --%
fxs(1,1)=sscanf(d,'%*s %f %*s'); %-- keep it in variable column 1--%
fprintf(g,'MFLD73C40E0099DC'); %-- Query Marker Level --%
l=fscanf(g); %--Read --%
fxs(1,2)=sscanf(l,'%f %*s'); %-- keep it in variable column 2--%
fprintf(g,'MK'); %-- EXIT Peak Search Mode --%

fclose(g);
clear g;

% OFF RF-KO
da = opcda('localhost','RSLinx Remote OPC Server');
connect(da);
grp = addgroup(da);
item1 = additem(grp,'[STR-DCS]STR_RFKO.PowerOff_Command_Manual');
RFKO = get(item1);
write(item1,1);
pause(10);
disconnect(da);

fx = fxs(1,1);
fy = fys(1,1);


if fxs(1,2) <= -100
    error('Cannot find the horizontal tune.');
end
if fys(1,2) <= -100
    error('Cannot find the vertical tune.');
end