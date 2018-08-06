%=============================================================
function [varargout] = BPMInit_Orb(varargin)
%=============================================================
%Initialize electron BPM data
%BPM=BPMInit_Orb(BPM);

BPM=varargin{1};

%horizontal plane ***
BPM(1).AOFamily='BPMx';
ntbpm=size(BPM(1).name,1);
BPM(1).mode=0;                     %display to show name, toggle for BPM.ifit
BPM(1).ref=zeros(ntbpm,1);        %...BPM.ref,des,abs all set in reference read
BPM(1).des=zeros(ntbpm,1);        %...initialize array
BPM(1).act=zeros(ntbpm,1);        %...initialize array
BPM(1).rffit=zeros(ntbpm,1);      %...initialize dispersion component
BPM(1).avail=(1:ntbpm)';          %...initialize all BPMs available
BPM(1).ifit=(1:ntbpm)';           %...initialize all BPMs on for fitting
BPM(1).fit=zeros(ntbpm,1);        %...initialize fitted solution zero
BPM(1).wt=ones(ntbpm,1);          %...SVD fitting weights
BPM(1).drf=0;                     %...no dispersion component
BPM(1).id=1;                      %...initialize BPM selection
BPM(1).ATindex=family2atindex(BPM(1).AOFamily);   %load AT indices


%vertical
BPM(2).AOFamily='BPMy';
ntbpm=size(BPM(2).name,1);
BPM(2).mode=0;                     %display to show name, toggle for BPM.ifit
BPM(2).ref=zeros(ntbpm,1);        %...BPM.ref,des,abs all set in reference read
BPM(2).des=zeros(ntbpm,1);        %...initialize array
BPM(2).act=zeros(ntbpm,1);        %...initialize array
BPM(2).rffit=zeros(ntbpm,1);      %...initialize dispersion component
BPM(2).avail=(1:ntbpm)';          %...initialize all BPMs available
BPM(2).ifit=(1:ntbpm)';           %...initialize all BPMs on for fitting
BPM(2).fit=zeros(ntbpm,1);        %...initialize fitted solution zero
BPM(2).wt =ones(ntbpm,1);         %...SVD fitting weights
BPM(2).drf=0;                     %...no dispersion component
BPM(2).id=1;                      %...initialize BPM selection
BPM(2).ATindex=family2atindex(BPM(2).AOFamily);   %load AT indices

varargout{1}=BPM;


