function varargout = mcadisplaydemo(ARG,varargin)
%MCADISPLAYDEMO creates a GUI display to monitor PVs
% MCADISPLAYDEMO(PVNAMES)
% PVNAMES is an M-by-N cell array of strings with PV names to monitor
% GUI elements will be arranged on the figure in M rows N coloumns 
% Returns the figure handle

% Calls with a single string argument are callbacks

persistent INUSE thisfigure ButtonHandles ValueBoxHandles CAHandles MonitorStates


if iscellstr(ARG)
    if INUSE
        error('Only one window of MCADISPLAYDEMO is  allowed')
    end
    INUSE = 1;
    
    PVNameBoxHeight    = 15;
    
    PVValueBoxWidth    = 70;
    PVValueBoxHeight   = 15;
    
    ActionButtonWidth  = 70;
    ActionButtonHeight = 15;
    
    HGap = 2;
    VGap = 2;
    
    PVNameBoxWidth     = PVValueBoxWidth + HGap + ActionButtonWidth;
    
    PVBlockWidth  = PVNameBoxWidth;
    PVBlockHeight = PVValueBoxHeight + VGap + PVNameBoxHeight;
    
    SpaceBetweenBlocksHorizontal = 10;
    SpaceBetweenBlocksVertical = 10;
    
    [N,M] = size(ARG);
    ButtonHandles = zeros(1,N*M);
    ValueBoxHandles = zeros(1,N*M);
    CAHandles = zeros(1,N*M);
    MonitorStates = zeros(1,N*M);
    
    reverseindex = (N+1)-(1:N);
    PVNames = ARG(reverseindex,:);
    
    
    
    AllBlocksWidth  = M*PVBlockWidth  + (M-1)*SpaceBetweenBlocksHorizontal;
    AllBlocksHeight = N*PVBlockHeight + (N-1)*SpaceBetweenBlocksVertical;
    
    DistanceFromFigureEdge = 10;
    
    set(0,'Units','points');
    sz = get(0,'ScreenSize');
    
    
    thisfigure = figure('Color', [0.8 0.8 0.8], ...
	'Units','points', ...
	'Position',[sz(3)/2 sz(4)/2 2*DistanceFromFigureEdge+AllBlocksWidth 2*DistanceFromFigureEdge+AllBlocksHeight], ...
	'Tag','Figure1', ...
	'ToolBar','none','Menu','None','HandleVisibility','off','Visible','off');
    
    for n=1:N
        for m = 1:M
            IntIndex = n+(m-1)*N;
            
            CAHandles(IntIndex) = mcaopen(PVNames{n,m});

            if CAHandles(IntIndex)             
                
                % Text box with PV name - don't need to keep track of handles
                NameBoxHandles(IntIndex) = uicontrol('Parent',thisfigure, 'Units','points','FontSize',8,...
                    'BackgroundColor', [0.8 0.8 0.8], ...
                    'Position',[  DistanceFromFigureEdge+(m-1)*(PVBlockWidth+SpaceBetweenBlocksHorizontal) ...
                        DistanceFromFigureEdge+(n-1)*(PVBlockHeight+SpaceBetweenBlocksVertical) + VGap + PVValueBoxHeight, ...
                        PVNameBoxWidth, PVNameBoxHeight],...
                    'String',PVNames{n,m}, 'HorizontalAlignment','left', ...
                    'Style','text');
                               
                % Value Text Box
                ValueBoxHandles(IntIndex) = uicontrol('Parent',thisfigure, 'Units','points','FontSize',8, ...
                    'Position',[  DistanceFromFigureEdge+(m-1)*(PVBlockWidth+SpaceBetweenBlocksHorizontal) ...
                        DistanceFromFigureEdge+(n-1)*(PVBlockHeight+SpaceBetweenBlocksVertical), ...
                        PVValueBoxWidth, PVValueBoxHeight],...
                    'HorizontalAlignment','left','Style','text','BackgroundColor',[1 1 1]);
            
            
            
                % Draw buttons
                ButtonHandles(IntIndex) = uicontrol('Parent',thisfigure, 'Units','points', 'BackgroundColor', [0.8 0.8 0.8], ...
                    'Position',[  DistanceFromFigureEdge+(m-1)*(PVBlockWidth+SpaceBetweenBlocksHorizontal)+HGap+PVValueBoxWidth...
                        DistanceFromFigureEdge+(n-1)*(PVBlockHeight+SpaceBetweenBlocksVertical), ...
                        ActionButtonWidth, ActionButtonHeight],...
                    'String','Monitor','CallBack','mcadisplaydemo buttonclick');
                
                MonitorStates(IntIndex) = 0; % Initially not monitored;
                                
                set(ValueBoxHandles(IntIndex),'String',num2str(mcaget(CAHandles(IntIndex))));
                set(ButtonHandles(IntIndex),'UserData',IntIndex);
                
            else
                uicontrol('Parent',thisfigure, 'Units','points','FontSize',8,...
                    'BackgroundColor', [0.8 0.8 0.8], ...
                    'Position',[  DistanceFromFigureEdge+(m-1)*(PVBlockWidth+SpaceBetweenBlocksHorizontal) ...
                        DistanceFromFigureEdge+(n-1)*(PVBlockHeight+SpaceBetweenBlocksVertical) + VGap + PVValueBoxHeight, ...
                        PVNameBoxWidth, PVNameBoxHeight],...
                    'String',PVNames{n,m}, 'HorizontalAlignment','left', ...
                    'Style','text');
                               
                
                uicontrol('Parent',thisfigure, 'Units','points','FontSize',8, ...
                    'Position',[  DistanceFromFigureEdge+(m-1)*(PVBlockWidth+SpaceBetweenBlocksHorizontal) ...
                        DistanceFromFigureEdge+(n-1)*(PVBlockHeight+SpaceBetweenBlocksVertical), ...
                        PVNameBoxWidth, PVNameBoxHeight ],...
                    'String','Unable to connect', 'HorizontalAlignment','left', ...
                    'Style','text','BackgroundColor',[1 1 1]);
            end
            
           
        end
    end
    
    set(thisfigure,'Visible','on','CloseRequestFcn','mcadisplaydemo exit');
    if nargout==1 
        varargout{1}=thisfigure;
    end

    
elseif ischar(ARG) % evaluate callback
    switch lower(ARG)
    case 'buttonclick'
        IntIndex = get(gcbo,'UserData');
        if MonitorStates(IntIndex)  % PV is monitored, stop monitoring
            mcaclearmon(CAHandles(IntIndex));
            disp('Monitor Cleared');
            set(gcbo,'String','Monitor');
            MonitorStates(IntIndex) = 0;
        else % PV is NOT monitored, start monitoring
            set(gcbo,'String','Stop');
            moncb = ['mcadisplaydemo(''updatevalue'',',num2str(IntIndex),');'];
            if mcamon(CAHandles(IntIndex),moncb)
                disp('Monitor installed');;
            end
            MonitorStates(IntIndex) = 1;
        end
            
    case 'updatevalue'
        IntIndex = varargin{1};       
        set(ValueBoxHandles(IntIndex),'String',num2str(mcacache(CAHandles(IntIndex))));
    case 'exit'
        NH = length(CAHandles);
        for i=1:NH
            if MonitorStates(i)
                mcaclearmon(CAHandles(i));
            end
            %mcaclose(CAHandles(i));
            INUSE = 0;
        end
        delete(thisfigure);
    end     
end