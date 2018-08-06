function myprobe(varargin)
persistent thisfigure ValueBoxHandle ButtonHandle CAHandle

if nargin==0
    thisfigure = figure('Color', [0.8 0.8 0.8], ...
	'Units','points', 'Name', 'My standalone application','NumberTitle','off', 'resize', 'off',...
	'Position',[100 100 200 70], ...
	'ToolBar','none','Menu','None');


    ValueBoxHandle = uicontrol('Parent',thisfigure, 'Units','points',...
                    'BackgroundColor', [1 1 1],'Position',[10 10 160 20],'Style','text');
                    
                    
    ButtonHandle = uicontrol('Parent',thisfigure, 'Units','points', ...
                    'Position',[10 30 160 20],...
                    'String','Monitor','CallBack','myprobe1 update');
    
    CAHandle = mcaopen('spr:v4g11/am');
    if CAHandle
        mcamain(150,1,ValueBoxHandle);
    end
    

else
    action = varargin{1};
    switch action
    case 'update'
        val = mcaget(CAHandle);
        set(ValueBoxHandle,'String',num2str(val));
    case 'monitorevent'
        val = mcacache(CAHandle);
        set(ValueBoxHandle,'String',num2str(val));
    end
end      