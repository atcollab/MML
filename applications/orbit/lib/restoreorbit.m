function varargout=RestoreOrbit(varargin)
%=============================================================
%read saved data from file
%load structures sys, bl, bpm, cor, rsp for return 
%no graphics in this routine

DirSpec =varargin(1);    DirSpec=char(DirSpec);
FileName=varargin(2);    FileName=char(FileName);
auto    =varargin(3);    auto=char(auto);
sys     =varargin(4);    sys=sys{1};
bpm     =varargin(5);    bpm=bpm{1};
bl      =varargin(6);    bl=bl{1};
cor     =varargin(7);    cor=cor{1};
rsp     =varargin(8);    rsp=rsp{1};

%=================================
%check automatic file load request
%=================================
if ~strcmp(auto,'auto')==1
ans=input('Load Restore File? Y/N [Y]: ','s');
if isempty(ans) ans='n'; end
if ans=='n' | ans=='N'
  disp('WARNING: Restore File NOT LOADED');
  fclose(fid);
  return
end
end

%===========================
%execute script in save file
%===========================
disp(['   Loading restore file... ',FileName]);
%provides filetype,sys,bpmx,bpmy,bpm,corx,cory,cor,rsp,bly
run([DirSpec filesep FileName]);     %save file is a script - contains information in sys, bpm, cor, rsp, bpmx, bpmy, corx, cory, bly
% d=pwd;
% cd(DirSpec);
% assignin('caller','RestoreFile',FileName);
% [filetype,sys,bpmx,bpmy,bpm,corx,cory,cor,rsp,bly]=RestoreFile;
% cd(d);

if ~strcmpi(filetype,'RESTORE')
disp(['Warning: improper file specification - ' upper(filetype)]);
return
else
clear filetype
end

sys.xlimax=sys.mxs;           %...scaling for abcissa

%=========================================================
%load Corrector to BPM response matrix
%=========================================================
[S,filename] = getbpmresp('struct');               %automatically loads golden response
rsp=response2rsp(S,rsp);

%=========================================================
%load Dispersion Data
%=========================================================
%load golden dispersion
load([sys.dispfiledir sys.dispfilename]);

% The following assumes mm/Hz units for the dispersion measurements.
if strcmpi(BPMxDisp.Units,'Physics')
    BPMxDisp = physics2hw(BPMxDisp);
end
if strcmpi(BPMyDisp.Units,'Physics')
    BPMyDisp = physics2hw(BPMyDisp);
end

d={BPMxDisp; BPMyDisp};
family={'BPMx'; 'BPMy'};
for k=1:2
    bpm(k).disp=0.0*getfamilydata(family{k},'Status');  % make full length array of zeros
    indx=dev2elem(family{k},d{k}.Monitor.DeviceList);
    
    bpm(k).disprf=d{k}.ActuatorDelta;       % rf change to generate dispersion orbit
    bpm(k).disprfUnits = d{k}.Actuator.UnitsString;
    temp=d{k}.Data;                % mm per MHz. vector size full length (all BPMs)
    bpm(k).disp(indx)=temp*bpm(k).disprf;  % mm per unit of rf frequency change used in dispersion measurement
end

%=========================================================
%load Corrector to Photon BPM response matrix
%=========================================================
if strcmpi(sys.machine,'SPEAR3')
[S,filename] = getphotresp('struct');              %golden photon response
bl=response2bl(S,bl);
rsp(2).cp=bl(2).cp;                                %cp used in RSP structure
end

%=======================================================================
%load BPM and COR data from cell arrays acquired while running save file
%=======================================================================
%horizontal BPM
for ii=1:size(bpmx,1);
    ifit=bpmx{ii}(3);
    wt  =bpmx{ii}(4);
    bpm(1).ifit(ii)=ifit{1};         %convert from cell to real
    bpm(1).wt(ii)  =wt{1};
end
bpm(1).ifit=find(bpm(1).ifit);       %compress fitting vector

%horizontal corrector
for ii=1:size(corx,1)
    ifit=corx{ii}(3);
    wt  =corx{ii}(4);
    cor(1).ifit(ii)=ifit{1};         %convert from cell to real
    cor(1).wt(ii)  =wt{1};
end
cor(1).ifit=find(cor(1).ifit);       %compress fitting vector

%horizontal dispersion

%vertical BPM
for ii=1:size(bpmy,1)
    ifit=bpmy{ii}(3);
    wt  =bpmy{ii}(4);
    bpm(2).ifit(ii)=ifit{1};         %convert from cell to real
    bpm(2).wt(ii)  =wt{1};
end
bpm(2).ifit=find(bpm(2).ifit);       %compress fitting vector

%vertical corrector
for ii=1:size(cory,1)
    ifit=cory{ii}(3);
    wt  =cory{ii}(4);
    cor(2).ifit(ii)=ifit{1};         %convert from cell to real
    cor(2).wt(ii)  =wt{1};
end
cor(2).ifit=find(cor(2).ifit);       %compress fitting vector

%vertical beamline
for ii=1:size(bly,1)
    ifit=bly{ii}(3);
    wt  =bly{ii}(4);
    bl(2).ifit(ii)=ifit{1};         %convert from cell to real
    bl(2).wt(ii)  =wt{1};
end

bl(2).ifit=sort(find(bl(2).ifit));  %compress fitting vector
sys.pbpm=0;
if ~isempty(bl(2).ifit) sys.pbpm=1; end %measure photon bpm data

%==========================================================
%load corrector limits and response matrix kicks via AO
%==========================================================
AO=getao;

cor(1).lim =abs(AO.('HCM').Setpoint.Range(:,1));          %corrector limits
cor(1).ebpm=AO.('HCM').Setpoint.DeltaRespMat;             %kicks for response matrix
%%%no corrector kicks to photon bpms in vertical plane

cor(2).lim =abs(AO.('VCM').Setpoint.Range(:,1));
cor(2).ebpm=AO.('VCM').Setpoint.DeltaRespMat;
if isfield(AO.('VCM').Setpoint,'PhotResp')
    cor(2).pbpm=AO.('VCM').Setpoint.PhotResp;
else
    cor(2).pbpm=1;
end

disp(['   Finished loading restore file... ',FileName]);
varargout{1}=sys;
varargout{2}=bpm;
varargout{3}=bl;
varargout{4}=cor;
varargout{5}=rsp;
