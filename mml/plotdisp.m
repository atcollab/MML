function [DxOut, DyOut, FileName] = plotdisp(varargin)
%PLOTDISP - Plots the dispersion function 
%
%  For structure inputs:
%  [Dx, Dy] = plotdisp(Dx, Dy)               Plots in the units stored in the structure
%  [Dx, Dy] = plotdisp(FileName)             Plots in the units stored in a file ('' to browse)
%  [Dx, Dy] = plotdisp(Dx, Dy,'Hardware')    Plots in hardware units (converts if necessary)
%  [Dx, Dy] = plotdisp(Dx, Dy,'Physics')     Plots in physics  units (converts if necessary)
%
%  When not using structure inputs, assumptions have to be made about the units
%  This function assumes that hardware units are mm/MHz and physics units are meters/Hz
%  [Dx,Dy] = plotdisp(Dx, Dy)                   Assumes that the units of Dx,Dy are mm/MHz
%  [Dx,Dy] = plotdisp(Dx, Dy, 'Physics')        Assumes that the units of Dx,Dy are m/(dp/p) (no conversion)
%                                             ie, was measured using [Dx, Dy] = measdisp('Physics')
%  [Dx,Dy] = plotdisp(Dx, Dy, 'Physics',mcf,rf) Converts Dx,Dy from mm/MHz to m/(dp/p)
%                                             ie, was measured using [Dx, Dy] = measdisp('Hardware')
%
%  INPUTS
%  1. d (dispersion structure) or Dx and Dy (vectors) as measure by measdisp
%  2. 'Physics'  is a flag to plot dispersion function in physics units
%     'Hardware' is a flag to plot dispersion function in hardware units
%     ('Eta' can be used instead of 'Physics')
%  3. mcf = momentum compaction factor (linear)
%  4. rf  = rf frequency (MHz)
%     rf and mcf input are only for nonstructure inputs when using the 'Physics' flag
%
%  OUTPUT
%  1. [Dx, Dy] is the dispersion function which may be different from the input
%     if units were changed.
%
%  NOTE
%  1. 'Hardware' and 'Physics' are not case sensitive
%
%  See also measdisp, getdisp

%  Written by William J. Corbett and Greg Portmann
%  Modified by Laurent S. Nadolski
%  More generic, Eta option was not working


MCF = [];
RF0 = [];
FileName = -1;
Dx = [];
Dy = [];
ModeString = '';

BPMxFamily = gethbpmfamily;
BPMyFamily = getvbpmfamily;

% Input parsing
UnitsFlag = {};
%UnitsFlag = {'Physics'};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignore structures
    elseif iscell(varargin{i})
        % Ignore cells
    elseif strcmpi(varargin{i},'Eta') || strcmpi(varargin{i},'Physics')
        UnitsFlag = {'Physics'};
        varargin(i) = [];
        if length(varargin) >= i         % Not sure if I'm using these inputs at the moment
            if isnumeric(varargin{i})
                MCF = varargin{i};
                if length(varargin) >= i+1
                    if isnumeric(varargin{i+1})
                        RF0 = varargin{i+1};
                        varargin(i+1) = [];    
                    end
                end
                varargin(i) = [];    
            end
        end
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlag = varargin(i);
        varargin(i) = [];    
    end
end


% Check if the input is a structure
if isempty(varargin)
elseif ischar(varargin{1})
    FileName = varargin{1};
elseif length(varargin) < 2
    error('Dx and Dy dispersion or a filename input are required.');
else
    if (isstruct(varargin{1}) || isnumeric(varargin{1})) && (isstruct(varargin{2}) || isnumeric(varargin{2})) 
        Dx = varargin{1};
        Dy = varargin{2};
    else
        error('Dx and Dy dispersion or a filename input are required.');
    end
end

if isempty(Dx)
    if ischar(FileName)
        [Dx, FileName] = getdisp(BPMxFamily, 'Struct', FileName, UnitsFlag{:});
    else
        [Dx, FileName] = getdisp(BPMxFamily, 'Struct', UnitsFlag{:});
    end
    if isempty(FileName) || ~ischar(FileName)
        return;
    else
        Dy = getdisp(BPMyFamily, FileName, 'Struct', UnitsFlag{:});
    end
end

if isstruct(Dx)
    if isempty(UnitsFlag)
        UnitsFlag = Dx.Units;
    end
    ModeString = Dx.Monitor.Mode;
    
    MCF = Dx.MCF;
    if strcmpi(UnitsFlag,'Physics') && strcmpi(Dx.Units,'Hardware')
        % Change to physics units
        Dx = hw2physics(Dx);
    end        
    if strcmpi(UnitsFlag,'Physics') && strcmpi(Dy.Units,'Hardware')
        % Change to physics units
        Dy = hw2physics(Dy);
    end
    % Change to denominator to energy shift (dp/p)
    %RF0 = Dx.Actuator.Data;    
    %RF0 = RF0(1);  % Just in case someone has a vector for multiple cavities
    %Dx.Data = -RF0 * MCF * Dx.Data;
    %Dy.Data = -RF0 * MCF * Dy.Data;
    %
    %Dx.UnitsString = [Dx.Monitor.UnitsString,'/(dp/p)'];
    %Dy.UnitsString = [Dy.Monitor.UnitsString,'/(dp/p)'];
    
    if strcmpi(UnitsFlag,'Hardware') && strcmpi(Dx.Units,'Physics')
        % Change to hardware units
        Dx = physics2hw(Dx);
    end
    if strcmpi(UnitsFlag,'Hardware') && strcmpi(Dy.Units,'Physics')
        % Change to hardware units
        Dy = physics2hw(Dy);
    end
    % Change to denominator to RF change
    %RF0 = Dx.Actuator.Data;    
    %RF0 = RF0(1);  % Just in case someone has a vector for multiple cavities
    %Dx.Data = Dx.Data / (-RF0 * MCF);
    %Dy.Data = Dy.Data / (-RF0 * MCF);
    % Change to hardware units
    %Dx = physics2hw(Dx);
    %Dy = physics2hw(Dy);
    %Dx.UnitsString = [Dx.Monitor.UnitsString,'/',Dx.Actuator.UnitsString];
    %Dy.UnitsString = [Dy.Monitor.UnitsString,'/',Dy.Actuator.UnitsString];
    
    DeltaRF = Dx.ActuatorDelta;        
    TimeStamp = Dx.TimeStamp;
    
    if isempty(strfind(Dx.UnitsString,'dp'))
        TitleString = sprintf('"Dispersion" Function: %s  (\\Deltaf=%g %s)', texlabel('{Delta}Orbit / {Delta}f'), DeltaRF, Dx.Actuator.UnitsString);
    else
        TitleString = sprintf('Dispersion Function: %s  (\\alpha=%.5f, f=%f %s, \\Deltaf=%g %s)', texlabel('-alpha f {Delta}Orbit / {Delta}f'), MCF, Dx.Actuator.Data, Dx.Actuator.UnitsString, DeltaRF, Dx.Actuator.UnitsString);
    end
    
    
    % Plot dispersion
    if isfamily(Dx.Monitor.FamilyName)
        sx = getspos(Dx.Monitor.FamilyName,Dx.Monitor.DeviceList);
        X1LabelString = sprintf('%s Position [meters]', Dx.Monitor.FamilyName);
    elseif strcmpi(Dx.Monitor.FamilyName, 'all');
        global THERING
        sx = findspos(THERING, 1:length(THERING)+1);
        X1LabelString = 'Position [meters]';
    else
        sx = 1:length(Dx.Data);
        X1LabelString = 'BPM Number';
        
        global THERING
        if ~isempty(THERING)
            Index = findcells(THERING, 'FamName', Dx.Monitor.FamilyName);
            if ~isempty(Index)
                sx = findspos(THERING, Index);
                X1LabelString = sprintf('%s Position [meters]', Dx.Monitor.FamilyName);
            end
        end
    end
    
    if isfamily(Dy.Monitor.FamilyName)
        sy = getspos(Dy.Monitor.FamilyName, Dy.Monitor.DeviceList);
        X2LabelString = sprintf('%s Position [meters]', Dy.Monitor.FamilyName);
    elseif strcmpi(Dy.Monitor.FamilyName, 'all');
        global THERING
        sy = findspos(THERING, 1:length(THERING)+1);
        X2LabelString = 'Position [meters]';
    else
        sy = 1:length(Dy.Data);
        X2LabelString = 'BPM Number';
        
        global THERING
        if ~isempty(THERING)
            Index = findcells(THERING, 'FamName', Dy.Monitor.FamilyName);
            if ~isempty(Index)
                sy = findspos(THERING, Index);
                X2LabelString = sprintf('%s Position [meters]', Dy.Monitor.FamilyName);
            end
        end
    end
    
    Y1LabelString = sprintf('Horizontal [%s]', Dx.UnitsString);
    Y2LabelString = sprintf('Vertical [%s]', Dx.UnitsString);
    
    DxOut = Dx;
    DyOut = Dy;
    
    Dx = Dx.Data;
    Dy = Dy.Data;
else
    % Non structure inputs
    if nargin == 2 || nargin == 3 || nargin == 5
        % OK
    else
        error('2, 3, or 5 inputs required');
    end
        
    if isempty(UnitsFlag)
        UnitsFlag = 'Physics';
    end

    if strcmpi(UnitsFlag,'Physics')
        Y1LabelString = sprintf('Horizontal [m/(dp/p)]');
        Y2LabelString = sprintf('Vertical [m/(dp/p)]');
        
        % Convert to physics units (if RF0 and MCF were not input, then assume that the units were already in mm/(dp/p))
        if ~isempty(RF0) && ~isempty(MCF)
            TitleString = sprintf('Dispersion Function: %s  (\\alpha=%f, f=%f)', texlabel('-alpha f {Delta}Orbit / {Delta}f'), MCF, RF0);
            % Change units to meters/(dp/p)
            Dx = -RF0(1) * MCF * Dx / 1000;
            Dy = -RF0(1) * MCF * Dy / 1000;
        else
            TitleString = sprintf('Dispersion Function: %s', texlabel('-alpha f {Delta}Orbit / {Delta}f'));
        end     
    else
        TitleString = sprintf('"Dispersion" Function: %s', texlabel('{Delta}Orbit / {Delta}f'));
        Y1LabelString = sprintf('Horizontal [mm/MHz]');
        Y2LabelString = sprintf('Vertical [mm/MHz]');                 
    end
    
    % Plot dispersion in terms of mm/MHz
    sx = 1:length(Dx);
    sy = 1:length(Dy);
    X1LabelString = 'BPM Number';
    X2LabelString = 'BPM Number';
    
    DxOut = Dx;
    DyOut = Dy;
end


% Plot
clf reset
%set(gcf,'NumberTitle','On','Name','Dispersion');

h(1) = subplot(2,1,1);
if length(Dx) > 125
    plot(sx, Dx, 'b');
else
    plot(sx, Dx, '.-b');
end
xlabel(X1LabelString);
ylabel(Y1LabelString);
title(TitleString);
grid on;

h(2) = subplot(2,1,2);
if length(Dy) > 125
    plot(sy, Dy, 'b');
else
    plot(sy, Dy, '.-b');
end
xlabel(X2LabelString);
ylabel(Y2LabelString);
grid on;

L = getfamilydata('Circumference');
if ~isempty(L)
    xaxiss([0 L]);
end

% Link the x-axes
linkaxes(h, 'x');

orient tall

if exist('TimeStamp','var')
    %addlabel(1,0,sprintf('%s', datestr(TimeStamp,0)));
    if any(strcmpi(ModeString, {'Model','Simulator'}))
        addlabel(1,0,sprintf('%s (Model)', datestr(TimeStamp,0)));
    else
        addlabel(1,0,sprintf('%s', datestr(TimeStamp,0)));        
    end
end

if FileName == -1
    FileName = [];
end