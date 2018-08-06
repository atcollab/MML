%=============================================================
function varargout = bpmgui(action, varargin)
%=============================================================
%  bpmgui controls orbit manipulation and plotting
%graphics handles
global BPM BL COR RSP SYS
orbfig = findobj(0,'tag','orbfig');
plane=SYS.plane;

%BPM=getappdata(0,'BPM');

switch action
%...GetRef//YLimits
%...PlotRef//PlotAct_Init//PlotAct//PlotFit_Init//PlotFit
%...PlotDes_Init//Plot_Des//Plot_BPMs_Init//PlotBPMs
%...PlotResp_Init//PlotResp//PlotEig_Init//PlotEig
%...BPMDown//ProcessBPM//MoveBPMUp
%...EditBPM//SetBPMOff//BPMBox//Up
%...RePlot//ClearPlot
%...SelectAll//SelectNone
%...ToggleMode//DragMode//ShowBPMState

%=============================================================
case 'GetRef'                                 % *** GetRef ***
%=============================================================
%measure orbit and load  into BPM.ref
families={'BPMx','BPMy'};

for k=1:length(families)
    val=getam(families{k},[]);
    val=val(find(~isnan(val)));
    status=BPM(k).status;
    BPM(k).iref=status;
    BPM(k).ref(status)=val;
    
    if strcmpi(SYS.datamode,'REAL')
       BPM(k).ref(status)=BPM(k).ref(status) - BPM(k).offset(status);   %remove offset
       BPM(k).ref(status)=BPM(k).gain(status).*BPM(k).ref(status);  %scale by gain
    end
    
end

setappdata(0,'BPM',BPM);

%=============================================================
case 'UpdateRef'                           % *** UpdateRef ***
%=============================================================
%load a simulated or most recently measured reference orbit into BPM structure
%load a copy into the .des field
bpmgui('GetRef');
%BPM=getappdata(0,'BPM');

BPM(1).act=BPM(1).ref;
BPM(1).des=BPM(1).ref;
BPM(1).abs=BPM(1).ref;

BPM(2).act=BPM(2).ref;
BPM(2).des=BPM(2).ref;
BPM(2).abs=BPM(2).ref;

if SYS.relative==1   %absolute mode
BPM(1).abs=zeros(size(BPM(1).name,1),1);
BPM(2).abs=zeros(size(BPM(2).name,1),1); 
end

setappdata(0,'BPM',BPM);

orbgui('LBox',' Refresh Reference Orbit: ');

orbgui('RefreshOrbGUI');

%=============================================================
case 'GetAct'                             % *** GetAct ***
%=============================================================
%measure orbit and load  into BPM.act
families={'BPMx','BPMy'};

for k=1:length(families)
    val=getam(families{k},[]);
    val=val(find(~isnan(val)));
    status=BPM(k).status;
    BPM(k).act(status)=val;
    if strcmpi(SYS.datamode,'REAL')
       BPM(k).act(status)=BPM(k).act(status) - BPM(k).offset(status);   %remove offset
       BPM(k).act(status)=BPM(k).gain(status).*BPM(k).act(status);      %scale by gain
    end
    
    %raw: no change in BPM(k).act


    
%hotwire BPM [10 4]
% indx=dev2elem('BPMx',[10 4]);   %60
% BPM(k).act(indx)=BPM(k).ref(indx);
% BPM(k).wt(indx)=0;

%hotwire BPM [12 4]
% indx=dev2elem('BPMx',[12 4]);   %60+12
% %BPM(k).act(indx)=BPM(k).ref(indx);
% BPM(k).wt(indx)=0;
end


setappdata(0,'BPM',BPM);

%photon bpm acquisition 
%because feedback calls GetAct directly (not UpdateAct)
if SYS.pbpm==1 
    BL=getbldata(BL,1,1);          %acquire photon bpm data (navg, dwell)
    setappdata(0,'BL',BL);
end

%=============================================================
case 'UpdateAct'                           % *** UpdateAct ***
%=============================================================
%read new orbit, update graphics
bpmgui('GetAct');
orbgui('LBox',' Refresh Orbit ');
orbgui('RefreshOrbGUI');

%=============================================================
case 'ylimits'                             % *** ylimits ***
%=============================================================
%set vertical axis limits for BPM plot
if BPM(plane).scalemode==0 
return; 
end  %manual mode

mxref=max(abs(BPM(plane).ref(BPM(plane).status)-BPM(plane).abs(BPM(plane).status)));        %for ylimit calculation
mxdes=max(abs(BPM(plane).des(BPM(plane).status)-BPM(plane).abs(BPM(plane).status)));        %for ylimit calculation
mxact=max(abs(BPM(plane).act(BPM(plane).status)-BPM(plane).abs(BPM(plane).status)));        %for ylimit calculation
%look for maximum of (act-abs)+fit
mxfit=max(abs((BPM(plane).act(BPM(plane).avail)-BPM(plane).abs(BPM(plane).avail)+...
         BPM(plane).fit(BPM(plane).avail))));
ylim=max([mxref mxdes mxact mxfit])*1.1;

%units are mm

if ylim<0.1 ylim=0.1; end

set(SYS.handles.ahbpm,'YLim',[-ylim,ylim]);

%==========================================================
case 'PlotRef_Init'                        %...PlotRef_Init
%==========================================================
%red, solid line for reference orbit.
%use .iref field
set(SYS.handles.ahbpm,'Color',[1 1 1],'NextPlot','add');
set(orbfig,'currentaxes',SYS.handles.ahbpm)

yd=BPM(plane).ref(BPM(plane).iref)-BPM(plane).abs(BPM(plane).iref);

%yd=zeros(length(BPM(plane).iref),1);
xd=orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
xd=xd(BPM(plane).iref);

SYS.handles.lhref=	line('parent',SYS.handles.ahbpm,'XData',xd,'YData',yd,'Color','r');
set(SYS.handles.lhref,'ButtonDownFcn','bpmgui(''BPMSelect'');');

setappdata(0,'SYS',SYS);

%==========================================================
case 'PlotRef'                        %...PlotRef
%==========================================================
%red, solid, static line for reference orbit.
%use .iref field
bpmgui('ylimits');
set(orbfig,'currentaxes',SYS.handles.ahbpm)

xd=orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
xd=xd(BPM(plane).iref);

yd=BPM(plane).ref-BPM(plane).abs;
    
yd=yd(BPM(plane).iref);                              %display indices

set(SYS.handles.lhref,'LineWidth',1.25,'XData',xd,'YData',yd);

setappdata(0,'SYS',SYS);

%==========================================================
case 'PlotAct_Init'                        %...PlotAct_Init
%==========================================================
%blue, solid dynamic line for actual orbit.
%use .status field
bpmgui('ylimits');
set(SYS.handles.ahbpm,'Color',[1 1 1],'NextPlot','add');
set(orbfig,'currentaxes',SYS.handles.ahbpm)

SYS.handles.lhact=	line('parent',SYS.handles.ahbpm,'XData',[],'YData',[],'Color','b','ButtonDownFcn','bpmgui(''BPMSelect'');');

setappdata(0,'SYS',SYS);

%==========================================================
case 'PlotAct'                             %...PlotAct
%==========================================================
%blue, solid dynamic line for actual orbit.
%use .status field
bpmgui('ylimits');
set(orbfig,'currentaxes',SYS.handles.ahbpm)

xd=orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
xd=xd(BPM(plane).status);

yd=BPM(plane).act-BPM(plane).abs;
yd=yd(BPM(plane).status);            %display indices

set(SYS.handles.lhact,'LineWidth',1.2,'XData',xd,'YData',yd);

%==========================================================
case 'PlotFit_Init'                        %...PlotFit_Init
%==========================================================
%blue, dashed line for orbit fit
%use .avail field
bpmgui('ylimits');
set(SYS.handles.ahbpm,'Color',[1,1,1],'NextPlot','add');
set(orbfig,'currentaxes',SYS.handles.ahbpm)
SYS.handles.lhfit=	line('parent',SYS.handles.ahbpm,'XData',[],'YData',[],'Color','b','LineStyle',':');

setappdata(0,'SYS',SYS);

%==========================================================
case 'PlotFit'                             %...PlotFit
%==========================================================
%blue, dashed line for orbit fit
%use .avail field
set(orbfig,'currentaxes',SYS.handles.ahbpm)


xd=orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
xd=xd(BPM(plane).avail);

%actual orbit plus the fitted solution from corrector change 
%yields the predicted orbit

yd=BPM(plane).act - BPM(plane).abs + BPM(plane).fit;
yd=yd(BPM(plane).avail);             %display indices

set(SYS.handles.lhfit,'XData',xd,'YData',yd);
set(SYS.handles.lhfit,'ButtonDownFcn','bpmgui(''BPMSelect'');');
bpmgui('ylimits');

%==========================================================
case 'PlotDes_Init'                        %...PlotDes_Init
%==========================================================
%red, dashed dynamic line for offset orbit
%use .avail field

yd=BPM(plane).des(BPM(plane).avail)-BPM(plane).abs(BPM(plane).avail);

xd=orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
xd=xd(BPM(plane).avail);

SYS.handles.lhdes=line('parent',SYS.handles.ahbpm,'XData',xd,'YData',yd,'Color','r','LineStyle',':');
set(SYS.handles.lhdes,'ButtonDownFcn','bpmgui(''BPMSelect'');');

setappdata(0,'SYS',SYS);

bpmgui('ylimits');

%==========================================================
case 'PlotDes'                                  %...PlotDes
%==========================================================
% %red, dashed dynamic line for offset orbit
%use .avail field

xd=orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
xd=xd(BPM(plane).avail);


yd=BPM(plane).des-BPM(plane).abs;
yd=yd(BPM(plane).avail);             %display indices


set(SYS.handles.lhdes,'XData',xd,'YData',yd);
bpmgui('ylimits');

%==========================================================
case 'ClearOffsets'                        %...ClearOffsets
%==========================================================
%remove offsets in plane of interest
%use .avail field

for ii=1:length(BPM(plane).avail)
    id=BPM(plane).avail(ii);
    BPM(plane).des(id)=BPM(plane).ref(id); %-BPM(plane).abs(id);
end

setappdata(0,'BPM',BPM);

orbgui('RefreshOrbGUI');

%==========================================================
case 'PlotIcons_Init'                       %...PlotIcons_Init
%==========================================================
%draw initial 'hot' circles for each BPM - need to vectorize
selectbpm=['bpmgui(''BPMDown'');'];

%present plane
plane=SYS.plane;
xd=orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting

%small black if not in status vector
for kk=1:length(BPM(plane).name)
	   BPM(plane).hicon(kk)=line('parent',SYS.handles.ahbpm,'tag', ['b' num2str(kk)],...
      'XData',xd(kk),...
      'YData',0,...
      'Marker','o','MarkerSize',3,'MarkerFaceColor','k',...
      'ButtonDownFcn',selectbpm);
end
BPM(plane).hicon=BPM(plane).hicon(:);
BPM(1+mod(plane,2)).hicon=BPM(plane).hicon;

setappdata(0,'BPM',BPM);

%draw a vertical black line at selected BPM
ylim=get(SYS.handles.ahbpm,'YLim');
SYS.handles.lhbid=	line('parent',SYS.handles.ahbpm,...
      'XData',[xd(BPM(plane).id),xd(BPM(plane).id)+0.001],...
	  'YData',[ylim(1),ylim(2)],'Color','k');
set(SYS.handles.lhbid,'ButtonDownFcn','bpmgui(''BPMSelect'');');

%==========================================================
case 'PlotBPMs'                             %...PlotBPMs
%==========================================================
%green if BPM contained in BPM(plane).ifit, otherwise yellow
%red if not available (no response matrix entry or no reference orbit)
%default hot bpms to black
xd=orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
yd=BPM(plane).des-BPM(plane).abs;


for kk=1:size(BPM(plane).name,1)
%     disp(['icon handle: ' num2str(BPM(plane).hicon(kk))]);
%     disp(['xd(kk): ' num2str(xd(kk))]);
	set(BPM(plane).hicon(kk),'Xdata',xd(kk),...
    'YData',0,'MarkerSize',3,'MarkerFaceColor','k');
end

nstat=length(BPM(plane).status);
for kk = 1:nstat
    k=BPM(plane).status(kk);   %double index, BPM.status is compressed
    color='r';                      %red for not available
   if ~isempty(find(BPM(plane).avail==k)), color='y'; end   %yellow for available
   if isempty(BPM(plane).ifit)
       color='y'; %yellow for no fit
   elseif ~isempty(find(BPM(plane).ifit ==k))
       color='g'; %green for fit
   end
	   set(BPM(plane).hicon(k),...
       'XData',xd(k),'YData',yd(k),...
       'MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor',color);
end

%==========================================================
case 'PlotResp_Init'                      %...PlotResp_Init
%==========================================================
%black, solid dynamic line for response orbit
%use .avail field
bpmgui('ylimits');
set(SYS.handles.ahbpm,'Color',[1,1,1],'NextPlot','add');
set(orbfig,'currentaxes',SYS.handles.ahbpm);
SYS.handles.lhrsp=	line('parent',SYS.handles.ahbpm,'XData',[],'YData',[],'Color','k');

setappdata(0,'SYS',SYS);

%==========================================================
case 'PlotResp'                             %...PlotResp
%==========================================================
%black, solid static line for column of response matrix
%use .avail field

id=COR(plane).id;

set(orbfig,'currentaxes',SYS.handles.ahbpm)

ylim=get(SYS.handles.ahbpm,'YLim');
val=0.5*ylim(2)/max(abs(RSP(plane).c(BPM(plane).avail,id))); %scale column of response matrix
yd=val*RSP(plane).c(BPM(plane).avail,id);
xd=orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting

set(SYS.handles.lhrsp,'LineWidth',1.5,'XData',xd,'YData',yd);

%==========================================================
case 'PlotEig_Init'                        %...PlotEig_Init
%==========================================================
%black, solid dynamic line for eigenvector orbit
%use .iavail field for default
bpmgui('ylimits');
set(SYS.handles.ahbpm,'Color',[1,1,1],'NextPlot','add');
set(orbfig,'currentaxes',SYS.handles.ahbpm)
SYS.handles.lheig=	line('parent',SYS.handles.ahbpm,'XData',[],'YData',[],'Color','k');

setappdata(0,'SYS',SYS);

%==========================================================
case 'PlotEig'                                  %...PlotEig
%==========================================================
%black, solid static line for eigenvector orbit
%use .ifit field

switch SYS.algo
    
case 'SVD'
ieig=RSP(plane).nsvd;

if ieig==0 return; end

set(orbfig,'currentaxes',SYS.handles.ahbpm);

ylim=get(SYS.handles.ahbpm,'YLim');
val=0.5*ylim(2)/max(abs(RSP(plane).u(ieig,:)));   %columns are .ifit bpms
yd=val*RSP(plane).u(ieig,:);
xd=orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting

set(SYS.handles.lheig,'LineWidth',1.5,'XData',xd,'YData',yd);

%orbvect=RSP(plane).c(BPM(plane).ifit,COR(plane).ifit)*corvect;
%val=((BPM(plane).act(BPM(plane).ifit)-...
%      BPM(plane).abs(BPM(plane).ifit))'*orbvect)/...
%    (orbvect'*orbvect);
end   %end case

%=============================================================
case 'BPMSelect'                          % *** BPMSelect ***
%=============================================================
%used if mouse clicks anywhere in BPM window
cpa = get(SYS.handles.ahbpm,'CurrentPoint');
pos=cpa(1);

switch SYS.xscale
case 'meter' 
id=find(min(abs(BPM(plane).z-pos))==abs(BPM(plane).z-pos));
case 'phase'
id=find(min(abs(BPM(plane).phi-pos))==abs(BPM(plane).phi-pos));
end

BPM(plane).id=id;

setappdata(0,'BPM',BPM);

b = BPM(plane).hicon(id);

bpmgui('BPMBar');

updateicons(SYS, BPM);

bpmgui('ProcessBPM',id,b);

%=============================================================
case 'BPMBar'                              % *** BPMBar ***
%=============================================================
%move black line in window to indicate selection
id=BPM(plane).id;
ylim=get(SYS.handles.ahbpm,'YLim');

if isempty(find(BPM(plane).status==id))
yd=[ylim(1)/4,ylim(2)/4];
else
yd=[BPM(plane).des(id)-BPM(plane).abs(id)+ylim(1)/4,BPM(plane).des(id)-BPM(plane).abs(id)+ylim(2)/4];
end

xd=orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
xd=[xd(id) xd(id)+0.001];

set(SYS.handles.lhbid,'XData',xd,'YData',yd);
  
%=============================================================
case 'BPMDown'                              % *** BPMDown ***
%=============================================================
%used if mouse clicks directly on BPM
b = gcbo;
bptag=get(b,'tag');
id = str2num(bptag(2:length(bptag))); %strip off 'b' to get the bpm index
BPM(plane).id=id;
setappdata(0,'BPM',BPM);

bpmgui('ProcessBPM',id,b);

%=============================================================
case 'ProcessBPM'                            % *** ProcessBPM ***
%=============================================================
%put BPM data into text fields.
%if BPM.mode=1, display, toggle
%if BPM.mode=2, display, drag

%identify BPM handle and number
id=varargin{1}; %bpm number 'id'
b =varargin{2}; %bpm graphics handle 'b'         

%check to see if bpm available
if isempty(find(BPM(plane).avail==id)) %put fit value in offset box and in request box        
  bpmgui('UpdateBPMBox');
return; 
end

%====================
%   TOGGLE MODE
%====================
if BPM(plane).mode==1                                %BPMs in toggle mode
    
    if isempty(BPM(plane).ifit)     %no BPMs chosen yet, this is the first one
        BPM(plane).ifit(1)=id;
        setappdata(0,'BPM',BPM);
        set(b,'MarkerFaceColor','g');
        set(orbfig,'WindowButtonUpFcn','bpmgui(''Up'')');
        return
    end
    
    if ~isempty(find(BPM(plane).ifit==id))                                  %BPM presently on for fit
    set(b,'MarkerFaceColor','y');
    BPM(plane).ifit(find(BPM(plane).ifit==id))=0;                           %set element in list to zero
    BPM(plane).ifit=BPM(plane).ifit(find(BPM(plane).ifit));                 %compress list
    BPM(plane).ifit=BPM(plane).ifit(:);                                     %create column vector
    setappdata(0,'BPM',BPM);

    elseif isempty(find(BPM(plane).ifit==id)) & ~isempty(find(BPM(plane).avail==id))     %BPM presently not on for fit
    set(b,'MarkerFaceColor','g');
    t=BPM(plane).ifit(:);
    
    %disp(['ID = ' num2str(id)]);
    t=sort([t; id]);
    BPM(plane).ifit=t;
    setappdata(0,'BPM',BPM);
    end
    set(orbfig,'WindowButtonUpFcn','bpmgui(''Up'')')


%====================
%   DRAG MODE
%====================
elseif BPM(plane).mode==2                                    %BPMs in drag mode
selectbpm=['bpmgui(''MoveBPM'',' num2str(b) ', ' num2str(id) ');'];
set(orbfig,'WindowButtonMotionFcn',selectbpm);
set(orbfig,'WindowButtonUpFcn','bpmgui(''Up'')');
end    %...end mode=2 (drag) condition

bpmgui('UpdateBPMBox');

%=============================================================
case 'MoveBPM'                              % *** MoveBPM ***
%=============================================================
%This function is called each time the user moves the mouse in 'down' mode

%reset the y coordinate of the data point on the dashed plot.
%...plot_ydata = get(SYS.handles.desorb, 'YData');  
%plot_ydata(ind) = pos(1,2);  
%the catch: note bpm tags have index progressing
%linearly from start to finish independent of status.
%But plot_ydata has index that skips bpms with bad status.
%must look for position in status vector of the
%bpm with index ind as chosen by the drag command.

b=varargin(1);
b=b{1};
id=varargin(2);
id=id{1};
b=BPM(plane).hicon(id);    %doesn't work without this line - round-off?


%reposition icon for BPM
pos = get(SYS.handles.ahbpm, 'CurrentPoint');
yd=pos(1,2);

BPM(plane).des(id) = yd+BPM(plane).abs(id);
setappdata(0,'BPM',BPM);

%set(b, 'YData', pos(1,2)-BPM(plane).abs(id));  %move the BPM icon to mouse position
set(b, 'YData', yd);  %move the BPM icon to mouse position

%re-plot red dotted line (desired orbit)
%%%%
bpmgui('PlotDes');
bpmgui('BPMBar');
bpmgui('UpdateBPMBox');


%=============================================================
case 'Up'                                  % *** Up ***
%=============================================================
%mouse button is let up, don't respond to motion
set(orbfig,'WindowButtonMotionFcn','',...
		'WindowButtonUpFcn','');
respgui('SolveSystem');
respgui('UpdateFit');
bpmgui('UpdateBPMBox');

%=============================================================
case 'EditDesOrb'                         %***	EditDesOrb ***
%=============================================================
h1=SYS.handles.bpmedit;   %handle of BPM edit box
if isempty(get(SYS.handles.bpmname,'String'))
set(SYS.handles.bpmedit,'String',num2str(0.0));
return; 
end
id=BPM(plane).id;
b = findobj(orbfig,'tag',['b' num2str(id)]);  %handle of bpm
offset=str2double(get(h1,'String'));

if isnan(offset) | ~isnumeric(offset) | ~length(offset)==1
  % flush the bad string out of the edit; replace with current value
  offset=0.0;
  set(h1,'String',num2str(offset));
  disp('Warning: Invalid offset entry.');
  orbgui('LBox','Warning: Invalid offset entry');
end

bpmgui('SetBPMOff',id,b,offset);

orbgui('RefreshOrbGUI'); 

%=============================================================
case 'EditBPMWeight'                 %***	EditBPMWeight ***
%=============================================================
%check if no BPM selected
h1=SYS.handles.editbpmweight;   %handle of BPM weight edit box
if isempty(get(SYS.handles.bpmname,'String'))
set(SYS.handles.editbpmweight,'String',num2str(1.0));
return; 
end

id=BPM(plane).id;
b = findobj(orbfig,'tag',['b' num2str(id)]);  %handle of bpm
weight=str2double(get(h1,'String'));

if isnan(weight) | ~isnumeric(weight) | ~length(weight)==1
  % flush the bad string out of the edit; replace with current value
  weight=1.0;
  set(h1,'String',num2str(weight));
  disp('Warning: Invalid weight entry.');
  orbgui('LBox','Warning: Invalid weight entry');
end

BPM(plane).wt(id)=weight; 
setappdata(0,'BPM',BPM);

orbgui('RefreshOrbGUI'); 

%=============================================================
case 'SetBPMOff'                         %***	SetBPMOff ***
%=============================================================
%Callback of the BPM offset edit box.
%resets the dashed red line and BPM icon position.
%For details, see "BPMmove" above.
%calling sequence:bpmgui('SetBPMOff',id,b,offset);

%identify BPM handle and number
id=varargin(1);   %bpm number 'id' comes through varargin
id=id{1};
b=varargin(2);
b=b{1};           %bpm handle 'b' comes through varargin
offset=varargin(3);
offset=offset{1};

BPM(plane).des(id)=BPM(plane).ref(id)-BPM(plane).abs(id) + offset; 
setappdata(0,'BPM',BPM);

yd=BPM(plane).des(id);
set(b,'YData',yd);   %moves the icon on screen

bpmgui('PlotDes');

%=============================================================
case 'UpdateBPMBox'                     % *** UpdateBPMBox ***
%=============================================================
%update BPMBox
%called from respgui(SVDSlide),respgui(SVDEdit) 
id=BPM(plane).id;
%check to see if bpm available
if isempty(find(BPM(plane).avail==id)) %put fit value in offset box and in request box        
  bpmgui('BPMBox',BPM(plane).name(id,:),BPM(plane).act(id),...
                0,0,0,0,0,0,id,getrf);
return; 
else
%compute desired offset from reference orbit
offset=BPM(plane).des(id)-BPM(plane).ref(id);
%compute fitted fitted value
fitval=BPM(plane).fit(id)+(BPM(plane).act(id)-BPM(plane).abs(id));
%compute orbit rms
rf_freq = getrf('struct');  % There can be more than one cavity.
% Convert into MHz units; replaced "factor" with "thisfactor" Eugene
% 1/2/2007
if strcmpi(lower(rf_freq.UnitsString),'hz')
    thisfactor = 1e-6;
elseif strcmpi(lower(rf_freq.UnitsString),'khz')
    thisfactor = 1e-3;
else
    thisfactor = 1;
end 

sig=sqrt(var(BPM(plane).act(BPM(plane).status)-BPM(plane).des(BPM(plane).status)));
bpmgui('BPMBox',BPM(plane).name(id,:),BPM(plane).act(id),...
                BPM(plane).ref(id),offset,BPM(plane).wt(id),BPM(plane).des(id),...
                fitval,sig,id,rf_freq.Data(1)*thisfactor)
end

%=============================================================
case 'BPMBox'                            % *** BPMBox ***
%=============================================================
%bpmgui('BPMBox',BPM(plane).name(id,:),BPM(plane).act(id),...
%                BPM(plane).ref(id),BPM(plane).des(id),fitval,id);
bpmname =   SYS.handles.bpmname;
actual =    SYS.handles.bpmact;
reference = SYS.handles.bpmref;
offedit =   SYS.handles.bpmedit;
wtedit =    SYS.handles.editbpmweight;
desire =    SYS.handles.bpmdes;
fitval =    SYS.handles.bpmfit;
rmsval =    SYS.handles.bpmrms;
freq   =    SYS.handles.rffrequency;

name=varargin{1};
act =varargin{2};
ref =varargin{3};
off =varargin{4};
wt  =varargin{5};
des =varargin{6};
fit =varargin{7};
rms =varargin{8};
id  =varargin{9};
rf  =varargin{10};

set(bpmname,  'String',[name '  (',num2str(id),')']);
set(actual,   'String',num2str(act, '%6.3f'));
set(reference,'String',num2str(ref, '%6.3f'));
set(offedit,  'String',num2str(off, '%6.3f'));
set(wtedit,   'String',num2str(wt,  '%6.3f'));
set(desire,   'String',num2str(des, '%6.3f'));
set(fitval,   'String',num2str(fit, '%6.3f'));
set(rmsval,   'String',num2str(rms, '%6.3f'));
set(offedit,  'UserData',id);
set(freq,     'String',[num2str(rf(1), '%11.6f') ' MHz']);

%=============================================================
case 'RePlot'                                 % *** RePlot ***
%=============================================================
%plot reference, desired, actual, icons
set(orbfig,'currentaxes',SYS.handles.ahbpm)
%could replace these calls with PlotRef, PlotAct, etc
   
bpmgui('PlotRef');
bpmgui('PlotDes');
bpmgui('PlotAct');
bpmgui('PlotFit');
bpmgui('PlotBPMs');  %plots icons
bpmgui('ylimits');
bpmgui('BPMBar');

%==========================================================
case 'ClearPlots'                        %...ClearPlots
%==========================================================
%clear columns of response matrix, orbit-eigenvectors and fit plots.

set(orbfig,'currentaxes',SYS.handles.ahbpm)
set(SYS.handles.lhrsp,'XData',[],'YData',[]);
set(SYS.handles.lheig,'XData',[],'YData',[]);
set(SYS.handles.lhfit,'XData',[],'YData',[]); 

%=============================================================
case 'SelectAll'                           % *** SelectAll ***
%============================================================
BPM(plane).ifit=[];
navail=length(BPM(plane).avail);
for kk = 1:navail
        k=BPM(plane).avail(kk);
 		    hbpm=BPM(plane).hicon(k);;
        set(hbpm,'MarkerFaceColor','g');
        BPM(plane).ifit(kk)=k;
end 

setappdata(0,'BPM',BPM);

orbgui('RefreshOrbGUI');

%=============================================================
case 'SelectNone'                           % *** SelectNone ***
%=============================================================
BPM(plane).ifit=[];
navail=length(BPM(plane).avail);
for kk = 1:navail
        k=BPM(plane).avail(kk);
        hbpm=BPM(plane).hicon(k);
        set(hbpm,'MarkerFaceColor','y');
end   

setappdata(0,'BPM',BPM);

orbgui('RefreshOrbGUI');

%respgui('FitOff',num2str(plane));

%==========================================================
case 'ToggleMode'                      % *** ToggleMode ***
%==========================================================
%callback of the bpm toggle radio button
%radio button toggles state and then executes callback
%hence, this routine finds the new state

if get(SYS.handles.togglebpm,'Value')==0 & get(SYS.handles.dragbpm,'Value')==0
BPM(plane).mode=0;           %'0' for display only
else
set(SYS.handles.dragbpm,'Value',0);
BPM(plane).mode=1;           %'1' for toggle mode
end

setappdata(0,'BPM',BPM);

%==========================================================
case 'DragMode'                          % *** DragMode ***
%==========================================================
%callback of the bpm drag radio button
%radio button toggles state and then executes callback
%hence, this routine finds the new state

if get(SYS.handles.togglebpm,'Value')==0 & get(SYS.handles.dragbpm,'Value')==0
BPM(plane).mode=0;           %'0' for display only
else
set(SYS.handles.togglebpm,'Value',0);
BPM(plane).mode=2;           %'2' for drag mode
end

setappdata(0,'BPM',BPM);

%===========================================================
case 'ShowBPMState'                    %*** ShowBPMState ***
%===========================================================
% Show bpm settings
  tavail=zeros(1,length(BPM(plane).name));
  tfit=zeros(1,length(BPM(plane).name));
  tstatus=zeros(1,length(BPM(plane).name));

  for ii=1:length(BPM(plane).name)
  if ~isempty(find(BPM(plane).avail==ii)) tavail(ii)=ii;  end
  if ~isempty(find(BPM(plane).ifit==ii)) tfit(ii)=ii;  end
  if ~isempty(find(BPM(plane).status==ii)) tstatus(ii)=ii;  end
  end
  
  
    ref=BPM(plane).ref;
    des=BPM(plane).des;
    babs=BPM(plane).abs;
    act=BPM(plane).act;
    fit=BPM(plane).fit;
    wt=BPM(plane).wt;
     
  fprintf('%s\n','index name       stat  avail  ifit     ref        des          abs       act         fit       weight');
  for ii=1:length(BPM(plane).name)
  fprintf('%3d %10s %5d %5d %5d %10.3f %10.3f %12.3f %10.3f %10.3f %10.3f\n',...
  ii, BPM(plane).name(ii,:),tstatus(ii),tavail(ii),tfit(ii),ref(ii),des(ii),babs(ii),act(ii),fit(ii),wt(ii));
  end

%===========================================================
otherwise
disp(['Warning: no CASE found in bpmgui: ' action]);
end  %end switchyard