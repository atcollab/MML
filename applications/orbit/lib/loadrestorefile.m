function varargout=LoadRestoreFile(varargin)
%=============================================================
%read saved data and load structures BPM, BL, COR, RSP, SYS from file
%no graphics in this routine

pathname=varargin(1);    pathname=char(pathname);
filename=varargin(2);    filename=char(filename);
auto    =varargin(3);    auto=char(auto);
sys     =varargin(4);    sys=sys{1};
bpm     =varargin(5);    bpm=bpm{1};
bl      =varargin(6);    bl=bl{1};
cor     =varargin(7);    cor=cor{1};
rsp     =varargin(8);    rsp=rsp{1};

if ~strcmp(auto,'auto')==1
ans=input('Load Restore File? Y/N [Y]: ','s');
if isempty(ans) ans='n'; end
if ans=='n' | ans=='N'
  disp('WARNING: Restore File NOT LOADED');
  fclose(fid);
  return
end
end
%=============================================================
%execute script in save file
disp(['Loading Restore file... ',filename]);

%store plane
plane=sys.plane;
run([pathname filename]);

sys.xlimax=sys.mxs;           %...scaling for abcissa

%load response matrices NOTE: reference orbit and corrector settings not included
disp(' ');
  if     sys.machine=='SPEAR2'
  trsp=ReadSPEAR2Response(sys.rspfil,'auto');
  elseif sys.machine=='SPEAR3'
  trsp=ReadSPEAR3Response(sys.rspfil,'auto');
  end
%load horizontal data structure
rsp(1).ntbpm=trsp(1).ntbpm;
rsp(1).ib=trsp(1).ib;
rsp(1).ntcor=trsp(1).ntcor;
rsp(1).ic=trsp(1).ic;
rsp(1).c=trsp(1).c;
%load vertical data structure
rsp(2).ntbpm=trsp(2).ntbpm;
rsp(2).ib=trsp(2).ib;
rsp(2).ibl=trsp(2).ibl;
rsp(2).ntcor=trsp(2).ntcor;
rsp(2).ic=trsp(2).ic;
rsp(2).c=trsp(2).c;
rsp(2).cp=trsp(2).cp;
clear trsp;

disp(' ');
[trsp]=ReadSP2BResp(sys.brspfil,'auto');
clear trsp;

disp(' ');
  if     sys.machine=='SPEAR2'
  trsp=ReadSPEAR2Dispersion(sys.etafil,'auto');
  elseif sys.machine=='SPEAR3'
  trsp=ReadSPEAR3Dispersion(sys.etafil,'auto');
  end
  rsp(1).eta=trsp(1).eta;
  rsp(1).drf=trsp(1).drf;
  rsp(2).eta=trsp(2).eta;
  rsp(2).drf=trsp(2).drf;
  clear trsp;

%load BPM and COR data from cell arrays

%***horizontal BPM***
%BPM data: name, index, fit,  weight
s=size(bpmx);
for ii=1:s(1)
    ifit=bpmx{ii}(3);
    wt  =bpmx{ii}(4);
    bpm(1).ifit(ii)=ifit{1};         %convert from cell to real
    bpm(1).wt(ii)  =wt{1};
end
bpm(1).ifit=find(bpm(1).ifit);       %compress fitting vector

%***horizontal corrector***
%COR data: name, index, fit,  weight,   limit,      ebpm,      pbpm
s=size(corx);
for ii=1:s(1)
    ifit=corx{ii}(3);
    wt  =corx{ii}(4);
    lim =corx{ii}(5);
    ebpm=corx{ii}(6);
    pbpm=corx{ii}(7);
    cor(1).ifit(ii)=ifit{1};         %convert from cell to real
    cor(1).wt(ii)  =wt{1};
    cor(1).lim(ii) =lim{1};
    cor(1).ebpm(ii)=ebpm{1};
    cor(1).pbpm(ii)=pbpm{1};
end
cor(1).ifit=find(cor(1).ifit);       %compress fitting vector

%***vertical BPM***
%BPM data: name, index, fit,  weight
s=size(bpmy);
for ii=1:s(1)
    ifit=bpmy{ii}(3);
    wt  =bpmy{ii}(4);
    bpm(2).ifit(ii)=ifit{1};         %convert from cell to real
    bpm(2).wt(ii)  =wt{1};
end
bpm(2).ifit=find(bpm(2).ifit);       %compress fitting vector

%***vertical corrector***
%COR data: name, index, fit,  weight,   limit,      ebpm,      pbpm
s=size(cory);
for ii=1:s(1)
    ifit=cory{ii}(3);
    wt  =cory{ii}(4);
    lim =cory{ii}(5);
    ebpm=cory{ii}(6);
    pbpm=cory{ii}(7);
    cor(2).ifit(ii)=ifit{1};         %convert from cell to real
    cor(2).wt(ii)  =wt{1};
    cor(2).lim(ii) =lim{1};
    cor(2).ebpm(ii)=ebpm{1};
    cor(2).pbpm(ii)=pbpm{1};
end
cor(2).ifit=find(cor(2).ifit);       %compress fitting vector

%***vertical beamline***
%BL data: name, index, fit,  weight
s=size(bly);
for ii=1:s(1)
    ifit=bly{ii}(3);
    wt  =bly{ii}(4);
    bl(2).ifit(ii)=ifit{1};         %convert from cell to real
    bl(2).wt(ii)  =wt{1};
end
bl(2).ifit=sort(find(bl(2).ifit));  %compress fitting vector
sys.pbpm=0;
if ~isempty(bl(2).ifit) sys.pbpm=1; end %measure photon bpm data

%Get BPM status, sort for avail, ifit
[bpm(1).status bpm(2).status]=SPEAR2BPMCheck999(bpm(1).hndl,bpm(2).hndl);
bpm(1).avail=bpm(1).status;  %...if status o.k. default to available
bpm(2).avail=bpm(2).status;  
[bpm]=SortBPMs(bpm,rsp); %status, reference orbit, response matrix, ifit

%Get BL status, sort for avail, ifit
%measure actual photon beam position
[bl(2).iopen,bl(2).open, bl(2).iauto,bl(2).auto,bl(2).sum,  bl(2).err,  bl(2).cur]=...
GetSPEAR2BL(sys.mode,bl(2).name,bl(2).hopen,bl(2).hauto,bl(2).hsum, bl(2).herr,bl(2).hcur,3,1);  
%last two entries number averages, dwell
%open, auto are compressed
bl(2).avail=bl(2).open;  %...if beam line open default to available
[bl]=SortBLs(bl,rsp)  ;  %open, response matrix, ifit


%Get COR status, sort for avail, ifit
cor(1).act=getset('GetAllCor',sys.mode,1,cor(1).dbname,cor(1).ham,cor(1).name,cor(1).iAT);  %returns column cell array
cor(1).ref=getset('GetAllCor',sys.mode,1,cor(1).dbname,cor(1).hac,cor(1).name,cor(1).iAT);
cor(2).act=getset('GetAllCor',sys.mode,2,cor(2).dbname,cor(2).ham,cor(2).name,cor(2).iAT);  %returns column cell array
cor(2).ref=getset('GetAllCor',sys.mode,2,cor(2).dbname,cor(2).hac,cor(2).name,cor(2).iAT);
[cor]=SortCORs(cor,rsp);

clear bpmx bpmy corx cory bly

disp(['Finished Loading Restore file ',filename]);

%acquire orbit, load into .act field
[x y]=getset('GetBPM',SYS.mode,BPM(1).dbname,BPM(1).hndl,BPM(2).hndl,BPM(1).name); %load random orbit into BPM.act
BPM(1).act=x(:);   %row vector to column vector
BPM(2).act=y(:);

%photon bpm acquisition 
%because feedback calls GetAct directly (not UpdateAct)
if SYS.pbpm==1 
[bl]=GetSP2BL(sys,bl);          %acquire photon bpm data
end

corgui('GetAct');
sys.plane=plane;   %restore file might have switched planes
%respgui('SolveSystem');
[rsp]=SVDecompose(sys.plane,bpm,cor,bl,rsp);
%respgui('BackSubSystem');    %computes orbit based on nsvd
[bpm,bl,cor]=BackSubSystem(plane,sys,bpm,bl,cor,rsp);

sys.plane=plane;

varargout{1}=sys;
varargout{1}=bpm;
varargout{1}=bl;
varargout{1}=cor;
varargout{1}=rsp;
