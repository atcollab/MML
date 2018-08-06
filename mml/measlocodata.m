function measlocodata(varargin)
%MEASLOCODATA - Measures a set of LOCO data
%
%  measlocodata(DirectoryName, DisplayFlag)
%
%  INPUTS
%  1. DirectoryName - Directory name for where to write the LOCO data files.
%                     If empty and DisplayFlag is on, then a dialog box will be used to select a directory.
%                     If empty and DisplayFlag is off, then the directory will chosen based on the date & time.
%
%  2. DisplayFlag -   'Display' - Dialog boxes will ask questions for what to measure, orbit correction, and pause 
%                                 before starting the measurement.  {'Display' is the default behavior} 
%                   'NoDisplay' - No questions will be asked.  The behavior for 'NoDisplay' is,
%                                 a. Measure dispersion
%                                 b. Measure the BPM response matrix
%                                 c. Measure the BPM noise (sigma)
%                                 d. Do not correct the orbit (the use should already have the proper orbit loaded)
%  3. ModeFlag - Optional mode overrides: 'Online', 'Simulator', 'Model'
%

%  Written by Greg Portmann


% Minimum beam current to make measurement
MinCurrent = .1;


% Input checking
DirectoryName = '';
DisplayFlag = 1;
ModeFlag = '';
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Model')
        ModeFlag = 'Model';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        ModeFlag = 'Online';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Simulator')
        ModeFlag = 'Simulator';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end


if length(varargin) >=1 
    DirectoryName = varargin{1};
end



% Get the directory location
if isempty(DirectoryName)
    c = clock;
    DirectoryName = [getfamilydata('Directory', 'DataRoot'), 'LOCO', filesep];
    DirectoryName = sprintf('%s%s', DirectoryName, datestr(c,29));  % Year-Month-Day
    DirectoryName = [DirectoryName, filesep, sprintf('%02d-%02d-%02.0f', c(4), c(5), c(6))];  % Hour-Minute-Second

    if DisplayFlag
        AnswerString = questdlg(strvcat(strvcat(strvcat(strvcat(strvcat( ...
            'Choose directory where all the LOCO data is written.', ...
            'The default directory location is:'), ...
            sprintf('%s\n',DirectoryName)),' '), ...
            'Yes - Use this directory'),'No - Select a new directory'), ...
            'LOCO Mesurement Setup','Yes','No','Yes');

        if strcmp(AnswerString,'No')
            DirectoryName = [getfamilydata('Directory', 'DataRoot'), 'LOCO', filesep];
            DirectoryName = uigetdir(DirectoryName, 'Select a directory to put the LOCO data');
            if DirectoryName == 0
                fprintf('   LOCO data measurement cancelled\n');
                return
            end
        end
    end
end


% Create the directory
DirStart = pwd;
[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
cd(DirStart);
       


if DisplayFlag
    DispersionString   = questdlg({'A Dispersion function measurement is needed for LOCO.', ' ','Should this function measure a Dispersion function?'},'LOCO Mesurement Setup','Yes','No','Yes');
    BPMSigmaString     = questdlg({'A BPM Sigma measurement is needed for LOCO.', ' ','Should this function measure the BPM Sigma?'},'LOCO Mesurement Setup','Yes','No','Yes');
    BPMResponseMatrix  = questdlg({'A BPM Response Matrix measurement is needed for LOCO.', ' ','Should this function measure the BPM Response Matrix?'},'LOCO Mesurement Setup','Yes','No','Yes');
    CorrectorOrbitFlag = 'No'; %questdlg({'The proper orbit can be important for a LOCO measurement.', ' ','Should this function correct the orbit (using setorbitdefault) at the start?'},'LOCO Mesurement Setup','Yes','No','No');

    %StartFlag = questdlg('Start the LOCO measurement?','LOCO Mesurement','Yes','No','Yes');
    StartFlag = questdlg({'Start the LOCO measurement?',' ','(Make sure the orbit is ok.)'},'LOCO Mesurement','Yes','No','Yes');
    if ~strcmpi(StartFlag, 'Yes')
        fprintf('   LOCO data measurement cancelled\n');
        return
    end
else
    DispersionString = 'Yes';
    BPMSigmaString = 'Yes';
    BPMResponseMatrix = 'Yes';
    CorrectorOrbitFlag = 'No';
end


TimeStart = gettime;
[N, T] = getbpmaverages;
T = max(T);


% Correct the orbit
if strcmpi(CorrectorOrbitFlag, 'Yes')
    if getdcct < MinCurrent
        fprintf('   LOCO measurement stopped due to beam current < %f mAmps\n', MinCurrent);
        return
    end
    try
        fprintf('   Correcting the orbit\n');
        setorbitdefault('NoDisplay');
        pause(T * 2.5);
        clf reset
        plotorbit;
        drawnow;
        fprintf('   Orbit correction complete\n\n');

        if DisplayFlag
            ContinueFlag = questdlg(strvcat(strvcat('The orbit has been corrected using the setorbitdefault function.', ' '),'Check that the orbit is good before continuing.  Continue?'),'LOCO Mesurement Setup','Yes','No','Yes');
            if ~strcmpi(ContinueFlag, 'Yes')
                fprintf('   LOCO data measurement cancelled\n');
                return
            end
        end
    catch
        ErrorString = questdlg(strvcat('There was a problem correcting the orbit.','Do you want to continue taking LOCO data?'),'LOCO','Yes','No','No');
        if ~strcmpi(ErrorString, 'Yes')
            fprintf('   LOCO data measurement cancelled\n');
            return
        end
    end
end


% Set the nominal gains/roll for BPMs and Correctors
setlocodata('Nominal');
fprintf('   Run aoinit or setoperationalmode after measlocodata completes to return to the default values.\n');


% Measure dispersion
if strcmpi(DispersionString, 'Yes')
    if getdcct < MinCurrent
        fprintf('   LOCO measurement stopped due to beam current < %f mAmps\n', MinCurrent);
        return
    end
    fprintf('   Measuring dispersion\n');
    if isempty(ModeFlag)
        [Dx, Dy, FileName] = measdisp('Struct','Archive','Display');
    else
        [Dx, Dy, FileName] = measdisp('Struct','Archive','Display',ModeFlag);
    end
    copyfile(FileName, DirectoryName);
    try
        clf reset
        plotdisp(Dx, Dy, 'Physics');
        drawnow;
    catch
        fprintf('\n   There was a problem plotting the dispersion function.\n');
        fprintf(  '   Take a good look at the dispersion data before using it.\n');
    end
    fprintf('\n');
end


% Measure BPM response matrix
if strcmpi(BPMResponseMatrix, 'Yes')
    if getdcct < MinCurrent
        fprintf('   LOCO measurement stopped due to beam current < %f mAmps\n', MinCurrent);
        return
    end
    FileName = [getfamilydata('Directory', 'BPMResponse'), getfamilydata('Default', 'BPMRespFile')];
    FileName = appendtimestamp(FileName);
    if isempty(ModeFlag)
        [Rmat, FileName] = measbpmresp('Archive', FileName);   % 'MinimumBeamCurrent', ???
        %[Rmat, FileName] = measbpmresp;
    else
        [Rmat, FileName] = measbpmresp('Archive', FileName, ModeFlag);   % 'MinimumBeamCurrent', ???
    end
    copyfile(FileName, DirectoryName);

    try
        clf reset
        plotbpmresp(FileName);
        drawnow;
    catch
        fprintf('\n   There was a problem plotting the BPM response matrix.\n');
        fprintf(  '   Take a good look at the data before using it.\n');
    end
    fprintf('   BPM response matrix measurement complete\n\n');
end


% Measure BPM sigma
if strcmpi(BPMSigmaString, 'Yes')
    if getdcct < MinCurrent
        fprintf('   LOCO measurement stopped due to beam current < %f mAmps\n', MinCurrent);
        return
    end
    fprintf('   Measuring BPM sigma\n');
    if T == 0
        T = .5;
    end
    if isempty(ModeFlag)
        [BPMx, BPMy, FileName] = monbpm(0:T:3*60, 'Struct', 'Archive');
    else
        [BPMx, BPMy, FileName] = monbpm(0:T:3*60, 'Struct', 'Archive', ModeFlag);
    end
    copyfile(FileName, DirectoryName);
    fprintf('   BPM noise measurement complete\n\n');
end

fprintf('   The total measurement time was %.2f minutes.\n', (gettime-TimeStart)/60);
fprintf('   LOCO measurement complete\n\n');



