%=============================================================
function varargout=ReadReference(varargin)
%=============================================================
%reads a reference orbit from file in VSPEAR11 format 
filename=varargin(1);   filename=char(filename);
auto    =varargin(2);   auto=char(auto);
sys     =varargin(3);   sys=sys{1};
bpm     =varargin(4);   bpm=bpm{1};


[tbpm]=ReadSPEAR2Orbit(filename,auto);
bpm(1).iref=tbpm(1).iref;
bpm(1).ref =tbpm(1).ref;
bpm(2).iref=tbpm(2).iref;
bpm(2).ref =tbpm(2).ref;

%process for orbit program
bpm(1).des=bpm(1).ref;
bpm(1).abs=bpm(1).ref;

bpm(2).des=bpm(2).ref;
bpm(2).abs=bpm(2).ref;

if sys.relative==1
ntbpm=length(bpm(1).name(:,1));
bpm(1).abs=zeros(1,ntbpm)';
ntbpm=length(bpm(2).name(:,1));
bpm(2).abs=zeros(1,ntbpm)';
end 

varargout{1}=bpm;
