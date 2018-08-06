function arplot_orbitfb2(monthStr, days, year1, month2Str, days2, year2)
% arplot_orbitfb2(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
% Plots archived data about the orbit feedback, including the
%		(S-matrix*Corrector Trim AMs) for all the Bergoz BPMs
%       (this routine is compatible with the new Matlab ML)
%
% Example:  arplots_orbitfb2('January',22:24, 1998);
%           plots data from 1/22, 1/23, and 1/24 in 1998
%
% C. Steier, May 2002; updated to work with new ML 4-25-07, T.Scarvie

tightaxis = 1; % change to 1 if you want the vertical axis auto-scaled

switch2bergoz

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

hcm12 = []; hcm18 = []; hcm21 = []; hcm28 = []; hcm31 = []; hcm38 = []; hcmu310 = []; hcm41 = [];  hcm48 = [];
hcm51 = []; hcm58 = []; hcmu510 = []; hcm61 = []; hcm68 = []; hcm71 = []; hcm78 = []; hcm81 = []; hcm88 = [];
hcm91 = []; hcm98 = []; hcm101 = []; hcm108 = []; hcmu1010 = []; hcm111 = []; hcm118 = []; hcm121 = []; hcm127 = [];

vcm12 = []; vcm14 = []; vcm15 = []; vcm17 = []; vcm18 = []; vcm21 = []; vcm22 = []; vcm24 = []; vcm25 = []; vcm27 = []; vcm28 = [];
vcm31 = []; vcm34 = []; vcm35 = []; vcm32 = []; vcm37 = []; vcm38 = []; vcmu310 = []; vcm41 = []; vcm42 = []; vcm44 = []; vcm45 = []; vcm47 = []; vcm48 = [];
vcm51 = []; vcm52 = []; vcm54 = []; vcm55 = []; vcm57 = []; vcm58 = []; vcmu510 = []; vcm61 = []; vcm62 = []; vcm64 = []; vcm65 = []; vcm67 = []; vcm68 = [];
vcm71 = []; vcm72 = []; vcm74 = []; vcm75 = []; vcm77 = []; vcm78 = []; vcm81 = []; vcm82 = []; vcm84 = []; vcm85 = []; vcm87 = []; vcm88 = [];
vcm91 = []; vcm92 = []; vcm94 = []; vcm95 = []; vcm97 = []; vcm98 = []; vcm101 = []; vcm102 = []; vcm104 = []; vcm105 = []; vcm107 = []; vcm108 = []; vcmu1010 = [];
vcm111 = []; vcm112 = []; vcm114 = []; vcm115 = []; vcm117 = []; vcm118 = []; vcm121 = []; vcm122 = []; vcm124 = []; vcm125 = []; vcm127 = [];

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

    [y1, i] = arselect('SR01C___HCM2T__AC');
    hcm12 = [hcm12 y1];

    [y1, i] = arselect('SR01C___HCM4T__AC');
    hcm18 = [hcm18 y1];

    [y1, i] = arselect('SR02C___HCM1T__AC');
    hcm21 = [hcm21 y1];

    [y1, i] = arselect('SR02C___HCM4T__AC');
    hcm28 = [hcm28 y1];

    [y1, i] = arselect('SR03C___HCM1T__AC');
    hcm31 = [hcm31 y1];

    [y1, i] = arselect('SR03C___HCM4T__AC');
    hcm38 = [hcm38 y1];

    [y1, i] = arselect('SR04U___HCM2___AM');
    hcmu310 = [hcmu310 y1];

    [y1, i] = arselect('SR04C___HCM1T__AC');
    hcm41 = [hcm41 y1];

    [y1, i] = arselect('SR04C___HCM4T__AC');
    hcm48 = [hcm48 y1];

    [y1, i] = arselect('SR05C___HCM1T__AC');
    hcm51 = [hcm51 y1];

    [y1, i] = arselect('SR05C___HCM4T__AC');
    hcm58 = [hcm58 y1];

    [y1, i] = arselect('SR06U___HCM2___AM');
    hcmu510 = [hcmu510 y1];

    [y1, i] = arselect('SR06C___HCM1T__AC');
    hcm61 = [hcm61 y1];

    [y1, i] = arselect('SR06C___HCM4T__AC');
    hcm68 = [hcm68 y1];

    [y1, i] = arselect('SR07C___HCM1T__AC');
    hcm71 = [hcm71 y1];

    [y1, i] = arselect('SR07C___HCM4T__AC');
    hcm78 = [hcm78 y1];

    [y1, i] = arselect('SR08C___HCM1T__AC');
    hcm81 = [hcm81 y1];

    [y1, i] = arselect('SR08C___HCM4T__AC');
    hcm88 = [hcm88 y1];

    [y1, i] = arselect('SR09C___HCM1T__AC');
    hcm91 = [hcm91 y1];

    [y1, i] = arselect('SR09C___HCM4T__AC');
    hcm98 = [hcm98 y1];

    [y1, i] = arselect('SR10C___HCM1T__AC');
    hcm101 = [hcm101 y1];

    [y1, i] = arselect('SR10C___HCM4T__AC');
    hcm108 = [hcm108 y1];

    [y1, i] = arselect('SR11U___HCM2___AM');
    hcmu1010 = [hcmu1010 y1];

    [y1, i] = arselect('SR11C___HCM1T__AC');
    hcm111 = [hcm111 y1];

    [y1, i] = arselect('SR11C___HCM4T__AC');
    hcm118 = [hcm118 y1];

    [y1, i] = arselect('SR12C___HCM1T__AC');
    hcm121 = [hcm121 y1];

    [y1, i] = arselect('SR12C___HCM3T__AC');
    hcm127 = [hcm127 y1];

    [y1, i] = arselect('SR01C___VCM2T__AC');
    vcm12 = [vcm12 y1];

    [y1, i] = arselect('SR01C___VCM3T__AC');
    vcm17 = [vcm17 y1];

    [y1, i] = arselect('SR01C___VCM4T__AC');
    vcm18 = [vcm18 y1];

    [y1, i] = arselect('SR02C___VCM1T__AC');
    vcm21 = [vcm21 y1];

    [y1, i] = arselect('SR02C___VCM2T__AC');
    vcm22 = [vcm22 y1];

    [y1, i] = arselect('SR02C___VCM3T__AC');
    vcm27 = [vcm27 y1];

    [y1, i] = arselect('SR02C___VCM4T__AC');
    vcm28 = [vcm28 y1];

    [y1, i] = arselect('SR03C___VCM1T__AC');
    vcm31 = [vcm31 y1];

    [y1, i] = arselect('SR03C___VCM2T__AC');
    vcm32 = [vcm32 y1];

    [y1, i] = arselect('SR03C___VCM3T__AC');
    vcm37 = [vcm37 y1];

    [y1, i] = arselect('SR03C___VCM4T__AC');
    vcm38 = [vcm38 y1];

    [y1, i] = arselect('SR04U___VCM2___AM');
    vcmu310 = [vcmu310 y1];

    [y1, i] = arselect('SR04C___VCM1T__AC');
    vcm41 = [vcm41 y1];

    [y1, i] = arselect('SR04C___VCM2T__AC');
    vcm42 = [vcm42 y1];

    [y1, i] = arselect('SR04C___VCM3T__AC');
    vcm47 = [vcm47 y1];

    [y1, i] = arselect('SR04C___VCM4T__AC');
    vcm48 = [vcm48 y1];

    [y1, i] = arselect('SR06U___VCM2___AM');
    vcmu510 = [vcmu510 y1];

    [y1, i] = arselect('SR05C___VCM1T__AC');
    vcm51 = [vcm51 y1];

    [y1, i] = arselect('SR05C___VCM2T__AC');
    vcm52 = [vcm52 y1];

    [y1, i] = arselect('SR05C___VCM3T__AC');
    vcm57 = [vcm57 y1];

    [y1, i] = arselect('SR05C___VCM4T__AC');
    vcm58 = [vcm58 y1];

    [y1, i] = arselect('SR06C___VCM1T__AC');
    vcm61 = [vcm61 y1];

    [y1, i] = arselect('SR06C___VCM2T__AC');
    vcm62 = [vcm62 y1];

    [y1, i] = arselect('SR06C___VCM3T__AC');
    vcm67 = [vcm67 y1];

    [y1, i] = arselect('SR06C___VCM4T__AC');
    vcm68 = [vcm68 y1];

    [y1, i] = arselect('SR07C___VCM1T__AC');
    vcm71 = [vcm71 y1];

    [y1, i] = arselect('SR07C___VCM2T__AC');
    vcm72 = [vcm72 y1];

    [y1, i] = arselect('SR07C___VCM3T__AC');
    vcm77 = [vcm77 y1];

    [y1, i] = arselect('SR07C___VCM4T__AC');
    vcm78 = [vcm78 y1];

    [y1, i] = arselect('SR08C___VCM1T__AC');
    vcm81 = [vcm81 y1];

    [y1, i] = arselect('SR08C___VCM2T__AC');
    vcm82 = [vcm82 y1];

    [y1, i] = arselect('SR08C___VCM3T__AC');
    vcm87 = [vcm87 y1];

    [y1, i] = arselect('SR08C___VCM4T__AC');
    vcm88 = [vcm88 y1];

    [y1, i] = arselect('SR09C___VCM1T__AC');
    vcm91 = [vcm91 y1];

    [y1, i] = arselect('SR09C___VCM2T__AC');
    vcm92 = [vcm92 y1];

    [y1, i] = arselect('SR09C___VCM3T__AC');
    vcm97 = [vcm97 y1];

    [y1, i] = arselect('SR09C___VCM4T__AC');
    vcm98 = [vcm98 y1];

    [y1, i] = arselect('SR10C___VCM1T__AC');
    vcm101 = [vcm101 y1];

    [y1, i] = arselect('SR10C___VCM2T__AC');
    vcm102 = [vcm102 y1];

    [y1, i] = arselect('SR10C___VCM3T__AC');
    vcm107 = [vcm107 y1];

    [y1, i] = arselect('SR10C___VCM4T__AC');
    vcm108 = [vcm108 y1];

    [y1, i] = arselect('SR11U___VCM2___AM');
    vcmu1010 = [vcmu1010 y1];

    [y1, i] = arselect('SR11C___VCM1T__AC');
    vcm111 = [vcm111 y1];

    [y1, i] = arselect('SR11C___VCM2T__AC');
    vcm112 = [vcm112 y1];

    [y1, i] = arselect('SR11C___VCM3T__AC');
    vcm117 = [vcm117 y1];

    [y1, i] = arselect('SR11C___VCM4T__AC');
    vcm118 = [vcm118 y1];

    [y1, i] = arselect('SR12C___VCM1T__AC');
    vcm121 = [vcm121 y1];

    [y1, i] = arselect('SR12C___VCM2T__AC');
    vcm122 = [vcm122 y1];

    [y1, i] = arselect('SR12C___VCM3T__AC');
    vcm127 = [vcm127 y1];


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

        [y1, i] = arselect('SR01C___HCM2T__AC');
        hcm12 = [hcm12 y1];

        [y1, i] = arselect('SR01C___HCM4T__AC');
        hcm18 = [hcm18 y1];

        [y1, i] = arselect('SR02C___HCM1T__AC');
        hcm21 = [hcm21 y1];

        [y1, i] = arselect('SR02C___HCM4T__AC');
        hcm28 = [hcm28 y1];

        [y1, i] = arselect('SR03C___HCM1T__AC');
        hcm31 = [hcm31 y1];

        [y1, i] = arselect('SR03C___HCM4T__AC');
        hcm38 = [hcm38 y1];

        [y1, i] = arselect('SR04U___HCM2___AM');
        hcmu310 = [hcmu310 y1];

        [y1, i] = arselect('SR04C___HCM1T__AC');
        hcm41 = [hcm41 y1];

        [y1, i] = arselect('SR04C___HCM4T__AC');
        hcm48 = [hcm48 y1];

        [y1, i] = arselect('SR05C___HCM1T__AC');
        hcm51 = [hcm51 y1];

        [y1, i] = arselect('SR05C___HCM4T__AC');
        hcm58 = [hcm58 y1];

        [y1, i] = arselect('SR06U___HCM2___AM');
        hcmu510 = [hcmu510 y1];

        [y1, i] = arselect('SR06C___HCM1T__AC');
        hcm61 = [hcm61 y1];

        [y1, i] = arselect('SR06C___HCM4T__AC');
        hcm68 = [hcm68 y1];

        [y1, i] = arselect('SR07C___HCM1T__AC');
        hcm71 = [hcm71 y1];

        [y1, i] = arselect('SR07C___HCM4T__AC');
        hcm78 = [hcm78 y1];

        [y1, i] = arselect('SR08C___HCM1T__AC');
        hcm81 = [hcm81 y1];

        [y1, i] = arselect('SR08C___HCM4T__AC');
        hcm88 = [hcm88 y1];

        [y1, i] = arselect('SR09C___HCM1T__AC');
        hcm91 = [hcm91 y1];

        [y1, i] = arselect('SR09C___HCM4T__AC');
        hcm98 = [hcm98 y1];

        [y1, i] = arselect('SR10C___HCM1T__AC');
        hcm101 = [hcm101 y1];

        [y1, i] = arselect('SR10C___HCM4T__AC');
        hcm108 = [hcm108 y1];

        [y1, i] = arselect('SR11U___HCM2___AM');
        hcmu1010 = [hcmu1010 y1];

        [y1, i] = arselect('SR11C___HCM1T__AC');
        hcm111 = [hcm111 y1];

        [y1, i] = arselect('SR11C___HCM4T__AC');
        hcm118 = [hcm118 y1];

        [y1, i] = arselect('SR12C___HCM1T__AC');
        hcm121 = [hcm121 y1];

        [y1, i] = arselect('SR12C___HCM3T__AC');
        hcm127 = [hcm127 y1];

        [y1, i] = arselect('SR01C___VCM2T__AC');
        vcm12 = [vcm12 y1];

        [y1, i] = arselect('SR01C___VCM3T__AC');
        vcm17 = [vcm17 y1];

        [y1, i] = arselect('SR01C___VCM4T__AC');
        vcm18 = [vcm18 y1];

        [y1, i] = arselect('SR02C___VCM1T__AC');
        vcm21 = [vcm21 y1];

        [y1, i] = arselect('SR02C___VCM2T__AC');
        vcm22 = [vcm22 y1];

        [y1, i] = arselect('SR02C___VCM3T__AC');
        vcm27 = [vcm27 y1];

        [y1, i] = arselect('SR02C___VCM4T__AC');
        vcm28 = [vcm28 y1];

        [y1, i] = arselect('SR03C___VCM1T__AC');
        vcm31 = [vcm31 y1];

        [y1, i] = arselect('SR03C___VCM2T__AC');
        vcm32 = [vcm32 y1];

        [y1, i] = arselect('SR03C___VCM3T__AC');
        vcm37 = [vcm37 y1];

        [y1, i] = arselect('SR03C___VCM4T__AC');
        vcm38 = [vcm38 y1];

        [y1, i] = arselect('SR04U___VCM2___AM');
        vcmu310 = [vcmu310 y1];

        [y1, i] = arselect('SR04C___VCM1T__AC');
        vcm41 = [vcm41 y1];

        [y1, i] = arselect('SR04C___VCM2T__AC');
        vcm42 = [vcm42 y1];

        [y1, i] = arselect('SR04C___VCM3T__AC');
        vcm47 = [vcm47 y1];

        [y1, i] = arselect('SR04C___VCM4T__AC');
        vcm48 = [vcm48 y1];

        [y1, i] = arselect('SR05C___VCM1T__AC');
        vcm51 = [vcm51 y1];

        [y1, i] = arselect('SR05C___VCM2T__AC');
        vcm52 = [vcm52 y1];

        [y1, i] = arselect('SR05C___VCM3T__AC');
        vcm57 = [vcm57 y1];

        [y1, i] = arselect('SR05C___VCM4T__AC');
        vcm58 = [vcm58 y1];

        [y1, i] = arselect('SR06U___VCM2___AM');
        vcmu510 = [vcmu510 y1];

        [y1, i] = arselect('SR06C___VCM1T__AC');
        vcm61 = [vcm61 y1];

        [y1, i] = arselect('SR06C___VCM2T__AC');
        vcm62 = [vcm62 y1];

        [y1, i] = arselect('SR06C___VCM3T__AC');
        vcm67 = [vcm67 y1];

        [y1, i] = arselect('SR06C___VCM4T__AC');
        vcm68 = [vcm68 y1];

        [y1, i] = arselect('SR07C___VCM1T__AC');
        vcm71 = [vcm71 y1];

        [y1, i] = arselect('SR07C___VCM2T__AC');
        vcm72 = [vcm72 y1];

        [y1, i] = arselect('SR07C___VCM3T__AC');
        vcm77 = [vcm77 y1];

        [y1, i] = arselect('SR07C___VCM4T__AC');
        vcm78 = [vcm78 y1];

        [y1, i] = arselect('SR08C___VCM1T__AC');
        vcm81 = [vcm81 y1];

        [y1, i] = arselect('SR08C___VCM2T__AC');
        vcm82 = [vcm82 y1];

        [y1, i] = arselect('SR08C___VCM3T__AC');
        vcm87 = [vcm87 y1];

        [y1, i] = arselect('SR08C___VCM4T__AC');
        vcm88 = [vcm88 y1];

        [y1, i] = arselect('SR09C___VCM1T__AC');
        vcm91 = [vcm91 y1];

        [y1, i] = arselect('SR09C___VCM2T__AC');
        vcm92 = [vcm92 y1];

        [y1, i] = arselect('SR09C___VCM3T__AC');
        vcm97 = [vcm97 y1];

        [y1, i] = arselect('SR09C___VCM4T__AC');
        vcm98 = [vcm98 y1];

        [y1, i] = arselect('SR10C___VCM1T__AC');
        vcm101 = [vcm101 y1];

        [y1, i] = arselect('SR10C___VCM2T__AC');
        vcm102 = [vcm102 y1];

        [y1, i] = arselect('SR10C___VCM3T__AC');
        vcm107 = [vcm107 y1];

        [y1, i] = arselect('SR10C___VCM4T__AC');
        vcm108 = [vcm108 y1];

        [y1, i] = arselect('SR11U___VCM2___AM');
        vcmu1010 = [vcmu1010 y1];

        [y1, i] = arselect('SR11C___VCM1T__AC');
        vcm111 = [vcm111 y1];

        [y1, i] = arselect('SR11C___VCM2T__AC');
        vcm112 = [vcm112 y1];

        [y1, i] = arselect('SR11C___VCM3T__AC');
        vcm117 = [vcm117 y1];

        [y1, i] = arselect('SR11C___VCM4T__AC');
        vcm118 = [vcm118 y1];

        [y1, i] = arselect('SR12C___VCM1T__AC');
        vcm121 = [vcm121 y1];

        [y1, i] = arselect('SR12C___VCM2T__AC');
        vcm122 = [vcm122 y1];

        [y1, i] = arselect('SR12C___VCM3T__AC');
        vcm127 = [vcm127 y1];

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


figure

subplot(4,1,1)
plot(t,hcm12,t,hcm18);
legend('HCM 1.2','HCM 1.8');
ylabel('I [A]');
grid;
if tightaxis
   axis tight;
   xaxis([min(t) max(t)]);
else
   axis([min(t) max(t) -1 1]);
end
title(['HCM trim DACs ',titleStr]);

subplot(4,1,2)
plot(t,hcm21,t,hcm28);
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
plot(t,hcm31,t,hcm38);
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
plot(t,hcm41,t,hcm48,t,hcmu310/10);
legend('HCM 4.1','HCM 4.8','HCMCHIC 3.10/10');
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
plot(t,hcm51,t,hcm58);
legend('HCM 5.1','HCM 5.8');
ylabel('I [A]');
grid;
if tightaxis
   axis tight;
   xaxis([min(t) max(t)]);
else
   axis([min(t) max(t) -1 1]);
end
title(['HCM trim DACs ',titleStr]);

subplot(4,1,2)
plot(t,hcm61,t,hcm68,t,hcmu510/10);
legend('HCM 6.1','HCM 6.8','HCMCHIC 5.10/10');
ylabel('I [A]');
grid;
if tightaxis
   axis tight;
   xaxis([min(t) max(t)]);
else
   axis([min(t) max(t) -1 1]);
end

subplot(4,1,3)
plot(t,hcm71,t,hcm78);
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
plot(t,hcm81,t,hcm88);
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
plot(t,hcm91,t,hcm98);
legend('HCM 9.1','HCM 9.8');
ylabel('I [A]');
grid;
if tightaxis
   axis tight;
   xaxis([min(t) max(t)]);
else
   axis([min(t) max(t) -1 1]);
end
title(['HCM trim DACs ',titleStr]);

subplot(4,1,2)
plot(t,hcm101,t,hcm108);
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
plot(t,hcm111,t,hcm118,t,hcmu1010/10);
legend('HCM 11.1','HCM 11.8','HCMCHIC 10.10/10');
ylabel('I [A]');
grid;
if tightaxis
   axis tight;
   xaxis([min(t) max(t)]);
else
   axis([min(t) max(t) -1 1]);
end

subplot(4,1,4)
plot(t,hcm121,t,hcm127);
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
title(['VCM trim DACs ',titleStr]);

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
title(['VCM trim DACs ',titleStr]);

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
title(['VCM trim DACs ',titleStr]);

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


HCM = [hcm12;hcm18;hcm21;hcm28;hcm31;hcm38;hcm41;hcm48;hcm51;hcm58;hcm61;hcm68; ...
    hcm71;hcm78;hcm81;hcm88;hcm91;hcm98;hcm101;hcm108;hcm111;hcm118;hcm121;hcm127;hcmu310;hcmu510;hcmu1010];
VCM = [vcm12;vcm17;vcm18;vcm21;vcm22;vcm27;vcm28;vcm31;vcm32;vcm37;vcm38; ...
    vcm41;vcm42;vcm47;vcm48;vcm51;vcm52;vcm57;vcm58;vcm61;vcm62;vcm67;vcm68; ...
    vcm71;vcm72;vcm77;vcm78;vcm81;vcm82;vcm87;vcm88;vcm91;vcm92;vcm97;vcm98; ...
    vcm101;vcm102;vcm107;vcm108;vcm111;vcm112;vcm117;vcm118;vcm121;vcm122;vcm127;vcmu310;vcmu510;vcmu1010];
% VCM = [vcm12;vcm14;vcm15;vcm17;vcm18;vcm21;vcm22;vcm24;vcm25;vcm27;vcm28;vcm31;vcm32;vcm34;vcm35;vcm37;vcm38; ...
%     vcm41;vcm42;vcm44;vcm45;vcm47;vcm48;vcm51;vcm52;vcm54;vcm55;vcm57;vcm58;vcm61;vcm62;vcm64;vcm65;vcm67;vcm68; ...
%     vcm71;vcm72;vcm74;vcm75;vcm77;vcm78;vcm81;vcm82;vcm84;vcm85;vcm87;vcm88;vcm91;vcm92;vcm94;vcm95;vcm97;vcm98; ...
%     vcm101;vcm102;vcm104;vcm105;vcm107;vcm108;vcm111;vcm112;vcm114;vcm115;vcm117;vcm118;vcm121;vcm122;vcm124;vcm125;vcm127;vcmu310;vcmu510;vcmu1010];

%  size(Sx)
%  size(HCM)
%  size(Sy)
%  size(VCM)

BPMx = Sx*HCM;
BPMy = Sy*VCM;

% for loop=1:size(BPMx,1)
%     figure;
%     plot(t,BPMx(loop,:))
%     legend(getname('BPMx',BPMlist(loop,:)))
%     axis tight
%     aa=axis;
%     xaxis([min(t) max(t)]);
%     yaxis([aa(3) aa(4)]);
%     xlabel(xlabelstring);
% end
% for loop=1:size(BPMy,1)
%     figure;
%     plot(t,BPMy(loop,:))
%     legend(getname('BPMy',BPMlist(loop,:)))
%     axis tight
%     aa=axis;
%     xaxis([min(t) max(t)]);
%     yaxis([aa(3) aa(4)]);
%     xlabel(xlabelstring);
% end
