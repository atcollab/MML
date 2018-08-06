%function [sys,bpmx,bpmy,bpm,corx,cory,cor,rsp,bly]=restore
%system parameter save file
%timestamp: 18-Jan-2002 08:08:08
%comment: Save System
ad=getad;
filetype         = 'RESTORE';      %check to see if correct file type
sys.machine      = 'SPEAR3';       %machine for control
sys.mode         = 'ONLINE';       %online or simulator
sys.datamode     = 'REAL';         %raw or real (for real: (1)response matrix multiplied by bpm gains, (2) BPM reads have gain, offset
sys.bpmode       = 'BERGOZ';       %BPM system mode
sys.bpmslp       = 3.0;            %BPM sleep time in sec
sys.plane        = 1;              %plane (1=horizontal 2=vertical)
sys.algo         = 'SVD';          %fitting algorithm
sys.pbpm         = 1;              %use of photon BPMs
sys.filpath      = ad.Directory.Orbit;       %file path in MATLAB
sys.respfiledir  = ad.Directory.OpsData;                                           %response matrix directory
sys.respfilename = ad.OpsData.BPMRespFile;                                         %response matrix file
sys.mxs          = 250;            %maximum ring circumference
sys.xlimax       = 250;            %abcissa plot limit
sys.mxphi(1)     = 8;              %maximum horizontal phase advance
sys.mxphi(2)     = 6;              %maximum vertical phase advance
sys.xscale       = 'meter';        %abcissa plotting mode (meter or phase)
 
%*=== HORIZONTAL DATA ===*
bpm(1).dev      = 10;              %maximum orbit deviation
bpm(1).drf      = 0;               %dispersion component zero
bpm(1).id       = 5;               %BPM selection
bpm(1).scalemode= 0;               %BPM scale mode 0=manual mode, 1=autoscale
bpm(1).ylim     = 0.5;               %BPM vertical axis scale
cor(1).fract    = 1.0;             %fraction of correctors
cor(1).id=1;                       %COR selection
cor(1).scalemode=0;                %COR scale mode 0=manual mode, 1=autoscale
cor(1).ylim     = 30;              %COR horizontal axis scale (amp)
rsp(1).disp     = 'off';           %mode for matrix column display
rsp(1).eig      = 'off';           %mode for eigenvector display
rsp(1).fit      = 0;               %valid fit flag
rsp(1).rfflag   = 1;               %rf fitting flag
rsp(1).rfcorflag= 1;               %fitting flag for rf component in correctors
rsp(1).savflag  = 0;               %save solution flag
rsp(1).nsvd     = 54;              %number of singular values
rsp(1).svdtol   = 0;               %svd tolerance (0 uses number of singular values)
rsp(1).nsvdmx   = 1;               %default maximum number of singular values
 
%Note: only fit and weight for fitting will be used in orbit program from this array
%      Name and index are loaded from middleware
etaxwt=0.0;
%     name       index  fit (0/1) weight etaweight
bpmx={
{    '1BPM1    '     1      1      1.000   etaxwt     }
{    '1BPM2    '     2      0      1.000   etaxwt     }
{    '1BPM3    '     3      0      1.000   etaxwt     }
{    '1BPM4    '     4      1      1.000   etaxwt     }
{    '1BPM5    '     5      0      1.000   etaxwt     }
{    '1BPM6    '     6      0      1.000   etaxwt     }
{    '1BPM7    '     7      1      1.000   etaxwt     }
{    '2BPM1    '     8      1      1.000   etaxwt     }
{    '2BPM2    '     9      0      1.000   etaxwt     }
{    '2BPM3    '     10     0      1.000   etaxwt     }
{    '2BPM4    '     11     1      1.000   etaxwt     }
{    '2BPM5    '     12     0      1.000   etaxwt     }
{    '2BPM6    '     13     1      1.000   etaxwt     }
{    '3BPM1    '     14     1      1.000   etaxwt     }
{    '3BPM2    '     15     0      1.000   etaxwt     }
{    '3BPM3    '     16     0      1.000   etaxwt     }
{    '3BPM4    '     17     1      1.000   etaxwt     }
{    '3BPM5    '     18     0      1.000   etaxwt     }
{    '3BPM6    '     19     1      1.000   etaxwt     }
{    '4BPM1    '     20     1      1.000   etaxwt     }
{    '4BPM2    '     21     0      1.000   etaxwt     }
{    '4BPM3    '     22     0      1.000   etaxwt     }
{    '4BPM4    '     23     1      1.000   etaxwt     }
{    '4BPM5    '     24     0      1.000   etaxwt     }
{    '4BPM6    '     25     1      1.000   etaxwt     }
{    '5BPM1    '     26     1      1.000   etaxwt     }
{    '5BPM2    '     27     0      1.000   etaxwt     }
{    '5BPM3    '     28     0      1.000   etaxwt     }
{    '5BPM4    '     29     1      1.000   etaxwt     }
{    '5BPM5    '     30     0      1.000   etaxwt     }
{    '5BPM6    '     31     1      1.000   etaxwt     }
{    '6BPM1    '     32     1      1.000   etaxwt     }
{    '6BPM2    '     33     0      1.000   etaxwt     }
{    '6BPM3    '     34     0      1.000   etaxwt     }
{    '6BPM4    '     35     1      1.000   etaxwt     }
{    '6BPM5    '     36     0      1.000   etaxwt     }
{    '6BPM6    '     37     1      1.000   etaxwt     }
{    '7BPM1    '     38     1      1.000   etaxwt     }
{    '7BPM2    '     39     0      1.000   etaxwt     }
{    '7BPM3    '     40     0      1.000   etaxwt     }
{    '7BPM4    '     41     1      1.000   etaxwt     }
{    '7BPM5    '     42     0      1.000   etaxwt     }
{    '7BPM6    '     43     1      1.000   etaxwt     }
{    '8BPM1    '     44     1      1.000   etaxwt     }
{    '8BPM2    '     45     0      1.000   etaxwt     }
{    '8BPM3    '     46     0      1.000   etaxwt     }
{    '8BPM4    '     47     1      1.000   etaxwt     }
{    '8BPM5    '     48     0      1.000   etaxwt     }
{    '8BPM6    '     49     1      1.000   etaxwt     }
{    '9BPM1    '     50     1      1.000   etaxwt     }
{    '9BPM2    '     51     0      1.000   etaxwt     }
{    '9BPM3    '     52     0      1.000   etaxwt     }
{    '9BPM4    '     53     1      1.000   etaxwt     }
{    '9BPM5    '     54     0      1.000   etaxwt     }
{    '9BPM6    '     55     0      1.000   etaxwt     }
{    '9BPM7    '     56     1      1.000   etaxwt     }
{    '10BPM1   '     57     1      1.000   etaxwt     }
{    '10BPM2   '     58     0      1.000   etaxwt     }
{    '10BPM3   '     59     0      1.000   etaxwt     }
{    '10BPM4   '     60     1      1.000   etaxwt     }
{    '10BPM5   '     61     0      1.000   etaxwt     }
{    '10BPM6   '     62     1      1.000   etaxwt     }
{    '10BPM7   '     63     1      1.000   etaxwt     }
{    '11BPM1   '     64     1      1.000   etaxwt     }
{    '11BPM2   '     65     0      1.000   etaxwt     }
{    '11BPM3   '     66     0      1.000   etaxwt     }
{    '11BPM4   '     67     1      1.000   etaxwt     }
{    '11BPM5   '     68     0      1.000   etaxwt     }
{    '11BPM6   '     69     1      1.000   etaxwt     }
{    '12BPM1   '     70     1      1.000   etaxwt     }
{    '12BPM2   '     71     0      1.000   etaxwt     }
{    '12BPM3   '     72     0      1.000   etaxwt     }
{    '12BPM4   '     73     0      1.000   etaxwt     }
{    '12BPM5   '     74     1      1.000   etaxwt     }
{    '12BPM6   '     75     1      1.000   etaxwt     }
{    '13BPM1   '     76     1      1.000   etaxwt     }
{    '13BPM2   '     77     0      1.000   etaxwt     }
{    '13BPM3   '     78     0      1.000   etaxwt     }
{    '13BPM4   '     79     1      1.000   etaxwt     }
{    '13BPM5   '     80     0      1.000   etaxwt     }
{    '13BPM6   '     81     1      1.000   etaxwt     }
{    '14BPM1   '     82     1      1.000   etaxwt     }
{    '14BPM2   '     83     0      1.000   etaxwt     }
{    '14BPM3   '     84     0      1.000   etaxwt     }
{    '14BPM4   '     85     1      1.000   etaxwt     }
{    '14BPM5   '     86     0      1.000   etaxwt     }
{    '14BPM6   '     87     1      1.000   etaxwt     }
{    '15BPM1   '     88     1      1.000   etaxwt     }
{    '15BPM2   '     89     0      1.000   etaxwt     }
{    '15BPM3   '     90     0      1.000   etaxwt     }
{    '15BPM4   '     91     1      1.000   etaxwt     }
{    '15BPM5   '     92     0      1.000   etaxwt     }
{    '15BPM6   '     93     1      1.000   etaxwt     }
{    '16BPM1   '     94     1      1.000   etaxwt     }
{    '16BPM2   '     95     0      1.000   etaxwt     }
{    '16BPM3   '     96     0      1.000   etaxwt     }
{    '16BPM4   '     97     1      1.000   etaxwt     }
{    '16BPM5   '     98     0      1.000   etaxwt     }
{    '16BPM6   '     99     1      1.000   etaxwt     }
{    '17BPM1   '     100    1      1.000   etaxwt     }
{    '17BPM2   '     101    0      1.000   etaxwt     }
{    '17BPM3   '     102    0      1.000   etaxwt     }
{    '17BPM4   '     103    1      1.000   etaxwt     }
{    '17BPM5   '     104    0      1.000   etaxwt     }
{    '17BPM6   '     105    1      1.000   etaxwt     }
{    '18BPM1   '     106    1      1.000   etaxwt     }
{    '18BPM2   '     107    0      1.000   etaxwt     }
{    '18BPM3   '     108    0      1.000   etaxwt     }
{    '18BPM4   '     109    1      1.000   etaxwt     }
{    '18BPM5   '     110    0      1.000   etaxwt     }
{    '18BPM6   '     111    0      1.000   etaxwt     }
{    '18BPM7   '     112    1      1.000   etaxwt     }
};
 
%Note: only fit, weight for fitting will be used in orbit program from this array
%      Name and index are loaded from middleware
% name    index fit (0/1)  weight
corx={
{'1CX1    '  1   1   1.0    }
{'1CX2    '  2   0   1.0    }
{'1CX3    '  3   1   1.0    }
{'1CX4    '  4   1   1.0    }
{'2CX1    '  5   1   1.0    }
{'2CX2    '  6   0   1.0    }
{'2CX3    '  7   1   1.0    }
{'2CX4    '  8   1   1.0    }
{'3CX1    '  9   1   1.0    }
{'3CX2    '  10  0   1.0    }
{'3CX3    '  11  1   1.0    }
{'3CX4    '  12  1   1.0    }
{'4CX1    '  13  1   1.0    }
{'4CX2    '  14  0   1.0    }
{'4CX3    '  15  1   1.0    }
{'4CX4    '  16  1   1.0    }
{'5CX1    '  17  1   1.0    }
{'5CX2    '  18  0   1.0    }
{'5CX3    '  19  1   1.0    }
{'5CX4    '  20  1   1.0    }
{'6CX1    '  21  1   1.0    }
{'6CX2    '  22  0   1.0    }
{'6CX3    '  23  1   1.0    }
{'6CX4    '  24  1   1.0    }
{'7CX1    '  25  1   1.0    }
{'7CX2    '  26  0   1.0    }
{'7CX3    '  27  1   1.0    }
{'7CX4    '  28  1   1.0    }
{'8CX1    '  29  1   1.0    }
{'8CX2    '  30  0   1.0    }
{'8CX3    '  31  1   1.0    }
{'8CX4    '  32  1   1.0    }
{'9CX1    '  33  1   1.0    }
{'9CX2    '  34  0   1.0    }
{'9CX3    '  35  1   1.0    }
{'9CX4    '  36  1   1.0    }
{'10CX1   '  37  1   1.0    }
{'10CX2   '  38  0   1.0    }
{'10CX3   '  39  1   1.0    }
{'10CX4   '  40  1   1.0    }
{'11CX1   '  41  1   1.0    }
{'11CX2   '  42  0   1.0    }
{'11CX3   '  43  1   1.0    }
{'11CX4   '  44  1   1.0    }
{'12CX1   '  45  1   1.0    }
{'12CX2   '  46  0   1.0    }
{'12CX3   '  47  1   1.0    }
{'12CX4   '  48  1   1.0    }
{'13CX1   '  49  1   1.0    }
{'13CX2   '  50  0   1.0    }
{'13CX3   '  51  1   1.0    }
{'13CX4   '  52  1   1.0    }
{'14CX1   '  53  1   1.0    }
{'14CX2   '  54  0   1.0    }
{'14CX3   '  55  1   1.0    }
{'14CX4   '  56  1   1.0    }
{'15CX1   '  57  1   1.0    }
{'15CX2   '  58  0   1.0    }
{'15CX3   '  59  1   1.0    }
{'15CX4   '  60  1   1.0    }
{'16CX1   '  61  1   1.0    }
{'16CX2   '  62  0   1.0    }
{'16CX3   '  63  1   1.0    }
{'16CX4   '  64  1   1.0    }
{'17CX1   '  65  1   1.0    }
{'17CX2   '  66  0   1.0    }
{'17CX3   '  67  1   1.0    }
{'17CX4   '  68  1   1.0    }
{'18CX1   '  69  1   1.0    }
{'18CX2   '  70  0   1.0    }
{'18CX3   '  71  1   1.0    }
{'18CX4   '  72  1   1.0    }
}; 
 
%*===   VERTICAL DATA ===*
bpm(2).dev=10;          %maximum orbit deviation
bpm(2).drf=0;           %dispersion component zero
bpm(2).id=1;            %BPM selection
bpm(2).scalemode=0;     %BPM scale mode 0=manual mode, 1=autoscale
bpm(2).ylim=0.25;        %BPM vertical axis scale
cor(2).fract=1.0;       %fraction of correctors
cor(2).id  =1;            %COR selection
cor(2).scalemode=0;     %COR scale mode 0=manual mode, 1=autoscale
cor(2).ylim =30;         %COR vertical axis scale (amp)
rsp(2).disp ='off';     %mode for matrix column display
rsp(2).eig  ='off';     %mode for eigenvector display
rsp(2).fit  =0;         %valid fit flag
rsp(2).rfflag=1;        %rf fitting flag
rsp(2).rfcorflag= 1;               %fitting flag for rf component in correctors
rsp(2).savflag=0;       %save solution flag
rsp(2).nsvd=54;         %number of singular values
rsp(2).svdtol=0;        %svd tolerance (0 uses number of singular values)
rsp(2).nsvdmx=1;        %default maximum number of singular values
 
etaywt=50;  %nominal response ~0.25 peak, 5kHz difference ~0.0025 peak (factor 100)
%     name       index  fit (0/1) weight   etaweight
bpmy={
{    '1BPM1    '     1      1      1.000     etaywt     }
{    '1BPM2    '     2      0      1.000     etaywt     }
{    '1BPM3    '     3      0      1.000     etaywt     }
{    '1BPM4    '     4      1      1.000     etaywt     }
{    '1BPM5    '     5      0      1.000     etaywt     }
{    '1BPM6    '     6      0      1.000     etaywt     }
{    '1BPM7    '     7      1      1.000     etaywt     }
{    '2BPM1    '     8      1      1.000     etaywt     }
{    '2BPM2    '     9      0      1.000     etaywt     }
{    '2BPM3    '     10     0      1.000     etaywt     }
{    '2BPM4    '     11     1      1.000     etaywt     }
{    '2BPM5    '     12     0      1.000     etaywt     }
{    '2BPM6    '     13     1      1.000     etaywt     }
{    '3BPM1    '     14     1      1.000     etaywt     }
{    '3BPM2    '     15     0      1.000     etaywt     }
{    '3BPM3    '     16     0      1.000     etaywt     }
{    '3BPM4    '     17     1      1.000     etaywt     }
{    '3BPM5    '     18     0      1.000     etaywt     }
{    '3BPM6    '     19     1      1.000     etaywt     }
{    '4BPM1    '     20     1      1.000     etaywt     }
{    '4BPM2    '     21     0      1.000     etaywt     }
{    '4BPM3    '     22     0      1.000     etaywt     }
{    '4BPM4    '     23     1      1.000     etaywt     }
{    '4BPM5    '     24     0      1.000     etaywt     }
{    '4BPM6    '     25     1      1.000     etaywt     }
{    '5BPM1    '     26     1      1.000     etaywt     }
{    '5BPM2    '     27     0      1.000     etaywt     }
{    '5BPM3    '     28     0      1.000     etaywt     }
{    '5BPM4    '     29     1      1.000     etaywt     }
{    '5BPM5    '     30     0      1.000     etaywt     }
{    '5BPM6    '     31     1      1.000     etaywt     }
{    '6BPM1    '     32     1      1.000     etaywt     }
{    '6BPM2    '     33     0      1.000     etaywt     }
{    '6BPM3    '     34     0      1.000     etaywt     }
{    '6BPM4    '     35     1      1.000     etaywt     }
{    '6BPM5    '     36     0      1.000     etaywt     }
{    '6BPM6    '     37     1      1.000     etaywt     }
{    '7BPM1    '     38     1      1.000     etaywt     }
{    '7BPM2    '     39     0      1.000     etaywt     }
{    '7BPM3    '     40     0      1.000     etaywt     }
{    '7BPM4    '     41     1      1.000     etaywt     }
{    '7BPM5    '     42     0      1.000     etaywt     }
{    '7BPM6    '     43     1      1.000     etaywt     }
{    '8BPM1    '     44     1      1.000     etaywt     }
{    '8BPM2    '     45     0      1.000     etaywt     }
{    '8BPM3    '     46     0      1.000     etaywt     }
{    '8BPM4    '     47     1      1.000     etaywt     }
{    '8BPM5    '     48     0      1.000     etaywt     }
{    '8BPM6    '     49     1      1.000     etaywt     }
{    '9BPM1    '     50     1      1.000     etaywt     }
{    '9BPM2    '     51     0      1.000     etaywt     }
{    '9BPM3    '     52     0      1.000     etaywt     }
{    '9BPM4    '     53     1      1.000     etaywt     }
{    '9BPM5    '     54     0      1.000     etaywt     }
{    '9BPM6    '     55     0      1.000     etaywt     }
{    '9BPM7    '     56     1      1.000     etaywt     }
{    '10BPM1   '     57     1      1.000     etaywt     }
{    '10BPM2   '     58     0      1.000     etaywt     }
{    '10BPM3   '     59     0      1.000     etaywt     }
{    '10BPM4   '     60     1      1.000     etaywt     }
{    '10BPM5   '     61     0      1.000     etaywt     }
{    '10BPM6   '     62     0      1.000     etaywt     }
{    '10BPM7   '     63     1      1.000     etaywt     }
{    '11BPM1   '     64     1      1.000     etaywt     }
{    '11BPM2   '     65     0      1.000     etaywt     }
{    '11BPM3   '     66     0      1.000     etaywt     }
{    '11BPM4   '     67     1      1.000     etaywt     }
{    '11BPM5   '     68     0      1.000     etaywt     }
{    '11BPM6   '     69     1      1.000     etaywt     }
{    '12BPM1   '     70     1      1.000     etaywt     }
{    '12BPM2   '     71     0      1.000     etaywt     }
{    '12BPM3   '     72     0      1.000     etaywt     }
{    '12BPM4   '     73     0      1.000     etaywt     }
{    '12BPM5   '     74     1      1.000     etaywt     }
{    '12BPM6   '     75     1      1.000     etaywt     }
{    '13BPM1   '     76     1      1.000     etaywt     }
{    '13BPM2   '     77     0      1.000     etaywt     }
{    '13BPM3   '     78     0      1.000     etaywt     }
{    '13BPM4   '     79     1      1.000     etaywt     }
{    '13BPM5   '     80     0      1.000     etaywt     }
{    '13BPM6   '     81     1      1.000     etaywt     }
{    '14BPM1   '     82     1      1.000     etaywt     }
{    '14BPM2   '     83     0      1.000     etaywt     }
{    '14BPM3   '     84     0      1.000     etaywt     }
{    '14BPM4   '     85     1      1.000     etaywt     }
{    '14BPM5   '     86     0      1.000     etaywt     }
{    '14BPM6   '     87     1      1.000     etaywt     }
{    '15BPM1   '     88     1      1.000     etaywt     }
{    '15BPM2   '     89     0      1.000     etaywt     }
{    '15BPM3   '     90     0      1.000     etaywt     }
{    '15BPM4   '     91     1      1.000     etaywt     }
{    '15BPM5   '     92     0      1.000     etaywt     }
{    '15BPM6   '     93     1      1.000     etaywt     }
{    '16BPM1   '     94     1      1.000     etaywt     }
{    '16BPM2   '     95     0      1.000     etaywt     }
{    '16BPM3   '     96     0      1.000     etaywt     }
{    '16BPM4   '     97     1      1.000     etaywt     }
{    '16BPM5   '     98     0      1.000     etaywt     }
{    '16BPM6   '     99     1      1.000     etaywt     }
{    '17BPM1   '     100    1      1.000     etaywt     }
{    '17BPM2   '     101    0      1.000     etaywt     }
{    '17BPM3   '     102    0      1.000     etaywt     }
{    '17BPM4   '     103    1      1.000     etaywt     }
{    '17BPM5   '     104    0      1.000     etaywt     }
{    '17BPM6   '     105    1      1.000     etaywt     }
{    '18BPM1   '     106    1      1.000     etaywt     }
{    '18BPM2   '     107    0      1.000     etaywt     }
{    '18BPM3   '     108    0      1.000     etaywt     }
{    '18BPM4   '     109    1      1.000     etaywt     }
{    '18BPM5   '     110    0      1.000     etaywt     }
{    '18BPM6   '     111    0      1.000     etaywt     }
{    '18BPM7   '     112    1      1.000     etaywt     }
};
 
% name    index fit (0/1)  weight
cory={
{'1CY1    '  1   1   1.0    }
{'1CY2    '  2   1   1.0    }
{'1CY3    '  3   0   1.0    }
{'1CY4    '  4   1   1.0    }
{'2CY1    '  5   1   1.0    }
{'2CY2    '  6   1   1.0    }
{'2CY3    '  7   0   1.0    }
{'2CY4    '  8   1   1.0    }
{'3CY1    '  9   1   1.0    }
{'3CY2    '  10  1   1.0    }
{'3CY3    '  11  0   1.0    }
{'3CY4    '  12  1   1.0    }
{'4CY1    '  13  1   1.0    }
{'4CY2    '  14  1   1.0    }
{'4CY3    '  15  0   1.0    }
{'4CY4    '  16  1   1.0    }
{'5CY1    '  17  1   1.0    }
{'5CY2    '  18  1   1.0    }
{'5CY3    '  19  0   1.0    }
{'5CY4    '  20  1   1.0    }
{'6CY1    '  21  1   1.0    }
{'6CY2    '  22  1   1.0    }
{'6CY3    '  23  0   1.0    }
{'6CY4    '  24  1   1.0    }
{'7CY1    '  25  1   1.0    }
{'7CY2    '  26  1   1.0    }
{'7CY3    '  27  0   1.0    }
{'7CY4    '  28  1   1.0    }
{'8CY1    '  29  1   1.0    }
{'8CY2    '  30  1   1.0    }
{'8CY3    '  31  0   1.0    }
{'8CY4    '  32  1   1.0    }
{'9CY1    '  33  1   1.0    }
{'9CY2    '  34  1   1.0    }
{'9CY3    '  35  0   1.0    }
{'9CY4    '  36  1   1.0    }
{'10CY1   '  37  1   1.0    }
{'10CY2   '  38  1   1.0    }
{'10CY3   '  39  0   1.0    }
{'10CY4   '  40  1   1.0    }
{'11CY1   '  41  1   1.0    }
{'11CY2   '  42  1   1.0    }
{'11CY3   '  43  0   1.0    }
{'11CY4   '  44  1   1.0    }
{'12CY1   '  45  1   1.0    }
{'12CY2   '  46  1   1.0    }
{'12CY3   '  47  0   1.0    }
{'12CY4   '  48  1   1.0    }
{'13CY1   '  49  1   1.0    }
{'13CY2   '  50  1   1.0    }
{'13CY3   '  51  0   1.0    }
{'13CY4   '  52  1   1.0    }
{'14CY1   '  53  1   1.0    }
{'14CY2   '  54  1   1.0    }
{'14CY3   '  55  0   1.0    }
{'14CY4   '  56  1   1.0    }
{'15CY1   '  57  1   1.0    }
{'15CY2   '  58  1   1.0    }
{'15CY3   '  59  0   1.0    }
{'15CY4   '  60  1   1.0    }
{'16CY1   '  61  1   1.0    }
{'16CY2   '  62  1   1.0    }
{'16CY3   '  63  0   1.0    }
{'16CY4   '  64  1   1.0    }
{'17CY1   '  65  1   1.0    }
{'17CY2   '  66  1   1.0    }
{'17CY3   '  67  0   1.0    }
{'17CY4   '  68  1   1.0    }
{'18CY1   '  69  1   1.0    }
{'18CY2   '  70  1   1.0    }
{'18CY3   '  71  0   1.0    }
{'18CY4   '  72  1   1.0    }
}; 
%Note: only fit and weight for fitting will be used in orbit program from this array
%      Name and index are loaded from middleware
%    name    index fit (0/1)  weight
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
 