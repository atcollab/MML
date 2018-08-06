function bpmgui(action, varargin)
% function varargout = bpmgui(action, varargin)
%  bpmgui controls orbit manipulation and plotting
%  graphics handles
%
% INPUT
% 1. action possible among
% 
% GetRef
% UpdateRef
% GetAct
% UpdateAct
% ylimits
% PlotRef_Init
% PlotRef
% PlotAct_Init
% PlotAct
% PlotFit_Init
% PlotFit
% PlotDes_Init
% PlotDes
% ClearOffsets
% PlotIcons_Init
% PlotBPMs
% PlotResp_Init
% PlotResp
% PlotEig_Init
% PlotEig
% BPMSelect
% BPMBar
% BPMDown
% ProcessBPM
% MoveBPM
% Up
% EditDesOrb
% EditBPMWeight
% SetBPMOff
% UpdateBPMBox
% BPMBox
% RePlot
% ClearPlots
% SelectAll
% SelectNone
% ToggleMode
% ToggleMode
% DragMode
% ShowBPMState
% 
% 

%
% Written By Jeff Corbett
% Modified by Laurent S. Nadolski, Soleil, April 2004

global BPM COR RSP SYS
orbfig = findobj(0,'tag','orbfig');
plane  = SYS.plane;

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
        %load present orbit into .ref field of BPM structure

        % H-plane
        BPM(1).ref = BPM(1).act;
        % V-plane
        BPM(2).ref = BPM(2).act;
        
        setappdata(0,'BPM',BPM);

        %=============================================================
    case 'UpdateRef'                           % *** UpdateRef ***
        %=============================================================
        %load a simulated or measured reference orbit into BPM structure
        %load a copy into the .des field
        bpmgui('GetRef');  
        %BPM=getappdata(0,'BPM');

        % H-plane
        BPM(1).act = BPM(1).ref;
        BPM(1).des = BPM(1).ref;
        BPM(1).abs = BPM(1).ref;
        % V-plane
        BPM(2).act = BPM(2).ref;
        BPM(2).des = BPM(2).ref;
        BPM(2).abs = BPM(2).ref;

        if SYS.relative == 1   %absolute mode
            BPM(1).abs = BPM(1).abs*0;
            BPM(2).abs = BPM(2).abs*0;
        end

        setappdata(0,'BPM',BPM);

        orbgui('LBox',' Refresh Reference Orbit: ');

        orbgui('RefreshOrbGUI');

        %=============================================================
    case 'GetAct'                             % *** GetAct ***
        %=============================================================
        %acquire orbit, load into .act field

        % H-plane
        val = getam(BPM(1).AOFamily,[],SYS.mode);
        BPM(1).act(BPM(1).status) = val;
        % V-plane
        val = getam(BPM(2).AOFamily,[],SYS.mode);
        BPM(2).act(BPM(2).status) = val;

        %% Variable stored in the workspace memory
        setappdata(0,'BPM',BPM);     

        %=============================================================
    case 'UpdateAct'                           % *** UpdateAct ***
        %=============================================================
        %read new orbit, update graphics

        orbgui('LBox',' Refresh Orbit ');
        %         disp('bpm acquisition');
        %         tic;
        pause(2);
        bpmgui('GetAct');          %loads both planes (300 ms in simulator)
        %         toc;

        %         disp('Corrector acquisition');
        %         tic;
        corgui('GetAct');          %loads both planes (200 ms in simulator)
        %         toc;

        orbgui('RefreshOrbGUI');

        %=============================================================
    case 'ylimits'                             % *** ylimits ***
        %=============================================================
        
        %set vertical axis limits for BPM plot
        if BPM(plane).scalemode == 0
            return; 
        end  %manual mode

        orbgui('AutoScaleBPMAxis');
%         mxref = max(abs(BPM(plane).ref(BPM(plane).status)-BPM(plane).abs(BPM(plane).status)));        %for ylimit calculation
%         mxdes = max(abs(BPM(plane).des(BPM(plane).status)-BPM(plane).abs(BPM(plane).status)));        %for ylimit calculation
%         mxact = max(abs(BPM(plane).act(BPM(plane).status)-BPM(plane).abs(BPM(plane).status)));        %for ylimit calculation
%         mxfit = max(abs((BPM(plane).act(BPM(plane).avail)-BPM(plane).abs(BPM(plane).avail)+...
%             BPM(plane).fit(BPM(plane).avail))));
%                
%         ylim = max([mxref mxdes mxact mxfit])*1.1;
% 
%         % TODO if limimit y-scale wanted
%         %units are mm
% %         if ylim < 0.01 ylim = 0.01; end
% 
%         ylim = ylim *BPM(plane).scale;
%         
%         set(SYS.ahbpm,'YLim',ylim*[-1, 1]);

        %==========================================================
    case 'PlotRef_Init'                        %...PlotRef_Init
        %==========================================================
        %red, solid line for reference orbit.
        %use .iref field
        set(SYS.ahbpm,'Color',[1 1 1],'NextPlot','add');
        set(orbfig,'currentaxes',SYS.ahbpm)

        yd = BPM(plane).ref(BPM(plane).iref)-BPM(plane).abs(BPM(plane).iref);
        yd = yd *BPM(plane).scale;
        
        xd = orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
        xd = xd(BPM(plane).iref);

        SYS.lhref=	line('parent',SYS.ahbpm,'XData',xd, ...
            'YData',yd,'Color','r','Tag', 'Ref');
        set(SYS.lhref,'ButtonDownFcn','bpmgui(''BPMSelect'');');

        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'PlotRef'                        %...PlotRef
        %==========================================================
        %red, solid, static line for reference orbit.
        %use .iref field
        bpmgui('ylimits');
        set(orbfig,'currentaxes',SYS.ahbpm)

        xd = orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
        xd = xd(BPM(plane).iref);

        yd = BPM(plane).ref(BPM(plane).iref) - BPM(plane).abs(BPM(plane).iref);
        yd = yd*BPM(plane).scale;
        
        set(SYS.lhref,'LineWidth',1.25,'XData',xd,'YData',yd);

        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'PlotAct_Init'                        %...PlotAct_Init
        %==========================================================
        %blue, solid dynamic line for actual orbit.
        %use .status field
        bpmgui('ylimits');
        set(SYS.ahbpm,'Color',[1 1 1],'NextPlot','add');
        set(orbfig,'currentaxes',SYS.ahbpm)

        SYS.lhact = line('parent',SYS.ahbpm,'XData',[], ...
            'YData',[],'Color','b','ButtonDownFcn', ...,
            'bpmgui(''BPMSelect'');','Tag', 'Act');

        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'PlotAct'                             %...PlotAct
        %==========================================================
        %blue, solid dynamic line for actual orbit.
        %use .status field
        bpmgui('ylimits');
        set(orbfig,'currentaxes',SYS.ahbpm)
        xd = orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
        xd = xd(BPM(plane).status);

        yd = BPM(plane).act(BPM(plane).status)-BPM(plane).abs(BPM(plane).status);
        yd = yd *BPM(plane).scale;
        
        set(SYS.lhact,'LineWidth',1.2,'XData',xd,'YData',yd);

        %==========================================================
    case 'PlotFit_Init'                        %...PlotFit_Init
        %==========================================================
        %blue, dashed line for orbit fit
        %use .avail field
        bpmgui('ylimits');
        set(SYS.ahbpm,'Color',[1,1,1],'NextPlot','add');
        set(orbfig,'currentaxes',SYS.ahbpm)
        SYS.lhfit=	line('parent',SYS.ahbpm,'XData',[], ...
            'YData',[],'Color','b','LineStyle',':','Tag', 'Fit');

        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'PlotFit'                             %...PlotFit
        %==========================================================
        %blue, dashed line for orbit fit
        %use .avail field
        set(orbfig,'currentaxes',SYS.ahbpm)

        %actual orbit plus the fitted solution from corrector change
        %yields the predicted orbit
        yd = (BPM(plane).act(BPM(plane).avail) - ...
              BPM(plane).abs(BPM(plane).avail) + ... %zero if absolute, ref else
              BPM(plane).fit(BPM(plane).avail) + ...
              BPM(plane).rffit(BPM(plane).avail));
        yd = yd*BPM(plane).scale;
        
        xd = orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
        xd = xd(BPM(plane).avail);
               
        %% Update graph
        set(SYS.lhfit,'XData',xd,'YData',yd);
        set(SYS.lhfit,'ButtonDownFcn','bpmgui(''BPMSelect'');');
        bpmgui('ylimits');

        %==========================================================
    case 'PlotDes_Init'                        %...PlotDes_Init
        %==========================================================
        %red, dashed dynamic line for offset orbit
        %use .avail field

        yd = BPM(plane).des(BPM(plane).avail) - BPM(plane).abs(BPM(plane).avail);
        yd = yd*BPM(plane).scale;
        
        xd = orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
        xd = xd(BPM(plane).avail);
        
        SYS.lhdes = line('parent',SYS.ahbpm,'XData',xd, ...
            'YData',yd,'Color','r','LineStyle',':','Tag', 'Des');
        set(SYS.lhdes,'ButtonDownFcn','bpmgui(''BPMSelect'');');

        setappdata(0,'SYS',SYS);

        bpmgui('ylimits');

        %==========================================================
    case 'PlotDes'                                  %...PlotDes
        %==========================================================
        % %red, dashed dynamic line for offset orbit
        %use .avail field

        yd = BPM(plane).des(BPM(plane).avail) - BPM(plane).abs(BPM(plane).avail);
        yd = yd *BPM(plane).scale;
       
        xd = orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
        xd = xd(BPM(plane).avail);
     
        set(SYS.lhdes,'XData',xd,'YData',yd);
        bpmgui('ylimits');

        %%==========================================================
    case 'ClearOffsets'                        %...ClearOffsets
        %==========================================================
        %remove offsets in plane of interest
        %use .avail field

        id = BPM(plane).avail(1:length(BPM(plane).avail));
        BPM(plane).des(id) = BPM(plane).ref(id)-BPM(plane).abs(id);
        
        %moves the icon on screen
        set(BPM(plane).hicon(id),{'YData'},num2cell(BPM(plane).des)); 

%         for ii = 1:length(BPM(plane).avail)
%             id                 = BPM(plane).avail(ii);
%             BPM(plane).des(id) = BPM(plane).ref(id)-BPM(plane).abs(id);
%             b                  = BPM(plane).hicon(id);
%             set(b,'YData',BPM(plane).des(id));   %moves the icon on screen
%         end

        setappdata(0,'BPM',BPM);

        orbgui('RefreshOrbGUI');

        %==========================================================
    case 'PlotIcons_Init'                       %...PlotIcons_Init
        %==========================================================
        %draw initial 'hot' circles for each BPM - need to vectorize
        selectbpm = 'bpmgui(''BPMDown'');';

        %present plane
        plane = SYS.plane;
        xd    = orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting

        %black if not in status vector
        for kk = 1:size(BPM(plane).name,1)
            BPM(plane).hicon(kk) = line('parent',SYS.ahbpm, ...
                'Tag', ['b' num2str(kk)],...
                'XData',xd(kk),...
                'YData',0,...
                'Marker','o','MarkerSize',5,'MarkerFaceColor','k',...
                'ButtonDownFcn',selectbpm);
        end
        BPM(plane).hicon          = BPM(plane).hicon(:);
        BPM(1+mod(plane,2)).hicon = BPM(plane).hicon;

        setappdata(0,'BPM',BPM);

        %draw a vertical black line at selected BPM
        ylim = get(SYS.ahbpm,'YLim');
        SYS.lhbid =	line('parent',SYS.ahbpm,...
            'XData',[xd(BPM(plane).id),xd(BPM(plane).id) + 0.001],...
            'YData',[ylim(1),ylim(2)],'Color','k','Tag', 'Icons');
        set(SYS.lhbid, 'ButtonDownFcn','bpmgui(''BPMSelect'');');

        %==========================================================
    case 'PlotBPMs'                             %...PlotBPMs
        %==========================================================
        %green if BPM contained in BPM(plane).ifit, otherwise yellow
        %red if not available (no response matrix entry or no reference orbit)
        %default hot bpms to black
%         yd = BPM(plane).des - BPM(plane).abs;
        yd = BPM(plane).act(BPM(plane).status) - BPM(plane).abs(BPM(plane).status);
        yd = yd*BPM(plane).scale;
        
        xd = orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting

%         for kk = 1:size(BPM(plane).name,1)
%             set(BPM(plane).hicon(kk),'Xdata',xd(kk),...
%                 'YData',0,'MarkerSize',5,'MarkerFaceColor','k');
%         end
%         set(BPM(plane).hicon,'YData',0,'MarkerFaceColor','k');
        
        nstat = length(BPM(plane).status);
        kk = (1:nstat)';
        colorcell = repmat({'g'},nstat,1); %green for fit
        colorcell(setdiff(kk,BPM(plane).ifit)) = {'y'};  %yellow for no fit
        colorcell(setdiff(kk,BPM(plane).avail)) = {'r'};  %red for not available
        
        % set everything using cell structure instead of for-loop      
%         set(BPM(plane).hicon,{'XData'},num2cell(xd),{'YData'},num2cell(yd), ...
%             {'MarkerFaceColor'},colorcell);
               
        for kk = 1:nstat
            k     = BPM(plane).status(kk);   %double index, BPM.status is compressed
            color = 'r';                 %red for not available
            if ~isempty(find(BPM(plane).avail == k)), color = 'y'; end   %yellow for available
            if isempty(BPM(plane).ifit)
                color = 'y'; %yellow for no fit
            elseif ~isempty(find(BPM(plane).ifit == k))
                color = 'g'; %green for fit
            end
%             set(BPM(plane).hicon(k),...
%                 'XData',xd(k),'YData',yd(k),...
%                 'MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor',color);
            for kk = 1:nstat
                k     = BPM(plane).status(kk);   %double index, BPM.status is compressed
                color = 'r';                 %red for not available
                if ~isempty(find(BPM(plane).avail == k)), color = 'y'; end   %yellow for available
                if isempty(BPM(plane).ifit)
                    color = 'y'; %yellow for no fit
                elseif ~isempty(find(BPM(plane).ifit == k))
                    color = 'g'; %green for fit
                end
            end

        end

        %==========================================================
    case 'PlotResp_Init'                      %...PlotResp_Init
        %==========================================================
        %black, solid dynamic line for response orbit
        %use .avail field
        bpmgui('ylimits');
        set(SYS.ahbpm,'Color',[1,1,1],'NextPlot','add');
        set(orbfig,'currentaxes',SYS.ahbpm);
        SYS.lhrsp =	line('parent',SYS.ahbpm,'XData',[], ...
            'YData',[],'Color','k','Tag', 'Resp');

        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'PlotResp'                             %...PlotResp
        %==========================================================
        %black, solid static line for column of response matrix
        %use .avail field

        id = COR(plane).id;

        set(orbfig,'currentaxes',SYS.ahbpm)

        ylim = get(SYS.ahbpm,'YLim');
        
        %scale column of response matrix
        val  = 0.5*ylim(2)/max(abs(RSP(plane).Data(BPM(plane).avail,id))); 
                                  
        yd   = val*RSP(plane).Data(BPM(plane).avail,id);
        
        xd   = orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting

        set(SYS.lhrsp,'LineWidth',1.5,'XData',xd,'YData',yd);

        %==========================================================
    case 'PlotEig_Init'                        %...PlotEig_Init
        %==========================================================
        %black, solid dynamic line for eigenvector orbit
        %use .iavail field for default
        bpmgui('ylimits');
        set(SYS.ahbpm,'Color',[1,1,1],'NextPlot','add');
        set(orbfig,'currentaxes',SYS.ahbpm)
        SYS.lheig=	line('parent',SYS.ahbpm,'XData',[], ...
            'YData',[],'Color','k','Tag', 'Eig');

        setappdata(0,'SYS',SYS);

        %==========================================================
    case 'PlotEig'                                  %...PlotEig
        %==========================================================
        %black, solid static line for eigenvector orbit
        %use .ifit field

        switch SYS.algo

            case 'SVD'
                ieig = RSP(plane).nsvd;

                if ieig == 0, return; end

                set(orbfig,'currentaxes',SYS.ahbpm);

                ylim = get(SYS.ahbpm,'YLim');
                val  = 0.5*ylim(2)/max(abs(RSP(plane).U(ieig,:)));   %columns are .ifit bpms
                yd   = val*RSP(plane).U(ieig,:);                                
                xd   = orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
                set(SYS.lheig,'LineWidth',1.5,'XData',xd,'YData',yd);                

        end   %end case

        %=============================================================
    case 'BPMSelect'                          % *** BPMSelect ***
        %=============================================================
        %used if mouse clicks anywhere in BPM window
        % Get mouse position
        cpa = get(SYS.ahbpm,'CurrentPoint');
        pos = cpa(1);

        %% Searchs closest BPM
        
        switch SYS.xscale
            case 'meter'
                id = find(min(abs(BPM(plane).s-pos)) == abs(BPM(plane).s-pos));
            case 'phase'
                id = find(min(abs(BPM(plane).phi-pos)) == abs(BPM(plane).phi-pos));
        end

        BPM(plane).id = id;

        %% Stores updated BPM structure
        setappdata(0,'BPM',BPM);

        b = BPM(plane).hicon(id); % handle for round symbol

        % Set black cross in the BPM window
        bpmgui('BPMBar');

        bpmgui('ProcessBPM',id,b);

        %=============================================================
    case 'BPMBar'                              % *** BPMBar ***
        %=============================================================
        %move black line in window to indicate selection
        id   = BPM(plane).id;
        ylim = get(SYS.ahbpm,'YLim');

        if isempty(find(BPM(plane).status == id,1))
            yd = ylim/4*BPM(plane).scale;
        else
            yd = (BPM(plane).des(id) - BPM(plane).abs(id))*BPM(plane).scale ...
                + ylim/4;
        end

        xd = orbgui('GetAbscissa',SYS,'BPM');  %horizontal coordinates for plotting
        xd = [xd(id) xd(id) + 0.001];
       
        set(SYS.lhbid,'XData',xd,'YData',yd);

        %=============================================================
    case 'BPMDown'                              % *** BPMDown ***
        %=============================================================
        %used if mouse clicks directly on BPM
        b     = gcbo;
        bptag = get(b,'tag');
        id    = str2double(bptag(2:length(bptag))); %strip off 'b' to get the bpm index
        BPM(plane).id = id;

        setappdata(0,'BPM',BPM);

        bpmgui('ProcessBPM',id,b);

        %=============================================================
    case 'ProcessBPM'                            % *** ProcessBPM ***
        %=============================================================
        %put BPM data into text fields.
        %if BPM.mode=1, display, toggle
        %if BPM.mode=2, display, drag

        %identify BPM handle and number
        id = varargin{1}; %bpm number 'id'
        b  = varargin{2}; %bpm graphics handle 'b'

        %check to see if bpm available
        if isempty(find(BPM(plane).avail == id,1)) %put fit value in offset box and in request box
            bpmgui('UpdateBPMBox');
            return;
        end

        %====================
        %   TOGGLE MODE
        %====================
        if BPM(plane).mode == 1                                %BPMs in toggle mode

            if isempty(BPM(plane).ifit)     %no BPMs chosen yet, this is the first one
                BPM(plane).ifit(1) = id;
                setappdata(0,'BPM',BPM);
                set(b,'MarkerFaceColor','g');
                set(orbfig,'WindowButtonUpFcn','bpmgui(''Up'')');
                return
            end

            if ~isempty(find(BPM(plane).ifit == id,1))                   %BPM presently on for fit
                set(b,'MarkerFaceColor','y');
                BPM(plane).ifit(find(BPM(plane).ifit==id)) = 0;          %set element in list to zero
                BPM(plane).ifit=BPM(plane).ifit(find(BPM(plane).ifit));  %compress list
                BPM(plane).ifit=BPM(plane).ifit(:);                      %create column vector
                setappdata(0,'BPM',BPM);

            elseif isempty(find(BPM(plane).ifit == id, 1)) && ...
                    ~isempty(find(BPM(plane).avail == id, 1))     %BPM presently not on for fit
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
        elseif BPM(plane).mode == 2                                    %BPMs in drag mode
            selectbpm = ['bpmgui(''MoveBPM'',' num2str(b) ', ' num2str(id) ');'];
            set(orbfig,'WindowButtonMotionFcn',selectbpm);
            set(orbfig,'WindowButtonUpFcn','bpmgui(''Up'')');
        end    %...end mode=2 (drag) condition

        bpmgui('UpdateBPMBox');

        %=============================================================
    case 'MoveBPM'                              % *** MoveBPM ***
        %=============================================================
        %This function is called each time the user moves the mouse in 'down' mode

        %reset the y coordinate of the data point on the dashed plot.
        %...plot_ydata = get(SYS.desorb, 'YData');
        %plot_ydata(ind) = pos(1,2);
        %the catch: note bpm tags have index progressing
        %linearly from start to finish independent of status.
        %But plot_ydata has index that skips bpms with bad status.
        %must look for position in status vector of the
        %bpm with index ind as chosen by the drag command.

%         b  = varargin{1};
        id = varargin{2};  
        b  = BPM(plane).hicon(id);    %doesn't work without this line - round-off?


        %reposition icon for BPM
        pos = get(SYS.ahbpm, 'CurrentPoint');
        yd  = pos(1,2);
      
        % Update ans save desired orbit
        BPM(plane).des(id) = yd/BPM(plane).scale + BPM(plane).abs(id);
        setappdata(0,'BPM',BPM);

        set(b, 'YData', yd);  %move the BPM icon to mouse position

        %re-plot red dotted line (desired orbit)
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
        h1 = SYS.bpmedit;   %handle of BPM edit box
        if isempty(get(SYS.bpmname,'String'))
            set(SYS.bpmedit,'String',num2str(0.0));
            return;
        end
        id = BPM(plane).id;
        b  = findobj(orbfig,'tag',['b' num2str(id)]);  %handle of bpm
        offset = str2double(get(h1,'String'));

        if isnan(offset) || ~isnumeric(offset) || ~length(offset) == 1
            % flush the bad string out of the edit; replace with current value
            offset = 0.0;
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
        h1 = SYS.editbpmweight;   %handle of BPM weight edit box
        if isempty(get(SYS.bpmname,'String'))
            set(SYS.editbpmweight,'String',num2str(1.0));
            return;
        end

        id     = BPM(plane).id;
%         b      = findobj(orbfig,'tag',['b' num2str(id)]);  %handle of bpm
        weight = str2double(get(h1,'String'));

        if isnan(weight) || ~isnumeric(weight) || ~length(weight) == 1
            % flush the bad string out of the edit; replace with current value
            weight = 1.0;
            set(h1,'String',num2str(weight));
            disp('Warning: Invalid weight entry.');
            orbgui('LBox','Warning: Invalid weight entry');
        end

        BPM(plane).wt(id) = weight;
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
        id     = varargin{1}; %bpm number 'id' comes through varargin
        b      = varargin{2}; %bpm handle 'b' comes through varargin
        offset = varargin{3}; % offset value
        
        % update and save BPM
        BPM(plane).des(id) = BPM(plane).ref(id)-BPM(plane).abs(id) ...
            + offset/BPM(plane).scale;      
        setappdata(0,'BPM',BPM); 

        %moves the icon on screen
        yd = BPM(plane).des(id);        
        set(b,'YData',yd);   

        % replot Desired orbit
        bpmgui('PlotDes');

        %=============================================================
    case 'UpdateBPMBox'                     % *** UpdateBPMBox ***
        %=============================================================
        %update BPMBox
        %called from respgui(SVDSlide),respgui(SVDEdit)
        id = BPM(plane).id;
        %check to see if bpm available
        if isempty(find(BPM(plane).avail == id,1)) %put fit value in offset box and in request box
            bpmgui('BPMBox',BPM(plane).name(id,:),BPM(plane).act(id),...
                0,0,0,0,0,0,id);
            return;
        else
            %compute desired offset from reference orbit
            offset       = BPM(plane).des(id) - BPM(plane).ref(id);
            %compute predicted fitted value
            predictedval = BPM(plane).fit(id) + ...
                (BPM(plane).act(id) - BPM(plane).abs(id));
            %compute orbit mean
            meanV = mean(BPM(plane).act(BPM(plane).status)-BPM(plane).abs(BPM(plane).status));
            %compute orbit rms
            rms   = std(BPM(plane).act(BPM(plane).status)-BPM(plane).abs(BPM(plane).status));
            bpmgui('BPMBox',BPM(plane).name(id,:),BPM(plane).act(id),...
                BPM(plane).ref(id),offset,BPM(plane).wt(id),BPM(plane).des(id),...
                predictedval, meanV, rms, id)
        end

        %=============================================================
    case 'BPMBox'                            % *** BPMBox ***
        %=============================================================
        %bpmgui('BPMBox',BPM(plane).name(id,:),BPM(plane).act(id),...
        %                BPM(plane).ref(id),BPM(plane).des(id),fitval,id);
        bpmname   = SYS.bpmname;
        actual    = SYS.bpmact;
        reference = SYS.bpmref;
        offedit   = SYS.bpmedit;
        wtedit    = SYS.editbpmweight;
        desire    = SYS.bpmdes;
        measval   = SYS.bpmmeas;
        rmsval    = SYS.bpmrms;
        meanval   = SYS.bpmmean;

        name = varargin{1};
        act  = varargin{2};
        ref  = varargin{3};
        off  = varargin{4};
        wt   = varargin{5};
        des  = varargin{6};
        meas = varargin{7};
        meanV= varargin{8};
        rms  = varargin{9};
        id   = varargin{10};

        % conversion in device list
        dev = elem2dev(BPM(plane).AOFamily,id);
        
        set(bpmname,  'String',[name '  [',num2str(dev(1)),' ', ...
            num2str(dev(2)),']']);
        set(actual,   'String',num2str(act*BPM(plane).scale,  '%6.3f'));
        set(reference,'String',num2str(ref*BPM(plane).scale,  '%6.3f'));
        set(offedit,  'String',num2str(off*BPM(plane).scale,  '%6.3f'));
        set(wtedit,   'String',num2str(wt,                    '%6.3f'));
        set(desire,   'String',num2str(des*BPM(plane).scale,  '%6.3f'));
        set(measval,  'String',num2str(meas*BPM(plane).scale, '%6.3f'));
        set(rmsval,   'String',num2str(rms*BPM(plane).scale,  '%6.3f'));
        set(meanval,  'String',num2str(meanV*BPM(plane).scale,'%6.3f'));
        set(offedit,  'UserData',id);

        %=============================================================
    case 'RePlot'                                 % *** RePlot ***
        %=============================================================
        %plot reference, desired, actual, icons
        set(orbfig,'currentaxes',SYS.ahbpm)
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

        set(orbfig,'currentaxes',SYS.ahbpm)
        set(SYS.lhrsp,'XData',[],'YData',[]);
        set(SYS.lheig,'XData',[],'YData',[]);
        set(SYS.lhfit,'XData',[],'YData',[]);

        %=============================================================
    case 'SelectAll'                           % *** SelectAll ***
        %============================================================
        BPM(plane).ifit=[];
        navail = length(BPM(plane).avail);
        
        set(BPM(plane).hicon(BPM(plane).avail),'MarkerFaceColor','g');
        
        BPM(plane).ifit(1:navail) = BPM(plane).avail(1:navail);
        
        
%         for kk = 1:navail
%             k    = BPM(plane).avail(kk);
%             hbpm = BPM(plane).hicon(k);;
%             set(hbpm,'MarkerFaceColor','g');
%             BPM(plane).ifit(kk) = k;
%         end

        setappdata(0,'BPM',BPM);

        orbgui('RefreshOrbGUI');

        %=============================================================
    case 'SelectNone'                           % *** SelectNone ***
        %=============================================================
        BPM(plane).ifit = [];
        
        set(BPM(plane).hicon(BPM(plane).avail),'MarkerFaceColor','y');
                
%         navail          = length(BPM(plane).avail);
%         for kk = 1:navail
%             k    = BPM(plane).avail(kk);
%             hbpm = BPM(plane).hicon(k);
%             set(hbpm,'MarkerFaceColor','y');
%         end

        setappdata(0,'BPM',BPM);

        orbgui('RefreshOrbGUI');

        %respgui('FitOff',num2str(plane));

        %==========================================================
    case 'ToggleMode'                      % *** ToggleMode ***
        %==========================================================
        %callback of the bpm toggle radio button
        %radio button toggles state and then executes callback
        %hence, this routine finds the new state

        if get(SYS.togglebpm,'Value') == 0 &&  ...
                get(SYS.dragbpm,'Value') == 0
            BPM(plane).mode = 0;           %'0' for display only
        else
            set(SYS.dragbpm,'Value',0);
            BPM(plane).mode = 1;           %'1' for toggle mode
        end

        setappdata(0,'BPM',BPM);

        %==========================================================
    case 'DragMode'                          % *** DragMode ***
        %==========================================================
        %callback of the bpm drag radio button
        %radio button toggles state and then executes callback
        %hence, this routine finds the new state

        if get(SYS.togglebpm,'Value') == 0 &&  ...
                get(SYS.dragbpm,'Value') == 0
            BPM(plane).mode = 0;           %'0' for display only
        else
            set(SYS.togglebpm,'Value',0);
            BPM(plane).mode = 2;           %'2' for drag mode
        end

        setappdata(0,'BPM',BPM);

        %===========================================================
    case 'ShowBPMState'                    %*** ShowBPMState ***
        %===========================================================
        % Show bpm settings
        len = size(BPM(plane).name,1);
        tavail  = zeros(len,1);
        tfit    = zeros(len,1);
        tstatus = zeros(len,1);
      
        idx = intersect(BPM(plane).avail,1:len);
        tavail(idx) = idx;
        idx = intersect(BPM(plane).ifit,1:len);
        tfit(idx) = idx;
        idx = intersect(BPM(plane).status,1:len);
        tstatus(idx) = idx;
      
%         tic 
%         for ii = 1:size(BPM(plane).name,1)
%             if ~isempty(find(BPM(plane).avail == ii))  tavail(ii)  = ii;  end
%             if ~isempty(find(BPM(plane).ifit == ii))   tfit(ii)    = ii;  end
%             if ~isempty(find(BPM(plane).status == ii)) tstatus(ii) = ii;  end
%         end
%         toc

        ref  = BPM(plane).ref;
        des  = BPM(plane).des;
        babs = BPM(plane).abs;
        act  = BPM(plane).act;
        fit  = BPM(plane).fit;
        wt   = BPM(plane).wt;

        %%% BUILD UP CELL TO DISPLAY
        ivec = (1:len)';        
        Strcell = cell(11,len);
        Strcell(1,:) = num2cell(ivec);
        Strcell(2,:) = cellstr(BPM(plane).name(ivec,:))';
        Strcell(3:end,:) = num2cell([tstatus(ivec),tavail(ivec),tfit(ivec),ref(ivec), ...
            des(ivec),babs(ivec),act(ivec),fit(ivec),wt(ivec) ])';
        
        %% Speed issue
        % in a workspace : 2.3s
        % in a file : 0.04s
        % in a file and edit in matlab : 0.5s first time then 0.1
        % in a file and edit in nedit  : 0.06s
        
        filename = [SYS.localdata 'bpmdata.txt'];
        fid = fopen(filename,'w');
        fprintf(fid,'%s\n','index    name    stat  avail  ifit     ref        des          abs       act         fit       weight');
        fprintf(fid,'%3d %10s %5d %5d %5d %10.3f %10.3f %12.3f %10.3f %10.3f %10.3f\n',...
            Strcell{:});
        fclose(fid)
        % edit 'bpmdata.txt'        
        system(['nedit ', filename, ' &']);  % much faster
            
%             tic
%         for ii = 1:size(BPM(plane).name,1)
%             fprintf(0,'%3d %10s %5d %5d %5d %10.3f %10.3f %12.3f %10.3f %10.3f %10.3f\n',...
%                 ii, BPM(plane).name(ii,:),tstatus(ii),tavail(ii),tfit(ii),ref(ii), ...
%                 des(ii),babs(ii),act(ii),fit(ii),wt(ii));
%         end
%         toc
        %===========================================================
    otherwise
        disp(['Warning: no CASE found in bpmgui: ' action]);
end  %end switchyard
