%=============================================================
function [varargout] = CORInit_Orb(varargin)
%=============================================================
%Initialize COR structure for SPEAR ORBIT program

%COR=CORInit_Orb(COR);

COR=varargin{1};

%horizontal
COR(1).AOFamily='HCM';
ntxcor=size(COR(1).name,1);
COR(1).mode=0;                          %...display to show name, toggle for cor.ifit
COR(1).wt=    ones(ntxcor,1);           %...fitting weights
COR(1).fit=  zeros(ntxcor,1);           %...result of fitting
COR(1).save= zeros(ntxcor,1);           %...for corrector restore
COR(1).saveflag=0;                      %...correctors not saved
COR(1).fract=0.7;                       %...fraction of correction
COR(1).id=1;                            %...initialize cor selection
COR(1).scalemode=0;                     %...0=manual mode, 1=autoscale
COR(1).ylim=25.0;                       %...25 amp vertical axis scale
COR(1).status=(1:ntxcor)';              %...initial status vector
COR(1).avail =(1:ntxcor)';              %...initial availability vector (in response matrix)
COR(1).ifit  =(1:ntxcor)';              %...initial fitting index vector
COR(1).ibump  =[];                      %...initial corrrector bump index vector
COR(1).bumpref  =[];                    %...initial corrrector values for bump
COR(1).ATindex=family2atindex(COR(1).AOFamily);   %load AT indices


%vertical
COR(2).AOFamily='VCM';
ntycor=size(COR(2).name,1);
COR(2).mode=0;                          %...display to show name, toggle for cor.ifit
COR(2).wt=    ones(ntycor,1);           %...weights for fitting
COR(2).fit=  zeros(ntycor,1);           %...result of fitting
COR(2).save= zeros(ntycor,1);           %...for corrector reset
COR(2).saveflag=0;                      %...correctors not saved
COR(2).fract=0.7;                       %...fraction of correction
COR(2).id=1;                            %...initialize corrector selection 
COR(2).scalemode=0;                     %...0=manual mode, 1=autoscale
COR(2).ylim=50.0;                       %...5 amp vertical axis scale
COR(2).status=(1:ntycor)';              %...initial status vector
COR(2).avail =(1:ntycor)';              %...initial availability vector (in response matrix)
COR(2).ifit  =(1:ntycor)';              %...initial fitting index vector
COR(2).ibump  =[];                      %...initial corrrector bump index vector
COR(2).bumpref  =[];                    %...initial corrrector values for bump
COR(2).ATindex=family2atindex(COR(1).AOFamily);   %load AT indices

varargout{1}=COR;
