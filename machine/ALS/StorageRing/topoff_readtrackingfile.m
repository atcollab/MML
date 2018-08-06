function [Data, FileNameBase] = topoff_readtrackingfile(FileName)
%TOPOFF_READTRACKINGFILE - Read Hiroshi's top-off tracking files
%  [Data, FileName] = topoff_readtrackingfile(FileName)
%
%  INPUTS
%  1. FileName - Tracking file name (extension not necessary)
%
%  OUTPUTS
%  1. Data - Structure of data and parameters
%
%  See also topoff_plottrackingfile, topoff_apertures, topoff_fieldprofiles


if nargin == 0 || isempty(FileName)
    [FileName, PathName] = uigetfile('*.csv', 'Tracking file ...');
    if ~ischar(FileName)
        Data =[]; 
        FileNameBase = [];
        return
    end
    FileName = [PathName, FileName];
end

[PathName, FileName, ext] = fileparts(FileName);
if isempty(PathName)
    FileNameBase = [FileName];
else
    FileNameBase = [PathName, filesep, FileName];
end

% Get the phase space info
[fid, errmsg]  = fopen([FileNameBase, '.iphs'],'r');
if fid==-1
    error('Could not open file');
end

LINE1 = fgetl(fid);
LINE2 = fgetl(fid);

LINE = fgetl(fid);
i = findstr(LINE,'|');
Data.x0     = str2double(LINE(i(2)+1:i(3)-1));
Data.xMin   = str2double(LINE(i(3)+1:i(4)-1));
Data.xMax   = str2double(LINE(i(4)+1:i(5)-1));
Data.xDelta = str2double(LINE(i(5)+1:end));
Data.xSteps = length(Data.xMin:Data.xDelta:Data.xMax);

LINE = fgetl(fid);
i = findstr(LINE,'|');
Data.Px0     = str2double(LINE(i(2)+1:i(3)-1));
Data.PxMin   = str2double(LINE(i(3)+1:i(4)-1));
Data.PxMax   = str2double(LINE(i(4)+1:i(5)-1));
Data.PxDelta = str2double(LINE(i(5)+1:end));
Data.PxSteps = length(Data.PxMin:Data.PxDelta:Data.PxMax);

LINE = fgetl(fid);
i = findstr(LINE,'|');
Data.dPx0     = str2double(LINE(i(2)+1:i(3)-1));
Data.dPxMin   = str2double(LINE(i(3)+1:i(4)-1));
Data.dPxMax   = str2double(LINE(i(4)+1:i(5)-1));
Data.dPxDelta = str2double(LINE(i(5)+1:end));
Data.dPxSteps = length(Data.dPxMin:Data.dPxDelta:Data.dPxMax);

fclose(fid);

Data.x = (Data.xMin:Data.xDelta:Data.xMax)';
Data.Px = (Data.PxMin:Data.PxDelta:Data.PxMax)';


% Get the tracking data
if exist([FileNameBase, '.csv'],'file')
    % Raw tracking data
    CSVFlag = 1;
    %[fid, errmsg]  = fopen([FileNameBase, '.csv'],'r');
    %if fid==-1
    %    error('Could not open file');
    %end
    Data.Data = load([FileNameBase, '.csv'], '-ascii');
    Data.Data(Data.Data(:,3)==10000000000,3) = NaN;
else
    % Bitmap data
    CSVFlag = 0;
    [fid, errmsg]  = fopen([FileNameBase, '.dat'],'r');
    if fid==-1
        error('Could not open file');
    end

    LINE1 = fgetl(fid);
    LINE2 = fgetl(fid);
    %LINE3 = fgetl(fid);
    Tmp = fscanf(fid,'%d,%d,%f,%f,%f',[1 5]);
    M = Tmp(1);
    N = Tmp(2);

    Tmp = fscanf(fid,'%d,%d,%f,%f,%f');
    Data.Data = reshape(Tmp',5,length(Tmp)/5)';
    % i = 0;
    % while 1
    %     Tmp = fscanf(fid,'%d,%d,%f,%f,%f',[1 5]);
    %     if length(Tmp) ~= 5
    %         break
    %     else
    %         i = i + 1;
    %         Data.Data(i,:) = Tmp;
    %     end
    % end
    fclose(fid);

    Data.Data = Data.Data(:,[4 5 3]);

    % d = NaN * ones(max(Data.Data(:,1)), max(Data.Data(:,2)));
    % for i = 1:size(Data.Data,1)
    %     d(Data.Data(i,1),Data.Data(i,2)) = Data.Data(i,3);
    % end

    % Start distance at the launch point
    %Data.Data(:,3) = Data.Data(:,3) - 8.6;

    % Bad data
    %Data.Data(find(Data.Data(:,1)==0),1) = 0.34;
    %Data.Data(find(Data.Data(:,2)==0),2) = 0.3;
end

if size(Data.Data,1) == 1
    Data.Z = Data.Data(1,3);
    Data.x = Data.Data(1,1);
    Data.Px = Data.Data(1,2);
elseif (Data.xSteps*Data.PxSteps) == size(Data.Data,1)
    d = diff(Data.Data(:,1));
    i = find(d ~=0);
    i = i(1);

    %Data.X = reshape(Data.Data(:,1),i,size(Data.Data,1)/i);
    %Data.Y = reshape(Data.Data(:,2),i,size(Data.Data,1)/i);
    Data.Z = reshape(Data.Data(:,3),i,size(Data.Data,1)/i);

    % Change Z to be from low to high
    if ~CSVFlag
        %Data.Y = Data.Y(end:-1:1);
        Data.Z = Data.Z(end:-1:1,:);
    end
else
    [XI,YI] = meshgrid(Data.x, Data.Px);
    [XI,YI,Data.Z] = griddata(Data.Data(:,1), Data.Data(:,2), Data.Data(:,3), XI, YI, 'linear');

    % Remove rows or columns that are all NaN
    for i = size(Data.Z,2):-1:1
        if all(isnan(Data.Z(:,i)))
            Data.Z(:,i) = [];
            Data.x(i) = [];
            %Data.xSteps = Data.xSteps - 1;
        end
    end
    for i = size(Data.Z,1):-1:1
        if all(isnan(Data.Z(i,:)))
            Data.Z(i,:) = [];
            Data.Px(i) = [];
            %Data.PxSteps = Data.PxSteps - 1;
        end
    end
end


Data = rmfield(Data, 'Data');

