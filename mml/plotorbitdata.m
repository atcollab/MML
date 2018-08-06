function [BPMx, BPMy] = plotorbitdata(varargin)
%PLOTORBITDATA - Plots BPM statistics
%  [BPMx, BPMy] = plotorbitdata(FileName)
%
%  INPUTS
%  1.  FileName = Filename (w/ or w/o directory) where the data was saved
%      If empty then search for a file in the default BPM directory.
%      If '.' then search for a file in the present directory.
%
%  OUTPUTS
%  For numeric output:
%  1. BPMx - Horizontal data structure
%  2. BPMy - Vertical data structure
%
%  KEYWORDS
%  1. Physics or Hardware
%  2. Position - X-axis is the position along the ring {Default}
%  3. Phase    - X-axis is the phase along the ring
%  4. Sector   - X-axis is sector number

%  Written by Greg Portmann
%  Modified by Laurent S. Nadolski


BPMxFamily = gethbpmfamily;
BPMyFamily = getvbpmfamily;

XAxisFlag = 'Position';
HoldFlag = 0;  % Not presently used
UnitsFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'hold on')
        HoldFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        UnitsFlags = {'Physics'};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlags = {'Hardware'};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Position')
        XAxisFlag = 'Position';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Phase')
        XAxisFlag = 'Phase';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Sector')
        XAxisFlag = 'Sector';
        varargin(i) = [];
    end
end


FileName = [];
if length(varargin) >= 1
    FileName = varargin{1};
end


if isstruct(FileName)
    BPMx = FileName;
    if nargin >= 2
        BPMy = varargin{2};
    else
        BPMy = BPMx;
    end
    % BPM response matrix cludge
    if all(size(BPMx) == [2 2])
        BPMx = BPMx(1,1);
    end
else
    DirFlag = 0;
    if isdir(FileName)
        DirFlag = 1;
    else
        if length(FileName)>=1
            if strcmp(FileName(end),filesep)
                DirFlag = 1;
            end
        end
    end
    if strcmp(FileName,'.') || isempty(FileName) || DirFlag
        % Data root
        if strcmp(FileName,'.')
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a file to analyze');
        elseif DirFlag
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a file to analyze', FileName);
        else
            DirectoryName = getfamilydata('Directory','DataRoot');
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a file to analyze', DirectoryName);
        end
        if FileName == 0
            return
        end
        FileName = [DirectoryName FileName];
    end


    % Get data from file
    try
        BPMx = getdata(BPMxFamily, FileName, 'Struct');
        BPMy = getdata(BPMyFamily, FileName, 'Struct');
    catch
        try
            % BPM response
            BPMy = getbpmresp('Filename', FileName, 'Struct');
            BPMx = BPMy(1,1);
        catch
            try
                % Dispersion
                BPMx = getrespmat(BPMxFamily, 'RF', FileName, 'Struct');
                BPMy = getrespmat(BPMyFamily, 'RF', FileName, 'Struct');
            catch
                try
                    % Chromaticity
                    BPMx = load(FileName);
                catch
                    disp('Not sure what type of file this is');
                    return
                end
            end
        end
    end
end


% Units conversion
if ~isempty(UnitsFlags) && strcmpi(UnitsFlags{1},'Physics')
    BPMx = hw2physics(BPMx);
    BPMy = hw2physics(BPMy);
elseif ~isempty(UnitsFlags) && strcmpi(UnitsFlags{1},'Hardware')
    BPMx = physics2hw(BPMx);
    BPMy = physics2hw(BPMy);
end

if strcmpi(XAxisFlag, 'Phase')
    [BPMxspos, BPMyspos, Sx, Sy, Tune] = modeltwiss('Phase', BPMxFamily, [], BPMyFamily, []);
    BPMxspos = BPMxspos/2/pi;
    BPMyspos = BPMyspos/2/pi;
    XLabel = 'BPM Phase';
elseif strcmpi(XAxisFlag, 'Sector')
    [Sector, Nsectors, Ndevices] = sectorticks(BPMx.DeviceList);
    BPMxspos = Sector;
    BPMyspos = Sector;
    XLabel = 'Sector Number';
else
    BPMxspos = getspos(BPMx);
    BPMyspos = getspos(BPMy);
    XLabel = 'BPM Position [meters]';
end


if isfield(BPMx, 'CreatedBy') && (strcmpi(BPMx.CreatedBy, 'monbpm') || strcmpi(BPMx.CreatedBy, 'measbpmsigma'))
    if strcmpi(BPMx.CreatedBy, 'monbpm')
        % Definition of standard deviations
        BPMxStd = std(BPMx.Data, 0, 2);
        BPMyStd = std(BPMy.Data, 0, 2);

        % Difference orbit sigma
        BPMxSigma = BPMx.Sigma;
        BPMySigma = BPMy.Sigma;

        Mx = BPMx.Data;
        My = BPMy.Data;

        tout = BPMx.tout;
    elseif strcmpi(BPMx.CreatedBy, 'measbpmsigma')
        % Definition of standard deviations
        BPMxStd = std(BPMx.RawData, 0, 2);
        BPMyStd = std(BPMy.RawData, 0, 2);

        % Difference orbit sigma
        BPMxSigma = BPMx.Data;
        BPMySigma = BPMy.Data;

        Mx = BPMx.RawData;
        My = BPMy.RawData;

        tout = BPMx.DCCT.tout;
    else
        error('Not sure how to analyze this file');
    end


    Mx0 = Mx(:,1);
    for i = 1:size(Mx,2)
        Mx(:,i) = Mx(:,i) - Mx0;
    end

    %tout = BPMy.tout;
    My0 = My(:,1);
    for i = 1:size(My,2)
        My(:,i) = My(:,i) - My0;
    end

    BPMxMax = max(Mx, [], 2);
    BPMyMax = max(My, [], 2);

    BPMxMin = min(Mx, [], 2);
    BPMyMin = min(My, [], 2);

    h = gcf;
    figure(h);
    clf reset
    ha = subplot(2,2,1);
    plot(tout, Mx);
    grid on;
    xaxis([0 max(tout)]);
    xlabel('Time [Seconds]');
    ylabel(sprintf('Horizontal Data [%s]', BPMx.UnitsString));

    ha(2) = subplot(2,2,3);
    plot(tout, My);
    grid on;
    xaxis([0 max(tout)]);
    xlabel('Time [Seconds]');
    ylabel(sprintf('Vertical Data [%s]', BPMx.UnitsString));

    linkaxes(ha, 'x');
    
    ha = subplot(2,2,2);
    plot(BPMxspos, abs(BPMxMax),'k');
    hold on
    plot(BPMxspos, abs(BPMxMin),'r');
    plot(BPMxspos, BPMxStd,'g');
    plot(BPMxspos, BPMxSigma,'b');
    hold off
    grid on;
    if strcmpi(XAxisFlag, 'Sector')
        xaxis([1 Nsectors+1])
        set(gca,'XTick',1:Nsectors);
    else
        axis tight;
    end
    xlabel(XLabel);
    ylabel(sprintf('Horizontal [%s]', BPMx.UnitsString));
    legend('abs(Max)','abs(Min)','std(Data)', 'std(Difference Orbits)','Location','Best');

    ha(2) = subplot(2,2,4);
    plot(BPMyspos, abs(BPMyMax),'k');
    hold on
    plot(BPMyspos, abs(BPMyMin),'r');
    plot(BPMyspos, BPMyStd,'g');
    plot(BPMyspos, BPMySigma,'b');
    hold off
    grid on;
    if strcmpi(XAxisFlag, 'Sector')
        xaxis([1 Nsectors+1])
        set(gca,'XTick',1:Nsectors);
    else
        axis tight;
    end
    xlabel(XLabel);
    ylabel(sprintf('Vertical [%s]', BPMx.UnitsString));
    legend('abs(Max)','abs(Min)','std(Data)', 'std(Difference Orbits)', 'Location','Best')

    linkaxes(ha, 'x');

    addlabel(.5,1,sprintf('BPM Data'), 10);
    addlabel(1,0,sprintf('%s', datestr(BPMx.TimeStamp)));
    orient landscape

    h = h + 1;

    figure(h);
    clf reset
    ha = subplot(2,1,1);
    bar(BPMxspos, BPMxSigma);
    grid on;
    if strcmpi(XAxisFlag, 'Sector')
        xaxis([1 Nsectors+1])
        set(gca,'XTick',1:Nsectors);
    else
        axis tight;
    end
    xlabel(XLabel);
    ylabel(sprintf('Horizontal STD [%s]', BPMx.UnitsString));
    title(sprintf('BPM Standard Deviation of Difference Orbits / sqrt(2)'));

    ha(2) = subplot(2,1,2);
    bar(BPMyspos, BPMySigma);
    grid on;
    grid on;
    if strcmpi(XAxisFlag, 'Sector')
        xaxis([1 Nsectors+1])
        set(gca,'XTick',1:Nsectors);
    else
        axis tight;
    end

    linkaxes(ha, 'x');

    xlabel(XLabel);
    ylabel(sprintf('Vertical STD [%s]', BPMx.UnitsString));
    addlabel(1,0,sprintf('%s', datestr(BPMx.TimeStamp)));
    orient tall

elseif isfield(BPMx, 'DataDescriptor') && strcmpi(BPMx.DataDescriptor, 'Dispersion')
    plotdisp(BPMx, BPMy);

elseif isfield(BPMx, 'DataDescriptor') && strcmpi(BPMx.DataDescriptor, 'Chromaticity')
    plotchro(BPMx);

elseif isfield(BPMx, 'DataDescriptor') && strcmpi(BPMx.DataDescriptor, 'Response Matrix')  % strcmpi(BPMx.CreatedBy, 'measbpmresp')
    %if exist('plotbpmresp','file')
    %    plotbpmresp(BPMy);
    %end
    figure;
    clf reset
    surf([BPMy(1,1).Data BPMy(1,2).Data; BPMy(2,1).Data BPMy(2,2).Data]);
    view(-70, 65);
    title('Orbit Response Matrix');
    xlabel('CM Number');
    ylabel('BPM Number');
    addlabel(1,0,sprintf('%s', datestr(BPMy(1,1).TimeStamp)));

elseif isfield(BPMx, 'QMS')
    quadplot(BPMx.QMS);

elseif isfield(BPMx, 'Data') && isfield(BPMx, 'DataDescriptor') && isfield(BPMx, 'TimeStamp')
    h = gcf;
    figure(h);
    clf reset
    subplot(2,1,1);
    if size(BPMx.Data,2) > 1
        plot(tout, BPMx.Data);
        xlabel('Time [Seconds]');
    else
        plot(Sector, BPMx.Data);
        if strcmpi(XAxisFlag, 'Sector')
            xaxis([1 Nsectors+1])
            set(gca,'XTick',1:Nsectors);
        else
            axis tight;
        end
        xlabel(XLabel);
    end
    grid on;
    ylabel(sprintf('Horizontal [%s]', BPMx.UnitsString));
    title(sprintf('%s', BPMx.DataDescriptor));

    subplot(2,1,2);
    if size(BPMx.Data,2) > 1
        plot(tout, BPMy.Data);
        xlabel('Time [Seconds]');
    else
        [Sector, Nsectors, Ndevices] = sectorticks(BPMy.DeviceList);
        plot(Sector, BPMy.Data);
        if strcmpi(XAxisFlag, 'Sector')
            xaxis([1 Nsectors+1])
            set(gca,'XTick',1:Nsectors);
        else
            axis tight;
        end
        xlabel(XLabel);
    end
    grid on;
    ylabel(sprintf('Vertical [%s]', BPMx.UnitsString));
    title(sprintf('%s', BPMy.DataDescriptor));
    addlabel(1,0,sprintf('%s', datestr(BPMx.TimeStamp)));
    orient tall

else
    fprintf('   Not sure how to plot data file %s.\n', FileName);
end

