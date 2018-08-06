function varargout = orbgui(action, varargin)
%ORBGUI -- Contains routines to set up the main orbit control panel
%  for the 'orbit' program
% function varargout = orbgui(action, varargin)
%  orbgui contains routines to set up the main orbit control panel
%  for the 'orbit' program
%  routines contained in orbgui switchyard are:
%
% OrbFig
% BPMAxes
% LatticeAxes
% CorAxes
% MachineParameters
% UpdateParameters
% SVDAxes
% PlotMenu
% BPMChangeUnits
% CORChangeUnits
% LoadRaw2Real
% AlgorithmMenu
% SVDAlgo
% SuperperiodMenu
% BPMMenu
% CORMenu
% EtaMenu
% SYSMenu
% Switch2online
% Switch2sim
% OptMenu
% SimMenu
% Cor2Zero
% Quad2Zero
% QuadOffset
% MakeNewRef
% PlotAlign
% SetTune
% UpdateOptics
% DisplayOpticsEXCEL
% DisplayOptics
% PlotBetaFunctions
% PlotRingElements
% RespMenu
% UIControls
% BPMbox
% CorBox
% SVDBox
% KnobBox
% Plane
% TogglePlane
% RefreshOrbGUI
% Relative
% Abort
% ScaleBPMAxis
% AutoScaleBPMAxis
% AutoScaleCorrAxis
% ScaleCORAxis
% BPMPlotScale
% ProcessBPMScale
% PlotSPosition
% PlotPhase
% BPMScaleType
% CorPlotScale
% CORScaleType
% ProcessCORScale
% LstBox
% LBox
% GetAbscissa
% InitialSaveSet
% SaveSet2Initial
% SaveSet
% MoveSaveSet
% RestoreSaveSet
% UnDrawSaveSet
% ReDrawSaveSet
% DeleteSaveSet
% SelectSaveSet
% LoadSaveSet
% RestoreSystem
% SaveSystem
% SaveBump
% CloseMainFigure
% 

%
% Written by J. Corbett
% Adapted by Laurent S. Nadolski

% graphics handles

% globals
global BPM COR RSP SYS THERING
orbfig = findobj(0,'tag','orbfig');
plane  = SYS.plane; % 1 for H and 2 for V

[BPMxFamily, BPMzFamily] = BPM.AOFamily;
[HCORFamily, VCORFamily] = COR.AOFamily;

switch action

    %==========================================================
    case 'OrbFig'                               %OrbFig
    %==========================================================
        %orbfig sets up the main figure for the Orbit program.
        %orbit and corrector plots, uicontrols and uimenus fit into orbfig.
        %to print graphics activate menubar
        %PaperPosition sets orientation of figure on print page

        %screen size call
        [screen_wide, screen_high]=screensizecm;

        %fig_start = [0.13*screen_wide 0.16*screen_high];
        fig_start = [0.1*screen_wide 0.1*screen_high];
        %fig_size  = [0.78125*screen_wide 0.78125*screen_high];
        fig_size  = [0.8125*screen_wide 0.8*screen_high];
        SYS.orbfig = figure('Visible','on',...
            'units','centimeters',...
            'NumberTitle','off',...
            'Doublebuffer','on',...
            'Tag','orbfig',...
            'Name','SOLEIL Storage Ring Orbit Correction Interface v.1',...
            'PaperPositionMode','Auto',...
            'MenuBar','None', 'Position',[fig_start fig_size], ...
            'Resize','off', 'CloseRequestFcn', ...
            'orbgui(''CloseMainFigure'')');
        %set(SYS.orbfig,'DeleteFcn',['st=fclose(''all'');' 'CloseCAQuery'],'Resize','off');

%         %==========================================================
%     case 'Axes_1'                               %Axes_1
%         %==========================================================
%         %Establish top axes
% 
%         [screen_wide, screen_high] = screensizecm;
% 
%         x0=0.0478*screen_wide; y0=0.5*screen_high; dx=0.7383*screen_wide; dy=0.2*screen_high;
% 
%         % axe handle 1 = ah1
%         SYS.ahbpm = axes('Units','centimeters',...
%             'Color', [1 1 1], ...
%             'Box','on',...
%             'YGrid','on',...
%             'Position',[x0 y0 dx dy]);
% 
%         set(SYS.ahbpm,'xticklabelmode','manual');
%         set(SYS.ahbpm,'xticklabel',[]);
%         varargout{1} = SYS.ahbpm;

        %==========================================================
    case 'BPMAxes'                               %BPMAxes
        %==========================================================
        %BPMAxes is the axes to plot: reference, desired, actual, predicted
        %columns of response matrix and svd orbit eigenvectors (columns of U: R=UWVt)
        %need NextPlot add to prevent PLOT from resetting fields to default (incl tag)
        %DrawMode

        [screen_wide, screen_high] = screensizecm;

        x0=0.0478*screen_wide; y0=0.5*screen_high; 
        dx=0.7383*screen_wide; dy=0.2*screen_high;

        % axe handle 1 = ah1
        SYS.ahbpm = axes('Units','centimeters',...
            'Color', [1 1 1], ...
            'Box','on',...
            'YGrid','on',...
            'Position',[x0 y0 dx dy]);

        set(SYS.ahbpm,'xticklabelmode','manual');
        set(SYS.ahbpm,'xticklabel',[]);

        set(SYS.ahbpm,'NextPlot','add');
        set(SYS.ahbpm,'ButtonDownFcn','bpmgui(''BPMSelect'')');
        set(SYS.ahbpm,'xticklabelmode','manual');
        set(SYS.ahbpm,'xticklabel',[]);

        label = ['BPM Value  (',  getfamilydata(BPMxFamily,'Monitor','HWUnits'), ')'];

        set(get(SYS.ahbpm,'Ylabel'),'string',label);  %handle for xlabel

%         set(SYS.ahbpm,'NextPlot','add');
%         set(SYS.ahbpm,'ButtonDownFcn','bpmgui(''BPMSelect'')');
%         set(SYS.ahbpm,'xticklabelmode','manual');
%         set(SYS.ahbpm,'xticklabel',[]);
% 
%         label = ['BPM Value  (',  getfamilydata(BPMxFamily,'Monitor','HWUnits'), ')'];
% 
%         set(get(SYS.ahbpm,'Ylabel'),'string',label);  %handle for xlabel

       %==========================================================
    case 'LatticeAxes'                                   %ZoomAxes
        %==========================================================
        %Position Axes is for slider that controls zoom of display windows

        [screen_wide, screen_high] = screensizecm;

        x0 = 0.0478*screen_wide; y0 = 0.473*screen_high; 
        dx = 0.7383*screen_wide; dy = 0.025*screen_high;

        SYS.ahpos = axes('Units','centimeters',...
            'Color', [1 1 1],...
            'Box','on',...
            'Position',[x0 y0 dx dy],...
            'xticklabelmode','manual',...
            'yticklabelmode','manual',...
            'xtickmode','manual',...
            'ytickmode','manual');

        drawlattice;
        
        set(SYS.ahpos,'XTick',[],'YTick',[]); % to erase tick labels
       
        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'CorAxes'                               %CorAxes
        %==========================================================
        %CorAxes are the axes to plot: actual, fit correctors
        %and svd corrector eigenvectors (columns of V: R=UWVt)

        [screen_wide, screen_high]=screensizecm;

        x0=0.0478*screen_wide; y0=0.27*screen_high; 
        dx=0.7383*screen_wide; dy=0.2*screen_high;

        %axe handle for correctors 
        SYS.ahcor = axes('Units','centimeters',...
            'NextPlot','add',...
            'Color', [1 1 1], ...
            'Box','on',...
            'YGrid','on',...
            'Position',[x0 y0 dx dy],...
            'ButtonDownFcn','corgui(''CorSelect'')');

        label=['Corrector Value  (',  getfamilydata(HCORFamily,'Setpoint','HWUnits'), ')'];

        set(get(SYS.ahcor,'Ylabel'),'string',label);  %handle for xlabel
        set(get(SYS.ahcor,'Xlabel'),'string','Position in Storage Ring (m)');

        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'MachineParameters'              %...MachineParameters
        %==========================================================
        %Create field boxes to display beam energy and current
        [screen_wide, screen_high] = screensizecm;

        x0=0.4*screen_wide; y0=0.76*screen_high; dx=0.08*screen_wide; dy=0.02*screen_high;

        uicontrol('Style','text',...                            %Current Text
            'units', 'centimeters','Position',[x0+0*dx y0 dx dy],...
            'HorizontalAlignment','right',...
            'ToolTipString','Electron Beam Current (A)',...
            'String','Current (mA)');

        SYS.hcurrent=uicontrol('Style','PushButton',...  %Current Display
            'units', 'centimeters','Position',[x0+1.1*dx y0+0.005*screen_high dx/1.5 dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'ToolTipString','Electron Beam Current (A)',...
            'CallBack','orbgui(''UpdateParameters'')',...
            'String',num2str(SYS.current, '%6.1f'));

        uicontrol('Style','text',...                           %Energy Text
            'units', 'centimeters','Position',[x0+0*dx y0-dy dx dy],...
            'HorizontalAlignment','right',...
            'ToolTipString','Electron Beam Energy (GeV)',...
            'String','Energy (GeV)');

        SYS.henergy=uicontrol('Style','PushButton',...   %Energy Display
            'units', 'centimeters','Position',[x0+1.1*dx y0-dy+0.005*screen_high dx/1.5 dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'ToolTipString','Electron Beam Energy (GeV)',...
            'CallBack','orbgui(''UpdateParameters'')',...
            'String',num2str(SYS.energy, '%6.4f'));

        uicontrol('Style','text',...                            %Lifetime Text
            'units', 'centimeters','Position',[x0+1.8*dx y0 dx dy],...
            'HorizontalAlignment','right',...
            'ToolTipString','Electron Beam Lifetime (h)',...
            'String','Lifetime (h)');

        SYS.hlifetime=uicontrol('Style','PushButton',... %Lifetime Display
            'units', 'centimeters','Position',[x0+3.0*dx y0+0.005*screen_high dx/1.5 dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'ToolTipString','Electron Beam Lifetime (h)',...
            'CallBack','orbgui(''UpdateParameters'')',...
            'String',num2str(SYS.lifetime, '%6.1f'));

        uicontrol('Style','text',...                            %Amp-hr Text
            'units', 'centimeters','Position',[x0+1.8*dx y0-dy dx dy],...
            'HorizontalAlignment','right',...
            'ToolTipString','Running mode: online or simulator',...
            'String','Mode');

        SYS.modecolor = uicontrol('Style','PushButton',...                            %Amp-hr Text
            'units', 'centimeters','Position',[x0 + 3*dx y0 - dy dx/1.5 dy],...
            'HorizontalAlignment','center');
              
%         uicontrol('Style','text',...                            %Amp-hr Text
%             'units', 'centimeters','Position',[x0+1.8*dx y0-dy dx dy],...
%             'HorizontalAlignment','right',...
%             'ToolTipString','Electron beam amp-hours',...
%             'String','Amp-hr:');
% 
%         SYS.amphr=uicontrol('Style','PushButton',...     %Amp-hr Display
%             'units', 'centimeters','Position',[x0+3.0*dx y0-dy+0.005*screen_high dx/1.5 dy],...
%             'BackGroundColor',[0.77 0.91 1.00],...
%             'ToolTipString','Electron beam amp-hours',...
%             'CallBack','orbgui(''UpdateParameters'')',...
%             'String',num2str(SYS.ahr, '%6.1f'));

        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'UpdateParameters'              %...UpdateParameters
        %==========================================================
        %Update field boxes that display machine parameters

        
        if strcmpi(SYS.machine,'Ring')
            [SYS.energy,SYS.current,SYS.lifetime] = getringparams;
            setappdata(0,'SYS',SYS);
        end
        set(SYS.henergy,  'String',num2str(SYS.energy,  '%6.4f'));
        set(SYS.hcurrent, 'String',num2str(SYS.current, '%6.3f'));        
        set(SYS.hlifetime,'String',num2str(SYS.lifetime,'%6.3f'));

        %==========================================================
    case 'SVDAxes'                               %SVDAxes
        %==========================================================
        %SVDAxes are the axes to plot singular value spectrum/logarithmic

        %screen size call
        [screen_wide, screen_high]=screensizecm;

        x0=0.6*screen_wide; dx=0.19*screen_wide; 
        y0=0.0495*screen_high; dy=0.14*screen_high;

        % axe handle for SVD
        SYS.ahsvd = axes('Units','centimeters','YScale','log','NextPlot', ...
            'add','Color', [1 1 1],'Box','On','Position',[x0 y0 dx dy], ...
            'XminorTick','On','YminorTick','On');

        setappdata(0,'SYS',SYS);

        set(get(SYS.ahsvd,'Ylabel'),'string','Singular Value');
        set(get(SYS.ahsvd,'Xlabel'),'string','Singular Value Index');
        
        %==========================================================
    case 'PlotMenu'                               %  PlotMenu
        %==========================================================
        %*** PLOT MENU ***
        mh.plot = uimenu('Label','Plot    ');
        uimenu(mh.plot,'Label','BPM Plot Scale', ...
            'Callback','orbgui(''BPMPlotScale'')');
        uimenu(mh.plot,'Label','Corrector Plot Scale', ...
            'Callback','orbgui(''CorPlotScale'')');
        mh.r2=uimenu(mh.plot,'Label','BPM Unit Data Display');
        SYS.BPMPhysicsUnits = ...
            uimenu(mh.r2,'Label','Physics Units','Callback', ...
            'orbgui(''BPMChangeUnits'',''Physics'')');
        SYS.BPMHardwareUnits = ...
            uimenu(mh.r2,'Label','Hardware Units','Callback', ...
            'orbgui(''BPMChangeUnits'',''Hardware'')');
        SYS.BPM1000HardwareUnits = ...
            uimenu(mh.r2,'Label','1000xHardware Units','Callback', ...
            'orbgui(''BPMChangeUnits'',''1000xHardware'')');
        mh.r3=uimenu(mh.plot,'Label','COR Unit Data Display');
        SYS.CORPhysicsUnits = ...
            uimenu(mh.r3,'Label','Physics Units','Callback', ...
            'orbgui(''CORChangeUnits'',''Physics'')');
        SYS.CORHardwareUnits = ...
            uimenu(mh.r3,'Label','Hardware Units','Callback', ...
            'orbgui(''CORChangeUnits'',''Hardware'')');
%         uimenu(mh.plot,'Label',' ');
%         mh.r2r=uimenu(mh.plot,'Label','Raw/Real Data Display');
%         uimenu(mh.r2r,'Label','Display Raw Data','Callback','orbgui('''')');
%         uimenu(mh.r2r,'Label','Display Real Data','Callback','orbgui('''')');
%         uimenu(mh.r2r,'Label','Update Raw2Real Coefficients','Callback','orbgui('''')');        
%         uimenu(mh.plot,'Label','Cross-Hair: Axes Start Location','Callback','orbgui(''StartLoc'')');
%         uimenu(mh.plot,'Label','Cross-Hair: Axes Stop Location', 'Callback','orbgui(''StopLoc'')');
%         uimenu(mh.plot,'Label','Reset Horizontal Scale',        'Callback','orbgui(''ResetAxes'')');
        setappdata(0,'SYS',SYS);
    
        %==========================================================
    case 'BPMChangeUnits'  % BPM Unit data Display
        %==========================================================
        
        BPM(1).units = varargin{1};
        BPM(2).units = varargin{1};
        
        setappdata(0,'BPM',BPM);
        
        %% BPM y-axis label
        label = get(get(SYS.ahbpm,'Ylabel'),'string');       
        switch varargin{1}
            case 'Hardware'
                Unit = 'mm';
                set(SYS.BPMPhysicsUnits,'Checked','Off');
                set(SYS.BPMHardwareUnits,'Checked','On');
                set(SYS.BPM1000HardwareUnits,'Checked','Off');
                BPM(1).scale = 1; 
                BPM(2).scale = 1; 
            case '1000xHardware'
                Unit = 'um';
                set(SYS.BPMPhysicsUnits,'Checked','Off');
                set(SYS.BPMHardwareUnits,'Checked','Off');
                set(SYS.BPM1000HardwareUnits,'Checked','On');
                BPM(1).scale = 1000; 
                BPM(2).scale = 1000; 
            case 'Physics'
                Unit = 'm';
                set(SYS.BPMPhysicsUnits,'Checked','On');
                set(SYS.BPMHardwareUnits,'Checked','Off');
                set(SYS.BPM1000HardwareUnits,'Checked','Off');
                BPM(1).scale = 0.001; 
                BPM(2).scale = 0.001; 
        end

        label = [label(1:strfind(label,'(')-1) '(' Unit ')'];
        set(get(SYS.ahbpm,'Ylabel'),'string',label);
        
        setappdata(0,'SYS',SYS);

        bpmgui('RePlot');
        bpmgui('UpdateBPMBox');
        
        %==========================================================
    case 'CORChangeUnits'  % BPM Unit data Display
        %==========================================================
        
        for plane = 1:2
            COR(plane).units = varargin{1};
        end
        
        setappdata(0,'COR',COR);
        
        %% HCOR y-axis label
        label = get(get(SYS.ahcor,'Ylabel'),'string');       
        switch varargin{1}
            case {'Hardware','1000xHardware'}
                Unit = 'A';
                set(SYS.CORPhysicsUnits,'Checked','Off');
                set(SYS.CORHardwareUnits,'Checked','On');
            case 'Physics'
                Unit = 'mrad';
                set(SYS.CORPhysicsUnits,'Checked','On');
                set(SYS.CORHardwareUnits,'Checked','Off');
        end
        label = [label(1:strfind(label,'(')-1) '(' Unit ')'];
        set(get(SYS.ahcor,'Ylabel'),'string',label);

        corgui('RePlot')
        corgui('UpdateCorBox');

        %==========================================================
    case 'LoadRaw2Real'                         %  LoadRaw2Real
        %==========================================================
        %Load Raw2Real Coefficients into AppData

        Families = {BPMxFamily, BPMzFamily, HCORFamily, VCORFamily};

        for k = 1:length(Families)
            Family     = Families{k};
            DeviceList = getlist(Family,0);   %0 gives all entries
            raw2realdata.(Family).Gain    = getphysdata(Family, 'Gain',   DeviceList);
            raw2realdata.(Family).Offset  = getphysdata(Family, 'Offset', DeviceList);
        end

        setappdata(0,'raw2realdata',raw2realdata);

%         %==========================================================
%     case 'AlgorithmMenu'                       %  AlgorithmMenu
%         %==========================================================
%         %*** Algorithn MENU ***
%         mh.algo = uimenu('Label','Fit Algorithm');
%         uimenu(mh.algo,'Label','SVD','Callback',...
%             'orbgui(''SVDAlgo'');');
%         uimenu(mh.algo,'Label','Micado','Callback',...
%             'orbgui(''MicadoAlgo'');');

        %==========================================================
    case 'SVDAlgo'                       %  SVDAlgo
        %==========================================================
        SYS.algo='SVD';
        setappdata(0,'SYS',SYS);

        %==========================================================
%     case 'MicadoAlgo'                       %  MicadoAlgo
%         %==========================================================
%         SYS.algo='Micado';
%         setappdata(0,'SYS',SYS);

        %==========================================================
    case 'SuperperiodMenu'                       %  SuperperiodMenu
        %==========================================================
        %*** Algorithn MENU ***
        mh.superperiod = uimenu('Label','Super-period');
        SYS.allmachine = ...
            uimenu(mh.superperiod,'Label','All storage ring','Callback',...
            'orbgui(''plotxaxis'',''allmachine'');','Tag','allmachine');
        SYS.superperiod1 = ...
            uimenu(mh.superperiod,'Label','Super period #1','Callback',...
            'orbgui(''plotxaxis'',''superperiod1'');','Tag','superperiod1');
        SYS.superperiod2 = ...
            uimenu(mh.superperiod,'Label','Super period #2','Callback',...
            'orbgui(''plotxaxis'',''superperiod2'');','Tag','superperiod2');
        SYS.superperiod3 = ...
            uimenu(mh.superperiod,'Label','Super period #3','Callback',...
            'orbgui(''plotxaxis'',''superperiod3'');','Tag','superperiod3');
        SYS.superperiod4 = ...
            uimenu(mh.superperiod,'Label','Super period #4','Callback',...
            'orbgui(''plotxaxis'',''superperiod4'');','Tag','superperiod4');
        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'plotxaxis'
        %==========================================================
        
        action = varargin{1};
        
        bpm_axe     = axis(SYS.ahbpm);
        cor_axe     = axis(SYS.ahcor);
        lattice_axe = axis(SYS.ahpos);
      
        switch action
            case 'allmachine'
                AxisRange1X = [0 1]*SYS.xlimax;
            case 'superperiod1'
                AxisRange1X = [0 0.25]*SYS.xlimax;
            case 'superperiod2'
                AxisRange1X = [0.25 0.5]*SYS.xlimax;
            case 'superperiod3'
                AxisRange1X = [0.5 0.75]*SYS.xlimax;
            case 'superperiod4'
                AxisRange1X = [0.75 1]*SYS.xlimax;
        end

        axis(SYS.ahbpm,   [AxisRange1X bpm_axe(3:4)]);
        axis(SYS.ahcor, [AxisRange1X cor_axe(3:4)]);
        axis(SYS.ahpos, [AxisRange1X lattice_axe(3:4)]);

        setappdata(0, 'xaxe', AxisRange1X);

        set(SYS.allmachine,'Checked','Off');
        set(SYS.superperiod1,'Checked','Off');
        set(SYS.superperiod2,'Checked','Off');
        set(SYS.superperiod3,'Checked','Off');
        set(SYS.superperiod4,'Checked','Off');
        set(SYS.(action),'Checked','On');


        %==========================================================
    case 'BPMMenu'                               %  BPMMenu
        %==========================================================
        %*** BPM MENU ***
        mh.bpms = uimenu('Label','BPMs');
        uimenu(mh.bpms,'Label','Select All BPMs','Callback','bpmgui(''SelectAll'');');
        uimenu(mh.bpms,'Label','Select No BPM','Callback','bpmgui(''SelectNone'');');
        uimenu(mh.bpms,'Label','Remove BPM Drag Changes','Callback','bpmgui(''ClearOffsets'');');
        uimenu(mh.bpms,'Label','Show BPM State','Callback','bpmgui(''ShowBPMState'');');
        uimenu(mh.bpms,'Label','Archive X-Orbit',          'Callback', ...
            'readwrite(''ArchiveBPMOrbit'',''X'');','Separator','on');
        uimenu(mh.bpms,'Label','Archive Z-Orbit',          'Callback', ...
            'readwrite(''ArchiveBPMOrbit'',''Z'');');
        uimenu(mh.bpms,'Label','Archive X/Z-Orbit',        'Callback', ...
            'readwrite(''ArchiveBPMOrbit'',''XZ'');');
        uimenu(mh.bpms,'Label','Load X-Reference Orbit',   'Callback', ...
            'readwrite(''ReadBPMReference'',''X'');','Separator','on');
        uimenu(mh.bpms,'Label','Load Z-Reference Orbit',   'Callback', ...
            'readwrite(''ReadBPMReference'',''Z'');');
        uimenu(mh.bpms,'Label','Load X/Z-Reference Orbit', 'Callback', ...
            'readwrite(''ReadBPMReference'',''XZ'');');
        uimenu(mh.bpms,'Label','Archive Golden X-Orbit',   'Callback', ...
            'readwrite(''ArchiveBPMOrbit'',''X'',''Golden'');','Separator','on');
        uimenu(mh.bpms,'Label','Archive Golden Z-Orbit',   'Callback', ...
            'readwrite(''ArchiveBPMOrbit'',''Z'',''Golden'');');
        uimenu(mh.bpms,'Label','Archive Golden X/Z-Orbit', 'Callback', ...
            'readwrite(''ArchiveBPMOrbit'',''XZ'',''Golden'');');
        uimenu(mh.bpms,'Label','Load Golden X-Reference',  'Callback', ...
            'readwrite(''ReadBPMReference'',''X'',''Golden'');','Separator','on');
        uimenu(mh.bpms,'Label','Load Golden Z-Reference',  'Callback', ...
            'readwrite(''ReadBPMReference'',''Z'',''Golden'');');
        uimenu(mh.bpms,'Label','Load Golden X/Z-Reference','Callback', ...
            'readwrite(''ReadBPMReference'',''XZ'',''Golden'');');

        %Select horizontal BPM weights
        cback='rload(''GenFig'', BPM(1).name,BPM(1).avail,BPM(1).ifit,BPM(1).wt,';
        cback=[cback '''Horizontal BPM Weights'',''xbwt'');'];
        %instructions are used during 'load' procedure of rload window
        instructions=[...
            '   global BPM;',...
            '   tlist = get(gcf,''UserData'');',...
            '   BPM(1).wt=tlist{4};',...
            '   setappdata(0,''BPM'',BPM);',...
            '   orbgui(''RefreshOrbGUI'');'];
        uimenu(mh.bpms,'Label','Select X-BPM Weights','Callback', ...
            cback,'Tag','xbwt','Userdata',instructions,'Separator','on');

        %Select vertical BPM weights
        cback='rload(''GenFig'', BPM(2).name,BPM(2).avail,BPM(2).ifit,BPM(2).wt,';
        cback=[cback '''Vertical BPM Weights'',''zbwt'');'];
        %instructions are used during 'load' procedure of rload window
        instructions=[...
            '   global BPM;',...
            '   tlist = get(gcf,''UserData'');',...
            '   BPM(2).wt=tlist{4};',...
            '   setappdata(0,''BPM'',BPM);',...
            '   orbgui(''RefreshOrbGUI'');'];

        uimenu(mh.bpms,'Label','Select Z-BPM Weights','Callback', ...
            cback,'Tag','ybwt','Userdata',instructions);
%         uimenu(mh.bpms,'Label','   ');
%         uimenu(mh.bpms,'Label','Help with BPM Functions','Callback','readwrite(''OpenHelp'');');

        %==========================================================
    case 'CORMenu'                               %  CORMenu
        %==========================================================
        %*** CORRECTOR MENU ***
        mh.cors = uimenu('Label','Correctors');
        uimenu(mh.cors,'Label','Update Correctors','Callback', ...
            'corgui(''UpdateCorrs'');');
        uimenu(mh.cors,'Label','Corrector strengths to zero (this plane)', ...
            'Callback','orbgui(''Cor2Zero'')');
        uimenu(mh.cors,'Label','Select All Correctors','Callback', ...
            'corgui(''SelectAll'');','Separator','on');
        uimenu(mh.cors,'Label','Select No Correctors','Callback', ...
            'corgui(''SelectNone'');');
        uimenu(mh.cors,'Label','Load Correctors','Callback', ...
            'readwrite(''DialogBox'',''Read Correctors'',''ReadCorrectors'');','Separator','on');
        uimenu(mh.cors,'Label','Archive Correctors','Callback', ...
            'readwrite(''DialogBox'',''Write Correctors'',''WriteCorrectors'');');

        %Select horizontal corrector limits
        cback='rload(''GenFig'', COR(1).name,COR(1).status,COR(1).avail,COR(1).lim,';
        cback=[cback '''Horizontal Corrector Limits'',''xclim'');'];
        %instructions are used during 'load' procedure of rload window
        instructions=[...
            '   global COR;',...
            '   tlist = get(gcf,''UserData'');',...
            '   COR(1).lim=tlist{4};',...
            '   setappdata(0,''COR'',COR);'];
        uimenu(mh.cors,'Label','Select X-Corrector Limits','Callback', ...
            cback,'Tag','xclim','Userdata',instructions,'Separator','on');

        %Select horizontal corrector weights
        cback='rload(''GenFig'', COR(1).name,COR(1).status,COR(1).ifit,COR(1).wt,';
        cback=[cback '''Horizontal Corrector Weights'',''xcwt'');'];
        %instructions are used during 'load' procedure of rload window
        instructions=[...
            '   global COR;',...
            '   tlist = get(gcf,''UserData'');',...
            '   COR(1).wt=tlist{4};',...
            '   setappdata(0,''COR'',COR);',...
            '   orbgui(''RefreshOrbGUI'');'];

        uimenu(mh.cors,'Label','Select X-Corrector Weights','Callback', ...
            cback,'Tag','xcwt','Userdata',instructions);

        %Select vertical corrector limits
        cback='rload(''GenFig'', COR(2).name,COR(2).status,COR(2).avail,COR(2).lim,';
        cback=[cback '''Vertical Corrector Limits'',''zclim'');'];
        %instructions are used during 'load' procedure of rload window
        instructions=[...
            '   global COR;',...
            '   tlist = get(gcf,''UserData'');',...
            '   COR(2).lim=tlist{4};',...
            '   setappdata(0,''COR'',COR);'];
        uimenu(mh.cors,'Label','Select Z-Corrector Limits','Callback',cback, ...
            'Tag','zclim','Userdata',instructions,'Separator','on');

        %Select vertical corrector weights
        cback='rload(''GenFig'', COR(2).name,COR(2).status,COR(2).ifit,COR(2).wt,';
        cback=[cback '''Vertical Corrector Weights'',''zcwt'');'];
        %instructions are used during 'load' procedure of rload window
        instructions=[...
            '   global COR;',...
            '   tlist = get(gcf,''UserData'');',...
            '   COR(2).wt=tlist{4};',...
            '   setappdata(0,''COR'',COR);',...
            '   orbgui(''RefreshOrbGUI'');'];

        uimenu(mh.cors,'Label','Select Z-Corrector Weights','Callback',cback, ...
            'Tag','zcwt','Userdata',instructions);
        uimenu(mh.cors,'Label','Show Corrector State','Callback', ...
            'corgui(''ShowCORState'');','Separator','on');
%         uimenu(mh.cors,'Label','Help with Corrector Functions','Callback','readwrite(''OpenHelp'');');

        %==========================================================
    case 'EtaMenu'                               %  EtaMenu
        %==========================================================
        %*** Dispersion control MENU ***
        mh.eta = uimenu('Label','Eta Fit');
        uimenu(mh.eta,'Label','Load Dispersion Orbit','Callback', ...
            'readwrite(''DialogBox'',''Load Reference Orbit'',''ReadDispersion'');');
        uimenu(mh.eta,'Label','Display Dispersion Control Panel','Callback', ...
            'respgui(''DispersionPanel'')');
        uimenu(mh.eta,'Label','Display Dispersion Correction','Callback', ...
            'respgui(''DispersionPlot'')');

        %==========================================================
    case 'SYSMenu'                               %  SYSMenu
        %==========================================================
        %*** SYSTEM MENU ***
        mh.sys = uimenu('Label','Session');
        menuh = uimenu(mh.sys,'Label','Mode');
        SYS.online = uimenu(menuh,'Label','Online','Callback', ...
            'orbgui(''Switch2online'')');        
        SYS.sim   = uimenu(menuh,'Label','Simulator','Callback', ...
            'orbgui(''Switch2sim'')');

        menuh = uimenu(mh.sys,'Label','Do not use this menu', ...
            'ForegroundColor', 'r', 'Separator','On');
        uimenu(menuh,'Label','Save Program Parameters','Callback', ...
            'readwrite(''DialogBox'',''Save System Parameters'',''SaveSystem'');');
        uimenu(menuh,'Label','Restore Program Parameters','Callback', ...
            'readwrite(''DialogBox'',''Restore System Parameters'',''RestoreSystem'')');
        
        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'Switch2online'                         %  Switch2online
        %==========================================================
                
        if strcmpi(SYS.mode,'Simulator') % was Simulator turned Online
            set(SYS.online, 'Checked', 'On');
            set(SYS.sim,    'Checked', 'Off');
            set(SYS.orbfig,'Name', ...
                'SOLEIL Storage Ring Orbit Correction Interface (Online)');
            set(SYS.modecolor,'BackGroundColor','r','String','Online');
            orbgui('LBox','Warning: switched to online');
            SYS.mode = 'Online';
            setappdata(0,'SYS',SYS);
        end

        %==========================================================
    case 'Switch2sim'                         %  Switch2sim
        %==========================================================
        
        if strcmpi(SYS.mode,'Online')
            set(SYS.online, 'Checked', 'Off');
            set(SYS.sim,    'Checked', 'On');
            set(SYS.orbfig,'Name', ...
                'SOLEIL Storage Ring Orbit Correction Interface (Simulator)');
            set(SYS.modecolor,'BackGroundColor','g','String','Simulator');
            orbgui('LBox','Warning: switched to simulator');
            SYS.mode = 'Simulator';
            setappdata(0,'SYS',SYS);
        end

        %==========================================================
    case 'OptMenu'                               %  OptMenu
        %==========================================================
        %*** OPTICS MENU ***
        mh.opt = uimenu('Label','Optics');
        uimenu(mh.opt,'Label','Display Optics Parameters','Callback',...
            'orbgui(''DisplayOptics'')');
        if ispc
            uimenu(mh.opt,'Label','Display Optics Parameters in EXCEL', ...
                'Callback','orbgui(''DisplayOpticsEXCEL'')');
        end
        uimenu(mh.opt,'Label','Plot Betafunctions','Callback', ...
            'orbgui(''PlotBetaFunctions'')');
        uimenu(mh.opt,'Label','Plot Ring Elements','Callback', ...
            'orbgui(''PlotRingElements'')');

        %==========================================================
    case 'SimMenu'                               %  SimMenu
        %==========================================================
        % %*** SIMULATION MENU ***
        mh.sim = uimenu('Label','Simulator');
        uimenu(mh.sim,'Label','New Quad Alignment (both plane)', ...
            'Callback', 'orbgui(''QuadOffset'')');
        uimenu(mh.sim,'Label','Make New Reference Orbit (this plane)', ...
            'Callback','orbgui(''MakeNewRef'')');
        uimenu(mh.sim,'Label','Quad alignment to zero (both planes)', ...
            'Callback','orbgui(''Quad2Zero'')');
        uimenu(mh.sim,'Label','Update Optics (LinOpt)', ...
            'Callback','orbgui(''UpdateOptics'')','Separator','on');
        t   = getphysdata;   
        str = sprintf('Fit Tunes to %3.2f/%3.2f',t.TUNE.Golden(1),t.TUNE.Golden(2));
        uimenu(mh.sim,'Label',str,'Callback','orbgui(''SetTune'')');

        %==========================================================
    case 'Cor2Zero'                             %...Quad2Zero
        %==========================================================
        %Callback of Simulator/'Corrector Strengths to Zero'

        %set correctors to zero
        if plane == 1
            setsp(HCORFamily,0.0,SYS.mode);   %only sets correctors with valid status
        elseif plane == 2
            setsp(VCORFamily,0.0,SYS.mode);
        end

        bpmgui('GetAct');
        corgui('GetAct');
        orbgui('RefreshOrbGUI');

        %==========================================================
    case 'Quad2Zero'                             %...Quad2Zero
        %==========================================================
        %Callback of Simulator/'Quadrupole Strenths to Zero'

        %set quadrupole offsets to zero
        quadalign(0.0,0.0);
        bpmgui('GetAct');
        corgui('GetAct');
        orbgui('RefreshOrbGUI');

        %==========================================================
    case 'QuadOffset'                            %...QuadOffset
        %==========================================================
        %Callback of Simulator/'New Quad Alignment'

        %apply quadrupole offsets
        quadalign(0.0001,0.0001);  %units are meters
        bpmgui('GetAct');
        corgui('GetAct');
        orbgui('RefreshOrbGUI')

        %==========================================================
    case 'MakeNewRef'                            %...MakeNewRef
        %==========================================================
        %callback of Simulation 'Make New Reference Orbit'

        %record present quad positions for reset

        AO = getappdata(0,'AcceleratorObjects');

        ATindx = [] ;
        
        aofields = fieldnames(AO);
        
        %% look for quads in lattice
        for ii = 1:length(aofields)
            if strcmpi(AO.(aofields{ii}).FamilyType,'quad')
                ATindx = [AO.(aofields{ii}).AT.ATIndex];
            end
        end
        
        ATindx = unique(ATindx)';

        mx0 = getcellstruct(THERING,'T1',ATindx,1);
        my0 = getcellstruct(THERING,'T1',ATindx,3);

        %set quads to zero
        quadalign(0.0,0.0);  %units are meters

        %produce a new random orbit
        quadalign(0.00001,0.00001);  %units are meters, 10 um rms

        %load new reference orbit
        bpmgui('GetRef');
        BPM(1).des = BPM(1).ref;
        BPM(1).abs = BPM(1).ref;
        BPM(2).des = BPM(2).ref;
        BPM(2).abs = BPM(2).ref;

        if SYS.relative == 1    %Absolute orbit mode
            BPM(1).abs = zeros(size(BPM(1).name,1),1);
            BPM(2).abs = zeros(size(BPM(2).name,1),1);
        end

        setappdata(0,'BPM',BPM);

        %put quads back to original position
        setshift(ATindx,-mx0,-my0);

        bpmgui('GetAct');
        corgui('GetAct');
        orbgui('RefreshOrbGUI');

        %==========================================================
    case 'PlotAlign'                            %...PlotAlign
        %==========================================================
        %update graphics after alignments changed
        bpmgui('GetRef');
        BPM(1).des = BPM(1).ref;
        BPM(1).abs = BPM(1).ref;
        BPM(2).des = BPM(2).ref;
        BPM(2).abs = BPM(2).ref;

        if SYS.relative == 1
            BPM(1).abs = zeros(size(BPM(1).name,1),1);
            BPM(2).abs = zeros(size(BPM(2).name,1),1);
        end

        setappdata(0,'BPM',BPM);

        orbgui('RefreshOrbGUI');

        %==========================================================
    case 'SetTune'                    %...SetTune
        %==========================================================
        %set tune back to nominal values
        t = getphysdata;
        
        TuneFitFamily1 = 'Q7';
        TuneFitFamily2 = 'Q9';
        
        fittune2([t.TUNE.Golden(1),t.TUNE.Golden(2)], TuneFitFamily1, TuneFitFamily2);
        
        bpmgui('UpdateAct');

        %==========================================================
    case 'UpdateOptics'                    %...UpdateOptics
        %==========================================================
        %recompute linear optics
        [LinData, Nu, Ksi] = linopt(THERING ,0.0, 1:length(THERING));
        disp(['Nux: ' num2str(Nu(1)) '       Nuz: ' num2str(Nu(2))])

        %==========================================================
    case 'DisplayOpticsEXCEL'            %...DisplayOpticsEXCEL
        %==========================================================
        ring2excel

        %==========================================================
    case 'DisplayOptics'                      %...DisplayOptics
        %==========================================================
        %Display Optics to command window
        NR = length(THERING);
        orbgui('LBox','Calculating Accelerator Optics...');
        optics = gettwiss(THERING,0.0);
        orbit  = findorbit4(THERING,0.0,1:NR);
        orbgui('LBox','Begin Writing Twiss Parameters');
 
        ivec = (1:NR)';        
        Strcell = cell(18,NR);
        Strcell(1,:) = num2cell(ivec);
        Strcell(2,:) = cellstr(optics.name)';
        Strcell(3:end,:) = num2cell([optics.len,optics.s, ...
            optics.betax,optics.alfax, optics.phix, optics.etax, optics.etapx, ...
            optics.betay,optics.alfay, optics.phiy, optics.etay, optics.etapy, ...
            orbit(1,:)',orbit(2,:)',orbit(3,:)',orbit(4,:)'])';

        filename = [SYS.localdata 'twissdata.txt'];
        fid = fopen(filename,'w');
        fprintf(fid,[' index   name  length   s     betx   alfx   phix' ...
            'etax   etaxp  betz   alfz   phiz   etaz   etazp    x' ...
            '      xp     z      zp\n']);
        fprintf(fid,['%4d %8s %6.2f %6.2f %6.2f %6.2f %6.2f % 6.2f %' ...
            '6.2f %6.2f %6.2f %6.2f % 6.2f % 6.2f %6.2f %6.2f %6.2f ' ...
            '%6.2f\n'],...
            Strcell{:});
        fclose(fid);
        system(['nedit ', filename, ' &']);  % much faster
        
%         for ii = 1:NR
%             name = optics.name(ii,:);
%             len  = optics.len(ii);
%             s    = optics.s(ii);
%             betx = optics.betax(ii);
%             alfx = optics.alfax(ii);
%             phix = optics.phix(ii);
%             etax = optics.etax(ii);
%             etapx= optics.etapx(ii);
% 
%             bety = optics.betay(ii);
%             alfy = optics.alfay(ii);
%             phiy = optics.phiy(ii);
%             etay = optics.etay(ii);
%             etapy= optics.etapy(ii);
% 
%             x = orbit(1,ii);  xp = orbit(2,ii);
%             y = orbit(3,ii);  yp = orbit(4,ii);
% 
%             fprintf('%6d %8s %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n',...
%                 ii,name,s,len,betx,alfx,phix,etax,etapx,bety,alfy,phiy,etay,etapy,x,xp,y,yp)
%             %     'one',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
%         end
%         disp(['Horizontal Tune ' num2str(phix) 'Vertical Tune ' num2str(phiy)])
        orbgui('LBox','Finished Writing Twiss Parameters');

        %==========================================================
    case 'PlotBetaFunctions'               % PlotBetaFunctions
        %==========================================================
        %plot betafunctions
        figure;
        plotbeta;

        %==========================================================
    case 'PlotRingElements'                % PlotRingElements
        %==========================================================
        %call intlat
        intlat;

        %==========================================================
    case 'RespMenu'                               %  RespMenu
        %==========================================================
        %response matrix
        mh.rsp = uimenu('Label','R-Matrix');
        uimenu(mh.rsp,'Label','Read Response Matrix','Callback', ...
            'readwrite(''ReadResponse'')');

        % COULD BE NOT LATER
%         uimenu(mh.rsp,'Label','Write Response Matrix', ...
%             'Callback','readwrite(''DialogBox'',''Write Response Matrix'',''WriteResponse'')');

%         uimenu(mh.rsp,'Label','    ');
        SYS.showeig  = uimenu(mh.rsp,'Label','Show Eigenvectors', ...
            'UserData',0,'Callback','corgui(''ShowEig'')','Separator','on');
        SYS.showresp = uimenu(mh.rsp,'Label','Show Response', ...
            'UserData',0,'Callback','corgui(''ShowResp'')');

%         uimenu(mh.rsp,'Label','    ');
        %Select corrector currents for horizontal response to eBPMs
%         cback = ['rload(''GenFig'', COR(1).name,COR(1).status,COR(1).ifit,COR(1).ebpm,'];
%         cback = [cback '''Horizontal Correctors to Electron BPMs'',''hbpm'');'];
%         %instructions are used during 'load' procedure of rload window
%         instructions = [...
%             '   global COR;',...
%             '   tlist = get(gcf,''UserData'');',...
%             '   COR(1).ebpm=tlist{4};',...
%             '   setappdata(0,''COR'',COR);'];
%         uimenu(mh.rsp,'Label','Select X-Corrector Strengths (BPM)',...
%             'Callback',cback,...
%             'Tag','hbpm',...
%             'Userdata',instructions,'Separator','on');

%         %Measure Horizontal
%         uimenu(mh.rsp,'Label','Measure Horizontal to BPMs (all valid correctors)',...
%             'Callback','corgui(''MeasureXResp'')');
        %==============
        %VERTICAL PLANE
        %==============
%         uimenu(mh.rsp,'Label','    ');
        %Select corrector currents for vertical response to eBPMs
%         cback = ['rload(''GenFig'', COR(2).name,COR(2).status,COR(2).ifit,COR(2).ebpm,'];
%         cback = [cback '''Vertical Correctors to Electron BPMs'',''vbpm'');'];
%         instructions = [...
%             '   global COR;',...
%             '   tlist = get(gcf,''UserData'');',...
%             '   COR(2).ebpm=tlist{4};',...
%             '   setappdata(0,''COR'',COR);'];
%         uimenu(mh.rsp,'Label','Select Z-corrector Strengths (BPM)',...
%             'Callback',cback,...
%             'Tag','vbpm',...
%             'Userdata',instructions,'Separator','on');
%         %Measure Vertical
%         uimenu(mh.rsp,'Label','Measure Vertical to BPMs (all valid correctors)',...
%             'Callback','corgui(''MeasureYResp'')');

        %==========================================================
    case 'UIControls'                           %  UIControls
        %==========================================================
        %pushbuttons located above main orbit display
        %other pushbuttons in routines OrbBox, CorBox

        [screen_wide, screen_high]=screensizecm;

        x0=0.047*screen_wide; y0=0.7318*screen_high; dx=0.74*screen_wide; dy=0.06378*screen_high;
        SYS.display = uicontrol('Style','frame',...
            'units', 'centimeters', ...
            'Position',[x0 y0 dx dy]);            %main frame

        x0=0.057*screen_wide; y0=0.739*screen_high; dx=0.117*screen_wide; dy=0.021*screen_high;
        dely=0.03*screen_high;   delx=0.15*screen_wide;

        uicontrol('Style','pushbutton',...
            'Units', 'centimeters', ...
            'Position', [x0+0*delx y0+1*dely dx dy], ...
            'String','Update Display','FontSize',9,'FontWeight','demi',...
            'ToolTipString','Update Measured Orbit (blue line)',...
            'Callback','bpmgui(''UpdateAct'')');     %Update Orbit
        uicontrol('Style','pushbutton',...
            'units', 'centimeters', ...
            'Position', [x0+0*delx y0+0*dely dx dy], ...
            'String','Update Reference','FontSize',9,'FontWeight','demi',...
            'ToolTipString','Update Reference Orbit, both planes (red line)',...
            'Callback','bpmgui(''UpdateRef'')');        %Update Reference Orbit

        if plane == 1, val=1; else val=0; end
        SYS.xplane=uicontrol('Style','checkbox',...
            'Units', 'centimeters', ...
            'Position', [0.25*screen_wide y0+1*dely 0.08*screen_wide dy], ...
            'String','Horizontal','Value',val,...
            'FontSize',9,'FontWeight','demi',...
            'ToolTipString','Horizontal Display and Control',...
            'Callback','orbgui(''Plane'')');  %Toggle Plane-Horizontal

        if plane == 2, val=1; else val=0; end
        SYS.yplane=uicontrol('Style','checkbox',...
            'Units', 'centimeters', ...
            'Position', [0.32*screen_wide y0+1*dely 0.08*screen_wide dy], ...
            'String','Vertical','Value',val,...
            'FontSize',9,'FontWeight','demi',...
            'ToolTipString','Vertical Display and Control',...
            'Callback','orbgui(''Plane'')');  %Toggle Plane-Vertical

        if SYS.relative==1, val=1; else val=0; end
        SYS.abs=uicontrol('Style','checkbox','units', 'centimeters', ...
            'Position', [0.25*screen_wide y0+0*dely 0.06*screen_wide dy], ...
            'String','Absolute','FontSize',9,'FontWeight','demi','Value',val,...
            'ToolTipString','Absolute BPM Display',...
            'Callback','orbgui(''Relative'')');   %Relative/Absolute-Absolute

        if SYS.relative==2, val=1; else val=0; end
        SYS.rel=uicontrol('Style','checkbox','units', 'centimeters', ...
            'Position', [0.32*screen_wide y0+0*dely 0.06*screen_wide dy], ...
            'String','Relative','FontSize',9,'FontWeight','demi','Value',val,...
            'ToolTipString','Relative BPM Display',...
            'Callback','orbgui(''Relative'')');   %Relative/Absolute-Relative

        uicontrol('Style','pushbutton',...
            'units', 'centimeters','ForeGroundColor','k',...
            'Position', [0.41*screen_wide 0.09*screen_high 0.45*dx dy], ...
            'String','Apply',...
            'ToolTipString','Apply Correction: Blue Dash Line = Predicted Orbit',...
            'FontSize',9,'FontWeight','demi',...
            'Callback','corgui(''ApplyCorrection'');');                  %Apply Correction

        uicontrol('Style','pushbutton',...
            'units', 'centimeters','ForeGroundColor','k',...
            'Position', [0.47*screen_wide 0.09*screen_high 0.45*dx dy], ...
            'String','Remove',...
            'ToolTipString','Remove Previous Corrector Solution',...
            'FontSize',9,'FontWeight','demi',...
            'Callback','corgui(''RemoveCorrection'');');                 %Remove Correction

        uicontrol('Style','pushbutton',...
            'units', 'centimeters','ForeGroundColor','k',...
            'Position', [0.41*screen_wide 0.06*screen_high 0.97*dx dy], ...
            'String','Refresh Fit',...
            'ToolTipString','Acquire Orbit, Correctors, Fit, Refresh all Plots & Fields',...
            'FontSize',9,'FontWeight','demi',...
            'Callback','orbgui(''RefreshOrbGUI'');');                    %Refresh Fit

        uicontrol('Style','pushbutton',...
            'units', 'centimeters', ...
            'Position', [x0+4*delx+0.53*dx        y0+1*dely 0.47*dx dy], ...
            'ForeGroundColor','k','String','Save',...
            'FontSize',9,'FontWeight','demi',...
            'ToolTipString','Save Set - Use to Save Present Working Parameters',...
            'Callback','orbgui(''SaveSet'');');      %SaveSet

        uicontrol('Style','pushbutton',...
            'units', 'centimeters', ...
            'Position', [x0+4*delx+0.53*dx        y0+0*dely 0.47*dx dy], ...
            'ForeGroundColor','k','String','Restore',...
            'FontSize',9,'FontWeight','demi',...
            'ToolTipString','Restore System to Save Set Parameters',...
            'Callback','orbgui(''RestoreSaveSet'');');     %RestoreSaveSet

        %% Scaling of the BPMs
            
        x0=0.788*screen_wide; dx=0.015*screen_wide; dy=0.031*screen_high; y0=0.583*screen_high;
        SYS.BPMScale=uicontrol('Style','slider','Units','centimeters',...
            'Position',[x0 y0 dx dy],'Callback','orbgui(''ScaleBPMAxis'');',...
            'Max',1,'Min',-1,'SliderStep',[5e-1 2e-1],'Value',0);

        SYS.BPMAutoScale=uicontrol('Style','pushbutton', ...
            'Units','centimeters',...
            'Position',[x0 y0 - 1.5  dx dy], ...
            'ForeGroundColor','k','String','A',...
            'FontSize',9,'FontWeight','demi',...
            'ToolTipString','Autoscales BPM axis',...
            'Callback','orbgui(''AutoScaleBPMAxis'');');  %autoscale
            

        %% Scaling of the correctors
        
        y0=0.355*screen_high;
        SYS.CORScale=uicontrol('Style','slider','Units','centimeters',...
            'Position',[x0 y0 dx dy],'Callback','orbgui(''ScaleCORAxis'');',...
            'Max',1,'Min',-1,'SliderStep',[5e-1 5e-1],'Value',0);

        SYS.BPMAutoScale=uicontrol('Style','pushbutton', ...
            'Units','centimeters',...
            'Position',[x0 y0 - 1.5  dx dy], ...
            'ForeGroundColor','k','String','A',...
            'FontSize',9,'FontWeight','demi',...
            'ToolTipString','Autoscales Corrector axis',...
            'Callback','orbgui(''AutoScaleCorrAxis'');');  %autoscale

        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'BPMbox'                               %  BPMbox
        %==========================================================
        %BPM Dialog Box
        %located at bottom of main frame
        [screen_wide, screen_high]=screensizecm;

        x0=0.013*screen_wide; dx=0.1640*screen_wide; y0=0.0158*screen_high; dy=0.17*screen_high;
        uicontrol('Style','frame','units', 'centimeters','Position',[x0 y0 dx dy]);     %main frame

        %Static BPM text fields (labels)
%         dx2=0.0888*screen_wide; 
        dy2=0.017*screen_high; dely=0.0175*screen_high;

        x0=0.7*screen_wide; dx=0.085*screen_wide; y0=0.705*screen_high;
        
        uicontrol('Style','Frame','Units','centimeters','Position', ...
            [x0-0.05 y0-0.05 dx+0.075 dy2+0.075]);  %frame around toggle

        SYS.togglebpm=uicontrol('Style','checkbox',...
            'units', 'centimeters', ...
            'Position',[x0 y0 dx dy2],...
            'String','Toggle BPMs',...
            'ToolTipString','Toggle BPMs between fit (green) and no-fit (yellow)',...
            'Callback','bpmgui(''ToggleMode'')');     %Radio BPM: Toggle Mode

        uicontrol('Style','Frame','Units','centimeters','Position', ...
            [x0-1.5*dx-0.05 y0-0.05 dx+0.075 dy2+0.075]);  %frame around drag

        SYS.dragbpm=uicontrol('Style','checkbox',...
            'units', 'centimeters', ...
            'Position', [x0 - 1.5*dx  y0 dx dy2], ...
            'String','Drag BPMs',...
            'ToolTipString','Enable BPMs for interactive drag',...
            'Callback','bpmgui(''DragMode'')');      %Radio BPM: Drag Mode


        x0=0.01856*screen_wide; dx=0.0576*screen_wide; y0=0.0247*screen_high; dy=0.01562*screen_high;
        uicontrol('Style','text',...
            'units', 'centimeters',...
            'Position',[x0 y0+1.7*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','BPM weight',...
            'String','Weight:');

        uicontrol('Style','text',...
            'units', 'centimeters',...
            'Position',[x0 y0+2.7*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Predicted Orbit (blue dash line value at BPM site)',...
            'String','Prediction:');

        uicontrol('Style','text',...
            'units', 'centimeters',...
            'Position',[x0 y0+3.7*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Requested orbit (BPM icon value at BPM site)',...
            'String','Desired:');

        uicontrol('Style','text',...
            'units', 'centimeters',...
            'Position',[x0 y0+4.7*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Offset from BPM icon to red line at BPM site',...
            'String','Offset:');

        uicontrol('Style','text',...
            'units', 'centimeters',...
            'Position',[x0 y0+6*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Reference orbit (red line value at BPM site)',...
            'String','Reference:');

        uicontrol('Style','text',...
            'units', 'centimeters',...
            'Position',[x0 y0+7*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Measured orbit (blue line value at BPM site)',...
            'String','Measured:');

        uicontrol('Style','text',...
            'units', 'centimeters',...
            'Position',[x0 y0+8*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Selected BPM name',...
            'String','BPM Name:');

        %Dynamic BPM text fields (data)
        x0 = 0.09647*screen_wide; dx=0.075*screen_wide; %0.065
        y0 = 0.0247*screen_high; dy=0.0156*screen_high;
%         dx2 = 0.00037*screen_wide; 
        dely=0.0175*screen_high;

        SYS.bpmmeas =uicontrol('Style','text',...
            'units', 'centimeters',...
            'Position',[x0 y0+2.7*dely dx dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'String','');                 %BPMmeas

        SYS.bpmdes=uicontrol('Style','text',...
            'units', 'centimeters',...
            'Position',[x0 y0+3.7*dely dx dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'String','');                 %BPMdes

        %offset edit box
        SYS.bpmedit=uicontrol('Style','edit',...
            'units', 'centimeters',...
            'Position',[x0 y0+4.7*dely dx 1.2*dy],...
            'FontName','times','FontSize',8,...
            'Callback','bpmgui(''EditDesOrb'')',...
            'String','');                 %EditDesOrb

        SYS.editbpmweight=uicontrol('Style','edit',...
            'units', 'centimeters',...
            'Position',[x0 y0+1.7*dely dx 1.2*dy],...
            'FontName','times','FontSize',8,...
            'Callback','bpmgui(''EditBPMWeight'')',...
            'String','');                 %EditBPMWeight

        SYS.bpmref=uicontrol('Style','text',...
            'units', 'centimeters',...
            'Position',[x0 y0+6*dely dx dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'String','');                 %BPMref


        SYS.bpmact=uicontrol('Style','text',...
            'units', 'centimeters',...
            'Position',[x0 y0+7*dely dx dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'String','');                 %BPMact

        SYS.bpmname=uicontrol('Style','text',...
            'units', 'centimeters',...
            'Position',[x0 y0+8*dely dx dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'String','');                 %bpmname

        %RMS Display
        x0=0.1*screen_wide; dx=0.035*screen_wide; y0=0.705*screen_high; dy=0.0175*screen_high;

        uicontrol('Style','frame','Units','centimeters','Position', ...
            [x0-0.025 y0-0.025 2.2*dx+0.05 dy+0.05]); %frame around RMS

        uicontrol('Style','text',...
            'Units','centimeters',...
            'Position',[x0 y0 dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','RMS deviation of actual orbit from desired orbit',...
            'String',' rms:');  %Display RMS static

        x0 = 0.135*screen_wide; dx = 0.04*screen_wide;
        SYS.bpmrms = uicontrol('Style','text',...
            'units','centimeters',...
            'Position',[x0 y0 dx dy],...
            'String','');       %RMS dynamic

        x0=0.23*screen_wide; dx=0.035*screen_wide; y0=0.705*screen_high; dy=0.0175*screen_high;

        uicontrol('Style','frame','Units','centimeters','Position', ...
            [x0-0.025 y0-0.025 2.4*dx+0.05 dy+0.05]); %frame around mean

        uicontrol('Style','text',...
            'Units','centimeters',...
            'Position',[x0 y0 dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Mean deviation of actual orbit from desired orbit',...
            'String',' mean:');    %Display mean static

        x0 = 0.27*screen_wide; dx = 0.04*screen_wide;
        SYS.bpmmean = uicontrol('Style','text',...
            'units','centimeters',...
            'Position',[x0 y0 dx dy],...
            'String',''); %mean dynamic

        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'CorBox'                      % *** CorrectBox ***
        %==========================================================
        %frame for corrector uicontrols
        %located at bottom of main frame
        [screen_wide, screen_high]=screensizecm;

        x0 = 0.2*screen_wide; dx=0.1650*screen_wide; 
        y0=0.016*screen_high; dy=0.17*screen_high;
        uicontrol('Style','frame','Units','centimeters','Position',[x0 y0 dx dy]);  %main frame

        %Static Corrector text fields (labels)
        x0=0.21*screen_wide;
        dx=0.06*screen_wide; y0=0.025*screen_high; dy=0.015*screen_high;
        dx2=0.1*screen_wide; dely=0.0175*screen_high;
        %dy2=0.017*screen_high;

        %% Construction from bottom to up
        uicontrol('Style','pushbutton',...	            %Restore Correctors
            'Units','centimeters',...
            'Position',[1.2*x0 y0+0*dely dx2 dy],...
            'ForeGroundColor','k',...
            'String','Restore Correctors',...
            'ToolTipString','Restore corrector strengths in active plane',...
            'Callback','corgui(''RestoreCors'');');   %Restore Correctors

        uicontrol('Style','pushbutton',...	           %Save Correctors
            'Units','centimeters',...
            'Position',[1.2*x0 y0+1.0*dely dx2 dy],...
            'ForeGroundColor','k',...
            'String','Save Correctors',...
            'ToolTipString','Save corrector strengths in active plane',...
            'Callback','corgui(''SaveCors'',SYS.plane);');   %save correctors for bump generation and restore

       %display rf offset
        SYS.rftoggle = uicontrol('Style','radio',...
            'units', 'centimeters', ...
            'Position', [x0-dy*0.5 y0+dely 0.6*dx 1.2*dy], ...
            'Callback','respgui(''RFToggle'')','Value',0,...
            'ToolTipString','Toggle fitting for RF orbit component', ...
            'String','RF');
        
%         uicontrol('Style','pushbutton',...	            %MakeOrbitSlider
%             'Units','centimeters',...
%             'Position',[1.1*x0 y0+0.4*dely dx2 dy],...
%             'ForeGroundColor','k',...
%             'String','Make Slider',...
%             'ToolTipString','Create Orbit Slider/Save File to Disk',...
%             'Callback','corgui(''MakeOrbitSlider'');'); %MakeOrbitSlider
        
        uicontrol('Style','text',...
            'Units','centimeters',...
            'Position',[x0 y0+2*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','RF value updated if RF correction',...
            'String','rf (MHz):');

        uicontrol('Style','text',...
            'Units','centimeters',...
            'Position',[x0 y0+3*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','RF shift if correction',...
            'String','drf (MHz):');

        uicontrol('Style','text',...
            'Units','centimeters',...
            'Position',[x0 y0+4*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Requested corrector strength (red bar at corrector site)',...
            'String','Desired:');

        uicontrol('Style','text',...
            'Units','centimeters',...
            'Position',[x0 y0+5*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Incremental corrector strength (red bar - green bar)',...
            'String','Fit Increment:');

        uicontrol('Style','text',...
            'Units','centimeters',...
            'Position',[x0 y0+6*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Saved corrector value',...
            'String','Reference:');

        uicontrol('Style','text',...
            'Units','centimeters',...
            'Position',[x0 y0+7*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Measured corrector value (green/yellow bar at corrector site)',...
            'String','Measured:');

       uicontrol('Style','text',...
            'Units','centimeters',...
            'Position',[x0 y0+8*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Selected corrector name',...
            'String','Corr Name:');
         

        %Dynamic corrector text fields (data)
        x0=0.28*screen_wide; dx=0.075*screen_wide; %0.065

        SYS.hrf=uicontrol('Style','text',...
            'units','centimeters',...
            'Position',[x0 y0+2*dely dx dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'String','');                 %CORreq

        SYS.hdrf=uicontrol('Style','text',...
            'units','centimeters',...
            'Position',[x0 y0+3*dely dx dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'String','');                 %CORreq

        SYS.correq=uicontrol('Style','text',...
            'units','centimeters',...
            'Position',[x0 y0+4*dely dx dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'String','');                 %CORreq

        SYS.coroffset=uicontrol('Style','text',...
            'units','centimeters',...
            'Position',[x0 y0+5*dely dx dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'String','');                 %CORoffset

        SYS.corref=uicontrol('Style','text',...
            'units','centimeters',...
            'Position',[x0 y0+6*dely dx dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'String','');                 %CORref

        SYS.coract=uicontrol('Style','text',...
            'units','centimeters',...
            'Position',[x0 y0+7*dely dx dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'String','');                 %CORact

        SYS.corname=uicontrol('Style','text',...
            'units','centimeters',...
            'Position',[x0 y0+8*dely dx dy],...
            'BackGroundColor',[0.77 0.91 1.00],...
            'String','');               %CORname

        x0=0.7*screen_wide; dx=0.07*screen_wide; y0=0.445*screen_high; dy=0.0175*screen_high;
        uicontrol('Style','Frame','Units','centimeters','Position', ...
            [x0-0.05 y0-0.05 dx+0.075 dy+0.075]);  %frame

        SYS.togglecor=uicontrol('Style','checkbox','units', 'centimeters','Position', [x0 y0 dx dy],...
            'String','Toggle Corrs',...
            'ToolTipString','Toggle correctors for fit (green)/nofit (yellow)',...
            'Callback','corgui(''ToggleCor'')');        %Radio Corr: Toggle


        %RMS Display
        x0=0.055*screen_wide; dx=0.035*screen_wide;
        uicontrol('Style','frame','Units','centimeters','Position', ...
            [x0-0.025 y0-0.025 2.2*dx+0.05 dy+0.05]); %frame around RMS

        uicontrol('Style','text','Units','centimeters','Position',[x0 y0 dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','RMS value of correctors used for fit',...
            'String',' rms:');                          %rms static

        SYS.corrms = uicontrol('Style','text','units','centimeters', ...
            'Position',[x0+dx y0 dx dy],'String','');   %rms dynamic

        %Mean Display
        x0=0.16*screen_wide; dx=0.035*screen_wide;
        uicontrol('Style','frame','Units','centimeters','Position', ...
            [x0-0.025 y0-0.025 2.4*dx+0.05 dy+0.05]); %frame around mean

        uicontrol('Style','text','Units','centimeters','Position',[x0 y0 dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','RMS value of correctors used for fit',...
            'String',' mean:');                          %mean static

        SYS.cormean = uicontrol('Style','text','units','centimeters', ...
            'Position',[x0+dx y0 dx dy],'String','');   %mean dynamic
        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'SVDBox'                               %  SVDBox
        %==========================================================
        %SVD Dialog Box
        %located at bottom of main frame
        [screen_wide, screen_high] = screensizecm;

        x0=0.385*screen_wide; dx=0.16*screen_wide; 
        y0=0.0158*screen_high; dy=0.17*screen_high;

        uicontrol('Style','frame','Units','centimeters','Position',[x0 y0 dx dy]);     %main frame

        x0=0.39*screen_wide; dx=0.09375*screen_wide; 
        y0=0.018*screen_high; dy=0.02*screen_high;
%         dy2=0.022*screen_high; 
        dely=0.02353*screen_high;

        uicontrol('Style','text',...
            'units','centimeters',...
            'Position',[x0 y0+6*dely dx dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Choose number of singular values for fit',...
            'String','# Singular Values:');

        uicontrol('Style','text',...
            'units','centimeters',...
            'Position',[x0 y0+5*dely dx*1.2 dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Fractional multiplier applied to all correctors (but not shown in fit)',...
            'String','Fraction of Correction:');


        x0 = 0.50*screen_wide; dx=0.032*screen_wide;
        default_nsvd = 56;
        % Edit box for number of singular values
        SYS.svdedit = uicontrol('Style','edit',...
            'Units','centimeters',...
            'Position',[x0+dx/2 y0+6*dely dx/1.5 dy],...
            'Callback','respgui(''SVDEdit'');',...
            'String',num2str(default_nsvd));   %default to one singular value

        %Slider for number of singlar values  see %matlab help/slider
%         SYS.svdslide=uicontrol('Style','slider',...
%             'Units','centimeters',...
%             'Position',[x0-dx/2 y0+6*dely dx/1.2 dy],...
%             'Callback','respgui(''SVDSlider'');',...
%             'Max',default_nsvd,'Min',1,...
%             'SliderStep',[1/(default_nsvd-1),1/(default_nsvd-1)],...
%             'Value',round(default_nsvd/2));

        %Edit box for fraction of correction
        SYS.fract=uicontrol('Style','edit',...
            'Units','centimeters',...
            'Position',[x0+dx/2 y0+5*dely dx/1.5 dy],...
            'Callback','corgui(''Fract'');',...
            'String',num2str(1));

        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'KnobBox'                               %  KnobBox
        %==========================================================

        [screen_wide, screen_high]=screensizecm;

        x0=0.4170*screen_wide; y0=0.006*screen_high;
        dy=0.021*screen_high; dely=0.02353*screen_high;

        dx=0.14*screen_wide;
        SYS.addignknob=uicontrol('Style','pushbutton',...
            'Units','centimeters',...
            'Position',[x0 y0+3*dely dx dy],...
            'ForeGroundColor','k',...
            'String','Assign Knob',...
            'ToolTipString','Save knob corrector strengths in active plane',...
            'Callback','corgui(''AssignKnob'');');   %Assign Knob

        uicontrol('Style','text',...
            'units','centimeters',...
            'Position',[1.03*x0 y0+1.8*dely dx/2 dy],...
            'HorizontalAlignment','left',...
            'ToolTipString','Edit corrector knob strength',...
            'String','Knob Amplitude:');

        SYS.knobedit=uicontrol('Style','edit',...
            'Units','centimeters',...
            'Position',[1.25*x0 y0+1.9*dely dx/5 dy],...
            'Callback','corgui(''KnobEdit'');',...
            'String',num2str(0));

        setappdata(0,'SYS',SYS);

        %=============================================================
    case 'Plane'                             % *** Plane ***
        %=============================================================
        %Toggle the x/y fitting displays
        corgui('HidePlots');        %Note: separate handles for corrector icons in each plane
        %hide existing icons before switching planes (visible/off)

        if  get(SYS.xplane,'Value')==0 && SYS.plane==1     %was in horizontal mode, stay in horizontal
            set(SYS.xplane,'Value',1);
        elseif get(SYS.yplane,'Value')==0 && SYS.plane==2     %%was in vertical mode, stay in vertical
            set(SYS.yplane,'Value',1);
        elseif get(SYS.yplane,'Value')==1 && SYS.plane==1     %%was in horizontal mode, switch to vertical
            SYS.plane=2;           %horizontal
            set(SYS.xplane,'Value',0);
        elseif get(SYS.xplane,'Value')==1 && SYS.plane==2     %%was in vertical mode, switch to horizontal
            SYS.plane=1;           %horizontal
            set(SYS.yplane,'Value',0);
        end

        setappdata(0,'SYS',SYS);

        if RSP(2).rfflag  % disable RF correction for vertical plane
            respgui('RFToggle');            
        end

        corgui('ShowPlots');        %visible/on
        orbgui('RefreshOrbGUI');

        %=============================================================
    case 'TogglePlane'                       % *** TogglePlane ***
        %=============================================================
        %Toggle plane flag
        SYS.plane=1+mod(SYS.plane,2);
        setappdata(0,'SYS',SYS);

        %=============================================================
    case 'RefreshOrbGUI'                   % *** RefreshOrbGUI ***
        %=============================================================

        respgui('SolveSystem');    %75 ms in simulator
        respgui('UpdateFit');

        %disp('update fields');    %15 ms in simulator
        %Set Defaults
        set(SYS.togglebpm,'Value',0);        %default to display only
        set(SYS.dragbpm,  'Value',0);        %default to no drag
        set(SYS.togglecor,'Value',0);        %default to no toggle
        set(SYS.showresp, 'Checked', 'Off'); %default to no resp display
        set(SYS.showeig,  'Checked', 'Off'); %default to no eig display
       
        %default to no rf orbit subtraction
        set(SYS.rftoggle, 'Value', 0);
        set(SYS.hdrf,'String', '0.0');
        set(SYS.fract,'String', num2str(COR(plane).fract));
        
        %re-write text fields
        if BPM(plane).mode == 1, set(SYS.togglebpm,'Value',1); end;     %toggle
        if BPM(plane).mode == 2, set(SYS.dragbpm,'Value',1); end;       %drag
        if COR(plane).mode == 1, set(SYS.togglecor,'Value',1); end;     %toggle
        if strcmpi(RSP(plane).disp(1:2),'on'), set(SYS.showresp,'Checked', 'on'); end;
        if strcmpi(RSP(plane).eig(1:2),'on'), set(SYS.showeig, 'Checked', 'on'); end;
        if RSP(plane).rfflag  == 1 % RF part 
            set(SYS.rftoggle,'Value',1);
            set(SYS.hdrf,'String', num2str(SYS.drf)); 
        end;

        %units for bpm and corrector plot abscissa
        if strcmp(SYS.xscale,'meter')
            SYS.xlimax = SYS.maxs;
        elseif strcmp(SYS.xscale,'phase')
            SYS.xlimax = SYS.maxphi(plane);
        end

        setappdata(0,'SYS',SYS);

        %Update BPM Displays (100 ms in simulator)
        bpmgui('ClearPlots');            %remove eigenvector, response and fit plots
        if BPM(plane).scalemode == 0     %manual
            set(SYS.ahbpm,'YLim',[-BPM(plane).ylim,BPM(plane).ylim]);
        end
        bpmgui('RePlot');                %ref, des, act, fit, icons, limits, bar
        bpmgui('UpdateBPMBox');

        %Update Corrector Displays (100 ms in simulator)
        if COR(plane).scalemode == 0     %manual
            set(SYS.ahcor,'YLim',[-COR(plane).ylim,COR(plane).ylim]);   end
        corgui('RePlot');                %clear, actual, fit, bar, limits
        corgui('UpdateCorBox');

        switch SYS.algo
            case 'SVD'
                %Update SVD Displays
                respgui('PlotSVD');
                set(SYS.svdedit,'String',num2str(RSP(plane).nsvd));

%                 %slider_step=[arrow_step, trough_step] normalized to range
%                 if RSP(plane).nsvdmax > 1
%                     slider_step = [1/(RSP(plane).nsvdmax-1),1/(RSP(plane).nsvdmax-1)];
%                     set(SYS.svdslide,'Visible','On','Value',RSP(plane).nsvd,'Max',RSP(plane).nsvdmax,'Min',1,'SliderStep',slider_step);
%                     set(SYS.svdedit,'Value',RSP(plane).nsvd);
%                 else
%                     set(SYS.svdslide,'Visible','Off');
%                 end

        end   %end algo case

        orbgui('UpdateParameters');

        orbgui('LBox',' Finished acquisition and display refresh');

        %=============================================================
    case 'Relative'                             % *** Relative ***
        %=============================================================
        %Toggles orbit display absolute/relative
        %If reference orbit read from file then subtract
        %Otherwise reference orbit is zero

        if  get(SYS.abs,'Value') == 0 && SYS.relative == 1     %was in absolute mode, stay in absolute
            set(SYS.abs,'Value',1);
        elseif get(SYS.rel,'Value') == 0 && SYS.relative == 2  %was in relative mode, stay in relative
            set(SYS.rel,'Value',1);
        elseif get(SYS.rel,'Value') == 1 && SYS.relative == 1  %was in absolute mode, switch to relative
            SYS.relative = 2;           %relative mode
            set(SYS.abs,'Value',0);
            BPM(1).abs = BPM(1).ref;    %BPM.act and BPM.des have BPM.abs subtracted off at plot time
            BPM(2).abs = BPM(2).ref;
        elseif get(SYS.abs,'Value') == 1 && SYS.relative == 2  %was in relative mode, switch to absolute
            SYS.relative = 1;           %absolute mode
            set(SYS.rel,'Value',0);
            BPM(1).abs = zeros(size(BPM(1).name,1),1);
            BPM(2).abs = zeros(size(BPM(2).name,1),1);
        end

        setappdata(0,'SYS',SYS);
        setappdata(0,'BPM',BPM);

        bpmgui('RePlot');     %do not replot correctors for relative
        bpmgui('BPMBar');
        bpmgui('UpdateBPMBox');
        
        %==========================================================
    case 'Abort'                                % *** Abort ***
        %==========================================================
        %callback of corrector menu
        %in case user aborts response matrix measurement or feedback
        SYS.abort = 1;
        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'ScaleBPMAxis'                  % *** ScaleBPMAxis ***
        %==========================================================
        axes(SYS.ahbpm);
        a = axis;
        ChangeFactor = 2;
        
        if get(SYS.BPMScale,'Value') < 0
            del = (ChangeFactor-1)*(a(4)-a(3));
        else
            del = (1/ChangeFactor-1)*(a(4)-a(3));
        end
        axis([a(1) a(2) a(3)-del/2 a(4)+del/2]);
        set(SYS.BPMScale, 'Value', 0);

        BPM(plane).ylim = a(4)+del/2;
        setappdata(0,'BPM',BPM);

        %rescale BPMBar
        yd = [-BPM(plane).ylim/4,BPM(plane).ylim/4];
        set(SYS.lhbid,'YData',yd);

        %==========================================================
    case 'AutoScaleBPMAxis'   %  Autoscale BPMaxis
        %==========================================================
        
        % switchoff black cross
        set(SYS.lhbid,'XData',[],'YData',[]);
        
        % Auto-scale y-axis of BPM plot
        val0 = axis(SYS.ahbpm);
        axis(SYS.ahbpm, 'tight');
        val  = axis(SYS.ahbpm);
        BPM(plane).ylim = max(abs(val(3:4)))*1.2;
        axis(SYS.ahbpm, [val0(1:2) BPM(plane).ylim*[-1 1]]);
        setappdata(0,'BPM',BPM);
        
        % Set back black cross in the BPM window
        bpmgui('BPMBar');
        
        %==================================================================
    case 'AutoScaleCorrAxis'                  % *** AutoScaleCORAxis ***
        %==================================================================
        
        % switchoff black cross
        set(SYS.lhcid,'XData',[],'YData',[]);
       
        % Auto-scale y-axis of COR plot
        val0 = axis(SYS.ahcor);
        axis(SYS.ahcor, 'tight');
        val  = axis(SYS.ahcor);
        COR(plane).ylim = max(abs(val(3:4)))*1.2;
        axis(SYS.ahcor, [val0(1:2) COR(plane).ylim*[-1 1]]);
        setappdata(0,'COR',COR);
         
        % Set back black cross in the BPM window
        corgui('CorBar');
       
        %==========================================================
    case 'ScaleCORAxis'                  % *** ScaleCORAxis ***
        %==========================================================
        axes(SYS.ahcor);
        a = axis;
        ChangeFactor = 2;
        
        if get(SYS.CORScale,'Value') < 0
            del = (ChangeFactor-1)*(a(4)-a(3));
        else
            del = (1/ChangeFactor-1)*(a(4)-a(3));
        end
        
        axis([a(1) a(2) a(3)-del/2 a(4)+del/2]);
        set(SYS.CORScale, 'Value', 0);

        COR(plane).ylim = a(4)+del/2;
        setappdata(0,'COR',COR);

        %rescale CORBar
        yd = [-COR(plane).ylim/4, COR(plane).ylim/4];
        set(SYS.lhcid,'YData',yd);

        %===========================================================
%     case 'StartLoc'              %*** StartLoc ***
%         %===========================================================
%         %cross cursor to select a new start location on Z axis.
%         %must put bpms into 'Select' mode (display only) so
%         %bpm nearest cursor will not get toggled or dragged
%         %NOTE: tried setting mode to zero and then reset after sizing plot but still toggles bpm state.
% 
%         mode=BPM(plane).mode;     %save mode for after NewStart
%         BPM(plane).mode=0;        %put in select mode
%         setappdata(0,'BPM',BPM);
% 
%         set(orbfig,'Pointer','fullcross',...
%             'WindowButtonDownFcn','orbgui(''NewStart'')');
%         BPM(plane).mode=mode;     %restore mode
%         setappdata(0,'BPM',BPM);
% 
%         %===========================================================
%     case 'NewStart'              %*** NewStart ***
%         %===========================================================
%         %sets the current cursor position as the new Start Location of the plot.
%         cpa = get(SYS.ahbpm,'CurrentPoint');
%         limits = get(SYS.ahbpm,'XLim');
%         set(SYS.ahbpm,'XLim',[cpa(1,1) limits(1,2)]);   %Change start, leave stop alone
%         set(SYS.ahcor,'XLim',[cpa(1,1) limits(1,2)]);   %Change start, leave stop alone
%         set(orbfig, 'Pointer','arrow',...
%             'WindowButtonDownFcn','');
% 
%         %===========================================================
%     case 'StopLoc'              %*** StopLoc ***
%         %===========================================================
%         %creates a cross cursor for the user to select a new stopping location on Z axis.
%         mode=BPM(plane).mode;     %save mode for after NewStart
%         BPM(plane).mode=0;        %put in select mode
%         setappdata(0,'BPM',BPM);
% 
%         set(orbfig,'Pointer','fullcross',...
%             'WindowButtonDownFcn','orbgui(''NewStop'')');
%         BPM(plane).mode=mode;     %restore mode
%         setappdata(0,'BPM',BPM);
% 
%         %===========================================================
%     case 'NewStop'              %*** NewStop ***
%         %===========================================================
%         %set the current cursor position as the new Stop Location of the plot.
%         cpa = get(SYS.ahbpm,'CurrentPoint');
%         limits = get(SYS.ahbpm,'XLim');
%         set(SYS.ahbpm,'XLim',[limits(1,1) cpa(1,1)]);    %Change stop, leave start alone
%         set(SYS.ahcor,'XLim',[limits(1,1) cpa(1,1)]);    %Change stop, leave start alone
%         set(orbfig, 'Pointer','arrow',...
%             'WindowButtonDownFcn','');
% 
        %===========================================================
    case 'BPMPlotScale'                    %*** BPMPlotScale ***
        %===========================================================
        %Select vertical limit for BPM plot

        %Clear previous  figure
        bpmscalefig = findobj(0,'tag','bpmplotscale');
        if ~isempty(bpmscalefig), delete(bpmscalefig); end

        figure('Position',[600 600 400 200],...
            'NumberTitle','off',...
            'Name','BPM Plot Control',...
            'Tag','bpmplotscale',...
            'MenuBar','none');

        val=0;
        if BPM(plane).scalemode==0; val=1; end              %manual
        uicontrol('Style','radio',...
            'Position',[20 150 120 20],...
            'String','Manual Scale',...
            'Tag','bpmmanual',...
            'Value',val,...
            'ToolTipString','BPM plot scale Manual',...
            'Callback','orbgui(''BPMScaleType'', ''0'')');

        uicontrol('Style','text',...
            'String','Vertical Axis Limit: ','HorizontalAlignment','left',...
            'Position',[150 150 100 20]);

        uicontrol('Style','edit',...
            'tag','bpmscale',...
            'String',num2str(BPM(plane).ylim),'HorizontalAlignment','left',...
            'Position',[250 150 50 20]);


        val=0;
        if BPM(plane).scalemode==1; val=1; end              %auto
        uicontrol('Style','radio',...
            'Position',[20 120 120 20],...
            'String','Auto Scale','HorizontalAlignment','left',...
            'Tag','bpmauto',...
            'Value',val,...
            'ToolTipString','BPM plot scale Auto',...
            'Callback','orbgui(''BPMScaleType'', ''1'')');

        val=0;
        if strcmp(SYS.xscale,'meter'); val=1; end           %s-position
        uicontrol('Style','radio',...
            'Position',[20 90 150 20],...
            'String','Plot vs. s-position',...
            'Tag','plotspos',...
            'Value',val,...
            'ToolTipString','Plot BPM vs. the s-position',...
            'Callback','orbgui(''PlotSPosition'')');

        val=0;
        if strcmp(SYS.xscale,'phase'); val=1; end          %betatron phase
        uicontrol('Style','radio',...
            'Position',[20 60 150 20],...
            'String','Plot vs. Phase',...
            'Tag','plotphase',...
            'Value',val,...
            'ToolTipString','Plot BPMs vs. the phase',...
            'Callback','orbgui(''PlotPhase'')');

        uicontrol('Style','pushbutton',...                  %apply
            'String','Apply',...
            'Position',[150 20 50 20],...
            'Callback','orbgui(''ProcessBPMScale'');');

        uicontrol('Style','pushbutton',...                  %cancel
            'String','Cancel',...
            'Callback','delete(gcf)',...
            'Position',[210 20 50 20]);

        %===========================================================
    case 'ProcessBPMScale'              %*** ProcessBPMScale ***
        %===========================================================
        %select vertical limits for BPM axis (symetric limits)

        h    = findobj(0,'Tag','bpmscale');
        ylim = str2double(get(h,'String'));

        if isempty(ylim)
            ylim = BPM(plane).ylim;
        end

        hmanual = findobj(0,'Tag','bpmmanual');
        set(h,'Value',1);
        hauto = findobj(0,'Tag','bpmauto');
        
        if BPM(plane).scalemode == 0  %manual mode
            BPM(plane).ylim = ylim;

            set(SYS.ahbpm,'YLim', ylim*[-1, 1]);

            set(hmanual,'Value',1);
            set(hauto,'Value',0);
        else                        %auto mode
            BPM(plane).ylim = ylim;

            set(hmanual,'Value',0);
            set(hauto,'Value',1);
        end

        setappdata(0,'BPM',BPM);

        bpmgui('BPMBar');

        delete(gcf);


        %===========================================================
    case 'PlotSPosition'                    %*** PlotSPosition ***
        %===========================================================
        %plot BPMs and correctors in terms of s-position
        h1 = findobj(0,'tag','plotspos');
        h2 = findobj(0,'tag','plotphase');

        if get(h1,'Value') == 0 && get(h2,'Value') == 0   %...default to meters
            set(h2,'Value',1);
            SYS.xscale = 'phase';
            SYS.xlimax = SYS.maxphi(plane);
            set(get(SYS.ahcor,'Xlabel'),'string','Betatron Phase (rad/(2pi))');
        else
            SYS.xscale = 'meter';
            set(h1,'Value',1);
            set(h2,'Value',0);
            SYS.xlimax = SYS.maxs;
            set(get(SYS.ahcor,'Xlabel'),'string','Position in Storage Ring (m)');
        end

        setappdata(0,'SYS',SYS);

        h  = allchild(get(SYS.allmachine,'Parent'));
        id = strcmpi(get(h,'Checked'),'on');
        orbgui('plotxaxis',get(h(id),'Tag'));
        
        bpmgui('RePlot');
        corgui('RePlot');

        %===========================================================
    case 'PlotPhase'                    %*** PlotPhase ***
        %===========================================================
        %plot BPMs and correctors in terms of phase
        h1 = findobj(0,'tag','plotspos');
        h2 = findobj(0,'tag','plotphase');

        if get(h1,'Value') == 0 && get(h2,'Value') == 0   %...default to meters
            set(h1,'Value',1);
            SYS.xscale = 'meter';
            SYS.xlimax = SYS.maxs;
            set(get(SYS.ahcor,'Xlabel'),'string','Position in Storage Ring (m)');
        else % Phase
            SYS.xscale = 'phase';
            set(h1,'Value',0);
            set(h2,'Value',1);
            SYS.xlimax   = SYS.maxphi(plane);
            set(get(SYS.ahcor,'Xlabel'),'string','Betatron Phase (rad)');
        end
        
        setappdata(0,'SYS',SYS);

        h  = allchild(get(SYS.allmachine,'Parent'));
        id = strcmpi(get(h,'Checked'),'on');
        orbgui('plotxaxis',get(h(id),'Tag'));
        
        bpmgui('RePlot');
        corgui('RePlot');

        %===========================================================
    case 'BPMScaleType'                    %*** BPMScaleType ***
        %===========================================================
        %toggle to manual mode for BPM vertical axis
        stype = str2double(varargin{1});    % stype=0 for manual,   stype=1 for auto

        %presently in manual mode, toggle to auto
        if (BPM(plane).scalemode == 0 && stype==0) ||...
                (BPM(plane).scalemode==0 && stype==1)
            h=findobj(0,'Tag','bpmmanual');
            set(h,'Value',0);
            h=findobj(0,'Tag','bpmauto');
            set(h,'Value',1);
            BPM(plane).scalemode = 1;
            setappdata(0,'BPM',BPM);
            bpmgui('ylimits');
            bpmgui('RePlot');
            return
        end

        %presently in auto mode, toggle to manual
        if (BPM(plane).scalemode==1 && stype==0) ||...
                (BPM(plane).scalemode==1 && stype==1)
            h=findobj(0,'Tag','bpmmanual');
            set(h,'Value',1);
            h=findobj(0,'Tag','bpmauto');
            set(h,'Value',0);
            BPM(plane).scalemode=0;
            setappdata(0,'BPM',BPM);
            ylim=BPM(plane).ylim;
            set(SYS.ahbpm,'YLim',[-ylim,ylim]);
            bpmgui('RePlot');
            return
        end

        %===========================================================
    case 'CorPlotScale'                    %*** CorPlotScale ***
        %===========================================================
        %Select vertical limit for Corrector plot

        %Clear previous  figure
        corscalefig = findobj(0,'tag','corplotscale');
        if ~isempty(corscalefig), delete(corscalefig); end

        figure('Position',[600 600 400 200],...
            'NumberTitle','off','Tag','corplotscale',...
            'Name','COR Vertical Axis Limits',...
            'MenuBar','none');

        val = 0;
        if COR(plane).scalemode == 0, val = 1; end   %manual
        uicontrol('Style','radio',...
            'Position',[20 150 120 20],...
            'String','Manual Scale',...
            'Tag','cormanual',...
            'Value',val,...
            'ToolTipString','Corrector plot scale Manual',...
            'Callback','orbgui(''CORScaleType'', ''0'')');

        val = 0;
        if COR(plane).scalemode == 1, val = 1; end
        uicontrol('Style','radio',...
            'Position',[20 120 120 20],...
            'String','Auto Scale','HorizontalAlignment','left',...
            'Tag','corauto',...
            'Value',val,...
            'ToolTipString','Corrector plot scale Auto',...
            'Callback','orbgui(''CORScaleType'', ''1'')');     %auto

        uicontrol('Style','text',...
            'String','Vertical Axis Limit: ','HorizontalAlignment','left',...
            'Position',[150 150 100 20]);

        uicontrol('Style','edit',...
            'tag','corscale',...
            'String',num2str(COR(plane).ylim),'HorizontalAlignment','left',...
            'Position',[250 150 50 20]);

        uicontrol('Style','pushbutton',...                    %apply
            'String','Apply',...
            'Position',[150 20 50 20],...
            'Callback','orbgui(''ProcessCORScale'');');

        uicontrol('Style','pushbutton',...                    %cancel
            'String','Cancel',...
            'Callback','delete(gcf)',...
            'Position',[210 20 50 20]);

        %===========================================================
    case 'CORScaleType'                    %*** CORScaleType ***
        %===========================================================
        %toggle to manual mode for COR vertical axis        
        
        % stype=0 for manual, stype=1 for auto
        stype = str2double(varargin{1});    

        hmanual = findobj(0,'Tag','cormanual');
        hauto   = findobj(0,'Tag','corauto');

        %presently in manual mode, toggle to auto
        if (COR(plane).scalemode == 0 && stype == 0) ||...
                (COR(plane).scalemode == 0 && stype == 1)
            set(hmanual,'Value',0);
            set(hauto,  'Value',1);
            COR(plane).scalemode=1;
            setappdata(0,'COR',COR);
            corgui('ylimits');
            corgui('RePlot');
            return
        end

        %presently in auto mode, toggle to manual
        if (COR(plane).scalemode==1 && stype==0) ||...
                (COR(plane).scalemode==1 && stype==1)
            set(hmanual,'Value',1);
            set(hauto,'Value',0);
            COR(plane).scalemode=0;
            setappdata(0,'COR',COR);
            ylim=COR(plane).ylim;
            set(SYS.ahcor,'YLim',[-ylim,ylim]);
            corgui('RePlot');
            return
        end

        %===========================================================
    case 'ProcessCORScale'              %*** ProcessCORScale ***
        %===========================================================
        h = findobj(0,'Tag','corscale');
        ylim = str2double(get(h,'String'));
        if isempty(ylim), ylim = COR(plane).ylim; end

        if COR(plane).scalemode == 0  %manual mode
            COR(plane).ylim=ylim;
            setappdata(0,'COR',COR);
            set(SYS.ahcor,'YLim',[-ylim,ylim]);

            h=findobj(0,'Tag','cormanual');
            set(h,'Value',1);
            h=findobj(0,'Tag','corauto');
            set(h,'Value',0);


        else                        %auto mode
            COR(plane).ylim=ylim;
            setappdata(0,'COR',COR);
            h=findobj(0,'Tag','cormanual');
            set(h,'Value',0);
            h=findobj(0,'Tag','corauto');
            set(h,'Value',1);
        end

        corgui('CorBar');

        delete(gcf);

        %=============================================================
    case 'LstBox'                               %  ListBox
        %==========================================================
        %create list box to display program output dialog
        ts = ['Program Start-Up: ' datestr(now,0)];
        [screen_wide, screen_high]=screensizecm;

        x0=0.013*screen_wide; y0=0.2000*screen_high; 
        dx=0.3061*screen_wide; dy=0.04817*screen_high;

        SYS.lstbox = uicontrol('Style','list','Units','centimeters', ...
            'Position',[x0 y0 dx dy],'String',{ts});

%         %=============================================================
%     case 'RestoreFileBox'                        %  RestoreFileBox
%         %=============================================================
%         %create list box to display program output dialog
%         [screen_wide, screen_high]=screensizecm;
% 
%         x0=0.63*screen_wide; y0=0.210*screen_high; dx=0.15*screen_wide; dy=0.025*screen_high;
% 
%         uicontrol('Style','Text',...
%             'Units','centimeters',...
%             'Position',[x0 y0 dx dy],...
%             'String',' ',...
%             'tag','restorefile');

        %===========================================================
    case 'LBox'                          %*** LBox ***
        %===========================================================
        %load latest sequence of strings into graphical display listbox
        comment = varargin{1};
        ts      = datestr(now,0);
        addstr  = {[ts  ': ' comment]};
        h       = SYS.lstbox;
        str     = get(h,'String');
        str     = [str; addstr];
        ione    = size(str,1);
        nentry  = 50;
        
        if ione >= nentry                %keep only top entries
            str = str(ione-nentry+1:ione,1);
            ione = size(str,1);
        end
        
        set(h,'String',str,'listboxtop',ione);

        % % % if ~isempty(SYS.SYSLogfid)              %write to log file
        % % %    str=char(addstr{1});
        % % %    fprintf(SYS.SYSLogfid,'%s\n',str);
        % % % end

%         %==========================================================
%     case 'StartPatchActive'                  % StartPatchActive
%         %==========================================================
%         %activate start patch in element icon/zoom bar
%         set(orbfig,'WindowButtonMotionFcn','orbgui(''MoveStartPatch'')',...
%             'WindowButtonUpFcn',    'orbgui(''StartPatchUp'')');
% 
%         %==========================================================
%     case 'MoveStartPatch'                    % MoveStartPatch
%         %==========================================================
%         xpos=orbgui('GetStartPos',0.02);
%         orbgui('SetStartPatch',xpos);

        %==========================================================
%     case 'GetStartPos'                    % GetStartPos
%         %==========================================================
%         %find starting position and check agains stop position
%         stoplim=varargin(1); stoplim=stoplim{1};
%         %check requested point to right of zero
%         cpa = get(SYS.ahpos, 'CurrentPoint');
%         xpos = cpa(1);
%         if xpos<=0.0055
%             xpos=0.0055;
%         end
% 
%         %check requested point to left of stop patch
%         h=findobj(0,'Tag','stoppatch');
%         xlim=get(h,'XData');   %x-positions of three patch corners
%         if xpos>=xlim(1)-stoplim;
%             xpos =xlim(1)-stoplim;
%         end
%         varargout{1}=xpos;
% 
%         %==========================================================
%     case 'SetStartPatch'                     % SetStartPatch
%         %==========================================================
%         %move the patch to mouse position
%         xpos=varargin{1};
%         h=findobj(orbfig,'tag','startpatch');
%         xdata = [xpos-0.005 xpos+0.005 xpos-0.005];
%         set(h, 'XData', xdata);
% 
%         %==========================================================
%     case 'StartPatchUp'                       %StartPatchUp
%         %==========================================================
%         %sequence to execute when startpatch let up
%         xpos=orbgui('GetStartPos',0.01);
%         orbgui('SetStartPatch',xpos);
% 
%         %change BPM and corrector plot limits
%         limits = get(SYS.ahbpm,'XLim');
%         set(SYS.ahbpm,'XLim',[SYS.xlimax*xpos limits(1,2)]);   %Change start, leave stop alone
%         set(SYS.ahcor,'XLim',[SYS.xlimax*xpos limits(1,2)]);
%         corgui('PlotAct');
%         corgui('PlotFit');
%         set(orbfig, 'Pointer','arrow',...
%             'WindowButtonMotionFcn','','WindowButtonUpFcn','');
% 
%         %==========================================================
%     case 'StopPatchActive'                  % StopPatchActive
%         %==========================================================
%         set(orbfig,'WindowButtonMotionFcn','orbgui(''MoveStopPatch'')',...
%             'WindowButtonUpFcn',    'orbgui(''StopPatchUp'')');
% 
%         %==========================================================
%     case 'MoveStopPatch'                    % MoveStopPatch
%         %==========================================================
%         xpos=orbgui('GetStopPos',0.01);
%         orbgui('SetStopPatch',xpos);
% 
%         %==========================================================
%     case 'GetStopPos'                    % GetStopPos
%         %==========================================================
%         stoplim=varargin(1); stoplim=stoplim{1};
%         %check requested point to left of the x-limit
%         cpa = get(SYS.ahpos, 'CurrentPoint');
%         xpos = cpa(1);
%         if xpos>=(1.0 - 0.005)
%             xpos =(1.0 - 0.005);
%         end
% 
%         %check requested point to right of start patch
%         h=findobj(orbfig,'tag','startpatch');
%         xlim=get(h,'XData');   %x-positions of three patch corners
%         if xpos<=xlim(1)+stoplim
%             xpos=xlim(1)+stoplim+0.01;
%         end
%         varargout{1}=xpos;
% 
%         % %check requested point to left of stop patch
%         % h=findobj(orbfig,'tag','stoppatch');
%         % xlim=get(h,'XData');   %x-positions of four patch corners
%         % if xpos>=xlim(1)-stoplim;
%         %    xpos=xlim(1)-stoplim;
%         % end
%         % varargout{1}=xpos;
% 
%         %==========================================================
%     case 'SetStopPatch'                     % SetStopPatch
%         %==========================================================
%         xpos=varargin{1};
%         h=findobj(orbfig,'tag','stoppatch');
%         xdata = [xpos+0.005 xpos-0.005 xpos+0.005];
%         set(h, 'XData', xdata);  %move the patch to mouse position
% 
%         %==========================================================
%     case 'StopPatchUp'                       %StopPatchUp
%         %==========================================================
%         xpos=orbgui('GetStopPos',0.01);
%         orbgui('SetStopPatch',xpos);
% 
%         %change BPM and corrector plot limits
%         limits = get(SYS.ahbpm,'XLim');
%         set(SYS.ahbpm,'XLim',[limits(1,1) SYS.xlimax*xpos]);   %Change stop, leave start alone
%         set(SYS.ahcor,'XLim',[limits(1,1) SYS.xlimax*xpos]);
%         corgui('PlotAct');
%         corgui('PlotFit');
%         set(orbfig, 'Pointer','arrow',...
%             'WindowButtonMotionFcn','','WindowButtonUpFcn','');

        %==========================================================
    case 'GetAbscissa'                          %...GetAbscissa
        %==========================================================
        %return coordinates for abscissa (position or phase)
        SYS   = varargin{1};
        elem  = varargin{2};
        plane = SYS.plane;
        
        switch SYS.xscale
            case 'meter'
                if strcmpi(elem,'BPM'), xd = BPM(plane).s; end
                if strcmpi(elem,'COR'), xd = COR(plane).s; end
            case 'phase'
                if strcmpi(elem,'BPM'), xd = BPM(plane).phi; end
                if strcmpi(elem,'COR'), xd = COR(plane).phi; end
        end

        varargout = {xd};

        %=============================================================
    case 'InitialSaveSet'                 % *** InitialSaveSet ***
        %=============================================================
        %used during startup
        %generate a Save Set and copy to Initial slot
        SYS.save.max = 5;     %1 slot for Initial, 4 slot for Save Sets
        setappdata(0,'SYS',SYS);
        orbgui('SaveSet');
        SYS.save.ptr = 2;
        setappdata(0,'SYS',SYS);
        orbgui('SaveSet2Initial');
        SYS.save.ptr = 1;
        setappdata(0,'SYS',SYS);

        %=============================================================
    case 'SaveSet2Initial'               % *** SaveSet2Initial ***
        %=============================================================
        %load selected Save Set into Initial Slot
        ptr = SYS.save.ptr;
        orbgui('MoveSaveSet',ptr,1);    %move Save Set from ptr to 1
        %update figure if it exists
        if ~isempty(findobj('Tag','savesetfigure'))
            orbgui('UnDrawSaveSet');
            orbgui('ReDrawSaveSet');
        end

        %=============================================================
    case 'SaveSet'                             % *** SaveSet ***
        %=============================================================
        %generate SaveSet of parameters for both planes
        %bpm selection (ifit,wt)
        %beamline selection (ifit,wt)
        %corrector selection (ifit,wt)
        %bpm offsets (des)
        %system parameters: mode, bpmode, plane, relative, algorithm, bpmslp
        %fitting parameters: nsvd, etc

        %initialize buffer depth if necessary
        if ~isfield(SYS.save,'len'), SYS.save.len = 1;  end  

        %system parameters
        sys.mode       = SYS.mode;
        sys.bpmode     = SYS.bpmode;
        sys.plane      = SYS.plane;
        SYS.relative   = SYS.relative;
        sys.machine    = SYS.machine;
        sys.bpmslp     = SYS.bpmslp;
        sys.algo       = SYS.algo;
        sys.maxs       = SYS.maxs;
        sys.maxphi     = SYS.maxphi;
        sys.xscale     = SYS.xscale;

        %bpm, corrector and response matrix parameters
        for ip = 1:2,
            %BPM
            bpm(ip).mode     = BPM(ip).mode;
            bpm(ip).scalemode= BPM(ip).scalemode;
%             bpm(ip).dev      = BPM(ip).dev;
            bpm(ip).id       = BPM(ip).id;
            bpm(ip).ifit     = BPM(ip).ifit;
            bpm(ip).wt       = BPM(ip).wt;
            bpm(ip).des      = BPM(ip).des;
            %Correctors
            cor(ip).mode     = COR(ip).mode;
            cor(ip).scalemode= COR(ip).scalemode;
            cor(ip).fract    = COR(ip).fract;
            cor(ip).id       = COR(ip).id;
            cor(ip).ifit     = COR(ip).ifit;
            cor(ip).wt       = COR(ip).wt;
            cor(ip).ebpm     = COR(ip).ebpm;
            %Orbit Response Matrix
            rsp(ip).nsvd     = RSP(ip).nsvd;
            rsp(ip).disp     = RSP(ip).disp;
            rsp(ip).eig      = RSP(ip).eig;
        end

        %move Save Sets down
        len = SYS.save.len;    %present length of buffer
        for ii = len:-1:2      %'Initial' occupies first slot
            orbgui('MoveSaveSet',ii,ii+1);
        end

        %load new Save Set slot #2 (slot #1 = Initial)
        slot = 2;
        setappdata(orbfig,['sys' num2str(slot)],sys);
        setappdata(orbfig,['bpm' num2str(slot)],bpm);
        setappdata(orbfig,['cor' num2str(slot)],cor);
        setappdata(orbfig,['rsp' num2str(slot)],rsp);
        
        %create time stamp
        SYS.save.ts(slot,:) = datestr(now,0); 

        %increment Save Set buffer length
        SYS.save.len = SYS.save.len+1;                     
        
        if SYS.save.len > SYS.save.max    %stop at maximum
            SYS.save.len = SYS.save.max;
            setappdata(0,'SYS',SYS);
        end

        %update figure if it exists
        if ~isempty(findobj('Tag','savesetfigure'))
            orbgui('UnDrawSaveSet');
            SYS.save.ptr = 2;
            setappdata(0,'SYS',SYS);
            %point to most recent selection
            orbgui('ReDrawSaveSet');
        end

        orbgui('LBox',' Saved parameter Save Set');

        %=============================================================
    case 'MoveSaveSet'                       % *** MoveSaveSet ***
        %=============================================================
        %moves a Save Set from one location in appdata to another
        start = varargin{1};  %initial SaveSet location
        stop  = varargin{2};  %final SaveSet location

        sys = getappdata(orbfig,['sys' num2str(start)] );
        bpm = getappdata(orbfig,['bpm' num2str(start)] );
        cor = getappdata(orbfig,['cor' num2str(start)] );
        rsp = getappdata(orbfig,['rsp' num2str(start)] );

        setappdata(orbfig,['sys' num2str(stop)],sys);
        setappdata(orbfig,['bpm' num2str(stop)],bpm);
        setappdata(orbfig,['cor' num2str(stop)],cor);
        setappdata(orbfig,['rsp' num2str(stop)],rsp);

        SYS.save.ts(stop,:) = SYS.save.ts(start,:);    %move time stamp
        setappdata(0,'SYS',SYS);

        %===================================================================
    case 'RestoreSaveSet'                       % *** RestoreSaveSet ***
        %===================================================================
        %pop up screen with choices for SaveSet

        %test if Save Set panel already exists
        h = findobj(0,'tag','savesetfigure');
        if ~isempty(h)
            delete(h);
        end

        [screen_wide, screen_high]=screensizecm;

        % Draw the outside box of the figure
        x0=0.3545*screen_wide; y0=0.4297*screen_high; dx=0.4014*screen_wide; dy=0.2500*screen_high;
        figure('Units','centimeters',...
            'Position',[x0 y0 dx dy],...
            'NumberTitle','off',...
            'Name','Save Set Selection',...
            'Tag','savesetfigure',...
            'MenuBar','none');

        %pushbuttons for Save Set commands
        x0=0.025*screen_wide; y0=0.02*screen_high; dx=0.08*screen_wide; dy=0.025*screen_high;
        uicontrol('Style','pushbutton',...
            'Units','centimeters',...
            'String','Load Save Set',...
            'Position',[x0+0*dx y0 dx dy],...
            'Callback','orbgui(''LoadSaveSet'');');

        uicontrol('Style','pushbutton',...
            'Units','centimeters',...
            'String','Delete Save Set',...
            'Callback','orbgui(''DeleteSaveSet'');',...
            'Position',[x0+1.1*dx y0 dx dy]);

        uicontrol('Style','pushbutton',...
            'Units','centimeters',...
            'String','Load to Initial',...
            'Callback','orbgui(''SaveSet2Initial'');',...
            'Position',[x0+2.2*dx y0 dx dy]);

        uicontrol('Style','pushbutton',...
            'Units','centimeters',...
            'String','Cancel',...
            'Callback','delete(gcf)',...
            'Position',[x0+3.3*dx y0 dx dy]);

        orbgui('ReDrawSaveSet')

        %=============================================================
    case 'UnDrawSaveSet'                   % *** UnDrawSaveSet ***
        %=============================================================
        %remove radio buttons
        for ptr = 1:SYS.save.len
            h=findobj(0,'Tag',['ss' num2str(ptr)]);
            delete(h);
        end

        %=============================================================
    case 'ReDrawSaveSet'                   % *** ReDrawSaveSet ***
        %=============================================================
        [screen_wide, screen_high]=screensizecm;
        x0=0.025*screen_wide; y0=0.02*screen_high; dx=0.08*screen_wide; dy=0.025*screen_high;

        h=findobj('Tag','savesetfigure');
        figure(h);
        %List Save Set choices
        %radio button for initial Save Set
        uicontrol('Style','radio',...
            'Units','centimeters',...
            'Position',[x0 y0+7*dy 4*dx 0.9*dy],...
            'String',['Initial Save Set  :  ' SYS.save.ts(1,:)],...
            'Value',0,...
            'Tag','ss1',...
            'Callback','orbgui(''SelectSaveSet'');',...
            'ToolTipString','Restore to Initial Save Set');

        %radio buttons for Save Sets
        len = SYS.save.len;                      %length of buffer
        for ii = 2:len
            tag = ['ss' num2str(ii)];          %add unity since initial in '1' slot
            ts  = SYS.save.ts(ii,:);
            uicontrol('Style','radio',...
                'Units','centimeters',...
                'Position',[x0 y0+(7-ii)*dy 4*dx 0.9*dy],...
                'String',['Save Set  ',num2str(ii-1),'         :  ' ts],...
                'Value',0,...
                'Tag',tag,...
                'Callback','orbgui(''SelectSaveSet'');',...
                'ToolTipString','Restore Save Set');
        end

        if isfield(SYS.save,'ptr')
            if ~isempty(SYS.save.ptr)
                set(findobj('Tag',['ss' num2str(SYS.save.ptr)]),'Value',1);
            end
        end

        %=============================================================
    case 'DeleteSaveSet'               % *** DeleteSaveSet ***
        %=============================================================
        %Delete the selected Save Set
        %first locate Save Set of choice
        if ~isfield(SYS.save,'ptr') || ~isfield(SYS.save,'len'),return; end

        ptr = SYS.save.ptr;    %pointer to selected Save Set
        len = SYS.save.len;    %total length of Save Set ring buffer

        if SYS.save.ptr == 1, return; end   %don'td delete Initial

        %shift higher order Save Sets down one slot each
        for ii = ptr:len-1,
            sys = getappdata(orbfig,['sys' num2str(ii+1)] );
            bpm = getappdata(orbfig,['bpm' num2str(ii+1)] );
            cor = getappdata(orbfig,['cor' num2str(ii+1)] );
            rsp = getappdata(orbfig,['rsp' num2str(ii+1)] );

            setappdata(orbfig,['sys' num2str(ii)],sys);   %initial in '1' slot
            setappdata(orbfig,['bpm' num2str(ii)],bpm);
            setappdata(orbfig,['cor' num2str(ii)],cor);
            setappdata(orbfig,['rsp' num2str(ii)],rsp);
            SYS.save.ts(ii,:) = SYS.save.ts(ii+1,:);
        end
        orbgui('UnDrawSaveSet');                      %clear drawing before reducing len
        SYS.save.ptr=[];

        if SYS.save.len>=2
            SYS.save.len=len-1;
        end

        setappdata(0,'SYS',SYS);

        orbgui('ReDrawSaveSet')

        %=============================================================
    case 'SelectSaveSet'               % *** SelectSaveSet ***
        %=============================================================
        imax=SYS.save.max+1;   %add '1' to include Initial

        %first turn off all choices
        for ii=1:imax,
            set(findobj(0,'Tag',['ss' num2str(ii)]),'Value',0);
        end

        %turn on selection
        set(gcbo,'Value',1);
        ptr=get(gcbo,'Tag');
        ptr=str2double(ptr(3));

        %load selection into global
        SYS.save.ptr=ptr;
        setappdata(0,'SYS',SYS);

        %=============================================================
    case 'LoadSaveSet'                       % *** LoadSaveSet ***
        %=============================================================
        %load parameters
        %update orbit
        %update correctors
        %solvesystem, backsub
        %replot

        if ~isfield(SYS.save,'ptr')
            disp('Warning: no Save Set Selected');
            orbgui('LBox','Warning: no Save Set Selected');
            return
        end

        ptr = SYS.save.ptr;

        sys = getappdata(orbfig,['sys' num2str(ptr)] );
        bpm = getappdata(orbfig,['bpm' num2str(ptr)] );
        cor = getappdata(orbfig,['cor' num2str(ptr)] );
        rsp = getappdata(orbfig,['rsp' num2str(ptr)] );

        SYS.mode       = sys.mode;
        SYS.bpmode     = sys.bpmode;
        SYS.plane      = sys.plane;
        SYS.relative   = SYS.relative;
        SYS.machine    = sys.machine;
        SYS.bpmslp     = sys.bpmslp;
        SYS.algo       = sys.algo;
        SYS.maxs        = sys.maxs;
        SYS.maxphi      = sys.maxphi;
        SYS.xscale     = sys.xscale;

        for ip = 1:2
            % BPM
            BPM(ip).mode     = bpm(ip).mode;
            BPM(ip).scalemode= bpm(ip).scalemode;
%             BPM(ip).dev      = bpm(ip).dev;
            BPM(ip).id       = bpm(ip).id;
            BPM(ip).ifit     = bpm(ip).ifit;
            BPM(ip).wt       = bpm(ip).wt;
            BPM(ip).des      = bpm(ip).des;
            %Correctors
            COR(ip).mode     =cor(ip).mode;
            COR(ip).scalemode=cor(ip).scalemode;
            COR(ip).fract    =cor(ip).fract;
            COR(ip).id       =cor(ip).id;
            COR(ip).ifit     =cor(ip).ifit;
            COR(ip).wt       =cor(ip).wt;
            COR(ip).ebpm     =cor(ip).ebpm;
            %Orbit response matrix
            RSP(ip).nsvd     =rsp(ip).nsvd;
            RSP(ip).disp     =rsp(ip).disp;
            RSP(ip).eig      =rsp(ip).eig;
        end
        
        setappdata(0,'SYS',SYS);
        setappdata(0,'BPM',BPM);
        setappdata(0,'COR',COR);
        setappdata(0,'RSP',RSP);

        orbgui('RefreshOrbGUI');

        COR(1).rst = COR(1).act;
        COR(2).rst = COR(2).act;
        setappdata(0,'COR',COR);

        orbgui('LBox',' Finished restoring system parameters ');
        %disp(['Save Set Loaded ' num2str(ptr) '  ' SYS.save.ts(ptr,:)]);

        %=============================================================
    case 'RestoreSystem'                   % *** RestoreSystem ***
        %=============================================================
        %restore ORBIT program from file
        pathname = char(varargin(1)); %file directory
        filename = char(varargin(2)); %SaveSystem file name
        auto     = char(varargin(3)); %automatic load flag
        [SYS BPM COR RSP] = RestoreOrbit(pathname,filename,auto,SYS,BPM,COR,RSP);  %no graphics commands

        %Some code below this line is done in RestoreOrbit

        %Get BPM status, sort for avail, ifit
        % TODO 
        [BPM(1).status BPM(2).status] = SPEAR2BPMCheck999(BPM(1).hndl,BPM(2).hndl);
        BPM(1).avail = BPM(1).status;  %...if status o.k. default to available
        BPM(2).avail = BPM(2).status;
        [BPM]        = SortBPMs(BPM,RSP);
        setappdata(0,'BPM',BPM);

        %Get COR status, sort for avail, ifit
        [COR] = SortCORs(COR,RSP);
        setappdata(0,'COR',COR);


        %Set up program parameters: both planes
        for ip = 1:2
            orbgui('TogglePlane');
            orbgui('RefreshOrbGUI');        %acquires new orbit, correctors, fits, updates plots
            %COR=getappdata(0,'COR');
            COR(ip).ref = COR(ip).act;
            COR(ip).rst = COR(ip).act;       %for save/restore
        end

        orbgui('InitialSaveSet');   
        SYS.save.ptr = 1;   
        SYS.save.len = 2;   %make save set, clear others

        orbgui('LBox',[' Finished loading Restore File: ' filename]);
        set(findobj('tag','restorefile'),'String',filename);

        %=============================================================
    case 'SaveSystem'                         % *** SaveSystem ***
        %=============================================================
        %write ORBIT parameters to *.m file
        
        filename = char(varargin(1));    %cell array containing file name
        comment  = char(varargin(2));    %cell array containing file comment
        
        [fid,message] = fopen(filename,'w');
        
        if fid == -1
            disp(message);
            return
        end
        
        % Laurent asks %s\n for windows compatibility ???
        
        fprintf(fid,'%s\n','%system parameter save file');
        ts = datestr(now,0);
        fprintf(fid,'%s\n',['%timestamp: ' ts]);
        fprintf(fid,'%s\n',['%comment: ' comment]);
        %
        fprintf(fid,'%s',['sys.machine='  ,'''',SYS.machine,''';']);
        fprintf(fid,'%s\n', '   %machine for control');
        %
        fprintf(fid,'%s',['sys.mode='  ,'''',SYS.mode,''';']);
        fprintf(fid,'%s\n', '      %online or simulator');
        %
        fprintf(fid,'%s',['sys.bpmode=' ,'''',SYS.bpmode,''';']);
        fprintf(fid,'%s\n', '     %BPM system mode');
        %
        fprintf(fid,'%s',['sys.bpmslp= ',num2str(SYS.bpmslp),';']);
        fprintf(fid,'%s\n', '          %BPM sleep time in sec');
        %
        fprintf(fid,'%s',['sys.plane='  ,     num2str(SYS.plane),';']);
        fprintf(fid,'%s\n', '            %plane (1=horizontal 2=vertical)');
        %
        fprintf(fid,'%s',['sys.algo=', '''SVD'';']);
        fprintf(fid,'%s\n', '         %fitting algorithm');
        %
%         fprintf(fid,'%s',['sys.pbpm= ' ,num2str(SYS.pbpm),';']);
%         fprintf(fid,'%s\n', '            %acquisition of photon BPMs');
        %
        fprintf(fid,'%s',['sys.filepath=  ' ,'''',SYS.filepath,''';']);
        fprintf(fid,'%s\n', '     %file path in MATLAB');
        %
        fprintf(fid,'%s',['sys.reffile=  ' ,'''',SYS.reffile,''';']);
        fprintf(fid,'%s\n', '     %reference orbit file');
        %
%         fprintf(fid,'%s',['sys.rspfile=  ' ,'''',SYS.rspfile,''';']);
%         fprintf(fid,'%s\n', '     %response matrix file');
        %
%         fprintf(fid,'%s',['sys.brspfile= ','''',SYS.brspfile,''';']);
%         fprintf(fid,'%s\n', '     %bump response matrix file');
        %
        fprintf(fid,'%s',['sys.etafile= ' ,'''',SYS.etafile,''';']);
        fprintf(fid,'%s\n', '     %dispersion file');
        %
        fprintf(fid,'%s',['SYS.relative= ' ,num2str(SYS.relative),';']);
        fprintf(fid,'%s\n', '        %relative or absolute BPM plot 1=absolute, 2=relative');
        %
%         fprintf(fid,'%s',['sys.fdbk= 0;']);
%         fprintf(fid,'%s\n', '            %no feedback');
%         %
%         fprintf(fid,'%s',['sys.abort=0;']);
%         fprintf(fid,'%s\n', '            %reset abort flag');
        %
        fprintf(fid,'%s',['sys.maxs= ',num2str(SYS.maxs),';']);
        fprintf(fid,'%s\n', '           %maximum ring circumference');
        %
        fprintf(fid,'%s',['sys.xlimax= ' ,num2str(SYS.xlimax),';']);
        fprintf(fid,'%s\n', '        %abcissa plot limit');
        %
        fprintf(fid,'%s',['sys.maxphi(1)= ',num2str(SYS.maxphi(1)),';']);
        fprintf(fid,'%s\n', '        %maximum horizontal phase advance');
        %
        fprintf(fid,'%s',['sys.maxphi(2)= ',num2str(SYS.maxphi(2)),';']);
        fprintf(fid,'%s\n', '        %maximum vertical phase advance');
        %
        fprintf(fid,'%s',['sys.xscale=', '''meter'';']);
        fprintf(fid,'%s\n', '        %abcissa plotting mode (meter or phase)');

        %==============================================================
        %********   WRITE HORIZONTAL & VERTICAL CONTROL DATA  *********
        %==============================================================
        header = ['%*=== HORIZONTAL DATA ===*'; '%*===   VERTICAL DATA ===*';];
        xy = ['x';'z';];
        for ip = 1:2,
            p = num2str(ip);
            fprintf(fid,'%s\n',' ');
            fprintf(fid,'%s\n',header(ip,:));

            %BPM
            fprintf(fid,'%s',[['bpm(',p,').dev=']  ,num2str(10),          ';']);
            fprintf(fid,'%s\n','          %maximum orbit deviation');
%             fprintf(fid,'%s',['bpm(',p,').drf=0;']);
%             fprintf(fid,'%s\n','           %dispersion component zero');
            fprintf(fid,'%s',[['bpm(',p,').id=']  ,num2str(BPM(ip).id),          ';']);
            fprintf(fid,'%s\n','          %BPM selection');
            fprintf(fid,'%s',[['bpm(',p,').scalemode=']  ,num2str(BPM(ip).scalemode),          ';']);
            fprintf(fid,'%s\n','     %BPM scale mode 0=manual mode, 1=autoscale');
            fprintf(fid,'%s',[['bpm(',p,').ylim=']  ,num2str(BPM(ip).ylim),          ';']);
            fprintf(fid,'%s\n','            %BPM vertical axis scale');

            %COR
            fprintf(fid,'%15s %6.3f',[['cor(',p,').fract='],num2str(COR(ip).fract),';']);
            fprintf(fid,'%s\n','      %fraction of correctors');
            fprintf(fid,'%s','cor(',p,').savfrac =1.0;');
            fprintf(fid,'%s\n' ,'    %saved fraction of corrector solution (unity)');

            %RSP
            fprintf(fid,'%s',['rsp(',p,').disp =''off'';']);
            fprintf(fid,'%s\n' ,'     %mode for matrix column display');
            fprintf(fid,'%s',['rsp(',p,').eig  =''off'';']);
            fprintf(fid,'%s\n' ,'     %mode for eigenvector display');
            fprintf(fid,'%s',['rsp(',p,').fit  =0;']);
            fprintf(fid,'%s\n' ,'         %valid fit flag');
            fprintf(fid,'%s %d',['rsp(',p,').rfflag=', num2str(RSP(ip).rfflag),';']);
            fprintf(fid,'%s\n' ,'           %rf fitting flag');
            fprintf(fid,'%s %d',['rsp(',p,').savflag=0;']);
            fprintf(fid,'%s\n' ,'      %save solution flag');
            fprintf(fid,'%s',[['rsp(',p,').nsvd=' ],num2str(RSP(ip).nsvd), ';']);
            fprintf(fid,'%s\n','         %number of singular values');
%             fprintf(fid,'%s',[['rsp(',p,').savnsvd=' ],num2str(RSP(ip).savnsvd), ';']);
%             fprintf(fid,'%s\n','       %saved number of singular values');
            fprintf(fid,'%s',['rsp(',p,').nsvdmax=1;']);
            fprintf(fid,'%s\n','        %default maximum number of singular values');
%             fprintf(fid,'%s',[['rsp(',p,').bmp=' ],num2str(RSP(ip).bmp), ';']);
%             fprintf(fid,'%s\n','           %bump subtraction flag');
            fprintf(fid,'%s\n',' ');


            %BPM fitting indices, weights
            fprintf(fid,'%s\n','%BPM data: name, index, fit,  weight, etaweight');
            fprintf(fid,'%6s\n' ,['bpm',xy(ip,:),'={']);

            for ii = 1:size(BPM(ip).name,1)
                ifit = ii;
                if isempty(find(BPM(ip).ifit == ii,1))
                    ifit = 0;
                end
                fprintf(fid,'%1s %10s %5d %5d %10.3f %10.3f %1s\n' ,...
                    '{',['''',BPM(ip).name(ii,:),''''], ii, ifit, BPM(ip).wt(ii), 0.0, '}');
            end
            fprintf(fid,'%2s\n' ,'};');
            fprintf(fid,'%s\n',' ');

            %Corrector fitting indices, weights, limits, ebpm matrix, pbpm matrix
            fprintf(fid,'%s\n','%COR data: name, index, fit,  weight,   limit,      ebpm,      pbpm');
            fprintf(fid,'%6s\n' ,['cor',xy(ip,:),'={']);
            for ii = 1:size(COR(ip).name,1)
                ifit = ii;
                if isempty(find(COR(ip).ifit == ii,1))
                    ifit = 0;
                end
                fprintf(fid,'%1s %10s %5d %5d %10.3f %10.3f %10.3f  %1s\n' ,...
                    '{',['''',COR(ip).name(ii,:),''''], ii, ifit,  ...
                    COR(ip).wt(ii), COR(ip).lim(ii), COR(ip).ebpm(ii),'}');
            end
            fprintf(fid,'%2s\n' ,'};');
            fprintf(fid,'%s\n',' ');

        end    %end of plane loop

        %close file, produce binary backup
        fclose(fid);
        disp(['Saved system parameters to file... ' filename ]);
        temp = [filename '_binary'];
        save(temp, 'BPM', 'COR', 'RSP', 'SYS');
        disp(['Backup file... ' temp ]);

        %==========================================================
    case 'SaveBump'                               %  SaveBump
        %==========================================================
        %*** Save Bump File ***
        extype='*.dat';
        [filename,pathname]=uiputfile(extype,'Select Bump File Name');
        if isempty(findstr(filename,'.m'))
            filename = [filename,'.m'];
        end

        if isequal(filename,0) || isequal(pathname,0)
            disp('File not open');
            return
        else
            disp(['File ', [pathname filename], ' open']);
        end

        [fid,message]=fopen([pathname filename],'w');
        if fid==-1
            disp(['WARNING: Unable to open file to write bump :' pathname filename]);
            disp(message);
            return
        end

        ncor = length(COR(plane).ifit);
        fprintf(fid,'%s\n','new bump');
        fprintf(fid,'%d\n',ncor);
        for ii = 1:ncor
            id = COR(plane).ifit(ii);
            %.name is not compressed   .fit vector is compressed
            fprintf(fid,'%s %10.3f\n' ,...
                [COR(plane).name(id,:) '     '], COR(plane).fit(ii));
        end
        fclose(fid);

        %==========================================================
    case 'CloseMainFigure'                    %CloseMainFigure
        %==========================================================

        answer = questdlg('Close Orbit GUI?',...
            'Exit Orbit Control Program',...
            'Yes','No','Yes');
        switch answer

            case 'Yes'

                %     answer = questdlg('Clear channel access handles?',...
                %                        'Channel Access handles',...
                %                        'Yes','No','Yes');
                %     if strcmp(answer,'Yes')
                %         disp('   Closing Channel Access SYS...');
                %         clearmcahandles;
                %     end
                delete(findobj('tag','makeorbitslider'));
                delete(findobj('tag','bpmplotscale'));
                delete(findobj('tag','corplotscale'));

                delete(findobj('tag','rload_xbwt'));
                delete(findobj('tag','rload_xclim'));
                delete(findobj('tag','rload_xcwt'));
                delete(findobj('tag','rload_hbpm'));
                delete(findobj('tag','rload_etawtx'));

                delete(findobj('tag','rload_zbwt'));
                delete(findobj('tag','rload_zclim'));
                delete(findobj('tag','rload_zcwt'));
                delete(findobj('tag','rload_ypwt'));
                delete(findobj('tag','rload_vbpm'));
                delete(findobj('tag','rload_etawtz'));

                delete(findobj('tag','rload_vbl'));
                delete(findobj('tag','toggle_blsel'));

                delete(findobj('tag','dispersionpanel'));
                delete(findobj('tag','orbfig'));
                return

            case 'No'
                return
            otherwise
                return
        end

        %===========================================================
    otherwise
        disp(['   Warning: CASE not found in ORBGUI: ' action]);

end  %end switchyard

