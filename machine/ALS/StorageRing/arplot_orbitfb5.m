function arplot_orbitfb5(monthStr, days, year1, month2Str, days2, year2)
% arplot_orbitfb5(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
% Plots archived data about the orbit feedback:
%       plots (corrector Trim SP + the corrector SP - corrector AM)
%       which represents the hidden FOFB setpoints
%       (this routine is compatible with the new Matlab ML)
%
% Example:  arplots_orbitfb4('January',22:24, 2007);
%           plots data from 1/22, 1/23, and 1/24 in 2007
%
% C. Steier, May 2002; updated to work with new ML 4-25-07, T.Scarvie

tightaxis = 1; % change to 1 if you want the vertical axis auto-scaled

switch2bergoz
disp('  Matlab session is now using only Bergoz BPMs!');

BPMlist = getlist('BPMx');

HCMlist = [1 2;1 8;2 1;2 8;3 1;3 8;3 10;4 1;4 8;5 1;5 8;5 10;6 1;6 8; ...
    7 1;7 8;8 1;8 8;9 1;9 8;10 1;10 8;10 10;11 1;11 8;12 1;12 7];

VCMlist = [1 2;1 7;1 8;2 1;2 2;2 7;2 8;3 1;3 2;3 7;3 8;3 10;4 1;4 2;4 7;4 8;5 1;5 2;5 7;5 8;5 10;6 1;6 2;6 7;6 8; ...
    7 1;7 2;7 7;7 8;8 1;8 2;8 7;8 8;9 1;9 2;9 7;9 8;10 1;10 2;10 7;10 8;10 10;11 1;11 2;11 7;11 8;12 1;12 2;12 7];

% HCMlist = [1 2;1 7;1 8;2 1;2 2;2 7;2 8;3 1;3 2;3 7;3 8;3 10;4 1;4 2;4 7;4 8;5 1;5 2;5 7;5 8;5 10;6 1;6 2;6 7;6 8; ...
%     7 1;7 2;7 7;7 8;8 1;8 2;8 8;8 8;9 1;9 2;9 7;9 8;10 1;10 2;10 7;10 8;10 10;11 1;11 2;11 7;11 8;12 1;12 2;12 7];

% VCMlist = [1 2;1 4;1 5;1 7;1 8;2 1;2 2;2 4;2 5;2 7;2 8;3 1;3 2;3 4;3 5;3 7;3 8;3 10;4 1;4 2;4 4;4 5;4 7;4 8;5 1;5 2;5 4;5 5;5 7;5 8;5 10;6 1;6 2;6 4;6 5;6 7;6 8; ...
%     7 1;7 2;7 4;7 5;7 7;7 8;8 1;8 2;8 4;8 5;8 7;8 8;9 1;9 2;9 4;9 5;9 7;9 8;10 1;10 2;10 4;10 5;10 7;10 8;10 10;11 1;11 2;11 4;11 5;11 7;11 8;12 1;12 2;12 4;12 5;12 7];

%VCMlist = getlist('VCM','Trim');

Sx = getrespmat('BPMx',BPMlist,'HCM',HCMlist);
Sy = getrespmat('BPMy',BPMlist,'VCM',VCMlist);


% Inputs
if nargin < 2
    error('ARPLOTS:  You need at least two input arguments.');
elseif nargin == 2
    tmp = clock;
    year1 = tmp(1);
    monthStr2 = [];
    days2 = [];
    year2 = [];
elseif nargin == 3
    monthStr2 = [];
    days2 = [];
    year2 = [];
elseif nargin == 4
    error('ARPLOTS:  You need 2, 3, 5, or 6 input arguments.');
elseif nargin == 5
    tmp = clock;
    year2 = tmp(1);
elseif nargin == 6
else
    error('ARPLOTS:  Inputs incorrect.');
end

arglobal

t=[];

hcm12trimSP = []; hcm12SP = []; hcm12AM = []; hcm17trimSP = []; hcm17SP = []; hcm17AM = []; hcm18trimSP = []; hcm18SP = []; hcm18AM = [];
hcm21trimSP = []; hcm21SP = []; hcm21AM = []; hcm22trimSP = []; hcm22SP = []; hcm22AM = []; hcm27trimSP = []; hcm27SP = []; hcm27AM = []; hcm28trimSP = []; hcm28SP = []; hcm28AM = [];
hcm31trimSP = []; hcm31SP = []; hcm31AM = []; hcm32trimSP = []; hcm32SP = []; hcm32AM = []; hcm37trimSP = []; hcm37SP = []; hcm37AM = []; hcm38trimSP = []; hcm38SP = []; hcm38AM = [];
hcm41trimSP = []; hcm41SP = []; hcm41AM = []; hcm42trimSP = []; hcm42SP = []; hcm42AM = []; hcm47trimSP = []; hcm47SP = []; hcm47AM = []; hcm48trimSP = []; hcm48SP = []; hcm48AM = [];
hcm51trimSP = []; hcm51SP = []; hcm51AM = []; hcm52trimSP = []; hcm52SP = []; hcm52AM = []; hcm57trimSP = []; hcm57SP = []; hcm57AM = []; hcm58trimSP = []; hcm58SP = []; hcm58AM = [];
hcm61trimSP = []; hcm61SP = []; hcm61AM = []; hcm62trimSP = []; hcm62SP = []; hcm62AM = []; hcm67trimSP = []; hcm67SP = []; hcm67AM = []; hcm68trimSP = []; hcm68SP = []; hcm68AM = [];
hcm71trimSP = []; hcm71SP = []; hcm71AM = []; hcm72trimSP = []; hcm72SP = []; hcm72AM = []; hcm77trimSP = []; hcm77SP = []; hcm77AM = []; hcm78trimSP = []; hcm78SP = []; hcm78AM = [];
hcm81trimSP = []; hcm81SP = []; hcm81AM = []; hcm82trimSP = []; hcm82SP = []; hcm82AM = []; hcm87trimSP = []; hcm87SP = []; hcm87AM = []; hcm88trimSP = []; hcm88SP = []; hcm88AM = [];
hcm91trimSP = []; hcm91SP = []; hcm91AM = []; hcm92trimSP = []; hcm92SP = []; hcm92AM = []; hcm97trimSP = []; hcm97SP = []; hcm97AM = []; hcm98trimSP = []; hcm98SP = []; hcm98AM = [];
hcm101trimSP = []; hcm101SP = []; hcm101AM = []; hcm102trimSP = []; hcm102SP = []; hcm102AM = []; hcm107trimSP = []; hcm107SP = []; hcm107AM = []; hcm108trimSP = []; hcm108SP = []; hcm108AM = [];
hcm111trimSP = []; hcm111SP = []; hcm111AM = []; hcm112trimSP = []; hcm112SP = []; hcm112AM = []; hcm117trimSP = []; hcm117SP = []; hcm117AM = []; hcm118trimSP = []; hcm118SP = []; hcm118AM = [];
hcm121trimSP = []; hcm121SP = []; hcm121AM = []; hcm122trimSP = []; hcm122SP = []; hcm122AM = []; hcm127trimSP = []; hcm127SP = []; hcm127AM = []; hcm128trimSP = []; hcm128SP = []; hcm128AM = [];

vcm12trimSP = []; vcm12SP = []; vcm12AM = []; vcm13trimSP = []; vcm13SP = []; vcm13AM = []; vcm18trimSP = []; vcm18SP = []; vcm18AM = [];
vcm21trimSP = []; vcm21SP = []; vcm21AM = []; vcm22trimSP = []; vcm22SP = []; vcm22AM = []; vcm23trimSP = []; vcm23SP = []; vcm23AM = []; vcm28trimSP = []; vcm28SP = []; vcm28AM = [];
vcm31trimSP = []; vcm31SP = []; vcm31AM = []; vcm32trimSP = []; vcm32SP = []; vcm32AM = []; vcm33trimSP = []; vcm33SP = []; vcm33AM = []; vcm38trimSP = []; vcm38SP = []; vcm38AM = [];
vcm41trimSP = []; vcm41SP = []; vcm41AM = []; vcm42trimSP = []; vcm42SP = []; vcm42AM = []; vcm43trimSP = []; vcm43SP = []; vcm43AM = []; vcm48trimSP = []; vcm48SP = []; vcm48AM = [];
vcm51trimSP = []; vcm51SP = []; vcm51AM = []; vcm52trimSP = []; vcm52SP = []; vcm52AM = []; vcm53trimSP = []; vcm53SP = []; vcm53AM = []; vcm58trimSP = []; vcm58SP = []; vcm58AM = [];
vcm61trimSP = []; vcm61SP = []; vcm61AM = []; vcm62trimSP = []; vcm62SP = []; vcm62AM = []; vcm63trimSP = []; vcm63SP = []; vcm63AM = []; vcm68trimSP = []; vcm68SP = []; vcm68AM = [];
vcm71trimSP = []; vcm71SP = []; vcm71AM = []; vcm72trimSP = []; vcm72SP = []; vcm72AM = []; vcm73trimSP = []; vcm73SP = []; vcm73AM = []; vcm78trimSP = []; vcm78SP = []; vcm78AM = [];
vcm81trimSP = []; vcm81SP = []; vcm81AM = []; vcm82trimSP = []; vcm82SP = []; vcm82AM = []; vcm83trimSP = []; vcm83SP = []; vcm83AM = []; vcm88trimSP = []; vcm88SP = []; vcm88AM = [];
vcm91trimSP = []; vcm91SP = []; vcm91AM = []; vcm92trimSP = []; vcm92SP = []; vcm92AM = []; vcm93trimSP = []; vcm93SP = []; vcm93AM = []; vcm98trimSP = []; vcm98SP = []; vcm98AM = [];
vcm101trimSP = []; vcm101SP = []; vcm101AM = []; vcm102trimSP = []; vcm102SP = []; vcm102AM = []; vcm103trimSP = []; vcm103SP = []; vcm103AM = []; vcm108trimSP = []; vcm108SP = []; vcm108AM = [];
vcm111trimSP = []; vcm111SP = []; vcm111AM = []; vcm112trimSP = []; vcm112SP = []; vcm112AM = []; vcm113trimSP = []; vcm113SP = []; vcm113AM = []; vcm118trimSP = []; vcm118SP = []; vcm118AM = [];
vcm121trimSP = []; vcm121SP = []; vcm121AM = []; vcm122trimSP = []; vcm122SP = []; vcm122AM = []; vcm123trimSP = []; vcm123SP = []; vcm123AM = []; vcm128trimSP = []; vcm128SP = []; vcm128AM = [];


if isempty(days2)
    if length(days) == [1]
        month  = mon2num(monthStr);
        NumDays = length(days);
        StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
        EndDayStr =   [''];
        titleStr = [StartDayStr];
    else
        month  = mon2num(monthStr);
        NumDays = length(days);
        StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
        EndDayStr =   [monthStr, ' ', num2str(days(length(days))),', ', num2str(year1)];
        titleStr = [StartDayStr,' to ', EndDayStr,' (', num2str(NumDays),' days)'];
    end
else
    month  = mon2num(monthStr);
    month2 = mon2num(month2Str);
    NumDays = length(days) + length(days2);
    StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
    EndDayStr =   [month2Str, ' ', num2str(days2(length(days2))),', ', num2str(year2)];
    
    titleStr = [StartDayStr,' to ', EndDayStr,' (', num2str(NumDays),' days)'];
end


StartDay = days(1);
EndDay = days(length(days));
N=0;

for day = days
    %day;
    %t0=clock;
    year1str = num2str(year1);
    if year1 < 2000
        year1str = year1str(3:4);
        FileName = sprintf('%2s%02d%02d', year1str, month, day);
    else
        FileName = sprintf('%4s%02d%02d', year1str, month, day);
    end
    FileName = sprintf('%2s%02d%02d', year1str, month, day);
    arread(FileName);
    %readtime = etime(clock, t0)
    
    [y1, i] = arselect('SR01C___HCM2T__AC10');
    hcm12trimSP = [hcm12trimSP y1];
    [y1, i] = arselect('SR01C___HCM2___AC0');
    hcm12SP = [hcm12SP y1];
    [y1, i] = arselect('SR01C___HCM2___AM0');
    hcm12AM = [hcm12AM y1];
    
    [y1, i] = arselect('SR01C___HCM3T__AC10');
    hcm17trimSP = [hcm17trimSP y1];
    [y1, i] = arselect('SR01C___HCM3___AC0');
    hcm17SP = [hcm17SP y1];
    [y1, i] = arselect('SR01C___HCM3___AM0');
    hcm17AM = [hcm17AM y1];
    
    [y1, i] = arselect('SR01C___HCM4T__AC10');
    hcm18trimSP = [hcm18trimSP y1];
    [y1, i] = arselect('SR01C___HCM4___AC0');
    hcm18SP = [hcm18SP y1];
    [y1, i] = arselect('SR01C___HCM4___AM0');
    hcm18AM = [hcm18AM y1];
    
    [y1, i] = arselect('SR02C___HCM1T__AC10');
    hcm21trimSP = [hcm21trimSP y1];
    [y1, i] = arselect('SR02C___HCM1___AC0');
    hcm21SP = [hcm21SP y1];
    [y1, i] = arselect('SR02C___HCM1___AM0');
    hcm21AM = [hcm21AM y1];
    
    [y1, i] = arselect('SR02C___HCM2T__AC10');
    hcm22trimSP = [hcm22trimSP y1];
    [y1, i] = arselect('SR02C___HCM2___AC0');
    hcm22SP = [hcm22SP y1];
    [y1, i] = arselect('SR02C___HCM2___AM0');
    hcm22AM = [hcm22AM y1];
    
    [y1, i] = arselect('SR02C___HCM3T__AC10');
    hcm27trimSP = [hcm27trimSP y1];
    [y1, i] = arselect('SR02C___HCM3___AC0');
    hcm27SP = [hcm27SP y1];
    [y1, i] = arselect('SR02C___HCM3___AM0');
    hcm27AM = [hcm27AM y1];
    
    [y1, i] = arselect('SR02C___HCM4T__AC10');
    hcm28trimSP = [hcm28trimSP y1];
    [y1, i] = arselect('SR02C___HCM4___AC0');
    hcm28SP = [hcm28SP y1];
    [y1, i] = arselect('SR02C___HCM4___AM0');
    hcm28AM = [hcm28AM y1];
    
    [y1, i] = arselect('SR03C___HCM1T__AC10');
    hcm31trimSP = [hcm31trimSP y1];
    [y1, i] = arselect('SR03C___HCM1___AC0');
    hcm31SP = [hcm31SP y1];
    [y1, i] = arselect('SR03C___HCM1___AM0');
    hcm31AM = [hcm31AM y1];
    
    [y1, i] = arselect('SR03C___HCM2T__AC10');
    hcm32trimSP = [hcm32trimSP y1];
    [y1, i] = arselect('SR03C___HCM2___AC0');
    hcm32SP = [hcm32SP y1];
    [y1, i] = arselect('SR03C___HCM2___AM0');
    hcm32AM = [hcm32AM y1];
    
    [y1, i] = arselect('SR03C___HCM3T__AC10');
    hcm37trimSP = [hcm37trimSP y1];
    [y1, i] = arselect('SR03C___HCM3___AC0');
    hcm37SP = [hcm37SP y1];
    [y1, i] = arselect('SR03C___HCM3___AM0');
    hcm37AM = [hcm37AM y1];
    
    [y1, i] = arselect('SR03C___HCM4T__AC10');
    hcm38trimSP = [hcm38trimSP y1];
    [y1, i] = arselect('SR03C___HCM4___AC0');
    hcm38SP = [hcm38SP y1];
    [y1, i] = arselect('SR03C___HCM4___AM0');
    hcm38AM = [hcm38AM y1];
    
    [y1, i] = arselect('SR04C___HCM1T__AC10');
    hcm41trimSP = [hcm41trimSP y1];
    [y1, i] = arselect('SR04C___HCM1___AC0');
    hcm41SP = [hcm41SP y1];
    [y1, i] = arselect('SR04C___HCM1___AM0');
    hcm41AM = [hcm41AM y1];
    
    [y1, i] = arselect('SR04C___HCM2T__AC10');
    hcm42trimSP = [hcm42trimSP y1];
    [y1, i] = arselect('SR04C___HCM2___AC0');
    hcm42SP = [hcm42SP y1];
    [y1, i] = arselect('SR04C___HCM2___AM0');
    hcm42AM = [hcm42AM y1];
    
    [y1, i] = arselect('SR04C___HCM3T__AC10');
    hcm47trimSP = [hcm47trimSP y1];
    [y1, i] = arselect('SR04C___HCM3___AC0');
    hcm47SP = [hcm47SP y1];
    [y1, i] = arselect('SR04C___HCM3___AM0');
    hcm47AM = [hcm47AM y1];
    
    [y1, i] = arselect('SR04C___HCM4T__AC10');
    hcm48trimSP = [hcm48trimSP y1];
    [y1, i] = arselect('SR04C___HCM4___AC0');
    hcm48SP = [hcm48SP y1];
    [y1, i] = arselect('SR04C___HCM4___AM0');
    hcm48AM = [hcm48AM y1];
    
    [y1, i] = arselect('SR05C___HCM1T__AC10');
    hcm51trimSP = [hcm51trimSP y1];
    [y1, i] = arselect('SR05C___HCM1___AC0');
    hcm51SP = [hcm51SP y1];
    [y1, i] = arselect('SR05C___HCM1___AM0');
    hcm51AM = [hcm51AM y1];
    
    [y1, i] = arselect('SR05C___HCM2T__AC10');
    hcm52trimSP = [hcm52trimSP y1];
    [y1, i] = arselect('SR05C___HCM2___AC0');
    hcm52SP = [hcm52SP y1];
    [y1, i] = arselect('SR05C___HCM2___AM0');
    hcm52AM = [hcm52AM y1];
    
    [y1, i] = arselect('SR05C___HCM3T__AC10');
    hcm57trimSP = [hcm57trimSP y1];
    [y1, i] = arselect('SR05C___HCM3___AC0');
    hcm57SP = [hcm57SP y1];
    [y1, i] = arselect('SR05C___HCM3___AM0');
    hcm57AM = [hcm57AM y1];
    
    [y1, i] = arselect('SR05C___HCM4T__AC10');
    hcm58trimSP = [hcm58trimSP y1];
    [y1, i] = arselect('SR05C___HCM4___AC0');
    hcm58SP = [hcm58SP y1];
    [y1, i] = arselect('SR05C___HCM4___AM0');
    hcm58AM = [hcm58AM y1];
    
    [y1, i] = arselect('SR06C___HCM1T__AC10');
    hcm61trimSP = [hcm61trimSP y1];
    [y1, i] = arselect('SR06C___HCM1___AC0');
    hcm61SP = [hcm61SP y1];
    [y1, i] = arselect('SR06C___HCM1___AM0');
    hcm61AM = [hcm61AM y1];
    
    [y1, i] = arselect('SR06C___HCM2T__AC10');
    hcm62trimSP = [hcm62trimSP y1];
    [y1, i] = arselect('SR06C___HCM2___AC0');
    hcm62SP = [hcm62SP y1];
    [y1, i] = arselect('SR06C___HCM2___AM0');
    hcm62AM = [hcm62AM y1];
    
    [y1, i] = arselect('SR06C___HCM3T__AC10');
    hcm67trimSP = [hcm67trimSP y1];
    [y1, i] = arselect('SR06C___HCM3___AC0');
    hcm67SP = [hcm67SP y1];
    [y1, i] = arselect('SR06C___HCM3___AM0');
    hcm67AM = [hcm67AM y1];
    
    [y1, i] = arselect('SR06C___HCM4T__AC10');
    hcm68trimSP = [hcm68trimSP y1];
    [y1, i] = arselect('SR06C___HCM4___AC0');
    hcm68SP = [hcm68SP y1];
    [y1, i] = arselect('SR06C___HCM4___AM0');
    hcm68AM = [hcm68AM y1];
    
    [y1, i] = arselect('SR07C___HCM1T__AC10');
    hcm71trimSP = [hcm71trimSP y1];
    [y1, i] = arselect('SR07C___HCM1___AC0');
    hcm71SP = [hcm71SP y1];
    [y1, i] = arselect('SR07C___HCM1___AM0');
    hcm71AM = [hcm71AM y1];
    
    [y1, i] = arselect('SR07C___HCM2T__AC10');
    hcm72trimSP = [hcm72trimSP y1];
    [y1, i] = arselect('SR07C___HCM2___AC0');
    hcm72SP = [hcm72SP y1];
    [y1, i] = arselect('SR07C___HCM2___AM0');
    hcm72AM = [hcm72AM y1];
    
    [y1, i] = arselect('SR07C___HCM3T__AC10');
    hcm77trimSP = [hcm77trimSP y1];
    [y1, i] = arselect('SR07C___HCM3___AC0');
    hcm77SP = [hcm77SP y1];
    [y1, i] = arselect('SR07C___HCM3___AM0');
    hcm77AM = [hcm77AM y1];
    
    [y1, i] = arselect('SR07C___HCM4T__AC10');
    hcm78trimSP = [hcm78trimSP y1];
    [y1, i] = arselect('SR07C___HCM4___AC0');
    hcm78SP = [hcm78SP y1];
    [y1, i] = arselect('SR07C___HCM4___AM0');
    hcm78AM = [hcm78AM y1];
    
    [y1, i] = arselect('SR08C___HCM1T__AC10');
    hcm81trimSP = [hcm81trimSP y1];
    [y1, i] = arselect('SR08C___HCM1___AC0');
    hcm81SP = [hcm81SP y1];
    [y1, i] = arselect('SR08C___HCM1___AM0');
    hcm81AM = [hcm81AM y1];
    
    [y1, i] = arselect('SR08C___HCM2T__AC10');
    hcm82trimSP = [hcm82trimSP y1];
    [y1, i] = arselect('SR08C___HCM2___AC0');
    hcm82SP = [hcm82SP y1];
    [y1, i] = arselect('SR08C___HCM2___AM0');
    hcm82AM = [hcm82AM y1];
    
    [y1, i] = arselect('SR08C___HCM3T__AC10');
    hcm87trimSP = [hcm87trimSP y1];
    [y1, i] = arselect('SR08C___HCM3___AC0');
    hcm87SP = [hcm87SP y1];
    [y1, i] = arselect('SR08C___HCM3___AM0');
    hcm87AM = [hcm87AM y1];
    
    [y1, i] = arselect('SR08C___HCM4T__AC10');
    hcm88trimSP = [hcm88trimSP y1];
    [y1, i] = arselect('SR08C___HCM4___AC0');
    hcm88SP = [hcm88SP y1];
    [y1, i] = arselect('SR08C___HCM4___AM0');
    hcm88AM = [hcm88AM y1];
    
    [y1, i] = arselect('SR09C___HCM1T__AC10');
    hcm91trimSP = [hcm91trimSP y1];
    [y1, i] = arselect('SR09C___HCM1___AC0');
    hcm91SP = [hcm91SP y1];
    [y1, i] = arselect('SR09C___HCM1___AM0');
    hcm91AM = [hcm91AM y1];
    
    [y1, i] = arselect('SR09C___HCM2T__AC10');
    hcm92trimSP = [hcm92trimSP y1];
    [y1, i] = arselect('SR09C___HCM2___AC0');
    hcm92SP = [hcm92SP y1];
    [y1, i] = arselect('SR09C___HCM2___AM0');
    hcm92AM = [hcm92AM y1];
    
    [y1, i] = arselect('SR09C___HCM3T__AC10');
    hcm97trimSP = [hcm97trimSP y1];
    [y1, i] = arselect('SR09C___HCM3___AC0');
    hcm97SP = [hcm97SP y1];
    [y1, i] = arselect('SR09C___HCM3___AM0');
    hcm97AM = [hcm97AM y1];
    
    [y1, i] = arselect('SR09C___HCM4T__AC10');
    hcm98trimSP = [hcm98trimSP y1];
    [y1, i] = arselect('SR09C___HCM4___AC0');
    hcm98SP = [hcm98SP y1];
    [y1, i] = arselect('SR09C___HCM4___AM0');
    hcm98AM = [hcm98AM y1];
    
    [y1, i] = arselect('SR10C___HCM1T__AC10');
    hcm101trimSP = [hcm101trimSP y1];
    [y1, i] = arselect('SR10C___HCM1___AC0');
    hcm101SP = [hcm101SP y1];
    [y1, i] = arselect('SR10C___HCM1___AM0');
    hcm101AM = [hcm101AM y1];
    
    [y1, i] = arselect('SR10C___HCM2T__AC10');
    hcm102trimSP = [hcm102trimSP y1];
    [y1, i] = arselect('SR10C___HCM2___AC0');
    hcm102SP = [hcm102SP y1];
    [y1, i] = arselect('SR10C___HCM2___AM0');
    hcm102AM = [hcm102AM y1];
    
    [y1, i] = arselect('SR10C___HCM3T__AC10');
    hcm107trimSP = [hcm107trimSP y1];
    [y1, i] = arselect('SR10C___HCM3___AC0');
    hcm107SP = [hcm107SP y1];
    [y1, i] = arselect('SR10C___HCM3___AM0');
    hcm107AM = [hcm107AM y1];
    
    [y1, i] = arselect('SR10C___HCM4T__AC10');
    hcm108trimSP = [hcm108trimSP y1];
    [y1, i] = arselect('SR10C___HCM4___AC0');
    hcm108SP = [hcm108SP y1];
    [y1, i] = arselect('SR10C___HCM4___AM0');
    hcm108AM = [hcm108AM y1];
    
    [y1, i] = arselect('SR11C___HCM1T__AC10');
    hcm111trimSP = [hcm111trimSP y1];
    [y1, i] = arselect('SR11C___HCM1___AC0');
    hcm111SP = [hcm111SP y1];
    [y1, i] = arselect('SR11C___HCM1___AM0');
    hcm111AM = [hcm111AM y1];
    
    [y1, i] = arselect('SR11C___HCM2T__AC10');
    hcm112trimSP = [hcm112trimSP y1];
    [y1, i] = arselect('SR11C___HCM2___AC0');
    hcm112SP = [hcm112SP y1];
    [y1, i] = arselect('SR11C___HCM2___AM0');
    hcm112AM = [hcm112AM y1];
    
    [y1, i] = arselect('SR11C___HCM3T__AC10');
    hcm117trimSP = [hcm117trimSP y1];
    [y1, i] = arselect('SR11C___HCM3___AC0');
    hcm117SP = [hcm117SP y1];
    [y1, i] = arselect('SR11C___HCM3___AM0');
    hcm117AM = [hcm117AM y1];
    
    [y1, i] = arselect('SR11C___HCM4T__AC10');
    hcm118trimSP = [hcm118trimSP y1];
    [y1, i] = arselect('SR11C___HCM4___AC0');
    hcm118SP = [hcm118SP y1];
    [y1, i] = arselect('SR11C___HCM4___AM0');
    hcm118AM = [hcm118AM y1];
    
    [y1, i] = arselect('SR12C___HCM1T__AC10');
    hcm121trimSP = [hcm121trimSP y1];
    [y1, i] = arselect('SR12C___HCM1___AC0');
    hcm121SP = [hcm121SP y1];
    [y1, i] = arselect('SR12C___HCM1___AM0');
    hcm121AM = [hcm121AM y1];
    
    [y1, i] = arselect('SR12C___HCM2T__AC10');
    hcm122trimSP = [hcm122trimSP y1];
    [y1, i] = arselect('SR12C___HCM2___AC0');
    hcm122SP = [hcm122SP y1];
    [y1, i] = arselect('SR12C___HCM2___AM0');
    hcm122AM = [hcm122AM y1];
    
    [y1, i] = arselect('SR12C___HCM3T__AC10');
    hcm127trimSP = [hcm127trimSP y1];
    [y1, i] = arselect('SR12C___HCM3___AC0');
    hcm127SP = [hcm127SP y1];
    [y1, i] = arselect('SR12C___HCM3___AM0');
    hcm127AM = [hcm127AM y1];
    
    [y1, i] = arselect('SR12C___HCM4T__AC10');
    hcm128trimSP = [hcm128trimSP y1];
    [y1, i] = arselect('SR12C___HCM4___AC0');
    hcm128SP = [hcm128SP y1];
    [y1, i] = arselect('SR12C___HCM4___AM0');
    hcm128AM = [hcm128AM y1];
    
    
    %vertical
    [y1, i] = arselect('SR01C___VCM2T__AC10');
    vcm12trimSP = [vcm12trimSP y1];
    [y1, i] = arselect('SR01C___VCM2___AC0');
    vcm12SP = [vcm12SP y1];
    [y1, i] = arselect('SR01C___VCM2___AM0');
    vcm12AM = [vcm12AM y1];
    
    [y1, i] = arselect('SR01C___VCM3T__AC10');
    vcm13trimSP = [vcm13trimSP y1];
    [y1, i] = arselect('SR01C___VCM3___AC0');
    vcm13SP = [vcm13SP y1];
    [y1, i] = arselect('SR01C___VCM3___AM0');
    vcm13AM = [vcm13AM y1];
    
    [y1, i] = arselect('SR01C___VCM4T__AC10');
    vcm18trimSP = [vcm18trimSP y1];
    [y1, i] = arselect('SR01C___VCM4___AC0');
    vcm18SP = [vcm18SP y1];
    [y1, i] = arselect('SR01C___VCM4___AM0');
    vcm18AM = [vcm18AM y1];
    
    [y1, i] = arselect('SR02C___VCM1T__AC10');
    vcm21trimSP = [vcm21trimSP y1];
    [y1, i] = arselect('SR02C___VCM1___AC0');
    vcm21SP = [vcm21SP y1];
    [y1, i] = arselect('SR02C___VCM1___AM0');
    vcm21AM = [vcm21AM y1];
    
    [y1, i] = arselect('SR02C___VCM2T__AC10');
    vcm22trimSP = [vcm22trimSP y1];
    [y1, i] = arselect('SR02C___VCM2___AC0');
    vcm22SP = [vcm22SP y1];
    [y1, i] = arselect('SR02C___VCM2___AM0');
    vcm22AM = [vcm22AM y1];
    
    [y1, i] = arselect('SR02C___VCM3T__AC10');
    vcm23trimSP = [vcm23trimSP y1];
    [y1, i] = arselect('SR02C___VCM3___AC0');
    vcm23SP = [vcm23SP y1];
    [y1, i] = arselect('SR02C___VCM3___AM0');
    vcm23AM = [vcm23AM y1];
    
    [y1, i] = arselect('SR02C___VCM4T__AC10');
    vcm28trimSP = [vcm28trimSP y1];
    [y1, i] = arselect('SR02C___VCM4___AC0');
    vcm28SP = [vcm28SP y1];
    [y1, i] = arselect('SR02C___VCM4___AM0');
    vcm28AM = [vcm28AM y1];
    
    [y1, i] = arselect('SR03C___VCM1T__AC10');
    vcm31trimSP = [vcm31trimSP y1];
    [y1, i] = arselect('SR03C___VCM1___AC0');
    vcm31SP = [vcm31SP y1];
    [y1, i] = arselect('SR03C___VCM1___AM0');
    vcm31AM = [vcm31AM y1];
    
    [y1, i] = arselect('SR03C___VCM2T__AC10');
    vcm32trimSP = [vcm32trimSP y1];
    [y1, i] = arselect('SR03C___VCM2___AC0');
    vcm32SP = [vcm32SP y1];
    [y1, i] = arselect('SR03C___VCM2___AM0');
    vcm32AM = [vcm32AM y1];
    
    [y1, i] = arselect('SR03C___VCM3T__AC10');
    vcm33trimSP = [vcm33trimSP y1];
    [y1, i] = arselect('SR03C___VCM3___AC0');
    vcm33SP = [vcm33SP y1];
    [y1, i] = arselect('SR03C___VCM3___AM0');
    vcm33AM = [vcm33AM y1];
    
    [y1, i] = arselect('SR03C___VCM4T__AC10');
    vcm38trimSP = [vcm38trimSP y1];
    [y1, i] = arselect('SR03C___VCM4___AC0');
    vcm38SP = [vcm38SP y1];
    [y1, i] = arselect('SR03C___VCM4___AM0');
    vcm38AM = [vcm38AM y1];
    
    [y1, i] = arselect('SR04C___VCM1T__AC10');
    vcm41trimSP = [vcm41trimSP y1];
    [y1, i] = arselect('SR04C___VCM1___AC0');
    vcm41SP = [vcm41SP y1];
    [y1, i] = arselect('SR04C___VCM1___AM0');
    vcm41AM = [vcm41AM y1];
    
    [y1, i] = arselect('SR04C___VCM2T__AC10');
    vcm42trimSP = [vcm42trimSP y1];
    [y1, i] = arselect('SR04C___VCM2___AC0');
    vcm42SP = [vcm42SP y1];
    [y1, i] = arselect('SR04C___VCM2___AM0');
    vcm42AM = [vcm42AM y1];
    
    [y1, i] = arselect('SR04C___VCM3T__AC10');
    vcm43trimSP = [vcm43trimSP y1];
    [y1, i] = arselect('SR04C___VCM3___AC0');
    vcm43SP = [vcm43SP y1];
    [y1, i] = arselect('SR04C___VCM3___AM0');
    vcm43AM = [vcm43AM y1];
    
    [y1, i] = arselect('SR04C___VCM4T__AC10');
    vcm48trimSP = [vcm48trimSP y1];
    [y1, i] = arselect('SR04C___VCM4___AC0');
    vcm48SP = [vcm48SP y1];
    [y1, i] = arselect('SR04C___VCM4___AM0');
    vcm48AM = [vcm48AM y1];
    
    [y1, i] = arselect('SR05C___VCM1T__AC10');
    vcm51trimSP = [vcm51trimSP y1];
    [y1, i] = arselect('SR05C___VCM1___AC0');
    vcm51SP = [vcm51SP y1];
    [y1, i] = arselect('SR05C___VCM1___AM0');
    vcm51AM = [vcm51AM y1];
    
    [y1, i] = arselect('SR05C___VCM2T__AC10');
    vcm52trimSP = [vcm52trimSP y1];
    [y1, i] = arselect('SR05C___VCM2___AC0');
    vcm52SP = [vcm52SP y1];
    [y1, i] = arselect('SR05C___VCM2___AM0');
    vcm52AM = [vcm52AM y1];
    
    [y1, i] = arselect('SR05C___VCM3T__AC10');
    vcm53trimSP = [vcm53trimSP y1];
    [y1, i] = arselect('SR05C___VCM3___AC0');
    vcm53SP = [vcm53SP y1];
    [y1, i] = arselect('SR05C___VCM3___AM0');
    vcm53AM = [vcm53AM y1];
    
    [y1, i] = arselect('SR05C___VCM4T__AC10');
    vcm58trimSP = [vcm58trimSP y1];
    [y1, i] = arselect('SR05C___VCM4___AC0');
    vcm58SP = [vcm58SP y1];
    [y1, i] = arselect('SR05C___VCM4___AM0');
    vcm58AM = [vcm58AM y1];
    
    [y1, i] = arselect('SR06C___VCM1T__AC10');
    vcm61trimSP = [vcm61trimSP y1];
    [y1, i] = arselect('SR06C___VCM1___AC0');
    vcm61SP = [vcm61SP y1];
    [y1, i] = arselect('SR06C___VCM1___AM0');
    vcm61AM = [vcm61AM y1];
    
    [y1, i] = arselect('SR06C___VCM2T__AC10');
    vcm62trimSP = [vcm62trimSP y1];
    [y1, i] = arselect('SR06C___VCM2___AC0');
    vcm62SP = [vcm62SP y1];
    [y1, i] = arselect('SR06C___VCM2___AM0');
    vcm62AM = [vcm62AM y1];
    
    [y1, i] = arselect('SR06C___VCM3T__AC10');
    vcm63trimSP = [vcm63trimSP y1];
    [y1, i] = arselect('SR06C___VCM3___AC0');
    vcm63SP = [vcm63SP y1];
    [y1, i] = arselect('SR06C___VCM3___AM0');
    vcm63AM = [vcm63AM y1];
    
    [y1, i] = arselect('SR06C___VCM4T__AC10');
    vcm68trimSP = [vcm68trimSP y1];
    [y1, i] = arselect('SR06C___VCM4___AC0');
    vcm68SP = [vcm68SP y1];
    [y1, i] = arselect('SR06C___VCM4___AM0');
    vcm68AM = [vcm68AM y1];
    
    [y1, i] = arselect('SR07C___VCM1T__AC10');
    vcm71trimSP = [vcm71trimSP y1];
    [y1, i] = arselect('SR07C___VCM1___AC0');
    vcm71SP = [vcm71SP y1];
    [y1, i] = arselect('SR07C___VCM1___AM0');
    vcm71AM = [vcm71AM y1];
    
    [y1, i] = arselect('SR07C___VCM2T__AC10');
    vcm72trimSP = [vcm72trimSP y1];
    [y1, i] = arselect('SR07C___VCM2___AC0');
    vcm72SP = [vcm72SP y1];
    [y1, i] = arselect('SR07C___VCM2___AM0');
    vcm72AM = [vcm72AM y1];
    
    [y1, i] = arselect('SR07C___VCM3T__AC10');
    vcm73trimSP = [vcm73trimSP y1];
    [y1, i] = arselect('SR07C___VCM3___AC0');
    vcm73SP = [vcm73SP y1];
    [y1, i] = arselect('SR07C___VCM3___AM0');
    vcm73AM = [vcm73AM y1];
    
    [y1, i] = arselect('SR07C___VCM4T__AC10');
    vcm78trimSP = [vcm78trimSP y1];
    [y1, i] = arselect('SR07C___VCM4___AC0');
    vcm78SP = [vcm78SP y1];
    [y1, i] = arselect('SR07C___VCM4___AM0');
    vcm78AM = [vcm78AM y1];
    
    [y1, i] = arselect('SR08C___VCM1T__AC10');
    vcm81trimSP = [vcm81trimSP y1];
    [y1, i] = arselect('SR08C___VCM1___AC0');
    vcm81SP = [vcm81SP y1];
    [y1, i] = arselect('SR08C___VCM1___AM0');
    vcm81AM = [vcm81AM y1];
    
    [y1, i] = arselect('SR08C___VCM2T__AC10');
    vcm82trimSP = [vcm82trimSP y1];
    [y1, i] = arselect('SR08C___VCM2___AC0');
    vcm82SP = [vcm82SP y1];
    [y1, i] = arselect('SR08C___VCM2___AM0');
    vcm82AM = [vcm82AM y1];
    
    [y1, i] = arselect('SR08C___VCM3T__AC10');
    vcm83trimSP = [vcm83trimSP y1];
    [y1, i] = arselect('SR08C___VCM3___AC0');
    vcm83SP = [vcm83SP y1];
    [y1, i] = arselect('SR08C___VCM3___AM0');
    vcm83AM = [vcm83AM y1];
    
    [y1, i] = arselect('SR08C___VCM4T__AC10');
    vcm88trimSP = [vcm88trimSP y1];
    [y1, i] = arselect('SR08C___VCM4___AC0');
    vcm88SP = [vcm88SP y1];
    [y1, i] = arselect('SR08C___VCM4___AM0');
    vcm88AM = [vcm88AM y1];
    
    [y1, i] = arselect('SR09C___VCM1T__AC10');
    vcm91trimSP = [vcm91trimSP y1];
    [y1, i] = arselect('SR09C___VCM1___AC0');
    vcm91SP = [vcm91SP y1];
    [y1, i] = arselect('SR09C___VCM1___AM0');
    vcm91AM = [vcm91AM y1];
    
    [y1, i] = arselect('SR09C___VCM2T__AC10');
    vcm92trimSP = [vcm92trimSP y1];
    [y1, i] = arselect('SR09C___VCM2___AC0');
    vcm92SP = [vcm92SP y1];
    [y1, i] = arselect('SR09C___VCM2___AM0');
    vcm92AM = [vcm92AM y1];
    
    [y1, i] = arselect('SR09C___VCM3T__AC10');
    vcm93trimSP = [vcm93trimSP y1];
    [y1, i] = arselect('SR09C___VCM3___AC0');
    vcm93SP = [vcm93SP y1];
    [y1, i] = arselect('SR09C___VCM3___AM0');
    vcm93AM = [vcm93AM y1];
    
    [y1, i] = arselect('SR09C___VCM4T__AC10');
    vcm98trimSP = [vcm98trimSP y1];
    [y1, i] = arselect('SR09C___VCM4___AC0');
    vcm98SP = [vcm98SP y1];
    [y1, i] = arselect('SR09C___VCM4___AM0');
    vcm98AM = [vcm98AM y1];
    
    [y1, i] = arselect('SR10C___VCM1T__AC10');
    vcm101trimSP = [vcm101trimSP y1];
    [y1, i] = arselect('SR10C___VCM1___AC0');
    vcm101SP = [vcm101SP y1];
    [y1, i] = arselect('SR10C___VCM1___AM0');
    vcm101AM = [vcm101AM y1];
    
    [y1, i] = arselect('SR10C___VCM2T__AC10');
    vcm102trimSP = [vcm102trimSP y1];
    [y1, i] = arselect('SR10C___VCM2___AC0');
    vcm102SP = [vcm102SP y1];
    [y1, i] = arselect('SR10C___VCM2___AM0');
    vcm102AM = [vcm102AM y1];
    
    [y1, i] = arselect('SR10C___VCM3T__AC10');
    vcm103trimSP = [vcm103trimSP y1];
    [y1, i] = arselect('SR10C___VCM3___AC0');
    vcm103SP = [vcm103SP y1];
    [y1, i] = arselect('SR10C___VCM3___AM0');
    vcm103AM = [vcm103AM y1];
    
    [y1, i] = arselect('SR10C___VCM4T__AC10');
    vcm108trimSP = [vcm108trimSP y1];
    [y1, i] = arselect('SR10C___VCM4___AC0');
    vcm108SP = [vcm108SP y1];
    [y1, i] = arselect('SR10C___VCM4___AM0');
    vcm108AM = [vcm108AM y1];
    
    [y1, i] = arselect('SR11C___VCM1T__AC10');
    vcm111trimSP = [vcm111trimSP y1];
    [y1, i] = arselect('SR11C___VCM1___AC0');
    vcm111SP = [vcm111SP y1];
    [y1, i] = arselect('SR11C___VCM1___AM0');
    vcm111AM = [vcm111AM y1];
    
    [y1, i] = arselect('SR11C___VCM2T__AC10');
    vcm112trimSP = [vcm112trimSP y1];
    [y1, i] = arselect('SR11C___VCM2___AC0');
    vcm112SP = [vcm112SP y1];
    [y1, i] = arselect('SR11C___VCM2___AM0');
    vcm112AM = [vcm112AM y1];
    
    [y1, i] = arselect('SR11C___VCM3T__AC10');
    vcm113trimSP = [vcm113trimSP y1];
    [y1, i] = arselect('SR11C___VCM3___AC0');
    vcm113SP = [vcm113SP y1];
    [y1, i] = arselect('SR11C___VCM3___AM0');
    vcm113AM = [vcm113AM y1];
    
    [y1, i] = arselect('SR11C___VCM4T__AC10');
    vcm118trimSP = [vcm118trimSP y1];
    [y1, i] = arselect('SR11C___VCM4___AC0');
    vcm118SP = [vcm118SP y1];
    [y1, i] = arselect('SR11C___VCM4___AM0');
    vcm118AM = [vcm118AM y1];
    
    [y1, i] = arselect('SR12C___VCM1T__AC10');
    vcm121trimSP = [vcm121trimSP y1];
    [y1, i] = arselect('SR12C___VCM1___AC0');
    vcm121SP = [vcm121SP y1];
    [y1, i] = arselect('SR12C___VCM1___AM0');
    vcm121AM = [vcm121AM y1];
    
    [y1, i] = arselect('SR12C___VCM2T__AC10');
    vcm122trimSP = [vcm122trimSP y1];
    [y1, i] = arselect('SR12C___VCM2___AC0');
    vcm122SP = [vcm122SP y1];
    [y1, i] = arselect('SR12C___VCM2___AM0');
    vcm122AM = [vcm122AM y1];
    
    [y1, i] = arselect('SR12C___VCM3T__AC10');
    vcm123trimSP = [vcm123trimSP y1];
    [y1, i] = arselect('SR12C___VCM3___AC0');
    vcm123SP = [vcm123SP y1];
    [y1, i] = arselect('SR12C___VCM3___AM0');
    vcm123AM = [vcm123AM y1];
    
    [y1, i] = arselect('SR12C___VCM4T__AC10');
    vcm128trimSP = [vcm128trimSP y1];
    [y1, i] = arselect('SR12C___VCM4___AC0');
    vcm128SP = [vcm128SP y1];
    [y1, i] = arselect('SR12C___VCM4___AM0');
    vcm128AM = [vcm128AM y1];
    
    
    
    t    = [t  ARt+(day-StartDay)*24*60*60];
    
    disp(' ');
end


if ~isempty(days2)
    
    StartDay = days2(1);
    EndDay = days2(length(days2));
    
    for day = days2
        
        year2str = num2str(year2);
        
        if year2 < 2000
            year2str = year2str(3:4);
            FileName = sprintf('%2s%02d%02d', year2str, month2, day);
        else
            FileName = sprintf('%4s%02d%02d', year2str, month2, day);
        end
        
        FileName = sprintf('%2s%02d%02d', year2str, month2, day);
        
        arread(FileName);
        %readtime = etime(clock, t0)
        
        [y1, i] = arselect('SR01C___HCM2T__AC10');
        hcm12trimSP = [hcm12trimSP y1];
        [y1, i] = arselect('SR01C___HCM2___AC0');
        hcm12SP = [hcm12SP y1];
        [y1, i] = arselect('SR01C___HCM2___AM0');
        hcm12AM = [hcm12AM y1];
        
        [y1, i] = arselect('SR01C___HCM3T__AC10');
        hcm17trimSP = [hcm17trimSP y1];
        [y1, i] = arselect('SR01C___HCM3___AC0');
        hcm17SP = [hcm17SP y1];
        [y1, i] = arselect('SR01C___HCM3___AM0');
        hcm17AM = [hcm17AM y1];
        
        [y1, i] = arselect('SR01C___HCM4T__AC10');
        hcm18trimSP = [hcm18trimSP y1];
        [y1, i] = arselect('SR01C___HCM4___AC0');
        hcm18SP = [hcm18SP y1];
        [y1, i] = arselect('SR01C___HCM4___AM0');
        hcm18AM = [hcm18AM y1];
        
        [y1, i] = arselect('SR02C___HCM1T__AC10');
        hcm21trimSP = [hcm21trimSP y1];
        [y1, i] = arselect('SR02C___HCM1___AC0');
        hcm21SP = [hcm21SP y1];
        [y1, i] = arselect('SR02C___HCM1___AM0');
        hcm21AM = [hcm21AM y1];
        
        [y1, i] = arselect('SR02C___HCM2T__AC10');
        hcm22trimSP = [hcm22trimSP y1];
        [y1, i] = arselect('SR02C___HCM2___AC0');
        hcm22SP = [hcm22SP y1];
        [y1, i] = arselect('SR02C___HCM2___AM0');
        hcm22AM = [hcm22AM y1];
        
        [y1, i] = arselect('SR02C___HCM3T__AC10');
        hcm27trimSP = [hcm27trimSP y1];
        [y1, i] = arselect('SR02C___HCM3___AC0');
        hcm27SP = [hcm27SP y1];
        [y1, i] = arselect('SR02C___HCM3___AM0');
        hcm27AM = [hcm27AM y1];
        
        [y1, i] = arselect('SR02C___HCM4T__AC10');
        hcm28trimSP = [hcm28trimSP y1];
        [y1, i] = arselect('SR02C___HCM4___AC0');
        hcm28SP = [hcm28SP y1];
        [y1, i] = arselect('SR02C___HCM4___AM0');
        hcm28AM = [hcm28AM y1];
        
        [y1, i] = arselect('SR03C___HCM1T__AC10');
        hcm31trimSP = [hcm31trimSP y1];
        [y1, i] = arselect('SR03C___HCM1___AC0');
        hcm31SP = [hcm31SP y1];
        [y1, i] = arselect('SR03C___HCM1___AM0');
        hcm31AM = [hcm31AM y1];
        
        [y1, i] = arselect('SR03C___HCM2T__AC10');
        hcm32trimSP = [hcm32trimSP y1];
        [y1, i] = arselect('SR03C___HCM2___AC0');
        hcm32SP = [hcm32SP y1];
        [y1, i] = arselect('SR03C___HCM2___AM0');
        hcm32AM = [hcm32AM y1];
        
        [y1, i] = arselect('SR03C___HCM3T__AC10');
        hcm37trimSP = [hcm37trimSP y1];
        [y1, i] = arselect('SR03C___HCM3___AC0');
        hcm37SP = [hcm37SP y1];
        [y1, i] = arselect('SR03C___HCM3___AM0');
        hcm37AM = [hcm37AM y1];
        
        [y1, i] = arselect('SR03C___HCM4T__AC10');
        hcm38trimSP = [hcm38trimSP y1];
        [y1, i] = arselect('SR03C___HCM4___AC0');
        hcm38SP = [hcm38SP y1];
        [y1, i] = arselect('SR03C___HCM4___AM0');
        hcm38AM = [hcm38AM y1];
        
        [y1, i] = arselect('SR04C___HCM1T__AC10');
        hcm41trimSP = [hcm41trimSP y1];
        [y1, i] = arselect('SR04C___HCM1___AC0');
        hcm41SP = [hcm41SP y1];
        [y1, i] = arselect('SR04C___HCM1___AM0');
        hcm41AM = [hcm41AM y1];
        
        [y1, i] = arselect('SR04C___HCM2T__AC10');
        hcm42trimSP = [hcm42trimSP y1];
        [y1, i] = arselect('SR04C___HCM2___AC0');
        hcm42SP = [hcm42SP y1];
        [y1, i] = arselect('SR04C___HCM2___AM0');
        hcm42AM = [hcm42AM y1];
        
        [y1, i] = arselect('SR04C___HCM3T__AC10');
        hcm47trimSP = [hcm47trimSP y1];
        [y1, i] = arselect('SR04C___HCM3___AC0');
        hcm47SP = [hcm47SP y1];
        [y1, i] = arselect('SR04C___HCM3___AM0');
        hcm47AM = [hcm47AM y1];
        
        [y1, i] = arselect('SR04C___HCM4T__AC10');
        hcm48trimSP = [hcm48trimSP y1];
        [y1, i] = arselect('SR04C___HCM4___AC0');
        hcm48SP = [hcm48SP y1];
        [y1, i] = arselect('SR04C___HCM4___AM0');
        hcm48AM = [hcm48AM y1];
        
        [y1, i] = arselect('SR05C___HCM1T__AC10');
        hcm51trimSP = [hcm51trimSP y1];
        [y1, i] = arselect('SR05C___HCM1___AC0');
        hcm51SP = [hcm51SP y1];
        [y1, i] = arselect('SR05C___HCM1___AM0');
        hcm51AM = [hcm51AM y1];
        
        [y1, i] = arselect('SR05C___HCM2T__AC10');
        hcm52trimSP = [hcm52trimSP y1];
        [y1, i] = arselect('SR05C___HCM2___AC0');
        hcm52SP = [hcm52SP y1];
        [y1, i] = arselect('SR05C___HCM2___AM0');
        hcm52AM = [hcm52AM y1];
        
        [y1, i] = arselect('SR05C___HCM3T__AC10');
        hcm57trimSP = [hcm57trimSP y1];
        [y1, i] = arselect('SR05C___HCM3___AC0');
        hcm57SP = [hcm57SP y1];
        [y1, i] = arselect('SR05C___HCM3___AM0');
        hcm57AM = [hcm57AM y1];
        
        [y1, i] = arselect('SR05C___HCM4T__AC10');
        hcm58trimSP = [hcm58trimSP y1];
        [y1, i] = arselect('SR05C___HCM4___AC0');
        hcm58SP = [hcm58SP y1];
        [y1, i] = arselect('SR05C___HCM4___AM0');
        hcm58AM = [hcm58AM y1];
        
        [y1, i] = arselect('SR06C___HCM1T__AC10');
        hcm61trimSP = [hcm61trimSP y1];
        [y1, i] = arselect('SR06C___HCM1___AC0');
        hcm61SP = [hcm61SP y1];
        [y1, i] = arselect('SR06C___HCM1___AM0');
        hcm61AM = [hcm61AM y1];
        
        [y1, i] = arselect('SR06C___HCM2T__AC10');
        hcm62trimSP = [hcm62trimSP y1];
        [y1, i] = arselect('SR06C___HCM2___AC0');
        hcm62SP = [hcm62SP y1];
        [y1, i] = arselect('SR06C___HCM2___AM0');
        hcm62AM = [hcm62AM y1];
        
        [y1, i] = arselect('SR06C___HCM3T__AC10');
        hcm67trimSP = [hcm67trimSP y1];
        [y1, i] = arselect('SR06C___HCM3___AC0');
        hcm67SP = [hcm67SP y1];
        [y1, i] = arselect('SR06C___HCM3___AM0');
        hcm67AM = [hcm67AM y1];
        
        [y1, i] = arselect('SR06C___HCM4T__AC10');
        hcm68trimSP = [hcm68trimSP y1];
        [y1, i] = arselect('SR06C___HCM4___AC0');
        hcm68SP = [hcm68SP y1];
        [y1, i] = arselect('SR06C___HCM4___AM0');
        hcm68AM = [hcm68AM y1];
        
        [y1, i] = arselect('SR07C___HCM1T__AC10');
        hcm71trimSP = [hcm71trimSP y1];
        [y1, i] = arselect('SR07C___HCM1___AC0');
        hcm71SP = [hcm71SP y1];
        [y1, i] = arselect('SR07C___HCM1___AM0');
        hcm71AM = [hcm71AM y1];
        
        [y1, i] = arselect('SR07C___HCM2T__AC10');
        hcm72trimSP = [hcm72trimSP y1];
        [y1, i] = arselect('SR07C___HCM2___AC0');
        hcm72SP = [hcm72SP y1];
        [y1, i] = arselect('SR07C___HCM2___AM0');
        hcm72AM = [hcm72AM y1];
        
        [y1, i] = arselect('SR07C___HCM3T__AC10');
        hcm77trimSP = [hcm77trimSP y1];
        [y1, i] = arselect('SR07C___HCM3___AC0');
        hcm77SP = [hcm77SP y1];
        [y1, i] = arselect('SR07C___HCM3___AM0');
        hcm77AM = [hcm77AM y1];
        
        [y1, i] = arselect('SR07C___HCM4T__AC10');
        hcm78trimSP = [hcm78trimSP y1];
        [y1, i] = arselect('SR07C___HCM4___AC0');
        hcm78SP = [hcm78SP y1];
        [y1, i] = arselect('SR07C___HCM4___AM0');
        hcm78AM = [hcm78AM y1];
        
        [y1, i] = arselect('SR08C___HCM1T__AC10');
        hcm81trimSP = [hcm81trimSP y1];
        [y1, i] = arselect('SR08C___HCM1___AC0');
        hcm81SP = [hcm81SP y1];
        [y1, i] = arselect('SR08C___HCM1___AM0');
        hcm81AM = [hcm81AM y1];
        
        [y1, i] = arselect('SR08C___HCM2T__AC10');
        hcm82trimSP = [hcm82trimSP y1];
        [y1, i] = arselect('SR08C___HCM2___AC0');
        hcm82SP = [hcm82SP y1];
        [y1, i] = arselect('SR08C___HCM2___AM0');
        hcm82AM = [hcm82AM y1];
        
        [y1, i] = arselect('SR08C___HCM3T__AC10');
        hcm87trimSP = [hcm87trimSP y1];
        [y1, i] = arselect('SR08C___HCM3___AC0');
        hcm87SP = [hcm87SP y1];
        [y1, i] = arselect('SR08C___HCM3___AM0');
        hcm87AM = [hcm87AM y1];
        
        [y1, i] = arselect('SR08C___HCM4T__AC10');
        hcm88trimSP = [hcm88trimSP y1];
        [y1, i] = arselect('SR08C___HCM4___AC0');
        hcm88SP = [hcm88SP y1];
        [y1, i] = arselect('SR08C___HCM4___AM0');
        hcm88AM = [hcm88AM y1];
        
        [y1, i] = arselect('SR09C___HCM1T__AC10');
        hcm91trimSP = [hcm91trimSP y1];
        [y1, i] = arselect('SR09C___HCM1___AC0');
        hcm91SP = [hcm91SP y1];
        [y1, i] = arselect('SR09C___HCM1___AM0');
        hcm91AM = [hcm91AM y1];
        
        [y1, i] = arselect('SR09C___HCM2T__AC10');
        hcm92trimSP = [hcm92trimSP y1];
        [y1, i] = arselect('SR09C___HCM2___AC0');
        hcm92SP = [hcm92SP y1];
        [y1, i] = arselect('SR09C___HCM2___AM0');
        hcm92AM = [hcm92AM y1];
        
        [y1, i] = arselect('SR09C___HCM3T__AC10');
        hcm97trimSP = [hcm97trimSP y1];
        [y1, i] = arselect('SR09C___HCM3___AC0');
        hcm97SP = [hcm97SP y1];
        [y1, i] = arselect('SR09C___HCM3___AM0');
        hcm97AM = [hcm97AM y1];
        
        [y1, i] = arselect('SR09C___HCM4T__AC10');
        hcm98trimSP = [hcm98trimSP y1];
        [y1, i] = arselect('SR09C___HCM4___AC0');
        hcm98SP = [hcm98SP y1];
        [y1, i] = arselect('SR09C___HCM4___AM0');
        hcm98AM = [hcm98AM y1];
        
        [y1, i] = arselect('SR10C___HCM1T__AC10');
        hcm101trimSP = [hcm101trimSP y1];
        [y1, i] = arselect('SR10C___HCM1___AC0');
        hcm101SP = [hcm101SP y1];
        [y1, i] = arselect('SR10C___HCM1___AM0');
        hcm101AM = [hcm101AM y1];
        
        [y1, i] = arselect('SR10C___HCM2T__AC10');
        hcm102trimSP = [hcm102trimSP y1];
        [y1, i] = arselect('SR10C___HCM2___AC0');
        hcm102SP = [hcm102SP y1];
        [y1, i] = arselect('SR10C___HCM2___AM0');
        hcm102AM = [hcm102AM y1];
        
        [y1, i] = arselect('SR10C___HCM3T__AC10');
        hcm107trimSP = [hcm107trimSP y1];
        [y1, i] = arselect('SR10C___HCM3___AC0');
        hcm107SP = [hcm107SP y1];
        [y1, i] = arselect('SR10C___HCM3___AM0');
        hcm107AM = [hcm107AM y1];
        
        [y1, i] = arselect('SR10C___HCM4T__AC10');
        hcm108trimSP = [hcm108trimSP y1];
        [y1, i] = arselect('SR10C___HCM4___AC0');
        hcm108SP = [hcm108SP y1];
        [y1, i] = arselect('SR10C___HCM4___AM0');
        hcm108AM = [hcm108AM y1];
        
        [y1, i] = arselect('SR11C___HCM1T__AC10');
        hcm111trimSP = [hcm111trimSP y1];
        [y1, i] = arselect('SR11C___HCM1___AC0');
        hcm111SP = [hcm111SP y1];
        [y1, i] = arselect('SR11C___HCM1___AM0');
        hcm111AM = [hcm111AM y1];
        
        [y1, i] = arselect('SR11C___HCM2T__AC10');
        hcm112trimSP = [hcm112trimSP y1];
        [y1, i] = arselect('SR11C___HCM2___AC0');
        hcm112SP = [hcm112SP y1];
        [y1, i] = arselect('SR11C___HCM2___AM0');
        hcm112AM = [hcm112AM y1];
        
        [y1, i] = arselect('SR11C___HCM3T__AC10');
        hcm117trimSP = [hcm117trimSP y1];
        [y1, i] = arselect('SR11C___HCM3___AC0');
        hcm117SP = [hcm117SP y1];
        [y1, i] = arselect('SR11C___HCM3___AM0');
        hcm117AM = [hcm117AM y1];
        
        [y1, i] = arselect('SR11C___HCM4T__AC10');
        hcm118trimSP = [hcm118trimSP y1];
        [y1, i] = arselect('SR11C___HCM4___AC0');
        hcm118SP = [hcm118SP y1];
        [y1, i] = arselect('SR11C___HCM4___AM0');
        hcm118AM = [hcm118AM y1];
        
        [y1, i] = arselect('SR12C___HCM1T__AC10');
        hcm121trimSP = [hcm121trimSP y1];
        [y1, i] = arselect('SR12C___HCM1___AC0');
        hcm121SP = [hcm121SP y1];
        [y1, i] = arselect('SR12C___HCM1___AM0');
        hcm121AM = [hcm121AM y1];
        
        [y1, i] = arselect('SR12C___HCM2T__AC10');
        hcm122trimSP = [hcm122trimSP y1];
        [y1, i] = arselect('SR12C___HCM2___AC0');
        hcm122SP = [hcm122SP y1];
        [y1, i] = arselect('SR12C___HCM2___AM0');
        hcm122AM = [hcm122AM y1];
        
        [y1, i] = arselect('SR12C___HCM3T__AC10');
        hcm127trimSP = [hcm127trimSP y1];
        [y1, i] = arselect('SR12C___HCM3___AC0');
        hcm127SP = [hcm127SP y1];
        [y1, i] = arselect('SR12C___HCM3___AM0');
        hcm127AM = [hcm127AM y1];
        
        [y1, i] = arselect('SR12C___HCM4T__AC10');
        hcm128trimSP = [hcm128trimSP y1];
        [y1, i] = arselect('SR12C___HCM4___AC0');
        hcm128SP = [hcm128SP y1];
        [y1, i] = arselect('SR12C___HCM4___AM0');
        hcm128AM = [hcm128AM y1];
        
        
        %vertical
        [y1, i] = arselect('SR01C___VCM2T__AC10');
        vcm12trimSP = [vcm12trimSP y1];
        [y1, i] = arselect('SR01C___VCM2___AC0');
        vcm12SP = [vcm12SP y1];
        [y1, i] = arselect('SR01C___VCM2___AM0');
        vcm12AM = [vcm12AM y1];
        
        [y1, i] = arselect('SR01C___VCM3T__AC10');
        vcm13trimSP = [vcm13trimSP y1];
        [y1, i] = arselect('SR01C___VCM3___AC0');
        vcm13SP = [vcm13SP y1];
        [y1, i] = arselect('SR01C___VCM3___AM0');
        vcm13AM = [vcm13AM y1];
        
        [y1, i] = arselect('SR01C___VCM4T__AC10');
        vcm18trimSP = [vcm18trimSP y1];
        [y1, i] = arselect('SR01C___VCM4___AC0');
        vcm18SP = [vcm18SP y1];
        [y1, i] = arselect('SR01C___VCM4___AM0');
        vcm18AM = [vcm18AM y1];
        
        [y1, i] = arselect('SR02C___VCM1T__AC10');
        vcm21trimSP = [vcm21trimSP y1];
        [y1, i] = arselect('SR02C___VCM1___AC0');
        vcm21SP = [vcm21SP y1];
        [y1, i] = arselect('SR02C___VCM1___AM0');
        vcm21AM = [vcm21AM y1];
        
        [y1, i] = arselect('SR02C___VCM2T__AC10');
        vcm22trimSP = [vcm22trimSP y1];
        [y1, i] = arselect('SR02C___VCM2___AC0');
        vcm22SP = [vcm22SP y1];
        [y1, i] = arselect('SR02C___VCM2___AM0');
        vcm22AM = [vcm22AM y1];
        
        [y1, i] = arselect('SR02C___VCM3T__AC10');
        vcm23trimSP = [vcm23trimSP y1];
        [y1, i] = arselect('SR02C___VCM3___AC0');
        vcm23SP = [vcm23SP y1];
        [y1, i] = arselect('SR02C___VCM3___AM0');
        vcm23AM = [vcm23AM y1];
        
        [y1, i] = arselect('SR02C___VCM4T__AC10');
        vcm28trimSP = [vcm28trimSP y1];
        [y1, i] = arselect('SR02C___VCM4___AC0');
        vcm28SP = [vcm28SP y1];
        [y1, i] = arselect('SR02C___VCM4___AM0');
        vcm28AM = [vcm28AM y1];
        
        [y1, i] = arselect('SR03C___VCM1T__AC10');
        vcm31trimSP = [vcm31trimSP y1];
        [y1, i] = arselect('SR03C___VCM1___AC0');
        vcm31SP = [vcm31SP y1];
        [y1, i] = arselect('SR03C___VCM1___AM0');
        vcm31AM = [vcm31AM y1];
        
        [y1, i] = arselect('SR03C___VCM2T__AC10');
        vcm32trimSP = [vcm32trimSP y1];
        [y1, i] = arselect('SR03C___VCM2___AC0');
        vcm32SP = [vcm32SP y1];
        [y1, i] = arselect('SR03C___VCM2___AM0');
        vcm32AM = [vcm32AM y1];
        
        [y1, i] = arselect('SR03C___VCM3T__AC10');
        vcm33trimSP = [vcm33trimSP y1];
        [y1, i] = arselect('SR03C___VCM3___AC0');
        vcm33SP = [vcm33SP y1];
        [y1, i] = arselect('SR03C___VCM3___AM0');
        vcm33AM = [vcm33AM y1];
        
        [y1, i] = arselect('SR03C___VCM4T__AC10');
        vcm38trimSP = [vcm38trimSP y1];
        [y1, i] = arselect('SR03C___VCM4___AC0');
        vcm38SP = [vcm38SP y1];
        [y1, i] = arselect('SR03C___VCM4___AM0');
        vcm38AM = [vcm38AM y1];
        
        [y1, i] = arselect('SR04C___VCM1T__AC10');
        vcm41trimSP = [vcm41trimSP y1];
        [y1, i] = arselect('SR04C___VCM1___AC0');
        vcm41SP = [vcm41SP y1];
        [y1, i] = arselect('SR04C___VCM1___AM0');
        vcm41AM = [vcm41AM y1];
        
        [y1, i] = arselect('SR04C___VCM2T__AC10');
        vcm42trimSP = [vcm42trimSP y1];
        [y1, i] = arselect('SR04C___VCM2___AC0');
        vcm42SP = [vcm42SP y1];
        [y1, i] = arselect('SR04C___VCM2___AM0');
        vcm42AM = [vcm42AM y1];
        
        [y1, i] = arselect('SR04C___VCM3T__AC10');
        vcm43trimSP = [vcm43trimSP y1];
        [y1, i] = arselect('SR04C___VCM3___AC0');
        vcm43SP = [vcm43SP y1];
        [y1, i] = arselect('SR04C___VCM3___AM0');
        vcm43AM = [vcm43AM y1];
        
        [y1, i] = arselect('SR04C___VCM4T__AC10');
        vcm48trimSP = [vcm48trimSP y1];
        [y1, i] = arselect('SR04C___VCM4___AC0');
        vcm48SP = [vcm48SP y1];
        [y1, i] = arselect('SR04C___VCM4___AM0');
        vcm48AM = [vcm48AM y1];
        
        [y1, i] = arselect('SR05C___VCM1T__AC10');
        vcm51trimSP = [vcm51trimSP y1];
        [y1, i] = arselect('SR05C___VCM1___AC0');
        vcm51SP = [vcm51SP y1];
        [y1, i] = arselect('SR05C___VCM1___AM0');
        vcm51AM = [vcm51AM y1];
        
        [y1, i] = arselect('SR05C___VCM2T__AC10');
        vcm52trimSP = [vcm52trimSP y1];
        [y1, i] = arselect('SR05C___VCM2___AC0');
        vcm52SP = [vcm52SP y1];
        [y1, i] = arselect('SR05C___VCM2___AM0');
        vcm52AM = [vcm52AM y1];
        
        [y1, i] = arselect('SR05C___VCM3T__AC10');
        vcm53trimSP = [vcm53trimSP y1];
        [y1, i] = arselect('SR05C___VCM3___AC0');
        vcm53SP = [vcm53SP y1];
        [y1, i] = arselect('SR05C___VCM3___AM0');
        vcm53AM = [vcm53AM y1];
        
        [y1, i] = arselect('SR05C___VCM4T__AC10');
        vcm58trimSP = [vcm58trimSP y1];
        [y1, i] = arselect('SR05C___VCM4___AC0');
        vcm58SP = [vcm58SP y1];
        [y1, i] = arselect('SR05C___VCM4___AM0');
        vcm58AM = [vcm58AM y1];
        
        [y1, i] = arselect('SR06C___VCM1T__AC10');
        vcm61trimSP = [vcm61trimSP y1];
        [y1, i] = arselect('SR06C___VCM1___AC0');
        vcm61SP = [vcm61SP y1];
        [y1, i] = arselect('SR06C___VCM1___AM0');
        vcm61AM = [vcm61AM y1];
        
        [y1, i] = arselect('SR06C___VCM2T__AC10');
        vcm62trimSP = [vcm62trimSP y1];
        [y1, i] = arselect('SR06C___VCM2___AC0');
        vcm62SP = [vcm62SP y1];
        [y1, i] = arselect('SR06C___VCM2___AM0');
        vcm62AM = [vcm62AM y1];
        
        [y1, i] = arselect('SR06C___VCM3T__AC10');
        vcm63trimSP = [vcm63trimSP y1];
        [y1, i] = arselect('SR06C___VCM3___AC0');
        vcm63SP = [vcm63SP y1];
        [y1, i] = arselect('SR06C___VCM3___AM0');
        vcm63AM = [vcm63AM y1];
        
        [y1, i] = arselect('SR06C___VCM4T__AC10');
        vcm68trimSP = [vcm68trimSP y1];
        [y1, i] = arselect('SR06C___VCM4___AC0');
        vcm68SP = [vcm68SP y1];
        [y1, i] = arselect('SR06C___VCM4___AM0');
        vcm68AM = [vcm68AM y1];
        
        [y1, i] = arselect('SR07C___VCM1T__AC10');
        vcm71trimSP = [vcm71trimSP y1];
        [y1, i] = arselect('SR07C___VCM1___AC0');
        vcm71SP = [vcm71SP y1];
        [y1, i] = arselect('SR07C___VCM1___AM0');
        vcm71AM = [vcm71AM y1];
        
        [y1, i] = arselect('SR07C___VCM2T__AC10');
        vcm72trimSP = [vcm72trimSP y1];
        [y1, i] = arselect('SR07C___VCM2___AC0');
        vcm72SP = [vcm72SP y1];
        [y1, i] = arselect('SR07C___VCM2___AM0');
        vcm72AM = [vcm72AM y1];
        
        [y1, i] = arselect('SR07C___VCM3T__AC10');
        vcm73trimSP = [vcm73trimSP y1];
        [y1, i] = arselect('SR07C___VCM3___AC0');
        vcm73SP = [vcm73SP y1];
        [y1, i] = arselect('SR07C___VCM3___AM0');
        vcm73AM = [vcm73AM y1];
        
        [y1, i] = arselect('SR07C___VCM4T__AC10');
        vcm78trimSP = [vcm78trimSP y1];
        [y1, i] = arselect('SR07C___VCM4___AC0');
        vcm78SP = [vcm78SP y1];
        [y1, i] = arselect('SR07C___VCM4___AM0');
        vcm78AM = [vcm78AM y1];
        
        [y1, i] = arselect('SR08C___VCM1T__AC10');
        vcm81trimSP = [vcm81trimSP y1];
        [y1, i] = arselect('SR08C___VCM1___AC0');
        vcm81SP = [vcm81SP y1];
        [y1, i] = arselect('SR08C___VCM1___AM0');
        vcm81AM = [vcm81AM y1];
        
        [y1, i] = arselect('SR08C___VCM2T__AC10');
        vcm82trimSP = [vcm82trimSP y1];
        [y1, i] = arselect('SR08C___VCM2___AC0');
        vcm82SP = [vcm82SP y1];
        [y1, i] = arselect('SR08C___VCM2___AM0');
        vcm82AM = [vcm82AM y1];
        
        [y1, i] = arselect('SR08C___VCM3T__AC10');
        vcm83trimSP = [vcm83trimSP y1];
        [y1, i] = arselect('SR08C___VCM3___AC0');
        vcm83SP = [vcm83SP y1];
        [y1, i] = arselect('SR08C___VCM3___AM0');
        vcm83AM = [vcm83AM y1];
        
        [y1, i] = arselect('SR08C___VCM4T__AC10');
        vcm88trimSP = [vcm88trimSP y1];
        [y1, i] = arselect('SR08C___VCM4___AC0');
        vcm88SP = [vcm88SP y1];
        [y1, i] = arselect('SR08C___VCM4___AM0');
        vcm88AM = [vcm88AM y1];
        
        [y1, i] = arselect('SR09C___VCM1T__AC10');
        vcm91trimSP = [vcm91trimSP y1];
        [y1, i] = arselect('SR09C___VCM1___AC0');
        vcm91SP = [vcm91SP y1];
        [y1, i] = arselect('SR09C___VCM1___AM0');
        vcm91AM = [vcm91AM y1];
        
        [y1, i] = arselect('SR09C___VCM2T__AC10');
        vcm92trimSP = [vcm92trimSP y1];
        [y1, i] = arselect('SR09C___VCM2___AC0');
        vcm92SP = [vcm92SP y1];
        [y1, i] = arselect('SR09C___VCM2___AM0');
        vcm92AM = [vcm92AM y1];
        
        [y1, i] = arselect('SR09C___VCM3T__AC10');
        vcm93trimSP = [vcm93trimSP y1];
        [y1, i] = arselect('SR09C___VCM3___AC0');
        vcm93SP = [vcm93SP y1];
        [y1, i] = arselect('SR09C___VCM3___AM0');
        vcm93AM = [vcm93AM y1];
        
        [y1, i] = arselect('SR09C___VCM4T__AC10');
        vcm98trimSP = [vcm98trimSP y1];
        [y1, i] = arselect('SR09C___VCM4___AC0');
        vcm98SP = [vcm98SP y1];
        [y1, i] = arselect('SR09C___VCM4___AM0');
        vcm98AM = [vcm98AM y1];
        
        [y1, i] = arselect('SR10C___VCM1T__AC10');
        vcm101trimSP = [vcm101trimSP y1];
        [y1, i] = arselect('SR10C___VCM1___AC0');
        vcm101SP = [vcm101SP y1];
        [y1, i] = arselect('SR10C___VCM1___AM0');
        vcm101AM = [vcm101AM y1];
        
        [y1, i] = arselect('SR10C___VCM2T__AC10');
        vcm102trimSP = [vcm102trimSP y1];
        [y1, i] = arselect('SR10C___VCM2___AC0');
        vcm102SP = [vcm102SP y1];
        [y1, i] = arselect('SR10C___VCM2___AM0');
        vcm102AM = [vcm102AM y1];
        
        [y1, i] = arselect('SR10C___VCM3T__AC10');
        vcm103trimSP = [vcm103trimSP y1];
        [y1, i] = arselect('SR10C___VCM3___AC0');
        vcm103SP = [vcm103SP y1];
        [y1, i] = arselect('SR10C___VCM3___AM0');
        vcm103AM = [vcm103AM y1];
        
        [y1, i] = arselect('SR10C___VCM4T__AC10');
        vcm108trimSP = [vcm108trimSP y1];
        [y1, i] = arselect('SR10C___VCM4___AC0');
        vcm108SP = [vcm108SP y1];
        [y1, i] = arselect('SR10C___VCM4___AM0');
        vcm108AM = [vcm108AM y1];
        
        [y1, i] = arselect('SR11C___VCM1T__AC10');
        vcm111trimSP = [vcm111trimSP y1];
        [y1, i] = arselect('SR11C___VCM1___AC0');
        vcm111SP = [vcm111SP y1];
        [y1, i] = arselect('SR11C___VCM1___AM0');
        vcm111AM = [vcm111AM y1];
        
        [y1, i] = arselect('SR11C___VCM2T__AC10');
        vcm112trimSP = [vcm112trimSP y1];
        [y1, i] = arselect('SR11C___VCM2___AC0');
        vcm112SP = [vcm112SP y1];
        [y1, i] = arselect('SR11C___VCM2___AM0');
        vcm112AM = [vcm112AM y1];
        
        [y1, i] = arselect('SR11C___VCM3T__AC10');
        vcm113trimSP = [vcm113trimSP y1];
        [y1, i] = arselect('SR11C___VCM3___AC0');
        vcm113SP = [vcm113SP y1];
        [y1, i] = arselect('SR11C___VCM3___AM0');
        vcm113AM = [vcm113AM y1];
        
        [y1, i] = arselect('SR11C___VCM4T__AC10');
        vcm118trimSP = [vcm118trimSP y1];
        [y1, i] = arselect('SR11C___VCM4___AC0');
        vcm118SP = [vcm118SP y1];
        [y1, i] = arselect('SR11C___VCM4___AM0');
        vcm118AM = [vcm118AM y1];
        
        [y1, i] = arselect('SR12C___VCM1T__AC10');
        vcm121trimSP = [vcm121trimSP y1];
        [y1, i] = arselect('SR12C___VCM1___AC0');
        vcm121SP = [vcm121SP y1];
        [y1, i] = arselect('SR12C___VCM1___AM0');
        vcm121AM = [vcm121AM y1];
        
        [y1, i] = arselect('SR12C___VCM2T__AC10');
        vcm122trimSP = [vcm122trimSP y1];
        [y1, i] = arselect('SR12C___VCM2___AC0');
        vcm122SP = [vcm122SP y1];
        [y1, i] = arselect('SR12C___VCM2___AM0');
        vcm122AM = [vcm122AM y1];
        
        [y1, i] = arselect('SR12C___VCM3T__AC10');
        vcm123trimSP = [vcm123trimSP y1];
        [y1, i] = arselect('SR12C___VCM3___AC0');
        vcm123SP = [vcm123SP y1];
        [y1, i] = arselect('SR12C___VCM3___AM0');
        vcm123AM = [vcm123AM y1];
        
        [y1, i] = arselect('SR12C___VCM4T__AC10');
        vcm128trimSP = [vcm128trimSP y1];
        [y1, i] = arselect('SR12C___VCM4___AC0');
        vcm128SP = [vcm128SP y1];
        [y1, i] = arselect('SR12C___VCM4___AM0');
        vcm128AM = [vcm128AM y1];
        
        
        
        t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
        
        disp(' ');
        
    end
end


% Hours or days for the x-axis?
if t(end)/60/60/24 > 3
    t = t/60/60/24;
    xlabelstring = ['Date since ', StartDayStr, ' [Days]'];
    DayFlag = 1;
else
    t = t/60/60;
    xlabelstring = ['Time since ', StartDayStr, ' [Hours]'];
    DayFlag = 0;
end
Days = [days days2];
xmax = max(t);

% HCMtrimSP=getpv('HCM','Trim',HCMlist1);
% HCMSP=getpv('HCM','DAC',HCMlist1);
% HCMAM=getpv('HCM','Monitor',HCMlist1);
% HCMtrimSP+HCMSP-HCMAM;

figure

subplot(4,1,1)
plot(t,hcm12trimSP+hcm12SP-hcm12AM,t,hcm18trimSP+hcm18SP-hcm18AM);
legend('HCM 1.2','HCM 1.8');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -1 1]);
end
title(['HCMtrimSP+HCMSP-HCMAM ',titleStr]);

subplot(4,1,2)
plot(t,hcm21trimSP+hcm21SP-hcm21AM,t,hcm28trimSP+hcm28SP-hcm28AM);
legend('HCM 2.1','HCM 2.8');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -1 1]);
end

subplot(4,1,3)
plot(t,hcm31trimSP+hcm31SP-hcm31AM,t,hcm38trimSP+hcm38SP-hcm38AM);
legend('HCM 3.1','HCM 3.8');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -1 1]);
end

subplot(4,1,4)
plot(t,hcm41trimSP+hcm41SP-hcm41AM,t,hcm48trimSP+hcm48SP-hcm48AM);
legend('HCM 4.1','HCM 4.8');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -1 1]);
end
xlabel(xlabelstring);
orient tall;


figure

subplot(4,1,1)
plot(t,hcm51trimSP+hcm51SP-hcm51AM,t,hcm58trimSP+hcm58SP-hcm58AM);
legend('HCM 5.1','HCM 5.8');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -1 1]);
end
title(['HCMtrimSP+HCMSP-HCMAM ',titleStr]);

subplot(4,1,2)
plot(t,hcm61trimSP+hcm61SP-hcm61AM,t,hcm68trimSP+hcm68SP-hcm68AM);
legend('HCM 6.1','HCM 6.8');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -1 1]);
end

subplot(4,1,3)
plot(t,hcm71trimSP+hcm71SP-hcm71AM,t,hcm78trimSP+hcm78SP-hcm78AM);
legend('HCM 7.1','HCM 7.8');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -1 1]);
end

subplot(4,1,4)
plot(t,hcm81trimSP+hcm81SP-hcm81AM,t,hcm88trimSP+hcm88SP-hcm88AM);
legend('HCM 8.1','HCM 8.8');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -1 1]);
end
xlabel(xlabelstring);
orient tall;


figure

subplot(4,1,1)
plot(t,hcm91trimSP+hcm91SP-hcm91AM,t,hcm98trimSP+hcm98SP-hcm98AM);
legend('HCM 9.1','HCM 9.8');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -1 1]);
end
title(['HCMtrimSP+HCMSP-HCMAM ',titleStr]);

subplot(4,1,2)
plot(t,hcm101trimSP+hcm101SP-hcm101AM,t,hcm108trimSP+hcm108SP-hcm108AM);
legend('HCM 10.1','HCM 10.8');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -1 1]);
end

subplot(4,1,3)
plot(t,hcm111trimSP+hcm111SP-hcm111AM,t,hcm118trimSP+hcm118SP-hcm118AM);
legend('HCM 11.1','HCM 11.8');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -1 1]);
end

subplot(4,1,4)
plot(t,hcm121trimSP+hcm121SP-hcm121AM,t,hcm128trimSP+hcm128SP-hcm128AM);
legend('HCM 12.1','HCM 12.7');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -1 1]);
end
xlabel(xlabelstring);
orient tall;

figure

return

subplot(4,1,1)
plot(t,vcm12,t,vcm18,t,vcm17);
legend('VCM 1.2','VCM 1.8','VCM 1.7');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -2 2]);
end
title(['VCM trim AMs ',titleStr]);

subplot(4,1,2)
plot(t,vcm21,t,vcm28,t,vcm22,t,vcm27);
legend('VCM 2.1','VCM 2.8','VCM 2.2','VCM 2.7');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -2 2]);
end

subplot(4,1,3)
plot(t,vcm31,t,vcm38,t,vcm32,t,vcm37);
legend('VCM 3.1','VCM 3.8','VCM 3.2','VCM 3.7');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -2 2]);
end

subplot(4,1,4)
plot(t,vcm41,t,vcm48,t,vcmu310/10,t,vcm42,t,vcm47);
legend('VCM 4.1','VCM 4.8','VCMCHIC 3.10/10','VCM 4.2','VCM 4.7');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -2 2]);
end
xlabel(xlabelstring);
orient tall;




figure

subplot(4,1,1)
plot(t,vcm51,t,vcm58,t,vcm52,t,vcm57);
legend('VCM 5.1','VCM 5.8','VCM 5.2','VCM 5.7');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -2 2]);
end
title(['VCM trim AMs ',titleStr]);

subplot(4,1,2)
plot(t,vcm61,t,vcm68,t,vcmu510/10,t,vcm62,t,vcm67);
legend('VCM 6.1','VCM 6.8','VCMCHIC 5.10/10','VCM 6.2','VCM 6.7');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -2 2]);
end

subplot(4,1,3)
plot(t,vcm71,t,vcm78,t,vcm72,t,vcm77);
legend('VCM 7.1','VCM 7.8','VCM 7.2','VCM 7.7');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -2 2]);
end

subplot(4,1,4)
plot(t,vcm81,t,vcm88,t,vcm82,t,vcm87);
legend('VCM 8.1','VCM 8.8','VCM 8.2','VCM 8.7');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -2 2]);
end
xlabel(xlabelstring);
orient tall;


figure

subplot(4,1,1)
plot(t,vcm91,t,vcm98,t,vcm92,t,vcm97);
legend('VCM 9.1','VCM 9.8','VCM 9.2','VCM 9.7');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -2 2]);
end
title(['VCM trim AMs ',titleStr]);

subplot(4,1,2)
plot(t,vcm101,t,vcm108,t,vcm102,t,vcm107);
legend('VCM 10.1','VCM 10.8','VCM 10.2','VCM 10.7');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -2 2]);
end

subplot(4,1,3)
plot(t,vcm111,t,vcm118,t,vcmu1010/10,t,vcm112,t,vcm117);
legend('VCM 11.1','VCM 11.8','VCMCHIC 10.10/10','VCM 11.2','VCM 11.7');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -2 2]);
end

subplot(4,1,4)
plot(t,vcm121,t,vcm127,t,vcm122);
legend('VCM 12.1','VCM 12.7','VCM 12.2');
ylabel('I [A]');
grid;
if tightaxis
    axis tight;
    xaxis([min(t) max(t)]);
else
    axis([min(t) max(t) -2 2]);
end
xlabel(xlabelstring);
orient tall;


%smatrix plots
if 0
    HCM = [hcm12;hcm18;hcm21;hcm28;hcm31;hcm38;hcm41;hcm48;hcm51;hcm58;hcm61;hcm68; ...
        hcm71;hcm78;hcm81;hcm88;hcm91;hcm98;hcm101;hcm108;hcm111;hcm118;hcm121;hcm127;hcmu310;hcmu510;hcmu1010];
    VCM = [vcm12;vcm17;vcm18;vcm21;vcm22;vcm27;vcm28;vcm31;vcm32;vcm37;vcm38; ...
        vcm41;vcm42;vcm47;vcm48;vcm51;vcm52;vcm57;vcm58;vcm61;vcm62;vcm67;vcm68; ...
        vcm71;vcm72;vcm77;vcm78;vcm81;vcm82;vcm87;vcm88;vcm91;vcm92;vcm97;vcm98; ...
        vcm101;vcm102;vcm107;vcm108;vcm111;vcm112;vcm117;vcm118;vcm121;vcm122;vcm127;vcmu310;vcmu510;vcmu1010];
    % VCM = [vcm12;vcm18;vcm15;vcm17;vcm18;vcm21;vcm22;vcm28;vcm25;vcm27;vcm28;vcm31;vcm32;vcm38;vcm35;vcm37;vcm38; ...
    %     vcm41;vcm42;vcm48;vcm45;vcm47;vcm48;vcm51;vcm52;vcm58;vcm55;vcm57;vcm58;vcm61;vcm62;vcm68;vcm65;vcm67;vcm68; ...
    %     vcm71;vcm72;vcm78;vcm75;vcm77;vcm78;vcm81;vcm82;vcm88;vcm85;vcm87;vcm88;vcm91;vcm92;vcm98;vcm95;vcm97;vcm98; ...
    %     vcm101;vcm102;vcm108;vcm105;vcm107;vcm108;vcm111;vcm112;vcm118;vcm115;vcm117;vcm118;vcm121;vcm122;vcm128;vcm125;vcm127;vcmu310;vcmu510;vcmu1010];
    
    %  size(Sx)
    %  size(HCM)
    %  size(Sy)
    %  size(VCM)
    
    BPMx = Sx*HCM;
    BPMy = Sy*VCM;
    
    for loop=1:size(BPMx,1)
        figure;
        plot(t,BPMx(loop,:))
        legend(getname('BPMx',BPMlist(loop,:)))
        axis tight
        aa=axis;
        xaxis([min(t) max(t)]);
        yaxis([aa(3) aa(4)]);
        xlabel(xlabelstring);
    end
    for loop=1:size(BPMy,1)
        figure;
        plot(t,BPMy(loop,:))
        legend(getname('BPMy',BPMlist(loop,:)))
        axis tight
        aa=axis;
        xaxis([min(t) max(t)]);
        yaxis([aa(3) aa(4)]);
        xlabel(xlabelstring);
    end
end