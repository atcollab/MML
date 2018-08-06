%system parameter save file
%timestamp: 18-Jan-2002 08:08:08
%comment: Save System
ad=getad;
filetype         = 'RESTORE';      %check to see if correct file type
sys.machine      = 'TLS';          %machine for control
sys.mode         = 'SIMULATOR';       %online or simulator
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
sys.mxs          = 120;            %maximum ring circumference
sys.xlimax       = 120;            %abcissa plot limit
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
rsp(1).rfflag   = 0;               %rf fitting flag
rsp(1).rfcorflag= 0;               %fitting flag for rf component in correctors
rsp(1).savflag  = 0;               %save solution flag
rsp(1).nsvd     = 30;              %number of singular values
rsp(1).svdtol   =  0;               %svd tolerance (0 uses number of singular values)
rsp(1).nsvdmx   = 47;              %default maximum number of singular values
 
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
{    '1BPMx8    '     8      1      1.000   etaxwt     }
{    '1BPMx9    '     9      1      1.000   etaxwt     }
{    '1BPMx10   '     10     1      1.000   etaxwt     }
{    '2BPMx1    '     11     1      1.000   etaxwt     }
{    '2BPMx2    '     12     1      1.000   etaxwt     }
{    '2BPMx3    '     13     1      1.000   etaxwt     }
{    '2BPMx4    '     14     1      1.000   etaxwt     }
{    '2BPMx5    '     15     1      1.000   etaxwt     }
{    '2BPMx6    '     16     1      1.000   etaxwt     }
{    '2BPMx7    '     17     1      1.000   etaxwt     }
{    '2BPMx8    '     18     1      1.000   etaxwt     }
{    '2BPMx9    '     19     1      1.000   etaxwt     }
{    '2BPMx10   '     20     1      1.000   etaxwt     }
{    '3BPMx1    '     21     1      1.000   etaxwt     }
{    '3BPMx2    '     22     1      1.000   etaxwt     }
{    '3BPMx3    '     23     1      1.000   etaxwt     }
{    '3BPMx4    '     24     1      1.000   etaxwt     }
{    '3BPMx5    '     25     1      1.000   etaxwt     }
{    '3BPMx6    '     26     1      1.000   etaxwt     }
{    '3BPMx7    '     27     1      1.000   etaxwt     }
{    '3BPMx8    '     28     1      1.000   etaxwt     }
{    '3BPMx9    '     29     1      1.000   etaxwt     }
{    '3BPMx10   '     30     1      1.000   etaxwt     }
{    '3BPMx11   '     31     1      1.000   etaxwt     }
{    '4BPMx1    '     32     1      1.000   etaxwt     }
{    '4BPMx2    '     33     1      1.000   etaxwt     }
{    '4BPMx3    '     34     1      1.000   etaxwt     }
{    '4BPMx4    '     35     1      1.000   etaxwt     }
{    '4BPMx5    '     36     1      1.000   etaxwt     }
{    '4BPMx6    '     37     1      1.000   etaxwt     }
{    '4BPMx7    '     38     1      1.000   etaxwt     }
{    '4BPMx8    '     39     1      1.000   etaxwt     }
{    '4BPMx9    '     40     1      1.000   etaxwt     }
{    '4BPMx10   '     41     1      1.000   etaxwt     }
{    '5BPMx1    '     42     1      1.000   etaxwt     }
{    '5BPMx2    '     43     1      1.000   etaxwt     }
{    '5BPMx3    '     44     1      1.000   etaxwt     }
{    '5BPMx4    '     45     1      1.000   etaxwt     }
{    '5BPMx5    '     46     1      1.000   etaxwt     }
{    '5BPMx6    '     47     1      1.000   etaxwt     }
{    '5BPMx7    '     48     1      1.000   etaxwt     }
{    '5BPMx8    '     49     1      1.000   etaxwt     }
{    '5BPMx9    '     50     1      1.000   etaxwt     }
{    '5BPMx10   '     51     1      1.000   etaxwt     }
{    '6BPMx1    '     52     1      1.000   etaxwt     }
{    '6BPMx2    '     53     1      1.000   etaxwt     }
{    '6BPMx3    '     54     1      1.000   etaxwt     }
{    '6BPMx4    '     55     1      1.000   etaxwt     }
{    '6BPMx5    '     56     1      1.000   etaxwt     }
{    '6BPMx6    '     57     1      1.000   etaxwt     }
{    '6BPMx7    '     58     1      1.000   etaxwt     }
{    '6BPMx8    '     59     1      1.000   etaxwt     }
};
 
%Note: only fit, weight for fitting will be used in orbit program from this array
%      Name and index are loaded from middleware
% name    index fit (0/1)  weight
corx={
{'1HCM1   '  1   1   1.0    }
{'1HCM2   '  2   1   1.0    }
{'1HCM3   '  3   1   1.0    }
{'1HCM4   '  4   1   1.0    }
{'1HCM5   '  5   1   1.0    }
{'1HCM6   '  6   1   1.0    }
{'1HCM7   '  7   1   1.0    }
{'1HCM8   '  8   1   1.0    }
{'1HCM9   '  9   1   1.0    }
{'2HCM1   '  10  1   1.0    }
{'2HCM2   '  11  1   1.0    }
{'2HCM3   '  12  1   1.0    }
{'2HCM4   '  13  1   1.0    }
{'2HCM5   '  14  1   1.0    }
{'2HCM6   '  15  1   1.0    }
{'2HCM7   '  16  1   1.0    }
{'2HCM8   '  17  1   1.0    }
{'3HCM1   '  18  1   1.0    }
{'3HCM2   '  19  1   1.0    }
{'3HCM3   '  20  1   1.0    }
{'3HCM4   '  21  1   1.0    }
{'3HCM5   '  22  1   1.0    }
{'3HCM6   '  23  1   1.0    }
{'3HCM7   '  24  1   1.0    }
{'4HCM1   '  25  1   1.0    }
{'4HCM2   '  26  1   1.0    }
{'4HCM3   '  27  1   1.0    }
{'4HCM4   '  28  1   1.0    }
{'4HCM5   '  29  1   1.0    }
{'4HCM6   '  30  1   1.0    }
{'4HCM7   '  31  1   1.0    }
{'4HCM8   '  32  1   1.0    }
{'5HCM1   '  33  1   1.0    }
{'5HCM2   '  34  1   1.0    }
{'5HCM3   '  35  1   1.0    }
{'5HCM4   '  36  1   1.0    }
{'5HCM5   '  37  1   1.0    }
{'5HCM6   '  38  1   1.0    }
{'5HCM7   '  39  1   1.0    }
{'5HCM8   '  40  1   1.0    }
{'6HCM1   '  41  1   1.0    }
{'6HCM2   '  42  1   1.0    }
{'6HCM3   '  43  1   1.0    }
{'6HCM4   '  44  1   1.0    }
{'6HCM5   '  45  1   1.0    }
{'6HCM6   '  46  1   1.0    }
{'6HCM7   '  47  1   1.0    }
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
rsp(2).nsvd      = 30;     %number of singular values
rsp(2).svdtol    =  0;     %svd tolerance (0 uses number of singular values)
rsp(2).nsvdmx    = 47;     %default maximum number of singular values
 
etaywt=50;  %nominal response ~0.25 peak, 5kHz difference ~0.0025 peak (factor 100)
%     name       index  fit (0/1) weight   etaweight
bpmy={
{    '1BPMy1    '     1      1      1.000   etaxwt     }
{    '1BPMy2    '     2      1      1.000   etaxwt     }
{    '1BPMy3    '     3      1      1.000   etaxwt     }
{    '1BPMy4    '     4      1      1.000   etaxwt     }
{    '1BPMy5    '     5      1      1.000   etaxwt     }
{    '1BPMy6    '     6      1      1.000   etaxwt     }
{    '1BPMy7    '     7      1      1.000   etaxwt     }
{    '1BPMy8    '     8      1      1.000   etaxwt     }
{    '1BPMy9    '     9      1      1.000   etaxwt     }
{    '1BPMy10   '     10     1      1.000   etaxwt     }
{    '2BPMy1    '     11     1      1.000   etaxwt     }
{    '2BPMy2    '     12     1      1.000   etaxwt     }
{    '2BPMy3    '     13     1      1.000   etaxwt     }
{    '2BPMy4    '     14     1      1.000   etaxwt     }
{    '2BPMy5    '     15     1      1.000   etaxwt     }
{    '2BPMy6    '     16     1      1.000   etaxwt     }
{    '2BPMy7    '     17     1      1.000   etaxwt     }
{    '2BPMy8    '     18     1      1.000   etaxwt     }
{    '2BPMy9    '     19     1      1.000   etaxwt     }
{    '2BPMy10   '     20     1      1.000   etaxwt     }
{    '3BPMy1    '     21     1      1.000   etaxwt     }
{    '3BPMy2    '     22     1      1.000   etaxwt     }
{    '3BPMy3    '     23     1      1.000   etaxwt     }
{    '3BPMy4    '     24     1      1.000   etaxwt     }
{    '3BPMy5    '     25     1      1.000   etaxwt     }
{    '3BPMy6    '     26     1      1.000   etaxwt     }
{    '3BPMy7    '     27     1      1.000   etaxwt     }
{    '3BPMy8    '     28     1      1.000   etaxwt     }
{    '3BPMy9    '     29     1      1.000   etaxwt     }
{    '3BPMy10   '     30     1      1.000   etaxwt     }
{    '3BPMy11   '     31     1      1.000   etaxwt     }
{    '4BPMy1    '     32     1      1.000   etaxwt     }
{    '4BPMy2    '     33     1      1.000   etaxwt     }
{    '4BPMy3    '     34     1      1.000   etaxwt     }
{    '4BPMy4    '     35     1      1.000   etaxwt     }
{    '4BPMy5    '     36     1      1.000   etaxwt     }
{    '4BPMy6    '     37     1      1.000   etaxwt     }
{    '4BPMy7    '     38     1      1.000   etaxwt     }
{    '4BPMy8    '     39     1      1.000   etaxwt     }
{    '4BPMy9    '     40     1      1.000   etaxwt     }
{    '4BPMy10   '     41     1      1.000   etaxwt     }
{    '5BPMy1    '     42     1      1.000   etaxwt     }
{    '5BPMy2    '     43     1      1.000   etaxwt     }
{    '5BPMy3    '     44     1      1.000   etaxwt     }
{    '5BPMy4    '     45     1      1.000   etaxwt     }
{    '5BPMy5    '     46     1      1.000   etaxwt     }
{    '5BPMy6    '     47     1      1.000   etaxwt     }
{    '5BPMy7    '     48     1      1.000   etaxwt     }
{    '5BPMy8    '     49     1      1.000   etaxwt     }
{    '5BPMy9    '     50     1      1.000   etaxwt     }
{    '5BPMy10   '     51     1      1.000   etaxwt     }
{    '6BPMy1    '     52     1      1.000   etaxwt     }
{    '6BPMy2    '     53     1      1.000   etaxwt     }
{    '6BPMy3    '     54     1      1.000   etaxwt     }
{    '6BPMy4    '     55     1      1.000   etaxwt     }
{    '6BPMy5    '     56     1      1.000   etaxwt     }
{    '6BPMy6    '     57     1      1.000   etaxwt     }
{    '6BPMy7    '     58     1      1.000   etaxwt     }
{    '6BPMy8    '     59     1      1.000   etaxwt     }
}; 
% name    index fit (0/1)  weight
cory={
{'1VCM1   '  1   1   1.0    }
{'1VCM2   '  2   1   1.0    }
{'1VCM3   '  3   1   1.0    }
{'1VCM4   '  4   1   1.0    }
{'1VCM5   '  5   1   1.0    }
{'1VCM6   '  6   1   1.0    }
{'1VCM7   '  7   1   1.0    }
{'1VCM8   '  8   1   1.0    }
{'1VCM9   '  9   1   1.0    }
{'2VCM1   '  10  1   1.0    }
{'2VCM2   '  11  1   1.0    }
{'2VCM3   '  12  1   1.0    }
{'2VCM4   '  13  1   1.0    }
{'2VCM5   '  14  1   1.0    }
{'2VCM6   '  15  1   1.0    }
{'2VCM7   '  16  1   1.0    }
{'2VCM8   '  17  1   1.0    }
{'3VCM1   '  18  1   1.0    }
{'3VCM2   '  19  1   1.0    }
{'3VCM3   '  20  1   1.0    }
{'3VCM4   '  21  1   1.0    }
{'3VCM5   '  22  1   1.0    }
{'3VCM6   '  23  1   1.0    }
{'3VCM7   '  24  1   1.0    }
{'4VCM1   '  25  1   1.0    }
{'4VCM2   '  26  1   1.0    }
{'4VCM3   '  27  1   1.0    }
{'4VCM4   '  28  1   1.0    }
{'4VCM5   '  29  1   1.0    }
{'4VCM6   '  30  1   1.0    }
{'4VCM7   '  31  1   1.0    }
{'4VCM8   '  32  1   1.0    }
{'5VCM1   '  33  1   1.0    }
{'5VCM2   '  34  1   1.0    }
{'5VCM3   '  35  1   1.0    }
{'5VCM4   '  36  1   1.0    }
{'5VCM5   '  37  1   1.0    }
{'5VCM6   '  38  1   1.0    }
{'5VCM7   '  39  1   1.0    }
{'5VCM8   '  40  1   1.0    }
{'6VCM1   '  41  1   1.0    }
{'6VCM2   '  42  1   1.0    }
{'6VCM3   '  43  1   1.0    }
{'6VCM4   '  44  1   1.0    }
{'6VCM5   '  45  1   1.0    }
{'6VCM6   '  46  1   1.0    }
{'6VCM7   '  47  1   1.0    }
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
 