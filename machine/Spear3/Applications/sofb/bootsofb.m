function BootSOFB;

%do list
%check orbit read out of range
%check correctors out of range (cycle, total)
%write data to log file (one log per program launch)
%remove DC component of correctors
%rf frequency correction
%photon beamline steering

[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

%SYS Structure
SYS.mincur=8;  %minimum current
SYS.cycle=0;   %cycle counter
SYS.trip=0;    %interlock flag
SYS.stop=0;    %stop flag
SYS.mode='ONLINE';
SYS.LogFlag=0;
SYS.SOFB.timerperiod=6;            %seconds
SYS.photon       = 0;              %use of photon BPMs
SYS.abort        = 0;              %reset abort flag
SYS.rf           = 1;              %rf fitting flag
SYS.rfcor        = 1;              %rf-corrector fitting flag
SYS.rfmin        = 1.0/1e6;        %threshold to change rf frequency (MHz)
SYS.nerror       = 0;              %orbit correction try/catch
SYS.nerrormax    = 20;             %maximum number of try/catch

%Load BPM Response Matrix
[S,filename] = getbpmresp('struct');              %golden response
RSP=response2rsp(S,RSP);

%Load Photon Response Matrix Data
[S,filename] = getphotresp('struct');              %golden photon response
BL=response2bl(S,BL);
RSP(2).cp=BL(2).cp;                                %cp used in RSP structure

 
BPMFamilies={'BPMx'; 'BPMy'};
CorFamilies={'HCM';  'VCM' };
Plane={'Horizontal';  'Vertical'};
Fract=[0.75; 0.75];     %fraction of correction in each plane
BPMDev=[1.0; 0.5];      %maximum orbit deviation in each plane

%remove BPMs from SOFB that have status=1 in SPEAR3INIT
%device     x-plane     y-plane  4-char comment  (0 indicates remove from list, 1 indicates keep in list)
nofitbpm={...
[4  4]        1           1     'BL1 '; ...
[5  4]        1           1     'BL2 '; ...
[14 4]        1           1     'BL3 '; ...
[14 1]        1           1     'BL4 ' ; ...
[13 1]        1           1     'BL5 ' ; ...
[12 1]        1           1     'BL6 ' ; ...
[6  1]        1           1     'BL7 ' ; ...
[7  4]        1           1     'BL8 ' ; ...
[8  1]        1           1     'BL9 ' ; ...
[7  1]        1           1     'BL10' ; ...
[16 1]        1           1     'BL11' };
nofitbpmx=[];   %devicelist
nofitbpmy=[];
for k=1:size(nofitbpm(:,1))
  if nofitbpm{k,2}==0           %check for horizontal BPMs to eliminate
  nofitbpmx=[nofitbpmx; nofitbpm{k,1}]; 
  end
  if nofitbpm{k,3}==0           %check for vertical BPMs to eliminate
  nofitbpmy=[nofitbpmy; nofitbpm{k,1}]; 
  end
end


physdata=getphysdata;

for plane=1:2
    
%Initialize BPM Data
family=BPMFamilies{plane};
orbdevlist=getlist(family);

BPM(plane).family    = family;                   %family
BPM(plane).maxdev    = BPMDev(plane);            %maximum orbit deviation
BPM(plane).drf       = 0;                        %rf frequency shift

status=getfamilydata(family,'Status');           %full length status vector

%goodindex index used for orbit acquisition SOFBlib('CorrectOrbit')
if     plane==1
    nofitbpm=nofitbpmx;
elseif plane==2
    nofitbpm=nofitbpmy;
end

  if ~isempty(nofitbpm)
  status(dev2elem(family,nofitbpm))=0;                                                          %set status=0 for no-fit bpms
  BPM(plane).badindex=sort(findrowindex(nofitbpm,orbdevlist));                                  %index of no-fit bpms in measured orbit
  %SETXOR(A,B) returns values not in the intersection of A and B.
  BPM(plane).goodindex=[setxor(BPM(plane).badindex,1:length(dev2elem(family,orbdevlist)))]';     %index of good bpms in measured orbit
  else
  BPM(plane).goodindex=[1:length(dev2elem(family,orbdevlist))]';
  BPM(plane).badindex=[];
  end

BPM(plane).ntbpm=length(status);                 %total number of bpms
BPM(plane).status=find(status);                  %indices of status=1 bpms
BPM(plane).ifit=BPM(plane).status;               %indices of BPMs for fitting
BPM(plane).wt=ones(BPM(plane).ntbpm,1);          %bpm weights

%master arrays used for turning beamlines on/off (sofbgui('BeamlineFit'))
% BPM(plane).masterifit=BPM(plane).ifit;
% BPM(plane).masterstatus=BPM(plane).status;
% BPM(plane).mastergoodindex=BPM(plane).goodindex;  

%Load golden orbit
BPM(plane).ref=zeros(BPM(plane).ntbpm,1);             %initialize full length reference orbit
BPM(plane).act=zeros(BPM(plane).ntbpm,1);             %initialize full length measured orbit
BPM(plane).rffit=zeros(BPM(plane).ntbpm,1);           %initialize full length rffit orbit
BPM(plane).golden=physdata.(family).Golden.Data;      %full length       %see alternative command in spear3init
BPM(plane).goldenioc=getbpmdes(family);
BPM(plane).ref(BPM(plane).status)=BPM(plane).golden(BPM(plane).status);
BPM(plane).des=BPM(plane).ref;                        %desired orbit (can differ from Golden)

%check that MATLAB golden and ioc golden agree
%note: notagree contains indices within the spear3init BPM status vector
notagree=find(abs(BPM(plane).golden(BPM(plane).status)-BPM(plane).goldenioc)>1e-4);
if ~isempty(notagree)
    for k=1:length(notagree)
        disp([   'Warning: MATLAB Golden orbit and IOC Golden orbit do not agree for family ' family ' status number ' num2str(BPM(plane).status(notagree(k)))]);
    end
end

%Load Dispersion
BPM(plane).disprf=physdata.(family).Dispersion.ActuatorDelta;  %rf change to generate dispersion orbit
BPM(plane).disp=physdata.(family).Dispersion.Data;             %mm/MHz, full length
BPM(plane).disp=BPM(plane).disp*BPM(plane).disprf;             %mm/unit of rf frequency used in dispersion measurement
BPM(plane).rffract=0.5;                                        %fraction of rf correction

%Initialize Corrector Data
family=CorFamilies{plane};
COR(plane).family    = family;
COR(plane).plane     = Plane{plane};
COR(plane).fract     = Fract(plane);                 %fraction of Correction

status=getfamilydata(family,'Status');
%remove BL5 correctors  in both planes [12 4]  [13 1]
% disp('   Warning: removing correctors in BL5 straight (program: BootSOFB lines 134-136)');
% status(dev2elem(family,[12,4]))=0;
% status(dev2elem(family,[13,1]))=0;

COR(plane).ntcor=length(status);                     %total number of correctors
COR(plane).status=find(status);                      %valid correctors
COR(plane).ifit=COR(plane).status;                   %fit with all valid correctors
COR(plane).wt=ones(COR(plane).ntcor,1);              %corrector weights

COR(plane).ref=zeros(COR(plane).ntcor,1);
COR(plane).act=zeros(COR(plane).ntcor,1);         
COR(plane).acc=zeros(COR(plane).ntcor,1);         
COR(plane).maxdev=8;  

%calculate (inverse response matrix)*dispersion in CalcInverse

%Initialize RSP fields
RSP(plane).fit       = 0;                      %valid fit flag
RSP(plane).nsvd      = 54;                     %number of singular values
RSP(plane).svdtol    = 0;                      %svd tolerance (0 uses number of singular values)
RSP(plane).nsvdmx    = 1;                      %default maximum number of singular values
end 

%[BPM]=SortBPMs(BPM,RSP);

%*=== PHOTON BPM DATA ===*
BL(2).DevList=getlist('BLOpen',0);                     %valid photon BPMs in middlelayer
BL(2).ElemList=dev2elem('BLOpen',BL(2).DevList);
BL(2).status=getfamilydata('BLOpen','Status');         
BL(2).ifit=find(BL(2).status);                         %initialize with all beamlines status=1
weight=100;
BL(2).wt=weight*ones(length(BL(2).ElemList),1);        %photon BPMS weights
BL(2).maxdev=5;

%bpms to remove if photon beamlines selected - this will keep orbit away from BL flat
BL(2).bpmout(1,:) =[4  4];
BL(2).bpmout(2,:) =[5  4];
BL(2).bpmout(3,:) =[14 4];
BL(2).bpmout(4,:) =[14 1];
BL(2).bpmout(5,:) =[13 1];
BL(2).bpmout(6,:) =[12 1];
BL(2).bpmout(7,:) =[6  1];
BL(2).bpmout(8,:) =[7  4];
BL(2).bpmout(9,:) =[8  1];
BL(2).bpmout(10,:)=[7  1];
BL(2).bpmout(11,:)=[16 1];

sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);