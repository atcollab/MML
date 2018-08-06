function varargout = corinit_orb(varargin)
% CORINIT_ORB - Initializes COR structure for SPEAR ORBIT program
%COR=CORInit_Orb(COR);

%
% Written by William J. Corbett
% Adapted by Laurent S. Nadolski

HCORFamily = 'HCOR';
VCORFamily = 'VCOR';

AO = getao;

%horizontal
COR(1).name     = AO.(HCORFamily).CommonNames;
COR(1).s        = AO.(HCORFamily).Position;   
COR(1).AOFamily = HCORFamily;
good            = AO.(HCORFamily).Status;
ntcor           = size(COR(1).name,1);
COR(1).ntcor    = ntcor;
COR(1).mode     = 0;                     %...display to show name, toggle for cor.ifit
COR(1).wt       = ones(ntcor,1);         %...fitting weights
COR(1).fit      = zeros(ntcor,1);        %...result of fitting
% COR(1).knob     = zeros(ntcor,1);        %...for corrector knob
% COR(1).iknob    = zeros(ntcor,1);        %...knob indices
% COR(1).knobflag = 0;                     %...knob not saved
COR(1).save     = zeros(ntcor,1);        %...for corrector restore
COR(1).saveflag = 0;                     %...correctors not saved
COR(1).fract    = 1.0;                   %...fraction of correction
COR(1).id       = 1;                     %...initialize cor selection
COR(1).scalemode= 1;                     %...0=manual mode, 1=autoscale
COR(1).ylim     = 10.0;                  %...10 amp vertical axis scale
COR(1).status   = (1:ntcor)'.*good;      %...initial status vector
COR(1).avail    = COR(1).status;         %...initial availability vector (in response matrix)
COR(1).ifit     = COR(1).status;         %...initial fitting index vector
COR(1).ibump    = [];                    %...initial corrrector bump index vector
% COR(1).bumpref  = [];                    %...initial corrrector values for bump
COR(1).ATindex  = AO.(HCORFamily).AT.ATIndex;   %load AT indices
COR(1).act      = zeros(ntcor,1);       %...actual values
COR(1).ref      = zeros(ntcor,1);       %...reference values
COR(1).des      = zeros(ntcor,1);       %...desired values

%vertical
COR(2).AOFamily = VCORFamily;
COR(2).name     = AO.(VCORFamily).CommonNames;
COR(2).s        = AO.(VCORFamily).Position;   
good            = AO.(VCORFamily).Status;
ntcor           = size(COR(2).name,1);
COR(2).ntcor    = ntcor;
COR(2).mode     = 0;                    %...display to show name, toggle for cor.ifit
COR(2).avail    = zeros(ntcor,1);       %...available bpm 
COR(2).fit      = zeros(ntcor,1);       %...result of fitting
COR(2).wt       = ones(ntcor,1);        %...weights for fitting
% COR(2).knob     = zeros(ntcor,1);       %...forcorrector knob
% COR(2).iknob    = zeros(ntcor,1);       %...knob indices
% COR(2).knobflag = 0;                    %...knob not saved
COR(2).save     = zeros(ntcor,1);       %...for corrector reset
COR(2).saveflag = 0;                    %...correctors not saved
COR(2).fract    = 1.0;                  %...fraction of correction
COR(2).id       = 1;                    %...initialize corrector selection 
COR(2).scalemode= 1;                    %...0=manual mode, 1=autoscale
COR(2).ylim     = 10.0;                 %...10 amp vertical axis scale
COR(2).status   = (1:ntcor)'.*good;     %...initial status vector
COR(2).avail    = COR(2).status;        %...initial availability vector (in response matrix)
COR(2).ifit     = COR(2).status;        %...initial fitting index vector
COR(2).ibump    = [];                   %...initial corrrector bump index vector
% COR(2).bumpref  = [];                   %...initial corrrector values for bump
COR(2).ATindex  = AO.(VCORFamily).AT.ATIndex;   %load AT indices
COR(2).act      = zeros(ntcor,1);       %...actual values
COR(2).ref      = zeros(ntcor,1);       %...reference values
COR(2).des      = zeros(ntcor,1);       %...desired values

varargout{1} = COR;
