function HTMLFileName = publish_epbi(EPBIFileName)
%PUBLISH_EPBI
%
%  See also epbitest2 getepbichannelnames getepbiwaveform plotepbiwaveform publish_epbi

%  Written by Greg Portmann

% For the compiler
%#function publish

DirStart = pwd;

% Directory
if isunix
    EPBIRootDir = '/home/als/physdata/';
else
    EPBIRootDir = '\\als-filer\physdata\';
end

if nargin <1 || isempty(EPBIFileName)
    [PlotFile, DirectoryPath] = uigetfile({'*.mat','MAT-files (*.mat)'},'Pick an EPBI file', 'MultiSelect', 'off', [EPBIRootDir, 'EPBI']);
    if PlotFile == 0
        return
    end
    EPBIFileName = [DirectoryPath, PlotFile];
else
    %EPBIFileName = 'C:\Users\portmann\Documents\ALS\EPBI\ShiftData\2012-01-08\EPBI11_Upper_Test3_Set2';
    %EPBIFileName = '/home/physdata/matlab/StorageRingData/TopOff/EPBI/2011-11-29/EPBI11_Upper_Test3_Set1';
    %EPBIFileName = '/home/physdata/matlab/StorageRingData/TopOff/EPBI/2011-11-29/EPBI11_Upper_Test3_Set1';
end

load(EPBIFileName);

% if length(EPBIFileName)>4 && strcmpi(EPBIFileName(end-3:end),'.mat')
%     EPBIFileName = which(EPBIFileName);
% else
%     EPBIFileName = which([EPBIFileName,'.mat']);
% end


if exist('EPBIData','var')
    % Test 2
    PubDir = [EPBIRootDir, 'EPBI', filesep, 'Publish', filesep, 'Test2'];
   %PubDir = [EPBIRootDir, 'EPBI', filesep, 'Publish', filesep, 'Test2', filesep, datestr(EPBIData.DataTime(1,1),29), filesep, datestr(EPBIData.DataTime(1,1),'HH-MM-SS')];
else
    % Test 3
    PubDir = [EPBIRootDir, 'EPBI', filesep, 'Publish', filesep, 'Test3'];
    %PubDir = [EPBIRootDir, 'EPBI', filesep, 'Publish', filesep, 'Test3', filesep, datestr(TimeStamp(1,1),29), filesep, datestr(TimeStamp(1,1),'HH-MM-SS')];
    %PubDir = [getfamilydata('Directory','DataRoot'), 'EPBI', filesep, 'Publish', filesep, datestr(TimeStamp(1,1),29), filesep, datestr(TimeStamp(1,1),'HH-MM-SS')];
    %PubDir = appendtimestamp(PubDir, TimeStamp(1,1));
end

[PubDir, DirErrorFlag] = gotodirectory(PubDir);
if DirErrorFlag
    fprintf('   Warning: %s was not the desired directory for EPBI data.\n', PubDir);
end

PubFile = WriteEPBIDataToFile(EPBIFileName);
PubDir = pwd;

options.format = 'html';
options.outputDir = pwd; %DirectoryName;
options.showCode = false;
HTMLFileName = publish(PubFile, options);

% Open website
web([PubFile(1:end-2),'.html']);

cd(DirStart);



function [PubFile, PubDir] = WriteEPBIDataToFile(EPBIFileName)


load(EPBIFileName);

if ~exist('EPBIData','var')
    EPBIData.Desc = 'EPBI Test3';
end

if strcmpi(EPBIData.Desc, 'EPBI Test2')
    % Test #2
    
   %PubFile = sprintf('EPBI_Test2_Sector%d_%s.m', EPBIData.Sector, EPBIData.HeaterName);
   %PubFile = sprintf('EPBI_Test2_Sector%d_%s_%s_%s.m', EPBIData.Sector, EPBIData.HeaterName, datestr(EPBIData.DataTime(1,1),29), datestr(EPBIData.DataTime(1,1),'HH-MM-SS'));
    PubFile = sprintf('EPBI_Test2_Sector%d_%s_%s.m', EPBIData.Sector, EPBIData.HeaterName, datestr(EPBIData.DataTime(1,1),'yyyy_mm_dd_HH_MM_SS'));
    
    %PubFile = 'EPBI_Publish.m';
    fid = fopen(PubFile, 'w');
    
    fprintf(fid, '%%%% EPBI Test #2 on %s\n', datestr(EPBIData.DataTime(1,1), 31));
    PrintBlueLine(fid, sprintf('  Sector %d, %s', EPBIData.Sector, EPBIData.HeaterName));
    %PrintBlueLine(fid, '  Unit A & B');
    
    fprintf(fid, '\n');
    fprintf(fid, '%%%% Plot\n');
    fprintf(fid, 'function publish_EPBI_Plot\n');
    fprintf(fid, 'hfig=plotepbitest2(''%s'', ''html''); drawnow; snapnow; close(hfig);\n',EPBIFileName);
    fprintf(fid, '\n');
    pause(0);
    
    fprintf(fid, '%%%% Column Names\n');
    PrintOrangeLine(fid, sprintf('Column %02d  -> Measurement Time [seconds]', 1));
    for i = 1:size(EPBIData.ChannelNames, 1)
        PrintOrangeLine(fid, sprintf('Column %02d  -> %s [C]   (Limit %.2f)', i+1, deblank(EPBIData.ChannelNames(i,:)),EPBIData.Limit(i)));
    end
    
    fprintf(fid, '%%%% Data\n');
    %fprintf(fid, '%% |MONOSPACED TEXT|\n');
    
    for j = 1:size(EPBIData.TC, 2)
        % Time
        %DataLine = [datestr(TimeStamp(1,j),13)];
        DataLine = sprintf('%.3f', EPBIData.t(j)-EPBIData.t(1));
        
        % TC
        for i = 1:size(EPBIData.TC, 1)
            DataLine = [DataLine, '  ', sprintf('%.2f', EPBIData.TC(i,j))];
        end
                
        if any(EPBIData.TripIndex == j)
            iTrip = find(EPBIData.TripIndex == j);
            for ii = iTrip(:)'
                DataLine = [DataLine, ' ', sprintf('%s', deblank(EPBIData.ChannelNames(ii,9:end-4)) )];
            end
            DataLine = [DataLine, ' Tripped'];
            MakeRed = 1;
        else
            MakeRed = 0;
        end
        
        if MakeRed
            PrintRedLine(fid,  DataLine);
        else
            PrintBlueLine(fid, DataLine);
        end
    end

else
    
    % Test #3
    if UpperFlag
       %PubFile = sprintf('EPBI_Test3_Sector%d_Upper.m', Sector);
        PubFile = sprintf('EPBI_Test3_Sector%d_Upper_%s.m', Sector, datestr(TimeStamp(1,1),'yyyy_mm_dd_HH_MM_SS'));
    else
       %PubFile = sprintf('EPBI_Test3_Sector%d_Lower.m', Sector);
        PubFile = sprintf('EPBI_Test3_Sector%d_Lower_%s.m', Sector, datestr(TimeStamp(1,1),'yyyy_mm_dd_HH_MM_SS'));
    end
    %PubFile = 'EPBI_Test3.m';
    
    fid = fopen(PubFile, 'w');
    
    fprintf(fid, '%%%% EPBI Test #3 on %s\n', datestr(TimeStamp(1,1), 31));
    PrintBlueLine(fid, sprintf('  Sector %d', Sector));
    PrintBlueLine(fid, '  Unit A & B');
    if UpperFlag
        PrintBlueLine(fid, '  Upper Thermocouples');
        ChannelName(10:18,:) = [];
        Data(10:18,:) = [];
    else
        PrintBlueLine(fid, '  Lower Thermocouples');
        ChannelName(1:9,:) = [];
        Data(1:9,:) = [];
    end
    %PrintBlueLine(fid, '  ');
    
    fprintf(fid, '\n');
    fprintf(fid, '%%%% Plot\n');
    fprintf(fid, 'function publish_EPBI_Plot\n');
    fprintf(fid, 'hfig=plotepbitest3(''%s'', ''html''); drawnow; snapnow; close(hfig);\n',EPBIFileName);
    fprintf(fid, '\n');
    
    fprintf(fid, '%%%% Column Names\n');
    PrintBlueLine(fid, sprintf('Column %02d  -> Measurement Time [seconds]', 1));
    for i = 1:9  %size(ChannelName, 1)
        PrintBlueLine(fid, sprintf('Column %02d  -> %s [C]', i+1, deblank(ChannelName(i,:))));
    end
    i = i+1; PrintBlueLine(fid, sprintf('Column %02d  -> %s (Unit A relay)', i+1, deblank(ChannelName(i,:))));
    i = i+1; PrintBlueLine(fid, sprintf('Column %02d  -> %s (Unit B relay)', i+1, deblank(ChannelName(i,:))));
    for i = 12:15
        PrintBlueLine(fid, sprintf('Column %02d  -> %s [um] (Difference orbit)', i+1, deblank(ChannelName(i,:))));
    end
    i = i+1; PrintBlueLine(fid, sprintf('Column %02d  -> %s [Amps] (VCM AM Difference)', i+1, deblank(ChannelName(i,:))));
    
    fprintf(fid, '%%%% Data\n');
    %fprintf(fid, '%% |MONOSPACED TEXT|\n');
    
    for j = 1:size(Data, 2)
        % Time
        %DataLine = [datestr(TimeStamp(1,j),13)];
        DataLine = sprintf('%.3f',t(j));
        
        % TC
        for i = 1:9 %size(Data, 1)
            DataLine = [DataLine, '  ', sprintf('%.1f',Data(i,j))];
        end
        
        % Relay
        DataLine = [DataLine, '  ', sprintf('%d',Data(10,j))];
        DataLine = [DataLine, '  ', sprintf('%d',Data(11,j))];
        
        % Orbit
        for i = 12:15
            DataLine = [DataLine, '  ', sprintf('%+05d',round(1000*(Data(i,j)-Data(i,1))))];
        end
        
        % VCM AM
        DataLine = [DataLine, '  ', sprintf('%5.2f',Data(16,j)-Data(16,1))];
        
        % Printline
        if Data(10,j) == 1 && Data(11,j) == 1
            PrintOrangeLine(fid, DataLine);
        elseif Data(10,j) == 1 || Data(11,j) == 1
            PrintRedLine(fid, DataLine);
        else
            PrintBlueLine(fid, DataLine);
        end
        %fprintf(fid, '%% %s', DataLine);
        
        % Orbit
        
    end
end

fclose(fid);
pause(1);



function PrintBlueLine(fid, PrintString)
fprintf(fid, '%% <html><span style="font-family : Courier;color: #0066CC;">%s</span></html>\n%%\n', PrintString);
%fprintf(fid, '%% <html><span style="font-family : Monospaced;color: #0066CC;">%s</span></html>\n%%\n', PrintString);


function PrintRedLine(fid, PrintString)
fprintf(fid, '%% <html><span style="font-family : Courier;color: #CC0000;">%s</span></html>\n%%\n', PrintString);
%fprintf(fid, '%% <html><span style="font-family : Monospaced;color: #CC0000;">%s</span></html>\n%%\n', PrintString);


function PrintOrangeLine(fid, PrintString)
fprintf(fid, '%% <html><span style="font-family : Courier;color: #CC6600;">%s</span></html>\n%%\n', PrintString);
%fprintf(fid, '%% <html><span style="font-family : Monospaced;color: #CC6600;">%s</span></html>\n%%\n', PrintString);




