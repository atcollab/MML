function [Data, FileNameBase] = topoff_plottrackingfile(varargin)
%TOPOFF_PLOTTRACKINGFILE - Plot Hiroshi's top-off tracking files
%  [Data, FileName] = topoff_plottrackingfile(FileName, MinTrackingDistance, MaxTrackingDistance)
%
%  INPUTS
%  1. FileName - Tracking file name (extension not necessary)
%  2. MinTrackingDistance - Particles tracked to less than TrackingDistance
%                           are black in the colormap       {Default: 3.25 for dot-2 & dot-3 ports}
%  4. MaxTrackingDistance - Starting point for the tracking {Default: 8.60 for dot-2 & dot-3 ports}
%
%  OUTPUTS
%  1. Data - Structure of data and parameters
%           (plots data if no output exists)
%
%  See also topoff_apertures, topoff_readtrackingfile, topoff_fieldprofiles


if nargin == 0 || isempty(varargin{1})
    [Data, FileNameBase] = topoff_readtrackingfile;
else
    if isstruct(varargin{1})
        Data = varargin{1};
        FileNameBase = '';
    else
        [Data, FileNameBase] = topoff_readtrackingfile(varargin{1});
    end
end

if isfield(Data, 'BL')
    FileNameBase = Data.BL;
end

if nargin < 2
    % This isn't very robust but it will do for now
    if ~isempty(strfind(FileNameBase, 'SB_BL2')) || ~isempty(strfind(FileNameBase, 'SB_DOT2'))
        cMin = 3.25; % SB BL Dot-2 & Dot-3
    elseif ~isempty(strfind(FileNameBase, 'SB_BL3')) || ~isempty(strfind(FileNameBase, 'SB_DOT3'))
        cMin = 3.25; % SB BL Dot-2 & Dot-3
    elseif ~isempty(strfind(FileNameBase, 'BL3')) || ~isempty(strfind(FileNameBase, 'DOT3'))
        cMin = 3.25; % BL Dot-2 & Dot-3
    elseif ~isempty(strfind(FileNameBase, 'BL2')) || ~isempty(strfind(FileNameBase, 'DOT2'))
        cMin = 3.25; % BL Dot-2 & Dot-3
    elseif ~isempty(strfind(FileNameBase, 'BL1')) || ~isempty(strfind(FileNameBase, 'DOT1'))
        cMin = 6.9;  % BL Dot-1
    elseif ~isempty(strfind(FileNameBase, 'BL0')) || ~isempty(strfind(FileNameBase, 'DOT0'))
        cMin = 0.25;  % BL Dot-0
    else
        cMin = 0;
    end
else
    cMin = varargin{2};
end
if nargin < 3
    if ~isempty(strfind(FileNameBase, 'SB_BL2')) || ~isempty(strfind(FileNameBase, 'SB_DOT2'))
        cMax = 8.6;  % SB BL Dot-2 & Dot-3
    elseif ~isempty(strfind(FileNameBase, 'SB_BL3')) || ~isempty(strfind(FileNameBase, 'SB_DOT3'))
        cMax = 8.6;  % SB BL Dot-2 & Dot-3
    elseif ~isempty(strfind(FileNameBase, 'BL3')) || ~isempty(strfind(FileNameBase, 'DOT3'))
        cMax = 8.6;  % BL Dot-2 & Dot-3
    elseif ~isempty(strfind(FileNameBase, 'BL2')) || ~isempty(strfind(FileNameBase, 'DOT2'))
        cMax = 8.6;  % BL Dot-2 & Dot-3
    elseif ~isempty(strfind(FileNameBase, 'BL1')) || ~isempty(strfind(FileNameBase, 'DOT1'))
        cMax = 12.2;  % BL Dot-1
    elseif ~isempty(strfind(FileNameBase, 'BL0')) || ~isempty(strfind(FileNameBase, 'DOT0'))
        cMax = 11;  % BL Dot-0
    else
        cMax = 12.25;
    end
else
    cMax = varargin{3};
end


% This is just for legend
%topoff_apertures(Data.BL, 2, '', 1, 3);
%hold on;

NextPlot = get(gca,'NextPlot');

if 1  % 0-image, else surf
    % Surf plot
    if 1 %strcmpi(NextPlot,'Add')
        % Add a row and column so that the last points get plotted
        Z = Data.Z;
        x = Data.x;
        Px = Data.Px;
        Z = [Z; Z(end,:)];
        Z = [Z  Z(:,end)];
        if length(x)>1
            x = [x; x(end)+(x(end)-x(end-1))];
            Px = [Px; Px(end)+(Px(end)-Px(end-1))];
            
            dx = diff(x);
            dx = [dx; dx(end)];
            dPx = diff(Px);
            dPx = [dPx; dPx(end)];
            [X,Y] = meshgrid(x-dx/2, Px-dPx/2);
        else
            x = [x; x(end)+Data.xDelta];
            Px = [Px; Px(end)+Data.PxDelta];
            
            dx = diff(x);
            dx = [dx; dx(end)];
            dPx = diff(Px);
            dPx = [dPx; dPx(end)];
            [X,Y] = meshgrid(x-dx/2, Px-dPx/2);
        end

        hs = surf(X, Y, Z, 'EraseMode', 'Background');

        %             % Zero out data in the area of the new plot
        %             h = get(gca,'Children');
        %             for i = 1:length(h)
        %                 try
        %                     XX = get(h(i), 'XData');
        %                     YY = get(h(i), 'YData');
        %                     ZZ = get(h(i), 'ZData');
        %                     if ~isempty(ZZ)
        %                         [ii, jj] = find(min(Data.x)<=XX & XX<=max(Data.x) & min(Data.Px)<=YY & YY<=max(Data.Px));
        %                         %ii = find(min(Data.x)<=XX(1,:) & XX(1,:)<=max(Data.x));
        %                         %jj = find(min(Data.Px)<=YY(:,1) & YY(:,1)<=max(Data.Px));
        %                         if ~isempty(ii)
        %                             for k = 1:length(ii)
        %                                 ZZ(ii(k),jj(k)) = NaN;
        %                             end
        %                             set(h(i), 'ZData', ZZ);
        %                         end
        %                     end
        %                 catch
        %                 end
        %             end
        %            surf(X, Y, Data.Z);
    else
        [X,Y] = meshgrid(Data.x, Data.Px);
        surf(X, Y, Data.Z);
    end

    %shading interp
    shading flat
    view(0,90);

    %grid off
    %set(hs, 'EraseMode', 'Xor');
    
else
    % Image plot
    %h = imagesc(Data.x, Data.Px, Data.Z);
    h = image(Data.x, Data.Px, Data.Z, 'CDataMapping','scaled');
    set(gca, 'YDir', 'Normal');
end

Nmap = 2048; %128;
cmap = jet(Nmap);

set(gca, 'CLim', [0 cMax]);

a = linspace(0,cMax,Nmap)';
i = find(cMin <= a);
i = i(1);


if i > 1
    N = round(Nmap*(cMin/cMax)/(1-cMin/cMax));
    cmap = [cmap; zeros(N,3)];
    colormap(cmap);
else
    %colormap('default');
    colormap(cmap);
end

m = colormap;
m = m(end:-1:1,:);
colormap(m);
hcb = colorbar;

brighten(.4);  % Hiroshi has more green/yellow than the Matlab default

if isfield(Data, 'BL')
     hold on;
     topoff_apertures(Data.BL, 2, 'k', 1, 3, 2);
     set(gca,'NextPlot', NextPlot);
else
    % This isn't very robust but it will do for now
    if ~isempty(strfind(FileNameBase, 'SB_BL2')) || ~isempty(strfind(FileNameBase, 'SB_DOT2'))
        hold on;
        topoff_apertures('SB_BL2', 2, 'k', 1, 3);
        set(gca,'NextPlot', NextPlot);
    elseif ~isempty(strfind(FileNameBase, 'SB_BL3')) || ~isempty(strfind(FileNameBase, 'SB_DOT3'))
        hold on;
        topoff_apertures('SB_BL3', 2, 'k', 1, 3);
        set(gca,'NextPlot', NextPlot);
    elseif ~isempty(strfind(FileNameBase, 'BL3')) || ~isempty(strfind(FileNameBase, 'DOT3'))
        hold on;
        topoff_apertures('BL3', 2, 'k', 1, 3);
        set(gca,'NextPlot', NextPlot);
    elseif ~isempty(strfind(FileNameBase, 'BL2')) || ~isempty(strfind(FileNameBase, 'DOT2'))
        hold on;
        topoff_apertures('BL2', 2, 'k', 1, 3);
        set(gca,'NextPlot', NextPlot);
    elseif ~isempty(strfind(FileNameBase, 'BL1')) || ~isempty(strfind(FileNameBase, 'DOT1'))
        hold on;
        topoff_apertures('BL1', 2, 'k', 1, 3);
        set(gca,'NextPlot', NextPlot);
    elseif ~isempty(strfind(FileNameBase, 'BL0')) || ~isempty(strfind(FileNameBase, 'DOT0'))
        hold on;
        topoff_apertures('BL0', 2, 'k', 1, 3);
        set(gca,'NextPlot', NextPlot);
    else
        ii = strfind(FileNameBase, 'BL');
        if ~isempty(ii) && ~isempty(FileNameBase) && length(FileNameBase) > ii(end)
            BL = str2num(FileNameBase(ii(end)+2));
            if ~ischar(BL)
                hold on;
                topoff_apertures([9 0], 2, 'k', 1, 3);
%                topoff_apertures(BL, 2, 'k', 1, 3);
                set(gca,'NextPlot', NextPlot);

                %if BL == 2
                %   xaxis([.505 .675]);
                %   yaxis([.27 .337]);
                %elseif BL == 3
                %    xaxis([.23 .415]);
                %    yaxis([.16 .29]);
                %end
            end
        end
    end
end

xaxis([Data.xMin  Data.xMax]);
yaxis([Data.PxMin Data.PxMax]);
xlabel('Meters');
ylabel('Radians');


% For copying to MS-Word, it's nice to have the same size figure
Units = get(gcf, 'Units');
set(gcf, 'Units', 'inches');
P = get(gcf,'Position');
if P(4) < 9.18
    P(2) = P(2) + P(4) - 5.45;
end
P(3) = 9.18;
P(4) = 5.45;
set(gcf,'Position', P);
set(gcf, 'Units', Units);

