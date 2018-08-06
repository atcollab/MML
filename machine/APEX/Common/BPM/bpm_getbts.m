% function SA = bpm_getsa_all(t, FigNum)
% 
% Use bpm_getsa_all to plot
%
% if nargin < 2 || isempty(FigNum)
%     FigNum = 200;
% end

clear

% Add ID and EPU!!
% Add imn/max over 10 seconds

%118 & 36 hours seg faulted?
t = 0:.1:6.3*60*60;
%t = 0:10:48*60*60;
%t = 0:.1:1*60;

%Prefix_All = getfamilydata('BPM','BaseName');
Prefix_All = {
     'BTS:BPM1:'
};

PVsPerBPM = 29+4;
%PVsPerBPM = 29+4+8;

RFPV = [];
for i = 1:length(Prefix_All)
    
    Prefix =  Prefix_All{i};
    if Prefix(end) ~= ':'
        Prefix = [Prefix, ':'];
    end

    %bpm_setenv(Prefix{i}, RFAttn);
    
    % A=c3  B=c1  C=c2  D=c0
    PV1 = [
        [Prefix,'SA:X             ']  %  1
        [Prefix,'SA:Y             ']
        [Prefix,'SA:Q             ']
        [Prefix,'SA:S             ']  %  4
        
        [Prefix,'ADC3:rfMag       ']  %  5
        [Prefix,'ADC1:rfMag       ']
        [Prefix,'ADC2:rfMag       ']
        [Prefix,'ADC0:rfMag       ']  %  8
        
        [Prefix,'ADC3:ptLoMag     ']  %  9
        [Prefix,'ADC1:ptLoMag     ']
        [Prefix,'ADC2:ptLoMag     ']
        [Prefix,'ADC0:ptLoMag     ']  % 12
        
        [Prefix,'ADC3:ptHiMag     ']  % 13
        [Prefix,'ADC1:ptHiMag     ']
        [Prefix,'ADC2:ptHiMag     ']
        [Prefix,'ADC0:ptHiMag     ']  % 16
        
        [Prefix,'ADC3:gainFactor  ']  % 17
        [Prefix,'ADC1:gainFactor  ']
        [Prefix,'ADC2:gainFactor  ']
        [Prefix,'ADC0:gainFactor  ']  % 20

        [Prefix,'AFE:0:temperature']  % 21
        [Prefix,'AFE:1:temperature']
        [Prefix,'AFE:2:temperature']
        [Prefix,'AFE:3:temperature']
        [Prefix,'AFE:4:temperature']
        [Prefix,'AFE:5:temperature']
        [Prefix,'AFE:6:temperature']
        [Prefix,'AFE:7:temperature']
        [Prefix,'DFE:0:temperature']
        [Prefix,'DFE:1:temperature']
        [Prefix,'DFE:2:temperature']
        [Prefix,'DFE:3:temperature']
        [Prefix,'FPGA:temperature ']  % 33
        ];
    
    PV2 = [
        [Prefix,'AFE:adcRate    ']    % 34
        [Prefix,'EVR:AFEref:sync']
        [Prefix,'AFE:pllStatus  ']
        [Prefix,'EVR:FA:sync    ']
        [Prefix,'EVR:SA:sync    ']
        [Prefix,'EVR:LO:sync    ']
        [Prefix,'autotrim:status']
        [Prefix,'attenuation    ']    % 41
        ];
    
    RFPV = strvcat(RFPV, PV1);
   % RFPV = strvcat(RFPV, PV2);
end

RFPV = strvcat(RFPV, 'cmm:beam_current');
RFPV = strvcat(RFPV, 'SR01C___FREQB__AM00');
RFPV = strvcat(RFPV, 'EG______HQMOFM_AC01');  % can't get from s02lxioc01.als  ???

d = getbpmlist('Bergoz');
RFPV = strvcat(RFPV, family2channel('BPMx',d));
RFPV = strvcat(RFPV, family2channel('BPMy',d));

RFPV = strvcat(RFPV, family2channel('ID'));
RFPV = strvcat(RFPV, family2channel('EPU'));


% Warm up CA first
[SA.Data, tout, Ts] = getpvonline(RFPV, 'double');
tic; 
[SA.Data, tout, Ts] = getpvonline(RFPV, 'double'); toc
[SA.Data, tout, Ts] = getpvonline(RFPV, 'double', 1, t);


% SA.X = tmp(1,:);
% SA.Y = tmp(2,:);
% SA.Q = tmp(3,:);
% SA.S = tmp(4,:);
% %SA.TsXYQS = linktime2datenum(Ts);
% tmp(1:4,:) = [];
% %Ts(1:4,:) = [];
% 
% SA.A = tmp(1,:);
% SA.B = tmp(2,:);
% SA.C = tmp(3,:);
% SA.D = tmp(4,:);
% tmp(1:4,:) = [];
% %Ts(1:4,:) = [];
% 
% SA.PTLoA = tmp(1,:);
% SA.PTLoB = tmp(2,:);
% SA.PTLoC = tmp(3,:);
% SA.PTLoD = tmp(4,:);
% tmp(1:4,:) = [];
% %Ts(1:4,:) = [];
% 
% SA.PTHiA = tmp(1,:);
% SA.PTHiB = tmp(2,:);
% SA.PTHiC = tmp(3,:);
% SA.PTHiD = tmp(4,:);
% tmp(1:4,:) = [];
% %Ts(1:4,:) = [];
%  
% SA.DCCT   = tmp(1,:);
% SA.t_DCCT = Ts(end,:);
% tmp(1,:)  = [];
% Ts(end,:) = [];
% 
% SA.RF     = tmp(1,:);
% SA.t_RF   = Ts(end,:);
% tmp(1,:)  = [];
% Ts(end,:) = [];

SA.t = t;
SA.tout = tout;
SA.TsLabCA = Ts;
SA.Ts = linktime2datenum(Ts);
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


save SA_All_Set21
%save SA_All_2Bunch_Set11



