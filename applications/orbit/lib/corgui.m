function varargout = corgui(action, varargin)
%=============================================================
% corgui controls corrector manipulation and plotting for orbit program

%globals
global BPM BL COR RSP SYS
orbfig = findobj(0,'tag','orbfig');
plane=SYS.plane;

switch action
%...//plotcor_init//plotcor//cordown//CORmove//ResetCur


%==========================================================
case 'PlotCor_Init'             % *** PlotCor_Init ***
%==========================================================
%draw patches to create a "bar" plot for the correctors.
set(SYS.handles.ahcor,'Xlim',[0 SYS.xlimax]);    %xlim=get(SYS.handles.ahbpm,'XLim');

%========================================
%initialize for plane that IS NOT default
%========================================
plane=1+mod(plane,2);
SYS.plane=plane;

xd=orbgui('GetAbscissa',SYS,'COR');  %horizontal coordinates for plotting

COR(plane).id=1;        %first corrector selected as default

for ii = 1:size(COR(plane).name,1)
	c = xd(ii);         %horizontal coordinate
    color='k';          %default black if not in status vector
  if ~isempty(find(COR(plane).status==ii)) color='y'; end  %yellow for available
  if ~isempty(find(COR(plane).ifit==ii))   color='g'; end  %green for fit

   %actual corrector strength (green)
	COR(plane).hact(ii,1)=line('parent',SYS.handles.ahcor,'XData',[c],'YData',[0],'Marker','diamond',...
          'MarkerFaceColor',color,'MarkerSize',6,...
		  'tag', ['c' num2str(plane) '_' num2str(ii)],...   %c for corrector
          'ButtonDownFcn','corgui(''CorSelect'')');
   %vertical bar to icon
	COR(plane).hact(ii,2)=line('parent',SYS.handles.ahcor,'XData',[c c],'YData',[0 0],'Color','b');

    %actual+fitted strength (red)
	COR(plane).hfit(ii,1)=line('parent',SYS.handles.ahcor,'XData',[c],'YData',[0],'Marker','o',...
          'MarkerFaceColor','r','MarkerSize',4,...
		  'tag', ['f' num2str(plane) '_' num2str(ii)],...   %f for fit
          'ButtonDownFcn','corgui(''CorSelect'')');
    %vertical bar to icon
	COR(plane).hfit(ii,2)=line('parent',SYS.handles.ahcor,'XData',[c c],'YData',[0 0],'Color','b');
      
    if strcmp(color,'k')    %if status bad make single black dot
        set(COR(plane).hact(ii,1),'MarkerSize',4,'Marker','o');
        set(COR(plane).hfit(ii,1),'MarkerFaceColor','k');
    end

  end
%========================================
%initialize for plane that IS default
%========================================
plane=1+mod(plane,2);    %return to default plane
SYS.plane=plane;

COR(plane).id=1;

xd=orbgui('GetAbscissa',SYS,'COR');  %horizontal coordinates for plotting

for ii = 1:size(COR(plane).name,1)
	c = xd(ii);
    color='k';   %black if not in status vector
  if ~isempty(find(COR(plane).status==ii)) color='y'; end  %yellow for for available 
  if ~isempty(find(COR(plane).ifit==ii))   color='g'; end  %green for fit

   %actual corrector strength (green)
	COR(plane).hact(ii,1)=line('parent',SYS.handles.ahcor,'XData',[c],'YData',[0],'Marker','diamond',...
          'MarkerFaceColor',color,'MarkerSize',6,...
		  'tag', ['c' num2str(plane) '_' num2str(ii)],...
          'ButtonDownFcn','corgui(''CorSelect'')');
    %vertical bar to icon
	COR(plane).hact(ii,2)=line('parent',SYS.handles.ahcor,'XData',[c c],'YData',[0 0]);

    %actual+fitted strength (red)
	COR(plane).hfit(ii,1)=line('parent',SYS.handles.ahcor,'XData',[c],'YData',[0],'Marker','o',...
          'MarkerFaceColor','r','MarkerSize',4,...
		  'tag', ['f' num2str(plane) '_' num2str(ii)],...
          'ButtonDownFcn','corgui(''CorSelect'')');
    %vertical bar to icon
	COR(plane).hfit(ii,2)=line('parent',SYS.handles.ahcor,'XData',[c c],'YData',[0 0]);
    
    if strcmp(color,'k')    %if status bad make single black dot
        set(COR(plane).hact(ii,1),'MarkerSize',4,'Marker','o');
        set(COR(plane).hfit(ii,1),'MarkerFaceColor','k');
    end
end


%set limits on corrector plot
ylim=get(SYS.handles.ahcor,'YLim');
%vertical bar on selected corrector
SYS.handles.lhcid=line('parent',SYS.handles.ahcor,...
      'XData',[xd(COR(plane).id),xd(COR(plane).id)+0.001],...
	  'YData',[ylim(1),ylim(2)],'Color','k');
set(SYS.handles.lhcid,'ButtonDownFcn','corgui(''CorSelect'')');

corgui('ylimits');

%===========================================================
case 'Fract'                                 %*** Fract ***
%===========================================================
%callback of the text box used to set fraction
h1=SYS.handles.fract;
fract=str2double(get(h1,'String'));

if isnan(fract) | ~isnumeric(fract) | ~length(fract)==1
  % flush the bad string out of the edit; replace with current value:
  set(h1,'String',num2str(COR(plane).fract));
  disp('Warning: Invalid fraction entry.');
  orbgui('LBox','Warning: Invalid fraction entry');
  return;
else
  COR(plane).fract = fract;
  %NOTE: fraction scalar only used at time of corrector application
%   respgui('UpdateFit');
%   orbgui('RefreshOrbGUI');
end

%===========================================================
case 'ApplyCorrection'              %*** ApplyCorrection ***
%===========================================================
%Apply orbit correction
if COR(plane).ifit
orbgui('LBox',' Apply correction for current plane');
corgui('ApplyFit');
else
orbgui('LBox',' Correction not valid for current plane');  
end

%===========================================================
case 'ApplyFit'                            %*** ApplyFit ***
%===========================================================
% apply rf correction and corrector fit pattern, both scaled by fract
% 1/31/05 - added rf correction and removal of dispersion component from correctors

% fraction of correction
fract=COR(plane).fract;

% apply rf correction
if RSP(plane).rfflag==1 & plane==1                  %...rf correction flag
rf=getrf;
setrf(rf(1) - fract*BPM(plane).drf);    %wjc changed sign 9/20/06
end

% apply corrector settings
act  =COR(plane).act(COR(plane).ifit);              %...NOTE: corrector pattern (.act) measured at time of fit in RefreshOrbGUI
family=COR(plane).AOFamily;                         %...corrector family
fit  =COR(plane).fit;                               %...increment vector from fitting
ifit =COR(plane).ifit;                              %...indices of correctors to fit
NewSP=act + fract*fit;                              %...new setpoint prior to removing dispersion component

setsp(family,NewSP,ifit);

%load restore field to enable corrector pattern removal
COR(plane).rst=COR(plane).act;

% nstep=5;
% for k=1:nstep
%     setsp(COR(plane).AOFamily,k/nstep*val,ifit);
%     pause(0.1)
% end

pause(SYS.bpmslp);            %wait for BPM processor
orbgui('RefreshOrbGUI');

%===========================================================
case 'RemoveCorrection'            %*** RemoveCorrection ***
%===========================================================
%restore to corrector pattern prior to 'ApplyFit'

if COR(plane).ifit
orbgui('LBox',' Removing last correction');
%NOTE: corrector pattern (.act) measured at time of fit in RefreshOrbGUI

ifit=COR(plane).ifit;
val=COR(plane).rst(COR(plane).ifit);

setsp(COR(plane).AOFamily,val,ifit);

% nstep=5;
% for k=1:nstep
%     setsp(COR(plane).AOFamily,(1-k/nstep)*val,status);
%     pause(0.1)
% end

pause(SYS.bpmslp);            %wait for BPM processor
orbgui('RefreshOrbGUI');
else
orbgui('LBox',' Correction not valid for current plane');  
end

% % % %==========================================================
% % % case 'UpdateCorrs'                  % *** UpdateCorrs ***
% % % %==========================================================
% % % %callback of the 'refresh corrector' button
% % % %acquire corrector readbacks, plot, re-calculate fit
% % % corgui('UpdateAct');
% % % orbgui('RefreshOrbGUI');

%==========================================================
case 'GetAct'                              % *** GetAct ***
%==========================================================
%get readback corrector values from database
%load values into full length array slots with valid status 
families={'HCM','VCM'};

for k=1:length(families)
    val=getsp(families{k},[]);
    status=COR(k).status;
    COR(k).act(status)=val;
    COR(k).act=COR(k).act(:);
end

setappdata(0,'COR',COR);

%==========================================================
case 'UpdateAct'                  % *** UpdateAct ***
%==========================================================
%callback of the 'refresh corrector' button
%acquire corrector readbacks and plot

corgui('GetAct');

corgui('PlotAct');
corgui('UpdateCorBox');
orbgui('LBox',' Refresh Corrector Setpoints');

%==========================================================
case 'PlotAct'                            % *** PlotAct ***
%==========================================================
%draw stem plot for the actual corrector values.
%act contains real values

%scale start patch
ah=get(SYS.handles.ahcor);
set(orbfig,'currentaxes',SYS.handles.ahcor)

xd=orbgui('GetAbscissa',SYS,'COR');
   
for kk=1:size(COR(plane).name,1)
yd=0.0;      %default corrector value
color='k';   %default black if not in status vector
  if ~isempty(find(COR(plane).status==kk))
  color='y';  %yellow for available
  yd = COR(plane).act(kk);
  end
  
  if ~isempty(COR(plane).ifit);
    if ~isempty(find(COR(plane).ifit==kk)) color='g'; end
  end
  
set(COR(plane).hact(kk,1),'XData',xd(kk),'YData',yd,'MarkerFaceColor',color);
set(COR(plane).hact(kk,2),'XData',[xd(kk) xd(kk)],'YData',[0 yd]);
end  %end loop over all correctors

corgui('ylimits');

%==========================================================
case 'PlotFit'                      % *** PlotFit ***
%==========================================================
%draw stem plot for the total predicted corrector values after fitting
%note:COR(plane).fit is compressed

if isempty(COR(plane).fit) 
    return
end

xd=orbgui('GetAbscissa',SYS,'COR');

for kk = 1:length(COR(plane).ifit)
   k=COR(plane).ifit(kk);
   yd = COR(plane).act(k)+COR(plane).fit(kk);
   
       
   set(COR(plane).hfit(k,1),'Xdata',xd(k),'YData',yd);
   set(COR(plane).hfit(k,2),'Xdata',[xd(k) xd(k)],'YData',[0 yd]);
end
% for kk = 1:length(COR(plane).status)
%    k=COR(plane).status(kk);
%    yd = COR(plane).act(k)+COR(plane).fit(k);
%    set(COR(plane).hfit(k,1),'Xdata',xd(k),'YData',yd);
%    set(COR(plane).hfit(k,2),'Xdata',[xd(k) xd(k)],'YData',[0 yd]);
% end
corgui('ylimits');

%==========================================================
case 'ClearFit'                      % *** ClearFit ***
%==========================================================
%clear horizontal fit
for kk = 1:length(COR(1).z)        
set(COR(1).hfit(kk,1),'YData',0);
set(COR(1).hfit(kk,2),'YData',[0 0]);
end
%clear vertical   fit
for kk = 1:length(COR(2).z)        
set(COR(2).hfit(kk,1),'YData',0);
set(COR(2).hfit(kk,2),'YData',[0 0]);
end

%==========================================================
case 'ClearPlots'                    % *** Clearplots ***
%==========================================================
corgui('ClearFit');
%clear horizontal actuals
for kk = 1:length(COR(1).z)        
	 set(COR(1).hact(kk,1),'YData',0);
	 set(COR(1).hact(kk,2),'YData',[0 0]);
end
%clear vertical   actuals
for kk = 1:length(COR(2).z)        
	 set(COR(2).hact(kk,1),'YData',0);
	 set(COR(2).hact(kk,2),'YData',[0 0]);
end

%==========================================================
case 'ShowPlots'                    % *** Showplots ***
%==========================================================
%hide stem plots for current plane
for kk = 1:length(COR(plane).z)        
	 set(COR(plane).hact(kk,1),'Visible','On');
	 set(COR(plane).hact(kk,2),'Visible','On');
     set(COR(plane).hfit(kk,1),'Visible','On');
	 set(COR(plane).hfit(kk,2),'Visible','On');
end

%==========================================================
case 'HidePlots'                    % *** Hideplots ***
%==========================================================
%hide stem plots for current plane
for kk = 1:length(COR(plane).z)        
	 set(COR(plane).hact(kk,1),'Visible','Off');
	 set(COR(plane).hact(kk,2),'Visible','Off');
	 set(COR(plane).hfit(kk,1),'Visible','Off');
	 set(COR(plane).hfit(kk,2),'Visible','Off');
end

%=============================================================
case 'RePlot'                                  % *** RePlot ***
%=============================================================
corgui('ClearPlots');
set(orbfig,'currentaxes',SYS.handles.ahcor)
corgui('PlotAct');                        %plot actual correctors
corgui('PlotFit');                        %plot fitted correctors
corgui('CorBar');

%=============================================================
case 'ylimits'                             % *** ylimits ***
%=============================================================
%compute vertical axes limits for corrector plot

if COR(plane).scalemode==0 
return; 
end    %manual mode

mxfit=0;
if ~isempty(COR(plane).ifit)
mxfit=max(abs(COR(plane).fit(:) + COR(plane).act(COR(plane).ifit)));
end

mxact=max(abs(COR(plane).act(COR(plane).status)));        

ylim=max(mxfit, mxact)*1.1;


if ylim<0.1 ylim=0.1; end
set(SYS.handles.ahcor,'YLim',[-ylim,ylim]);

%=============================================================
case 'CorSelect'                          % *** CorSelect ***
%=============================================================
%used if mouse clicks anywhere in COR window
cpa = get(SYS.handles.ahcor,'CurrentPoint');
pos=cpa(1);

switch SYS.xscale
case 'meter' 
id=find(min(abs(COR(plane).z-pos))==abs(COR(plane).z-pos));
case 'phase'
id=find(min(abs(COR(plane).phi-pos))==abs(COR(plane).phi-pos));
end

COR(plane).id=id;

setappdata(0,'COR',COR);

c = COR(plane).hact(id,1);  %...get handle

corgui('ProcessCor',id,c);

%=============================================================
case 'CorDown'                              % *** CorDown ***
%=============================================================
c = gcbo;
ctag=get(c,'tag');
id = str2num(ctag(4:length(ctag))); %strip off 'c/plane_' to get the cor index
corgui('ProcessCor',id,c);

%=============================================================
case 'ProcessCor'                           % *** ProcessCor ***
%=============================================================
%This function is activated whenever the left mouse button is pressed inside a BPM patch.
%It sets up corfig to interpret movement of the mouse and also puts data about the
%particular cor into the text fields.

%identify COR handle and number
id=varargin(1); %corrector index 'id' comes through varargin
id=id{1};
c=varargin(2);
c=c{1};           %bpm handle 'c' comes through varargin
  %c = gcbo;
  %cortag = get(c,'tag');
  %id = str2num(cortag(2:length(cortag)));         %strip off 'c' to get the cor index

if COR(plane).mode==1                               %Corrrectors in toggle mode
   
   first=0;
   if isempty(COR(plane).ifit)     %no CORs chosen
   COR(plane).ifit(1)=id;
   set(c,'MarkerFaceColor','g');                         %add to fit list
   first=1;
   setappdata(0,'COR',COR);
   end

   if ~isempty(find(COR(plane).ifit==id))   & first==0     %presently selected for fit
   set(c,'MarkerFaceColor','y');
   COR(plane).ifit(find(COR(plane).ifit==id))=0;  %set fit vector to zero
   COR(plane).ifit=COR(plane).ifit(find(COR(plane).ifit));
   nfit=length(COR(plane).ifit);         %compute vector length
   setappdata(0,'COR',COR);

   elseif isempty(find(COR(plane).ifit==id)) & ~isempty(find(COR(plane).avail==id))
       %elseif ~isempty(find(COR(plane).avail==id))  %corrector is available
   set(c,'MarkerFaceColor','g');                         %add to fit list
   t=COR(plane).ifit;
   t=t(find(t));
   t=sort([t; id]);
   COR(plane).ifit=t;
   nfit=length(COR(plane).ifit);
   setappdata(0,'COR',COR);
   end
   
   orbgui('RefreshOrbGUI');
else
    corgui('UpdateCorBox');
end    %end toggle mode condition

set(orbfig,'WindowButtonUpFcn','corgui(''Up'')');
corgui('CorBar');

%update response matrix column plot
if RSP(plane).disp(1:2)=='of'                       %Response display mode
set(SYS.handles.lhrsp,'XData',[],'YData',[]);
else
bpmgui('PlotResp');                            %plot matrix column vector
end
            
%=============================================================
case 'CorBar'                              % *** CorBar ***
%=============================================================
%move black line in window to indicate selection
id=COR(plane).id;
ylim=get(SYS.handles.ahcor,'YLim');


if isempty(find(COR(plane).status==id))
yd=[ylim(1)/4,ylim(2)/4];
else
yd=[COR(plane).act(id)+ylim(1)/4,COR(plane).act(id)+ylim(2)/4];
end


xd=orbgui('GetAbscissa',SYS,'COR');  %horizontal coordinates for plotting
xd=[xd(id) xd(id)+0.001];

set(SYS.handles.lhcid,'XData',xd,'YData',yd);

%=============================================================
case 'UpdateCorBox'                     % *** UpdateCorBox ***
%=============================================================
%update UpdateCorBox
%called from orbgui(RefreshOrbGUI), corgui(UpdateCorrs), 
id=COR(plane).id;
%put fit value in offset box and in request box
fitindx=[];
if ~isempty(COR(plane).ifit) fitindx=find(COR(plane).ifit==id); end

if ~isempty(fitindx)
offset=COR(plane).fit(fitindx);
request=COR(plane).act(id)+offset;
else
offset=0.0;
request=COR(plane).act(id);
end

sig=sqrt(var(COR(plane).act(COR(plane).status)));
avg=mean(COR(plane).act(COR(plane).status));
corgui('CorBox',COR(plane).name(id,:),COR(plane).act(id),...
                COR(plane).save(id),offset,request,...
                avg,sig,id);

%=============================================================
case 'CorBox'                            % *** CorBox ***
%=============================================================
%called from
%corgui('CorBox',COR(plane).name(id,:),COR(plane).act(id),...
%                COR(plane).ref(id),id);
corname =   SYS.handles.corname;
actual =    SYS.handles.coract;
reference = SYS.handles.corref;
offset =    SYS.handles.coroffset;
request =   SYS.handles.correq;
avgval =    SYS.handles.coravg;
rmsval =    SYS.handles.corrms;

name=varargin{1};
act =varargin{2};
ref =varargin{3};
off =varargin{4};
req =varargin{5};
avg =varargin{6};
rms =varargin{7};
id=varargin{8};

set(corname,  'String',[name '  (',num2str(id),')']);
set(actual,   'String',num2str(act, '%6.3f'));
set(reference,'String',num2str(ref, '%6.3f'));
set(offset,   'String',num2str(off, '%6.3f'));
set(avgval,   'String',num2str(avg, '%6.3f'));
set(rmsval,   'String',num2str(rms, '%6.3f'));
set(request,  'String',num2str(req, '%6.3f'));

%=============================================================
case 'Up'                                  % *** Up ***
%=============================================================
%once the mouse button is let up, don't respond to motion any more.

set(orbfig,'WindowButtonMotionFcn','','WindowButtonUpFcn','');

%=============================================================
case 'CORmove'                      % *** CORmove ***
%=============================================================
%empty for now: can't drag correctors
if RSP(plane).disp(1:2)=='on'
end

%=============================================================
case 'SelectAll'                           % *** SelectAll ***
%============================================================
%load all available correctors into ifit field
COR(plane).ifit=[];
for kk = 1:length(COR(plane).avail)
        k=COR(plane).avail(kk);
        h1=COR(plane).hact(k,1);  %k,1 is the icon
        set(h1,'MarkerFaceColor','g');
        COR(plane).ifit(kk)=k;
end   

COR(plane).ifit=COR(plane).ifit(:);
setappdata(0,'COR',COR);

corgui('ClearFit'); %be sure to remove residual red corrector bars
orbgui('RefreshOrbGUI');
   
%=============================================================
case 'SelectNone'                           % *** SelectNone ***
%=============================================================
COR(plane).ifit=[];
COR(plane).fit=[];
for kk = 1:length(COR(plane).avail)
        k=COR(plane).avail(kk);
        h1=COR(plane).hact(k,1);  %k,1 is the icon
        set(h1,'MarkerFaceColor','y');
end   

setappdata(0,'COR',COR);

RSP(plane).nsvd=1;
RSP(plane).nsvdmx=1;
setappdata(0,'RSP',RSP);

orbgui('RefreshOrbGUI');
%respgui('FitOff',num2str(plane));

%==========================================================
case 'ToggleCor'                              %  ToggleCor
%==========================================================
h1=SYS.handles.togglecor;   
val=get(h1,'Value');
if val==0                        %radio was on, push turned off
COR(plane).mode=0;               %'0' for display
elseif val==1                    %radio was off, push turned on
COR(plane).mode=1;               %'1' for toggle
end
setappdata(0,'COR',COR);

%==========================================================
case 'ShowResp'                       %  ShowResp
%==========================================================
%toggle the 'showresp' flag to display columns of response matrix
%plotting in bpmgui('PlotResp')

%first make sure eigenvector display is off
h1=SYS.handles.showeig;   
val=get(h1,'UserData');
if val==1                        %radio on, turn off
RSP(plane).eig='off';
setappdata(0,'RSP',RSP);
set(SYS.handles.lheig,'XData',[],'YData',[]);
set(h1,'UserData',0);
end

h1=SYS.handles.showresp;   
val=get(h1,'checked');
%RSP=getappdata(0,'RSP');
if val==0                       %radio was on, push turned off
RSP(plane).disp='off';
set(SYS.handles.lhrsp,'XData',[],'YData',[]);
elseif val==1                    %radio was off, push turned on
RSP(plane).disp='on';
setappdata(0,'RSP',RSP);
bpmgui('PlotResp');
end
    
%==========================================================
case 'ShowEig'                       %  ShowEig
%==========================================================
%toggle state to show eigenvectors
%first make sure response matrix display is off
h1=SYS.handles.showresp;   
val=get(h1,'UserData');
if val==1                        %radio on, turn off
RSP(plane).disp='off';
set(SYS.handles.lhrsp,'XData',[],'YData',[]);
set(h1,'UserData',0);
end

h1=SYS.handles.showeig;   
val=get(h1,'UserData');

if val==0                       %radio was on, push turned off
RSP(plane).eig='off';
set(SYS.handles.lheig,'XData',[],'YData',[]);
elseif val==1                    %radio was off, push turned on
RSP(plane).eig='on';  
bpmgui('PlotEig');
end

%===========================================================
case 'SaveCorrs'                          %*** SaveCorrs ***
%===========================================================
%Save Corrector Readbacks for RESET button
plane=varargin{1};

val=getsp(COR(plane).AOFamily);
status=COR(plane).status;
COR(plane).save(status)=val;

COR(plane).saveflag=1;

setappdata(0,'COR',COR);

corgui('UpdateCorBox');

orbgui('LBox',[' Corrector pattern saved for plane: ' num2str(plane)]);


%===========================================================
case 'RestoreCorrs'                    %*** RestoreCorrs ***
%===========================================================
%restore correctors to saved values
if ~isempty(find(COR(plane).saveflag==0));
orbgui('LBox',[' Corrector pattern not saved for plane: ' num2str(plane)]);

return
end

val=COR(plane).save;
status=COR(plane).status;

% nstep=5;
% for k=1:nstep
%     setsp(COR(plane).AOFamily,(1-k/nstep)*val(status),status);
% pause(0.1)
% end

setsp(COR(plane).AOFamily,val(status),status);

orbgui('LBox',[' Corrector pattern restored for plane: ' num2str(plane)]);
orbgui('RefreshOrbGUI');

%==============================================================
case 'MakeOrbitSlider'                       %  MakeOrbitSlider
%==============================================================
%figure to create bump sliders and/or write files

[screen_wide, screen_high]=screensizecm;
fig_start = [0.4*screen_wide 0.5*screen_high];
fig_size = [0.4*screen_wide 0.25*screen_high];

h = findobj(0,'tag','makeorbitslider');
if ~isempty(h) 
    delete(h); 
end

if SYS.plane==1
    planestr='Horizontal ';
else
    planestr='Vertical';
end

figh=figure('units','centimeters',...                %...Figure
        'Position',[fig_start fig_size],'tag','makeorbitslider',... 
		'NumberTitle','off','Doublebuffer','on','Visible','On','Name',[planestr 'corrector bump panel'],...
		'PaperPositionMode','Auto','MenuBar','None');
%------------------------------------------------------------------
path=getfamilydata('Directory','BumpData');
filename=appendtimestamp('bump', clock);

uicontrol('Style','Text',...	                       %...Header                   
'units', 'normalize', ...
'Position', [.02 .8 .12 .08],'ForeGroundColor','k','HorizontalAlignment','Left',...
'String','Header:','ToolTipString','Name of slider in gui display',...	
'FontSize',8,'FontWeight','demi');

SYS.handles.bumpheader=uicontrol('Style','Edit',...	   %...Header                   
'units', 'normalize', ...
'Position', [.2 .8 .4 .08],'ForeGroundColor','k','HorizontalAlignment','Left',...
'String','Bump','ToolTipString','Name of slider in gui display',...	
'FontSize',8,'FontWeight','demi');

uicontrol('Style','Text',...	                       %...File Name                    
'units', 'normalize', ...
'Position', [.02 .7 .12 .08],'ForeGroundColor','k','HorizontalAlignment','Left',...
'String','File Name:','ToolTipString','Name of file written to disk',...	
'FontSize',8,'FontWeight','demi');

SYS.handles.bumpfile=uicontrol('Style','Edit',...	  %...File Name                    
'units', 'normalize', ...
'Position', [.2 .7 .5 .08],'ForeGroundColor','k','HorizontalAlignment','Left',...
'String',filename,'ToolTipString','Name of file written to disk',...	
'FontSize',8,'FontWeight','demi');

uicontrol('Style','Text',...	                      %...Save Directory                    
'units', 'normalize', ...
'Position', [.02 .6 .12 .08],'ForeGroundColor','k','HorizontalAlignment','Left',...
'String','File Path','ToolTipString','Path of file written to disk',...	
'FontSize',8,'FontWeight','demi');

SYS.handles.bumppath=uicontrol('Style','Edit',...	  %...Save Directory                    
'units', 'normalize', ...
'Position', [.2 .6 .8 .08],'ForeGroundColor','k','HorizontalAlignment','Left',...
'String',path,'ToolTipString','Path of file written to disk',...	
'FontSize',8,'FontWeight','demi');

uicontrol('Style','pushbutton',...	                  %...Save Command                   
'units', 'normalize', ...
'Position', [.2 .3 .3 .1],'ForeGroundColor','k',...
'String','Save file','ToolTipString','Write bump file to disk (do not launch slider)',...	
'FontSize',8,'FontWeight','demi','Callback',['corgui(''WriteBumpFile'');', 'close(''gcf'')']);

uicontrol('Style','pushbutton',...	                  %...Save & Launch Command                   
'units', 'normalize', ...
'Position', [.6 .3 .3 .1],'ForeGroundColor','k',...
'String','Save file/Launch Slider','ToolTipString','Write bump file to disk and launch slider',...	
'FontSize',8,'FontWeight','demi','Callback','corgui(''LaunchBumpSlider'')');

uicontrol('Style','pushbutton',...	                  %...cancel                  
'units', 'normalize','Position', [.8 .08 .1 .1],'ForeGroundColor','k','String','cancel',...
'Callback','delete(gcf)','FontSize',8,'FontWeight','demi');

%==========================================================
case 'WriteBumpFile'             % *** WriteBumpFile ***
%==========================================================
%call of MakeOrbitSlider
%call function WriteBumpFile with corrector strengths

if plane==1 
    Family='HCM';
elseif plane==2
    Family='VCM';
end

pv=common2channel(COR(plane).name(COR(plane).ifit,:),'Setpoint',Family);
delta=zeros(length(COR(plane).ifit),1);
for ii=1:length(COR(plane).ifit)
    jj=COR(plane).ifit(ii);
    %delta(ii,1)=COR(plane).fit(ii)-COR(plane).save(jj);
    delta(ii,1)=COR(plane).fit(ii); %-COR(plane).act(jj);
end

header=  get(SYS.handles.bumpheader,'String');
path=    get(SYS.handles.bumppath,'String');
filename=get(SYS.handles.bumpfile,'String');

if isempty(header)   header='slider'; end
if isempty(path)     path=getfamilydata('Directory','BumpFiles'); end
    set(SYS.handles.bumppath,'String',path);       %update so launchbumpslider has correct path
if isempty(filename) filename=appendtimestamp('bump', clock); 
    if isempty(findstr(filename,'.m')) filename=[filename '.m']; end
    set(SYS.handles.bumpfile,'String',filename);   %update so launchbumpslider has correct filename
end

writebumpfile(pv,delta,header,path,filename);
orbgui('LBox',[' Bump File Created: ', filename]);

%==========================================================
case 'LaunchBumpSlider'             % *** LaunchBumpSlider ***
%==========================================================
%call of MakeOrbitSlider 'Save and Launch
%call function SingleSlider with corrector strengths

corgui('WriteBumpFile');    %first write file

header=  get(SYS.handles.bumpheader,'String');
path=    get(SYS.handles.bumppath,'String');
filename=get(SYS.handles.bumpfile,'String');

if isempty(header)   header='slider'; end
if isempty(path)     path=getfamilydata('Directory','BumpFiles'); end
if isempty(filename) filename=appendtimestamp('bump', clock); end

setappdata(0,'SliderIndex',1);
setappdata(0,'SliderFigHandle',gcf);

singleslider(path,filename);

%===========================================================
case 'ShowCORState'              %*** ShowCORState ***
%===========================================================

% Show =corrector settings
  tavail=zeros(1,length(COR(plane).name));
  tifit=zeros(1,length(COR(plane).name));
  tfit=zeros(1,length(COR(plane).name));
  tstatus=zeros(1,length(COR(plane).name));
 
  findx=1;
  for ind=1:length(COR(plane).name)
  if ~isempty(find(COR(plane).avail==ind)) tavail(ind)=ind;  end
  if ~isempty(find(COR(plane).ifit==ind)) 
  tifit(ind)=ind;
  tfit(ind)=COR(plane).fit(findx);
  findx=findx+1;
  end
  if ~isempty(find(COR(plane).status==ind)) tstatus(ind)=ind;  end
  end
  
  

  
  fprintf('%s\n','index name       stat  avail     ifit       act        fit       weight');
  for ind=1:length(COR(plane).name)
          fprintf('%3d %10s %5d %5d %10.3f %10.3f %10.3f %10.3f\n',...
          ind, COR(plane).name(ind,:),...
          tstatus(ind),tavail(ind),tfit(ind),COR(plane).act(ind),tfit(ind),COR(plane).wt(ind));
  end
  
%==========================================================
case 'MeasureXResp'                  % *** MeasureXResp ***
%==========================================================
%callback of the 'Measure X-Response' menu selection

orbitfiginvisible;

disp('Orbit gui visibility turned off while response matrix measurement in progress');
disp(['To re-activate, issue command :  ', 'OrbitFigVisible']);

% acquire initial orbit 
disp('   Acquiring initial orbit')
Xorb = getx('struct');
Xorb.DataDescriptor='ResponseMatrixReference';
Yorb = gety('struct');
Yorb.DataDescriptor='ResponseMatrixReference';

%acquire machine configuration
disp('   Acquiring machine configuration')
machineconfig=getmachineconfig;

ad=getad;

xbpms=BPM(1).status;
ybpms=BPM(2).status;

xcors=COR(1).status;
xcors=[1 2 3]';   %%%%%%%%%%%debug
xkick=COR(1).ebpm(xcors);

WaitFlag=ad.BPMDelay;
ExtraDelay=0;

disp('   *** Begin measuring horizontal response matrix ***');
mat=measrespmat({'BPMx','BPMy'},{xbpms,ybpms},'HCM',xcors,xkick,'bipolar',WaitFlag,ExtraDelay,'struct');

% Make a response matrix array 
Rmat(1,1)=mat{1};  % x-x
Rmat(2,1)=mat{2};  % y-x

%load x-x data
Rmat(1,1).NaNData    = zeros(size(getlist('BPMx',0),1),size(getlist('HCM',0),1));
Rmat(1,1).NaNData(:) = deal(NaN);
Rmat(1,1).NaNData(xbpms,xcors)=mat{1}.Data;     %Kick x, look x
% 
%load y-x data
Rmat(2,1).NaNData    = zeros(size(getlist('BPMy',0),1),size(getlist('HCM',0),1));
Rmat(2,1).NaNData(:) = deal(NaN);
Rmat(2,1).NaNData(ybpms,xcors)=mat{2}.Data;     %Kick x, look y

for ii=1:2
    Rmat(ii,1).X       = Xorb;   
    Rmat(ii,1).Y       = Yorb;
    Rmat(ii,1).MachineConfig  = machineconfig;
end
Rmat(1,1).Monitor.DataDescriptor ='Horizontal Orbit';
Rmat(1,1).Actuator.DataDescriptor='Horizontal Correctors';
Rmat(2,1).Monitor.DataDescriptor ='Vertical Orbit';
Rmat(2,1).Actuator.DataDescriptor='Horizontal Correctors';

RSP(1)=response2rsp(Rmat(1,1),RSP(1),1);

orbitfigvisible;

BPM=SortBPMs(BPM,RSP);
COR=SortCORs(COR,RSP);
orbgui('RefreshOrbGUI');

orbgui('LBox',' Finished measuring horizontal eBPM response matrix');

%==========================================================
case 'MeasureYResp'                  % *** MeasureYResp ***
%==========================================================

%callback of the 'Measure Y-Response' menu selection

orbitfiginvisible;

disp('Orbit gui visibility turned off while response matrix measurement in progress');
disp(['To re-activate, issue command :  ', 'OrbitFigVisible']);

% acquire initial orbit 
disp('   Acquiring initial orbit')
Xorb = getx('struct');
Xorb.DataDescriptor='ResponseMatrixReference';
Yorb = gety('struct');
Yorb.DataDescriptor='ResponseMatrixReference';

%acquire machine configuration
disp('   Acquiring machine configuration')
machineconfig=getmachineconfig;

ad=getad;

xbpms=BPM(1).status;
ybpms=BPM(2).status;

ycors=COR(2).status;
ycors=[1 2 3]';   %%%%%%%%%%%debug
ykick=COR(2).ebpm(ycors);

WaitFlag=0;
ExtraDelay=ad.BPMDelay;

disp('   *** Begin measuring vertical response matrix ***');
mat=measrespmat({'BPMx','BPMy'},{xbpms,ybpms},'VCM',ycors,ykick,'bipolar',WaitFlag,ExtraDelay,'struct');

% Make a response matrix array 
Rmat(1,2)=mat{1};  % x-y
Rmat(2,2)=mat{2};  % y-y

%load x-y data
Rmat(1,2).NaNData    = zeros(size(getlist('BPMy',0),1),size(getlist('VCM',0),1));
Rmat(1,2).NaNData(:) = deal(NaN);
Rmat(1,2).NaNData(xbpms,ycors)=mat{1}.Data;     %Kick x, look y

%load y-y data
Rmat(2,2).NaNData    = zeros(size(getlist('BPMx',0),1),size(getlist('VCM',0),1));
Rmat(2,2).NaNData(:) = deal(NaN);
Rmat(2,2).NaNData(xbpms,ycors)=mat{2}.Data;     %Kick y, look y
% 
for ii=1:2
    Rmat(ii,2).X       = Xorb;   
    Rmat(ii,2).Y       = Yorb;
    Rmat(ii,2).MachineConfig  = machineconfig;
end

Rmat(1,2).Monitor.DataDescriptor ='Horizontal Orbit';
Rmat(1,2).Actuator.DataDescriptor='Vertical Correctors';
Rmat(2,2).Monitor.DataDescriptor ='Vertical Orbit';
Rmat(2,2).Actuator.DataDescriptor='Vertical Correctors';

RSP(2)=response2rsp(Rmat(2,2),RSP(2),2);

orbitfigvisible;

BPM=SortBPMs(BPM,RSP);
COR=SortCORs(COR,RSP);
orbgui('RefreshOrbGUI');

orbgui('LBox',' Finished measuring vertical eBPM response matrix');

%==========================================================
case 'MeasureYPhotonResp'      % *** MeasureYPhotonResp ***
%==========================================================
%callback of the 'Measure Photon Response' pushbutton for vertical plane
%callback of the 'Measure BPM Response' pushbutton for vertical plane
%callback of the 'Measure Y-Response' menu selection
disp('   *** Begin measuring vertical response matrix ***');

ad=getad;

xbpms=BPM(1).status;
ybpms=BPM(2).status;

ycors=COR(2).status;
ycors=[1 2 3]';   %%%%%%%%%%%debug
ykick=COR(2).ebpm(ycors);

WaitFlag=0;
ExtraDelay=ad.BPMDelay;

mat=measrespmat({'BPMx','BPMy'},{xbpms,ybpms},'VCM',ycors,ykick,'bipolar',WaitFlag,ExtraDelay,'struct');

% Make a response matrix array 
Rmat(1,2)=mat{1};  % x-y
Rmat(2,2)=mat{2};  % y-y

%load x-y data
Rmat(1,2).NaNData    = zeros(size(getlist('BPMy',0),1),size(getlist('VCM',0),1));
Rmat(1,2).NaNData(:) = deal(NaN);
Rmat(1,2).NaNData(xbpms,ycors)=mat{1}.Data;     %Kick x, look y

%load y-y data
Rmat(2,2).NaNData    = zeros(size(getlist('BPMx',0),1),size(getlist('VCM',0),1));
Rmat(2,2).NaNData(:) = deal(NaN);
Rmat(2,2).NaNData(xbpms,ycors)=mat{2}.Data;     %Kick y, look y
% 
RSP(2)=response2rsp(Rmat(2,2),RSP(2),2);

BPM=SortBPMs(BPM,RSP);
COR=SortCORs(COR,RSP);
orbgui('RefreshOrbGUI');

orbgui('LBox',' Finished measuring vertical pBPM response matrix');

%==========================================================
otherwise
disp(['Warning: no CASE found in corgui: ' action]);

end  %end switchyard


