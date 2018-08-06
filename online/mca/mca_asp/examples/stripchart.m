function varargout = stripchart(varargin)

persistent CAHandle figHandle v y Width tics PV MonTimer

if nargin == 0   

    v=[];
    y=[];
    
    PV = 'SR05S___IBPM2X_AM02';  % ALS BPM
    Width = 60; % seconds
    
    colordef black;
    
    % Main Panel
    %
    figHandle = figure('Units', 'points', ...
  	                   'Tag', 'Figure', ...
                       'Name', PV, ...
                       'DoubleBuffer', 'on', ...
  	                   'ToolBar','none', ...
                       'Menu', 'None', ...
                       'Visible', 'off');
    tics=[-Width:5:0];
    pos = get(figHandle,'position');
    set(figHandle,'position',[pos(1)-60, pos(2)-30, pos(3)+120, pos(4)+60]);
        
    set(figHandle,'Visible','on', 'CloseRequestFcn','stripchart exit');

    % Open the PV and then start the polling for the strip chart.
    %
    CAHandle = mcaopen(PV);
    if ~CAHandle
        errordlg('Unable to open channel.')
    else
        MonTimer = Timer('TimerFcn','stripchart update','Period',0.1,'ExecutionMode','fixedRate');
        start(MonTimer);
    end
else
    switch varargin{1}
        case 'update'
            
            % Get the value of the Process Variable and the Time Stamp
            % and add them into the arrays
            %
            val=mcaget(CAHandle);
            time=mcatime(CAHandle);
            top=size(v,2);
            
            % Only plot if the timestamp (and hence the value) has changed
            %
            if (top < 1 || time ~= v(top))

                y=[y val];
                v=[v time];
                    
                % Massage the values so that they can be plotted
                %
                top=size(v,2);
                z=(v(top)-v)*100000/1.15741;
                range=find(z > Width);
                v(:,range)=[];
                y(:,range)=[];
                x=(v-v(size(v,2)))*100000/1.15741;

                % Plot the arrays on the stripchart
                %
                plot(x,y,'-sy','LineWidth',2,'MarkerSize',3);
                axis([-Width 0 0 11]);
                title('aiExample PV Value','FontWeight','bold');
                grid on;
                ax=get(figHandle,'CurrentAxes');
                set(ax,'xtick',tics);
    
                ylabel(PV);
                xlabel('Time (s)');
            end
            
        case 'exit'
            stop (MonTimer);
            clear MonTimer;
            mcaclose(CAHandle);
            delete(figHandle);
    end
end