function varargout=sofblib(action,varargin)
%==========================================================
%library of functions for SOFB software

switch action
    
%**************************************************************        
case 'CreateGUI'
%**************************************************************        
%Create slow orbit feedback gui interface

[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

% get screen size in cm
h = findobj('Type', 'root'); units=get(h,'Units');
set(h, 'Units', 'centimeters');
screen_position = get(findobj('Type', 'root'), 'screensize');
screen_wide=screen_position(3); screen_high=screen_position(4);

%Figure
fig_start = [0.1*screen_wide 0.1*screen_high];
fig_size  = [0.3*screen_wide 0.3*screen_high];

handles.fig=figure('units','centimeters','Position',[fig_start fig_size],... 
		'NumberTitle','off','Doublebuffer','on','Resize','On',...
		'Tag','SOFBPanel','Name','Slow Orbit Feedback Control');
set(handles.fig,'MenuBar','None');
%set(handles.fig,'DeleteFcn','sofbgui(''KillTimer'')');
set(handles.fig,'CloseRequestFcn','sofbgui(''CloseMainFigure'')');

x=screen_wide*0.03; dx=screen_wide*0.05; y=screen_high*0.25; dy=screen_high*0.02;
delx=screen_wide*0.06; dely=screen_high*0.03;

%Control Pushbuttons
       handles.Start=uicontrol('Style','pushbutton',...	                  %...Start           
       'units', 'centimeters','Position', [x y dx dy],'ForeGroundColor','k',...
       'String','Start','Enable','on','Value',0,...
       'ToolTipString','Start Feedback',...	
       'FontSize',9,'FontWeight','demi','Callback','sofbgui(''Start'')');
   
       handles.Stop=uicontrol('Style','pushbutton',...	                  %...Stop                      
       'units', 'centimeters','Position', [x y-dely dx dy],'ForeGroundColor','k',...
       'String','Stop','Enable','off','Value',0,...
       'ToolTipString','Stop Feedback',...	
       'FontSize',9,'FontWeight','demi','Callback','sofbgui(''StopFlag'')');

%Cycle Indicator  
       handles.Cycle=uicontrol('Style','text',...  
       'units', 'centimeters','Position', [x y-2*dely 5*dx dy],...
       'ForeGroundColor','k','String','Cycle Time',...
       'ToolTipString','green: correction applied    y: correction bypassed',...	
       'FontSize',8,'FontWeight','demi');
   
%Checkboxes  
       handles.BLFit=uicontrol('Style','checkbox',...  
       'units', 'centimeters','Position', [x y-4*dely 2.3*dx dy],...
       'ForeGroundColor','k','String','Correct Beamlines',...
       'ToolTipString','Include photon BPMs in fit',...	
       'FontSize',8,'FontWeight','demi',...
       'Callback','sofbgui(''BeamlineFit'')');
       set(handles.BLFit,'Enable','off');
   
       handles.RFFit=uicontrol('Style','checkbox',...  
       'units', 'centimeters','Position', [x y-5*dely 2.3*dx dy],...
       'ForeGroundColor','k','String','Correct RF Frequency',...
       'ToolTipString','Include RF frequency in fit',...	
       'FontSize',8,'FontWeight','demi','Value',1,...
       'Callback','sofbgui(''RFFit'')');

sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);

%**************************************************************        
case 'CalcInverse'
%**************************************************************        
%SVD the response matrix, load RSP structures

[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

%...loop over planes
for plane=1:2
    
%...electron bpms
blist=BPM(plane).ifit;                               %...electron BPM indices from total list
clist=COR(plane).ifit;                               %...corrector indices from total list
c=RSP(plane).c(blist,clist);                         %...compress total matrix on fit indices
wt=diag(BPM(plane).wt(blist));                       %...align bpm weights on diagonal
c=wt*c;                                              %...BPM-weight response matrix

%calculate corrector pattern for dispersion - before appending photon BPMs
COR(plane).disp=pinv(c)*BPM(plane).disp(blist);

%...photon bpms
%NOTE: Always calculate inverse with all potential beamlines (BL(plane).ifit=find(BLOpen.status in BootSOFB))
%      if beamline shutter closes, component of BL.Err will be set to '0.0' in CorrectOrbit
if SYS.photon==1 & plane==2 & ~isempty(BL(plane).ifit)               %...only vertical photon BPMs
plist=BL(plane).ifit;                                %...photon BPM list
cp=RSP(plane).cp(plist,clist);                       %...compress total matrix on fit indices
wt=diag(BL(plane).wt(plist));                        %...photon bpm weights on diagonal
cp=wt*cp;                                            %...weight matrix before inversion
c=[c; cp];                                           %...concatenate photon response matrix

% %...for each beamline closed subtract one singular value
% nopen=length(BL(2).iopen);
% nlines=size(BL(2).name,1);
% nsvd=RSP(2).nsvd - (nlines - nopen);
end

%...perform SVD on total matrix
[u,s,v] = svd(c);    %A=USV'   A-1=VU'/S
RSP(plane).u=u;
RSP(plane).s=s;
RSP(plane).v=v;
RSP(plane).fit=1;


%...compute maximum number of singular values
mx=s*ones(length(clist),1);                    %...max number singular values
RSP(plane).nsvdmx=length(mx(find(mx)));              %...reject zeros

%...limit maximum number of singular values
ncor=length(clist);
mx=RSP(plane).s*ones(ncor,1);                        %...max number singular values/reject zeros
RSP(plane).nsvdmx=length(mx(find(mx)));
if RSP(plane).nsvd>RSP(plane).nsvdmx
   RSP(plane).nsvd=RSP(plane).nsvdmx;
end

%...apply SVD tolerance method if requested
if RSP(plane).svdtol~=0                              %...use tolerance method if specified
s=diag(s);
RSP(plane).nsvd=max(find(s/s(1)>=tol));
  if RSP(plane).nsvd<=0
    disp('   Warning: no singular values requested in CalcInverse');
    RSP(plane).fit=0;                                     %valid fit flag
    return
  end
end

end %loop over planes

sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);

%**************************************************************        
case 'TimerTryCatch'
%**************************************************************
%...callback of the SOFBtimer
%...use try/catch in case mca fails (no hard crash)

try
    sofblib('CorrectOrbit');
catch
    [handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');
    disp(['Warning: unable to correct orbit    '  datestr(now,0)]);
    SYS.nerror=SYS.nerror+1;
    sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);
    if SYS.nerror>SYS.nerrormax
    sofbgui('StopFlag')
    end
end

%**************************************************************        
case 'CorrectOrbit'
%**************************************************************
%callback of the SOFBtimer

[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

%...check if stop requested
if SYS.stop==1   
    sofbgui('StopFlag'); 
    return
end

%...cycle through both planes
for plane=1:2
    
%...read BPMs
val=getam(BPM(plane).family);
BPM(plane).act(BPM(plane).status)=val(BPM(plane).goodindex);
  
%...check if orbit shift within spec
iok=1;
iok=sofblib('CheckBPMDeviations');
if ~iok
    sofbgui('StopFlag');
    return
end

%...read photon beamlines
%...NOTE: use full DeviceList because shutters open and close over time
if SYS.photon==1 & plane==2 & ~isempty(BL(plane).ifit)               %...only vertical photon BPMs
  blopen=getam('BLOpen',BL(2).DevList);              %0 or 1 for beamline shutters
  iclosed=find(~blopen);                             %indices of closed beamlines
  BL(2).Err=getam('BLErr',BL(2).DevList);            %acquire error signals
  BL(2).Err(iclosed)=0;                              %zero out error on all closed beamlines
  sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);
%...check if photon BPM readings within spec
  iok=1;
  iok=sofblib('CheckPhotonBPMDeviations');
  if ~iok
    sofbgui('StopFlag');
    return
  end
end

%...read corrector values
  COR(plane).act(COR(plane).status)=getsp(COR(plane).family);
  sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);
 
%...check DCCT within spec
iok=1;
iok=sofblib('CheckDCCT');
if ~iok
    sofbgui('StopFlag');
    return
end

%...check for SOFBSetDisable
SOFBSetDisable=getpv('SPEAR:SOFBSetDisable');

%...Correct RF frequency
if SYS.rf==1 & plane==1 & ~SOFBSetDisable
   sofblib('CorrectRFFrequency');    %steps rf frequency
end
  
%...backsubstitute to calculate corrector pattern
   sofblib('BackSubstitute',plane);
  
%...remove dispersion-generating component from correctors (does not set correctors)


   if plane==1 & SYS.rfcor==1
       sofblib('RemoveRFCorrectors'); 
   end
  
  [handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

%...check correctors within spec
iok=1;
iok=sofblib('CheckCORDeviations',plane);
if ~iok
    sofbgui('StopFlag');
    return
end

%...set correctors
%disp(['setting correctors in ' COR(plane).plane ' plane'])
if SYS.setsp & ~SOFBSetDisable
  setsp(COR(plane).family,COR(plane).NewSP,COR(plane).ifit);
elseif plane==1            %only report no correctors set once
  disp(['Warning: no correctors set:   ' datestr(now,0)])
end

pause(0.1);
SYS.nerror=0;    %try/catch counter
sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);
  
end   %...end plane loop

[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

%...advance cycle indicator
SYS.cycle=SYS.cycle+1;
str=['cycle: ' num2str(SYS.cycle) '                 ' datestr(now,0)];
set(handles.Cycle,'String',str);

if SYS.setsp & ~SOFBSetDisable
set(handles.Cycle,'BackGroundColor','g');
else
set(handles.Cycle,'BackGroundColor','y');
end

set(handles.Stop,'Enable','on');
sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);

setpv('SPEAR:SOFBNumCycle',SYS.cycle);    %cycle number in EPICS

%...check if stop requested
if SYS.stop==1   
    sofbgui('StopFlag'); 
    return
end

if SYS.timermode==0;
sofbgui('Stop');
end

%**************************************************************        
case 'CorrectRFFrequency'
%**************************************************************        
%...remove dispersion component

[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');


ifit=BPM(1).ifit;
act=BPM(1).act(ifit);
des=BPM(1).des(ifit);
dispersion=BPM(1).disp(ifit);

num=-(act-des)'*dispersion;                               %project orbit shift into dispersion
den=dispersion'*dispersion;                               %normalize 
BPM(1).dispcoeff=num/den;                                 %scalar projection
BPM(1).drf=BPM(1).dispcoeff*BPM(1).disprf;                %rf shift

fract=BPM(1).rffract;
if abs(BPM(1).drf)>SYS.rfmin;
  BPM(1).drf=fract*BPM(1).drf;
  BPM(1).rffit(ifit)=BPM(1).dispcoeff*BPM(1).disp(ifit);    %predicted orbit shift
  disp(['stepping rf frequency by: ' num2str(1e6*BPM(1).drf) ' Hz     ''' datestr(now,0) ''' ; ...']);
  
  if SYS.setsp
    steprf(BPM(1).drf,'hardware');
  else
    disp('Warning: no rf set')
    BPM(1).rffit=zeros(BPM(1).ntbpm,1);                       %no change
  end

else
  BPM(1).rffit=zeros(BPM(1).ntbpm,1);                       %no change
end
    

sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);

%**************************************************************        
case 'RemoveRFCorrectors'
%**************************************************************        
%...remove corrector RF component 

[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

COR(1).rffit=zeros(COR(1).ntcor,1);                %initialize to zero

cdisp=COR(1).disp;                                 %COR(1).disp compressed

num=COR(1).NewSP'*cdisp;                           %project total corrector pattern into dispersion corrector pattern
den=cdisp'*cdisp;                                  %normalize 

COR(1).dispcoeff=num/den; 
COR(1).dispfit=COR(1).dispcoeff*COR(1).disp;      %corrector adjustment

%scalar projection
COR(1).NewSP=COR(1).NewSP - COR(1).dispfit; %subtract off dispersion component

sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);

%**************************************************************        
case 'BackSubstitute'
%**************************************************************        
%assumes etaoff has already been called

[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');
plane=varargin{1};

%use BPM.ifit and COR.ifit elements of response matrix

%check for valid fit
if RSP(plane).fit==0 
    disp('   Warning: fit flag zero in BackSubstitute');
    return; 
end 

%check for no singular values requested          
nsvd=round(RSP(plane).nsvd);
if nsvd==0
    COR(plane).NewSP=COR(plane).act(COR(plane).ifit)    
    sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);
    return
end

%...transpose orbit eigenvectors (u)
ut=RSP(plane).u(:,1:nsvd)';

%...electron BPM orbit
BPM(plane).fit=BPM(plane).rffit;                  %initial fit value is dispersion component                   
act=BPM(plane).act(BPM(plane).ifit);              %...actual BPM orbit
rffit=BPM(plane).rffit(BPM(plane).ifit);          %...dispersion component
des=BPM(plane).des(BPM(plane).ifit);              %...desired orbit
orb=act-des-rffit;
wt=diag(BPM(plane).wt(BPM(plane).ifit));          %...bpm weights on diagonal
orb=wt*orb;

%..photon BPM component
if SYS.photon==1 & plane==2 & ~isempty(BL(plane).ifit)               %...only vertical photon BPMs
porb=BL(plane).Err(BL(plane).ifit);               %...actual photon BPM orbit, ifit=BLErr.status in BootSOFB
%offset=0.3;
%porb=porb-offset;
pwt=diag(BL(plane).wt(BL(plane).ifit));           %...photon bpm weights on diagonal
porb=pwt*porb;
orb=[orb; porb;];
end

%..weight matrix before inversion
%disp(['number of singular values ' num2str(nsvd)])
utorb=-ut*orb;                                    %...multiply residual orbit on inverse u-matrix
invs=inv(RSP(plane).s(1:nsvd,1:nsvd));            %...clip singular value matrix to nsvd values
wutorb=invs*utorb;                         
COR(plane).fit=zeros(length(COR(plane).ifit),1);
COR(plane).fit=RSP(plane).v(:,1:nsvd)*wutorb;     %...compressed, row number=corrector number
COR(plane).NewSP=COR(plane).act(COR(plane).ifit)+COR(plane).fract*COR(plane).fit;

BPM(plane).fit=RSP(plane).c(:,COR(plane).ifit)*COR(plane).fit+BPM(plane).rffit;                  %add dispersion component, evaluate at all bpms

if plane==2 & ~isempty(BL(plane).ifit)
    BL(plane).fit=RSP(plane).cp(:,COR(plane).ifit)*COR(plane).fit;
end

sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);

%**************************************************************        
case 'CheckBPMDeviations'
%**************************************************************        
%check BPM readings within spec

[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

    %check sum signal for NaN
    devlist=getlist(BPM(1).family,0);
    devlist=devlist(BPM(1).status,:);
    BPM(1).bpmsum= getbpmspear('Sum',devlist);
    notok=find(isnan(BPM(1).bpmsum));
    if ~isempty(notok)
        indx=BPM(plane).status(notok);
        for ib=1:length(indx)
            device=elem2dev(BPM(plane).family,indx(ib));
            disp(['Warning: BPM device [' num2str(device(1)) ',' num2str(device(2))  '] Sum has NaN value']);
        end
        varargout{1}=0;
        SYS.trip=1;
        ts = datestr(now,0);
        save 'BPMSumNaNLog' ts SYS BPM BL COR RSP 
    end

varargout{1}=1;
for plane=1:2
    ref=BPM(plane).ref(BPM(plane).status);
    act=BPM(plane).act(BPM(plane).status);
    dev=BPM(plane).dev;
    %check for out of range
    notok=find(abs(act-ref)>dev);
    if ~isempty(notok)
        indx=BPM(plane).status(notok);
        for ib=1:length(indx)
            device=elem2dev(BPM(plane).family,indx(ib));
            disp(['Warning: ' BPM(plane).family ' device [' num2str(device(1)) ',' num2str(device(2))  '] out of range']);
        end
        varargout{1}=0;
        SYS.trip=1;
        ts = datestr(now,0);
        save 'BPMOutofRangeLog' ts SYS BPM BL COR RSP 
    end
    
    %check xy for NaN
    notok=find(isnan(act));
    if ~isempty(notok)
        indx=BPM(plane).status(notok);
        for ib=1:length(indx)
            device=elem2dev(BPM(plane).family,indx(ib));
            disp(['Warning: ' BPM(plane).family ' device [' num2str(device(1)) ',' num2str(device(2))  '] has NaN value']);
        end
        varargout{1}=0;
        SYS.trip=1;
        ts = datestr(now,0);
        save 'BPMXYNaNLog' ts SYS BPM BL COR RSP 
    end
    

end

sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);

%******************************
case 'SelectBPMx'
%******************************
[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');
status=find(getfamilydata('BPMx','Status'))

newlist=editlist(getlist('BPMx',status),'BPMx');
BPM(1).badindex=[setxor(dev2elem('BPMx',newlist),1:length(dev2elem('BPMx',orbdevlist)))]';

BPM(1).status(dev2elem('BPMx',BPM(1).badindex))=0;                                   %set status=0 for no-fit bpms
BPM(1).status=find(status);                                                          %indices of status=1 bpms
BPM(1).ifit=BPM(1).status;                                                           %indices of BPMs for fitting

BPM(1).goodindex=sort(findrowindex(temp,orbdevlist));

% %**************************************************************        
% case 'RemoveBeamlineBPM'
% %**************************************************************        
% %remove BPMs associated with beamlines
% [handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');
% 
% %build devicelist of BPMs associated with beamlines
% blbpmlist=[];
% for k=1:length(BL(2).ifit)
%     blbpmlist=[blbpmlist; BL(2).bpmout(BL(2).ifit(k),:)];
% end
% blbpmlist=sort(blbpmlist,1);
% 
% status=getfamilydata('BPMy','Status');           %full length status vector
% if ~isempty(blbpmlist)
% elemlist=dev2elem('BPMy',blbpmlist);
% status(elemlist)=0;                              %set status=0 for bpms associated with beamlines
% end
% BPM(2).status=find(status);                      %indices of status=1 bpms
% BPM(2).ifit=BPM(2).status;                       %indices of BPMs for fitting
% 
% %SETXOR(A,B) returns values not in the intersection of A and B.
% BPM(2).goodindex=[setxor(BPM(2).mastergoodindex,elemlist)];
% 
% sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);
% 
% %**************************************************************        
% case 'ReplaceBeamlineBPM'
% %**************************************************************        
% %replace BPMs associated with beamlines
% [handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');
%     BPM(2).ifit     =BPM(2).masterifit;
%     BPM(2).status   =BPM(2).masterstatus;
%     BPM(2).goodindex=BPM(2).mastergoodindex;
% sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);


%**************************************************************        
case 'CheckPhotonBPMDeviations'
%**************************************************************        
%check BPM readings within spec

[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

varargout{1}=1;
plane=2;
     act=BL(plane).Err(BL(plane).ifit);
     dev=BL(plane).dev;
     %check for out of range
     notok=find(abs(act)>dev);
     if ~isempty(notok)
         indx=BL(plane).status(notok);
         for ib=1:length(indx)
             disp(['Warning: ' BL(plane).family ' index ' num2str(indx(ib)) ' out of range']);
         end
         varargout{1}=0;
         SYS.trip=1;
         ts = datestr(now,0);
         save 'BLOutofRangeLog' ts SYS BPM BL COR RSP 
     end
     %check for NaN
     notok=find(isnan(act));
     if ~isempty(notok)
         indx=BL(plane).status(notok);
         for ib=1:length(indx)
             disp(['Warning: ' BL(plane).family ' index ' num2str(indx(ib)) ' has NaN value']);
         end
         varargout{1}=0;
         SYS.trip=1;
         ts = datestr(now,0);
         save 'BLNaNLog' ts SYS BPM BL COR RSP 
     end

sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);

%**************************************************************        
case 'CheckCORDeviations'
%**************************************************************        
%check COR readings within spec

varargout{1}=1;
[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

plane=varargin{1};

    ref=COR(plane).ref(COR(plane).status);
    NewSP=COR(plane).NewSP;
    dev=COR(plane).dev;

%check for NaN
    notok=find(isnan(NewSP));
    if ~isempty(notok)
        indx=COR(plane).status(notok);
        for ib=1:length(indx)
            device=elem2dev(COR(plane).family,indx(ib));
            disp(['Warning: ' COR(plane).family ' device [' num2str(device(1)) ',' num2str(device(2))  '] has NaN value']);
        end
        varargout{1}=0;
        SYS.trip=1;
        ts = datestr(now,0);
        save 'CORNaNLog' ts SYS BPM BL COR RSP 
    end
    
%check for maximum deviation
    notok=find(abs(NewSP-ref)>dev);
    if ~isempty(notok)
        indx=COR(plane).status(notok);
        for ib=1:length(indx)
            device=elem2dev(COR(plane).family,indx(ib));
            disp(['Warning: ' COR(plane).family ' device [' num2str(device(1)) ',' num2str(device(2))  ']  deviation out of range']);
        end
        varargout{1}=0;
        SYS.trip=1;
        ts = datestr(now,0);
        save 'CORMaxDevLog' ts SYS BPM BL COR RSP 
    end

%check for total current
   [notok, List] = checklimits(COR(plane).family, 1.1*COR(plane).NewSP, elem2dev(COR(plane).family,COR(plane).status));
    if notok>0
        indx=COR(plane).status(List);
        for ib=1:length(indx)
            device=elem2dev(COR(plane).family,indx(ib));
            disp(['Warning: ' COR(plane).family ' device [' num2str(device(1)) ',' num2str(device(2))  '] total out of range']);
        end
        varargout{1}=0;
        SYS.trip=1;
        ts = datestr(now,0);
        save 'CORTotalLog' ts SYS BPM BL COR RSP 
    end

sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);

%**************************************************************        
case 'CheckDCCT'
%**************************************************************        
%check DCCT reading within spec

varargout{1}=1;
[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

if strcmpi(getfamilydata('BPMx','Monitor','Mode'),'ONLINE')
  Current = getpv('SPEAR:BeamCurrAvg ');
    if Current<SYS.mincur
      disp(['Warning: Current below minimum range: ' num2str(Current) ' out of limit ' num2str(SYS.mincur) ' ma']);
      varargout{1}=0;
      SYS.trip=1;
    end
end
%varargout{1}=1;  %for debug
sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);

%**************************************************************        
case 'GetStructures'
%**************************************************************        
%retrieve structures from setappdata

SOFB=getappdata(0,'SOFB_structures');
varargout{1}=SOFB.handles;
varargout{2}=SOFB.SYS;
varargout{3}=SOFB.BPM;
varargout{4}=SOFB.BL;
varargout{5}=SOFB.COR;
varargout{6}=SOFB.RSP;

%**************************************************************        
case 'SetStructures'
%**************************************************************        
%put structures in appdata

SOFB.handles=varargin{1};
SOFB.SYS=varargin{2};
SOFB.BPM=varargin{3};
SOFB.BL= varargin{4};
SOFB.COR=varargin{5};
SOFB.RSP=varargin{6};
setappdata(0,'SOFB_structures',SOFB);

%**************************************************************   
otherwise
%**************************************************************   
disp(['Warning: CASE not found in sofblib ' action]);

end  %end switchyard
