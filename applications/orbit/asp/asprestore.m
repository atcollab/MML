%system parameter save file
%timestamp: 18-Jan-2002 08:08:08
%comment: Save System
ad=getad;
filetype         = 'RESTORE';      %check to see if correct file type
sys.machine      = 'ASP';          %machine for control
sys.mode         = 'ONLINE';       %online or simulator
sys.datamode     = 'REAL';         %raw or real (for real: (1)response matrix multiplied by bpm gains, (2) BPM reads have gain, offset
sys.bpmode       = 'Liberia';      %BPM system mode
sys.bpmslp       = 3.0;            %BPM sleep time in sec
sys.plane        = 1;              %plane (1=horizontal 2=vertical)
sys.algo         = 'SVD';          %fitting algorithm
sys.pbpm         = 0;              %use of photon BPMs
sys.filpath      = ad.Directory.Orbit;       %file path in MATLAB
sys.respfiledir  = ad.Directory.OpsData;                                           %response matrix directory
sys.respfilename = ad.OpsData.BPMRespFile; 
sys.dispfiledir  = ad.Directory.OpsData;                                           %dispersion directory
sys.dispfilename = ad.OpsData.DispFile;                                            %dispersion file
sys.mxs          = 216;            %maximum ring circumference
sys.xlimax       = 216;            %abcissa plot limit
sys.mxphi(1)     = 14;             %maximum horizontal phase advance
sys.mxphi(2)     = 6;              %maximum vertical phase advance
sys.xscale       = 'meter';        %abcissa plotting mode (meter or phase)
 
%*=== HORIZONTAL DATA ===*
bpm(1).dev      = 10;              %maximum orbit deviation
bpm(1).drf      = 0;               %dispersion component zero
bpm(1).id       = 1;               %BPM selection
bpm(1).scalemode= 1;               %BPM scale mode 0=manual mode, 1=autoscale
bpm(1).ylim     = 0.5;             %BPM vertical axis scale
cor(1).fract    = 1.0;             %fraction of correctors
cor(1).id       = 1;               %COR selection
cor(1).scalemode= 1;               %COR scale mode 0=manual mode, 1=autoscale
cor(1).ylim     = 30;              %COR horizontal axis scale (amp)
rsp(1).disp     = 'off';           %mode for matrix column display
rsp(1).eig      = 'off';           %mode for eigenvector display
rsp(1).fit      = 0;               %valid fit flag
rsp(1).rfflag   = 1;               %rf fitting flag
rsp(1).rfcorflag= 1;               %fitting flag for rf component in correctors
rsp(1).savflag  = 0;               %save solution flag
rsp(1).nsvd     = 42;              %number of singular values
rsp(1).svdtol   =  0;               %svd tolerance (0 uses number of singular values)
rsp(1).nsvdmx   = 30;              %default maximum number of singular values
 
%Note: only fit and weight for fitting will be used in orbit program from this array
%      Name and index are loaded from middleware
etaxwt=0.0;
%     name       index  fit (0/1) weight etaweight
bpmx={
{    '1BPMx1    '     1      1      1.000   etaxwt     }
{    '1BPMx2    '     2      1      1.000   etaxwt     }
{    '1BPMx3    '     3      1      1.000   etaxwt     }
{    '1BPMx4    '     4      1      1.000   etaxwt     }
{    '1BPMx5    '     5      1      1.000   etaxwt     }
{    '1BPMx6    '     6      1      1.000   etaxwt     }
{    '1BPMx7    '     7      1      1.000   etaxwt     }
{    '2BPMx1    '     8      1      1.000   etaxwt     }
{    '2BPMx2    '     9      1      1.000   etaxwt     }
{    '2BPMx3    '     10     1      1.000   etaxwt     }
{    '2BPMx4    '     11     1      1.000   etaxwt     }
{    '2BPMx5    '     12     1      1.000   etaxwt     }
{    '2BPMx6    '     13     1      1.000   etaxwt     }
{    '2BPMx7    '     14     1      1.000   etaxwt     }
{    '3BPMx1    '     15     1      1.000   etaxwt     }
{    '3BPMx2    '     16     1      1.000   etaxwt     }
{    '3BPMx3    '     17     1      1.000   etaxwt     }
{    '3BPMx4    '     18     1      1.000   etaxwt     }
{    '3BPMx5    '     19     1      1.000   etaxwt     }
{    '3BPMx6    '     20     1      1.000   etaxwt     }
{    '3BPMx7    '     21     1      1.000   etaxwt     }
{    '4BPMx1    '     22     1      1.000   etaxwt     }
{    '4BPMx2    '     23     1      1.000   etaxwt     }
{    '4BPMx3    '     24     1      1.000   etaxwt     }
{    '4BPMx4    '     25     1      1.000   etaxwt     }
{    '4BPMx5    '     26     1      1.000   etaxwt     }
{    '4BPMx6    '     27     1      1.000   etaxwt     }
{    '4BPMx7    '     28     1      1.000   etaxwt     }
{    '5BPMx1    '     29     1      1.000   etaxwt     }
{    '5BPMx2    '     30     1      1.000   etaxwt     }
{    '5BPMx3    '     31     1      1.000   etaxwt     }
{    '5BPMx4    '     32     1      1.000   etaxwt     }
{    '5BPMx5    '     33     1      1.000   etaxwt     }
{    '5BPMx6    '     34     1      1.000   etaxwt     }
{    '5BPMx7    '     35     1      1.000   etaxwt     }
{    '6BPMx1    '     36     1      1.000   etaxwt     }
{    '6BPMx2    '     37     1      1.000   etaxwt     }
{    '6BPMx3    '     38     1      1.000   etaxwt     }
{    '6BPMx4    '     39     1      1.000   etaxwt     }
{    '6BPMx5    '     40     1      1.000   etaxwt     }
{    '6BPMx6    '     41     1      1.000   etaxwt     }
{    '6BPMx7    '     42     1      1.000   etaxwt     }
{    '7BPMx1    '     43     1      1.000   etaxwt     }
{    '7BPMx2    '     44     1      1.000   etaxwt     }
{    '7BPMx3    '     45     1      1.000   etaxwt     }
{    '7BPMx4    '     46     1      1.000   etaxwt     }
{    '7BPMx5    '     47     1      1.000   etaxwt     }
{    '7BPMx6    '     48     1      1.000   etaxwt     }
{    '7BPMx7    '     49     1      1.000   etaxwt     }
{    '8BPMx1    '     50     1      1.000   etaxwt     }
{    '8BPMx2    '     51     1      1.000   etaxwt     }
{    '8BPMx3    '     52     1      1.000   etaxwt     }
{    '8BPMx4    '     53     1      1.000   etaxwt     }
{    '8BPMx5    '     54     1      1.000   etaxwt     }
{    '8BPMx6    '     55     1      1.000   etaxwt     }
{    '8BPMx7    '     56     1      1.000   etaxwt     }
{    '9BPMx1    '     57     1      1.000   etaxwt     }
{    '9BPMx2    '     58     1      1.000   etaxwt     }
{    '9BPMx3    '     59     1      1.000   etaxwt     }
{    '9BPMx4    '     60     1      1.000   etaxwt     }
{    '9BPMx5    '     61     1      1.000   etaxwt     }
{    '9BPMx6    '     62     1      1.000   etaxwt     }
{    '9BPMx7    '     63     1      1.000   etaxwt     }
{    '10BPMx1   '     64     1      1.000   etaxwt     }
{    '10BPMx2   '     65     1      1.000   etaxwt     }
{    '10BPMx3   '     66     1      1.000   etaxwt     }
{    '10BPMx4   '     67     1      1.000   etaxwt     }
{    '10BPMx5   '     68     1      1.000   etaxwt     }
{    '10BPMx6   '     69     1      1.000   etaxwt     }
{    '10BPMx7   '     70     1      1.000   etaxwt     }
{    '11BPMx1   '     71     1      1.000   etaxwt     }
{    '11BPMx2   '     72     1      1.000   etaxwt     }
{    '11BPMx3   '     73     1      1.000   etaxwt     }
{    '11BPMx4   '     74     1      1.000   etaxwt     }
{    '11BPMx5   '     75     1      1.000   etaxwt     }
{    '11BPMx6   '     76     1      1.000   etaxwt     }
{    '11BPMx7   '     77     1      1.000   etaxwt     }
{    '12BPMx1   '     78     1      1.000   etaxwt     }
{    '12BPMx2   '     79     1      1.000   etaxwt     }
{    '12BPMx3   '     80     1      1.000   etaxwt     }
{    '12BPMx4   '     81     1      1.000   etaxwt     }
{    '12BPMx5   '     82     1      1.000   etaxwt     }
{    '12BPMx6   '     83     1      1.000   etaxwt     }
{    '12BPMx7   '     84     1      1.000   etaxwt     }
{    '13BPMx1   '     85     1      1.000   etaxwt     }
{    '13BPMx2   '     86     1      1.000   etaxwt     }
{    '13BPMx3   '     87     1      1.000   etaxwt     }
{    '13BPMx4   '     88     1      1.000   etaxwt     }
{    '13BPMx5   '     89     1      1.000   etaxwt     }
{    '13BPMx6   '     90     1      1.000   etaxwt     }
{    '13BPMx7   '     91     1      1.000   etaxwt     }
{    '14BPMx1   '     92     1      1.000   etaxwt     }
{    '14BPMx2   '     93     1      1.000   etaxwt     }
{    '14BPMx3   '     94     1      1.000   etaxwt     }
{    '14BPMx4   '     95     1      1.000   etaxwt     }
{    '14BPMx5   '     96     1      1.000   etaxwt     }
{    '14BPMx6   '     97     1      1.000   etaxwt     }
{    '14BPMx7   '     98     1      1.000   etaxwt     }
};
 
%Note: only fit, weight for fitting will be used in orbit program from this array
%      Name and index are loaded from middleware
% name    index fit (0/1)  weight
corx={
{'1HCM1    '  1   1   1.0    }
{'1HCM2    '  2   1   1.0    }
{'1HCM3    '  3   1   1.0    }
{'2HCM1    '  4   1   1.0    }
{'2HCM2    '  5   1   1.0    }
{'2HCM3    '  6   1   1.0    }
{'3HCM1    '  7   1   1.0    }
{'3HCM2    '  8   1   1.0    }
{'3HCM3    '  9   1   1.0    }
{'4HCM1    '  10  1   1.0    }
{'4HCM2    '  11  1   1.0    }
{'4HCM3    '  12  1   1.0    }
{'5HCM1    '  13  1   1.0    }
{'5HCM2    '  14  1   1.0    }
{'5HCM3    '  15  1   1.0    }
{'6HCM1    '  16  1   1.0    }
{'6HCM2    '  17  1   1.0    }
{'6HCM3    '  18  1   1.0    }
{'7HCM1    '  19  1   1.0    }
{'7HCM2    '  20  1   1.0    }
{'7HCM3    '  21  1   1.0    }
{'8HCM1    '  22  1   1.0    }
{'8HCM2    '  23  1   1.0    }
{'8HCM3    '  24  1   1.0    }
{'9HCM1    '  25  1   1.0    }
{'9HCM2    '  26  1   1.0    }
{'9HCM3    '  27  1   1.0    }
{'10HCM1   '  28  1   1.0    }
{'10HCM2   '  29  1   1.0    }
{'10HCM3   '  30  1   1.0    }
{'11HCM1   '  31  1   1.0    }
{'11HCM2   '  32  1   1.0    }
{'11HCM3   '  33  1   1.0    }
{'12HCM1   '  34  1   1.0    }
{'12HCM2   '  35  1   1.0    }
{'12HCM3   '  36  1   1.0    }
{'13HCM1   '  37  1   1.0    }
{'13HCM2   '  38  1   1.0    }
{'13HCM3   '  39  1   1.0    }
{'14HCM1   '  40  1   1.0    }
{'14HCM2   '  41  1   1.0    }
{'14HCM3   '  42  1   1.0    }
}; 
 
%*===   VERTICAL DATA ===*
bpm(2).dev       = 10;     %maximum orbit deviation
bpm(2).drf       =  0;     %dispersion component zero
bpm(2).id        =  1;     %BPMx selection
bpm(2).scalemode =  1;     %BPMx scale mode 0=manual mode, 1=autoscale
bpm(2).ylim      =  0.25;  %BPMx vertical axis scale
cor(2).fract     =  1.0;   %fraction of correctors
cor(2).id        =  1;     %COR selection
cor(2).scalemode =  1;     %COR scale mode 0=manual mode, 1=autoscale
cor(2).ylim      = 30;     %COR vertical axis scale (amp)
rsp(2).disp      = 'off';  %mode for matrix column display
rsp(2).eig       = 'off';  %mode for eigenvector display
rsp(2).fit       =  0;     %valid fit flag
rsp(2).rfflag    =  0;     %rf fitting flag
rsp(2).rfcorflag =  0;     %fitting flag for rf component in correctors
rsp(2).savflag   =  0;     %save solution flag
rsp(2).nsvd      = 56;     %number of singular values
rsp(2).svdtol    =  0;     %svd tolerance (0 uses number of singular values)
rsp(2).nsvdmx    = 40;     %default maximum number of singular values
 
etaywt=50;  %nominal response ~0.25 peak, 5kHz difference ~0.0025 peak (factor 100)
%     name       index  fit (0/1) weight   etaweight
bpmy={
{    '1BPMy1    '     1      1      1.000   etaywt     }
{    '1BPMy2    '     2      1      1.000   etaywt     }
{    '1BPMy3    '     3      1      1.000   etaywt     }
{    '1BPMy4    '     4      1      1.000   etaywt     }
{    '1BPMy5    '     5      1      1.000   etaywt     }
{    '1BPMy6    '     6      1      1.000   etaywt     }
{    '1BPMy7    '     7      1      1.000   etaywt     }
{    '2BPMy1    '     8      1      1.000   etaywt     }
{    '2BPMy2    '     9      1      1.000   etaywt     }
{    '2BPMy3    '     10     1      1.000   etaywt     }
{    '2BPMy4    '     11     1      1.000   etaywt     }
{    '2BPMy5    '     12     1      1.000   etaywt     }
{    '2BPMy6    '     13     1      1.000   etaywt     }
{    '2BPMy7    '     14     1      1.000   etaywt     }
{    '3BPMy1    '     15     1      1.000   etaywt     }
{    '3BPMy2    '     16     1      1.000   etaywt     }
{    '3BPMy3    '     17     1      1.000   etaywt     }
{    '3BPMy4    '     18     1      1.000   etaywt     }
{    '3BPMy5    '     19     1      1.000   etaywt     }
{    '3BPMy6    '     20     1      1.000   etaywt     }
{    '3BPMy7    '     21     1      1.000   etaywt     }
{    '4BPMy1    '     22     1      1.000   etaywt     }
{    '4BPMy2    '     23     1      1.000   etaywt     }
{    '4BPMy3    '     24     1      1.000   etaywt     }
{    '4BPMy4    '     25     1      1.000   etaywt     }
{    '4BPMy5    '     26     1      1.000   etaywt     }
{    '4BPMy6    '     27     1      1.000   etaywt     }
{    '4BPMy7    '     28     1      1.000   etaywt     }
{    '5BPMy1    '     29     1      1.000   etaywt     }
{    '5BPMy2    '     30     1      1.000   etaywt     }
{    '5BPMy3    '     31     1      1.000   etaywt     }
{    '5BPMy4    '     32     1      1.000   etaywt     }
{    '5BPMy5    '     33     1      1.000   etaywt     }
{    '5BPMy6    '     34     1      1.000   etaywt     }
{    '5BPMy7    '     35     1      1.000   etaywt     }
{    '6BPMy1    '     36     1      1.000   etaywt     }
{    '6BPMy2    '     37     1      1.000   etaywt     }
{    '6BPMy3    '     38     1      1.000   etaywt     }
{    '6BPMy4    '     39     1      1.000   etaywt     }
{    '6BPMy5    '     40     1      1.000   etaywt     }
{    '6BPMy6    '     41     1      1.000   etaywt     }
{    '6BPMy7    '     42     1      1.000   etaywt     }
{    '7BPMy1    '     43     1      1.000   etaywt     }
{    '7BPMy2    '     44     1      1.000   etaywt     }
{    '7BPMy3    '     45     1      1.000   etaywt     }
{    '7BPMy4    '     46     1      1.000   etaywt     }
{    '7BPMy5    '     47     1      1.000   etaywt     }
{    '7BPMy6    '     48     1      1.000   etaywt     }
{    '7BPMy7    '     49     1      1.000   etaywt     }
{    '8BPMy1    '     50     1      1.000   etaywt     }
{    '8BPMy2    '     51     1      1.000   etaywt     }
{    '8BPMy3    '     52     1      1.000   etaywt     }
{    '8BPMy4    '     53     1      1.000   etaywt     }
{    '8BPMy5    '     54     1      1.000   etaywt     }
{    '8BPMy6    '     55     1      1.000   etaywt     }
{    '8BPMy7    '     56     1      1.000   etaywt     }
{    '9BPMy1    '     57     1      1.000   etaywt     }
{    '9BPMy2    '     58     1      1.000   etaywt     }
{    '9BPMy3    '     59     1      1.000   etaywt     }
{    '9BPMy4    '     60     1      1.000   etaywt     }
{    '9BPMy5    '     61     1      1.000   etaywt     }
{    '9BPMy6    '     62     1      1.000   etaywt     }
{    '9BPMy7    '     63     1      1.000   etaywt     }
{    '10BPMy1   '     64     1      1.000   etaywt     }
{    '10BPMy2   '     65     1      1.000   etaywt     }
{    '10BPMy3   '     66     1      1.000   etaywt     }
{    '10BPMy4   '     67     1      1.000   etaywt     }
{    '10BPMy5   '     68     1      1.000   etaywt     }
{    '10BPMy6   '     69     1      1.000   etaywt     }
{    '10BPMy7   '     70     1      1.000   etaywt     }
{    '11BPMy1   '     71     1      1.000   etaywt     }
{    '11BPMy2   '     72     1      1.000   etaywt     }
{    '11BPMy3   '     73     1      1.000   etaywt     }
{    '11BPMy4   '     74     1      1.000   etaywt     }
{    '11BPMy5   '     75     1      1.000   etaywt     }
{    '11BPMy6   '     76     1      1.000   etaywt     }
{    '11BPMy7   '     77     1      1.000   etaywt     }
{    '12BPMy1   '     78     1      1.000   etaywt     }
{    '12BPMy2   '     79     1      1.000   etaywt     }
{    '12BPMy3   '     80     1      1.000   etaywt     }
{    '12BPMy4   '     81     1      1.000   etaywt     }
{    '12BPMy5   '     82     1      1.000   etaywt     }
{    '12BPMy6   '     83     1      1.000   etaywt     }
{    '12BPMy7   '     84     1      1.000   etaywt     }
{    '13BPMy1   '     85     1      1.000   etaywt     }
{    '13BPMy2   '     86     1      1.000   etaywt     }
{    '13BPMy3   '     87     1      1.000   etaywt     }
{    '13BPMy4   '     88     1      1.000   etaywt     }
{    '13BPMy5   '     89     1      1.000   etaywt     }
{    '13BPMy6   '     90     1      1.000   etaywt     }
{    '13BPMy7   '     91     1      1.000   etaywt     }
{    '14BPMy1   '     92     1      1.000   etaywt     }
{    '14BPMy2   '     93     1      1.000   etaywt     }
{    '14BPMy3   '     94     1      1.000   etaywt     }
{    '14BPMy4   '     95     1      1.000   etaywt     }
{    '14BPMy5   '     96     1      1.000   etaywt     }
{    '14BPMy6   '     97     1      1.000   etaywt     }
{    '14BPMy7   '     98     1      1.000   etaywt     }
};
 
% name    index fit (0/1)  weight
cory={
{'1VCM1    '  1   1   1.0    }
{'1VCM2    '  2   1   1.0    }
{'1VCM3    '  3   1   1.0    }
{'1VCM4    '  4   1   1.0    }
{'2VCM1    '  5   1   1.0    }
{'2VCM2    '  6   1   1.0    }
{'2VCM3    '  7   1   1.0    }
{'2VCM4    '  8   1   1.0    }
{'3VCM1    '  9   1   1.0    }
{'3VCM2    '  10  1   1.0    }
{'3VCM3    '  11  1   1.0    }
{'3VCM4    '  12  1   1.0    }
{'4VCM1    '  13  1   1.0    }
{'4VCM2    '  14  1   1.0    }
{'4VCM3    '  15  1   1.0    }
{'4VCM4    '  16  1   1.0    }
{'5VCM1    '  17  1   1.0    }
{'5VCM2    '  18  1   1.0    }
{'5VCM3    '  19  1   1.0    }
{'5VCM4    '  20  1   1.0    }
{'6VCM1    '  21  1   1.0    }
{'6VCM2    '  22  1   1.0    }
{'6VCM3    '  23  1   1.0    }
{'6VCM4    '  24  1   1.0    }
{'7VCM1    '  25  1   1.0    }
{'7VCM2    '  26  1   1.0    }
{'7VCM3    '  27  1   1.0    }
{'7VCM4    '  28  1   1.0    }
{'8VCM1    '  29  1   1.0    }
{'8VCM2    '  30  1   1.0    }
{'8VCM3    '  31  1   1.0    }
{'8VCM4    '  32  1   1.0    }
{'9VCM1    '  33  1   1.0    }
{'9VCM2    '  34  1   1.0    }
{'9VCM3    '  35  1   1.0    }
{'9VCM4    '  36  1   1.0    }
{'10VCM1   '  37  1   1.0    }
{'10VCM2   '  38  1   1.0    }
{'10VCM3   '  39  1   1.0    }
{'10VCM4   '  40  1   1.0    }
{'11VCM1   '  41  1   1.0    }
{'11VCM2   '  42  1   1.0    }
{'11VCM3   '  43  1   1.0    }
{'11VCM4   '  44  1   1.0    }
{'12VCM1   '  45  1   1.0    }
{'12VCM2   '  46  1   1.0    }
{'12VCM3   '  47  1   1.0    }
{'12VCM4   '  48  1   1.0    }
{'13VCM1   '  49  1   1.0    }
{'13VCM2   '  50  1   1.0    }
{'13VCM3   '  51  1   1.0    }
{'13VCM4   '  52  1   1.0    }
{'14VCM1   '  53  1   1.0    }
{'14VCM2   '  54  1   1.0    }
{'14VCM3   '  55  1   1.0    }
{'14VCM4   '  56  1   1.0    }
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
 