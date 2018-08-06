function sofbgui(action,varargin)
%**********************
%initiate slow orbit feedback

if nargin==0         %no input - build initial graphics
SYS.timermode=1;     %timer mode=1 for timer, 0 for single step
SYS.setsp=1;        %setsp=1 for active sets, 0 for no sets

%check if feedback timer already running
  if SYS.timermode
  t=timerfind('Tag','SOFBtimer');    
    if ~isempty(t)
      if strcmp(t.Running,'on');
        ts = datestr(now,0);
        msgbox([ts ': Warning - Feedback Already Active'],'Error Message','error');
      return
      end
    end
  end  %end timermode

sofblib('SetStructures',[],SYS,[],[],[],[]);

if ~isempty(findobj('Tag','SOFBPanel'))    %delete existing figure, generate new figure
  delete(findobj('Tag','SOFBPanel')); 
end


sofblib('CreateGUI');   %create GUI

disp('   initializing feedback parameters...');   %load feedback parameters
bootsofb;
[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

%open system log file if requested
if SYS.LogFlag
  % %open file
  % ts = datestr(now,0);
  % tmp=['SOFB-' ts ];
  % fname=[tmp(1:16) '-' tmp(18:19) tmp(21:22) tmp(24:25)];
  % save (fname,datestr(now,0),'SYS','BPM','COR','BL','RSP');
end

%initiate single timer for slow orbit feedback
if SYS.timermode
  SOFBtimer=timer; 
  SOFBtimer.ExecutionMode = 'fixedRate';
  SOFBtimer.Tag='SOFBtimer'; 
  set(SOFBtimer,'Tag','SOFBtimer');  %*
  SOFBtimer.TasksToExecute = 9999999;
  setappdata(0,'SOFBTimer',SOFBtimer);
end

%save to appdata
sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);
disp('   done initializing feedback');
return
end   %end nargin==0 initialization


%*************************************
%        begin switchyard
%*************************************
%retrieve data structures from appdata and timer handle
[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

if SYS.timermode
    SOFBtimer=getappdata(0,'SOFBTimer');
end

switch action

%**************************************************************        
case 'Start'
%**************************************************************        
%callback of the START button for slow orbit feedback
%remove bpms where photon beamlines are selected
%routine invert response matrix both planes

set(handles.Start,'Enable','off');

%Measure actual orbit, reference correctors
for k=1:2
  val=getam(BPM(k).family);
  BPM(k).act(BPM(k).status)=val(BPM(k).goodindex);   %goodindex is subset of status in middlelayer
  COR(k).ref(COR(k).status)=getsp(COR(k).family);
end

%set initial trip levels
BPM(1).dev=4*BPM(1).maxdev;     %four times trip window for initial orbit correction
BPM(2).dev=4*BPM(2).maxdev;
BL(2).dev =BL(2).maxdev;
COR(1).dev=COR(1).maxdev;  
COR(2).dev=COR(2).maxdev;
sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);

sofblib('CalcInverse');

[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');
set(handles.BLFit,'Enable','Off');                    %disable beamline selection

%perform initial orbit correction, then reduce orbit deviation window
setpv('SPEAR:SOFBStatus',1);      %run flag in EPICS
sofblib('CorrectOrbit');   %perform single orbit correction
[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');
pause(round(SYS.SOFB.timerperiod));
BPM(1).dev=BPM(1).maxdev;  
BPM(2).dev=BPM(2).maxdev;
sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);


if SYS.timermode
        SOFBtimer.TimerFcn = 'sofblib(''TimerTryCatch'')';
        SOFBtimer.period = SYS.SOFB.timerperiod;
        start(SOFBtimer);
end

%**************************************************************    
case 'StopFlag'
%**************************************************************    
%set Stop flag
setpv('SPEAR:SOFBStatus',0);           %run flag in EPICS
setpv('SPEAR:SOFBNumCycle',0);         %cycle number in EPICS
SYS.stop = 1;
sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);
sofbgui('Stop')

%**************************************************************    
case 'Stop'
%**************************************************************    
%stop global feedback

sofbgui('EnableOff');

set(handles.Start,'Enable','on');
str=['Stop Global Feedback:' ' ' datestr(now,0)];
set(handles.Cycle,'String',str);
set(handles.Cycle,'BackGroundColor',[0.831373 0.815686 0.784314]);   %grey

if SYS.timermode
  stop(SOFBtimer);
end

SYS.cycle=0;
SYS.stop=0;
SYS.nerror=0;                                         %try/catch counter
%set(handles.BLFit,'Enable','On');                    %disable beamline selection
%set(handles.BLFit,'Enable','off');


sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);


%**************************************************************        
case 'EnableOff'
%**************************************************************        
%disable all pushbuttons

if ~strcmp(action,'CorrectOrbit')
set(handles.Start, 'Enable','off');
set(handles.Stop,  'Enable','off');
end

%**************************************************************   
case 'RFFit'
%**************************************************************  
[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

if get(handles.RFFit,'Value');
    SYS.rf           = 1;              %rf fitting flag
    SYS.rfcor        = 1;              %rf-corrector fitting flag
    disp('RF Fit On');
else
    SYS.rf           = 0;              %rf fitting flag
    SYS.rfcor        = 0;              %rf-corrector fitting flag
    disp('RF Fit Off');
end

sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);


%**************************************************************   
case 'BeamlineFit'
%************************************************************** 
[handles,SYS,BPM,BL,COR,RSP]=sofblib('GetStructures');

if get(handles.BLFit,'Value');
    SYS.photon           = 1;                     %photon BPM fitting flag
    sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);
%     %Remove bpms associated with photon bpms
%     if  ~isempty(BL(2).ifit)
%       %sofblib('RemoveBeamlineBPM');
%     end
    disp('Photon Beamline Fit On');
else
    SYS.photon           = 0;                     %photon BPM fitting flag
    sofblib('SetStructures',handles,SYS,BPM,BL,COR,RSP);
    disp('Photon Beamline Fit Off');
%     %Return bpms associated with photon bpms
%     if  ~isempty(BL(2).ifit)
%       %sofblib('ReplaceBeamlineBPM');
%     end
end

%==========================================================
case 'CloseMainFigure'                    %CloseMainFigure
%==========================================================
answer = questdlg('Exit Slow Orbit Feedback GUI?','Exit Orbit Control Program','Yes','No','Yes');

switch answer 
  case 'Yes'
    disp('   Exiting Orbit Feedback Panel');
    delete(handles.fig);
    sofbgui('KillTimer')
    setappdata(0,'SOFB_structures',[]);
  otherwise
    return
end

%**************************************************************   
case 'KillTimer'
%**************************************************************   
if SYS.timermode
 SOFBtimer=getappdata(0,'SOFBTimer');
 stop(SOFBtimer);
 delete(SOFBtimer);
 clear  SOFBtimer;
 
 
 
 t=timerfind;
 for k=1:length(t)
     if strcmpi(t(k).Tag,'SOFBtimer')
         stop(t(k));
         delete(t(k));
     end
 end
 
 
end

%**************************************************************   
otherwise
%**************************************************************   
disp(['Warning: CASE not found in SOFB ' action]);

end  %end switchyard
