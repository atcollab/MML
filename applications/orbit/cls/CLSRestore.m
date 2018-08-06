%system parameter save file
%timestamp: 22-Mar-2002 08:08:08
%comment: Save System

ad=getad;
filetype = 'RESTORE';              %check to see if correct file type
sys.machine='CLS';                 %machine for control
sys.datamode     = 'REAL';         %raw or real (for real: (1)response matrix multiplied by bpm gains, (2) BPM reads have gain, offset
sys.mode='SIMULATOR';              %online or simulator
sys.bpmode='CanadianLightSource';  %BPM system mode
sys.bpmslp=0.1;                    %BPM sleep time in sec
sys.plane=1;                       %plane (1=horizontal 2=vertical)
sys.globalperiod = 2.0;            %BPM sleep time in sec
sys.silverperiod = 2.0;            %BPM sleep time in sec
sys.algo         = 'SVD';          %fitting algorithm
sys.pbpm         = 0;              %use of photon BPMs
sys.filpath      = ad.Directory.Orbit;       %file path in MATLAB
sys.reffil       = [sys.filpath 'sp3silver.dat'];                                  %reference orbit file
sys.respfiledir  = ad.Directory.OpsData;                                           %response matrix directory
sys.respfilename = ad.OpsData.BPMRespFile;                                         %response matrix file
sys.etafil       = [sys.filpath 'etadata.m'];         %dispersion file
sys.relative     = 1;              %relative or absolute BPM plot 1=absolute, 2=relative
sys.fdbk         = 0;              %no feedback
sys.abort        = 0;              %reset abort flag
sys.mxs          = 180;            %maximum ring circumference
sys.xlimax       = 180;            %abcissa plot limit
sys.mxphi(1)     = 8;              %maximum horizontal phase advance
sys.mxphi(2)     = 4;              %maximum vertical phase advance
sys.xscale       = 'meter';        %abcissa plotting mode (meter or phase)

%*=== HORIZONTAL DATA ===*
bpm(1).dev      = 10;              %maximum orbit deviation
bpm(1).drf      = 0;               %dispersion component zero
bpm(1).id       = 5;               %BPM selection
bpm(1).scalemode= 0;               %BPM scale mode 0=manual mode, 1=autoscale
bpm(1).ylim     = 5;               %BPM vertical axis scale
cor(1).fract    = 1.0;             %fraction of correctors
cor(1).id=1;                       %COR selection
cor(1).scalemode=0;                %COR scale mode 0=manual mode, 1=autoscale
cor(1).ylim=10;                    %COR horizontal axis scale (amp)
rsp(1).disp     = 'off';           %mode for matrix column display
rsp(1).eig      = 'off';           %mode for eigenvector display
rsp(1).fit      = 0;               %valid fit flag
rsp(1).rfflag   = 0;               %rf fitting flag
rsp(1).etaflag  = 0;               %dispersion fitting flag
rsp(1).savflag  = 0;               %save solution flag
rsp(1).nsvd     = 25;              %number of singular values
rsp(1).svdtol   = 0;               %svd tolerance (0 uses number of singular values)
rsp(1).nsvdmx   = 1;               %default maximum number of singular values
 
%BPM data: name, index, fit (0/1),  weight etaweight
bpmx={
{    '1BP1    '     1      1      1.000    0.000}
{    '1BP2    '     2      1      1.000    0.000}
{    '1BP3    '     3      1      1.000    0.000}
{    '1BP4    '     4      1      1.000    0.000}
{    '2BP1    '     5      1      1.000    0.000}
{    '2BP2    '     6      1      1.000    0.000}
{    '2BP3    '     7      1      1.000    0.000}
{    '2BP4    '     8      1      1.000    0.000}
{    '3BP1    '     9      1      1.000    0.000}
{    '3BP2    '     10     1      1.000    0.000}
{    '3BP3    '     11     1      1.000    0.000}
{    '3BP4    '     12     1      1.000    0.000}
{    '4BP1    '     13     1      1.000    0.000}
{    '4BP2    '     14     1      1.000    0.000}
{    '4BP3    '     15     1      1.000    0.000}
{    '4BP4    '     16     1      1.000    0.000}
{    '5BP1    '     17     1      1.000    0.000}
{    '5BP2    '     18     1      1.000    0.000}
{    '5BP3    '     19     1      1.000    0.000}
{    '5BP4    '     20     1      1.000    0.000}
{    '6BP1    '     21     1      1.000    0.000}
{    '6BP2    '     22     1      1.000    0.000}
{    '6BP3    '     23     1      1.000    0.000}
{    '6BP4    '     24     1      1.000    0.000}
{    '7BP1    '     25     1      1.000    0.000}
{    '7BP2    '     26     1      1.000    0.000}
{    '7BP3    '     27     1      1.000    0.000}
{    '7BP4    '     28     1      1.000    0.000}
{    '8BP1    '     29     1      1.000    0.000}
{    '8BP2    '     30     1      1.000    0.000}
{    '8BP3    '     31     1      1.000    0.000}
{    '8BP4    '     32     1      1.000    0.000}
{    '9BP1    '     33     1      1.000    0.000}
{    '9BP2    '     34     1      1.000    0.000}
{    '9BP3    '     35     1      1.000    0.000}
{    '9BP4    '     36     1      1.000    0.000}
{    '10BP1   '     37     1      1.000    0.000}
{    '10BP2   '     38     1      1.000    0.000}
{    '10BP3   '     39     1      1.000    0.000}
{    '10BP4   '     40     1      1.000    0.000}
{    '11BP1   '     41     1      1.000    0.000}
{    '11BP2   '     42     1      1.000    0.000}
{    '11BP3   '     43     1      1.000    0.000}
{    '11BP4   '     44     1      1.000    0.000}
{    '12BP1   '     45     1      1.000    0.000}
{    '12BP2   '     46     1      1.000    0.000}
{    '12BP3   '     47     1      1.000    0.000}
{    '12BP4   '     48     1      1.000    0.000}
};
 
%COR data: name, index, fit (0/1),  weight,   limit,      ebpm,      pbpm
corx={
{'1CX1    '  1   1   1.0    30    1.5  0.0  }
{'1CX2    '  2   1   1.0    30    1.5  0.0  }
{'1CX3    '  3   1   1.0    30    1.5  0.0  }
{'1CX4    '  4   1   1.0    30    1.5  0.0  }
{'2CX1    '  5   1   1.0    30    1.5  0.0  }
{'2CX2    '  6   1   1.0    30    1.5  0.0  }
{'2CX3    '  7   1   1.0    30    1.5  0.0  }
{'2CX4    '  8   1   1.0    30    1.5  0.0  }
{'3CX1    '  9   1   1.0    30    1.5  0.0  }
{'3CX2    '  10  1   1.0    30    1.5  0.0  }
{'3CX3    '  11  1   1.0    30    1.5  0.0  }
{'3CX4    '  12  1   1.0    30    1.5  0.0  }
{'4CX1    '  13  1   1.0    30    1.5  0.0  }
{'4CX2    '  14  1   1.0    30    1.5  0.0  }
{'4CX3    '  15  1   1.0    30    1.5  0.0  }
{'4CX4    '  16  1   1.0    30    1.5  0.0  }
{'5CX1    '  17  1   1.0    30    1.5  0.0  }
{'5CX2    '  18  1   1.0    30    1.5  0.0  }
{'5CX3    '  19  1   1.0    30    1.5  0.0  }
{'5CX4    '  20  1   1.0    30    1.5  0.0  }
{'6CX1    '  21  1   1.0    30    1.5  0.0  }
{'6CX2    '  22  1   1.0    30    1.5  0.0  }
{'6CX3    '  23  1   1.0    30    1.5  0.0  }
{'6CX4    '  24  1   1.0    30    1.5  0.0  }
{'7CX1    '  25  1   1.0    30    1.5  0.0  }
{'7CX2    '  26  1   1.0    30    1.5  0.0  }
{'7CX3    '  27  1   1.0    30    1.5  0.0  }
{'7CX4    '  28  1   1.0    30    1.5  0.0  }
{'8CX1    '  29  1   1.0    30    1.5  0.0  }
{'8CX2    '  30  1   1.0    30    1.5  0.0  }
{'8CX3    '  31  1   1.0    30    1.5  0.0  }
{'8CX4    '  32  1   1.0    30    1.5  0.0  }
{'9CX1    '  33  1   1.0    30    1.5  0.0  }
{'9CX2    '  34  1   1.0    30    1.5  0.0  }
{'9CX3    '  35  1   1.0    30    1.5  0.0  }
{'9CX4    '  36  1   1.0    30    1.5  0.0  }
{'10CX1   '  37  1   1.0    30    1.5  0.0  }
{'10CX2   '  38  1   1.0    30    1.5  0.0  }
{'10CX3   '  39  1   1.0    30    1.5  0.0  }
{'10CX4   '  40  1   1.0    30    1.5  0.0  }
{'11CX1   '  41  1   1.0    30    1.5  0.0  }
{'11CX2   '  42  1   1.0    30    1.5  0.0  }
{'11CX3   '  43  1   1.0    30    1.5  0.0  }
{'11CX4   '  44  1   1.0    30    1.5  0.0  }
{'12CX1   '  45  1   1.0    30    1.5  0.0  }
{'12CX2   '  46  1   1.0    30    1.5  0.0  }
{'12CX3   '  47  1   1.0    30    1.5  0.0  }
{'12CX4   '  48  1   1.0    30    1.5  0.0  }
}; 
 
%*===   VERTICAL DATA ===*
bpm(2).dev=10;          %maximum orbit deviation
bpm(2).drf=0;           %dispersion component zero
bpm(2).id=1;            %BPM selection
bpm(2).scalemode=0;     %BPM scale mode 0=manual mode, 1=autoscale
bpm(2).ylim=5;          %BPM vertical axis scale
cor(2).fract=0.7;       %fraction of correctors
cor(2).id=1;            %COR selection
cor(2).scalemode=0;     %COR scale mode 0=manual mode, 1=autoscale
cor(2).ylim=10;         %COR vertical axis scale (amp)
rsp(2).disp ='off';     %mode for matrix column display
rsp(2).eig  ='off';     %mode for eigenvector display
rsp(2).fit  =0;         %valid fit flag
rsp(2).rfflag=0;        %rf fitting flag
rsp(2).etaflag=0;       %dispersion fitting flag
rsp(2).savflag=0;       %save solution flag
rsp(2).nsvd=20;         %number of singular values
rsp(2).svdtol=0;        %svd tolerance (0 uses number of singular values)
rsp(2).nsvdmx=1;        %default maximum number of singular values
 
%BPM data: name, index, fit (0/1),  weight
bpmy={
{    '1BP1    '     1      1      1.000    0.000}
{    '1BP2    '     2      1      1.000    0.000}
{    '1BP3    '     3      1      1.000    0.000}
{    '1BP4    '     4      1      1.000    0.000}
{    '2BP1    '     5      1      1.000    0.000}
{    '2BP2    '     6      1      1.000    0.000}
{    '2BP3    '     7      1      1.000    0.000}
{    '2BP4    '     8      1      1.000    0.000}
{    '3BP1    '     9      1      1.000    0.000}
{    '3BP2    '     10     1      1.000    0.000}
{    '3BP3    '     11     1      1.000    0.000}
{    '3BP4    '     12     1      1.000    0.000}
{    '4BP1    '     13     1      1.000    0.000}
{    '4BP2    '     14     1      1.000    0.000}
{    '4BP3    '     15     1      1.000    0.000}
{    '4BP4    '     16     1      1.000    0.000}
{    '5BP1    '     17     1      1.000    0.000}
{    '5BP2    '     18     1      1.000    0.000}
{    '5BP3    '     19     1      1.000    0.000}
{    '5BP4    '     20     1      1.000    0.000}
{    '6BP1    '     21     1      1.000    0.000}
{    '6BP2    '     22     1      1.000    0.000}
{    '6BP3    '     23     1      1.000    0.000}
{    '6BP4    '     24     1      1.000    0.000}
{    '7BP1    '     25     1      1.000    0.000}
{    '7BP2    '     26     1      1.000    0.000}
{    '7BP3    '     27     1      1.000    0.000}
{    '7BP4    '     28     1      1.000    0.000}
{    '8BP1    '     29     1      1.000    0.000}
{    '8BP2    '     30     1      1.000    0.000}
{    '8BP3    '     31     1      1.000    0.000}
{    '8BP4    '     32     1      1.000    0.000}
{    '9BP1    '     33     1      1.000    0.000}
{    '9BP2    '     34     1      1.000    0.000}
{    '9BP3    '     35     1      1.000    0.000}
{    '9BP4    '     36     1      1.000    0.000}
{    '10BP1   '     37     1      1.000    0.000}
{    '10BP2   '     38     1      1.000    0.000}
{    '10BP3   '     39     1      1.000    0.000}
{    '10BP4   '     40     1      1.000    0.000}
{    '11BP1   '     41     1      1.000    0.000}
{    '11BP2   '     42     1      1.000    0.000}
{    '11BP3   '     43     1      1.000    0.000}
{    '11BP4   '     44     1      1.000    0.000}
{    '12BP1   '     45     1      1.000    0.000}
{    '12BP2   '     46     1      1.000    0.000}
{    '12BP3   '     47     1      1.000    0.000}
{    '12BP4   '     48     1      1.000    0.000}
};
 
%COR data: name, index, fit (0/1),  weight,   limit,      ebpm,      pbpm
cory={
{'1CY1    '  1   1   1.0    30    1.5  0.0  }
{'1CY2    '  2   1   1.0    30    1.5  0.0  }
{'1CY3    '  3   1   1.0    30    1.5  0.0  }
{'1CY4    '  4   1   1.0    30    1.5  0.0  }
{'2CY1    '  5   1   1.0    30    1.5  0.0  }
{'2CY2    '  6   1   1.0    30    1.5  0.0  }
{'2CY3    '  7   1   1.0    30    1.5  0.0  }
{'2CY4    '  8   1   1.0    30    1.5  0.0  }
{'3CY1    '  9   1   1.0    30    1.5  0.0  }
{'3CY2    '  10  1   1.0    30    1.5  0.0  }
{'3CY3    '  11  1   1.0    30    1.5  0.0  }
{'3CY4    '  12  1   1.0    30    1.5  0.0  }
{'4CY1    '  13  1   1.0    30    1.5  0.0  }
{'4CY2    '  14  1   1.0    30    1.5  0.0  }
{'4CY3    '  15  1   1.0    30    1.5  0.0  }
{'4CY4    '  16  1   1.0    30    1.5  0.0  }
{'5CY1    '  17  1   1.0    30    1.5  0.0  }
{'5CY2    '  18  1   1.0    30    1.5  0.0  }
{'5CY3    '  19  1   1.0    30    1.5  0.0  }
{'5CY4    '  20  1   1.0    30    1.5  0.0  }
{'6CY1    '  21  1   1.0    30    1.5  0.0  }
{'6CY2    '  22  1   1.0    30    1.5  0.0  }
{'6CY3    '  23  1   1.0    30    1.5  0.0  }
{'6CY4    '  24  1   1.0    30    1.5  0.0  }
{'7CY1    '  25  1   1.0    30    1.5  0.0  }
{'7CY2    '  26  1   1.0    30    1.5  0.0  }
{'7CY3    '  27  1   1.0    30    1.5  0.0  }
{'7CY4    '  28  1   1.0    30    1.5  0.0  }
{'8CY1    '  29  1   1.0    30    1.5  0.0  }
{'8CY2    '  30  1   1.0    30    1.5  0.0  }
{'8CY3    '  31  1   1.0    30    1.5  0.0  }
{'8CY4    '  32  1   1.0    30    1.5  0.0  }
{'9CY1    '  33  1   1.0    30    1.5  0.0  }
{'9CY2    '  34  1   1.0    30    1.5  0.0  }
{'9CY3    '  35  1   1.0    30    1.5  0.0  }
{'9CY4    '  36  1   1.0    30    1.5  0.0  }
{'10CY1   '  37  1   1.0    30    1.5  0.0  }
{'10CY2   '  38  1   1.0    30    1.5  0.0  }
{'10CY3   '  39  1   1.0    30    1.5  0.0  }
{'10CY4   '  40  1   1.0    30    1.5  0.0  }
{'11CY1   '  41  1   1.0    30    1.5  0.0  }
{'11CY2   '  42  1   1.0    30    1.5  0.0  }
{'11CY3   '  43  1   1.0    30    1.5  0.0  }
{'11CY4   '  44  1   1.0    30    1.5  0.0  }
{'12CY1   '  45  1   1.0    30    1.5  0.0  }
{'12CY2   '  46  1   1.0    30    1.5  0.0  }
{'12CY3   '  47  1   1.0    30    1.5  0.0  }
{'12CY4   '  48  1   1.0    30    1.5  0.0  }
};
 
%BL data: name, index, fit,  weight
 bly={
{     'BL1 '     1     0    100.000 }
{     'BL2 '     2     0    100.000 }
{     'BL3 '     3     0    100.000 }
{     'BL4 '     4     0    100.000 }
{     'BL5 '     5     0    100.000 }
{     'BL6 '     6     0    100.000 }
{     'BL7 '     7     0    100.000 }
{     'BL8 '     8     0    100.000 }
{     'BL9 '     9     0    100.000 }
{     'BL10'    10     0    100.000 }
{     'BL11'    11     0    100.000 }
};
 
