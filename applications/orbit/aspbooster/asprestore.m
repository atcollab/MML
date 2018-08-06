%system parameter save file
%timestamp: 18-Jan-2002 08:08:08
%comment: Save System
ad=getad;
filetype         = 'RESTORE';      %check to see if correct file type
sys.machine      = 'ASPBooster';       %machine for control
sys.mode         = 'ONLINE';       %online or simulator
sys.datamode     = 'REAL';         %raw or real (for real: (1)response matrix multiplied by bpm gains, (2) BPM reads have gain, offset
sys.bpmode       = 'Bergoz';       %BPM system mode
sys.bpmslp       = 3.0;            %BPM sleep time in sec
sys.plane        = 1;              %plane (1=horizontal 2=vertical)
sys.algo         = 'SVD';          %fitting algorithm
sys.pbpm         = 1;              %use of photon BPMs
sys.filpath      = ad.Directory.Orbit;       %file path in MATLAB
sys.respfiledir  = ad.Directory.OpsData;                                           %response matrix directory
sys.respfilename = ad.OpsData.BPMRespFile; 
sys.dispfiledir  = ad.Directory.OpsData;                                           %dispersion directory
sys.dispfilename = ad.OpsData.DispFile;                                            %dispersion file
sys.mxs          = 130.2;            %maximum ring circumference
sys.xlimax       = 130.2;            %abcissa plot limit
sys.mxphi(1)     = 10;              %maximum horizontal phase advance
sys.mxphi(2)     = 4;              %maximum vertical phase advance
sys.xscale       = 'meter';        %abcissa plotting mode (meter or phase)
 
%*=== HORIZONTAL DATA ===*
bpm(1).dev      = 10;              %maximum orbit deviation
bpm(1).drf      = 0;               %dispersion component zero
bpm(1).id       = 1;               %BPM selection
bpm(1).scalemode= 0;               %BPM scale mode 0=manual mode, 1=autoscale
bpm(1).ylim     = 0.5;             %BPM vertical axis scale
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
{    '1BPMx1    '     1      1      1.000   etaxwt     }
{    '1BPMx2    '     2      1      1.000   etaxwt     }
{    '1BPMx3    '     3      1      1.000   etaxwt     }
{    '1BPMx4    '     4      1      1.000   etaxwt     }
{    '1BPMx5    '     5      1      1.000   etaxwt     }
{    '1BPMx6    '     6      1      1.000   etaxwt     }
{    '1BPMx7    '     7      1      1.000   etaxwt     }
{    '1BPMx8    '     8      1      1.000   etaxwt     }
{    '2BPMx1    '     9      1      1.000   etaxwt     }
{    '2BPMx2    '     10     1      1.000   etaxwt     }
{    '2BPMx3    '     11     1      1.000   etaxwt     }
{    '2BPMx4    '     12     1      1.000   etaxwt     }
{    '2BPMx5    '     13     1      1.000   etaxwt     }
{    '2BPMx6    '     14     1      1.000   etaxwt     }
{    '2BPMx7    '     15     1      1.000   etaxwt     }
{    '2BPMx8    '     16     1      1.000   etaxwt     }
{    '3BPMx1    '     17     1      1.000   etaxwt     }
{    '3BPMx2    '     18     1      1.000   etaxwt     }
{    '3BPMx3    '     19     1      1.000   etaxwt     }
{    '3BPMx4    '     20     1      1.000   etaxwt     }
{    '3BPMx5    '     21     1      1.000   etaxwt     }
{    '3BPMx6    '     22     1      1.000   etaxwt     }
{    '3BPMx7    '     23     1      1.000   etaxwt     }
{    '3BPMx8    '     24     1      1.000   etaxwt     }
{    '4BPMx1    '     25     1      1.000   etaxwt     }
{    '4BPMx2    '     26     1      1.000   etaxwt     }
{    '4BPMx3    '     27     1      1.000   etaxwt     }
{    '4BPMx4    '     28     1      1.000   etaxwt     }
{    '4BPMx5    '     29     1      1.000   etaxwt     }
{    '4BPMx6    '     30     1      1.000   etaxwt     }
{    '4BPMx7    '     31     1      1.000   etaxwt     }
{    '4BPMx8    '     32     1      1.000   etaxwt     }
};
 
%Note: only fit, weight for fitting will be used in orbit program from this array
%      Name and index are loaded from middleware
% name    index fit (0/1)  weight
corx={
{'1HCM1    '  1   1   1.0    }
{'1HCM2    '  2   1   1.0    }
{'1HCM3    '  3   1   1.0    }
{'1HCM4    '  4   1   1.0    }
{'1HCM5    '  5   1   1.0    }
{'1HCM6    '  6   1   1.0    }
{'2HCM1    '  7   1   1.0    }
{'2HCM2    '  8   1   1.0    }
{'2HCM3    '  9   1   1.0    }
{'2HCM4    '  10  1   1.0    }
{'2HCM5    '  11  1   1.0    }
{'2HCM6    '  12  1   1.0    }
{'3HCM1    '  13  1   1.0    }
{'3HCM2    '  14  1   1.0    }
{'3HCM3    '  15  1   1.0    }
{'3HCM4    '  16  1   1.0    }
{'3HCM5    '  17  1   1.0    }
{'3HCM6    '  18  1   1.0    }
{'4HCM1    '  19  1   1.0    }
{'4HCM2    '  20  1   1.0    }
{'4HCM3    '  21  1   1.0    }
{'4HCM4    '  22  1   1.0    }
{'4HCM5    '  23  1   1.0    }
{'4HCM6    '  24  1   1.0    }
};
 
%*===   VERTICAL DATA ===*
BPMx(2).dev=10;          %maximum orbit deviation
BPMx(2).drf=0;           %dispersion component zero
BPMx(2).id=1;            %BPMx selection
BPMx(2).scalemode=0;     %BPMx scale mode 0=manual mode, 1=autoscale
BPMx(2).ylim=0.25;       %BPMx vertical axis scale
cor(2).fract=1.0;       %fraction of correctors
cor(2).id  =1;            %COR selection
cor(2).scalemode=0;     %COR scale mode 0=manual mode, 1=autoscale
cor(2).ylim =30;         %COR vertical axis scale (amp)
rsp(2).disp ='off';     %mode for matrix column display
rsp(2).eig  ='off';     %mode for eigenvector display
rsp(2).fit  =0;         %valid fit flag
rsp(2).rfflag=1;        %rf fitting flag
rsp(2).rfcorflag= 1;    %fitting flag for rf component in correctors
rsp(2).savflag=0;       %save solution flag
rsp(2).nsvd=54;         %number of singular values
rsp(2).svdtol=0;        %svd tolerance (0 uses number of singular values)
rsp(2).nsvdmx=1;        %default maximum number of singular values
 
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
{    '2BPMy1    '     9      1      1.000   etaxwt     }
{    '2BPMy2    '     10     1      1.000   etaxwt     }
{    '2BPMy3    '     11     1      1.000   etaxwt     }
{    '2BPMy4    '     12     1      1.000   etaxwt     }
{    '2BPMy5    '     13     1      1.000   etaxwt     }
{    '2BPMy6    '     14     1      1.000   etaxwt     }
{    '2BPMy7    '     15     1      1.000   etaxwt     }
{    '2BPMy8    '     16     1      1.000   etaxwt     }
{    '3BPMy1    '     17     1      1.000   etaxwt     }
{    '3BPMy2    '     18     1      1.000   etaxwt     }
{    '3BPMy3    '     19     1      1.000   etaxwt     }
{    '3BPMy4    '     20     1      1.000   etaxwt     }
{    '3BPMy5    '     21     1      1.000   etaxwt     }
{    '3BPMy6    '     22     1      1.000   etaxwt     }
{    '3BPMy7    '     23     1      1.000   etaxwt     }
{    '3BPMy8    '     24     1      1.000   etaxwt     }
{    '4BPMy1    '     25     1      1.000   etaxwt     }
{    '4BPMy2    '     26     1      1.000   etaxwt     }
{    '4BPMy3    '     27     1      1.000   etaxwt     }
{    '4BPMy4    '     28     1      1.000   etaxwt     }
{    '4BPMy5    '     29     1      1.000   etaxwt     }
{    '4BPMy6    '     30     1      1.000   etaxwt     }
{    '4BPMy7    '     31     1      1.000   etaxwt     }
{    '4BPMy8    '     32     1      1.000   etaxwt     }
};
 
% name    index fit (0/1)  weight
cory={
{'1VCM1    '  1   1   1.0    }
{'1VCM2    '  2   1   1.0    }
{'1VCM3    '  3   1   1.0    }
{'2VCM1    '  4   1   1.0    }
{'2VCM2    '  5   1   1.0    }
{'2VCM3    '  6   1   1.0    }
{'3VCM1    '  7   1   1.0    }
{'3VCM2    '  8   1   1.0    }
{'3VCM3    '  9   1   1.0    }
{'4VCM1    '  10  1   1.0    }
{'4VCM2    '  11  1   1.0    }
{'4VCM3    '  12  1   1.0    }
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
 