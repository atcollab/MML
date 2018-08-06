function [c, FileName] = plotchro(varargin)
%PLOTCHRO - Plot the chromaticity function
%  c = plotchro(c);
%  c = plotchro(c, 'Hardware');  plots in hardware units [Tune/MHz]
%  c = plotchro(c, 'Physics');   plots in physics  units [Tune/(dp/p)]
%  c = plotchro(FileName);
%  [c, FileName] = plotchro(''); prompts for a file
%
%  c is the chromacity structure returned by measchro
%
%  Note 1: 'Zeta' can be used instead of 'Physics'
%  Note 2: The default units comes from the structure c.Units
%
%  See also measchro

%  Written by Greg Portmann and Jeff Corbett


c = [];
PhysicsString = '';
FileName = '';


% Input parsing
UnitsFlag = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Zeta') || strcmpi(varargin{i},'Physics')
        UnitsFlag = [UnitsFlag varargin(i)];
        %if length(varargin) >= i+1         % Not using these inputs at the moment
        %    if isnumeric(varargin{i+1})
        %        MCF = varargin{i+1};
        %        if length(varargin) >= i+2
        %            if isnumeric(varargin{i+2})
        %                RF0 = varargin{i+2};
        %                varargin(i+2) = [];    
        %            end
        %        end
        %        varargin(i+1) = [];    
        %    end
        %end
        varargin(i) = [];    
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlag = [UnitsFlag varargin(i)];
        varargin(i) = [];    
    end
end


if length(varargin) >= 1
    if isstruct(varargin{1})
        c = varargin{1};
    elseif ischar(varargin{1})
        FileName = varargin{1};
    end
end
if isempty(c)
    [c, FileName] = getchro(FileName, 'Struct', UnitsFlag{:});
end
if ~isstruct(c)  
    error('Input must be a structure as returned by measchro');
end


Chromaticity = c.Data;
Tune =  c.Tune;
Units = c.Units;
UnitsString = c.UnitsString;
DeltaRF = c.ActuatorDelta;        


% Override the Units field
if isempty(UnitsFlag)
    PhysicsString = Units;
else
    PhysicsString = UnitsFlag{1};
end


if strcmpi(Units, 'Hardware')
    if strcmpi(PhysicsString,'Physics')
        % Change units to physics
        % MCF = c.MCF;
        % RF0 = c.Actuator.Data;
        % p = polyfit(c.dp, Tune(1,:), 2);
        % c.PolyFit(1,:) = p;
        % c.Data(1,1) = p(2);
        % p = polyfit(c.dp, Tune(2,:), 2);
        % c.PolyFit(2,:) = p;
        % c.Data(2,1) = p(2);
        % c.Units = 'Physics';
        % c.UnitsString = '1/(dp/p)';
        c = hw2physics(c);
        plotchro(c);
        return
    end
    
    %================================================
    % Tune shift vs. rf frequency
    %================================================
    x2 = linspace(min(DeltaRF), max(DeltaRF), 1000);
    
    clf reset
    set(gcf,'NumberTitle','on','Name','Tune Shift vs. RF Frequency');
    subplot(2,1,1);
    if strcmpi(c.Actuator.UnitsString,'MHz')
        % Hz is easier to view
        plot(1e6*DeltaRF, Tune(1,:), 'ob','markersize',2);   % plot raw tune data 
    else
        plot(DeltaRF, Tune(1,:), 'ob','markersize',2);   % plot raw tune data 
    end
    hold on;
    p = c.PolyFit(1,:);
    y = polyval(p, x2);                  % evaluate polynomial on equispaced points x2
    if strcmpi(c.Actuator.UnitsString,'MHz')
        plot(1e6*x2, y, '-b');                   % plot polynomial fit
        xlabel('RF Frequency Change [Hz]');
    else
        plot(x2, y, '-b');                   % plot polynomial fit
        xlabel(sprintf('RF Frequency Change [%s]', c.Actuator.UnitsString));
    end
    hold off;
    title([num2str(p(1)),' x (drf/rf)^2  + ',num2str(p(2)),' x drf/rf  + ',num2str(p(3))]);
    ylabel('Horizontal Tune');
    
    subplot(2,1,2);
    if strcmpi(c.Actuator.UnitsString,'MHz')
        plot(1e6*DeltaRF, Tune(2,:), 'ob','markersize',2);   % plot raw tune data 
    else
        plot(DeltaRF, Tune(2,:), 'ob','markersize',2);       % plot raw tune data 
    end
    hold on;
    p = c.PolyFit(2,:);
    y = polyval(p, x2);
    if strcmpi(c.Actuator.UnitsString,'MHz')
        plot(1e6*x2, y, '-b');                   % plot polynomial fit
        xlabel('RF Frequency Change [Hz]');
    else
        plot(x2, y, '-b');                       % plot polynomial fit
        xlabel(sprintf('RF Frequency Change [%s]', c.Actuator.UnitsString));
    end    
    hold off;
    title([num2str(p(1)),' x (drf/rf)^2  + ',num2str(p(2)),' x drf/rf  + ',num2str(p(3))]);
    ylabel('Vertical Tune');
    if any(strcmpi(c.Monitor.Mode, {'Model','Simulator'}))
        addlabel(1,0,sprintf('%s (Model)', datestr(c.TimeStamp,0)));
    else
        addlabel(1,0,sprintf('%s', datestr(c.TimeStamp,0)));        
    end
    orient tall
    
elseif strcmpi(Units, 'Physics')
    if strcmpi(PhysicsString,'Hardware')
        % Change units to hardware
        %MCF = c.MCF;
        %RF0 = c.Actuator.Data;
        %p = polyfit(DeltaRF, Tune(1,:), 2);
        %c.PolyFit(1,:) = p;
        %c.Data(1,1) = p(2);
        %p = polyfit(DeltaRF, Tune(2,:), 2);
        %c.PolyFit(2,:) = p;
        %c.Data(2,1) = p(2);
        %c.Units = 'Hardware';
        %c.UnitsString = c.Actuator.UnitsString;
        c = physics2hw(c);
        
        plotchro(c);
        return
    end

    %================================================
    % Tune shift vs. momentum    
    %================================================
    x2 = linspace(min(c.dp), max(c.dp), 1000);     %create momentum value interval
    
    clf reset
    set(gcf,'NumberTitle','on','Name','Tune Shift vs. Momentum ');
    subplot(2,1,1);
    plot(100*c.dp,Tune(1,:), 'ob','markersize',2);   %raw data
    hold on;
    p = c.PolyFit(1,:);
    y = polyval(p, x2);                          %evaluate polynomial on equispaced points x2
    plot(100*x2, y, '-b');                       %plot polynomial fit
    hold off;
    xlabel('Momentum Shift, dp/p [%]')
    title([num2str(p(1)),' (dp/p)^2  + ',num2str(p(2)),' dp/p  + ',num2str(p(3))]);
    ylabel('Horizontal Tune');
    
    subplot(2,1,2);
    plot(100*c.dp,Tune(2,:),'ob','markersize',2);
    hold on;
    p = c.PolyFit(2,:);
    y = polyval(p, x2);
    plot(100*x2, y, '-b');
    hold off;
    
    xlabel('Momentum Shift, dp/p [%]')
    title([num2str(p(1)),' (dp/p)^2  + ',num2str(p(2)),' dp/p  + ',num2str(p(3))]);
    ylabel('Vertical Tune');
    if any(strcmpi(c.Monitor.Mode, {'Model','Simulator'}))
        addlabel(1,0,sprintf('%s (Model)', datestr(c.TimeStamp,0)));
    else
        addlabel(1,0,sprintf('%s', datestr(c.TimeStamp,0)));        
    end
    %addlabel(1,0,sprintf('%s', datestr(c.TimeStamp,0)));
    orient tall
    
else
    error('UnitsString unknown type');
end    