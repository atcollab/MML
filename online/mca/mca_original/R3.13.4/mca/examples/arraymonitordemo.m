function arraymonitordemo(COMMANDSTR,varargin)
%MCAARRAYMONITORDEMO('init','PVName')

persistent thisfigure ExitButtonHandle AxisHandle LineHandle CAHandle
if ischar(COMMANDSTR)
   switch lower(COMMANDSTR)
   case 'init'
        CAHandle=mcaopen(varargin{1});
        if ~CAHandle
            error('could not connect to PV');
        end
        monstatus=mcamon(CAHandle);
        if ~monstatus
            error('Could not install a monitor');
        end
        A = mcacache(CAHandle);
        L = length(A);
        % Draw figure 
        thisfigure = figure;
        set(thisfigure,'MenuBar','none','DoubleBuffer','on',...
            'Name','Channel Access Array Monitor','CloseRequestFcn','arraymonitordemo exit');
        AxisHandle = axes;
        
        set(AxisHandle,'XLim',[1,L]);
        set(AxisHandle,'YLim',[-1 1]);

        LineHandle = line(1:L,A);
        
        set(LineHandle,'Color','red','Marker','.');
        
        mcamon(CAHandle,'arraymonitordemo update');

        xlabel('Sample #');
        ylabel('Amplitude [mV]');
        set(thisfigure,'HandleVisibility','off');
    case 'update'
        set(LineHandle,'YData',mcacache(CAHandle));
        
    case 'exit'
        mcaclearmon(CAHandle);
        delete(thisfigure);
    end
    
end
