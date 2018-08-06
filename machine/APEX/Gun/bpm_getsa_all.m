% function SA = bpm_getsa_all(t, FigNum)
% 
% Use bpm_getsa_all to plot
%
% if nargin < 2 || isempty(FigNum)
%     FigNum = 200;
% end

clear

Prefix_All = getfamilydata('BPM','BaseName');

PVsPerBPM = 4;
%PVsPerBPM = 29+4+8;

RFPV = [];
for i = 1:length(Prefix_All)
    Prefix =  Prefix_All{i};
    if Prefix(end) ~= ':'
        Prefix = [Prefix, ':'];
    end
    
    % A=c3  B=c1  C=c2  D=c0
    PV1 = [
        [Prefix,'SA:X             ']  %  1
        [Prefix,'SA:Y             ']
        [Prefix,'SA:Q             ']
        [Prefix,'SA:S             ']  %  4
        ];
    
    RFPV = strvcat(RFPV, PV1);
end

RFPV = strvcat(RFPV, 'BTS_____ICT01__AM00');
RFPV = strvcat(RFPV, 'BTS_____ICT02__AM01');
RFPV = strvcat(RFPV, 'cmm:beam_current');

% Add number of bunches, ...

% Warm up CA first
[d, tout, Ts] = getpv(RFPV, 'double');
tic; 
[SA.Data, tout, SA.Ts] = getpv(RFPV, 'double'); 
toc


%[SA.Data, tout, Ts] = getpvonline(RFPV, 'double', 1, t);
nShots = 100;
if 0
    j = 1;
    fprintf('%4d.  New data %s  x = %.4f  y = %.4f  s = %d\n', j, datestr(Ts(1),31), d(1,end), d(2,end), d(3,end));
else
    % Don't use the first point because the ICT and DCCT may not be at the same time.
    j = 0;
    d = -1 * d;
end
for i = 1:1e10
    [d, tout, Ts] = getpv(RFPV, 'double');
    
    if any(d(1:end-3) ~= SA.Data(1:end-3,end))
        j = j + 1;
        fprintf('%4d.  New data %s  x = %.4f  y = %.4f  s = %d\n', j, datestr(Ts(1),31), d(1,end), d(2,end), d(3,end));
        SA.Data(:,end+1) = d;
        SA.Ts(:,end+1) = Ts;
    end
    
    if size(SA.Data,2) >= nShots
        break
    else
        pause(.5);
    end
end


%SA.Ts = linktime2datenum(Ts);
%SA.TsStr  = datestr(SA.Ts(1),  'yyyy-mm-dd HH:MM:SS.FFF');
SA.Prefix = Prefix_All;


% Arc BPM gain factors on a curved section Bergoz card are X: 0.1613 V/% and Y: 0.1629 V/%
% Xgain = 16.13;
% Ygain = 16.29;
% 
% SA.s = SA.a + SA.b + SA.c + SA.d;
% SA.x = Xgain * (SA.a - SA.b - SA.c + SA.d ) ./ SA.s;  % mm
% SA.y = Ygain * (SA.a + SA.b - SA.c - SA.d ) ./ SA.s;  % mm
% 
% SA.pts = SA.pta + SA.ptb + SA.ptc + SA.ptd;
% SA.ptx = Xgain * (SA.pta - SA.ptb - SA.ptc + SA.ptd ) ./ SA.pts;  % mm
% SA.pty = Ygain * (SA.pta + SA.ptb - SA.ptc - SA.ptd ) ./ SA.pts;  % mm

% if ~isempty(FigNum) && FigNum
%     SA = bpm_plotsa(SA, FigNum);
% end


save BTS_SA_All_Set1
%save SA_All_2Bunch_Set11



