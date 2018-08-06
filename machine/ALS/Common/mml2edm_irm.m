function mml2edm_irm(Directory)

DirStart = pwd;

if nargin < 1
    if ispc
        cd \\Als-filer\physbase\hlc\IRM
    else
        cd /home/als/physbase/hlc/IRM
    end
else
    cd(Directory);
end

WindowLocation = [20 20];
FileName = 'IRM_Main.edl';
TitleBar = 'IRM Engineering Panel Launcher';
fprintf('   Building %s (%s)\n', TitleBar, FileName);

Height = 20;
FontSize = 12;

% Start the output file
fid = fopen(FileName, 'w', 'b');
[Header, TitleBar] = EDMHeader('TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', 850, 'Height', 100);
WriteEDMFile(fid, Header);

[N,a] = getirmlist;


n = 0;

% 41 53 59
%LiveIRMs = [34 46 48 49 80 86 87 101 102 107 108 109];
LiveIRMs = N(:,1);

% 30 -> Old BR bend power supply
% 64 -> Removed, IP got replaced
RemoveIRM = [22 30 52 64];


% Header
x = 3;
y = 3;
WriteEDMFile(fid, EDMStaticText('     IRM    #  Pwr Seal DegC   Information', x,     y, 'Width', 250, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'medium', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
WriteEDMFile(fid, EDMStaticText('     IRM    #  Pwr Seal DegC   Information', x+405, y, 'Width', 250, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'medium', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));

% Column 1
x = 3;
y = 3+20;
for i = 1:69
    n = n + 1;
    if ~any(i==RemoveIRM)
%       WriteEDMFile(fid, EDMRelatedDisplay('/vxboot/siocirm/boot/opi/IRM_Overall.edl', x,             y, 'Macro',     sprintf('P=irm:,R=%03d:',    N(i,1)), 'Width',  75, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('IRM %03d', N(i,1)), 'CommandLabel', ''));
        WriteEDMFile(fid, EDMRelatedDisplay('IRM_Overall.edl',                          x,             y, 'Macro',     sprintf('P=irm:,R=%03d:',    N(i,1)), 'Width',  75, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('IRM %03d', N(i,1)), 'CommandLabel', ''));
        WriteEDMFile(fid, EDMRectangle(                                                 x+80,          y, 'AlarmPV',   sprintf('irm:%03d:PowerGood',N(i,1)), 'Width', 15, 'Height', 15));
        WriteEDMFile(fid, EDMRectangle(                                                 x+80+20,       y, 'VisibleIf', sprintf('irm:%03d:Sealed',   N(i,1)), 'Width' ,15, 'Height', 15, 'Range',[1 100000], 'FillColor',22));  % Red
        WriteEDMFile(fid, EDMRectangle(                                                 x+80+20,       y, 'VisibleIf', sprintf('irm:%03d:Sealed',   N(i,1)), 'Width' ,15, 'Height', 15, 'Range',[1 100000], 'FillColor',35));  % Yellow
        WriteEDMFile(fid, EDMRectangle(                                                 x+80+20,       y, 'VisibleIf', sprintf('irm:%03d:Sealed',   N(i,1)), 'Width' ,15, 'Height', 15, 'Range',[0 1], 'FillColor',18));
        WriteEDMFile(fid, EDMTextMonitor(sprintf('irm:%03d:Temperature',N(i,1)),        x+80+20+20,    y, 'Width' , 35, 'Height', 15, 'Precision', 1));
        WriteEDMFile(fid, EDMStaticText( sprintf('%s', a{i}),                           x+80+20+20+37, y, 'Width', 250, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'medium', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
        %WriteEDMFile(fid, EDMShellCommand(sprintf('runIRM.sh %03d', i), x,  y, 'Width',  75, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('IRM %03d', i), 'CommandLabel', ''));
        %WriteEDMFile(fid, EDMRelatedDisplay('IRM.edl', x,  y, 'Macro', sprintf('P=irm:,R=%03d:', i), 'Width',  75, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('IRM %03d', i), 'CommandLabel', ''));
        y = y + 22;
    end
end
y1 = y;

% Column 2
x = 410;
y = 3+20;
for i = 70:size(N,1)
    n = n + 1;
    if ~any(i==RemoveIRM)
%       WriteEDMFile(fid, EDMRelatedDisplay('/vxboot/siocirm/boot/opi/IRM_Overall.edl', x,             y, 'Macro',     sprintf('P=irm:,R=%03d:',    N(i,1)), 'Width',  75, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('IRM %03d', N(i,1)), 'CommandLabel', ''));
        WriteEDMFile(fid, EDMRelatedDisplay('IRM_Overall.edl',                          x,             y, 'Macro',     sprintf('P=irm:,R=%03d:',    N(i,1)), 'Width',  75, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('IRM %03d', N(i,1)), 'CommandLabel', ''));
        WriteEDMFile(fid, EDMRectangle(                                                 x+80,          y, 'AlarmPV',   sprintf('irm:%03d:PowerGood',N(i,1)), 'Width', 15, 'Height', 15));
        WriteEDMFile(fid, EDMRectangle(                                                 x+80+20,       y, 'VisibleIf', sprintf('irm:%03d:Sealed',   N(i,1)), 'Width' ,15, 'Height', 15, 'Range',[1 100000], 'FillColor',35));
        WriteEDMFile(fid, EDMRectangle(                                                 x+80+20,       y, 'VisibleIf', sprintf('irm:%03d:Sealed',   N(i,1)), 'Width' ,15, 'Height', 15, 'Range',[0 1], 'FillColor',18));
        WriteEDMFile(fid, EDMTextMonitor(sprintf('irm:%03d:Temperature',N(i,1)),        x+80+20+20,    y, 'Width' , 35, 'Height', 15, 'Precision', 1));
        WriteEDMFile(fid, EDMStaticText( sprintf('%s', a{i}),                           x+80+20+20+37, y, 'Width', 300, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'medium', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));

       % WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', sprintf('irm:%03d:PowerGood',N(i,1)), 'Width', 15, 'Height', 15));
       % WriteEDMFile(fid, EDMTextMonitor(sprintf('irm:%03d:Temperature',N(i,1)), x+17, y, 'Width' ,35, 'Height', 15, 'Precision', 1));
       % WriteEDMFile(fid, EDMRelatedDisplay('/vxboot/siocirm/boot/opi/IRM_Overall.edl', x+17+37,  y, 'Macro', sprintf('P=irm:,R=%03d:', N(i,1)), 'Width',  75, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('IRM %03d', N(i,1)), 'CommandLabel', ''));
       % WriteEDMFile(fid, EDMStaticText(sprintf('%s', a{i}), x+17+37+77, y, 'Width', 250, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'medium', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
        y = y + 22;
    end
end
y2 = y;

fclose(fid);


% Update the header
FigWidth  = 380+430+50;
FigHeight = max([y1 y2]) + 10;
Header = EDMHeader('FileName', FileName, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', FigWidth, 'Height', FigHeight);


cd(DirStart);



function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');


function [n, a] = getirmlist

n = [
    1	79
    2	81
    3	70
    4	71
    5	95
    6	92
    7	93
    8	94
    9	73
    10	74
    11	75
    12	90
    13	113
    14	114
    15	118
    16	117
    17	120
    18	91
    19	115
    20	116
    21	119
    22	NaN
    23	76
    24	85
    25	104
    26	105
    27	106
    28	181
    29	286
    30	252
    31	282
    32	293
    33	341
    34	294
    35	344
    36	287
    37	345
    38	297
    39	284
    40	285
    41	366
    42	367
    43	377
    44	378
    45	362
    46	363
    47	372
    48	373
    49	498
    50	524
    51	737
    52	NaN
    53	507
    54	660
    55	661
    56	496
    57	497
    58	508
    59	509
    60	662
    61	663
    62	650
    63	510
    64	NaN
    65	511
    66	664
    67	665
    68	512
    69	513
    70	666
    71	667
    72	514
    73	525
    74	442
    75	444
    76	515
    77	668
    78	669
    79	744
    80	670
    81	671
    82	518
    83	NaN
    84	NaN
    85	519
    86	672
    87	673
    88	520
    89	408
    90	521
    91	674
    92	675
    93	743
    94	676
    95	677
    96	522
    97	409
    98	742
    99	745
    100	678
    101	679
    102	500
    103	411
    104	503
    105	680
    106	681
    107	714
    108	410
    109	505
    110	682
    111	683
    
    112 NaN
    113 NaN
    114 NaN
    115 NaN
    116 NaN
    117 NaN
    118 NaN
    119 NaN
    120 NaN
    121 NaN
    122 NaN
    123 NaN
    124 NaN
    125 NaN
    126 NaN
    127 NaN
    128 NaN
    129 NaN
    130 NaN
    131 NaN
    132 NaN
    
    150	NaN
    151	NaN
    %0	NaN
    %240	455
    %241	456
    ];

a = {
    'Electron Gun Heater'
    'Electron Gun HV Power supply'
    'GTL Sol 1,2,3'
    'LN Sol 1,2,3,4'
    'GTL VVR1, LN VVR1, IP (EG & GTL)'
    'GTL INM1, PP1'
    'GTL TV1 & TV2'
    'LN TV1 & TV2'
    'MO, RF frequency fine control'
    'GTL SHB1'
    'GTL SHB2'
    'Mod 1 Ion Pumps 1, 2, 3A, 3B'
    'Mod 1 Focus Coils, IP Kly1'
    'Mod 1 Control (HV, etc.)'
    'AS1 Phase Loop, LN Master Phase'
    'LN Phase Shifter & Attenuator'
    'LN Water Temperature Control'
    'Mod 2 Ion Pumps 4, 5A, 5B, Kly2'
    'Mod 2 Focus Coils'
    'Mod 2 Control (HV, etc.)'
    'AS2 Phase Loop'
    'Open'
    'LTB B1 & BS'
    'LTB B2'
    'LTB TV 1, 2'
    'LTB TV 3, 4'
    'LTB TV 5, 6'
    'LTB VVR1, VVR2, IP 1,2,3'
    'BR1 KI'
    'BR1 Old BR Bend'
    'BR1 TV2 & TV3'
    'BR1 VVR1 & VVR3, IP 1,2,3, Water flow'
    'BR2 IP 1,2,3, Water flow'
    'BR2 VVR1, Septum Valve (CVR1), ICTs'
    'BR2 Bump3'
    'BR2 Bump1 & Bump2'
    'BR2 KE'
    'BR2 Septum (SEN & SEK)'
    'BR3 TV1, VVR1, VVR2, IP 1,2,3'
    'BR4 TV1, VVR1, VVR2, IP 1,2,3'
    'BTS TV1, TV2, SP2'
    'BTS TV3, BTSS TV1'
    'BTS TV4 & TV5'
    'BTS TV6, VVR2, VVR3, IP 1,2,FE'
    'BTS Q1, Q2.1, Q3.2'
    'BTS Q2.2, Q3.1'
    'BTS Q4, Q5.1, Q5.2'
    'BTS Q6.1, Q6.2, Q7'
    'SR01S TV1, Septum Valve (CVR), IP 1-4'
    'SR01S Sabersky Finger (SPH 1,2,3), IP 5'
    'SR02S Pinger'
    'SR02S Open'
    'SR01C QFA Shunts'
    'SR01C TSP, PST, IG2, TC2, IP 1-4'
    'SR01C RVM, RFPERM, FEVACS, IP 5,6'
    'SR01S BUMP'
    'SR01S Septum (SEN & SEK)'
    'SR02S IP1'
    'SR02C QFA Shunts'
    'SR02C TSP, PST, IG2, TC2, IP 1-4'
    'SR02C RVM, RFPERM, FEVACS, IP 5,6'
    'SR03S RF Phase, TFB'
    'SR03S IP 1,4,5,6'
    'SR03S IP 7'
    'SR03C QFA Shunts'
    'SR03C TSP, PST, IG2, TC2, IP 1-4'
    'SR03C RVM, RFPERM, FEVACS, VVR1, VVR2, IP 5,6'
    'SR04U IP 1-4'
    'SR04C QFA Shunts'
    'SR04C TSP, PST, IG2, TC2, IP 1-4'
    'SR04C RVM, RFPERM, FEVACS, H2O Flow, IP 5,6'
    'SR05W IP 1,3,5'
    'SR05S DCCT (analog)'
    'SR05C SF Temperature'
    'SR05C SD Temperature'
    'SR05C QFA Shunts'
    'SR05C TSP, PST, IG2, TC2, IP 1-4'
    'SR05C RVM, RFPERM, FEVACS, IP 5,6'
    'SR06C QFA Shunts'
    'SR06C TSP, PST, IG2, TC2, IP 1-4'
    'SR06C RVM, RFPERM, FEVACS, VVR1, IP 5,6'
    'SR07U IP 1,3,5'
    'SR07S Photon BPM'
    'SR07S Bergoz BPM'
    'SR07C QFA Shunts'
    'SR07C TSP, PST, IG2, TC2, IP 1-4'
    'SR07C RVM, RFPERM, FEVACS, IP 5,6'
    'SR08U IP 1,3,5'
    'SR08U ID Temperatures'
    'SR08C QFA Shunts'
    'SR08C TSP, PST, IG2, TC2, IP 1-4'
    'SR08C RVM, RFPERM, FEVACS, VVR1, IP 5,6'
    'SR09C QFA Shunts'
    'SR09C TSP, PST, IG2, TC2, IP 1-4'
    'SR09C RVM, RFPERM, FEVACS, IP 5,6'
    'SR09U IP 1,3,5'
    'SR09U ID temperatures'
    'BTS FE B1'
    'SR10C QFA Shunts'
    'SR10C TSP, PST, IG2, TC2, IP 1-4'
    'SR10C RVM, RFPERM, FEVACS, VVR1, IP 5,6'
    'SR10U IP 1,3,5'
    'SR10U ID Temperatures'
    'SR11C QFA Shunts'
    'SR11C TSP, PST, IG2, TC2, IP 1-4'
    'SR11C RVM, RFPERM, FEVACS, IP 5,6'
    'SR12U IP 1,3,5'
    'SR12U ID Temperatures'
    'SR12C QFA Shunts'
    'SR12C TSP, PST, IG2, TC2, IP 1-4'
    'SR12C RVM, RFPERM, FEVACS IP 5,6'
    'BR2:HCM1, BR1:HCM2'
    'BR1:VCM1, BR1:VCM2'
    'BR1:VCM3, BR1:VCM4'
    'BR1:HCM3, BR1:HCM4'
    'BR3:HCM1, BR2:HCM2, BR2:HCM3, BR2:HCM4'
    'BR2:VCM1, BR2:VCM2'
    'BR2:VCM3, BR2:VCM4'
    'Spare'
    'BR4:HCM1, BR3:HCM2'
    'BR3:VCM1, BR3:VCM2'
    'BR3:VCM3, BR3:VCM4'
    'BR3:HCM3, BR3:HCM4'
    'BR1:HCM1, BR4:HCM2'
    'BR4:VCM1, BR4:VCM2'
    'BR4:VCM3, BR4:VCM4'
    'BR4:HCM3, BR4:HCM4'
    'BR4:RF (coming soon)'
    'BR1:SF, BR1:SD (coming soon)'
    'BR2:SF, BR2:SD (coming soon)'
    'BR3:SF, BR3:SD (coming soon)'
    'BR4:SF, BR4:SD (coming soon)'
    'Gauss Clock Injection'
    'Gauss Clock Extraction'
   % 'General testing'
   % 'EM Cage for HCM power supply testing'
   % 'EM Cage for QF/QD power supply testing'
    };





function [n, a] = getirmlist_old

n = [
    1	79
    2	81
    3	70
    4	71
    5	95
    6	92
    7	93
    8	94
    9	73
    10	74
    11	75
    12	90
    13	113
    14	114
    15	118
    16	117
    17	120
    18	91
    19	115
    20	116
    21	119
    22	NaN
    23	76
    24	85
    25	104
    26	105
    27	106
    28	181
    29	286
    30	252
    31	282
    32	293
    33	341
    34	294
    35	344
    36	287
    37	345
    38	297
    39	284
    40	285
    41	366
    42	367
    43	377
    44	378
    45	362
    46	363
    47	372
    48	373
    49	498
    50	524
    51	737
    52	NaN
    53	507
    54	660
    55	661
    56	496
    57	497
    58	508
    59	509
    60	662
    61	663
    62	650
    63	510
    64	NaN
    65	511
    66	664
    67	665
    68	512
    69	513
    70	666
    71	667
    72	514
    73	525
    74	442
    75	444
    76	515
    77	668
    78	669
    79	744
    80	670
    81	671
    82	518
    83	NaN
    84	NaN
    85	519
    86	672
    87	673
    88	520
    89	408
    90	521
    91	674
    92	675
    93	743
    94	676
    95	677
    96	522
    97	409
    98	742
    99	745
    100	678
    101	679
    102	500
    103	411
    104	503
    105	680
    106	681
    107	714
    108	410
    109	505
    110	682
    111	683
    ];

a = {
    'Electron Gun Heater'
    'Electron Gun HV Power supply'
    'GTL Sol 1,2,3'
    'LN Sol 1,2,3,4'
    'GTL VVR1, LN VVR1, IP (EG & GTL)'
    'GTL INM1, PP1'
    'GTL TV1 & TV2'
    'LN TV1 & TV2'
    'MO, RF frequency fine control'
    'GTL SHB1'
    'GTL SHB2'
    'Mod 1 Ion Pumps 1, 2, 3A, 3B'
    'Mod 1 Focus Coils, IP Kly1'
    'Mod 1 Control (HV, etc.)'
    'AS1 Phase Loop, LN Master Phase'
    'LN Phase Shifter & Attenuator'
    'LN Water Temperature Control'
    'Mod 2 Ion Pumps 4, 5A, 5B, Kly2'
    'Mod 2 Focus Coils'
    'Mod 2 Control (HV, etc.)'
    'AS2 Phase Loop'
    'Open'
    'LTB B1 & BS'
    'LTB B2'
    'LTB TV 1, 2'
    'LTB TV 3, 4'
    'LTB TV 5, 6'
    'LTB VVR1, VVR2, IP 1,2,3'
    'BR1 KI'
    'BR1 Old BR Bend'
    'BR1 TV2 & TV3'
    'BR1 VVR1 & VVR3, IP 1,2,3, Water flow'
    'BR2 IP 1,2,3, Water flow'
    'BR2 VVR1, Septum Valve (CVR1), ICTs'
    'BR2 Bump3'
    'BR2 Bump1 & Bump2'
    'BR2 KE'
    'BR2 Septum (SEN & SEK)'
    'BR3 TV1, VVR1, VVR2, IP 1,2,3'
    'BR4 TV1, VVR1, VVR2, IP 1,2,3'
    'BTS TV1, TV2, SP2'
    'BTS TV3, BTSS TV1'
    'BTS TV4 & TV5'
    'BTS TV6, VVR2, VVR3, IP 1,2,FE'
    'BTS Q1, Q2.1, Q3.2'
    'BTS Q2.2, Q3.1, Keptol'
    'BTS Q4, Q5.1, Q5.2'
    'BTS Q6.1, Q6.2, Q7'
    'SR01S TV1, Septum Valve (CVR), IP 1-4'
    'SR01S Sabersky Finge (SPH 1,2,3), IP 5'
    'SR02S Pinger'
    'SR02S Open'
    'SR01C QFA Shunts'
    'SR01C TSP, PST, IG2, TC2, IP 1-4'
    'SR01C RVM, RFPERM, FEVACS, IP 5,6'
    'SR01S BUMP'
    'SR01S Septum (SEN & SEK)'
    'SR02S IP1'
    'SR02C QFA Shunts'
    'SR02C TSP, PST, IG2, TC2, IP 1-4'
    'SR02C RVM, RFPERM, FEVACS, IP 5,6'
    'SR03S RF Phase, TFB'
    'SR03S IP 1,4,5,6'
    'SR03S IP 7'
    'SR03C QFA Shunts'
    'SR03C TSP, PST, IG2, TC2, IP 1-4'
    'SR03C RVM, RFPERM, FEVACS, VVR1, VVR2, IP 5,6'
    'SR04U IP 1-4'
    'SR04C QFA Shunts'
    'SR04C TSP, PST, IG2, TC2, IP 1-4'
    'SR04C RVM, RFPERM, FEVACS, H2O Flow, IP 5,6'
    'SR05W IP 1,3,5'
    'SR05S DCCT (analog)'
    'SR05C SF Temperature'
    'SR05C SD Temperature'
    'SR05C QFA Shunts'
    'SR05C TSP, PST, IG2, TC2, IP 1-4'
    'SR05C RVM, RFPERM, FEVACS, IP 5,6'
    'SR06C QFA Shunts'
    'SR06C TSP, PST, IG2, TC2, IP 1-4'
    'SR06C RVM, RFPERM, FEVACS, VVR1, IP 5,6'
    'SR07U IP 1,3,5'
    'SR07S Photon BPM'
    'SR07S Bergoz BPM'
    'SR07C QFA Shunts'
    'SR07C TSP, PST, IG2, TC2, IP 1-4'
    'SR07C RVM, RFPERM, FEVACS, IP 5,6'
    'SR08U IP 1,3,5'
    'SR08U ID Temperatures'
    'SR08C QFA Shunts'
    'SR08C TSP, PST, IG2, TC2, IP 1-4'
    'SR08C RVM, RFPERM, FEVACS, VVR1, IP 5,6'
    'SR09C QFA Shunts'
    'SR09C TSP, PST, IG2, TC2, IP 1-4'
    'SR09C RVM, RFPERM, FEVACS, IP 5,6'
    'SR09U IP 1,3,5'
    'SR09U ID temperatures'
    'BTS FE B1'
    'SR10C QFA Shunts'
    'SR10C TSP, PST, IG2, TC2, IP 1-4'
    'SR10C RVM, RFPERM, FEVACS, VVR1, IP 5,6'
    'SR10U IP 1,3,5'
    'SR10U ID Temperatures'
    'SR11C QFA Shunts'
    'SR11C TSP, PST, IG2, TC2, IP 1-4'
    'SR11C RVM, RFPERM, FEVACS, IP 5,6'
    'SR12U IP 1,3,5'
    'SR12U ID Temperatures'
    'SR12C QFA Shunts'
    'SR12C TSP, PST, IG2, TC2, IP 1-4'
    'SR12C RVM, RFPERM, FEVACS IP 5,6'
    };
