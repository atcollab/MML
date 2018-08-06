%function [sys,bpmx,bpmy,bpm,corx,cory,cor,rsp,bly]=restore
%system parameter save file
%timestamp: 18-Jan-2002 08:08:08
%comment: Save System
ad=getad;
filetype         = 'RESTORE';      %check to see if correct file type
sys.machine      = 'CAMD';         %machine for control
sys.mode         = 'simulator';    %online or simulator
sys.datamode     = 'REAL';         %raw or real (for real: (1)response matrix multiplied by bpm gains, (2) BPM reads have gain, offset
sys.bpmslp       = 3.0;            %BPM sleep time in sec
sys.globalperiod = 2.0;            %BPM sleep time in sec
sys.silverperiod = 2.0;            %BPM sleep time in sec
sys.plane        = 1;              %plane (1=horizontal 2=vertical)
sys.algo         = 'SVD';          %fitting algorithm
sys.pbpm         = 1;              %use of photon BPMs
sys.filpath      = ad.Directory.Orbit;       %file path in MATLAB
sys.respfiledir  = ad.Directory.OpsData;                                           %response matrix directory
sys.respfilename = ad.OpsData.BPMRespFile;                                         %response matrix file
%sys.relative     = 2;             %set in initialization relative or absolute BPM plot 1=absolute, 2=relative
sys.fdbk         = 0;              %no feedback
sys.abort        = 0;              %reset abort flag
sys.mxs          = 60;            %maximum ring circumference
sys.xlimax       = 60;            %abcissa plot limit
sys.mxphi(1)     = 5;              %maximum horizontal phase advance
sys.mxphi(2)     = 2;              %maximum vertical phase advance
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
rsp(1).rfflag   = 0;               %rf fitting flag
rsp(1).etaflag  = 0;               %dispersion fitting flag
rsp(1).savflag  = 0;               %save solution flag
rsp(1).nsvd     = 54;              %number of singular values
rsp(1).svdtol   = 0;               %svd tolerance (0 uses number of singular values)
rsp(1).nsvdmx   = 1;               %default maximum number of singular values
 
%Note: only fit and weight for fitting will be used in orbit program from this array
%      Name and index are loaded from middleware
etaxwt=0.0;
%     name       index  fit (0/1) weight etaweight
bpmx={
{    '1BPM1    '     1      0      1.000   etaxwt     }
{    '1BPM2    '     2      1      1.000   etaxwt     }
{    '1BPM3    '     3      1      1.000   etaxwt     }
{    '1BPM4    '     4      1      1.000   etaxwt     }
{    '1BPM5    '     5      1      1.000   etaxwt     }
{    '2BPM1    '     6      1      1.000   etaxwt     }
{    '2BPM2    '     7      1      1.000   etaxwt     }
{    '2BPM3    '     8      1      1.000   etaxwt     }
{    '2BPM4    '     9      1      1.000   etaxwt     }
{    '2BPM5    '     10     1      1.000   etaxwt     }
{    '3BPM1    '     11     1      1.000   etaxwt     }
{    '3BPM2    '     12     1      1.000   etaxwt     }
{    '3BPM3    '     13     1      1.000   etaxwt     }
{    '3BPM4    '     14     1      1.000   etaxwt     }
{    '3BPM5    '     15     1      1.000   etaxwt     }
{    '4BPM1    '     16     1      1.000   etaxwt     }
{    '4BPM2    '     17     1      1.000   etaxwt     }
{    '4BPM3    '     18     1      1.000   etaxwt     }
{    '4BPM4    '     19     1      1.000   etaxwt     }
{    '4BPM5    '     20     1      1.000   etaxwt     }
};
 
%Note: only fit, weight for fitting will be used in orbit program from this array
%      Name and index are loaded from middleware
% name    index fit (0/1)  weight
corx={
{'1CX1    '  1   1   1.0    }
{'1CX2    '  2   1   1.0    }
{'1CX3    '  3   1   1.0    }
{'1CX4    '  4   1   1.0    }
{'2CX1    '  5   1   1.0    }
{'2CX2    '  6   1   1.0    }
{'2CX3    '  7   1   1.0    }
{'2CX4    '  8   1   1.0    }
{'3CX1    '  9   1   1.0    }
{'3CX2    '  10  1   1.0    }
{'3CX3    '  11  1   1.0    }
{'3CX4    '  12  1   1.0    }
{'4CX1    '  13  1   1.0    }
{'4CX2    '  14  1   1.0    }
{'4CX3    '  15  1   1.0    }
{'4CX4    '  16  1   1.0    }
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
rsp(2).rfflag=0;        %rf fitting flag
rsp(2).etaflag=1;       %dispersion fitting flag
rsp(2).savflag=0;       %save solution flag
rsp(2).nsvd=54;         %number of singular values
rsp(2).svdtol=0;        %svd tolerance (0 uses number of singular values)
rsp(2).nsvdmx=1;        %default maximum number of singular values
 
etaywt=50;  %nominal response ~0.25 peak, 5kHz difference ~0.0025 peak (factor 100)
%     name       index  fit (0/1) weight   etaweight
bpmy={
{    '1BPM1    '     1      0      1.000   etaxwt     }
{    '1BPM2    '     2      1      1.000   etaxwt     }
{    '1BPM3    '     3      1      1.000   etaxwt     }
{    '1BPM4    '     4      1      1.000   etaxwt     }
{    '1BPM5    '     5      1      1.000   etaxwt     }
{    '2BPM1    '     6      1      1.000   etaxwt     }
{    '2BPM2    '     7      1      1.000   etaxwt     }
{    '2BPM3    '     8      1      1.000   etaxwt     }
{    '2BPM4    '     9      1      1.000   etaxwt     }
{    '2BPM5    '     10     1      1.000   etaxwt     }
{    '3BPM1    '     11     1      1.000   etaxwt     }
{    '3BPM2    '     12     1      1.000   etaxwt     }
{    '3BPM3    '     13     1      1.000   etaxwt     }
{    '3BPM4    '     14     1      1.000   etaxwt     }
{    '3BPM5    '     15     1      1.000   etaxwt     }
{    '4BPM1    '     16     1      1.000   etaxwt     }
{    '4BPM2    '     17     1      1.000   etaxwt     }
{    '4BPM3    '     18     1      1.000   etaxwt     }
{    '4BPM4    '     19     1      1.000   etaxwt     }
{    '4BPM5    '     20     1      1.000   etaxwt     }
};
 
% name    index fit (0/1)  weight
cory={
{'1CY1    '  1   1   1.0    }
{'1CY2    '  2   1   1.0    }
{'1CY3    '  3   1   1.0    }
{'2CY1    '  4   1   1.0    }
{'2CY2    '  5   1   1.0    }
{'2CY3    '  6   1   1.0    }
{'3CY1    '  7   1   1.0    }
{'3CY2    '  8   1   1.0    }
{'3CY3    '  9   1   1.0    }
{'4CY1    '  10  1   1.0    }
{'4CY2    '  11  1   1.0    }
{'4CY3    '  12  1   1.0    }
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
 