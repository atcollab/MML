%=============================================================
function varargout = respgui(action, varargin)
%=============================================================

%globals
global BPM BL COR RSP SYS
orbfig = findobj(0,'tag','orbfig');
plane=SYS.plane;
%RSP=getappdata(0,'RSP');

%...PlotSVD_Init//PlotSVD
%...SolveSystem
%...BackSubSystem//FitOff
%...//EditSVD//UpdateFit
%...RFToggle//EtaOff//BumpOff

switch action

%==========================================================
case 'PlotSVD_Init'                  % *** PlotSVD_Init ***
%==========================================================
%blue, solid dynamic semilog-line for singular value plot.
set(SYS.handles.ahsvd,'Color',[1 1 1],'NextPlot','add');
   %           'ButtonDownFcn','respgui(''SVDotActive'')');

set(orbfig,'currentaxes',SYS.handles.ahsvd)

SYS.handles.svdplot=plot(ones(1,10),'LineStyle','-','Color','b'); %does this tag axes or line?
SYS.handles.lhsvd=SYS.handles.svdplot;

SYS.handles.lhdot=line('parent',SYS.handles.ahsvd,...
      'XData',0,'YData',0,...
      'ButtonDownFcn','respgui(''SVDotActive'');',...
      'Marker','o','MarkerSize',8,'MarkerFaceColor','r');


%=============================================================
case 'SVDotActive'                       % *** SVDotActive ***
%=============================================================
%used if mouse clicks on SVD plot dot or anywhere in SVD window
%activate window-button-motion
set(orbfig,'WindowButtonMotionFcn','respgui(''MoveDot'');',...
		'WindowButtonUpFcn','respgui(''DotUp'')');

%==========================================================
case 'MoveDot'                            % *** MoveDot ***
%==========================================================
%The callback of the singular value plot dot drag
cpa = get(SYS.handles.ahsvd,'CurrentPoint');
RSP(plane).nsvd=round(cpa(1));

%check for out-of-range drag above
if RSP(plane).nsvd>RSP(plane).nsvdmx
   RSP(plane).nsvd=RSP(plane).nsvdmx;
   %orbgui('LBox',...
         %['Warning: number of singular values exceeds maximum: ',...
           %num2str(RSP(plane).nsvdmx)]);
end

%check for out-of-range drag below
if RSP(plane).nsvd<=0
   RSP(plane).nsvd=1;
   %orbgui('LBox','Warning: Requested negative number of singular values ');
end

setappdata(0,'RSP',RSP);

%re-draw dot
ncor=length(COR(plane).ifit);
if ncor==0 ncor=1; end           %protect against all correctors off
ydat=RSP(plane).s*ones(ncor,1);
indx=RSP(plane).nsvd;
if indx<=0 indx=1; end
set(SYS.handles.lhdot,'Xdata',RSP(plane).nsvd,'YData',ydat(indx));

%==========================================================
case 'DotUp'                            % *** DotUp ***
%==========================================================
respgui('MoveDot');

set(orbfig,'WindowButtonMotionFcn','','WindowButtonUpFcn','');
%update edit boxes
set(SYS.handles.svdedit,'String',num2str(RSP(plane).nsvd));

orbgui('RefreshOrbGUI');

%==========================================================
case 'PlotSVD'                             % ***PlotSVD ***
%==========================================================
%blue, solid dynamic line for singular value plot
set(orbfig,'currentaxes',SYS.handles.ahsvd);
if RSP(plane).nsvdmx>1 & RSP(plane).fit==1 %...must have fit valid before plotting
[r c]=size(RSP(plane).s);
k=min(r,c);
k=RSP(plane).nsvdmx;
ncor=length(COR(plane).ifit);
ydat=RSP(plane).s*ones(ncor,1);
set(SYS.handles.lhsvd,'Xdata',[1:k],'YData',ydat(1:k));

%red dot
indx=RSP(plane).nsvd;
if indx<=0 indx=1; end
set(SYS.handles.lhdot,'Xdata',RSP(plane).nsvd,'YData',ydat(indx));
else %fit not valid
set(SYS.handles.lhsvd,'Xdata',0:10,'YData',ones(1,11));
%red dot
set(SYS.handles.lhdot,'Xdata',0,'YData',1);
end

%==========================================================
case 'SolveSystem'                    % *** SolveSystem ***
%==========================================================
%solve the system with requested technique (SYS.algo)
% 1. check that bpms and correctors selected for fitting
% 2. build total response matrix (orbit, photon, dispersion)
% 3. build total constraint vector (orbit, photon, dispersion)
% 4. check dimensions of matrix, constraints
% 5. perform inversion
% 6. backsubstitute

%check for no variables or constraints
if isempty(BPM(plane).ifit) | isempty(COR(plane).ifit)
RSP(plane).fit=0;
BPM(plane).fit=zeros(length(BPM(plane).act),1);
COR(plane).fit=COR(plane).act;
setappdata(0,'RSP',RSP);
setappdata(0,'BPM',BPM);
setappdata(0,'COR',COR);

orbgui('LBox','Warning: select BPMs and CORs first');
disp('Warning: select beam position monitors and correctors first');
return
end

%check for no singular values requested          
if RSP(plane).nsvd<=0 & RSP(plane).svdtol<=0
disp('   Warning: no singular values or tolerance requested in svdfit');
return
end

%========================
   switch SYS.algo
%========================    
case 'SVD'   %use singular value technique to solve system

%...corrector set
corlist=COR(plane).ifit;
corwt=COR(plane).wt(corlist);

%...remove dispersion component if rfflag true
if RSP(plane).rfflag==1 & plane==1                  %...rf correction flag
respgui('EtaOff');                                  %...calculate dispersion component

%...check that frequency change > 1 Hz (units are MHz)
   if abs(BPM(plane).drf*COR(plane).fract) < 1e-6    %...multiply by fract - this is the amount that will be set online
      BPM(plane).rffit=zeros(length(BPM(plane).z),1);     %...set rf component to zero
      BPM(plane).drf=0;                                   %...set frequency step to zero
      setappdata(0,'BPM',BPM);
   end
   
else
BPM(plane).rffit=zeros(length(BPM(plane).z),1);     %...set rf component to zero
BPM(plane).drf=0;                                   %...set frequency step to zero
setappdata(0,'BPM',BPM);
end
%[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

%...assemble electron BPM orbit and response matrix (compressed)
eBPMlist=BPM(plane).ifit;                                 %...electron BPM list
eBPMval =BPM(plane).act-BPM(plane).des-BPM(plane).rffit;  %...actual orbit minus reference/desired orbit minus rf component
eBPMval =diag(BPM(plane).wt)*eBPMval(:);                  %...apply weights
eBPMval =eBPMval(eBPMlist);                               %...compress residual orbit vector
BPMval=eBPMval;

c=RSP(plane).c(eBPMlist,corlist);                    %...use only selected fit indices
wt=diag(BPM(plane).wt(eBPMlist));                    %...bpm weights on diagonal
c=wt*c;                                              %...weight matrix before inversion

%...assemble photon BPM orbit and response matrix (compressed)
if plane==2 & ~isempty(BL(plane).ifit)               %...only vertical photon BPMs
pBPMlist=BL(plane).ifit;                             %...photon BPM list
pBPMval =BL(plane).nerr;                             %...photon BPM deviations
pBPMval =diag(BL(plane).wt)*pBPMval(:);              %...apply weights
pBPMval =pBPMval(pBPMlist);                          %...compress residual steering vector
BPMval=[BPMval; pBPMval];                            %...concatenate electron and photon BPM error signals

cp=RSP(plane).cp(pBPMlist,corlist);                  %...use only selected fit indices
wt=diag(BL(plane).wt(pBPMlist));                     %...photon bpm weights on diagonal
cp=wt*cp;                                            %...weight matrix before inversion
c=[c; cp];                                           %...concatenate photon response matrix

%...for each beamline that has been closed subtract one singular value
nopen=length(BL(2).iopen);
nlines=size(BL(2).name,1);
nsvd=RSP(2).nsvd - (nlines - nopen);
end

%...perform SVD and backsubstitution

%...check for correct dimensioning
sz=size(c);
if sz(1)~=length(BPMval) | sz(2)~=length(corlist);
disp('   Warning: incorrect matrix or element list dimensions');
RSP(plane).fit=0;                                     %valid fit flag
return
end

%...perform decomposition
[u,s,v] = svd(c);    %A=USV'   A-1=VU'/S
RSP(plane).u=u;
RSP(plane).s=s;
RSP(plane).v=v;

%...compute maximum number of singular values
mx=s*ones(length(corlist),1);                        %...max number singular values
RSP(plane).nsvdmx=length(mx(find(mx)));              %...reject zeros

%...limit maximum number of singular values
ncor=length(corlist);
mx=RSP(plane).s*ones(ncor,1);                        %...max number singular values/reject zeros
RSP(plane).nsvdmx=length(mx(find(mx)));
if RSP(plane).nsvd>RSP(plane).nsvdmx
   RSP(plane).nsvd=RSP(plane).nsvdmx;
end
nsvd=RSP(plane).nsvd;

if RSP(plane).svdtol~=0                              %...use tolerance method if specified
s=diag(s);
msvd=max(find(s/s(1)>=tol));
  if msvd<=0
    disp('   Warning: no singular values requested in svdfit');
    RSP(plane).fit=0;                                     %valid fit flag
    return
  end
end

%...backsubstitute
Ut=u(:,1:nsvd)';                                %u-transpose, with desired number eigenvectors
UtBPM=-Ut*BPMval;                               %multiply monitor set on inverse U-matrix  NOTE NEGATIVE SIGN
InvS=inv(s(1:nsvd,1:nsvd));                     %clip singular value matrix to nsvd values
SUtBPM=InvS*UtBPM;                              %compute product (inverse-S)*(U-transpose)*(DelMon)
corfit=v(:,1:nsvd)*SUtBPM;                      %compute corrector values

%NOTE: fraction scalar only used at time of corrector application

%...remove rf component from correctors
if RSP(plane).rfcorflag==1 & plane==1                  %...rf correction flag
   %...compute corrector component required to correct dispersion  NOTE: COR.disp is compressed
   c=RSP(plane).c;
   blist=BPM(plane).ifit;
   clist=COR(plane).ifit;
   act=COR(plane).act(clist);
   COR(plane).disp=pinv(c(blist,clist))*BPM(plane).disp(blist);     %...compressed
   cdisp=COR(plane).disp;
   
   %...remove rf component from initial set of correctors (COR(plane).act)
   num=act'*cdisp;                                         %...project initial/actual corrector pattern into dispersion corrector pattern
   den=cdisp'*cdisp;                                       %...normalize 
   COR(plane).actdisp=num/den; 
   COR(plane).actdisp=COR(plane).actdisp*COR(plane).disp;  %...dispersion component in initial/actual correctors
   
   %...remove rf component from fitted correctors (COR(plane).fit)
   num=corfit'*cdisp;                                      %...project fitted corrector pattern into dispersion corrector pattern
   COR(plane).fitdisp=num/den;    
   COR(plane).fitdisp=COR(plane).fitdisp*COR(plane).disp;  %...dispersion component in fitted correctors
   corfit=corfit-COR(plane).actdisp-COR(plane).fitdisp;
else
   COR(plane).actdisp=0*corfit;                            %...no dispersion removal
   COR(plane).fitdisp=0*corfit;                            %...no dispersion removal
end

%...load corrector pattern into main structure
COR(plane).fit=corfit;

%...compute predicted orbit INCLUDING rf component removed from correctors and rf frequency adjustment
BPM(plane).fit=RSP(plane).c(:,corlist)*corfit - BPM(plane).rffit;        %...evaluate at ALL BPMS: NOTE NEGATIVE SIGN ON RF COMPONENT

%...compute predicted motion at photon beamlines
if plane==2 & ~isempty(BL(plane).ifit) 
BL(plane).fit=RSP(plane).cp(:,corlist)*corfit;       %...evaluate at ALL BPMS
end

%...set fitting flag
RSP(plane).fit=1;


setappdata(0,'BPM',BPM);
setappdata(0,'COR',COR);
setappdata(0,'RSP',RSP);

otherwise
disp(['Warning: no CASE found in SolveSystem: ' SYS.algo]);
end  %end SYS.algo switchyard

%==========================================================
case 'SVDEdit'                            % *** SVDEdit ***
%==========================================================
%callback of the singular value edit box.

val=str2double(get(SYS.handles.svdedit,'String'));

if isnan(val) | ~isnumeric(val) | ~length(val)==1
  % flush the bad string out of the edit; replace with current value:
  set(SYS.handles.svdedit,'String',num2str(RSP(plane).nsvd));
  orbgui('LBox','Warning: Invalid entry # singular values');
  disp('Warning: Invalid SVD entry.');
  return; 
else

RSP(plane).nsvd=round(val);

if RSP(plane).nsvd==0        %don't allow zero singular values
   RSP(plane).nsvd=1; 
   set(SYS.handles.svdedit,'String',num2str(RSP(plane).nsvd));
end

if RSP(plane).nsvd>RSP(plane).nsvdmx
   orbgui('LBox','Warning: # singular values exceeds maximum');
   disp(['Warning: number of singular values exceeds maximum: ',num2str(RSP(plane).nsvdmx)])
   RSP(plane).nsvd=RSP(plane).nsvdmx;
   set(SYS.handles.svdedit,'String',num2str(RSP(plane).nsvd));
end
 
setappdata(0,'RSP',RSP);

respgui('MoveSVDDot');
orbgui('RefreshOrbGUI');

end

%============================================================
case 'SVDSlider'                            % *** SVDSlide ***
%============================================================
%The callback of the singular value slider.
%
val=(get(SYS.handles.svdslide,'Value'));

RSP(plane).nsvd=round(val);

if RSP(plane).nsvd==0
   RSP(plane).nsvd=1;
end

if RSP(plane).nsvd>RSP(plane).nsvdmx
   disp(['Warning: number of singular values exceeds maximum: ',num2str(RSP(plane).nsvdmx)])
   RSP(plane).nsvd=RSP(plane).nsvdmx;
   set(SYS.handles.svdslide,'Value',RSP(plane).nsvd);
end
    
set(SYS.handles.svdedit,'String',num2str(RSP(plane).nsvd));
respgui('MoveSVDDot');
orbgui('RefreshOrbGUI');

%==========================================================
case 'MoveSVDDot'                       % ***MoveSVDDot ***
%==========================================================
if isempty(COR(plane).ifit) return; end
ncor=length(COR(plane).ifit);  %length of column
yd=RSP(plane).s*ones(ncor,1);  %matrix to column
indx=RSP(plane).nsvd;

if indx<=0 indx=1; 
end
if RSP(plane).nsvd>ncor 
   RSP(plane).nsvd=ncor;
   indx=ncor
end
if RSP(plane).fit==1
   set(SYS.handles.lhdot,'Xdata',RSP(plane).nsvd,'YData',yd(indx));
end

setappdata(0,'RSP',RSP);

%==========================================================
case 'RFToggle'                            % *** RFToggle ***
%==========================================================
%callback of the rf component toggle radio button
%radio button toggles state and then executes callback
%hence, this routine finds the new state
h1=SYS.handles.rftoggle;   
val=get(h1,'Value');
if val==1                % state was just toggled 'on'
RSP(plane).rfflag=1;
else
RSP(plane).rfflag=0;     % state was just toggled 'off'
BPM(plane).drf=0.0;
end

setappdata(0,'RSP',RSP);

respgui('SolveSystem',SYS.algo);
respgui('UpdateFit');

%==========================================================
case 'RFCORToggle'                            % *** RFCORToggle ***
%==========================================================
%callback of the rf component toggle radio button
%radio button toggles state and then executes callback
%hence, this routine finds the new state
h1=SYS.handles.rfcortoggle;   
val=get(h1,'Value');
if val==1                % state was just toggled 'on'
RSP(plane).rfcorflag=1;
else
RSP(plane).rfcorflag=0;     % state was just toggled 'off'
end

setappdata(0,'RSP',RSP);

respgui('SolveSystem',SYS.algo);
respgui('UpdateFit');

%==========================================================
case 'EtaOff'                         % *** EtaOff ***
%==========================================================
% inner product of residual orbit and rf orbit
% normalize to rf orbit
% calculate predicted orbit shift and rf frequency shift

BPM(plane).rffit=zeros(length(BPM(plane).z),1);     % initialize rf fit component to zero
BPM(plane).drf=0;                                   % initialize frequency shift to zero

% project orbit into rf component
res  = BPM(plane).act(BPM(plane).ifit)-BPM(plane).des(BPM(plane).ifit);   % residual orbit (actual - desired)
eta = BPM(plane).disp(BPM(plane).ifit);                                   % measured dispersion orbit (mm per unit of rf frequency used in measurement)

num=res'*eta;
den=eta'*eta;
fract=num/den;                                       % scalar projection of orbit into dispersion. Use plus sign later to correct  

BPM(plane).rffit=fract*BPM(plane).disp;              % scale and load predicted rf orbit component (full length vector)
BPM(plane).drf  =fract*BPM(plane).disprf;            % calculated rf frequency shift
  
setappdata(0,'BPM',BPM);

%==========================================================
case 'DisplayRFFit'                         % ***D isplayRFFit ***
%==========================================================
%update prediction for rf component
set(SYS.handles.rftoggle,'String',['RF control          '  num2str(BPM(plane).drf, '%11.3f') ' ' BPM(plane).disprfUnits]);

%==========================================================
case 'DisplayNsvd'                     % ***DisplayNsvd ***
%==========================================================
%update SVD Slider
%                                      'Value',round(RSP(plane).nsvd));
%update SVD Edit Field
set(SYS.handles.svdedit,'String',num2str(RSP(plane).nsvd));

%==========================================================
case 'UpdateFit'                         % ***UpdateFit ***
%==========================================================
%NOTE: to view predicted photon beam positions
%figure  %plot(BL(2).norm(BL(2).ifit) + BL(2).fit(BL(2).ifit))

bpmgui('PlotFit');        %plots orbit fit, updates limits
corgui('PlotFit');        %plots corrector fit (don't need to clear), updates ylimits
respgui('DisplayRFFit');  %display rf frequency shift

if strcmp(SYS.algo,'SVD')
    respgui('PlotSVD');       %...show singular value plot
    respgui('DisplayNsvd');   %...display number of singular values
    respgui('MoveSVDDot');    %...move dot to display number of singular values
%update eigenvector plot
    if RSP(plane).eig(1:2)=='of' | RSP(plane).nsvd==0    %Eigenvector display mode
    set(SYS.handles.lheig,'XData',[],'YData',[]);
    else
    bpmgui('PlotEig');                   %plot matrix column vector
    end
end


%update response matrix plot
if RSP(plane).disp(1:2)=='of'  
set(SYS.handles.lhrsp,'XData',[],'YData',[]);
else
bpmgui('PlotResp');                   %plot matrix column vector
end


%==========================================================
case 'ExternalFitOff'                     %...ExternalFitOff
%==========================================================
plane=varargin(1);
plane=str2num(plane{1});           %define requested plane
RSP(plane).fit=0;                  %fit not valid

switch SYS.algo   
case 'SVD'
    RSP(plane).nsvd=0;
   setappdata(0,'RSP',RSP);
end

%==========================================================
case 'FitOff'                             %...FitOff
%==========================================================
%clear graphics because fit invalid
plane=varargin(1);
plane=str2num(plane{1});           %define requested plane

RSP(plane).fit=0;                  %fit not valid
RSP(plane).u=[];
RSP(plane).s=[];
RSP(plane).v=[];
setappdata(0,'RSP',RSP);

set(SYS.handles.rftoggle,'String',['drf:  ' '0.0']);
%zero out fitting variables
BPM(plane).fit=zeros(size(BPM(plane).name,1),1);
setappdata(0,'BPM',BPM);

ncor=length(COR(plane).ifit);
COR(plane).fit=zeros(ncor,1);  %COR.fit is compressed
COR(plane).sav=COR(plane).fit;            %zero out save vector
setappdata(0,'COR',COR);

bpmgui('ClearPlots');          %remove all bpm fitting plots
corgui('ClearFit');            %remove all cor fitting plots
corgui('ylimits');

switch SYS.algo   
case 'SVD'
    %RSP=getappdata(0,'RSP');
    RSP(plane).nsvdmx=1;
    RSP(plane).nsvd=1;                                            %keep one singular value - all correctors off then one on
    setappdata(0,'RSP',RSP);
    set(SYS.handles.svdedit,'String',num2str(1));                 %SVD display box
    respgui('PlotSVD'); 
end

%==========================================================
case 'DispersionPanel'                   %  DispersionPanel
%==========================================================
%----------------------------------------------------------------
%  create figure
%----------------------------------------------------------------
h = findobj(0,'tag','dispersionpanel');  
if ~isempty(h) 
    delete(h); 
end

[screen_wide, screen_high]=screensizecm;
fig_start = [0.4*screen_wide 0.5*screen_high];
fig_size = [0.5*screen_wide 0.25*screen_high];
%----------------------------------------------------------------
figh=figure('units','centimeters',...                      %...Dispersion Control Figure
        'Position',[fig_start fig_size],...
		'tag','dispersionpanel',... 
		'NumberTitle','off',...
        'Doublebuffer','on',...
        'Visible','On',...
		'Name','Dispersion Fitting Control Panel',...
		'PaperPositionMode','Auto');
        set(figh,'MenuBar','None');
%------------------------------------------------------------------

%Radio Dispersion On/Off
uicontrol('Style','radiobutton',...	                       %Radio Horizontal Dispersion On/Off                               
'units', 'normalize', ...
'Position', [.05 .8 .3 .1], ...
'String','Fit Eta-X',...
'Tag','etaxflag',...
'Value',RSP(1).etaflag,...
'ToolTipString','Fit Horizontal Dispersion',...	
'FontSize',8,'FontWeight','demi',...
'Callback','respgui(''EtaXFlag'')');  

uicontrol('Style','radiobutton',...	                       %Radio Vertical Dispersion On/Off                               
'units', 'normalize', ...
'Position', [.5 .8 .3 .1], ...
'String','Fit Eta-Y',...
'Tag','etayflag',...
'Value',RSP(2).etaflag,...
'ToolTipString','Fit Vertical Dispersion',...	
'FontSize',8,'FontWeight','demi',...
'Callback','respgui(''EtaYFlag'')');  

%Select Horizontal Dispersion Weights
cback=['rload(''GenFig'',BPM(1).name,BPM(1).status,BPM(1).ifit,'];
cback=[cback 'BPM(1).etawt,''Horizontal BPMs for Eta Fitting'',''etaxwt'');'];
%instructions are used during 'load' procedure of rload window
instructions=[...
'   global BPM;',...
'   tlist = get(gcf,''UserData'');',...    
'   BPM(1).etawt=tlist{4};',...
'   setappdata(0,''BPM'',BPM);',...
'   orbgui(''RefreshOrbGUI'');'];

uicontrol('Style','pushbutton',...	                       %Select Horizontal Dispersion Weights                               
'units', 'normalize', ...
'Position', [.05 .65 .3 .1], ...
'String','Select x-BPM Weights',...
'tag','etaxwt',...
'Callback',cback,...
'Userdata',instructions);

%Select Vertical Dispersion Weights
cback=['rload(''GenFig'',BPM(2).name,BPM(2).status,BPM(2).ifit,'];
cback=[cback 'BPM(2).etawt,''Horizontal BPMs for Eta Fitting'',''etaywt'');'];
%instructions are used during 'load' procedure of rload window
instructions=[...
'   global BPM;',...
'   tlist = get(gcf,''UserData'');',...    
'   BPM(2).etawt=tlist{4};',...
'   setappdata(0,''BPM'',BPM);',...
'   orbgui(''RefreshOrbGUI'');'];

uicontrol('Style','pushbutton',...	                       %Select Vertical Dispersion Weights                               
'units', 'normalize', ...
'Position', [.5 .65 .3 .1], ...
'String','Select y-BPM Weights',...
'tag','etaywt',...
'Callback',cback,...
'Userdata',instructions);

%==========================================================
case 'EtaXFlag'                   %  EtaXFlag
%==========================================================
RSP(1).etaflag=0;
h=findobj(gcf,'tag','etaxflag');
val=get(h,'value');
if val==1
    RSP(1).etaflag=1;
    setappdata(0,'RSP',RSP);
end

%==========================================================
case 'EtaYFlag'                   %  EtaYFlag
%==========================================================
RSP(2).etaflag=0;
h=findobj(gcf,'tag','etayflag');
val=get(h,'value');
if val==1
    RSP(2).etaflag=1;
    setappdata(0,'RSP',RSP);
end


%==========================================================
otherwise
disp(['Warning: no CASE found in respgui: ' action]);
end  %end switchyard
