function varargout = example2(varargin)

persistent CAHandle figHandle valueBoxHandle

if nargin == 0   
    
    PV = 'epicsadminHost:aiExample2';
    
    % Graphics
    %
    HGap = 2;
    VGap = 2;
   
    PVNameBoxHeight    = 15;
    PVNameBoxWidth     = 150;
    PVValueBoxWidth    = 70;
    PVValueBoxHeight   = 15;

    PVBlockWidth       = PVNameBoxWidth + HGap + PVValueBoxWidth;
    PVBlockHeight      = max([PVNameBoxHeight PVValueBoxHeight]);
    
    ExitButtonWidth  = 70;
    ExitButtonHeight = 40;
    
    SpaceBetweenButtonAndPV = 10;
    
    DistanceFromFigureEdge = 10;
    set(0,'units','points');
    sz = get(0,'ScreenSize');
    
    % Main Panel
    %
    figHandle = figure('Color', [0.8 0.8 0.8], ...
	                   'Units', 'points', ...
	                   'Position', [sz(3)/2 sz(4)/2 2*DistanceFromFigureEdge+PVBlockWidth 2*DistanceFromFigureEdge+PVBlockHeight+SpaceBetweenButtonAndPV+ExitButtonHeight], ...
	                   'Tag', 'Figure', ...
                       'Resize', 'off', ...
                       'Name', PV, ...
	                   'ToolBar','none', ...
                       'Menu', 'None', ...
                       'HandleVisibility', 'off', ...
                       'Visible', 'off');
    
    % PV name field
    %
    nameBoxHandle = uicontrol('Parent', figHandle, ...
                              'Units', 'points', ...
                              'FontSize', 12, ...
                              'BackgroundColor', [0.8 0.8 0.8], ...
                              'Position', [DistanceFromFigureEdge DistanceFromFigureEdge+ExitButtonHeight+SpaceBetweenButtonAndPV PVNameBoxWidth PVNameBoxHeight], ...
                              'String', [PV ':'], ...
                              'HorizontalAlignment','left', ...
                              'Style','text');

    % PV value field
    %
    valueBoxHandle = uicontrol('Parent', figHandle, ...
                               'Units', 'points', ...
                               'FontSize', 12, ...
                               'Position', [DistanceFromFigureEdge+PVNameBoxWidth+HGap DistanceFromFigureEdge+ExitButtonHeight+SpaceBetweenButtonAndPV PVValueBoxWidth PVValueBoxHeight], ...
                               'HorizontalAlignment', 'left', ...
                               'Style', 'text', ...
                               'BackgroundColor', [1 1 1]);
    % Exit Button
    %
    buttonHandle = uicontrol('Parent', figHandle, ...
                             'Units', 'points', ...
                             'BackgroundColor', [0.8 0.8 0.8], ...
                             'Position', [DistanceFromFigureEdge DistanceFromFigureEdge ExitButtonWidth, ExitButtonHeight], ...
                             'String', 'Exit', ...
                             'Fontsize', 12, ...
                             'CallBack', 'example2 exit');
                           
    set(figHandle,'Visible','on','CloseRequestFcn', 'example2 exit');

    % PV Stuff
    %
    CAHandle = mcaopen(PV);
    if ~CAHandle
        errordlg('Unable to open channel.')
    else
        sts = mcamon(CAHandle, 'example2 go');
        if ~sts
            errordlg('Unable to create monitor.')
        end
    end
else
    switch varargin{1}
        case 'go'
            set(valueBoxHandle, 'String', num2str(mcacache(CAHandle)));    
            Alarm = mcaalarm(CAHandle);
            switch num2str(Alarm.severity)
                case '1'
                    set(valueBoxHandle, 'BackgroundColor', [1 1 0]);    
                case '2'
                    set(valueBoxHandle, 'BackgroundColor', [1 0 0]);    
                otherwise
                    set(valueBoxHandle, 'BackgroundColor', [1 1 1]);    
            end
                    
        case 'exit'
            mcaclearmon(CAHandle);
            mcaclose(CAHandle);
            delete(figHandle);
    end
end