% PJ BOussina waveform loader September 11, 2006
% Just for fun nothing serious 
% If you don't like it too bad, make it yourself
% Have FUN

%==========================
function plotwaveform(status)
%==========================
    %declare main structures
    SYS=[];  WAV=[];  AO=[];  AD=[]; 

    if exist('status','var')
        if ~(strcmpi(status,'online') | strcmpi(status,'sim'))
            disp('   Warning: invalid status input to PlotWaveform')
            return
        end
    else
       status='online';
    end
    
    AO=plotwaveform_ao(status);   %AO for plotwaveform
    AD=plotwaveform_ad;   %AD for plotwaveform
    
    %program parameters
    traces={'Trace1' 'Trace2'};                %each waveform has Trace1, Trace2
    channels={'ChannelA' 'ChannelB'};          %each trace has Channel A, Channel B
    sources={'Monitor' 'Golden' 'Save' 'File'};%each Channel has 4 sources
    makeSYSstruct;                             %initialize SYS structure
    nwfm=4;                                    %number of plots per axis
    makeWAVstruct;                             %initialize WAV structure

    background=[0.86 0.85 0.82];               %graphics color scheme
    df=1;                                      %number of pixels to extend frame
    PlotWaveformGUI                            %build the main GUI
    set(SYS.Handles.Figure,'HandleVisibility','off');
    make_psm_display                           %pulsed-signal monitor system for SPEAR3
 
    %initialize timer 
    pwtimer=timer('TimerFcn',@single_shot, 'Period', 1,'ExecutionMode','fixedRate','Tag','PlotwaveformTimer');
     
%========================
%=== BEGIN FUNCTIONS  ===
%=========================================
    function launch_timer_callback(src,evt)        %launch_timer_callback
%=========================================        
        if ~SYS.iLoad
            disp('Load waveform first')
            return
        end
        if strcmpi(get(src,'String'),'Continuous')  %showing 'Continous', turned to 'on'
          try
            start(pwtimer);
            set(SYS.Handles.Timer,'String','Running');
          catch
            warndlg(lasterr);
            a=timerfindall;
            stop(a);
            delete(a);
            return;
          end
        elseif strcmpi(get(src,'String'),'Running')
          try
            stop(pwtimer);
            set(SYS.Handles.Timer,'String','Continuous');
          catch
            warndlg(lasterr);
            a=timerfindall;
            stop(a);
            delete(a);
            return;
          end
        end
    end

%======================================        
   function select_waveform_callback(src,evt)   %%%%%%%%  select_waveform_callback %%%%%%%%%
%======================================        
    val=get(src,'Userdata');   %callback of select waveform pushbuttons
    SYS.iplot=val(1);  iplot=SYS.iplot;
    SYS.iwfm=val(2);   iwfm =SYS.iwfm;
    
    if WAV(iplot,iwfm).iLoad   %waveform already loaded
        update_display;
        if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')
            psm_display;  %updates psm parameter window
        end
        return
    end
    
    %generate figure for loading waveform
    SYS.Handles.SelectFigure=figure('Numbertitle','off','name','Select Waveform',...
       'Position', [112 500 920 300],'resize','off','Color',background);
        %set(FigHandles,'Toolbar','none','menubar','none');
            
    %make listboxes
    for ii=1:length(SYS.Families)
    allmax=size(AO.(SYS.Families{ii}).Monitor.ChannelNames,1);
    SYS.Handles.(SYS.Families{ii})=...
        uicontrol('Style', 'listbox','BackgroundColor',background, 'String', {'Select'},...
        'Position', [25+150*(ii-1) 60 135 200], 'Enable', 'on','Value',[],'Max',allmax,'Min',0,...
        'String',AO.(SYS.Families{ii}).Monitor.ChannelNames);
        uicontrol('Style', 'text','BackgroundColor',background, 'String', SYS.Families{ii},...
        'Position', [25+150*(ii-1) 260 120 20], 'Enable', 'on','Value',1);
    end
	
    %make 'Select' button
	 uicontrol('Style', 'pushbutton','BackgroundColor',background, 'String', 'Select',...
     'Callback',@process_selection_callback,'Position', [300 20 80 20], 'Enable', 'on','Value',0);
     set(SYS.Handles.SelectFigure,'HandleVisibility','off');

   end %end select_waveform_callback

%======================================        
    function process_selection_callback(src,evt)   %%%%%%%%  process_selection_callback %%%%%%%%%
%======================================        
        %callback of the 'Select' button on waveform selection subpanel
        iplot=SYS.iplot; 
        iwfm=SYS.iwfm;
        
        %initialize
        waveforms=[];
        ifams=[];
        
        %find which waveform selected
        for ii=1:length(SYS.Families)
        z=get(SYS.Handles.(SYS.Families{ii}),'String');  %all strings in listbox
        val=get(SYS.Handles.(SYS.Families{ii}),'value');
        str=z(val,:);  %specific string if chosen
        if ~isempty(str)   %found one
            ival=val;
            ifams=[ifams; ii];
            waveforms=[waveforms; str];  %string for selected value
        end
        end
        if size(waveforms,1)>1  
            waveform=waveforms(end,:);   %later may have multiple waveforms
            ifam=ifams(end);
        else
            waveform=waveforms;
            ifam=ifams;
        end
        
        %check timebase is consistent with other waveforms in this graph
        if isempty(SYS.Families(ifam))
          errordlg('Warning: No waveform selected','plotwaveform')
        return
        end

        iok=check_xunits(iplot,SYS.Families(ifam));
        if ~iok
          errordlg('Invalid waveform selection - inconsistent time base. Choose again.','Plotwaveform timebase error')
        return
        end

        %build the WAV structure
        clear_plot(iplot,iwfm);
        wav2zero(iplot,iwfm);
        WAV(iplot,iwfm).ChannelName=deblank(waveform);  %channel name
        waveform=AO.(SYS.Families{ifam}).CommonNames(get(SYS.Handles.(SYS.Families{ifam}),'value'),:); %common name from AO
        WAV(iplot,iwfm).Family=SYS.Families{ifam}; %family
        WAV(iplot,iwfm).FamilyType=SYS.FamilyTypes{ifam}; %type e.g. PSM, MCORR, etc
        WAV(iplot,iwfm).CommonName=deblank(AO.(SYS.Families{ifam}).CommonNames(ival,:)); %common name
        set(SYS.Handles.Select(iplot,iwfm),'String',waveform,'ForegroundColor',  WAV(iplot,iwfm).Color);  %display common name
        set(SYS.Handles.Display(iplot,iwfm),'Value',1) %checkbox for display 'on'
        WAV(iplot,iwfm).iLoad=1;       %status bit for waveform load
        WAV(iplot,iwfm).iDisplay=1;    %status bit for display
        WAV(iplot,iwfm).Monitor.XDataUnits=AO.(char(SYS.Families(ifam))).XUnits;  %usec, etc
        WAV(iplot,iwfm).Monitor.RawDataUnits=deblank(AO.(char(SYS.Families(ifam))).RawYUnits(ival,:));  %units for raw signal (e.g. Volts)
        WAV(iplot,iwfm).Monitor.EngDataUnits=deblank(AO.(char(SYS.Families(ifam))).EngYUnits(ival,:));  %units for Eng signal (e.g. Pwr)

        if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')   %acquire conversion factors from PV's
             wavpsm2zero(iplot,iwfm);
             WAV(iplot,iwfm).Monitor.VoltOffset=getpv([WAV(iplot,iwfm).ChannelName 'Conv.G']); 
             conv={'A'; 'B'; 'C'; 'D'; 'E'; 'F';};
             for ii=1:6 %A,B,C,D,E,F,G - Polynomial conversion factors from Volt to EGU (G=voltage offset)
             WAV(iplot,iwfm).Monitor.PolyConv(ii)=getpv([WAV(iplot,iwfm).ChannelName 'Conv.' conv{ii}]); 
             end
             WAV(iplot,iwfm).Monitor.RawSignal=AO.(char(SYS.Families(ifam))).RawSignal;  %VoltFst
             WAV(iplot,iwfm).Monitor.EngSignal=AO.(char(SYS.Families(ifam))).EngSignal;  %Fst
             WAV(iplot,iwfm).Monitor.XDataStep=AO.(WAV(iplot,iwfm).Family).Timebase(ival);
             NORD=getpv([WAV(iplot,iwfm).ChannelName 'Waveform.NORD']);
             WAV(iplot,iwfm).Monitor.XData=WAV(iplot,iwfm).Monitor.XDataStep*[1:NORD]';
        else
            errordlg(['Generate horizontal time base in select_waveform_callback for ' SYS.Machine])
            %WAV(iplot,iwfm).Monitor.XData=  %needed for plotting
            %WAV(iplot,iwfm).Monitor.XDataStep=   %needed for horizontal scroll gui
        end
        
        SYS.iLoad=1;
        set(SYS.Handles.Source(1,1),'Value',1);      %select radio button for Source(1)= 'Monitor'
        set(SYS.Handles.Source(2,1),'Value',1);      %select radio button for Source(2)= 'Monitor'
        set(SYS.Handles.Trace1Channel(1),'Value',1);  %select radio button for channel 'A'
        set(SYS.Handles.Trace2State,'Value',0)
        t=SYS.Families(ifam);
        set(get(SYS.Handles.Plot(iplot),'Xlabel'),'string',['Time (' AO.(t{1}).XUnits ' )'])
        waveform_name; %displays waveform name
       
        %NOT USED BECAUSE NEED TO BROWSE FOR GOLDEN
        %golden2memory;  %load Golden file if available   
        
        if ishandle(SYS.Handles.SelectFigure)
        close(SYS.Handles.SelectFigure)
        end
        
        single_shot;
        monitor2save;   %save reference automatically at load time
        if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')
          if ~ishandle(SYS.PSMHandles.Figure)  %if window does not exist make one
             make_psm_display;
          end

          psm_display;  %updates psm parameter window, single_shot does not look at psm
        end
    end

%======================================        
   function update_channel_callback(src,evt)   %%%%%%%%  update_channel_callback %%%%%%%%%
%======================================        
       %radiobuttion selection of channel A, B or A-B for Trace1 or Trace2
       val=get(src,'Userdata');
       tr=val(1);    %1,2   = Trace1 or Trace2
       ch=val(2);    %1,2,3 = Channel A, B or A-B
       iplot=SYS.iplot;
       iwfm=SYS.iwfm;
       if ~WAV(iplot,iwfm).iLoad; 
           errordlg('Select waveform first','Select Channel');  
           set(SYS.Handles.([traces{tr} 'Channel'])(ch),'Value',0);
           return; 
       end
   
       for ii=1:3   %turn off all Channel radiobuttons for selected Trace
       set(SYS.Handles.([traces{tr} 'Channel'])(ii),'Value',0)
       end
       if tr==2 && ~get(SYS.Handles.Trace2State,'Value')    %user chose Trace2 with radio button 'off'
           val=get(SYS.Handles.([traces{tr} 'Channel'])(ch),'Value');  %find value of radiobutton pushed
           set(SYS.Handles.([traces{tr} 'Channel'])(ch),'Value',mod(1,val));   %put it back
           WAV(iplot,iwfm).Trace2Channel=ch;  %update channel selection
           return
       end

       set(src,'Value',1)
       WAV(iplot,iwfm).([traces{tr} 'Channel'])=ch;  %1,2 or 3 for A, B or A-B
       WAV(iplot,iwfm).([traces{tr} 'State'])=1;
       single_shot_callback;    %defaults to update
   end

%========================================        
   function trace2state_callback(src,evt)  %trace2state_callback
%========================================        
        %radio button toggle on/off for Trace2
        iplot=SYS.iplot;
        iwfm=SYS.iwfm;

        if WAV(iplot,iwfm).iDisplay==0 || WAV(iplot,iwfm).iLoad==0  %flag to indicate waveform loaded)
           errordlg('Select or Load waveform first','Load waveform')
           set(SYS.Handles.Trace2State,'Value',0);
           return
        end

        val=get(SYS.Handles.Trace2State,'Value');
        if val   %user turned it 'on'
            WAV(iplot,iwfm).Trace2State=1;
            update_display
        else     %user turned it 'off'
          WAV(iplot,iwfm).Trace2State=0;
          set(SYS.Handles.Trace2(iplot,iwfm),'XData',[],'YData',[]);

        end   
    end

%======================================        
   function update_source_callback(src,evt)    %%%%%%%%  update_source_callback %%%%%%%%%
%======================================        
       %selects source (Monitor/Save/Golden/File) via radiobutton for Channel A or Channel B
       val=get(src,'Userdata');  
       ch=val{1};    %1,2   = ChannelA or ChannelB
       isr=val{2};   %index of source radio button
       iplot=SYS.iplot;
       iwfm=SYS.iwfm;

       if ~WAV(iplot,iwfm).iLoad; 
           errordlg('Select waveform first','Select Channel');
           set(src,'Value',0)
           return; 
       end


       switch isr
           case 2 %Golden 
               if ~WAV(iplot,iwfm).iGolden
               errordlg('Load golden waveform first','Data from Golden')
               set(src,'Value',0)  %put radio button back to zero
               return
               end
           case 3  %Save
               if ~WAV(iplot,iwfm).iSave
               errordlg('Save reference waveform first','Saved data')
               set(src,'Value',0)  %put radio button back to zero
               return
               end
           case 4 %File
               if ~WAV(iplot,iwfm).iFile
               errordlg('Load waveform from file first','Data from file')
               set(src,'Value',0)  %put radio button back to zero
               return
               end

       end
       
       for ii=1:4   %turn off all Source radiobuttons for selected Channel
       set(SYS.Handles.Source(ch,ii),'Value',0)
       end

       set(src,'Value',1)
       %both Trace1 and Trace2 have same SourceA and SourceB
       if ch==1
       WAV(iplot,iwfm).ChannelA=isr;
       elseif ch==2
       WAV(iplot,iwfm).ChannelB=isr;
       end
       single_shot_callback;  %defaults to update
   end

%======================================        
   function monitor2save_callback(src,evt)    %%%%%%%%  monitor2save_callback %%%%%%%%%
%======================================        
       monitor2save(src,evt);
   end

%======================================        
   function monitor2save(src,evt)    %%%%%%%%  monitor2save %%%%%%%%%
%======================================        
       iplot=SYS.iplot;
       iwfm=SYS.iwfm;
       if ~WAV(iplot,iwfm).iLoad; errordlg('Select waveform first','Save Data');  return; end
       WAV(iplot,iwfm).Save=WAV(iplot,iwfm).Monitor;
       WAV(iplot,iwfm).Save.TimeStamp=sprintf('%s', datestr(clock,31));
       disp([sprintf('%s', datestr(clock,31)) ' Waveform data ' WAV(iplot,iwfm).CommonName ' saved to memory '])
       WAV(iplot,iwfm).iSave=1;
       for kk=1:2 set(SYS.Handles.Source(kk,3),'ToolTipString',['Data saved: ' WAV(iplot,iwfm).Save.TimeStamp]); end
   end

%======================================        
   function save2file_callback(src,evt)     %%%%%%%%  save2file_callback %%%%%%%%%%
%======================================        
       save2file(1);   %argument '1' produces dialog box
   end

%======================================        
   function save2file(idialog)     %%%%%%%%  save2file %%%%%%%%%%
%======================================        
       iplot=SYS.iplot;
       iwfm=SYS.iwfm;
       if ~WAV(iplot,iwfm).iLoad; errordlg('Select waveform first','Save to File');  return; end

       DirStart = pwd;
       Family=WAV(iplot,iwfm).Family;   %family
       DirectoryName=AD.Directory.PlotWaveform.(Family); %directory
       Name=WAV(iplot,iwfm).CommonName;     %signal common name
       FileName = appendtimestamp(Name, clock);
       cd(DirectoryName);
       if idialog==1
         [FileName, DirectoryName] = uiputfile(FileName, 'Save file to disk');
         if ~FileName   %cancel sets FileName to 0
           disp(['   Warning: no file saved ' datestr(clock,31)])
           cd(DirStart);
           return
         end
       end
       
       Waveform.(Name)=WAV(iplot,iwfm).Monitor;
       Waveform.(Name).TimeStamp=sprintf('%s', datestr(clock,31));
       WAV(iplot,iwfm).FileName=FileName;   %store so Golden backup gets same timestamp
       save(FileName, 'Waveform'); disp(' ');
       disp([' Waveform File ' FileName '.mat saved to directory ' DirectoryName])
       cd(DirStart);
   end

%======================================        
   function save2golden_callback(src,evt)   %%%%%%%%  save2golden_callback %%%%%%%%%%
%======================================        
       save2golden;
   end

%======================================        
   function save2golden(src,evt)   %%%%%%%%  save2golden %%%%%%%%%%
%======================================        
       iplot=SYS.iplot;
       iwfm=SYS.iwfm;
       if ~WAV(iplot,iwfm).iLoad; errordlg('Select waveform first','Save to Golden');  return; end
       save2file(0);  %use argument '1' to generate a dialog box
       
       DirStart = pwd;
       Family=WAV(iplot,iwfm).Family;   %family
       DirectoryName=AD.Directory.PlotWaveform.(Family); %directory
       cd(DirectoryName) 
       Name=WAV(iplot,iwfm).CommonName;     %signal common name
       FileName = ['Golden_' Name];
       
%        [FileName, DirectoryName] = uiputfile(FileName, 'Save Golden file to disk');
%        if ~FileName   %cancel sets FileName to 0
%            disp(['   Warning: no golden file saved ' datestr(clock,31)])
%            cd(DirStart);
%            return
%        end
% 
%        iexist=exist([FileName '.mat'],'file');
%        if iexist
%            answer=questdlg(['Golden waveform file [ ' FileName '.mat ] already exists - overwrite?'],'Golden file','Yes','No','Yes');
%            if strcmpi(answer,'no')
%              disp([sprintf('%s', datestr(clock,31)) ' No Golden file written ' ]);
%              cd(DirStart);
%              return
%            end
%        end

       Golden.(Name)=WAV(iplot,iwfm).Monitor;
       Golden.(Name).TimeStamp=sprintf('%s', datestr(clock,31));
       save(FileName, 'Golden');  %sprintf('%s', datestr(clock,31)) 
       disp([' Golden File  ' FileName '.mat  saved to directory ' DirectoryName]);
       
       %save a copy to backup
       DirectoryName=[DirectoryName 'Golden_Backup'];
       cd([DirectoryName]);
       FileName=['Golden_' WAV(iplot,iwfm).FileName];  %use this name so save and goldenbackuptimestamps agree
       %FileName=appendtimestamp(FileName, clock);
       save(FileName,'Golden')
       disp([ ' Golden File backup ' FileName '.mat  saved to directory ' DirectoryName])
       cd(DirStart);
   end

 %======================================        
  function all2golden_callback(srv,evt)
 %======================================        
        iplot=SYS.iplot;
        iwfm=SYS.iwfm;
        for ii=1:2
            for jj=1:nwfm
                if WAV(ii,jj).iLoad
                    SYS.iplot=ii;
                    SYS.iwfm=jj;
                    save2golden
                end
            end
        end
          SYS.iplot=iplot;
          SYS.iwfm=iwfm;
  end

%======================================        
   function all2workspace_checkbox_callback(srv,evt)   %all_checkbox_callback
%======================================        
        iplot=SYS.iplot;
        iwfm=SYS.iwfm;
        if ~WAV(iplot,iwfm).iLoad; 
            errordlg('Select waveform first','Write All to Workspace');
            set(SYS.Handles.all2workspace,'Value',0);
        end
   end

 %======================================        
  function all2workspace
 %======================================        
       iplot=SYS.iplot;
        iwfm=SYS.iwfm;
        for ii=1:2
            for jj=1:nwfm
                if WAV(ii,jj).iLoad
                    SYS.iplot=ii;
                    SYS.iwfm=jj;
                    write2workspace
                end
            end
        end
          SYS.iplot=iplot;
          SYS.iwfm=iwfm;
    end

%=============================================        
    function write2workspace_callback(src,evt)   %write2workspace_callback
%============================================= 
      write2workspace(src,evt)
    end

%======================================        
    function write2workspace(src,evt)     %write2workspace
%======================================        
       %write waveform data structure to workspace
        iplot=SYS.iplot;
        iwfm=SYS.iwfm;
        if ~WAV(iplot,iwfm).iLoad; errordlg('Select waveform first','Write to Workspace');  return; end

        if get(SYS.Handles.all2workspace,'Value')
            set(SYS.Handles.all2workspace,'Value',0)
            all2workspace;
            set(SYS.Handles.all2workspace,'Value',1)
            return
        end
        
        Name=WAV(iplot,iwfm).CommonName;     %signal common name
        Struct.Family=WAV(iplot,iwfm).Family;
        Struct.CommonName=Name;
        source={'Monitor';};
        if WAV(iplot,iwfm).iGolden; source=[source 'Golden']; end
        if WAV(iplot,iwfm).iSave; source=[source 'Save']; end
        if WAV(iplot,iwfm).iFile; source=[source 'File']; end
        for kk=1:size(source,2)  %loop over available sources (Monitor, Golden, Save, File
           Struct.(source{kk})=WAV(iplot,iwfm).(source{kk});
           Struct.TimeStamp=sprintf('%s', datestr(clock,31));
        end                  
        assignin('base',Name,Struct);
        disp([sprintf('%s', datestr(clock,31)) ' Waveform data for [ ' Name ' ] written to MATLAB workspace'])
    end

%======================================        
  function file2memory_callback(src,evt)    %%%%%%%%  file2memory_callback %%%%%%%%%
%======================================        
       %load the file
       iplot=SYS.iplot;
       iwfm=SYS.iwfm;
       if ~WAV(iplot,iwfm).iLoad; errordlg('Select waveform first','Load Data File');  return; end

       DirStart = pwd;
       Family=WAV(iplot,iwfm).Family;   %family
       DirectoryName=AD.Directory.PlotWaveform.(Family);  %directory
       CommonName=WAV(iplot,iwfm).CommonName;     %signal common name
       cd(DirectoryName)
       FileName=uigetfile([CommonName '*.mat'], 'Select file');
        try
         load(FileName);
         WAV(iplot,iwfm).File=Waveform.(CommonName);
         WAV(iplot,iwfm).File.FileName=FileName;
         WAV(iplot,iwfm).iFile=1;
         disp([sprintf('%s', datestr(clock,31)) ' Waveform file [ ' FileName ' ] loaded to memory'])
         for kk=1:2 
             set(SYS.Handles.Source(kk,4),'ToolTipString',['File loaded: ' WAV(iplot,iwfm).File.FileName]); 
         end
         if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')
           psm_display;  %updates psm parameter window
         end
       catch
         errordlg('Warning: Problem with loading File', 'Load File');
       end
       cd(DirStart);
    end         
                  
%======================================        
    function golden2memory_callback(src,evt)  %%%%%%%%  golden2memory_callback %%%%%%%
%======================================        
      golden2memory(src,evt)
    end

%======================================        
    function golden2memory(src,evt)  %%%%%%%%  golden2memory %%%%%%%
%======================================        
%load  golden file
       iplot=SYS.iplot;
       iwfm=SYS.iwfm;
       if ~WAV(iplot,iwfm).iLoad; errordlg('Select waveform first','Load Golden');  return; end

       DirStart = pwd;
       Family=WAV(iplot,iwfm).Family;
       CommonName=WAV(iplot,iwfm).CommonName;
       DirectoryName=AD.Directory.PlotWaveform.(Family); %directory

       cd(DirectoryName)
       %look for golden file
       %FileName = ['Golden_' CommonName '.mat'];
       [FileName, PathName, FilterIndex] = uigetfile('*.mat', ['Load Golden File for Waveform ' Family]);
           if ~FileName   %cancel sets FileName to 0
           disp(['   Warning: no golden file loaded ' datestr(clock,31)])
           cd(DirStart);
           return
           end

       cd(PathName)
       if exist(FileName,'file');
        try
         load(FileName);
         WAV(iplot,iwfm).Golden=Golden.(CommonName);
         WAV(iplot,iwfm).iGolden=1;
         for ii=1:4   %turn off all Source radiobuttons for ChannelB
           set(SYS.Handles.Source(2,ii),'Value',0)
         end
         set(SYS.Handles.Source(2,2),'Value',1);      %select radio button for Source(2)= 'Golden'
         WAV(iplot,iwfm).ChannelB=2;  %default Bhannel B to Golden
         disp(['Golden Waveform file [ ' FileName ' ] loaded to memory'])
         for kk=1:2 
             set(SYS.Handles.Source(kk,2),...
                 'ToolTipString',['Golden Timestamp ' WAV(iplot,iwfm).Golden.TimeStamp]); 
         end
         if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')
           psm_display;  %updates psm parameter window
         end

         catch
           errordlg('Warning: Problem with loading Golden File', 'Load Golden File');
         end
       else
           disp([CommonName ': No Golden file available'])
       end
       cd(DirStart);
    end
 
%=========================================        
    function single_shot_callback(src,evt)
%=========================================        
%callback of single_shot pushbutton
      if strcmpi(pwtimer.Running,'on')  %timer running
          return
      end
      single_shot;
      waveform_name;
      iplot=SYS.iplot;
      iwfm=SYS.iwfm;
      if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')
          psm_display;  %updates psm parameter window
      end
    end

%=========================================        
   function single_shot(src,evt,irefresh)   %%%%%%%%  single_shot %%%%%%%%%
%=========================================        
%plot selected traces for selected signals on both axes
       if ~exist('irefresh','var'); irefresh=1; end  %default to acquiring fresh data
       %tic
       for ii=1:2   %axes index
         for jj=1:nwfm  %waveform index
             if   WAV(ii,jj).iDisplay
                %check to see if Monitor signal required
                sourceA=WAV(ii,jj).ChannelA;   %sources are 1,2,3,4 (Monitor, Save, Golden, File)
                sourceB=WAV(ii,jj).ChannelB;

                if (sourceA==1 || sourceB==1) && irefresh
                  if strcmpi(WAV(ii,jj).FamilyType,'PSM')
                    getpv_spear3(ii,jj);
                  else
                    WAV(ii,jj).Monitor.RawData=getpv(WAV(ii,jj).ChannelName);
                    if SYS.Units
                        %WAV(ii,jj).Monitor.EngData=convert to Engineering Units
                    end
                    WAV(ii,jj).Monitor.TimeStamp=sprintf('%s', datestr(clock,31));
                  end
                end
                for kk=1:2;  %trace index
                 if WAV(ii,jj).([traces{kk} 'State']);   %trace is on for plotting
                     switch WAV(ii,jj).([traces{kk} 'Channel'])  %which channel(s) for trace
                         case 1   %A only
                            if SYS.Units==0   %0 for raw units, 1 for converted/engineering units
                            yd=WAV(ii,jj).(sources{sourceA}).RawData;
                            else
                            yd=WAV(ii,jj).(sources{sourceA}).EngData;
                            end
                         case 2   %B only
                            if SYS.Units==0
                            yd=WAV(ii,jj).(sources{sourceB}).RawData;
                            else
                            yd=WAV(ii,jj).(sources{sourceB}).EngData;
                            end
                         case 3   %A-B
                            if SYS.Units==0
                            yd=WAV(ii,jj).(sources{sourceA}).RawData-WAV(ii,jj).(sources{sourceB}).RawData;
                            else
                            yd=WAV(ii,jj).(sources{sourceA}).EngData-WAV(ii,jj).(sources{sourceB}).EngData;
                            end
                     end  %end trace display type switchyard
                     WAV(ii,jj).(traces{kk}).YData=yd';
                     WAV(ii,jj).(traces{kk}).XData=WAV(ii,jj).Monitor.XData;
                     plot_waveform(ii,jj,kk)
                  end  %end trace display condition
               end   %end loop on traces
             end  %end signal signal display condition
          end  %end loop over signals
       end  %end loop over axes
       set(SYS.Date,'string',datestr(now,'HH:MM:SS PM'));  %update timestamp
       %toc
   end  %end single_shot


%======================================        
   function getpv_spear3(iplot,iwfm)    %%%%%%%%  getpv_spear3  %%%%%%%%%
%======================================        
%called from single_shot
     ch=WAV(iplot,iwfm).ChannelName;
     RawPV=[ch deblank(WAV(iplot,iwfm).Monitor.RawSignal)];
     EngPV=[ch deblank(WAV(iplot,iwfm).Monitor.EngDataUnits) deblank(WAV(iplot,iwfm).Monitor.EngSignal)];
     %disp([RawPV '    '  EngPV])
     WAV(iplot,iwfm).Monitor.RawData=getpv(RawPV);      
     WAV(iplot,iwfm).Monitor.EngData=getpv(EngPV);
     WAV(iplot,iwfm).Monitor.TimeStamp=sprintf('%s', datestr(clock,31));
       
       if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')
         if strcmpi(pwtimer.Running,'off')  %timer not running
           get_psm;
         end
       end

   end

%======================================        
  function plot_waveform(iplot,iwfm,tr)
%======================================        
     xd=WAV(iplot,iwfm).(traces{tr}).XData-WAV(iplot,iwfm).(traces{tr}).XOffset;
     yd=WAV(iplot,iwfm).(traces{tr}).YScale*WAV(iplot,iwfm).(traces{tr}).YData;
     yd=yd-WAV(iplot,iwfm).(traces{tr}).YOffset;
     set(SYS.Handles.(traces{tr})(iplot,iwfm),'xdata',xd,'ydata',yd);
     a=axis(SYS.Handles.Plot(iplot));
     set(SYS.Handles.Plot(iplot),'XLim',[a(1) a(2)]);
   end
    
%==========================================        
    function update_display(src,evt)
%==========================================        
%updates graphical interface display but not plots
        iplot=SYS.iplot;
        iwfm=SYS.iwfm;
                
        for kk=1:2      %loop over traces
            for jj=1:3   %loop over channel selection setting 'A', 'B', 'A-B' to radiobutton 'off'
            set(SYS.Handles.([traces{kk} 'Channel'])(jj),'Value',0)
            end
            ichan=WAV(iplot,iwfm).([traces{kk} 'Channel']);  %locate which radiobutton is active

            if ichan>0   %0 indicates no source selection
            set(SYS.Handles.([traces{kk} 'Channel'])(ichan),'Value',1)  %set active radiobutton
            end
        end
        
        for kk=1:2   %loop over channel selections for A and B
            for jj=1:4   %loop over source selection setting radiobuttons 'off'
            set(SYS.Handles.Source(kk,jj),'Value',0)
            end
            isrc=WAV(iplot,iwfm).(channels{kk});  %value 1,2,3,4 for Monitor,Golden,Save,File
            %disp(num2str([kk isrc]));
            set(SYS.Handles.Source(kk,isrc),'Value',1);
        end

        set(SYS.Handles.Trace2State,'Value',WAV(iplot,iwfm).Trace2State)

        set(SYS.Date,'string',datestr(now,'HH:MM:SS PM'));

        for kk=1:2  %loop over sources for channels A and B
            if WAV(iplot,iwfm).iGolden
            set(SYS.Handles.Source(kk,2),...
                        'ToolTipString',['Golden Timestamp ' WAV(iplot,iwfm).Golden.TimeStamp]);
            end
            set(SYS.Handles.Source(kk,3),'ToolTipString',['Data saved: ' WAV(iplot,iwfm).Save.TimeStamp]);
            if WAV(iplot,iwfm).iFile
            set(SYS.Handles.Source(kk,4),'ToolTipString',['File loaded: ' WAV(iplot,iwfm).File.FileName]);
            end
        end
        
        %reset radio buttons for scaling and horizontal offset display
        if WAV(iplot,iwfm).TraceScale==1
          set(SYS.Handles.Trace1Scale,'Value',1)
          set(SYS.Handles.Trace2Scale,'Value',0)
          set(SYS.Handles.XOffsetDisplay,'String',num2str(WAV(iplot,iwfm).(traces{1}).XOffset, '%6.3f'))
        elseif WAV(iplot,iwfm).TraceScale==2
          set(SYS.Handles.Trace1Scale,'Value',0)
          set(SYS.Handles.Trace2Scale,'Value',1)
          set(SYS.Handles.XOffsetDisplay,'String',num2str(WAV(iplot,iwfm).(traces{2}).XOffset, '%6.3f'))
        end
     
    
        waveform_name;
    end

%==================================================        
     function display_waveform_callback(src,evt)    %%%%%%%%  display_waveform  %%%%%%%%%
%==================================================        
       %response to display checkbox for selected signal
       %check indicated waveform is displayed, no check not displayed
       val=get(src,'userdata');
       SYS.iplot=val(1);   iplot=SYS.iplot;
       SYS.iwfm=val(2);    iwfm=SYS.iwfm;

       if  ~WAV(iplot,iwfm).iLoad
           set(src,'value',0);
           return
       end

       if get(src,'value')    %toggle 'on'
         WAV(iplot,iwfm).iDisplay=1;
         update_display;
         single_shot(0);  %0=no update
         if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')
           psm_display;  %updates psm parameter window
         end
       else                   %toggle 'off'
         WAV(iplot,iwfm).iDisplay=0;
         axes(SYS.Handles.Plot(iplot));
         set(SYS.Handles.Trace1(iplot,iwfm),'xdata',[],'ydata',[]);
         set(SYS.Handles.Trace2(iplot,iwfm),'xdata',[],'ydata',[]);
         str=['Plot # ' num2str(SYS.iplot) '  Waveform: '];
         set(SYS.Handles.Waveform,'String',str,'Foregroundcolor','k');
         if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')
           clear_psm_display
         end
         
         %look for another waveform to use in the same plot
         ifound=0;
         for ii=1:4
             if WAV(SYS.iplot,ii).iDisplay
                 SYS.iwfm=ii;
                 ifound=1;
                 update_display;
                 single_shot(0);  %0=no update
                 if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')
                   psm_display;  %updates psm parameter window
                 end
                 break
             end
         end
         if ~ifound %look for another waveform to use in the other plot
             SYS.iplot=rem(SYS.iplot,2)+1;
            for ii=1:4
             if WAV(SYS.iplot,ii).iDisplay
                 SYS.iwfm=ii;
                 ifound=1;
                 update_display;
                 single_shot(0);  %0=no update
                 if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')
                    psm_display;  %updates psm parameter window
                 end
                 break
             end
            end
         end
         if ~ifound  %no signals selected in either plot
             SYS.iplot=1;
             SYS.iwfm=1;
         end

       end  %end turn-off
     end

%==========================================        
   function waveform_name(src,evt)    %%%%%%%%  waveform name  %%%%%%%%%
%==========================================        
       %display waveform name and plot index
        iplot=SYS.iplot; 
        iwfm=SYS.iwfm;
        if    ~SYS.Units
            Units=WAV(iplot,iwfm).Monitor.RawDataUnits;
        elseif SYS.Units
            Units=WAV(iplot,iwfm).Monitor.EngDataUnits;
        end
        str=['    Plot ' num2str(SYS.iplot) ': ' WAV(iplot,iwfm).CommonName '  [' Units ']'  ];
        set(SYS.Handles.Waveform,'String',str,'Foregroundcolor',  WAV(iplot,iwfm).Color);
        set(get(SYS.Handles.Plot(iplot),'Ylabel'),'string',[char(WAV(iplot,iwfm).CommonName) '  [' Units ']'  ])

   end
  
%==========================================        
   function clear_plots_callback(src,evt)                 %%%%%%%%  clear_plots_callback  %%%%%%%%%
%==========================================        
       %callback of Clear Plots pushbutton   
       %clears all waveform loads for selected graph   
       iplot=get(src,'userdata');   %graph index
         axes(SYS.Handles.Plot(iplot));
         for iwfm=1:nwfm
             if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')
                 wavpsm2zero(iplot,iwfm)
             end
             wav2zero(iplot,iwfm);
             clear_plot(iplot,iwfm)
         end
         
         SYS.iGrid(iplot)=0;
         set(get(SYS.Handles.Plot(iplot),'Xlabel'),'string','Timebase')
         set(SYS.Handles.Waveform,'String','no waveform selected','Foregroundcolor','k');
         for kk=1:2 
            set(SYS.Handles.Source(kk,2),...
                        'ToolTipString',['Golden Timestamp ']);
            set(SYS.Handles.Source(kk,3),'ToolTipString',['Data save time']); 
            set(SYS.Handles.Source(kk,4),'ToolTipString',['File load']); 
         end
         SYS.iwfm=1;
         
         %check if waveforms loaded in other plot
         SYS.iLoad=0;
         ip=rem(iplot,2)+1;  %other plot
         for iwfm=1:nwfm
             if WAV(ip,iwfm).iLoad
                 SYS.iLoad=1;
             end
         end
   end

%==========================================        
function clear_plot(iplot,iwfm)
%==========================================        
%clear graphics for specific plot index, waveform index
   set(SYS.Handles.Trace1(iplot,iwfm),'xdata',[],'ydata',[]);
   set(SYS.Handles.Trace2(iplot,iwfm),'xdata',[],'ydata',[]);
   set(SYS.Handles.Select(iplot,iwfm),'String','Select','ForegroundColor','k');
   set(SYS.Handles.Display(iplot,iwfm),'Value',0);
   str=['Plot # ' num2str(SYS.iplot) '  Waveform: '];
   set(SYS.Handles.Master(iplot,iwfm),'Value',0);  %turn off master button
   WAV(iplot,iwfm).imaster=0;         %waveform not master
   set(SYS.Handles.Waveform,'String',str,'Foregroundcolor','k');
   for ii=1:2   %turn off A,B,A-B radio button, turn on 'A'
     for jj=1:3
       set(SYS.Handles.([traces{ii} 'Channel'])(jj),'Value',0);
     end
     set(SYS.Handles.([traces{ii} 'Channel'])(1), 'Value',1);  %1=radio button for channel 'A'
   end
           
   for ii=1:2  %turn off Channel A,B radio buttons, turn on 'Monitor
     for jj=1:4   %Monitor,Golden,Save,File
       set(SYS.Handles.Source(ii,jj),'Value',0);
     end
     set(SYS.Handles.Source(ii,1), 'Value',1);   %Monitor
   end
   
   if strcmpi(WAV(ii,jj).FamilyType,'PSM')
       clear_psm_display
   end
end

%==========================================        
function delete_waveform_callback(src,evt)   %delete_waveform_callback
%==========================================        
  val=get(src,'Userdata');
  iplot=val(1);
  iwfm=val(2);
  wav2zero(iplot,iwfm);
    if strcmpi(WAV(iplot,iwfm).FamilyType,'PSM')
    wavpsm2zero(iplot,iwfm);
    end
  clear_plot(iplot,iwfm)
end

%==========================================        
function wav2zero(ii,jj)
%==========================================        
%initialize segment of WAV structure
%ii=graph index
%jj=waveform index
%NOTE: Could also make 'SYS.WAV0' and set WAV(ii,jj)=SYS.WAV0 each time
  WAV(ii,jj).Family='';
  WAV(ii,jj).FamilyType='';
  WAV(ii,jj).ChannelName='';  %ChannelName of waveform
  WAV(ii,jj).CommonName='';   %CommonName of waveform
  WAV(ii,jj).iLoad=0;  %flag to indicate waveform loaded
  for kk=1:4    %Monitor, Save, File, Golden
    WAV(ii,jj).(sources{kk}).TimeStamp=[];    
    WAV(ii,jj).(sources{kk}).RawData=[];  WAV(ii,jj).(sources{kk}).RawDataUnits=[];
    WAV(ii,jj).(sources{kk}).EngData=[];  WAV(ii,jj).(sources{kk}).EngDataUnits=[];
    WAV(ii,jj).(sources{kk}).XData=[];    WAV(ii,jj).(sources{kk}).XDataUnits=[];
  end
  WAV(ii,jj).iDisplay=0;  %flag to indicate waveform displayed
  WAV(ii,jj).iMaster=0;  %master for plot scale
  WAV(ii,jj).Color=SYS.colors{jj};
  WAV(ii,jj).iSave=0;  %waveform saved memoryly
  WAV(ii,jj).iFile=0;  %waveform loaded from file
  WAV(ii,jj).iGolden=0;  %waveform loaded from golden
  WAV(ii,jj).Trace1State=1; %TraceA on for plotting (always)
  WAV(ii,jj).Trace1Channel=1;  %1,2 or 3 indicates A,B or A-B
  WAV(ii,jj).Trace2State=0; %TraceB on for plotting (optional)
  WAV(ii,jj).Trace2Channel=1;
  WAV(ii,jj).ChannelA=1;  %1,2,3 or 4 indicates Monitor,Save,Golden,File
  WAV(ii,jj).ChannelB=1;  %1,2,3 or 4 indicates Monitor,Save,Golden,File 
  WAV(ii,jj).TraceScale=1; %Trace1 selected for scaling
  WAV(ii,jj).Trace1.XOffset=0;  WAV(ii,jj).Trace2.XOffset=0;
  WAV(ii,jj).Trace1.YOffset=0;  WAV(ii,jj).Trace2.YOffset=0;
  WAV(ii,jj).Trace1.YScale=1;   WAV(ii,jj).Trace2.YScale=1; 
end

%==========================================        
   function PlotWaveformGUI(src,evt)    %%%%%%%%  PlotWaveformGUI  %%%%%%%%%
%==========================================        

    %figure
	SYS.Handles.Figure=figure('Numbertitle','off','name','PlotWaveform',...
       'Position', [112 400 900 700],'Color',background,'CloseRequestFcn',@closeplotwaveform);
    set(SYS.Handles.Figure,'Units','character');
    set(SYS.Handles.Figure,'resize','off');
    set(SYS.Handles.Figure,'Toolbar','none','menubar','none');
    
    %menus
    h=uimenu(SYS.Handles.Figure,'Label','Plot #1');
    uimenu(h,'Label','Toggle Graticule','Callback',@graticule_callback,'UserData',1);
    uimenu(h,'Label','Pop Plot','Callback',@pop_axes_callback,'UserData',1);
    
    h=uimenu(SYS.Handles.Figure,'Label','Plot #2');
    uimenu(h,'Label','Toggle Graticule','Callback',@graticule_callback,'UserData',2);
    uimenu(h,'Label','Pop Plot','Callback',@pop_axes_callback,'UserData',2);

    %axes
    y=[0.66 0.29];
    for ii=1:2  %two axes
      SYS.Handles.Plot(ii)=axes('Box','on','Position',[0.1 y(ii) 0.72 0.3],'NextPlot','add');
      %set(SYS.Handles.Plot(ii),'xticklabelmode','manual','xticklabel',[],'NextPlot','add');
      set(get(SYS.Handles.Plot(ii),'Xlabel'),'string','Timebase')
      set(get(SYS.Handles.Plot(ii),'Ylabel'),'Interpreter','None','string','Signal')
      SYS.iGrid(ii)=0;
    end; clear y
  
    %axes zoom and autoscale
    uicontrol('Style', 'Frame','Position', [105 12 187 130],'Backgroundcolor',background);
    uicontrol('Style', 'text','BackgroundColor','w','Position', [110 95  43 27],'String', ['Graph  1'; 'Vertical'],'Backgroundcolor',background)
    uicontrol('Style', 'text','BackgroundColor','w','Position', [110 50  42 27],'String', ['Graph  2'; 'Vertical'],'Backgroundcolor',background)
    uicontrol('Style', 'text','BackgroundColor','w','Position', [155 120 32 17],'String', 'Zoom','Backgroundcolor',background)
    uicontrol('Style', 'text','BackgroundColor','w','Position', [190 120 32 17],'String', 'Offset','Backgroundcolor',background)
    uicontrol('Style', 'text','BackgroundColor','w','Position', [115 18  30 17],'String', 'Horiz.','Backgroundcolor',background)

    %sliders for zoom
    slim=2;  %limit for zoom
    uicontrol('Style','slider','Position',[162 92 20 30],'Callback',@vertical_zoom_callback,...
    'Max',slim,'Min',-slim,'SliderStep',[0.01 0.01],'Value',0,'UserData',1);
    uicontrol('Style','slider','Position',[162 50  20 30],'Callback',@vertical_zoom_callback,...
    'Max',slim,'Min',-slim,'SliderStep',[0.01 0.01],'Value',0,'UserData',2);
    uicontrol('Style','slider','Position',[195 92 20 30],'Callback',@vertical_offset_callback,...
    'Max',slim,'Min',-slim,'SliderStep',[0.01 0.01],'Value',0,'UserData',1);
    uicontrol('Style','slider','Position',[195 50  20 30],'Callback',@vertical_offset_callback,...
    'Max',slim,'Min',-slim,'SliderStep',[0.01 0.01],'Value',0,'UserData',2);
    uicontrol('Style','slider','Position',[155 20  30 20],'Callback',@horizontal_zoom_callback,...
    'Max',slim,'Min',-slim,'SliderStep',[0.01 0.01],'Value',0);
    uicontrol('Style','slider','Position',[190 20  30 20],'Callback',@horizontal_offset_callback,...
    'Max',slim,'Min',-slim,'SliderStep',[0.01 0.01],'Value',0);

    %pushbuttons for autoscale
    uicontrol('Style','pushbutton','Position',[225 95  60 20],'String', 'Autoscale','Callback',@autoscale_callback,'Userdata',1,'Backgroundcolor',background);
    uicontrol('Style','pushbutton','Position',[225 57  60 20],'String', 'Autoscale','Callback',@autoscale_callback,'Userdata',2,'Backgroundcolor',background);
    uicontrol('Style','pushbutton','Position',[225 20  60 20],'String', 'Reset','Callback',@reset_horizontal_callback,...
        'ToolTipString','Reset horizontal scale on both plots','BackgroundColor',background )

    %waveform selection
    uicontrol('Style', 'text','BackgroundColor','w','Position', [700 670 80 20],'String', 'Master','Backgroundcolor',background)
    uicontrol('Style', 'text','BackgroundColor','w','Position', [760 670 40 20],'String', 'Display','Backgroundcolor',background)
    uicontrol('Style', 'text','BackgroundColor','w','Position', [800 670 60 20],'String', 'Waveform','Backgroundcolor',background)
    uicontrol('Style', 'text','BackgroundColor','w','Position', [860 670 40 20],'String', 'Delete','Backgroundcolor',background)

    uicontrol('Style', 'Frame','Position', [296 12 115 130],'Backgroundcolor',background);
    uicontrol('Style', 'Frame','Position', [415 12 163 130],'Backgroundcolor',background);
    uicontrol('Style', 'Frame','Position', [582 12 130 130],'Backgroundcolor',background);
    uicontrol('Style', 'Frame','Position', [716 12 175 130],'Backgroundcolor',background);

    %trace line Handles, master, display box, edit box, 
    y =[650 395];                %vertical offsets for axes in pixel
    yc=[545 295];                %vertical offsets for clear plot button
    for ii=1:2
      axes(SYS.Handles.Plot(ii));
      for jj=1:nwfm
        %master
        SYS.Handles.Master(ii,jj)=uicontrol('Style', 'radiobutton','BackgroundColor','w',...
        'Callback',@masterbox_callback,    'Position', [750 y(ii)-25*(jj-1) 17 17], 'Enable', 'on','Userdata',[ii jj],'Backgroundcolor',background);    
        %display
         SYS.Handles.Display(ii,jj)=uicontrol('Style', 'checkbox','BackgroundColor','w',...
         'Callback',@display_waveform_callback,'Position', [775 y(ii)-25*(jj-1) 17 17], 'Enable', 'on','Userdata',[ii jj],'Backgroundcolor',background);
         %select
         SYS.Handles.Select(ii,jj)=uicontrol('Style', 'pushbutton','BackgroundColor','w', 'String', 'Select',...
        'Callback',@select_waveform_callback,'Position', [800 y(ii)-25*(jj-1) 60 20], 'Enable', 'on','Userdata',[ii jj],'Backgroundcolor',background);       
        %delete
         SYS.Handles.Delete(ii,jj)=uicontrol('Style', 'pushbutton','BackgroundColor','w',...
         'Callback',@delete_waveform_callback,'Position', [865 y(ii)-25*(jj-1) 25 20], 'Enable', 'on','Userdata',[ii,jj],'Backgroundcolor',background);
        
        %trace initialization (lines, sources, displays)
         SYS.Handles.Trace1(ii,jj)=line('XData',[],'YData',[],'Color',SYS.colors{jj});  %'Linewidth',linewidth{1}
         SYS.Handles.Trace2(ii,jj)=line('XData',[],'YData',[],'Color',SYS.colors{jj},'Linestyle',':');
      end  %loop on waveforms
      
        %clear plot buttons
        uicontrol('Style', 'pushbutton','BackgroundColor','w', 'String', 'Clear Plots',...
        'Position', [800  yc(ii)  90 20],'Callback',@clear_plots_callback,'UserData',ii,'Backgroundcolor',background)
    end; %loop on axes
    
    clear linewidth

    %trace1 and trace2 (A, B, A-B) radiobuttons
    y=[98 37];
    for kk=1:2  %loop over traces
       uicontrol('Style', 'text','BackgroundColor','w','Position', [297 y(kk)+15 40 20],'String', traces{kk},'Backgroundcolor',background);
       SYS.Handles.([traces{kk} 'Channel'])(1)=uicontrol('Style', 'radiobutton','BackgroundColor','w','Position', [300 y(kk)  30 17],...
           'Callback',@update_channel_callback,'String', 'A',  'Userdata',[kk 1],'Value',0,'Backgroundcolor',background);
       SYS.Handles.([traces{kk} 'Channel'])(2)=uicontrol('Style', 'radiobutton','BackgroundColor','w','Position', [330 y(kk)  30 17],...
           'Callback',@update_channel_callback,'String', 'B',  'Userdata',[kk 2],'Value',0,'Backgroundcolor',background);
       SYS.Handles.([traces{kk} 'Channel'])(3)=uicontrol('Style', 'radiobutton','BackgroundColor','w','Position', [360 y(kk)  40 17],...
           'Callback',@update_channel_callback,'String', 'A-B','Userdata',[kk 3],'Value',0,'Backgroundcolor',background);
    end;  clear y
    
    %trace2 on/off selection    
       SYS.Handles.Trace2State=uicontrol('Style', 'radiobutton','BackgroundColor','w',...
            'Position', [360 58  50 17],'Callback',@trace2state_callback,'String', 'on/off','Value',0,'Backgroundcolor',background);

    %waveform name display
       uicontrol('Style','Frame','Position', [298-df 150-df 280+2*df 17+2*df])
       SYS.Handles.Waveform=uicontrol('Style', 'text','BackgroundColor','w','Position', [298 150 280 17],'String', 'Waveform Name',...
           'Backgroundcolor',background,'fontsize',10,'HorizontalAlignment','Center');   
     
    %raw/eng units selection
       SYS.Handles.RawUnits=uicontrol('Style', 'radiobutton','String', 'Raw Units','Value',0,'UserData',0,...
        'Position', [590 150 65 17],'Callback',@unitselect_callback,'Backgroundcolor',background,'FontSize',7);
       SYS.Handles.EngUnits=uicontrol('Style', 'radiobutton','String', 'Eng Units','Value',1,'UserData',1,...
        'Position', [650 150 65 17],'Callback',@unitselect_callback,'Backgroundcolor',background,'FontSize',7);
    
    %ChannelA and ChannelB source selection (Monitor/Golden/Saved/File) Userdata contains {Channel #, source}
       uicontrol('Style', 'text','BackgroundColor','w','Position', [419 118 50 17],'String', 'Channel A','Backgroundcolor',background);
       uicontrol('Style', 'text','BackgroundColor','w','Position', [497 118 50 17],'String', 'Channel B','Backgroundcolor',background);
       x=[420 497];
       for kk=1:2   %loop over channels A,B
        SYS.Handles.Source(kk,1)=uicontrol('Style', 'radiobutton','BackgroundColor','w','Position', [x(kk) 98 75 17],...
        'Callback',@update_source_callback,'String','Monitor'   ,'Userdata',{kk 1},'Backgroundcolor',background);
        SYS.Handles.Source(kk,2)=uicontrol('Style', 'radiobutton','BackgroundColor','w','Position', [x(kk) 78 75 17],...
        'Callback',@update_source_callback,'String','Golden'    ,'Userdata',{kk 2},'Backgroundcolor',background,'ToolTipString','Golden Waveform');
        SYS.Handles.Source(kk,3)=uicontrol('Style', 'radiobutton','BackgroundColor','w','Position', [x(kk) 58 75 17],...
        'Callback',@update_source_callback,'String','Saved Data','Userdata',{kk 3},'Backgroundcolor',background','ToolTipString','Saved Waveform');
        SYS.Handles.Source(kk,4)=uicontrol('Style', 'radiobutton','BackgroundColor','w','Position', [x(kk) 38 75 17],...
        'Callback',@update_source_callback,'String','File'      ,'Userdata',{kk 4},'Backgroundcolor',background','ToolTipString','File Waveform');
       end; clear x
     
    %scale single waveform
     slim=2;  %limit for sliders
     uicontrol('Style', 'text','String', 'Scale','Position',  [615 100 30 17],'Backgroundcolor',background)
     uicontrol('Style', 'text','String', 'Offset','Position',[650 100 40 17],'Backgroundcolor',background)
     uicontrol('Style', 'text','String', 'Vert.','Position',  [590 80  25 17],'Backgroundcolor',background)
     uicontrol('Style', 'text','String', 'Horizontal','Position',  [590 50  55 17],'Backgroundcolor',background)
     SYS.Handles.Trace1Scale=uicontrol('Style', 'radiobutton','String', 'Trace1','Value',1,'Userdata',1,...
        'Position', [590 120 55 17],'Callback',@tracescale_callback,'Backgroundcolor',background);
     SYS.Handles.Trace2Scale=uicontrol('Style', 'radiobutton','String', 'Trace2','Value',0,'Userdata',2,...
        'Position', [650 120 55 17],'Callback',@tracescale_callback,'Backgroundcolor',background);
     uicontrol('Style', 'pushbutton','String', 'Reset',...
        'Position', [625 18  50 17],'Callback',@reset_waveform_scale,...
        'ToolTipString','Reset x/y scale - this trace, this waveform only','Backgroundcolor',background)
     uicontrol('Style','slider','Position',[622 74 20 30],'Callback',@vertical_scale_single_callback,...
    'Max',slim,'Min',-slim,'SliderStep',[0.01 0.01],'Value',0,'UserData',1);
     uicontrol('Style','slider','Position',[660 74 20 30],'Callback',@vertical_offset_single_callback,...
    'Max',slim,'Min',-slim,'SliderStep',[0.01 0.01],'Value',0,'UserData',1);
    uicontrol('Style','slider','Position',[655 50  30 20],'Callback',@horizontal_offset_single_callback,...
    'Max',slim,'Min',-slim,'SliderStep',[0.25 0.25],'Value',0);
    SYS.Handles.XOffsetDisplay=uicontrol('Style','text','Position',[605 38 35 15],'String','0');

    %save and load data
     uicontrol('Style', 'pushbutton','String', 'Save Data',...
        'Position', [720 120 80 17],'Callback',@monitor2save_callback,'ToolTipString','store waveform in memory','Backgroundcolor',background)
     uicontrol('Style', 'pushbutton','String', 'Save to File',...
        'Position', [720 95 80 17],'Callback',@save2file_callback,'ToolTipString','write waveform to file','Backgroundcolor',background)
     uicontrol('Style', 'pushbutton','String', 'Load Data File',...
        'Position', [805 95 80 17],'Callback',@file2memory_callback,'ToolTipString','read waveform from file','Backgroundcolor',background)
     uicontrol('Style', 'pushbutton','String', 'Save to Golden',...
        'Position', [720 70  80 17],'Callback',@save2golden_callback,'ToolTipString','write waveform to golden','Backgroundcolor',background)
     uicontrol('Style', 'pushbutton','String', 'Load Golden',...
        'Position', [805 70  80 17],'Callback',@golden2memory_callback,'ToolTipString','golden file to memory','Backgroundcolor',background)
     uicontrol('Style', 'pushbutton','String', 'Save All to Golden',...
        'Position', [720 45 100 17],'Callback',@all2golden_callback,'ToolTipString','write all waveforms to golden','Backgroundcolor',background)
    

    %data transfer to file, workspace
    SYS.Handles.all2workspace=uicontrol('Style', 'checkbox','BackgroundColor','w', 'String', 'All',...
        'Position', [830 20 35 17],'Callback',@all2workspace_checkbox_callback,'Backgroundcolor',background);
    uicontrol('Style', 'pushbutton','BackgroundColor','w', 'String', 'Write to Workspace',...
        'Position', [720 20  100 17],'Callback',@write2workspace_callback,'Backgroundcolor',background)
    
    %trigger controls
    uicontrol('Style', 'Frame','Position', [10 35 90 107],'Backgroundcolor',background);
    uicontrol('Style', 'text','BackgroundColor','w','Position', [25 118 60 20],'String', 'Trigger','Backgroundcolor',background)
    uicontrol('Style', 'pushbutton','BackgroundColor','w', 'String', 'One Shot',...
        'Position', [15 100 80 17],'Callback',@single_shot_callback,'Backgroundcolor',background);
    SYS.Handles.Timer=uicontrol('Style', 'pushbutton','BackgroundColor','w', 'String', 'Continuous',...
        'Position', [15 70 80 17],'Callback',@launch_timer_callback,'Backgroundcolor',background);
    
    %debug
    uicontrol('Style', 'pushbutton','BackgroundColor','w','Position', [375 680 60 20],'String', 'Debug',...
        'Callback',@show_state_callback','Backgroundcolor',background,'fontsize',10,'HorizontalAlignment','Left');        
   
    %update PSM display
    if strcmpi(SYS.Machine,'SPEAR3')
        uicontrol('Style', 'pushbutton','BackgroundColor','w','Position', [475 680 150 20],'String', 'Update PSM Display',...
        'Callback',@psm_display_callback','Backgroundcolor',background,'fontsize',10,'HorizontalAlignment','Left');        
    end
    
    %date
    SYS.Date = uicontrol('Style', 'text','FontSize',8,'BackgroundColor','w','string',datestr(now,'HH:MM:SS PM'  ),...
        'Position', [15 40 80 17],'Backgroundcolor',background);

end %end PlotWaveformGUI

%==========================================        
   function masterbox_callback(src,evt)    %%%%%%%%  masterbox_callback  %%%%%%%%%
%==========================================        
   end

%==========================================        
    function iok=check_xunits(iplot,Family)
%==========================================        
        %check family has same time base as other waveforms in plot
        iok=1;
        ii=iplot;
        xunits=AO.(Family{1}).XUnits;
        for jj=1:nwfm
            if   WAV(ii,jj).iLoad
                Family=WAV(ii,jj).Family;
                if ~(strcmpi(AO.(Family).XUnits,xunits))
                    iok=0;   %found a disagreement in units
                    for kk=1:length(SYS.Families)
                      set(SYS.Handles.(SYS.Families{kk}),'value',[])
                    end
                    return
                end 
            end
        end
    end

%==========================================        
function vertical_zoom_callback(src,evt)    %%%%%%%%  vertical_zoom_callback %%%%%%%%%
%==========================================        
      h=SYS.Handles.Plot(get(src,'Userdata'));   %plot Handles
      xlim=get(h,'XLim');
      ylim=get(h,'YLim');
      factor = 1.1;
      if get(src,'Value') < 0     %increase size
        del = (factor-1)*(ylim(2)-ylim(1));
      else                        %decrease size
        del = (1/factor-1)*(ylim(2)-ylim(1));
      end
      set(h,'XLim',xlim,'YLim',[ylim(1)-del/2 ylim(2)+del/2]);
      set(src, 'Value', 0)
   end


%==========================================        
   function vertical_offset_callback(src,evt)    %%%%%%%%  vertical_offset_callback %%%%%%%%%
%==========================================
%vertically offsets Plot 1 or Plot 2
      h=SYS.Handles.Plot(get(src,'Userdata'));   %plot Handles
      xlim=get(h,'XLim');
      ylim=get(h,'YLim');
      factor = 1.1;
      if get(src,'Value') < 0     %raise scale
        del = (factor-1)*(ylim(2)-ylim(1));
      else                        %lower scale
        del = (1/factor-1)*(ylim(2)-ylim(1));
      end
      set(h,'XLim',xlim,'YLim',[ylim(1)+del/2 ylim(2)+del/2]);
      set(src, 'Value', 0)
   end
%==========================================        
  function horizontal_offset_callback(src,evt)    %%%%%%%%  horizontal_offset_callback %%%%%%%%%
%==========================================             
%horizontal offset Plot 1 and Plot 2
      factor = 1.1;
      for ii=1:2
      h=SYS.Handles.Plot(ii);
      xlim=get(h,'XLim');
      ylim=get(h,'YLim');
      if get(src,'Value') < 0     %raise scale
        del = (factor-1)*(xlim(2)-xlim(1));
      else                        %lower scale
        del = (1/factor-1)*(xlim(2)-xlim(1));
      end
      set(SYS.Handles.Plot(ii),'XLim',[xlim(1)+del/2 xlim(2)+del/2],'YLim',ylim);
      end
      set(src, 'Value', 0)
   end

%==========================================        
   function horizontal_zoom_callback(src,evt)    %%%%%%%%  horizontal_zoom_callback %%%%%%%%%
%==========================================        
%horizontal zoom Plot 1 and Plot 2
      factor = 1.1;
      for ii=1:2
      h=SYS.Handles.Plot(ii);
      xlim=get(h,'XLim');
      ylim=get(h,'YLim');
      if get(src,'Value') < 0     %increase size
        del = (factor-1)*(xlim(2)-xlim(1));
      else                        %decrease size
        del = (1/factor-1)*(xlim(2)-xlim(1));
      end
      set(SYS.Handles.Plot(ii),'XLim',[xlim(1)-del/2 xlim(2)+del/2],'YLim',ylim);
      end
      set(src, 'Value', 0)
   end

%===============================================        
    function reset_horizontal_callback(src,evt)   %reset_horizontal_callback
%===============================================        
      for ii=1:2
        for jj=1:nwfm
          if WAV(ii,jj).iLoad
            for kk=1:2   %loop over traces
              if WAV(ii,jj).iLoad
                xmin=WAV(ii,jj).(traces{kk}).XData(1);
                xmax=WAV(ii,jj).(traces{kk}).XData(end);
                break
              end
            end
          break
          end
        end
        set(SYS.Handles.Plot(ii),'XLim',[xmin xmax]);
      end
     
    end

%==========================================        
    function autoscale_callback(src,evt)    %%%%%%%%  autoscale_callback %%%%%%%%%
%==========================================        
%autoscales selected plot
      ii=get(src,'Userdata');
      ymax=-1e6;
      ymin=1e6;
      for jj=1:nwfm
      if   WAV(ii,jj).iDisplay   %check if waveform is displayed
          %Trace1
            y=get(SYS.Handles.Trace1(ii,jj),'ydata');
            ymax1=max(y);
            ymin1=min(y);
            if ymax1>ymax
              ymax=ymax1;
            end
            if ymin1<ymin
              ymin=ymin1;
            end
            
          %Trace2
          if WAV(ii,jj).Trace2State
            y=get(SYS.Handles.Trace2(ii,jj),'ydata');
            ymax1=max(y);
            ymin1=min(y);
            if ymax1>ymax
              ymax=ymax1;
            end
            if ymin1<ymin
              ymin=ymin1;
            end
          end
      end  %end condition on display
      end  %end loop on waveforms

      ymin=ymin-0.05*abs(ymin);
      ymax=ymax+0.05*abs(ymax);
      if ymin>ymax
          t=ymin;
          ymin=ymax;
          ymax=t;
      end
      if ymin==0 && ymax==0
          ymax=1;
      end
%       disp(num2str(ymin))
%       disp(num2str(ymax))

      a=axis(SYS.Handles.Plot(ii));
      set(SYS.Handles.Plot(ii),'xlim',[a(1) a(2)],'ylim',[ymin ymax])
      end %end function

 %==========================================        
    function graticule_callback(src,evt)       %graticule_callback
 %==========================================        
        iplot=get(gcbo,'Userdata');
        if SYS.iGrid(iplot)==0
          set(SYS.Handles.Plot(iplot),'XGrid','On', 'YGrid','On')
          SYS.iGrid(iplot)=1;
        else
          set(SYS.Handles.Plot(iplot),'XGrid','Off', 'YGrid','Off')
          SYS.iGrid(SYS.iplot)=0;
        end
        clear iplot
    end


 %==========================================        
   function tracescale_callback(src,evt)      %tracescale_callback
 %==========================================        
%radio buttons to control scaling of Trace1 or Trace2
        tr=get(src,'Userdata');
        iplot=SYS.iplot;
        iwfm=SYS.iwfm;
          if ~get(SYS.Handles.Trace2State,'Value')   %trace2 not selected
             set(SYS.Handles.Trace2Scale,'Value',0)  %put back radio button
             return
          end

        if ~WAV(iplot,iwfm).iLoad; 
            set(SYS.Handles.Trace1Scale,'Value',1)
            set(SYS.Handles.Trace2Scale,'Value',0)
            errordlg('Select waveform first','Trace Selection');  
            return; 
        end
        %toggle radio buttons
        if tr==1
          val=get(SYS.Handles.Trace1Scale,'Value')
          if val  %user turned Trace1 on
             set(SYS.Handles.Trace2Scale,'Value',0)
             WAV(iplot,iwfm).TraceScale=1; %Trace1 selected for scaling
             set(SYS.Handles.XOffsetDisplay,'String',num2str(WAV(iplot,iwfm).(traces{1}).XOffset, '%6.3f'))
          else  %user turned Trace1 off
             set(SYS.Handles.Trace2Scale,'Value',1)
             WAV(iplot,iwfm).TraceScale=2; %Trace2 selected for scaling
             set(SYS.Handles.XOffsetDisplay,'String',num2str(WAV(iplot,iwfm).(traces{2}).XOffset, '%6.3f'))
          end
        elseif tr==2
          val=get(SYS.Handles.Trace1Scale,'Value')
          if val  %user turned Trace2 on
             set(SYS.Handles.Trace1Scale,'Value',0)
             WAV(iplot,iwfm).TraceScale=2; %Trace2 selected for scaling
             set(SYS.Handles.XOffsetDisplay,'String',num2str(WAV(iplot,iwfm).(traces{2}).XOffset, '%6.3f'))
          else  %user turned Trace2 off
             set(SYS.Handles.Trace1Scale,'Value',1)
             WAV(iplot,iwfm).TraceScale=1; %Trace1 selected for scaling
             set(SYS.Handles.XOffsetDisplay,'String',num2str(WAV(iplot,iwfm).(traces{1}).XOffset, '%6.3f'))
          end
        end
     
    end

 %==========================================        
   function unitselect_callback(src,evt)        %unitselect_callback
 %==========================================        
      %radio buttons to control display of Raw and Eng Units
        iplot=SYS.iplot;
        iwfm=SYS.iwfm;

        if ~WAV(iplot,iwfm).iLoad; 
            set(SYS.Handles.RawUnits,'Value',0)
            set(SYS.Handles.EngUnits,'Value',1)
            errordlg('Select waveform first','Unit Selection');  
            return; 
        end
        
        %toggle radio buttons
          btn=get(src,'UserData');
          val=get(src,'Value');
          if     ~btn && val  %Raw turned on
             set(SYS.Handles.EngUnits,'Value',0)
             SYS.Units=0; %Raw Units
          elseif ~btn && ~val  %Raw turned off
             set(SYS.Handles.EngUnits,'Value',1)
             SYS.Units=1; %Eng Units
          elseif btn && val  %Eng turned on
             set(SYS.Handles.RawUnits,'Value',0)
             SYS.Units=1;
          elseif btn && ~val  %Eng turned off
             set(SYS.Handles.RawUnits,'Value',1)
             SYS.Units=0;
          end   
          if strcmpi(pwtimer.Running,'off')  %timer not running
              single_shot_callback;
              waveform_name;
          end
    end

  %==========================================        
  function reset_waveform_scale(src,evt)
  %==========================================        
      %reset scaling of single waveform
        iplot=SYS.iplot;
        iwfm=SYS.iwfm;
        tr=WAV(iplot,iwfm).TraceScale;
        if ~WAV(iplot,iwfm).iLoad; errordlg('Select waveform first','Reset');  return; end
        WAV(iplot,iwfm).(traces{tr}).YScale=1;
        WAV(iplot,iwfm).(traces{tr}).YOffset=0;
        WAV(iplot,iwfm).(traces{tr}).XOffset=0;
        set(SYS.Handles.XOffsetDisplay,'String',num2str(WAV(iplot,iwfm).(traces{tr}).XOffset, '%6.3f'))
        plot_waveform(iplot,iwfm,tr);
    end

  %===============================================        
  function vertical_scale_single_callback(src,evt)   %vertical_scale_single_callback
  %===============================================        
      %scale single waveform vertical
        iplot=SYS.iplot;
        iwfm=SYS.iwfm;
        tr=WAV(iplot,iwfm).TraceScale;
        if ~WAV(iplot,iwfm).iLoad
            errordlg('Select waveform first','Vertical Scale')
        end
        val=get(src,'Value');
        if val>0
            del=0.05;
        elseif val<0
            del=-0.05;
        end
        WAV(iplot,iwfm).(traces{tr}).YScale=WAV(iplot,iwfm).(traces{tr}).YScale+del;
        if WAV(iplot,iwfm).(traces{tr}).YScale<0
            WAV(iplot,iwfm).(traces{tr}).YScale=0;
        end
        plot_waveform(iplot,iwfm,tr);
        set(src, 'Value', 0)
    end

 %==========================================        
   function vertical_offset_single_callback(src,evt)     %vertical_offset_single_callback
 %==========================================        
      %vertical offset for single waveform
        iplot=SYS.iplot;
        iwfm=SYS.iwfm;
        if ~WAV(iplot,iwfm).iLoad
          errordlg('Select waveform first','Vertical Offset')
        end
        tr=WAV(iplot,iwfm).TraceScale;
        val=get(src,'Value');
        
        h=SYS.Handles.Plot(iplot);   %plot Handles
        xlim=get(h,'XLim');
        ylim=get(h,'YLim');
        factor = 1.1;
        %get(src,'Value')
        if get(src,'Value') < 0     %raise scale
          del = (factor-1)*(ylim(2)-ylim(1));
        else                        %lower scale
          del = (1/factor-1)*(ylim(2)-ylim(1));
        end
        WAV(iplot,iwfm).(traces{tr}).YOffset=WAV(iplot,iwfm).(traces{tr}).YOffset+del;
        plot_waveform(iplot,iwfm,tr);
        set(h,'XLim',xlim,'YLim',ylim);   %return plot coordinates to original value
        set(src, 'Value', 0)

    end

  %==========================================        
  function horizontal_offset_single_callback(src,evt)    %horizontal_offset_single_callback
  %==========================================        
      %horizontal offset for single waveform
        iplot=SYS.iplot;
        iwfm=SYS.iwfm;
        if ~WAV(iplot,iwfm).iLoad
          errordlg('Select waveform first','Horizontal Offset')
         end
        tr=WAV(iplot,iwfm).TraceScale;
        val=get(src,'Value');
        nstep=2;
        WAV(iplot,iwfm).(traces{tr}).XOffset=...
        WAV(iplot,iwfm).(traces{tr}).XOffset+val*nstep*WAV(iplot,iwfm).Monitor.XDataStep;
        plot_waveform(iplot,iwfm,tr);
        set(src, 'Value', 0)
        set(SYS.Handles.XOffsetDisplay,'String',num2str(WAV(iplot,iwfm).(traces{tr}).XOffset, '%6.3f'))
    end

%==========================================        
function makeSYSstruct
%==========================================        
 SYS=[]; 
 SYS.Families=fieldnames(AO);  %check to see if Families are MemberOf 'PlotWaveform'
 for ii=1:size(SYS.Families,1)
 SYS.FamilyTypes{ii}=AO.(SYS.Families{ii}).FamilyType;  
 end
 SYS.Machine='SPEAR3';
 SYS.iplot=1;
 SYS.iwfm=1;
 SYS.colors={'b','r','k','m'};   %colors for plots
 SYS.iLoad=0;
 SYS.Units=1;  %0 for raw data (.RawData), 1 for converted data (.EngData)
end

%==========================================        
function makeWAVstruct
%==========================================        
 %initialize WAV structure for program PlotWaveform
  WAV=[];
  for ii=1:2  %plots
    for jj=1:nwfm  %waveforms
      wav2zero(ii,jj)
    end
  end
end

%==========================================        
%     function pop_axes_callback(src,evt)
%==========================================        
%      SYS.iplot=get(gcbo,'Userdata');
%      a=figure;
%      myplot=gca;
%      b=copyobj(gca, a); 
%      for ii=1:4
%        if WAV(SYS.iplot,ii).iplot==1; 
%            h=WAV(SYS.iplot,ii).Line.Handles;
%            copyobj(h,b); 
%        end
%      end
%      clear h
% 
%      t=axis(gca);
%      axis(t)
%      set(b, 'Position',[0.13 0.11 0.775 0.815]); 
%      set(b, 'ButtonDownFcn','');
%      set(b, 'XAxisLocation','Bottom');
%      set(b,'XTick',[]);
%      set(b,'XTick',get(SYS.Handles.Plot(iplot),'XTick'));
% 
% 
% %      set(b,'YTickLabel',[]);
% %      axis(b,[get(SYS.Handles.Plot(iplot),'XLim') get(SYS.Handles.Plot(iplot),'YLim')]);
%      xlabel('Time [microsec]');
%      orient portrait
%     end

%==========================================        
function show_state_callback(src,evt)   %%%%%%%%  show_state_callback %%%
%==========================================        
disp(['Machine: ' SYS.Machine])
disp(['Graph ' num2str(SYS.iplot)])
disp(['Waveform ' num2str(SYS.iwfm)])
disp(' ')
show_string('Family')
show_string('ChannelName')
show_string('CommonName')
show_index('iLoad','waveform loaded')
show_index('iDisplay','selected for display')
%show_index('iMaster')
show_index('iSave','memory save')
show_index('iFile','file loaded')
show_index('iGolden','Golden loaded')
show_index('Trace1State','on or off')
show_index('Trace1Channel','A,B or A-B')
show_index('Trace2State','on or off')
show_index('Trace2Channel','A,B or A-B')
show_index('ChannelA','Monitor, Golden, Save, File')
show_index('ChannelB','Monitor, Golden, Save, File')
show_index('TraceScale','horizontal waveform offset')
show_index('Trace1','horizontal waveform offset','XOffset')
show_index('Trace2','horizontal waveform offset','XOffset')
show_index('Trace1','vertical waveform offset','YOffset')
show_index('Trace2','vertical waveform offset','YOffset')
show_index('Trace1','vertical waveform scaling','YScale')
show_index('Trace2','vertical waveform scaling','YScale')
%show_index('YOffset','vertical waveform offset')

%==========================================        
    function show_string(field)
%==========================================        
     disp(field)
     for ii=1:2
      t=[];
       for jj=1:nwfm
        if isempty(WAV(ii,jj).(field)); 
            txt='None'; 
        else
            txt=WAV(ii,jj).(field);
        end
        t=[t txt '   '];
      end
      disp(t)
     end
     disp(' ')
    end

 %==========================================        
   function show_index(field1,comment,field2)
 %==========================================        
    ifield2=0;
     if ~exist('field2','var')
       disp([field1   ' [  ' comment ' ]'])
     else
       ifield2=1;
       disp([field1 '.' field2 '   [' comment ' ]'])
     end
     
     for ii=1:2
      t=[];
       for jj=1:nwfm
            if ~ifield2
            t=[t WAV(ii,jj).(field1)];
            else
            t=[t WAV(ii,jj).(field1).(field2)];   
            end
       end
      disp(t)
     end
      disp(' ')
    end
  end  %show_state_callback

%==========================================        
    function closeplotwaveform(src,evt)
%========================================== 
%callback of closewindow
        %kill the timer
          if exist('pwtimer','var')
            stop(pwtimer);
            delete(pwtimer);
            clear pwtimer
          end
          t=timerfind;
          for k=1:length(t)
            if strcmpi(t(k).Tag,'PlotwaveformTimer')
              stop(t(k));
              delete(t(k));
            end
          end
          delete(SYS.Handles.Figure);
          %if  exist('SYS.PSMHandles.Figure')
             if  ishandle(SYS.PSMHandles.Figure)
              delete(SYS.PSMHandles.Figure);
             end
          %end
      %clear global SYS WAV AO AD;
    end

%==========================================        
function wavpsm2zero(ii,jj)
%==========================================        
 for kk=1:4
  WAV(ii,jj).(sources{kk}).XDataStep=[];
  WAV(ii,jj).(sources{kk}).VoltOffset=[]; %Voltage offset
  WAV(ii,jj).(sources{kk}).PolyConv=[]; %Polynomial conversion factors
  WAV(ii,jj).(sources{kk}).RawSignal='';  WAV(ii,jj).(sources{kk}).EngSignal='';  %VoltFst, Fst
  WAV(ii,jj).(sources{kk}).EngAvg=[];        WAV(ii,jj).(sources{kk}).EngFstAvg=[];
  WAV(ii,jj).(sources{kk}).EngCtr=[];        WAV(ii,jj).(sources{kk}).EngFstCtr=[];
  WAV(ii,jj).(sources{kk}).EngMax=[];        WAV(ii,jj).(sources{kk}).EngFstMax=[];
  WAV(ii,jj).(sources{kk}).EngMin=[];        WAV(ii,jj).(sources{kk}).EngFstMin=[];
  WAV(ii,jj).(sources{kk}).EngSum=[];        WAV(ii,jj).(sources{kk}).EngFstSum=[];
  WAV(ii,jj).(sources{kk}).EngInt=[];        WAV(ii,jj).(sources{kk}).EngFstInt=[];  %<Charge or Ener>  (Int value - "Charge" for Curr, "Ener" for Pwr, "Intgrl" for Load)
  WAV(ii,jj).(sources{kk}).RawAvg=[];        WAV(ii,jj).(sources{kk}).RawFstAvg=[];
  WAV(ii,jj).(sources{kk}).RawCtr=[];        WAV(ii,jj).(sources{kk}).RawFstCtr=[];
  WAV(ii,jj).(sources{kk}).RawMax=[];        WAV(ii,jj).(sources{kk}).RawFstMax=[];
  WAV(ii,jj).(sources{kk}).RawMin=[];        WAV(ii,jj).(sources{kk}).RawFstMin=[];
  WAV(ii,jj).(sources{kk}).RawSum=[];        WAV(ii,jj).(sources{kk}).RawFstSum=[];
  WAV(ii,jj).(sources{kk}).RawInt=[];        WAV(ii,jj).(sources{kk}).RawFstInt=[];  %<Charge or Ener>  (Int value - "Charge" for Curr, "Ener" for Pwr, "Intgrl" for Load)
 end
end

%======================================
    function make_psm_display(src,evt)
%======================================        
    %generate figure to display SPEAR3 psm parameters
    SYS.PSMHandles.Figure=figure('Numbertitle','off','name','SPEAR3 PSM Parameters',...
       'Position', [110 300 500 200],'resize','off','Color',background,'CloseRequestFcn',@close_psm);
      
    %Source headers (Monitor, Save, File, Golden)
    uicontrol('Style','text','BackgroundColor',background, 'String', 'Monitor','Position', [105 180 50 17]);
    uicontrol('Style','text','BackgroundColor',background, 'String', 'Golden', 'Position', [205 180 50 17]);
    uicontrol('Style','text','BackgroundColor',background, 'String', 'Save',   'Position', [305 180 50 17]);
    uicontrol('Style','text','BackgroundColor',background, 'String', 'File',   'Position', [405 180 50 17]);
    calcname={'Avg' 'Ctr' 'Max' 'Min' 'Sum' 'Int'};

    dx=100; dy=20;
    for ii=1:size(calcname,2)  %calculated number titles
      uicontrol('Style','text','BackgroundColor',background, 'String', [calcname{ii} ' / Fast'],...
                'Position',[30 180-dy*(ii) 50 17],'HorizontalAlignment','Left');
      uicontrol('Style','frame','BackgroundColor',background,'Position',[95 179-dy*(ii) 400 22]);

      for jj=1:4  %make text fields for calculated numbers
        SYS.PSMHandles.(sources{jj}).(calcname{ii})= uicontrol('Style','text','BackgroundColor',background,...
            'Position', [100+dx*(jj-1) 180-dy*(ii) 30 17],'HorizontalAlignment','Left','String', '2Hz');
        SYS.PSMHandles.(sources{jj}).([calcname{ii} 'Fst'])= uicontrol('Style', 'text','BackgroundColor',background,...
            'Position', [135+dx*(jj-1) 180-dy*(ii) 30 17],'HorizontalAlignment','Left','String', 'Fast');
      end
    end
       SYS.PSMHandles.Units=uicontrol('Style','text','BackgroundColor',background,...
                                            'String', 'Units','Position', [50 5 80 17]);
       SYS.PSMHandles.Waveform=uicontrol('Style','text','BackgroundColor',background,...
                                            'String', 'Waveform Name','Position', [150 5 200 17]);
       SYS.PSMHandles.Time=uicontrol('Style','text','BackgroundColor',background,...
                                            'String', sprintf('%s', datestr(clock,31)),'Position', [350 5 150 17]);
       uicontrol('Style','Pushbutton','BackgroundColor',background,...
                 'Position', [220 30 60 17],'HorizontalAlignment','Left','String', 'Update','Callback',@psm_display_callback);
    
       set(SYS.PSMHandles.Figure,'HandleVisibility','off');

end  %end make_psm_display

%======================================
    function close_psm(src,evt)
%======================================
        %question whether user wants to close SPEAR3 PSM parameter display window
        answer=questdlg('Close parameter display window?','Close display window');
        if strcmpi(answer,'yes')
            delete(SYS.PSMHandles.Figure)
        end
    end

%======================================
    function get_psm
%======================================
      iplot=SYS.iplot;
      iwfm=SYS.iwfm;
      if ~WAV(iplot,iwfm).iLoad
          errordlg('Select waveform first','SPEAR3 PSM Parameter display')
          return
      end
      calcname={'Avg' 'Ctr' 'Max' 'Min' 'Sum' 'Int'};
      ch=WAV(iplot,iwfm).ChannelName;
      %tic
      WAV(iplot,iwfm).Monitor.EngAvg =    getpv([ch WAV(iplot,iwfm).Monitor.EngDataUnits 'Avg']);       
      WAV(iplot,iwfm).Monitor.EngFstAvg = getpv([ch WAV(iplot,iwfm).Monitor.EngDataUnits 'FstAvg']);
      WAV(iplot,iwfm).Monitor.EngCtr =    getpv([ch WAV(iplot,iwfm).Monitor.EngDataUnits 'Centroid']);        
      WAV(iplot,iwfm).Monitor.EngFstCtr = getpv([ch WAV(iplot,iwfm).Monitor.EngDataUnits 'FstCentroid']);
      WAV(iplot,iwfm).Monitor.EngMax =    getpv([ch WAV(iplot,iwfm).Monitor.EngDataUnits 'Max']);        
      WAV(iplot,iwfm).Monitor.EngFstMax = getpv([ch WAV(iplot,iwfm).Monitor.EngDataUnits 'FstMax']);
      WAV(iplot,iwfm).Monitor.EngMin =    getpv([ch WAV(iplot,iwfm).Monitor.EngDataUnits 'Min']);        
      WAV(iplot,iwfm).Monitor.EngFstMin = getpv([ch WAV(iplot,iwfm).Monitor.EngDataUnits 'FstMin']);
      WAV(iplot,iwfm).Monitor.EngSum =    getpv([ch WAV(iplot,iwfm).Monitor.EngDataUnits 'Sum']);        
      WAV(iplot,iwfm).Monitor.EngFstSum = getpv([ch WAV(iplot,iwfm).Monitor.EngDataUnits 'FstSum']);
     %WAV(iplot,iwfm).Monitor.EngInt =    getpv([ch WAV(iplot,iwfm).EngDataUnits 'Avg'];       
     %WAV(iplot,iwfm).Monitor.EngFstInt='';  %<Charge or Ener>  (Int value
     %- "Charge" for Curr, "Ener" for Pwr, "Intgrl" for Load)      WAV(iplot,iwfm).Monitor.EngAvg =    getpv([ch WAV(iplot,iwfm).Monitor.EngDataUnits 'Avg']);       
% % %       WAV(iplot,iwfm).Monitor.RawFstAvg = getpv([ch WAV(iplot,iwfm).Monitor.RawDataUnits 'FstAvg']);
% % %       WAV(iplot,iwfm).Monitor.RawCtr =    getpv([ch WAV(iplot,iwfm).Monitor.RawDataUnits 'Centroid']);        
% % %       WAV(iplot,iwfm).Monitor.RawFstCtr = getpv([ch WAV(iplot,iwfm).Monitor.RawDataUnits 'FstCentroid']);
% % %       WAV(iplot,iwfm).Monitor.RawMax =    getpv([ch WAV(iplot,iwfm).Monitor.RawDataUnits 'Max']);        
% % %       WAV(iplot,iwfm).Monitor.RawFstMax = getpv([ch WAV(iplot,iwfm).Monitor.RawDataUnits 'FstMax']);
% % %       WAV(iplot,iwfm).Monitor.RawMin =    getpv([ch WAV(iplot,iwfm).Monitor.RawDataUnits 'Min']);        
% % %       WAV(iplot,iwfm).Monitor.RawFstMin = getpv([ch WAV(iplot,iwfm).Monitor.RawDataUnits 'FstMin']);
% % %       WAV(iplot,iwfm).Monitor.RawSum =    getpv([ch WAV(iplot,iwfm).Monitor.RawDataUnits 'Sum']);        
% % %       WAV(iplot,iwfm).Monitor.RawFstSum = getpv([ch WAV(iplot,iwfm).Monitor.RawDataUnits 'FstSum']);
% % %      %WAV(iplot,iwfm).Monitor.RawInt =    getpv([ch WAV(iplot,iwfm).RawDataUnits 'Avg'];       
% % %      %WAV(iplot,iwfm).Monitor.RawFstInt='';  %<Charge or Ener>  (Int value
% % %      %- "Charge" for Curr, "Ener" for Pwr, "Intgrl" for Load)
      %load the raw parameters here
      %toc

    end

%======================================        
function psm_display_callback(src,evt)     %psm_display_callback
%======================================        
  get_psm;
  psm_display;
end

%======================================        
function psm_display(src,evt)
%======================================        
      %acquire SPEAR3 data and update display
          if ~ishandle(SYS.PSMHandles.Figure)  %if window does not exist make one
              make_psm_display;
          end

      iplot=SYS.iplot;
      iwfm=SYS.iwfm;
      if ~WAV(iplot,iwfm).iLoad
           errordlg('Select waveform first','SPEAR3 PSM Parameter display')
           return
      end

      calcname={'Avg' 'Ctr' 'Max' 'Min' 'Sum'} ; % 'Int'};

      for ii=1:4 %loop over sources (Monitor, Golden, Save, File)
          %disp(sources{ii})
        for jj=1:size(calcname,2)  %loop over calculated values for each source
            str=num2str(WAV(iplot,iwfm).(sources{ii}).(['Eng' calcname{jj}]), '%8.2f');
            %disp(str)
         set(SYS.PSMHandles.(sources{ii}).(calcname{jj}),...        
         'String',str);
         set(SYS.PSMHandles.(sources{ii}).([calcname{jj} 'Fst']),...
         'String',num2str(WAV(iplot,iwfm).(sources{ii}).(['Eng' 'Fst' calcname{jj} ]), '%8.2f'));
        end
      end
        if    ~SYS.Units
            Units=WAV(iplot,iwfm).Monitor.RawDataUnits;
            set(SYS.PSMHandles.Units,'String','Raw Units','Foregroundcolor',  WAV(iplot,iwfm).Color);
        elseif SYS.Units
            Units=WAV(iplot,iwfm).Monitor.EngDataUnits;
            set(SYS.PSMHandles.Units,'String','Eng Units','Foregroundcolor',  WAV(iplot,iwfm).Color);
        end
        str=['    Plot ' num2str(SYS.iplot) ': ' WAV(iplot,iwfm).CommonName '  [' Units ']'  ];
        set(SYS.PSMHandles.Waveform,'String',str,'Foregroundcolor',  WAV(iplot,iwfm).Color);
        set(SYS.PSMHandles.Time,'String',sprintf('%s', datestr(clock,31)));
end  %end psm_display

%======================================
    function clear_psm_display
%======================================
      calcname={'Avg' 'Ctr' 'Max' 'Min' 'Sum' 'Int'};
      for ii=1:4 %loop over sources (Monitor, Golden, Save, File)
        for jj=1:size(calcname,2)  %loop over calculated values for each source
         set(SYS.PSMHandles.(sources{ii}).(calcname{jj}),        'String',' ');
         set(SYS.PSMHandles.(sources{ii}).([calcname{jj} 'Fst']),'String',' ');
        end
      end
      set(SYS.PSMHandles.Units,'String','Units','Foregroundcolor','k');
      set(SYS.PSMHandles.Waveform,'String','Waveform','Foregroundcolor','k');
      set(SYS.PSMHandles.Time,'String',sprintf('%s', datestr(clock,31)));
    end


end  %program
