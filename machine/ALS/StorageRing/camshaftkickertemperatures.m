function [T, LabelCell, ChanNames] = camshaftkickertemperatures(DeltaT)
%CAMSHAFTKICKERTEMPERATURES - Temperatures on the camshaft bunch kicker
%  [T, Label, ChanNames] = camshaftkickertemperatures(DeltaT)
%
%  INPUTS
%  1. DeltaT - Time delay between measurements {Default: 5} [seconds]
%              (Only used if no output exist.)
%
%  OUTPUTS
%  1. T - Tempterature vector
%  2. Label - Label cell array
%  3. ChanNames - Channel names
%  Note: if no outputs exists, then data is plotted tio a new figure.
%
%  OPERATIONS NOTES
%  1. It is important closely monitor the kicker temperatures during commissioning.
%     SR02W___TCWAGO_AM10  ->  Feed Thru, Top, Upstream
%     SR02W___TCWAGO_AM11  ->  Feed Thru, Bottom, Upstream
%     SR02W___TCWAGO_AM09  ->  Feed Thru, Top, Downstream
%     SR02W___TCWAGO_AM08  ->  Feed Thru, Bottom, Downstream
%     SR02W___TCWAGO_AM07  ->  Spool, Top, Upstream
%     SR02W___TCWAGO_AM01  ->  Spool, Bottom, Upstream
%
%  EXAMPLES
%  1. To monitor the temperatures every 4 seconds
%     >>  camshaftkickertemperatures(4)
%     Note: Ctrl-C will stop the program.  Since hold will be
%           left on, restarting with continue where it left off.
%
%
%  See also arplot_camshaftkicker

if nargin == 0
    DeltaT = 5;
end


%ChanNames = [
%    'SR02W___TCWAGO_AM10'
%    'SR02W___TCWAGO_AM11'
%    'SR02W___TCWAGO_AM09'
%    'SR02W___TCWAGO_AM08'
%    'SR02W___TCWAGO_AM07'
%    'SR02W___TCWAGO_AM01'
%    ];

% ChanNames = {
%     'SR02W___TCWAGO_AM00', 'TC-1'
%     'SR02W___TCWAGO_AM01', 'TC-2  Chamber'
%     'SR02W___TCWAGO_AM02', 'TC-3'
%     'SR02W___TCWAGO_AM03', 'TC-4'
%     'SR02W___TCWAGO_AM04', 'TC-5'
%     'SR02W___TCWAGO_AM05', 'TC-6'
%     'SR02W___TCWAGO_AM06', 'TC-7'
%     'SR02W___TCWAGO_AM07', 'TC-8  Spool (IW)'
%     'SR02W___TCWAGO_AM08', 'TC-9  Chamber (IW)'
%     'SR02W___TCWAGO_AM09', 'TC-10 Spool (OW)'
%     'SR02W___TCWAGO_AM10', 'TC-11 Spool (T)'
%     'SR02W___TCWAGO_AM11', 'TC-12 Spool (B)'
%     };

% Updated 2008-12-01 (GP - Visual inspection)
ChanNames = {
    %'SR02W___TCWAGO_AM00', 'TC-1'
    'SR02W___TCWAGO_AM01', 'No Label, Chamber (Upstream/Beam Height)'   % #1, Silver TC, no label (should be varified!!!)
    %'SR02W___TCWAGO_AM02', 'TC-3'
    %'SR02W___TCWAGO_AM03', 'TC-4'
    %'SR02W___TCWAGO_AM04', 'TC-5' % Not connected
    %'SR02W___TCWAGO_AM05', 'TC-6'
    %'SR02W___TCWAGO_AM06', 'TC-7'
    'SR02W___TCWAGO_AM07', 'TC-8  Chamber     (Upstream/Top)'           % #3
    'SR02W___TCWAGO_AM08', 'TC-9  Chamber     (Downstream/Beam Height)' % #6
    'SR02W___TCWAGO_AM09', 'TC-10 Feedthru    (Downstream/Top)'         % #5
    'SR02W___TCWAGO_AM10', 'TC-11 Feedthru    (Upstream/Top)'           % #2
    'SR02W___TCWAGO_AM11', 'TC-12 Spool Piece (Upstream/Top)'           % #4
    };


if ischar(DeltaT)
    % Get archived data

    iNotConnected = [];
    %iNotConnected = [0 5 6]+1;
    %iNotConnected = [1 3 4 5 6 7];
    ChanNames(iNotConnected,:) = [];

    if strcmpi(DeltaT, 'BadDay')
        % A famous 2 days
        global ARt ARData ARChanNames ARDate
        arread('20070613');
        ARt1 = ARt;
        ARData1 = ARData;
        arread('20070614');
        ARt = [ARt1 24*60*60+ARt];
        ARData = [ARData1 ARData];

        ChanNames = {
            'SR02W___TCWAGO_AM00', 'TC-1'
            'SR02W___TCWAGO_AM01', 'TC-2  Spool,       Bottom, Upstream'
            'SR02W___TCWAGO_AM02', 'TC-3'
            'SR02W___TCWAGO_AM03', 'TC-4'
            'SR02W___TCWAGO_AM04', 'TC-5'
            'SR02W___TCWAGO_AM05', 'TC-6'
            'SR02W___TCWAGO_AM06', 'TC-7'
            'SR02W___TCWAGO_AM07', 'TC-8  Spool,       Top,      Upstream'
            'SR02W___TCWAGO_AM08', 'TC-9  Feed Thru, Bottom, Downstream'
            'SR02W___TCWAGO_AM09', 'TC-10 Feed Thru, Top,     Downstream'
            'SR02W___TCWAGO_AM10', 'TC-11 Feed Thru, Top,     Upstream'
            'SR02W___TCWAGO_AM11', 'TC-12 Feed Thru, Bottom, Upstream'
            };

        iNotConnected = [1 3 4 5 6 7];
        ChanNames(iNotConnected,:) = [];

    elseif strcmpi(DeltaT, 'Interesting')
        % No kicker, lots of heating
        global ARt ARData ARChanNames ARDate
        arread('20070718');
        ARt1 = ARt;
        ARData1 = ARData;
        arread('20070719');
        ARt2 = ARt;
        ARData2 = ARData;
        arread('20070720');
        ARt = [ARt1 24*60*60+ARt2 48*60*60+ARt];
        ARData = [ARData1 ARData2 ARData];
    else
        %arread('20070712');
        %arread('20070720');
        arread(DeltaT);
    end


    clf reset
    subplot(4,1,1);
    DCCT = arplot(family2channel('DCCT'));
    h(1) = gca;
    xlabel('');
    ylabel('mAmps');

    subplot(4,1,[2 3 4]);
    y=arplot(cell2mat(ChanNames(:,1)));
    h(2) = gca;
    ylabel('Degrees [C]');
    title('');
    legend(ChanNames(:,2), 0);

    set(h(1),'XTickLabel','');
    linkaxes(h,'x');
    yaxesposition(1.05);

    axis(h(1),'tight');
    axis(h(2),'tight');
    a = axis(h(1));
    if a(3) < 0
        axis(h(1),[a(1) a(2) 0 a(4)]);
    end

    orient landscape

    return
end


% If no outputs exist then plot the data
if nargout == 0
    fprintf('   Monitoring camshaft bunch kicker temperatures every %.1f seconds.  Ctrl-C to stop.\n', DeltaT);
    H_axes = camkickertempplot;
    hold on;
    while 1
        pause(DeltaT);
        camkickertempplot(H_axes);
    end
    return
end


% ChanNames = [
%     'SR02W___TCWAGO_AM10'
%     'SR02W___TCWAGO_AM11'
%     'SR02W___TCWAGO_AM09'
%     'SR02W___TCWAGO_AM08'
%     'SR02W___TCWAGO_AM07'
%     'SR02W___TCWAGO_AM01'
%     ];
% LabelCell = {
%     'Feed Thru, Top, Upstream'
%     'Feed Thru, Bottom, Upstream'
%     'Feed Thru, Top, Downstream'
%     'Feed Thru, Bottom, Downstream'
%     'Spool, Top, Upstream'
%     'Spool, Bottom, Upstream'
%     };

LabelCell = ChanNames(:,2);
ChanNames = cell2mat(ChanNames(:,1));

T = getpv(ChanNames);



function H_axes = camkickertempplot(H_axes)

if nargin == 0
    H_axes = gca;
end

NextPlot = get(H_axes, 'NextPlot');

[T, LabelCell, ChanNames] = camshaftkickertemperatures;

Time = datenum(clock);
axes(H_axes);
plot(Time, T,'.');
hold on;

% plot(Time, T(1),'.b');
% hold on;
% plot(Time, T(2),'.g');
% plot(Time, T(3),'.r');
% plot(Time, T(4),'.c');
% plot(Time, T(5),'.m');
% plot(Time, T(6),'.k');

datetick('x');
a = axis;
axis tight;
xaxis(a(1:2));
set(gca, 'NextPlot', NextPlot);

if ~strcmpi(NextPlot, 'Add');
    xlabel('Time');
    ylabel('Temperature [C]');
    title('Camshaft Bunch Kicker Thermocouples');
    legend(LabelCell);
end

drawnow;


