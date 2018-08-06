function arread(InputDate, BooleanFlag)
%ARREAD - Loads one day of archived data into matlab global memory
%  arread(Date, BooleanFlag)
%
%  INPUTS
%  1. Date - 'yearmonthdat', example, arread('20021031')
%  2. BooleanFlag - 0, no booleans are read (default)
%                  else, floats and booleans are read
%
%  OUTPUTS - arread creates 4 global matrices
%  1. ARt - time vector for that day
%  2. ARData - channel data
%  3. ARChanNames - list of channel names
%  4. ARDate - the date
%
%  Use arglobal to make these variables available in the workspace
%
%  NOTE
%  1. Archived data before 95-10-27 has a different format and does
%     not include boolean data.  Use arreadold.m to access this data.
%  2. Archived data before 1998-11-01 uses a 2 digit year.  Arread automatically
%     accounts for this.
%  3. There are approximately 4100 boolean channels.  If you don't need  
%     boolean channels, BooleanFlag=0 save time and memory.
%
%  See also arplot_sr


% Revision history:
%
% 2002-07-23, Christoph Steier
% Updated search paths for PC version and corrected minor bugs to make function
% work on the PCs again.


global ARt ARData ARChanNames ARDate ARNumAnalog ARNumBinary ARChanNamesCell

if nargin < 2
    BooleanFlag = 0;
end


% Y2K complient
ARDate = InputDate;
if length(ARDate)==6 && ((str2num(ARDate(1:2))==98 && str2num(ARDate(3:4)) >= 11) || str2num(ARDate(1:2))>=99)
    ARDate = ['19',InputDate];
end


% Read Data
t0 = clock;
if ispc || strncmp(computer, 'GLNX', 4) || strncmp(computer, 'SOL64', 5) ||  strncmp(computer, 'MACI64', 6)
    % Use Matlab fopen/fread
    
    if ispc == 1
        % PC read
        versionstr = version;
        if strcmp(versionstr(1),'4')
            DirName = '\\Als-filer\als6\archdata\als_ar~1';
        else
            DirName = '\\Als-filer\als6\archdata\als_archive';
        end
    elseif  strncmp(computer, 'MACI64', 6)
        DirName = '/Volumes/als6/archdata/als_archive';
    else
        DirName = '/home/als6/archdata/als_archive';        % Unix file system
    end

    fn = [DirName, filesep, ARDate,'.bin'];
    fid = fopen(fn, 'r', 'b');
    if fid < 0
        fprintf(2, 'Couldn''t find and/or open archived file %s \n', fn);
        fprintf(2, 'The requested archived file likely doesn''t exist on the file system.\n');
        fprintf(2, 'A file permissions issue would be my second guess.\n\n');
        error(' ');
    end

    % Get the number of channels
    NumChannels  = fread(fid, 1, 'int'); ARNumAnalog = NumChannels;
    NumBinary    = fread(fid, 1, 'int'); ARNumBinary = NumBinary;
    NumSnapShots = fread(fid, 1, 'int');

    disp(['                          File name = ', fn]);
    disp(['  Number of floating point channels = ', num2str(NumChannels)]);
    fprintf('         Number of boolean channels = %d', NumBinary);
    if ~BooleanFlag
        fprintf(' (boolean channels will not be read)\n');
    else
        fprintf('\n');
    end
    disp(['                  Number snap shots = ', num2str(NumSnapShots)]);
    pause(.01);

    
    % Read time vector
    ARt = fread(fid, [1,NumSnapShots], 'long');
    
    % Init arrays
    if BooleanFlag
        if ~all(size(ARData) == [NumChannels+NumBinary NumSnapShots])
            ARData = zeros(NumChannels+NumBinary, NumSnapShots);
            ARChanNames = zeros(NumChannels+NumBinary, 40);
        end
    else
        if ~all(size(ARData) == [NumChannels NumSnapShots])
            ARData = zeros(NumChannels, NumSnapShots);
            ARChanNames = zeros(NumChannels, 40);
        end
    end


    % Read floating point channels
    for i = 1:NumChannels
        %ARChanNames(i,:) = sprintf('%s', fread(fid, 40, 'char'))        %str2mat(ARChanNames, );
        name=sprintf('%s', char(fread(fid, 40, 'char')));        
        c=size(name,2);
        ARChanNames(i,1:c) = name;
        
        ARData(i,:) = fread(fid, [1,NumSnapShots], 'float');
    end

    if BooleanFlag
        for i = 1:NumBinary
            name=sprintf('%s', char(fread(fid, 40, 'char')));
            c=size(name,2);
            ARChanNames(i+NumChannels,1:c) = name;
            
% if i== 8430
%     i
% end
            ARData(i+NumChannels,:) = fread(fid, [1,NumSnapShots], 'char');
        end
    end

    %   ARData = ARData';
    ARChanNames = setstr(ARChanNames);  % Note: change this to char for Matlab 7 and up

    fclose(fid);
    deltaT=etime(clock, t0);
    fprintf('                  Time to read data = %f seconds\n', deltaT);
    pause(.01);

else  
    % Solaris (compiled version)
    %DirName = '.'
    DirName = '/home/als6/archdata/als_archive';


    global GLOBAL_ALSDATA_DIRECTORY
    if exist([DirName,'/',ARDate,'.bin'])==2
        [ARData, ARChanNames, ARt] = argetdata(ARDate, BooleanFlag, DirName);
    elseif exist([GLOBAL_ALSDATA_DIRECTORY,ARDate,'.bin'])==2
        [ARData, ARChanNames, ARt] = argetdata(ARDate, BooleanFlag, GLOBAL_ALSDATA_DIRECTORY(1:end-1));
    else
        [ARData, ARChanNames, ARt] = argetdata(ARDate, BooleanFlag);     % If local file
    end


    ARData = ARData';
    ARChanNames = setstr(ARChanNames');

    deltaT=etime(clock, t0);
    fprintf('  Time to read data = %f seconds\n', deltaT);
    pause(.01);
end

ARChanNamesCell=cell(length(ARChanNames),1);
for loop=1:length(ARChanNames)
    ARChanNamesCell{loop}=ARChanNames(loop,:);
end


%[ARChanNames,I]=sort(ARChanNames);
%ARData = ARData(I,:);

