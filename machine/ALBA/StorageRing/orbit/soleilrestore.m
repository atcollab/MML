%function [sys,bpmx,bpmz,bpm,corx,corz,cor,rsp,bly]=soleilrestore
%system parameter save file
%timestamp: done by hand
%comment: Save System

%
% Modified by Laurent S. Nadolski

%% This file is part of the definition of the interface
%% Do not edit without mastering the contents.
%% TODO LAURENT : WARNING QUICK FIX just for a try !!!!!

AD = getAD;
filetype         = 'Restore';      %check to see if correct file type
sys.machine      = 'Ring';         %machine for control
% sys.bpmode       = 'slowacquisition'; %BPM system mode
sys.bpmslp       = 0.1;            %BPM sleep time in sec
sys.globalperiod = 2.0;            %BPM sleep time in sec
% sys.silverperiod = 2.0;            %BPM sleep time in sec
sys.plane        = 1;              %plane (1=horizontal 2=vertical)
sys.algo         = 'SVD';          %fitting algorithm
sys.filepath     = AD.Directory.Orbit;       %file path in MATLAB
% sys.reffile      = [sys.filepath 'soleilsilver.dat']; %reference orbit file
sys.respfiledir  = AD.Directory.OpsData;             %response matrix directory
sys.respfilename = AD.OpsData.BPMRespFile;           %response matrix file
sys.etafile      = AD.Directory.DispData;            %dispersion file
sys.relative     = 1;              %relative or absolute BPM plot 1=absolute, 2=relative
% sys.fdbk         = 0;              %no feedback
% sys.abort        = 0;              %reset abort flag
sys.maxs          = AD.Circumference; %maximum ring circumference
sys.xlimax       = sys.maxs;        %abcissa plot limit
sys.maxphi(1)     = 10;             %maximum horizontal phase ADvance
sys.maxphi(2)     = 8;              %maximum vertical phase ADvance
sys.xscale       = 'meter';        %abcissa plotting mode (meter or phase)
sys.drf          = 0;              %RF in HW units correction if required 
%*=== HORIZONTAL DATA ===*
% bpm(1).dev      = 10;              %maximum orbit deviation
bpm(1).id       = 1;               %BPM selection
bpm(1).scalemode= 1;               %BPM scale mode 0=manual mode, 1=autoscale
bpm(1).ylim     = 5;               %BPM vertical axis scale
bpm(1).units    = '1000xHardware'; %Display Units
bpm(1).scale    = 1000;            %Scaling factor
cor(1).fract    = 1.0;             %fraction of correctors
cor(1).id       = 1;               %COR selection
cor(1).scalemode= 0;               %COR scale mode 0=manual mode, 1=autoscale
cor(1).ylim     = maxn(getfamilydata(cor(1).AOFamily,'Setpoint','Range'));  %COR horizontal axis scale (amp)
cor(1).units    = 'Hardware';      %Display Units
cor(1).hw2physics = hw2physics(cor(1).AOFamily,'Setpoint',1,1)*1e3; % mrAD
rsp(1).disp     = 'off';           %mode for matrix column display
rsp(1).eig      = 'off';           %mode for eigenvector display
rsp(1).fit      = 0;               %valid fit flag
rsp(1).rfflag   = 0;               %rf fitting flag
rsp(1).etaflag  = 1;               %dispersion fitting flag
rsp(1).savflag  = 0;               %save solution flag
rsp(1).nsvd     = 56;              %number of singular values
rsp(1).svdtol   = 0;               %svd tolerance (0 uses number of singular values)
rsp(1).nsvdmax  = 1;               %default maximum number of singular values
 
%Note: only fit and weight for fitting will be used in orbit program from this array
%      Name and index are loADed from middleware
%     name       index  fit (0/1) weight etaweight
% bpmx={
% {    '1BPM1    '     1      1      1.000   0.000     }

%%% TO DO ERASE for automatic way if no previous file exist

% A1 = family2common('BPMx');
% A2 = (1:120)';
% A3 = ones(120,1);
% A4 = ones(120,1);
% A5 = zeros(120,1);
% 
% for k = 1:120
%     bpmx{k} = {A1(k,:),A2(k),A3(k),A4(k),A5(k)};
% end
% bpmx = bpmx';

%BPM data: name, index, fit,  weight
bpmx={
{  'BPMx001'     1     1      1.000    0.000 }
{  'BPMx002'     2     2      1.000    0.000 }
{  'BPMx003'     3     3      1.000    0.000 }
{  'BPMx004'     4     4      1.000    0.000 }
{  'BPMx005'     5     5      1.000    0.000 }
{  'BPMx006'     6     6      1.000    0.000 }
{  'BPMx007'     7     7      1.000    0.000 }
{  'BPMx008'     8     8      1.000    0.000 }
{  'BPMx009'     9     9      1.000    0.000 }
{  'BPMx010'    10    10      1.000    0.000 }
{  'BPMx011'    11    11      1.000    0.000 }
{  'BPMx012'    12    12      1.000    0.000 }
{  'BPMx013'    13    13      1.000    0.000 }
{  'BPMx014'    14    14      1.000    0.000 }
{  'BPMx015'    15    15      1.000    0.000 }
{  'BPMx016'    16    16      1.000    0.000 }
{  'BPMx017'    17    17      1.000    0.000 }
{  'BPMx018'    18    18      1.000    0.000 }
{  'BPMx019'    19    19      1.000    0.000 }
{  'BPMx020'    20    20      1.000    0.000 }
{  'BPMx021'    21    21      1.000    0.000 }
{  'BPMx022'    22    22      1.000    0.000 }
{  'BPMx023'    23    23      1.000    0.000 }
{  'BPMx024'    24    24      1.000    0.000 }
{  'BPMx025'    25    25      1.000    0.000 }
{  'BPMx026'    26    26      1.000    0.000 }
{  'BPMx027'    27    27      1.000    0.000 }
{  'BPMx028'    28    28      1.000    0.000 }
{  'BPMx029'    29    29      1.000    0.000 }
{  'BPMx030'    30    30      1.000    0.000 }
{  'BPMx031'    31    31      1.000    0.000 }
{  'BPMx032'    32    32      1.000    0.000 }
{  'BPMx033'    33    33      1.000    0.000 }
{  'BPMx034'    34    34      1.000    0.000 }
{  'BPMx035'    35    35      1.000    0.000 }
{  'BPMx036'    36    36      1.000    0.000 }
{  'BPMx037'    37    37      1.000    0.000 }
{  'BPMx038'    38    38      1.000    0.000 }
{  'BPMx039'    39    39      1.000    0.000 }
{  'BPMx040'    40    40      1.000    0.000 }
{  'BPMx041'    41    41      1.000    0.000 }
{  'BPMx042'    42    42      1.000    0.000 }
{  'BPMx043'    43    43      1.000    0.000 }
{  'BPMx044'    44    44      1.000    0.000 }
{  'BPMx045'    45    45      1.000    0.000 }
{  'BPMx046'    46    46      1.000    0.000 }
{  'BPMx047'    47    47      1.000    0.000 }
{  'BPMx048'    48    48      1.000    0.000 }
{  'BPMx049'    49    49      1.000    0.000 }
{  'BPMx050'    50    50      1.000    0.000 }
{  'BPMx051'    51    51      1.000    0.000 }
{  'BPMx052'    52    52      1.000    0.000 }
{  'BPMx053'    53    53      1.000    0.000 }
{  'BPMx054'    54    54      1.000    0.000 }
{  'BPMx055'    55    55      1.000    0.000 }
{  'BPMx056'    56    56      1.000    0.000 }
{  'BPMx057'    57    57      1.000    0.000 }
{  'BPMx058'    58    58      1.000    0.000 }
{  'BPMx059'    59    59      1.000    0.000 }
{  'BPMx060'    60    60      1.000    0.000 }
{  'BPMx061'    61    61      1.000    0.000 }
{  'BPMx062'    62    62      1.000    0.000 }
{  'BPMx063'    63    63      1.000    0.000 }
{  'BPMx064'    64    64      1.000    0.000 }
{  'BPMx065'    65    65      1.000    0.000 }
{  'BPMx066'    66    66      1.000    0.000 }
{  'BPMx067'    67    67      1.000    0.000 }
{  'BPMx068'    68    68      1.000    0.000 }
{  'BPMx069'    69    69      1.000    0.000 }
{  'BPMx070'    70    70      1.000    0.000 }
{  'BPMx071'    71    71      1.000    0.000 }
{  'BPMx072'    72    72      1.000    0.000 }
{  'BPMx073'    73    73      1.000    0.000 }
{  'BPMx074'    74    74      1.000    0.000 }
{  'BPMx075'    75    75      1.000    0.000 }
{  'BPMx076'    76    76      1.000    0.000 }
{  'BPMx077'    77    77      1.000    0.000 }
{  'BPMx078'    78    78      1.000    0.000 }
{  'BPMx079'    79    79      1.000    0.000 }
{  'BPMx080'    80    80      1.000    0.000 }
{  'BPMx081'    81    81      1.000    0.000 }
{  'BPMx082'    82    82      1.000    0.000 }
{  'BPMx083'    83    83      1.000    0.000 }
{  'BPMx084'    84    84      1.000    0.000 }
{  'BPMx085'    85    85      1.000    0.000 }
{  'BPMx086'    86    86      1.000    0.000 }
{  'BPMx087'    87    87      1.000    0.000 }
{  'BPMx088'    88    88      1.000    0.000 }
{  'BPMx089'    89    89      1.000    0.000 }
{  'BPMx090'    90    90      1.000    0.000 }
{  'BPMx091'    91    91      1.000    0.000 }
{  'BPMx092'    92    92      1.000    0.000 }
{  'BPMx093'    93    93      1.000    0.000 }
{  'BPMx094'    94    94      1.000    0.000 }
{  'BPMx095'    95    95      1.000    0.000 }
{  'BPMx096'    96    96      1.000    0.000 }
{  'BPMx097'    97    97      1.000    0.000 }
{  'BPMx098'    98    98      1.000    0.000 }
{  'BPMx099'    99    99      1.000    0.000 }
{  'BPMx100'   100   100      1.000    0.000 }
{  'BPMx101'   101   101      1.000    0.000 }
{  'BPMx102'   102   102      1.000    0.000 }
{  'BPMx103'   103   103      1.000    0.000 }
{  'BPMx104'   104   104      1.000    0.000 }
{  'BPMx105'   105   105      1.000    0.000 }
{  'BPMx106'   106   106      1.000    0.000 }
{  'BPMx107'   107   107      1.000    0.000 }
{  'BPMx108'   108   108      1.000    0.000 }
{  'BPMx109'   109   109      1.000    0.000 }
{  'BPMx110'   110   110      1.000    0.000 }
{  'BPMx111'   111   111      1.000    0.000 }
{  'BPMx112'   112   112      1.000    0.000 }
{  'BPMx113'   113   113      1.000    0.000 }
{  'BPMx114'   114   114      1.000    0.000 }
{  'BPMx115'   115   115      1.000    0.000 }
{  'BPMx116'   116   116      1.000    0.000 }
{  'BPMx117'   117   117      1.000    0.000 }
{  'BPMx118'   118   118      1.000    0.000 }
{  'BPMx119'   119   119      1.000    0.000 }
{  'BPMx120'   120   120      1.000    0.000 }
};


%Note: only fit, weight for fitting will be used in orbit program from this array
%      Name and index are loADed from middleware
% name    index fit (0/1)  weight
% corx={
% {'1CX1    '  1   1   1.0    }

%%% TO DO ERASE for automatic way if no previous file exist
% family = 'HCOR';
% good   = getfamilydata(family,'Status');
% DeviceList = family2dev(family,0);
% A1 = family2common(family,DeviceList,0);
% nb = length(good);
% A2 = (1:nb)';
% A3 = ones(nb,1).*good;
% A4 = ones(nb,1);
% 
% for k = 1:nb
%     corx{k} = {A1(k,:),A2(k),A3(k),A4(k)};
% end
% corx = corx';

%COR data: name, index, fit,  weight,   limit,      ebpm,      pbpm
corx={
{  'HCOR001'     1     1      1.000     10.000      0.250  }
{  'HCOR002'     2     0      1.000     10.000      0.250  }
{  'HCOR003'     3     0      1.000     10.000      0.250  }
{  'HCOR004'     4     4      1.000     10.000      0.250  }
{  'HCOR005'     5     0      1.000     10.000      0.250  }
{  'HCOR006'     6     0      1.000     10.000      0.250  }
{  'HCOR007'     7     7      1.000     10.000      0.250  }
{  'HCOR008'     8     8      1.000     10.000      0.250  }
{  'HCOR009'     9     0      1.000     10.000      0.250  }
{  'HCOR010'    10     0      1.000     10.000      0.250  }
{  'HCOR011'    11    11      1.000     10.000      0.250  }
{  'HCOR012'    12    12      1.000     10.000      0.250  }
{  'HCOR013'    13     0      1.000     10.000      0.250  }
{  'HCOR014'    14     0      1.000     10.000      0.250  }
{  'HCOR015'    15    15      1.000     10.000      0.250  }
{  'HCOR016'    16    16      1.000     10.000      0.250  }
{  'HCOR017'    17     0      1.000     10.000      0.250  }
{  'HCOR018'    18     0      1.000     10.000      0.250  }
{  'HCOR019'    19    19      1.000     10.000      0.250  }
{  'HCOR020'    20    20      1.000     10.000      0.250  }
{  'HCOR021'    21     0      1.000     10.000      0.250  }
{  'HCOR022'    22     0      1.000     10.000      0.250  }
{  'HCOR023'    23    23      1.000     10.000      0.250  }
{  'HCOR024'    24    24      1.000     10.000      0.250  }
{  'HCOR025'    25     0      1.000     10.000      0.250  }
{  'HCOR026'    26     0      1.000     10.000      0.250  }
{  'HCOR027'    27    27      1.000     10.000      0.250  }
{  'HCOR028'    28     0      1.000     10.000      0.250  }
{  'HCOR029'    29     0      1.000     10.000      0.250  }
{  'HCOR030'    30    30      1.000     10.000      0.250  }
{  'HCOR031'    31    31      1.000     10.000      0.250  }
{  'HCOR032'    32     0      1.000     10.000      0.250  }
{  'HCOR033'    33     0      1.000     10.000      0.250  }
{  'HCOR034'    34    34      1.000     10.000      0.250  }
{  'HCOR035'    35     0      1.000     10.000      0.250  }
{  'HCOR036'    36     0      1.000     10.000      0.250  }
{  'HCOR037'    37    37      1.000     10.000      0.250  }
{  'HCOR038'    38    38      1.000     10.000      0.250  }
{  'HCOR039'    39     0      1.000     10.000      0.250  }
{  'HCOR040'    40     0      1.000     10.000      0.250  }
{  'HCOR041'    41    41      1.000     10.000      0.250  }
{  'HCOR042'    42    42      1.000     10.000      0.250  }
{  'HCOR043'    43     0      1.000     10.000      0.250  }
{  'HCOR044'    44     0      1.000     10.000      0.250  }
{  'HCOR045'    45    45      1.000     10.000      0.250  }
{  'HCOR046'    46    46      1.000     10.000      0.250  }
{  'HCOR047'    47     0      1.000     10.000      0.250  }
{  'HCOR048'    48     0      1.000     10.000      0.250  }
{  'HCOR049'    49    49      1.000     10.000      0.250  }
{  'HCOR050'    50    50      1.000     10.000      0.250  }
{  'HCOR051'    51     0      1.000     10.000      0.250  }
{  'HCOR052'    52     0      1.000     10.000      0.250  }
{  'HCOR053'    53    53      1.000     10.000      0.250  }
{  'HCOR054'    54    54      1.000     10.000      0.250  }
{  'HCOR055'    55     0      1.000     10.000      0.250  }
{  'HCOR056'    56     0      1.000     10.000      0.250  }
{  'HCOR057'    57    57      1.000     10.000      0.250  }
{  'HCOR058'    58     0      1.000     10.000      0.250  }
{  'HCOR059'    59     0      1.000     10.000      0.250  }
{  'HCOR060'    60    60      1.000     10.000      0.250  }
{  'HCOR061'    61    61      1.000     10.000      0.250  }
{  'HCOR062'    62     0      1.000     10.000      0.250  }
{  'HCOR063'    63     0      1.000     10.000      0.250  }
{  'HCOR064'    64    64      1.000     10.000      0.250  }
{  'HCOR065'    65     0      1.000     10.000      0.250  }
{  'HCOR066'    66     0      1.000     10.000      0.250  }
{  'HCOR067'    67    67      1.000     10.000      0.250  }
{  'HCOR068'    68    68      1.000     10.000      0.250  }
{  'HCOR069'    69     0      1.000     10.000      0.250  }
{  'HCOR070'    70     0      1.000     10.000      0.250  }
{  'HCOR071'    71    71      1.000     10.000      0.250  }
{  'HCOR072'    72    72      1.000     10.000      0.250  }
{  'HCOR073'    73     0      1.000     10.000      0.250  }
{  'HCOR074'    74     0      1.000     10.000      0.250  }
{  'HCOR075'    75    75      1.000     10.000      0.250  }
{  'HCOR076'    76    76      1.000     10.000      0.250  }
{  'HCOR077'    77     0      1.000     10.000      0.250  }
{  'HCOR078'    78     0      1.000     10.000      0.250  }
{  'HCOR079'    79    79      1.000     10.000      0.250  }
{  'HCOR080'    80    80      1.000     10.000      0.250  }
{  'HCOR081'    81     0      1.000     10.000      0.250  }
{  'HCOR082'    82     0      1.000     10.000      0.250  }
{  'HCOR083'    83    83      1.000     10.000      0.250  }
{  'HCOR084'    84    84      1.000     10.000      0.250  }
{  'HCOR085'    85     0      1.000     10.000      0.250  }
{  'HCOR086'    86     0      1.000     10.000      0.250  }
{  'HCOR087'    87    87      1.000     10.000      0.250  }
{  'HCOR088'    88     0      1.000     10.000      0.250  }
{  'HCOR089'    89     0      1.000     10.000      0.250  }
{  'HCOR090'    90    90      1.000     10.000      0.250  }
{  'HCOR091'    91    91      1.000     10.000      0.250  }
{  'HCOR092'    92     0      1.000     10.000      0.250  }
{  'HCOR093'    93     0      1.000     10.000      0.250  }
{  'HCOR094'    94    94      1.000     10.000      0.250  }
{  'HCOR095'    95     0      1.000     10.000      0.250  }
{  'HCOR096'    96     0      1.000     10.000      0.250  }
{  'HCOR097'    97    97      1.000     10.000      0.250  }
{  'HCOR098'    98    98      1.000     10.000      0.250  }
{  'HCOR099'    99     0      1.000     10.000      0.250  }
{  'HCOR100'   100     0      1.000     10.000      0.250  }
{  'HCOR101'   101   101      1.000     10.000      0.250  }
{  'HCOR102'   102   102      1.000     10.000      0.250  }
{  'HCOR103'   103     0      1.000     10.000      0.250  }
{  'HCOR104'   104     0      1.000     10.000      0.250  }
{  'HCOR105'   105   105      1.000     10.000      0.250  }
{  'HCOR106'   106   106      1.000     10.000      0.250  }
{  'HCOR107'   107     0      1.000     10.000      0.250  }
{  'HCOR108'   108     0      1.000     10.000      0.250  }
{  'HCOR109'   109   109      1.000     10.000      0.250  }
{  'HCOR110'   110   110      1.000     10.000      0.250  }
{  'HCOR111'   111     0      1.000     10.000      0.250  }
{  'HCOR112'   112     0      1.000     10.000      0.250  }
{  'HCOR113'   113   113      1.000     10.000      0.250  }
{  'HCOR114'   114   114      1.000     10.000      0.250  }
{  'HCOR115'   115     0      1.000     10.000      0.250  }
{  'HCOR116'   116     0      1.000     10.000      0.250  }
{  'HCOR117'   117   117      1.000     10.000      0.250  }
{  'HCOR118'   118     0      1.000     10.000      0.250  }
{  'HCOR119'   119     0      1.000     10.000      0.250  }
{  'HCOR120'   120   120      1.000     10.000      0.250  }
};

%*===   VERTICAL DATA ===*
% bpm(2).dev      = 10;              %maximum orbit deviation
bpm(2).id       = 1;               %BPM selection
bpm(2).scalemode= 1;               %BPM scale mode 0=manual mode, 1=autoscale
bpm(2).ylim     = 5;               %BPM vertical axis scale
bpm(2).units    = '1000xHardware'; %Display units
bpm(1).scale    = 1000;            %Scaling factor
cor(2).fract    = 1.0;             %fraction of correctors
cor(2).id       = 1;               %COR selection
cor(2).scalemode= 0;               %COR scale mode 0=manual mode, 1=autoscale
cor(2).ylim     = maxn(getfamilydata(cor(2).AOFamily,'Setpoint','Range'));  %COR horizontal axis scale (amp)
cor(2).units    = 'Hardware';      %Display Units
cor(2).hw2physics = hw2physics(cor(2).AOFamily,'Setpoint',1,1)*1e3; % mrAD
rsp(2).disp     = 'off';           %mode for matrix column display
rsp(2).eig      = 'off';           %mode for eigenvector display
rsp(2).fit      = 0;               %valid fit flag
rsp(2).rfflag   = 0;               %rf fitting flag
rsp(2).etaflag  = 0;               %dispersion fitting flag
rsp(2).savflag  = 0;               %save solution flag
rsp(2).nsvd     = 56;              %number of singular values
rsp(2).svdtol   = 0;               %svd tolerance (0 uses number of singular values)
rsp(2).nsvdmax  = 1;               %default maximum number of singular values

%%% TO DO ERASE for automatic way if no previous file exist
% 
% %     name       index  fit (0/1) weight   etaweight
% % bpmz={
% % {    '1BPM1    '     1      1      1.000     0.000     }
% bpmz = bpmx;

%BPM data: name, index, fit,  weight
bpmz={
{  'BPMz001'     1     1      1.000    0.000 }
{  'BPMz002'     2     2      1.000    0.000 }
{  'BPMz003'     3     3      1.000    0.000 }
{  'BPMz004'     4     4      1.000    0.000 }
{  'BPMz005'     5     5      1.000    0.000 }
{  'BPMz006'     6     6      1.000    0.000 }
{  'BPMz007'     7     7      1.000    0.000 }
{  'BPMz008'     8     8      1.000    0.000 }
{  'BPMz009'     9     9      1.000    0.000 }
{  'BPMz010'    10    10      1.000    0.000 }
{  'BPMz011'    11    11      1.000    0.000 }
{  'BPMz012'    12    12      1.000    0.000 }
{  'BPMz013'    13    13      1.000    0.000 }
{  'BPMz014'    14    14      1.000    0.000 }
{  'BPMz015'    15    15      1.000    0.000 }
{  'BPMz016'    16    16      1.000    0.000 }
{  'BPMz017'    17    17      1.000    0.000 }
{  'BPMz018'    18    18      1.000    0.000 }
{  'BPMz019'    19    19      1.000    0.000 }
{  'BPMz020'    20    20      1.000    0.000 }
{  'BPMz021'    21    21      1.000    0.000 }
{  'BPMz022'    22    22      1.000    0.000 }
{  'BPMz023'    23    23      1.000    0.000 }
{  'BPMz024'    24    24      1.000    0.000 }
{  'BPMz025'    25    25      1.000    0.000 }
{  'BPMz026'    26    26      1.000    0.000 }
{  'BPMz027'    27    27      1.000    0.000 }
{  'BPMz028'    28    28      1.000    0.000 }
{  'BPMz029'    29    29      1.000    0.000 }
{  'BPMz030'    30    30      1.000    0.000 }
{  'BPMz031'    31    31      1.000    0.000 }
{  'BPMz032'    32    32      1.000    0.000 }
{  'BPMz033'    33    33      1.000    0.000 }
{  'BPMz034'    34    34      1.000    0.000 }
{  'BPMz035'    35    35      1.000    0.000 }
{  'BPMz036'    36    36      1.000    0.000 }
{  'BPMz037'    37    37      1.000    0.000 }
{  'BPMz038'    38    38      1.000    0.000 }
{  'BPMz039'    39    39      1.000    0.000 }
{  'BPMz040'    40    40      1.000    0.000 }
{  'BPMz041'    41    41      1.000    0.000 }
{  'BPMz042'    42    42      1.000    0.000 }
{  'BPMz043'    43    43      1.000    0.000 }
{  'BPMz044'    44    44      1.000    0.000 }
{  'BPMz045'    45    45      1.000    0.000 }
{  'BPMz046'    46    46      1.000    0.000 }
{  'BPMz047'    47    47      1.000    0.000 }
{  'BPMz048'    48    48      1.000    0.000 }
{  'BPMz049'    49    49      1.000    0.000 }
{  'BPMz050'    50    50      1.000    0.000 }
{  'BPMz051'    51    51      1.000    0.000 }
{  'BPMz052'    52    52      1.000    0.000 }
{  'BPMz053'    53    53      1.000    0.000 }
{  'BPMz054'    54    54      1.000    0.000 }
{  'BPMz055'    55    55      1.000    0.000 }
{  'BPMz056'    56    56      1.000    0.000 }
{  'BPMz057'    57    57      1.000    0.000 }
{  'BPMz058'    58    58      1.000    0.000 }
{  'BPMz059'    59    59      1.000    0.000 }
{  'BPMz060'    60    60      1.000    0.000 }
{  'BPMz061'    61    61      1.000    0.000 }
{  'BPMz062'    62    62      1.000    0.000 }
{  'BPMz063'    63    63      1.000    0.000 }
{  'BPMz064'    64    64      1.000    0.000 }
{  'BPMz065'    65    65      1.000    0.000 }
{  'BPMz066'    66    66      1.000    0.000 }
{  'BPMz067'    67    67      1.000    0.000 }
{  'BPMz068'    68    68      1.000    0.000 }
{  'BPMz069'    69    69      1.000    0.000 }
{  'BPMz070'    70    70      1.000    0.000 }
{  'BPMz071'    71    71      1.000    0.000 }
{  'BPMz072'    72    72      1.000    0.000 }
{  'BPMz073'    73    73      1.000    0.000 }
{  'BPMz074'    74    74      1.000    0.000 }
{  'BPMz075'    75    75      1.000    0.000 }
{  'BPMz076'    76    76      1.000    0.000 }
{  'BPMz077'    77    77      1.000    0.000 }
{  'BPMz078'    78    78      1.000    0.000 }
{  'BPMz079'    79    79      1.000    0.000 }
{  'BPMz080'    80    80      1.000    0.000 }
{  'BPMz081'    81    81      1.000    0.000 }
{  'BPMz082'    82    82      1.000    0.000 }
{  'BPMz083'    83    83      1.000    0.000 }
{  'BPMz084'    84    84      1.000    0.000 }
{  'BPMz085'    85    85      1.000    0.000 }
{  'BPMz086'    86    86      1.000    0.000 }
{  'BPMz087'    87    87      1.000    0.000 }
{  'BPMz088'    88    88      1.000    0.000 }
{  'BPMz089'    89    89      1.000    0.000 }
{  'BPMz090'    90    90      1.000    0.000 }
{  'BPMz091'    91    91      1.000    0.000 }
{  'BPMz092'    92    92      1.000    0.000 }
{  'BPMz093'    93    93      1.000    0.000 }
{  'BPMz094'    94    94      1.000    0.000 }
{  'BPMz095'    95    95      1.000    0.000 }
{  'BPMz096'    96    96      1.000    0.000 }
{  'BPMz097'    97    97      1.000    0.000 }
{  'BPMz098'    98    98      1.000    0.000 }
{  'BPMz099'    99    99      1.000    0.000 }
{  'BPMz100'   100   100      1.000    0.000 }
{  'BPMz101'   101   101      1.000    0.000 }
{  'BPMz102'   102   102      1.000    0.000 }
{  'BPMz103'   103   103      1.000    0.000 }
{  'BPMz104'   104   104      1.000    0.000 }
{  'BPMz105'   105   105      1.000    0.000 }
{  'BPMz106'   106   106      1.000    0.000 }
{  'BPMz107'   107   107      1.000    0.000 }
{  'BPMz108'   108   108      1.000    0.000 }
{  'BPMz109'   109   109      1.000    0.000 }
{  'BPMz110'   110   110      1.000    0.000 }
{  'BPMz111'   111   111      1.000    0.000 }
{  'BPMz112'   112   112      1.000    0.000 }
{  'BPMz113'   113   113      1.000    0.000 }
{  'BPMz114'   114   114      1.000    0.000 }
{  'BPMz115'   115   115      1.000    0.000 }
{  'BPMz116'   116   116      1.000    0.000 }
{  'BPMz117'   117   117      1.000    0.000 }
{  'BPMz118'   118   118      1.000    0.000 }
{  'BPMz119'   119   119      1.000    0.000 }
{  'BPMz120'   120   120      1.000    0.000 }
};

%%% TO DO ERASE for automatic way if no previous file exist

% % name    index fit (0/1)  weight
% % corz={
% % {'1CY1    '  1   1   1.0    }
% family = 'VCOR';
% good = getfamilydata(family,'Status');
% nb = length(good);
% DeviceList = family2dev(family,0);
% A1 = family2common(family,DeviceList,0);
% A2 = (1:nb)';
% A3 = ones(nb,1).*good;
% A4 = ones(nb,1);
% 
% for k = 1:nb
%     corz{k} = {A1(k,:),A2(k),A3(k),A4(k)};
% end
% corz = corz';

%COR data: name, index, fit,  weight,   limit,      ebpm,      pbpm
corz={
{  'VCOR001'     1     0      1.000     10.000      0.500  }
{  'VCOR002'     2     2      1.000     10.000      0.500  }
{  'VCOR003'     3     0      1.000     10.000      0.500  }
{  'VCOR004'     4     4      1.000     10.000      0.500  }
{  'VCOR005'     5     0      1.000     10.000      0.500  }
{  'VCOR006'     6     6      1.000     10.000      0.500  }
{  'VCOR007'     7     0      1.000     10.000      0.500  }
{  'VCOR008'     8     0      1.000     10.000      0.500  }
{  'VCOR009'     9     9      1.000     10.000      0.500  }
{  'VCOR010'    10    10      1.000     10.000      0.500  }
{  'VCOR011'    11     0      1.000     10.000      0.500  }
{  'VCOR012'    12     0      1.000     10.000      0.500  }
{  'VCOR013'    13    13      1.000     10.000      0.500  }
{  'VCOR014'    14    14      1.000     10.000      0.500  }
{  'VCOR015'    15     0      1.000     10.000      0.500  }
{  'VCOR016'    16     0      1.000     10.000      0.500  }
{  'VCOR017'    17    17      1.000     10.000      0.500  }
{  'VCOR018'    18    18      1.000     10.000      0.500  }
{  'VCOR019'    19     0      1.000     10.000      0.500  }
{  'VCOR020'    20     0      1.000     10.000      0.500  }
{  'VCOR021'    21    21      1.000     10.000      0.500  }
{  'VCOR022'    22    22      1.000     10.000      0.500  }
{  'VCOR023'    23     0      1.000     10.000      0.500  }
{  'VCOR024'    24     0      1.000     10.000      0.500  }
{  'VCOR025'    25    25      1.000     10.000      0.500  }
{  'VCOR026'    26     0      1.000     10.000      0.500  }
{  'VCOR027'    27    27      1.000     10.000      0.500  }
{  'VCOR028'    28     0      1.000     10.000      0.500  }
{  'VCOR029'    29    29      1.000     10.000      0.500  }
{  'VCOR030'    30     0      1.000     10.000      0.500  }
{  'VCOR031'    31     0      1.000     10.000      0.500  }
{  'VCOR032'    32    32      1.000     10.000      0.500  }
{  'VCOR033'    33     0      1.000     10.000      0.500  }
{  'VCOR034'    34    34      1.000     10.000      0.500  }
{  'VCOR035'    35     0      1.000     10.000      0.500  }
{  'VCOR036'    36    36      1.000     10.000      0.500  }
{  'VCOR037'    37     0      1.000     10.000      0.500  }
{  'VCOR038'    38     0      1.000     10.000      0.500  }
{  'VCOR039'    39    39      1.000     10.000      0.500  }
{  'VCOR040'    40    40      1.000     10.000      0.500  }
{  'VCOR041'    41     0      1.000     10.000      0.500  }
{  'VCOR042'    42     0      1.000     10.000      0.500  }
{  'VCOR043'    43    43      1.000     10.000      0.500  }
{  'VCOR044'    44    44      1.000     10.000      0.500  }
{  'VCOR045'    45     0      1.000     10.000      0.500  }
{  'VCOR046'    46     0      1.000     10.000      0.500  }
{  'VCOR047'    47    47      1.000     10.000      0.500  }
{  'VCOR048'    48    48      1.000     10.000      0.500  }
{  'VCOR049'    49     0      1.000     10.000      0.500  }
{  'VCOR050'    50     0      1.000     10.000      0.500  }
{  'VCOR051'    51    51      1.000     10.000      0.500  }
{  'VCOR052'    52    52      1.000     10.000      0.500  }
{  'VCOR053'    53     0      1.000     10.000      0.500  }
{  'VCOR054'    54     0      1.000     10.000      0.500  }
{  'VCOR055'    55    55      1.000     10.000      0.500  }
{  'VCOR056'    56     0      1.000     10.000      0.500  }
{  'VCOR057'    57    57      1.000     10.000      0.500  }
{  'VCOR058'    58     0      1.000     10.000      0.500  }
{  'VCOR059'    59    59      1.000     10.000      0.500  }
{  'VCOR060'    60     0      1.000     10.000      0.500  }
{  'VCOR061'    61     0      1.000     10.000      0.500  }
{  'VCOR062'    62    62      1.000     10.000      0.500  }
{  'VCOR063'    63     0      1.000     10.000      0.500  }
{  'VCOR064'    64    64      1.000     10.000      0.500  }
{  'VCOR065'    65     0      1.000     10.000      0.500  }
{  'VCOR066'    66    66      1.000     10.000      0.500  }
{  'VCOR067'    67     0      1.000     10.000      0.500  }
{  'VCOR068'    68     0      1.000     10.000      0.500  }
{  'VCOR069'    69    69      1.000     10.000      0.500  }
{  'VCOR070'    70    70      1.000     10.000      0.500  }
{  'VCOR071'    71     0      1.000     10.000      0.500  }
{  'VCOR072'    72     0      1.000     10.000      0.500  }
{  'VCOR073'    73    73      1.000     10.000      0.500  }
{  'VCOR074'    74    74      1.000     10.000      0.500  }
{  'VCOR075'    75     0      1.000     10.000      0.500  }
{  'VCOR076'    76     0      1.000     10.000      0.500  }
{  'VCOR077'    77    77      1.000     10.000      0.500  }
{  'VCOR078'    78    78      1.000     10.000      0.500  }
{  'VCOR079'    79     0      1.000     10.000      0.500  }
{  'VCOR080'    80     0      1.000     10.000      0.500  }
{  'VCOR081'    81    81      1.000     10.000      0.500  }
{  'VCOR082'    82    82      1.000     10.000      0.500  }
{  'VCOR083'    83     0      1.000     10.000      0.500  }
{  'VCOR084'    84     0      1.000     10.000      0.500  }
{  'VCOR085'    85    85      1.000     10.000      0.500  }
{  'VCOR086'    86     0      1.000     10.000      0.500  }
{  'VCOR087'    87    87      1.000     10.000      0.500  }
{  'VCOR088'    88     0      1.000     10.000      0.500  }
{  'VCOR089'    89    89      1.000     10.000      0.500  }
{  'VCOR090'    90     0      1.000     10.000      0.500  }
{  'VCOR091'    91     0      1.000     10.000      0.500  }
{  'VCOR092'    92    92      1.000     10.000      0.500  }
{  'VCOR093'    93     0      1.000     10.000      0.500  }
{  'VCOR094'    94    94      1.000     10.000      0.500  }
{  'VCOR095'    95     0      1.000     10.000      0.500  }
{  'VCOR096'    96    96      1.000     10.000      0.500  }
{  'VCOR097'    97     0      1.000     10.000      0.500  }
{  'VCOR098'    98     0      1.000     10.000      0.500  }
{  'VCOR099'    99    99      1.000     10.000      0.500  }
{  'VCOR100'   100   100      1.000     10.000      0.500  }
{  'VCOR101'   101     0      1.000     10.000      0.500  }
{  'VCOR102'   102     0      1.000     10.000      0.500  }
{  'VCOR103'   103   103      1.000     10.000      0.500  }
{  'VCOR104'   104   104      1.000     10.000      0.500  }
{  'VCOR105'   105     0      1.000     10.000      0.500  }
{  'VCOR106'   106     0      1.000     10.000      0.500  }
{  'VCOR107'   107   107      1.000     10.000      0.500  }
{  'VCOR108'   108   108      1.000     10.000      0.500  }
{  'VCOR109'   109     0      1.000     10.000      0.500  }
{  'VCOR110'   110     0      1.000     10.000      0.500  }
{  'VCOR111'   111   111      1.000     10.000      0.500  }
{  'VCOR112'   112   112      1.000     10.000      0.500  }
{  'VCOR113'   113     0      1.000     10.000      0.500  }
{  'VCOR114'   114     0      1.000     10.000      0.500  }
{  'VCOR115'   115   115      1.000     10.000      0.500  }
{  'VCOR116'   116     0      1.000     10.000      0.500  }
{  'VCOR117'   117   117      1.000     10.000      0.500  }
{  'VCOR118'   118     0      1.000     10.000      0.500  }
{  'VCOR119'   119   119      1.000     10.000      0.500  }
{  'VCOR120'   120     0      1.000     10.000      0.500  }
};
 
