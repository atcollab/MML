function [MagnetSetpoints, MagnetMonitors, BPMMonitors, MagnetSetpointsEnd, FileName] = monmags(varargin)
%MONMAGS - Monitors all magnet power supplies and plots various statistics
%
%  [MagnetSetpoints, MagnetMonitors, BPMMonitors, MagnetSetpointsEnd] = monmags(FileName, PlotDataFlag, UnitsFlag)
%  [MagnetSetpoints, MagnetMonitors, BPMMonitors, MagnetSetpointsEnd] = monmags(FileName, t, UnitsFlag)
%
%  INPUTS
%  1. FileName - file to load or save data  {Default or []: prompt for a filename}
%  2. PlotDataFlag - 0 -> get, save and plot data {Default: prompt for input}
%                    1 -> plot all families (data coming from a file)
%                    2 -> plot one family   (data coming from a file)
%     t - time vector (see help getpv for more details)  {Default: prompt for input}
%  Optional Inputs
%  3. UnitsFlag ('Hardware' or 'Physics') - Just for plotting.  {Default: default units when the data was taken}
%  4. 'NoDisplay' - read or save the data file without plotting the result (just for getting data).
%  5. 'Raw2Real' - if in hardware units, a raw2real conversion is make before plotting (no change is made to the measured data).
%                  
%  OUTPUTS
%  1. MagnetSetpoints - Cell array of magnet setpoints at the start of the test
%  2. MagnetMonitors  - Cell array of magnets monitors sampled according to the vector t
%  3. BPMMonitors     - Cell array of BPMs
%  4. MagnetSetpointsEnd - Cell array of magnet setpoints at the end of the test
%
%  NOTE
%  1. Input order does not matter.  All inputs are optional.
%  2. Make sure the sample period is long enough to acquirer the data.  It's
%     best to test on a few samples first (3 is points in the minimum).
%  3. Orbits are also monitored.  Use monbpm to just monitor the orbit.
%
%  EXAMPLES
%  1. To plot data in physics units (prompt for the file):
%     monmags('physics', 1);
%  2. To get data for 3 minutes at 1 sample/second, save to filename=magdata101.mat (in 
%     the current directory), and plot in default units:
%     monmags('magdata101',0:1:180);
%
%  See also monbpm

%  Written by Greg Portmann


DisplayFlag = 1;
FileName = -1;
ArchiveFlag = -1;
UnitsFlag  = ''; 
PlotDataFlag = [];
t = [];
DirectoryName = '';
MagnetSetpoints =[];
MagnetMonitors = [];
BPMMonitors = []; 
MagnetSetpointsEnd = [];
Raw2RealFlag = 0;

for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Remove
        varargin(i) = [];
    elseif iscell(varargin{i})
        % Remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'struct')
        % Remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Raw2Real')
        Raw2RealFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        UnitsFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlag = varargin{i};
        varargin(i) = [];
    end
end

for i = length(varargin):-1:1
    if ischar(varargin{i})
        FileName = varargin{i};
        if strcmpi(FileName,'Archive')
            PlotDataFlag = 0;
            ArchiveFlag = 1;
            if length(varargin) > i
                % Look for a filename as the next input
                if ischar(varargin{i+1})
                    FileName = varargin{i+1};
                    varargin(i+1) = [];
                end
            end
            varargin(i) = [];
        elseif strcmpi(varargin{i},'NoArchive')
            ArchiveFlag = 0;
            varargin(i) = [];
        end
    elseif isnumeric(varargin{i})
        if length(varargin{i}) == 1
            PlotDataFlag = varargin{i};
        else
            PlotDataFlag = 0;
            t = varargin{i};
        end
        varargin(i) = [];        
    end
end


if isempty(PlotDataFlag)
    if FileName == -1
        ButtonNumber = menu('What would you like to do?', 'Get New Data','Plot Data From a File','Plot 1 Family From a File','Cancel');  
        switch ButtonNumber
            case 1
                PlotDataFlag = 0;
            case 2
                PlotDataFlag = 1;
            case 3
                PlotDataFlag = 2;
            otherwise
                fprintf('   monmags cancelled\n');
                return
        end
    else
        if exist(FileName) || exist([FileName,'.mat'])
            PlotDataFlag = 1;
        else
            PlotDataFlag = 0;
        end
    end
end


% Get file for plotting
if (isempty(FileName) || isequal(FileName,-1)) && PlotDataFlag > 0
    DirectoryName = getfamilydata('Directory','DataRoot');
    DirectoryName = [DirectoryName, 'Magnets', filesep];
    [FileName, DirectoryName] = uigetfile('*.mat', 'Select a magnet file', DirectoryName);
    if isnumeric(FileName)
        fprintf('   monmags cancelled\n');
        return
    end
end


if PlotDataFlag == 0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get Data From The Control System %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    if ArchiveFlag
        if isempty(FileName)
            FileName = appendtimestamp('magnetdata');
            DirectoryName = [getfamilydata('Directory','DataRoot'), 'Magnets', filesep];
            
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
            
            [FileName, DirectoryName] = uiputfile('*.mat', 'Select a Magnet Monitor File', [DirectoryName FileName]);
            if isequal(FileName,0) || isequal(DirectoryName,0)
                disp('   Magnet power supply monitoring canceled.');
                FileName = '';
                return
            end
            FileName = [DirectoryName, FileName];
        elseif FileName == -1
            FileName = appendtimestamp('magnetdata');
            DirectoryName = [getfamilydata('Directory','DataRoot'), 'Magnets', filesep];
            FileName = [DirectoryName, FileName];
        end
    else
        if nargout == 0
            fprintf('   No output or filename input, so there is no reason to monitor the power supplies\n');
        end
    end
    
    
    % Setup the family cell array
    MagnetFamilies = findmemberof('Magnet');
    MagnetFamilies = MagnetFamilies(:);
    
    % If a family has all zero status remove it
    for i = length(MagnetFamilies):-1:1
        Status = family2status(MagnetFamilies{i});
        if all(Status==0)
            MagnetFamilies(i) = [];
        end
    end

    MagnetFamilies = editlist(MagnetFamilies);
    MagnetFamilies = MagnetFamilies(:);
    iMagnets = length(MagnetFamilies);
    MagnetDeviceLists = cell(iMagnets,1);

    
    % BPM families
    %BPMFamilies = findmemberof('BPM'); 
    %BPMFamilies = BPMFamilies(:);
    BPMFamilies = {gethbpmfamily; getvbpmfamily};  % Reduced to just the two main families
    
    % If a family has all zero status remove it
    for i = length(BPMFamilies):-1:1
        Status = family2status(BPMFamilies{i});
        if all(Status==0)
            BPMFamilies(i) = [];
        end
    end

    %BPMFamilies = editlist(BPMFamilies(:),'',[1 1 0 0]); % Tmp fix for an ALS issue
    BPMFamilies = editlist(BPMFamilies(:));
    BPMFamilies = BPMFamilies(:);
    iBPMs = length(BPMFamilies);
    BPMDeviceLists = cell(iBPMs,1);
 
    if isempty(MagnetFamilies) && isempty(BPMFamilies)
        fprintf('   Nothing to monitor.\n');
        return;
    end
    
        
    
    disp('  ');
    disp('   This function monitors the storage ring magnets and BPMs then computes various');
    disp('   accuracy statistics.  The sample period should be long enough to acquire ');
    disp('   all the magnets and BPMs in the storage ring.  The storage ring must be static');
    disp('   during this measurement (no magnet or insertion device changes, etc).  This ');
    disp('   function open a lot of windows, ">> close all" closes all figure windows.');
    disp('  ');
    if isempty(t)
        prompt = {'Input the sample period (seconds)', 'Input the total data collection time (seconds)'};
        answer = inputdlg(prompt,'monmags',1,{'1','180'});
        if isempty(answer)
            fprintf('   monmags cancelled\n');
            return
        end
        T       = str2num(answer{1});
        EndTime = str2num(answer{2});
        t = 0:T:EndTime;
    end
    if length(t) < 3
        fprintf('\n   The input time vector only has %d sample points.\n', length(t));
        fprintf('   The function will run with 3 but you should have a lot (like 100 or more).\n');
        fprintf('   monmags cancelled');
        return
    end
    
    fprintf('   Taking data for about %.1f seconds  . . .  ', t(end));
    TimeStart = gettime;
    
        
    % Get the setpoints at the start
    MagnetSetpoints = getsp(MagnetFamilies, MagnetDeviceLists, 'Struct');

    % Get the monitors (first connect to the channels so that the first sample time is not longer than the rest)
    % Forcing units to hardware is necessary to speedup the data taking
    tmp       = getam([MagnetFamilies; BPMFamilies], [MagnetDeviceLists; BPMDeviceLists], 'Hardware');
    Monitors  = getam([MagnetFamilies; BPMFamilies], [MagnetDeviceLists; BPMDeviceLists], t, 'Struct', 'Hardware');

    % Get the setpoints at the end (hopefully it's the same as the start)
    MagnetSetpointsEnd = getsp(MagnetFamilies, MagnetDeviceLists, 'Struct');

    % Split the monitors into magnets and BPMs
    MagnetMonitors = Monitors(1:iMagnets);
    BPMMonitors    = Monitors(iMagnets+1:iMagnets+iBPMs);

    fprintf('finished in %.1f seconds\n', Monitors{1}.tout(end));
    fprintf('   Average Sampling Period = %.3f seconds (Max= %.3f, Min=%.3f seconds)\n', mean(diff(Monitors{1}.tout)), max(diff(Monitors{1}.tout)), min(diff(Monitors{1}.tout)));


    % Convert to the default units
    for i = 1:length(Monitors)
        ActualUnits = getunits(Monitors{i}.FamilyName);
        if strcmpi(ActualUnits, 'Physics')
            Monitors{i} = hw2physics(Monitors{i});
        end
    end

    
    % Convert to fields (more readable)
    MagnetMonitors     = cell2field(MagnetMonitors);
    MagnetSetpoints    = cell2field(MagnetSetpoints);
    BPMMonitors        = cell2field(BPMMonitors);
    MagnetSetpointsEnd = cell2field(MagnetSetpointsEnd);
    
    
    % Save data in the proper directory
    if ArchiveFlag || ischar(FileName)
        [DirectoryName, FileName, Ext] = fileparts(FileName);
        DirStart = pwd;
        [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
        if ErrorFlag
            fprintf('\n   There was a problem getting to the proper directory!\n\n');
        end
        save(FileName, 'MagnetMonitors', 'MagnetSetpoints', 'BPMMonitors', 'MagnetSetpointsEnd');
        cd(DirStart);
        FileName = [DirectoryName FileName];
        
        if DisplayFlag
            fprintf('   Magnet power supply data saved to %s\n', FileName);
            fprintf('   The total measurement time was %.2f minutes.\n', (gettime-TimeStart)/60);
        else
            return;
        end
    else
        FileName = '';
    end
    
else
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get data from file and plot it %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load([DirectoryName, FileName]);
    
end


if ~DisplayFlag
    return
end



%%%%%%%%%%%%
% Plotting %
%%%%%%%%%%%%

% Convert to cell arrays
if ~iscell(MagnetMonitors)
    if isempty(MagnetMonitors)
        MagnetMonitors = {};
        MagnetSetpoints = {};
        MagnetSetpointsEnd = {};
    else
        MagnetMonitors     = field2cell(MagnetMonitors);
        MagnetSetpoints    = field2cell(MagnetSetpoints);
        MagnetSetpointsEnd = field2cell(MagnetSetpointsEnd);
    end
end
if ~iscell(BPMMonitors)
    if isempty(BPMMonitors)
        BPMMonitors = {};
    else
        BPMMonitors = field2cell(BPMMonitors);
    end
end

if ~isempty(MagnetMonitors)
    tout = MagnetMonitors{1}.tout;
elseif ~isempty(BPMMonitors)
    tout = BPMMonitors{1}.tout;
else
    fprintf('   There is not data in this file to plot.\n');
    return
end


if PlotDataFlag == 2
    % Plot one family
    for i = 1:length(MagnetMonitors)
        FamilyList{i} = MagnetMonitors{i}.FamilyName;    
    end 
    for i = 1:length(BPMMonitors)
        FamilyList{i+length(MagnetMonitors)} = BPMMonitors{i}.FamilyName;    
    end 
    
    FamilyNumber = menu('Choose a family', FamilyList);
    
    if FamilyNumber <= length(MagnetMonitors)
        MagnetMonitors  = MagnetMonitors(FamilyNumber);
        MagnetSetpoints = MagnetSetpoints(FamilyNumber);
        BPMMonitors = [];
    else
        BPMMonitors = BPMMonitors(FamilyNumber-length(MagnetMonitors));
        MagnetMonitors  = [];
        MagnetSetpoints = [];
    end
end


% Plot all families
for i = 1:length(MagnetMonitors)
    if strcmpi(UnitsFlag, 'Physics')
        MagnetMonitors{i}  = hw2physics(MagnetMonitors{i});
        MagnetSetpoints{i} = hw2physics(MagnetSetpoints{i});
    elseif strcmpi(UnitsFlag, 'Hardware')
        MagnetMonitors{i}  = physics2hw(MagnetMonitors{i});
        MagnetSetpoints{i} = physics2hw(MagnetSetpoints{i});
    end
    
    if Raw2RealFlag && strcmpi(MagnetMonitors{i}.Units, 'Hardware')
        MagnetMonitors{i}  = raw2real(MagnetMonitors{i});
        MagnetSetpoints{i} = raw2real(MagnetSetpoints{i});
    end


    a = unique(MagnetMonitors{i}.Data, 'rows');
    if size(a,1) == 1
        % Single power supply or ganged power supply
        figure;
        subplot(2,1,1);
        hist(MagnetMonitors{i}.Data(1,:),200);
        
        title(sprintf('%s: SP=%g, mean(AM)=%g, SP-mean(AM)=%g', ...
            MagnetSetpoints{i}.FamilyName, ...
            MagnetSetpoints{i}.Data(1,1), ...
            mean(MagnetMonitors{i}.Data(1,:)), ...
            MagnetSetpoints{i}.Data(1,1) - mean(MagnetMonitors{i}.Data(1,:))), 'FontSize',8);
        xlabel(MagnetMonitors{i}.UnitsString,'FontSize',8); 
        
        subplot(2,1,2);
        plot(MagnetMonitors{i}.tout, MagnetMonitors{i}.Data(1,:));
        title(sprintf('std(AM)=%.3g, max(AM-mean(AM))=%.3g', ...
            std(MagnetMonitors{i}.Data(1,:)), ... 
            max(abs(MagnetMonitors{i}.Data(1,:) - mean(MagnetMonitors{i}.Data(1,:))))), 'FontSize',8);        
        ylabel(MagnetMonitors{i}.UnitsString,'FontSize',8); 
        xlabel('Time [Seconds]','FontSize',8); 
        
        addlabel(1,0,sprintf('%s', datestr(MagnetMonitors{i}.TimeStamp)));
        orient tall
    else
        % Independent power supplies
        PlotBySector = 0;
        
        ElementList = dev2elem(MagnetMonitors{i}.FamilyName, MagnetMonitors{i}.DeviceList);
 
        [Sector, Nsectors, Ndevices] = sectorticks(MagnetMonitors{i}.DeviceList);
        %Spos = getspos(MagnetMonitors{i}.FamilyName, MagnetMonitors{i}.DeviceList);
        
        AMmean = mean(MagnetMonitors{i}.Data,2);
        AMstd = std(MagnetMonitors{i}.Data,0,2);
        
        %fprintf('   %s:  mean(AM)=%7.3f Amps,  SP-mean(AM)=%6.3f,  std(AM)=%5.3f Amps\n', MagnetMonitors{i}.FamilyName, AMmean, MagnetSetpoints{i}.Data-AMmean, AMstd);
        
        figure;
        subplot(4,1,1);
        if PlotBySector
            bar(Sector, AMmean);
            xaxis([1 Nsectors+1])
            set(gca,'XTick',1:Nsectors);
        else
            bar(ElementList, AMmean);
        end
        title(sprintf('%s Family (Units are in %s)', MagnetMonitors{i}.FamilyName, MagnetMonitors{i}.UnitsString));
        ylabel('mean(AM)','FontSize',8);
        %ylabel(sprintf('mean(AM) [%s]',MagnetMonitors{i}.UnitsString),'FontSize',8);
        grid on;
        
        ymax = max(AMmean);
        ymin = min(AMmean);
        extra = .05*(ymax-ymin);
        if extra < 1e6*eps
            extra = 1e6*eps;
        end
        if ~isnan(extra)
            yaxis([ymin-extra ymax+extra]);
        end
        
        subplot(4,1,2);
        if PlotBySector
            bar(Sector, MagnetSetpoints{i}.Data-AMmean);
            xaxis([1 Nsectors+1])
            set(gca,'XTick',1:Nsectors);
        else
            bar(ElementList, MagnetSetpoints{i}.Data-AMmean);
        end
        ylabel('SP-mean(AM)','FontSize',8);
        %ylabel(sprintf('SP-mean(AM) [%s]',MagnetMonitors{i}.UnitsString),'FontSize',8);
        grid on;
        
        subplot(4,1,3);
        if PlotBySector
            bar(Sector, AMstd);
            xaxis([1 Nsectors+1])
            set(gca,'XTick',1:Nsectors);
        else
            bar(ElementList, AMstd);
        end
        ylabel('std(AM)','FontSize',8);
        %ylabel(sprintf('std(AM) [%s]',MagnetMonitors{i}.UnitsString),'FontSize',8);
        grid on;
        
        subplot(4,1,4);
        % Outlier test
        clear AM_AMmeanMax
        for n = 1:size(AMmean,1)
            [tmp,j] = max(abs(MagnetMonitors{i}.Data(n,:)-AMmean(n)));
            AM_AMmeanMax(n,1) = MagnetMonitors{i}.Data(n,j)-AMmean(n);
        end
        if PlotBySector
            bar(Sector, AM_AMmeanMax);
            xaxis([1 Nsectors+1])
            set(gca,'XTick',1:Nsectors);
        else
            bar(ElementList, AM_AMmeanMax);
        end
        ylabel('max(AM-mean(AM))','FontSize',8);
        % ylabel(sprintf('max(AM-mean(AM)) [%s]',MagnetMonitors{i}.UnitsString),'FontSize',8);
        if PlotBySector
            xlabel('Sector Number');
        else
            xlabel('Element Number','FontSize',8);
        end
        grid on;
        
        addlabel(1,0,sprintf('%s', datestr(MagnetMonitors{i}.TimeStamp)));
        orient tall
        
        if PlotDataFlag == 2
            % Plot more stuff
            figure;
            
            % Worst SP-AMmean
            subplot(3,1,1);
            [tmp, k] = max(abs(MagnetSetpoints{i}.Data-AMmean));
            hist(MagnetMonitors{i}.Data(k,:), 200);
            title(sprintf('Worst SP-mean(AM): %s  SP=%g, mean(AM)=%g, SP-mean(AM)=%g', ...
                family2common(MagnetSetpoints{i}.FamilyName, MagnetSetpoints{i}.DeviceList(k,:)), ...
                MagnetSetpoints{i}.Data(k,1), ...
                AMmean(k), ...
                MagnetSetpoints{i}.Data(k,1) - AMmean(k)), ...
                'FontSize',8, ...
                'Interpret', 'None');
            xlabel(MagnetMonitors{i}.UnitsString,'FontSize',8); 
            a1 = axis;
            
            % Worst std(AM)
            subplot(3,1,2);
            [tmp, k] = max(AMstd);
            hist(MagnetMonitors{i}.Data(k,:), 200);
            title(sprintf('Worst std(AM): %s  SP=%g, mean(AM)=%g, std(AM)=%g', ...
                family2common(MagnetSetpoints{i}.FamilyName, MagnetSetpoints{i}.DeviceList(k,:)), ...
                MagnetSetpoints{i}.Data(k,1), ...
                AMmean(k), ...
                AMstd(k)), ...
                'FontSize',8, ...
                'Interpret', 'None');
            xlabel(MagnetMonitors{i}.UnitsString,'FontSize',8); 
            a2 = axis;
            
            % Worst max(AM-mean(AM))
            subplot(3,1,3);
            [tmp, k] = max(abs(AM_AMmeanMax));
            hist(MagnetMonitors{i}.Data(k,:), 200);
            title(sprintf('Worst max(AM-mean(AM)): %s  SP=%g, mean(AM)=%g, max(AM-mean(AM))=%g', ...
                family2common(MagnetSetpoints{i}.FamilyName, MagnetSetpoints{i}.DeviceList(k,:)), ...
                MagnetSetpoints{i}.Data(k,1), ...
                AMmean(k), ...
                AM_AMmeanMax(k)), ...
                'FontSize',8, ...
                'Interpret', 'None');
            xlabel(MagnetMonitors{i}.UnitsString,'FontSize',8); 
            a3 = axis;
            
            % Force all the x-axis to be the same
            %xaxis([min([a1(1) a2(1) a3(1)]) max([a1(2) a2(2) a3(2)])]);
            %subplot(3,1,1);
            %xaxis([min([a1(1) a2(1) a3(1)]) max([a1(2) a2(2) a3(2)])]);
            %subplot(3,1,2);
            %xaxis([min([a1(1) a2(1) a3(1)]) max([a1(2) a2(2) a3(2)])]);
            %addlabel(1,0,sprintf('%s', datestr(MagnetMonitors{i}.TimeStamp)));
            orient tall
        end
    end
end


for i = 1:length(BPMMonitors)
    if ~all(isnan(BPMMonitors{i}.Data))
        
        if strcmpi(UnitsFlag, 'physics')
            BPMMonitors{i}  = hw2physics(BPMMonitors{i});
        elseif strcmpi(UnitsFlag, 'hardware')
            BPMMonitors{i}  = physics2hw(BPMMonitors{i});
        end

        if Raw2RealFlag && strcmpi(BPMMonitors{i}.Units, 'Hardware')
            BPMMonitors{i}  = raw2real(BPMMonitors{i});
        end

        ElementList = dev2elem(BPMMonitors{i}.FamilyName, BPMMonitors{i}.DeviceList);
        
        if PlotDataFlag == 2
            % Plot more stuff
            figure;        
            subplot(2,1,1);
            plot(BPMMonitors{i}.tout, BPMMonitors{i}.Data);
            title(sprintf('%s Family (Raw Orbit Data)', BPMMonitors{i}.FamilyName));
            ylabel(sprintf('%s [%s]', BPMMonitors{i}.FamilyName, BPMMonitors{i}.UnitsString));
            axis tight;
            grid on;
        end        
        
        % Plot difference orbits
        Orbit0 = BPMMonitors{i}.Data(:,1);
        for j = size(BPMMonitors{i}.Data,2):-1:1
            BPMMonitors{i}.Data(:,j) = BPMMonitors{i}.Data(:,j) - Orbit0;
        end
        
        if PlotDataFlag == 2
            subplot(2,1,2);
            plot(BPMMonitors{i}.tout, BPMMonitors{i}.Data);
            title(sprintf('%s Family Difference Orbits from %s', BPMMonitors{i}.FamilyName, datestr(BPMMonitors{i}.TimeStamp,13)));
            ylabel(sprintf('%s [%s]', BPMMonitors{i}.FamilyName, BPMMonitors{i}.UnitsString));
            axis tight;
            grid on;
            
            addlabel(1,0,sprintf('%s', datestr(BPMMonitors{i}.TimeStamp)));
            orient tall
        end
        
        % Difference orbits
        DiffOrbits = diff(BPMMonitors{i}.Data, 1, 2);    
        %fprintf('   %s:  mean(AM)=%7.3f Amps,  SP-mean(AM)=%6.3f,  std(AM)=%5.3f Amps\n', BPMMonitors{i}.FamilyName, AMmean, BPMSetpoints{i}.Data-AMmean, AMstd);
        
        AMmean = mean(BPMMonitors{i}.Data,2);
        AMmax = max(BPMMonitors{i}.Data,[],2);
        AMmin = min(BPMMonitors{i}.Data,[],2);
        AMstd = std(BPMMonitors{i}.Data,0,2);
        AMstddetrend = std(detrend(BPMMonitors{i}.Data'))';
        
        figure;
        subplot(2,1,1);
        stairs(ElementList-.5, AMmean, 'b');
        hold on
        stairs(ElementList-.5, AMmax, 'r');
        stairs(ElementList-.5, AMmin, 'g');
        hold off
        title(sprintf('%s Family  (Deviation from the Starting Orbit)', BPMMonitors{i}.FamilyName));
        ylabel(sprintf('Max/Mean/Min [%s]', BPMMonitors{i}.UnitsString));
        grid on;
        
        
        subplot(2,1,2);
        stairs(ElementList-.5, AMstd, 'b');
        hold on;
        stairs(ElementList-.5, AMstddetrend, 'r');
        stairs(ElementList-.5, std(DiffOrbits,0,2)/sqrt(2), 'g');
        hold off
        ylabel(sprintf('STD [%s]', BPMMonitors{i}.UnitsString));
        xlabel('Element Number');
        legend('Raw data','Linear trend removed','Difference Orbits/sqrt(2)', 'Location', 'Best');
        grid on;
        
        addlabel(1,0,sprintf('%s', datestr(BPMMonitors{i}.TimeStamp)));
        orient tall
    end
end


% Convert back to structures
if ~isstruct(MagnetMonitors)
    MagnetMonitors     = cell2field(MagnetMonitors);
    MagnetSetpoints    = cell2field(MagnetSetpoints);
    MagnetSetpointsEnd = cell2field(MagnetSetpointsEnd);
end
if ~isempty(BPMMonitors)
    if ~isstruct(BPMMonitors)
        BPMMonitors = cell2field(BPMMonitors);
    end
end

