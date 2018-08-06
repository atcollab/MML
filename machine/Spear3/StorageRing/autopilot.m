function autopilot(action,varargin)

%=============================================================
% Auto Pilot Automated bucket selection software
%
% This routine automatically cycles through the current fill
% pattern at 5 Hz.  Option to reset to 1st bucket when 96mA
% SPEAR current is stored (for "mondo" bucket)
%                                           -Leif 23DEC2002
% General clean-up of code.  Added option to have Buck-o-mat
% run LTB B1 magnet to zero when SPEAR current reaches 100mA.
%                                           -Leif 19FEB2003
% Modified timer to switch only when ~1mA has been added to
% any given bucket.  Attempt to get cleaner fill pattern.
% This comment added late (21JULY2003).
%                                           -Leif 20MAR2003
%=============================================================

%**********************
%build graphics and initiate bucket filling
%switchyard construction for button controls
%retrieve timer from appdata every time function entered
%**********************

%check to see if autopilot panel exists
h=findobj(0,'tag','autopilot');
if ~isempty(h)
	autopilottimer=getappdata(h,'autopilotTimer');
	autopilotSYS=getappdata(h,'SystemParameters');
	autopilotCTRL=getappdata(h,'SystemControl');
end

%-----------------------------------------------------------------
% Initialize if no input arguement
%-----------------------------------------------------------------
if nargin==0
	
	%check to see if autopilot timer already running
	t=timerfind('Tag','autopilottimer');    
      if ~isempty(t)
        if strcmp(t.Running,'on');
        ts = datestr(now,0);
        msgbox([ts ': Warning - autopilot Already Active'],'Error Message','error');
        return
        end
      end
	
      
%----------------------------------------------------------------
%  create initial figure
%----------------------------------------------------------------
	h = findobj(0,'tag','autopilot');  
	if ~isempty(h) 
        delete(h); 
	end
	[screen_wide, screen_high]=screensizecm;
	fig_start = [0.34*screen_wide 0.005*screen_high];
	fig_size = [0.25*screen_wide 0.15*screen_high];

    %----------------------------------------------------------------
	figh=figure('units','centimeters',...                      %...Figure
           'Position',[fig_start fig_size],...
			'tag','autopilot',... 
			'NumberTitle','off',...
            'Doublebuffer','on',...
            'Visible','Off',...
			'Name','-=AUTO PILOT=-',...
			'PaperPositionMode','Auto');

	%----------------------------------------------------------------
    
	set(figh,'MenuBar','None');
	set(figh,'DeleteFcn','autopilot(''killtimer'')');
	
%     %----------------------------------------------------------------
%     %Figure Title
%     %----------------------------------------------------------------
%     uicontrol('Style','text',...	               %...Title text
%            'units', 'normalize', ...
%            'Position', [.10 .82 .80 .16], ...
%            'ForeGroundColor','k',...
%            'String','Auto Pilot',...
%            'Value',0,...
%            'Tag','titletext',...
%            'ToolTipString','Auto Pilot',...
%            'Backgroundcolor','b',...
%            'Foregroundcolor','w',...
%            'FontSize',12,'FontWeight','demi');
% 	
    %----------------------------------------------------------------
    %Dynamic Text (DCCT value and Bucket number) Fields
    %----------------------------------------------------------------
    uicontrol('Style','text',...                    %...Selected bucket display	                      
           'units', 'normalize', ...
           'Position', [.10 .82 .40 .16], ...
           'ForeGroundColor','k',...
           'BackGroundColor',[0.831373 0.815686 0.784314],...
           'String','',...
           'Tag','bucket',...
           'ToolTipString','Selected bucket display',...	
           'FontSize',10,'FontWeight','demi');
       
    uicontrol('Style','text',...                    %...SPEAR DCCT current display	                      
           'units', 'normalize', ...
           'Position', [.50 .82 .40 .16], ...
           'ForeGroundColor','k',...
           'BackGroundColor',[0.831373 0.815686 0.784314],...
           'String','',...
           'Tag','dcct',...
           'ToolTipString','SPEAR DCCT current display',...	
           'FontSize',10,'FontWeight','demi');
            
	%----------------------------------------------------------------
	% START/STOP and PAUSE/RESUME control pushButtons
	%----------------------------------------------------------------
    uicontrol('Style','pushbutton',...	                  %...autopilotstart                    
           'units', 'normalize', ...
           'Position', [.10 .45 .4 .35], ...
           'ForeGroundColor','k',...
           'String','Start','Enable','on',...
           'Tag','autopilotstart',...
           'Value',0,...
           'ToolTipString','Start autopilot',...	
           'FontSize',12,'FontWeight','demi',...
           'Callback','autopilot(''autopilotstart'')');  
       
    uicontrol('Style','pushbutton',...	                 %...autopilotpause        
           'units', 'normalize', ...
           'Position', [.50 .45 .4 .35], ...
           'ForeGroundColor','k',...
           'String','Pause','Enable','off',...
           'Tag','autopilotpause',...
           'ToolTipString','Pause autopilot',...	
           'FontSize',12,'FontWeight','demi',...
           'Callback','autopilot(''pauseflag'')');
	
	%----------------------------------------------------------------
	%Check-box: Automatic triggers for injection - default: NOT-active
	%----------------------------------------------------------------
    uicontrol('Style','checkbox',...
            'units','normalize',...
            'Position', [.10 .30 .04 .12],...
            'ForeGroundColor','k',...
            'ToolTipString','Automatically turn on triggers?',...
            'Value',0,...
            'Tag','inject');
        
    uicontrol('Style','text',...                    %...Auto Inject checkbox text
          'units', 'normalize', ...
           'Position', [.14 .30 .35 .12], ...
           'ForeGroundColor','k',...
           'String','Auto Inject',...
           'FontSize',9,'FontWeight','demi');
     
    %----------------------------------------------------------------
    %Slider: Auto Inject DCCT level setpoint - default: 85mA
    %----------------------------------------------------------------
    uicontrol('Style','slider',...
            'units','normalize',...
            'Position',[.02 .18 .06 .80],...
            'ForeGroundColor','k',...
            'ToolTipString','DCCT level to start injection',...
            'Min',0,...
            'Max',500,...
            'Value',85,...
            'SliderStep',[.002 .01],...
            'Tag','injectslider',...
            'Callback',@injectslider_Callback);
        
    uicontrol('Style','edit',...
            'units','normalize',...
            'Position',[.01 .05 .13 .10],...
            'ForeGroundColor','k',...
            'ToolTipString','DCCT level to start injection',...
            'String','85',...
            'Tag','injectvalue',...
            'Callback',@injectvalue_Callback,...
            'FontSize',9,'FontWeight','demi');
        
    %----------------------------------------------------------------
	%Check-box: Automatic shut-off when filled - default: active
	%----------------------------------------------------------------
    uicontrol('Style','checkbox',...
            'units','normalize',...
            'Position', [.50 .30 .04 .12],...
            'ForeGroundColor','k',...
            'ToolTipString','Automatically shut off triggers?',...
            'Value',1,...
            'Tag','shutoff');
        
    uicontrol('Style','text',...                    %...Auto Shut-Off checkbox text
           'units', 'normalize', ...
           'Position', [.55 .30 .35 .12], ...
           'ForeGroundColor','k',...
           'String','Auto Shut-Off',...
           'FontSize',9,'FontWeight','demi');
     
    %----------------------------------------------------------------
    %Slider: Auto Shut-Off DCCT level setpoint - default: 100mA
    %----------------------------------------------------------------
       uicontrol('Style','slider',...
            'units','normalize',...
            'Position',[.92 .18 .06 .80],...
            'ForeGroundColor','k',...
            'ToolTipString','DCCT level to stop injection',...
            'Min',0,...
            'Max',500.,...
            'Value',100,...
            'SliderStep',[0.002 0.01],...
            'Tag','shutoffslider',...
            'Callback',@shutoffslider_Callback);
     
    uicontrol('Style','edit',...
            'units','normalize',...
            'Position',[.86 .05 .13 .10],...
            'ForeGroundColor','k',...
            'ToolTipString','DCCT level to stop injection',...
            'String','100',...
            'Tag','shutoffvalue',...
            'Callback',@shutoffvalue_Callback,...
            'FontSize',9,'FontWeight','demi');
            
    %----------------------------------------------------------------
    %Slider: Current per bunch - default: 0.1mA
    %----------------------------------------------------------------
       uicontrol('Style','slider',...
            'units','normalize',...
            'Position',[.10 .17 .80 .10],...
            'ForeGroundColor','k',...
            'ToolTipString','Current per bunch',...
            'Min',0,...
            'Max',25,...
            'Value',0.1,...
            'SliderStep',[0.004 0.04],...
            'Tag','bunchslider',...
            'Callback',@bunchslider_Callback);
     
    uicontrol('Style','edit',...
            'units','normalize',...
            'Position',[.43 .05 .14 .10],...
            'ForeGroundColor','k',...
            'ToolTipString','Current per bunch',...
            'String','0.1',...
            'Tag','bunchvalue',...
            'Callback',@bunchvalue_Callback,...
            'FontSize',9,'FontWeight','demi');
            
    %----------------------------------------------------------------
	%Get handles for all necessary Channel Acces Process Variables
    %----------------------------------------------------------------
	if ~mcaisopen('inj:spr_bucket.first_buck_sel_ds')
	autopilotSYS.first_bucket = mcaopen('inj:spr_bucket.first_buck_sel_ds');
	end
	if ~mcaisopen('inj:spr_bucket.next_buck_sel_ds')
	autopilotSYS.next_bucket  = mcaopen('inj:spr_bucket.next_buck_sel_ds');
	end
	if ~mcaisopen('inj:inj_timing.bucket_as')
	autopilotSYS.inj_timing  = mcaopen('inj:inj_timing.bucket_as');
	end
	if ~mcaisopen('SPEAR:BeamCurrAvg')
	autopilotSYS.dcct_handle= mcaopen('SPEAR:BeamCurrAvg');
	end
	if ~mcaisopen('LINAC:ChopStateSetpt')
        autopilotSYS.chopper = mcaopen('LINAC:ChopStateSetpt');
	end
	if ~mcaisopen('118DG1:TrigModeSetpt')
        autopilotSYS.kicker12 = mcaopen('118-DG1:TrigModeSetpt');
	end
	if ~mcaisopen('118DG2:TrigModeSetpt')
        autopilotSYS.kicker3 = mcaopen('118-DG2:TrigModeSetpt');
	end
		
    setappdata(figh,'SystemParameters',autopilotSYS);

    %----------------------------------------------------------------
	%INITIALIZE GENERAL autopilot PARAMETERS
	%----------------------------------------------------------------
	disp('   Initializing general autopilot parameters...');
	autopilotCTRL.dcct_start=0;
    autopilotCTRL.injection=0;
%     autopilotCTRL.trigs=[autopilotSYS.kicker12;autopilotSYS.kicker3];
    autopilotCTRL.grey=[0.831373 0.815686 0.784314];   %grey color
    setappdata(figh,'SystemControl',autopilotCTRL);
	
    %----------------------------------------------------------------
	%initiate a single timer
    %----------------------------------------------------------------
	autopilottimer=timer; 
	autopilottimer.ExecutionMode = 'fixedRate';
	autopilottimer.Tag='autopilottimer'; 
	autopilottimer.TasksToExecute = 100000000;
	autopilottimer.period = .2;
	setappdata(figh,'autopilotTimer',autopilottimer);
    
    %----------------------------------------------------------------
    %Make autopilot figure visible but protect from being overwritten
    %----------------------------------------------------------------
    set(figh,'Visible','On');
	
	return                              % End initialization (isempty(varargin))
end                                     % Return and wait for b


%*************************************
%        begin main switchyard
%*************************************

handles=guihandles(findobj(0,'Tag','autopilot'));
autopilotSYS=getappdata(handles.autopilot,'SystemParameters');  %reload autopilotSYS
autopilotCTRL=getappdata(handles.autopilot,'SystemControl');    %reload autopilotCTRL

switch action

%**************************************************************        
case 'autopilotstart'
%**************************************************************
	%callback of the START button for autopilot
	
	%enable pause/stop buttons
	set(handles.autopilotpause,'Enable','on');
	set(handles.autopilotstart,'String','Stop');
	set(handles.autopilotstart,'ToolTipString','Stop autopilot');
	set(handles.autopilotstart,'Callback','autopilot(''autopilotstop'')');
	set(handles.autopilotpause,'String','Pause');
	set(handles.autopilotpause,'ToolTipString','Pause autopilot');
	set(handles.autopilotpause,'Callback','autopilot(''autopilotpause'')');
	
    %Get & display initial DCCT reading & set default starting parameters
    autopilotCTRL.dcct_start=mcaget(autopilotSYS.dcct_handle);
    dcct_str=['DCCT start current = ' num2str(autopilotCTRL.dcct_start)];
    disp(dcct_str);
	%autopilotCTRL.pattern=1;
    %autopilotCTRL.stop_str=['STOPPED'];
    %autopilotCTRL.stop_color=[0.831373 0.815686 0.784314];   %grey
	setappdata(handles.autopilot,'SystemControl',autopilotCTRL);
    
    %Select first bucket in pattern
	mcaput(autopilotSYS.first_bucket,1);
    
    %If auto-inject is selected, display "ARMED" warning in red
    if (get(findobj(0,'Tag','inject'),'Value') == get(findobj(0,'Tag','inject'),'Max'))
        bucket_str='ARMED!';
	    set(handles.bucket,'String',bucket_str,'BackGroundColor','r');
        autopilotCTRL.injection=0;
        setappdata(handles.autopilot,'SystemControl',autopilotCTRL);
    else
        autopilotCTRL.injection=1;
        setappdata(handles.autopilot,'SystemControl',autopilotCTRL);
    end
   
    %launch autopilot timer
	autopilottimer.TimerFcn = 'autopilot(''addcurrent'')';
	autopilotSYS.cycle=0;
	
	setappdata(handles.autopilot,'SystemParameters',autopilotSYS);
	
	start(autopilottimer);
            
%**************************************************************
case 'addcurrent'
%**************************************************************        
	%Callback of the autopilottimer when running.
    
    %Check delta current to see if it's time to change buckets
    dcct=mcaget(autopilotSYS.dcct_handle);
    if dcct >= (autopilotCTRL.dcct_start + get(handles.bunchslider,'Value')) && autopilotCTRL.injection == 1
	    mcaput(autopilotSYS.next_bucket,1);  %Then switch to the next bucket
        autopilotCTRL.dcct_start=dcct;     %Set new dcct_start point
        setappdata(handles.autopilot,'SystemControl',autopilotCTRL);
        dcct_str=['New DCCT start current = ' num2str(autopilotCTRL.dcct_start)];
        disp(dcct_str);
        %Update the selected bucket display
	    bucket_str=['Bucket: ' num2str(mcaget(autopilotSYS.inj_timing))];
	    set(handles.bucket,'String',bucket_str,'BackGroundColor','g');
        disp(bucket_str);
    end
	
    %If Auto Inject is selected and DCCT < injectslider value
    %Then turn on SPEAR kicker and linac chopper triggers
    if (get(findobj(0,'Tag','inject'),'Value') == get(findobj(0,'Tag','inject'),'Max'))
        if dcct <= get(handles.injectslider,'Value') && autopilotCTRL.injection == 0
            %First turn on the SPEAR kicker and linac chopper triggers
%              mcaput(autopilotCTRL.trigs,[1;1]); %Set chopper & kickers to External mode
             mcaput(autopilotSYS.chopper,0); %External mode
             mcaput(autopilotSYS.kicker12,1); %External mode
             mcaput(autopilotSYS.kicker3,1); %External mode
            %Update the selected bucket display
	        bucket_str=['Bucket: ' num2str(mcaget(autopilotSYS.inj_timing))];
	        set(handles.bucket,'String',bucket_str,'BackGroundColor','g');
            %Check if DCCT reading is below previous reference point
            if dcct < autopilotCTRL.dcct_start      %If so, then set a
                autopilotCTRL.dcct_start=dcct;      %New dcct_start reference point
                setappdata(handles.autopilot,'SystemControl',autopilotCTRL);
                dcct_str=['New DCCT start current = ' num2str(autopilotCTRL.dcct_start)];
                disp(dcct_str);
            end
            autopilotCTRL.injection=1;
            setappdata(handles.autopilot,'SystemControl',autopilotCTRL);
        end
    end

    %If Auto Shut-Off is selected and DCCT > shutoffslider value
    %Then shut off SPEAR kicker and linac chopper triggers
	if (get(findobj(0,'Tag','shutoff'),'Value') == get(findobj(0,'Tag','shutoff'),'Max'))
        if dcct >= get(handles.shutoffslider,'Value') && autopilotCTRL.injection == 1
            %Shut off SPEAR kicker and linac chopper triggers
%             mcaput(autopilotCTRL.trigs,[2;2]); %Set chopper & kickers to One-shot mode
            mcaput(autopilotSYS.chopper,1); %One-shot mode
            mcaput(autopilotSYS.kicker12,2); %One-shot mode
            mcaput(autopilotSYS.kicker3,2); %One-shot mode
            %Then switch to the next bucket (for next injection cycle)
            mcaput(autopilotSYS.next_bucket,1);
            %If Auto Inject is selected, then re-display the "ARMED!" warning in red
            if (get(findobj(0,'Tag','inject'),'Value') == get(findobj(0,'Tag','inject'),'Max'))
                bucket_str='ARMED!';    %Display "ARMED!" warning in red
                set(handles.bucket,'String',bucket_str,'BackGroundColor','r');
            end
            dcct_str=['DCCT final current = ' num2str(autopilotCTRL.dcct_start)];
            disp(dcct_str);
            autopilotCTRL.injection=0;
            setappdata(handles.autopilot,'SystemControl',autopilotCTRL);
        end
	end

    %Otherwise just update the DCCT current reading
    dcct_str=['DCCT: ' num2str(dcct,5)];
	set(handles.dcct,'String',dcct_str,'BackGroundColor',autopilotCTRL.grey);

%**************************************************************    
case 'autopilotstop'
%**************************************************************    
	%stop autopilot
	stop(autopilottimer);
    
    %Turn off SPEAR kicker and linac chopper triggers
%     mcaput(autopilotCTRL.trigs,[2;2]); %Set chopper & kickers to One-shot mode
    mcaput(autopilotSYS.chopper,1); %Turn chopper triggers OFF (One shot)
    mcaput(autopilotSYS.kicker12,2); %Turn kicker triggers OFF (One Shot)
    mcaput(autopilotSYS.kicker3,2); %Turn kicker triggers OFF (One Shot)
   
    dcct_str=['DCCT final current = ' num2str(autopilotCTRL.dcct_start)];
    disp(dcct_str);
    bucket_str=['Bucket: ' num2str(mcaget(autopilotSYS.inj_timing))];
    disp(bucket_str);
	set(handles.bucket,'String','','BackGroundColor',autopilotCTRL.grey);
	set(handles.dcct,'String','','BackGroundColor',autopilotCTRL.grey);
	set(handles.autopilotpause,'Enable','off');
	set(handles.autopilotstart,'String','Start');
	set(handles.autopilotstart,'ToolTipString','Start autopilot');
	set(handles.autopilotstart,'Callback','autopilot(''autopilotstart'')');
    setappdata(handles.autopilot,'SystemControl',autopilotCTRL);
    autopilotCTRL.injection=0;
    setappdata(handles.autopilot,'SystemControl',autopilotCTRL);
	autopilotSYS.cycle=0;
	setappdata(handles.autopilot,'SystemParameters',autopilotSYS);
	
%**************************************************************    
case 'autopilotpause'
%**************************************************************   
	%pause autopilot
    
	set(handles.dcct,'String','PAUSED');
	set(handles.dcct,'BackGroundColor','y');
	set(handles.bucket,'BackGroundColor','y');
	set(handles.autopilotpause,'String','Resume');
	set(handles.autopilotpause,'ToolTipString','resume autopilot');
	set(handles.autopilotpause,'Callback','autopilot(''autopilotresume'')');
	stop(autopilottimer);
	
    %Turn off SPEAR kicker and linac chopper triggers
%     mcaput(autopilotCTRL.trigs,[2;2]); %Set chopper & kickers to One-shot mode
    mcaput(autopilotSYS.chopper,1); %Turn chopper triggers OFF (One shot)
    mcaput(autopilotSYS.kicker12,2); %Turn kicker triggers OFF (One Shot)
    mcaput(autopilotSYS.kicker3,2); %Turn kicker triggers OFF (One Shot)
  
%**************************************************************   
case 'autopilotresume'
%**************************************************************   
	%return if timer is already running
	if strcmp(autopilottimer.Running,'on');
	return
	end
	dcct=mcaget(autopilotSYS.dcct_handle);
    %Check if DCCT reading is below previous reference point
    if dcct < autopilotCTRL.dcct_start      %If so, then set a
        autopilotCTRL.dcct_start=dcct;      %New dcct_start reference point
        setappdata(handles.autopilot,'SystemControl',autopilotCTRL);
        dcct_str=['New DCCT start current = ' num2str(autopilotCTRL.dcct_start)];
        disp(dcct_str);
    end
    %If Auto Inject is selected, and injecting at less then the shut-off current
    %Then turn on SPEAR kicker and linac chopper triggers
    if (get(findobj(0,'Tag','inject'),'Value') == get(findobj(0,'Tag','inject'),'Max'))
        if dcct >= get(handles.shutoffslider,'Value') && autopilotCTRL.injection == 1
            %First turn on the SPEAR kicker and linac chopper triggers
%             mcaput(autopilotCTRL.trigs,[1;1]); %Set chopper & kickers to External mode
	        mcaput(autopilotSYS.chopper,0); %External mode
	        mcaput(autopilotSYS.kicker12,1); %External mode
	        mcaput(autopilotSYS.kicker3,1); %External mode
        end
    end
	set(handles.autopilotpause,'String','Pause');
	set(handles.autopilotpause,'ToolTipString','Pause autopilot');
	set(handles.autopilotpause,'Callback','autopilot(''autopilotpause'')');
	set(handles.bucket,'BackGroundColor','g');
	set(handles.dcct,'BackGroundColor','g');
	
	start(autopilottimer)
	
%**************************************************************   
case 'killtimer'
%************************************************************** 
	%callback of main gui panel deletefcn
	
	%check to see if feedback timer exists and delete it
	t=timerfind('Tag','autopilottimer');    
	if ~isempty(t)  
        h=findobj(0,'tag','autopilot');
        FDBKtimer=getappdata(h,'autopilotTimer');
        stop(autopilottimer);
        delete(autopilottimer);
        clear  autopilottimer;
	end
	
	%Clear handles from mca calls
	clearmcahandles;
	
%**************************************************************   
otherwise
%**************************************************************   
	disp(['Warning: CASE not found in autopilot ' action]);

end  %end switchyard

function injectslider_Callback(object,eventdata)
handles=guihandles(findobj(0,'Tag','autopilot'));
NewVal=num2str(get(handles.injectslider,'Value'));
set(handles.injectvalue,'String',NewVal);

function injectvalue_Callback(object,eventdata)
handles=guihandles(findobj(0,'Tag','autopilot'));
NewVal=str2num(get(handles.injectvalue,'String'));
Min=get(handles.injectslider,'Min');
Max=get(handles.injectslider,'Max');
if NewVal < Min || NewVal > Max
    OldVal=num2str(get(handles.injectslider,'Value'));
    set(handles.injectvalue,'String',OldVal);
    disp('Warning: slider control can not have a Value outside of Min/Max range!');
else
    set(handles.injectslider,'Value',NewVal);
end

function shutoffslider_Callback(object,eventdata)
handles=guihandles(findobj(0,'Tag','autopilot'));
NewVal=num2str(get(handles.shutoffslider,'Value'));
set(handles.shutoffvalue,'String',NewVal);

function shutoffvalue_Callback(object,eventdata)
handles=guihandles(findobj(0,'Tag','autopilot'));
NewVal=str2num(get(handles.shutoffvalue,'String'));
Min=get(handles.shutoffslider,'Min');
Max=get(handles.shutoffslider,'Max');
if NewVal < Min || NewVal > Max
    OldVal=num2str(get(handles.shutoffslider,'Value'));
    set(handles.shutoffvalue,'String',OldVal);
    disp('Warning: slider control can not have a Value outside of Min/Max range!');
else
    set(handles.shutoffslider,'Value',NewVal);
end

function bunchslider_Callback(object,eventdata)
handles=guihandles(findobj(0,'Tag','autopilot'));
NewVal=num2str(get(handles.bunchslider,'Value'));
set(handles.bunchvalue,'String',NewVal);

function bunchvalue_Callback(object,eventdata)
handles=guihandles(findobj(0,'Tag','autopilot'));
NewVal=str2num(get(handles.bunchvalue,'String'));
Min=get(handles.bunchslider,'Min');
Max=get(handles.bunchslider,'Max');
if NewVal < Min || NewVal > Max
    OldVal=num2str(get(handles.bunchslider,'Value'));
    set(handles.bunchvalue,'String',OldVal);
    disp('Warning: slider control can not have a Value outside of Min/Max range!');
else
    set(handles.bunchslider,'Value',NewVal);
end