function m = mclock(varargin)
persistent thisfigure ExitButtonHandle StringBoxHandle TimerID
if nargin==0
    thisfigure = figure('Color', [0.8 0.8 0.8], ...
	'Units','points', 'Position',[100 100 180 50],...
	'Tag','Figure1','CloseRequestFcn','mclock exit',...
	'ToolBar','none','Menu','None','HandleVisibility','off','Visible','off');


    StringBoxHandle = uicontrol('Parent',thisfigure, 'Units','points','FontSize',16,...
                    'BackgroundColor', [1 1 1 ], ...
                    'Position',[10 10 100 20],...
                    'HorizontalAlignment','left', ...
                    'String',datestr(now,13),...
                    'Style','text');


                
    ExitButtonHandle = uicontrol('Parent',thisfigure, 'Units','points', 'BackgroundColor', [0.8 0.8 0.8], ...
                    'Position',[  120 10 50 20],'FontSize',12,...
                    'String','Exit','CallBack','mclock exit');            
  
    TimerID = timereval(2,1000,'mclock update');
                
    set(thisfigure,'Visible','on');

else
    switch lower(varargin{1})
    case 'update'
        set(StringBoxHandle,'String',datestr(now,13));
    case 'exit'
        timereval(5,TimerID);
        delete(thisfigure);
    end
end

