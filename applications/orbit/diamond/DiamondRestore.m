function [sys,bpmx,bpmy,bpm,corx,cory,cor,rsp,bly]=DiamondRestore(sys, bpm, bl, cor, rsp)
%system parameter save file
%timestamp: 18-Jan-2002 08:08:08
%comment: Save System
ad=getad;
filetype         = 'RESTORE';      %check to see if correct file type
sys.machine      = 'Diamond';      %machine for control
sys.mode         = 'SIMULATOR';    %online or simulator
sys.datamode     = 'RAW';          %raw or real (for real: (1)response matrix multiplied by bpm gains, (2) BPM reads have gain, offset
sys.bpmode       = 'Libera';       %BPM system mode
sys.bpmslp       = 3.0;            %BPM sleep time in sec
sys.plane        = 1;              %plane (1=horizontal 2=vertical)
sys.algo         = 'SVD';          %fitting algorithm
sys.pbpm         = 0;              %use of photon BPMs
sys.filpath      = ad.Directory.Orbit;       %file path in MATLAB
sys.respfiledir  = ad.Directory.OpsData;                                           %response matrix directory
sys.respfilename = ad.OpsData.BPMRespFile;                                         %response matrix file
sys.mxs          = 562;            %maximum ring circumference
sys.xlimax       = 562;            %abcissa plot limit
sys.mxphi(1)     = 28;             %maximum horizontal phase advance
sys.mxphi(2)     = 13;             %maximum vertical phase advance
sys.xscale       = 'meter';        %abcissa plotting mode (meter or phase)
 
%*=== HORIZONTAL DATA ===*
bpm(1).dev      = 10;              %maximum orbit deviation
bpm(1).drf      = 0;               %dispersion component zero
bpm(1).id       = 5;               %BPM selection
bpm(1).scalemode= 0;               %BPM scale mode 0=manual mode, 1=autoscale
bpm(1).ylim     = 1e-3;             %BPM vertical axis scale
cor(1).fract    = 1.0;             %fraction of correctors
cor(1).id       = 1;               %COR selection
cor(1).scalemode=0;                %COR scale mode 0=manual mode, 1=autoscale
cor(1).ylim     = 1e-2;            %COR horizontal axis scale (rad)
rsp(1).disp     = 'off';           %mode for matrix column display
rsp(1).eig      = 'off';           %mode for eigenvector display
rsp(1).fit      = 0;               %valid fit flag
rsp(1).rfflag   = 0;               %rf fitting flag
rsp(1).rfcorflag = 0;              %rf corrector fitting flag
rsp(1).savflag  = 0;               %save solution flag
rsp(1).nsvd     = 54;              %number of singular values
rsp(1).svdtol   = 0;               %svd tolerance (0 uses number of singular values)
rsp(1).nsvdmx   = 1;               %default maximum number of singular values
 
%Note: only fit and weight for fitting will be used in orbit program from this array
%      Name and index are loaded from middleware
%     name       index  fit (0/1) weight etaweight
for n = 1:168
    bpmx{n, 1} = { num2str(n) n 1 1.0 0.0 };
end

for n = 1:168
    corx{n, 1} = { num2str(n) n 1 1.0 };
end

%*===   VERTICAL DATA ===*
bpm(2).dev=10;          %maximum orbit deviation
bpm(2).drf=0;           %dispersion component zero
bpm(2).id=1;            %BPM selection
bpm(2).scalemode=0;     %BPM scale mode 0=manual mode, 1=autoscale
bpm(2).ylim=1e-3;        %BPM vertical axis scale
cor(2).fract=1.0;       %fraction of correctors
cor(2).id  =1;            %COR selection
cor(2).scalemode=0;     %COR scale mode 0=manual mode, 1=autoscale
cor(2).ylim = 1e-2;         %COR vertical axis scale (amp)
rsp(2).disp ='off';     %mode for matrix column display
rsp(2).eig  ='off';     %mode for eigenvector display
rsp(2).fit  =0;         %valid fit flag
rsp(2).rfflag=0;        %rf fitting flag
rsp(1).rfcorflag = 0;   %rf corrector fitting flag
rsp(2).savflag=0;       %save solution flag
rsp(2).nsvd=54;         %number of singular values
rsp(2).svdtol=0;        %svd tolerance (0 uses number of singular values)
rsp(2).nsvdmx=1;        %default maximum number of singular values
 
etaywt=50;  %nominal response ~0.25 peak, 5kHz difference ~0.0025 peak (factor 100)
%     name       index  fit (0/1) weight   etaweight

for n = 1:168
    bpmy{n, 1} = { num2str(n) n 1 1.0 etaywt };
end

for n = 1:168
    cory{n, 1} = { num2str(n) n 1 1.0 };
end

bly = [];
