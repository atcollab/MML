function varargout = plotorbit(varargin)
%PLOTORBIT - Plot the present orbit w.r.t. the golden or offset orbit
%  h = plotorbit
%
%  KEYWORDS
%  1. 'Golden' - Plot w.r.t. the golden orbit {Default}
%  2. 'Offset' - Plot w.r.t. the offset orbit
%  3. 'Position' - X-axis is the position along the ring {Default}
%  4. 'Phase'    - X-axis is the phase along the ring

%  Written by Greg Portmann


XAxisFlag = 'Position';
RefFlag = 'Golden';

% Input parsing
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Position')
        XAxisFlag = 'Position';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Phase')
        XAxisFlag = 'Phase';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Golden')
        RefFlag = 'Golden';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Offset')
        RefFlag = 'Offset';
        varargin(i) = [];
    end
end


% Default orbit families
BPMxFamily = gethbpmfamily;
BPMyFamily = getvbpmfamily;


if strcmpi(XAxisFlag, 'Phase')
    [BPMxspos, BPMyspos, Sx, Sy, Tune] = modeltwiss('Phase', BPMxFamily, [], BPMyFamily, []);
    BPMxspos = BPMxspos/2/pi;
    BPMyspos = BPMyspos/2/pi;
    XLabel = 'BPM Phase';
else
    BPMxspos = getspos(BPMxFamily,family2dev(BPMxFamily));
    BPMyspos = getspos(BPMyFamily,family2dev(BPMyFamily));
    XLabel = 'BPM Position [meters]';
end


% Get data
x = getam(BPMxFamily,'struct', varargin{:});
y = getam(BPMyFamily,'struct', varargin{:});


if strcmpi(RefFlag, 'Golden')
    Xref = getgolden(BPMxFamily,family2dev(BPMxFamily), varargin{:});
    Yref = getgolden(BPMyFamily,family2dev(BPMyFamily), varargin{:});
elseif strcmpi(RefFlag, 'Offset')
    Xref = getoffset(BPMxFamily,family2dev(BPMxFamily), varargin{:});
    Yref = getoffset(BPMyFamily,family2dev(BPMyFamily), varargin{:});
else
    error('Reference orbit not unknown');
end


% % Change to physics units
% if any(strcmpi('Physics',varargin))
%     Xref = hw2physics(BPMxFamily, 'Monitor', Xref, family2dev(BPMxFamily));
%     Yref = hw2physics(BPMyFamily, 'Monitor', Yref, family2dev(BPMyFamily));
% end


Xerr = x.Data - Xref;
Yerr = y.Data - Yref;

L = getfamilydata('Circumference');

clf reset
h(1,1) = subplot(2,1,1);
plot(BPMxspos, Xerr, '.-');
%xlabel(XLabel);
ylabel(sprintf('Horizontal [%s]',x.UnitsString));
title(sprintf('Storage Ring Orbit (Difference from the %s Orbit)',RefFlag));
xaxis([0 L]);

h(2,1) = subplot(2,1,2);
plot(BPMyspos, Yerr, '.-');
xlabel(XLabel);
ylabel(sprintf('Vertical [%s]',y.UnitsString));
xaxis([0 L]);

% Link the x-axes
linkaxes(h, 'x');

addlabel(1, 0, datestr(clock,0));
%addlabel(0, 0, sprintf(sprintf('RMS Error: Horizontal %6.4f %s  Vertical %6.4f %s', std(Xerr), x.UnitsString, std(Yerr), y.UnitsString)));
addlabel(0, 0, sprintf(sprintf('RMS Error:   Horizontal %f %s    Vertical %f %s', std(Xerr), x.UnitsString, std(Yerr), y.UnitsString)));

orient tall


if nargout >= 1
    varargout{1} = h;
end
