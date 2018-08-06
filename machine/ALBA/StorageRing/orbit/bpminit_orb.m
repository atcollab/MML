function varargout = bpminit_orb
% BPMINIT_Orb - Initialize electron BPM data for ORBIT program

%
% Written by William J. Corbett
% Adapted by Laurent S. Nadolski

BPMxFamily = gethbpmfamily;
BPMyFamily = getvbpmfamily;

AO = getao;

%horizontal plane ***
BPM(1).AOFamily = BPMxFamily;
BPM(1).name = AO.(BPMxFamily).CommonNames;
BPM(1).s    = AO.(BPMxFamily).Position;   
ntbpm       = size(BPM(1).name,1);
BPM(1).mode  = 0;                 %display to show name, toggle for BPM.ifit
BPM(1).ref   = zeros(ntbpm,1);    %...BPM.ref,des,abs all set in reference read
BPM(1).des   = zeros(ntbpm,1);    %...initialize array
BPM(1).act   = zeros(ntbpm,1);    %...initialize array
BPM(1).rffit = zeros(ntbpm,1);    %...initialize dispersion component
BPM(1).avail = (1:ntbpm)';        %...initialize all BPMs available
BPM(1).ifit  = (1:ntbpm)';        %...initialize all BPMs on for fitting
BPM(1).fit   = zeros(ntbpm,1);    %...initialize fitted solution zero
BPM(1).wt    = ones(ntbpm,1);     %...SVD fitting weights
BPM(1).etawt = ones(ntbpm,1);     %...SVD dispersion fitting weights
BPM(1).id    = 1;                 %...initialize BPM selection
BPM(1).ATindex = AO.(BPMxFamily).AT.ATIndex;   %load AT indices
BPM(1).ntbpm = ntbpm;             % number of bpms


% vertical plane
BPM(2).AOFamily= BPMyFamily;
BPM(2).name = AO.(BPMyFamily).CommonNames;
BPM(2).s    = AO.(BPMyFamily).Position;   
ntbpm       = size(BPM(2).name,1);
BPM(2).mode = 0;                  %display to show name, toggle for BPM.ifit
BPM(2).ref  = zeros(ntbpm,1);     %...BPM.ref,des,abs all set in reference read
BPM(2).des  = zeros(ntbpm,1);     %...initialize array
BPM(2).act  = zeros(ntbpm,1);     %...initialize array
BPM(2).rffit= zeros(ntbpm,1);     %...initialize dispersion component
BPM(2).avail= (1:ntbpm)';         %...initialize all BPMs available
BPM(2).ifit = (1:ntbpm)';         %...initialize all BPMs on for fitting
BPM(2).fit  = zeros(ntbpm,1);     %...initialize fitted solution zero
BPM(2).wt   = ones(ntbpm,1);      %...SVD fitting weights
BPM(2).etawt= ones(ntbpm,1);      %...SVD dispersion fitting weights
BPM(2).id   = 1;                  %...initialize BPM selection
BPM(2).ATindex = AO.(BPMxFamily).AT.ATIndex;   %load AT indices
BPM(2).ntbpm = ntbpm;             %number of bpms  

varargout{1} = BPM;
