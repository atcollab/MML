%=============================================================
function [varargout] = BLInit_Orb(varargin)
%=============================================================
%Append fields to input structure for ORBIT program
%Initialize photon beamline data
%BL=BLInit_Orb(BL);
BL=varargin{1};

%horizontal
BL(1).ifit=[];                              %...indices for fitting
BL(1).fit=zeros(size(BL(1).name,1),1);      %...predicted moves
BL(1).iopen=[];                             %...flags for open beamlines
BL(1).open=[];                              %...indices for beamline status
BL(1).iauto=[];                             %...flags for auto beamlines
BL(1).auto=[];                              %...indices for beamline auto
BL(1).avail=[];                             %...indices for available beamlines
BL(1).sum  =zeros(size(BL(1).name,1),1);    %...photon BPM sum readings
BL(1).err  =zeros(size(BL(1).name,1),1);    %...photon BPM err readings
BL(1).norm =zeros(size(BL(1).name,1),1);    %...photon BPM err/sum
BL(1).cur  =zeros(size(BL(1).name,1),1);    %...photon BPM cur readings
BL(1).wt=100*ones(size(BL(1).name,1),1);    %...photon BPM weights

%vertical
BL(2).ifit=[];                              %...indices for fitting
BL(2).fit=zeros(size(BL(1).name,1),1);      %...predicted moves
BL(2).iopen=[];                             %...flags for open beamlines
BL(2).open=[];                              %...indices for beamline status
BL(2).iauto=[];                             %...flags for auto beamlines
BL(2).auto=[];                              %...indices for beamline auto
BL(2).avail=[];                             %...indices for available beamlines
BL(2).sum  =zeros(size(BL(2).name,1),1);    %...photon BPM sum readings
BL(2).err  =zeros(size(BL(2).name,1),1);    %...photon BPM err readings
BL(2).norm =zeros(size(BL(2).name,1),1);    %...photon BPM err/sum
BL(2).cur  =zeros(size(BL(2).name,1),1);    %...photon BPM cur readings
BL(2).wt=100*ones(size(BL(2).name,1),1);    %...photon BPM weights

varargout{1}=BL;
