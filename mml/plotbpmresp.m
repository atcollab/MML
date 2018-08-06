function plotbpmresp(varargin)
%PLOTBPMRESP - Plots the orbit response matrix in various ways
%  plotbpmresp
%
%  INPUTS
%  1. 'Absolute' {Default} or 'Error' (subtract the model)
%  2. PlotType: '3D', 'Rows', 'Columns', 'CMSpace', 'BPMSpace'  {Default: '3D'}
%  3. Plane:   'All', 'xx', 'xy', 'yx', 'yy'  {Default: 'All' for '3D', else 'xx'}
%                  or 'xz', 'zx', 'zz', 'zz'
%  4. Filename (or '' for a dialog box)
%
%  NOTE
%  1. PlotType = 'Rows' or 'Columns' can take a long time to generate
%  2. 'ColumnSpace' and 'BPMSpace' are the same
%     'RowSpace' and 'CMSpace' are the same
%  3. Plane = 'All' can only be used on PlotType = '3D'
%  4. Use popplot to expand a subplot to full size.

%  Written by Greg Portmann
%  Adapted by Laurent S. Nadolski

R = '';
PlotType = '3D';
Plane = 'All';
ErrorFlag = 0;


% Input parsing
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Response matrix
        R = varargin(i);
        varargin(i) = [];
    elseif iscell(varargin{i})
        % Just remove
        varargin(i) = [];
    elseif any(strcmpi(varargin(i),{'Absolute','Abs'}))
        ErrorFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin(i),'Error')
        ErrorFlag = 1;
        varargin(i) = [];
    elseif any(strcmpi(varargin(i),{'3D'}))
        PlotType = '3D';
        varargin(i) = [];
    elseif any(strcmpi(varargin(i),{'Row','Rows'}))
        PlotType = 'Rows';
        varargin(i) = [];
    elseif any(strcmpi(varargin(i),{'Col','Cols','Column','Columns'}))
        PlotType = 'Columns';
        varargin(i) = [];
    elseif any(strcmpi(varargin(i),{'RowSpace','CMSpace'}))
        PlotType = 'CMSpace';
        varargin(i) = [];
    elseif any(strcmpi(varargin(i),{'ColumnSpace','BPMSpace'}))
        PlotType = 'BPMSpace';
        varargin(i) = [];
    elseif any(strcmpi(varargin(i),{'x','xx','horizontal'}))
        Plane = 'xx';
        varargin(i) = [];
    elseif any(strcmpi(varargin(i),{'y','yy','z','zz','vertical'}))
        Plane = 'yy';
        varargin(i) = [];
    elseif any(strcmpi(varargin(i),{'xy','xz'}))
        Plane = 'xy';
        varargin(i) = [];
    elseif any(strcmpi(varargin(i),{'yx','zx'}))
        Plane = 'yx';
        varargin(i) = [];
    elseif any(strcmpi(varargin(i),{'All'}))
        Plane = 'All';
        varargin(i) = [];
    elseif ischar(varargin{i})
        % Filename
        R = getbpmresp('FileName', varargin{i}, 'Struct', 'NoEnergyScaling');
        varargin(i) = [];
    end
end


if isempty(R)
    R = getbpmresp('Struct', 'NoEnergyScaling');
end
if isempty(R)
    fprintf('   Response matrix not found.\n');
    return;
end


if ErrorFlag
    % Plot the difference between the measured and model
    m = measbpmresp('Model','Struct');
    R(1,1).Data = R(1,1).Data - m(1,1).Data;
    R(1,2).Data = R(1,2).Data - m(1,2).Data;
    R(2,1).Data = R(2,1).Data - m(2,1).Data;
    R(2,2).Data = R(2,2).Data - m(2,2).Data;
end


hfig = gcf;
%clf reset

if strcmpi(PlotType, '3D')

    % 3-D response matrix plot
    if strcmpi(Plane, 'All')
        surf([R(1,1).Data R(1,2).Data; R(2,1).Data R(2,2).Data]);
        %surf([R(1,1).Data R(1,2).Data; R(2,1).Data R(2,2).Data], 'LineStyle', 'None');
        %alpha(0.5);
        xlabel('CM Number');
        ylabel('BPM Number');
        if isfield(R(1,1),'UnitsString')
            zlabel(R(1,1).UnitsString);
        end
    elseif strcmpi(Plane, 'xx')
        surf([R(1,1).Data]);
        xlabel('HCM Number');
        ylabel('BPMx Number');
        if isfield(R(1,1),'UnitsString')
            zlabel(R(1,1).UnitsString);
        end
    elseif strcmpi(Plane, 'xy')
        surf([R(1,2).Data]);
        xlabel('VCM Number');
        ylabel('BPMx Number');
        if isfield(R(1,2),'UnitsString')
            zlabel(R(1,2).UnitsString);
        end
    elseif strcmpi(Plane, 'yx')
        surf([R(2,1).Data]);
        xlabel('HCM Number');
        ylabel('BPMy Number');
        if isfield(R(2,1),'UnitsString')
            zlabel(R(2,1).UnitsString);
        end
    elseif strcmpi(Plane, 'yy')
        surf([R(2,2).Data]);
        xlabel('VCM Number');
        ylabel('BPMy Number');
        if isfield(R(2,2),'UnitsString')
            zlabel(R(2,2).UnitsString);
        end
    end
    view(-70, 65);
    if isfield(R(1,1), 'TimeStamp')
        addlabel(1,0,sprintf('%s', datestr(R(1,1).TimeStamp)));
    end

    if ErrorFlag
        % Measured - Model
        title('Orbit Response Matrix Error (Measured-Model)');
    else
        % Absolute response matrix plot
        title('Orbit Response Matrix');
    end

elseif strcmpi(PlotType,'Columns')
    set(gcf, 'Units', get(0, 'Units'));
    Pfig = get(gcf, 'Position');
    set(gcf, 'Position', get(0, 'ScreenSize'));

    NSectors = R(1,1).Monitor.DeviceList(end,1);
    NBPMxperSector = max(R(1,1).Monitor.DeviceList(:,2));
    NBPMyperSector = max(R(2,2).Monitor.DeviceList(:,2));

    NBPMx = size(R(1,1).Data,1);
    NBPMy = size(R(2,2).Data,1);

    NHCMperSector = max(R(1,1).Actuator.DeviceList(:,2));
    NVCMperSector = max(R(2,2).Actuator.DeviceList(:,2));

    if strcmpi(Plane, 'xx') || strcmpi(Plane, 'All')
        s = getspos(R(1,1).Monitor.FamilyName, R(1,1).Monitor.DeviceList);
        for i = 1:NSectors
            for j = 1:NHCMperSector
                Index = findrowindex([i j], R(1,1).Actuator.DeviceList);
                if ~isempty(Index)
                    figure(hfig);
                    subplot(NSectors, NHCMperSector, (i-1)*NHCMperSector + j);
                    plot(s, R(1,1).Data(:,Index));
                    %axis tight
                    set(gca,'XTickLabel','');
                    set(gca,'YTickLabel','');
                end
            end
        end
        addlabel(.5, 1, 'Horizontal Orbit Response Matrix Columns',12);
        addlabel(.5, 0, 'Horizontal Magnet Device Number', 10);

    elseif strcmpi(Plane, 'xy')
        s = getspos(R(1,2).Monitor.FamilyName, R(1,2).Monitor.DeviceList);
        for i = 1:NSectors
            for j = 1:NVCMperSector
                Index = findrowindex([i j], R(1,2).Actuator.DeviceList);
                if ~isempty(Index)
                    figure(hfig);
                    subplot(NSectors, NVCMperSector, (i-1)*NVCMperSector + j);
                    plot(s, R(1,2).Data(:,Index));
                    %axis tight
                    set(gca,'XTickLabel','');
                    set(gca,'YTickLabel','');
                end
            end
        end
        addlabel(.5, 1, 'Response Matrix Columns:  Horizontal Orbit / Vertical Kick',12);
        addlabel(.5, 0, 'Vertical Magnet Device Number', 10);

    elseif strcmpi(Plane, 'yx')
        s = getspos(R(2,1).Monitor.FamilyName, R(2,1).Monitor.DeviceList);
        for i = 1:NSectors
            for j = 1:NHCMperSector
                Index = findrowindex([i j], R(2,1).Actuator.DeviceList);
                if ~isempty(Index)
                    figure(hfig);
                    subplot(NSectors, NHCMperSector, (i-1)*NHCMperSector + j);
                    plot(s, R(2,1).Data(:,Index));
                    %axis tight
                    set(gca,'XTickLabel','');
                    set(gca,'YTickLabel','');
                end
            end
        end
        addlabel(.5, 1, 'Response Matrix Columns:  Vertical Orbit / Horizontal Kick',12);
        addlabel(.5, 0, 'Horizontal Magnet Device Number', 10);

    elseif strcmpi(Plane, 'yy')
        s = getspos(R(2,2).Monitor.FamilyName, R(2,2).Monitor.DeviceList);
        for i = 1:NSectors
            for j = 1:NVCMperSector
                Index = findrowindex([i j], R(2,2).Actuator.DeviceList);
                if ~isempty(Index)
                    figure(hfig);
                    subplot(NSectors, NVCMperSector, (i-1)*NVCMperSector + j);
                    plot(s, R(2,2).Data(:,Index));
                    %axis tight
                    set(gca,'XTickLabel','');
                    set(gca,'YTickLabel','');
                end
            end
        end
        addlabel(.5, 1, 'Vertical Orbit Response Matrix Columns',12);
        addlabel(.5, 0, 'Vertical Magnet Device Number', 10);
    end

    h = addlabel(.02,.5,'Sector Number',10);
    set(h,'Rotation',90);
    set(h,'HorizontalAlignment','center');
    set(h,'VerticalAlignment','top');
    if isfield(R(1,1), 'TimeStamp')
        addlabel(1,0,sprintf('%s', datestr(R(1,1).TimeStamp)));
    end
    set(gcf,'Position', Pfig);

elseif strcmpi(PlotType,'Rows')
    set(gcf, 'Units', get(0, 'Units'));
    Pfig = get(gcf, 'Position');
    set(gcf, 'Position', get(0, 'ScreenSize'));

    NSectors = R(1,1).Monitor.DeviceList(end,1);
    NBPMxperSector = max(R(1,1).Monitor.DeviceList(:,2));
    NBPMyperSector = max(R(2,2).Monitor.DeviceList(:,2));

    NBPMx = size(R(1,1).Data,1);
    NBPMy = size(R(2,2).Data,1);

    NHCMperSector = max(R(1,1).Actuator.DeviceList(:,2));
    NVCMperSector = max(R(2,2).Actuator.DeviceList(:,2));


    if strcmpi(Plane, 'xx') || strcmpi(Plane, 'All')
        s = getspos(R(1,1).Actuator.FamilyName, R(1,1).Actuator.DeviceList);
        for i = 1:NSectors
            for j = 1:NBPMxperSector
                Index = findrowindex([i j], R(1,1).Monitor.DeviceList);
                if ~isempty(Index)
                    figure(hfig);
                    subplot(NSectors, NBPMxperSector, (i-1)*NBPMxperSector + j);
                    plot(s, R(1,1).Data(Index,:));
                    %axis tight
                    set(gca,'XTickLabel','');
                    set(gca,'YTickLabel','');
                end
            end
        end
        addlabel(.5,1, 'Horizontal Orbit Response Matrix Rows',12);
        addlabel(.5,0, 'Horizontal BPM Device Number', 10);

    elseif strcmpi(Plane, 'xy')
        s = getspos(R(1,2).Actuator.FamilyName, R(1,2).Actuator.DeviceList);
        for i = 1:NSectors
            for j = 1:NBPMxperSector
                Index = findrowindex([i j], R(1,2).Monitor.DeviceList);
                if ~isempty(Index)
                    figure(hfig);
                    subplot(NSectors, NBPMxperSector, (i-1)*NBPMxperSector + j);
                    plot(s, R(1,2).Data(Index,:));
                    %axis tight
                    set(gca,'XTickLabel','');
                    set(gca,'YTickLabel','');
                end
            end
        end
        addlabel(.5,1, 'Response Matrix Rows:  Horizontal Orbit / Vertical Kick',12);
        addlabel(.5,0, 'Horizontal BPM Device Number', 10);

    elseif strcmpi(Plane, 'yx')
        s = getspos(R(2,1).Actuator.FamilyName, R(2,1).Actuator.DeviceList);
        for i = 1:NSectors
            for j = 1:NBPMyperSector
                Index = findrowindex([i j], R(2,1).Monitor.DeviceList);
                if ~isempty(Index)
                    figure(hfig);
                    subplot(NSectors, NBPMyperSector, (i-1)*NBPMyperSector + j);
                    plot(s, R(2,1).Data(Index,:));
                    %axis tight
                    set(gca,'XTickLabel','');
                    set(gca,'YTickLabel','');
                end
            end
        end
        addlabel(.5,1, 'Response Matrix Rows:  Vertical Orbit / Horizontal Kick',12);
        addlabel(.5,0, 'Vertical BPM Device Number', 10);

    elseif strcmpi(Plane, 'yy')
        s = getspos(R(2,2).Actuator.FamilyName, R(2,2).Actuator.DeviceList);
        for i = 1:NSectors
            for j = 1:NBPMyperSector
                Index = findrowindex([i j], R(2,2).Monitor.DeviceList);
                if ~isempty(Index)
                    figure(hfig);
                    subplot(NSectors, NBPMyperSector, (i-1)*NBPMyperSector + j);
                    plot(s, R(2,2).Data(Index,:));
                    %axis tight
                    set(gca,'XTickLabel','');
                    set(gca,'YTickLabel','');
                end
            end
        end
        addlabel(.5,1, 'Vertical Orbit Response Matrix Rows',12);
        addlabel(.5,0, 'Vertical BPM Device Number', 10);
    end

    xaxesposition(1.20);
    yaxesposition(1.20);
    h = addlabel(.02,.5,'Sector Number',10);
    set(h,'Rotation',90);
    set(h,'HorizontalAlignment','center');
    set(h,'VerticalAlignment','top');
    if isfield(R(1,1), 'TimeStamp')
        addlabel(1,0,sprintf('%s', datestr(R(1,1).TimeStamp)));
    end
    set(gcf,'Position', Pfig);

elseif strcmpi(PlotType,'BPMSpace')
    set(gcf, 'Units', get(0, 'Units'));
    Pfig = get(gcf, 'Position');
    set(gcf, 'Position', get(0, 'ScreenSize'));

    if strcmpi(Plane, 'xx') || strcmpi(Plane, 'All')
        [U,S,V] = svd(R(1,1).Data, 0);
    elseif strcmpi(Plane, 'xy')
        [U,S,V] = svd(R(1,2).Data, 0);
    elseif strcmpi(Plane, 'yx')
        [U,S,V] = svd(R(2,1).Data, 0);
    elseif strcmpi(Plane, 'yy')
        [U,S,V] = svd(R(2,2).Data, 0);
    end
    
    n = 0;
    M = ceil(sqrt(size(U,2)));
    N = ceil(sqrt(size(U,2)));
    for i = 1:M
        for j = 1:N
            n = n + 1;
            figure(hfig);
            subplot(M, N, n);
            plot(U(:,n));
            axis tight
            set(gca,'XTickLabel','');
            set(gca,'YTickLabel','');
            if n == size(U,2)
                break
            end
        end
        if n == size(U,2)
            break
        end
    end

    if strcmpi(Plane, 'xx') || strcmpi(Plane, 'All')
        addlabel(.5, 1, sprintf('Singular Vectors Spanning the Horizontal BPM Space (U(%dx%d))',size(U,1),size(U,2)),12);
    elseif strcmpi(Plane, 'xy')
        addlabel(.5, 1, sprintf('Singular Vectors Spanning the Horizontal BPM Cross Space (U(%dx%d))',size(U,1),size(U,2)),12);
    elseif strcmpi(Plane, 'yx')
        addlabel(.5, 1, sprintf('Singular Vectors Spanning the Vertical BPM Cross Space (U(%dx%d))',size(U,1),size(U,2)),12);
    elseif strcmpi(Plane, 'yy')
        addlabel(.5, 1, sprintf('Singular Vectors Spanning the Vertical BPM Space (U(%dx%d))',size(U,1),size(U,2)),12);
    end
    
    if isfield(R(1,1), 'TimeStamp')
        addlabel(1,0,sprintf('%s', datestr(R(1,1).TimeStamp)));
    end
    set(gcf,'Position', Pfig);

elseif strcmpi(PlotType,'CMSpace')
    set(gcf, 'Units', get(0, 'Units'));
    Pfig = get(gcf, 'Position');
    set(gcf, 'Position', get(0, 'ScreenSize'));

    if strcmpi(Plane, 'xx') || strcmpi(Plane, 'All')
        [U,S,V] = svd(R(1,1).Data, 0);
    elseif strcmpi(Plane, 'xy')
        [U,S,V] = svd(R(1,2).Data, 0);
    elseif strcmpi(Plane, 'yx')
        [U,S,V] = svd(R(2,1).Data, 0);
    elseif strcmpi(Plane, 'yy')
        [U,S,V] = svd(R(2,2).Data, 0);
    end
    
    n = 0;
    M = ceil(sqrt(size(V,2)));
    N = ceil(sqrt(size(V,2)));
    for i = 1:M
        for j = 1:N
            n = n + 1;
            figure(hfig);
            subplot(M, N, n);
            plot(V(:,n));
            axis tight
            set(gca,'XTickLabel','');
            set(gca,'YTickLabel','');
            if n == size(V,2)
                break
            end
        end
        if n == size(U,2)
            break
        end
    end

    if strcmpi(Plane, 'xx') || strcmpi(Plane, 'All')
        addlabel(.5, 1, sprintf('Singular Vectors Spanning the Horizontal Corrector Space (V(%dx%d))', size(V,1), size(V,2)), 12);
    elseif strcmpi(Plane, 'xy')
        addlabel(.5, 1, sprintf('Singular Vectors Spanning the Vertical Corrector Cross Space (V(%dx%d))', size(V,1), size(V,2)), 12);
    elseif strcmpi(Plane, 'yx')
        addlabel(.5, 1, sprintf('Singular Vectors Spanning the Horizontal Corrector Cross Space (V(%dx%d))', size(V,1), size(V,2)), 12);
    elseif strcmpi(Plane, 'yy')
        addlabel(.5, 1, sprintf('Singular Vectors Spanning the Vertical Corrector Space (V(%dx%d))', size(V,1), size(V,2)), 12);
    end

    if isfield(R(1,1), 'TimeStamp')
        addlabel(1,0,sprintf('%s', datestr(R(1,1).TimeStamp)));
    end
    set(gcf,'Position', Pfig);

end


