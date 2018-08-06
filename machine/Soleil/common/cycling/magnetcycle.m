function magnetcycle(varargin)
%MAGNETCYCLE - Standardize machine magnets
%
%  INPUTS
%  1. LatticeFile -'Present' {Default} - cycle to present setpoints
%                  'Golden'  - cycle to the golden lattice setpoints
%                  'UserSelect' - cycle to a selected file (a pop up to choose will be displayed)
%                   LatticeFilename - cycle to the ConfigSetpoint in that file
%
%  Optional input arguments
%  2. Cells of Families - for instance {'CH','CV'} or {'QP'}
%  3. 'Display' or 'NoDisplay' - to verify before standardizing and display results (or not)
%  4. Machine type - 'LT1', 'LT2', 'StorageRing', 'Booster'
%                     Default is given by mml via getfamilydata('SubMachine')
%  5. 'NoApply' - just configure but does not start cycling
%
%  EXAMPLES
%  1. magnetcycle('Golden')
%  2. magnetcycle('Golden',{'CH'}) % cycle only CH family to golden
%  values
%
% See Also setcyclecurve, getcyclingcurve, plotcyclingcurve, LT1cycling

%
%  Written by Laurent S. Nadolski

% TODO: Display part, cycle single element, cycle set of families (not
% all)

DisplayFlag = 1;
ApplyFlag = 1;

LatticeFileDefault = 'Present';
ConfigFlag = 1; % confirm before modifying cycling ramp

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parsing and checking %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Present')
        LatticeFile = 'Present';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Golden')
        LatticeFile = 'Golden';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'UserSelect')
        LatticeFile = 'UserSelect';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'LT1')
        Machine = 'LT1';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Booster')
        Machine = 'Booster';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'LT2')
        Machine = 'LT2';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'StorageRing')
        Machine = 'StorageRing';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoConfig')
        ConfigFlag = 0;
    elseif strcmpi(varargin{i},'Config')
        ConfigFlag = 1;
    elseif strcmpi(varargin{i},'Apply')
        ApplyFlag = 1;
    elseif strcmpi(varargin{i},'NoApply')
        ApplyFlag = 0;        
    elseif iscell(varargin{i})
        Magnet = varargin{i};
        varargin(i) = [];
    end
end

if ~exist('LatticeFile','var')
    LatticeFile = LatticeFileDefault;
end

if ~exist('Machine','var')
    Machine = getfamilydata('SubMachine');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the proper lattice %
%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(LatticeFile, 'UserSelect')
    [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat', 'Select a Machine Configuration File for Standardization', getfamilydata('Directory', 'ConfigData'));
    if FilterIndex == 0
        if strcmpi(DisplayFlag, 'Display')
            fprintf('   %s standardization cancelled\n', Machine);
        end
        return
    end
    try
        load([DirectoryName FileName]);
        Lattice = ConfigSetpoint;
    catch
        error('Problem getting data from machine configuration file\n%s',lasterr);
    end
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to the lattice file %s\n', [DirectoryName FileName]);
    end
elseif strcmpi(LatticeFile, 'Present')
    % Present lattice
    Lattice = getmachineconfig;
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to the present lattice\n');
    end
elseif strcmpi(LatticeFile, 'Golden')
    % Golden lattice
    FileName = getfamilydata('OpsData', 'LatticeFile');
    DirectoryName = getfamilydata('Directory', 'OpsData');
    load([DirectoryName FileName]);

    Lattice = ConfigSetpoint;
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to the golden lattice %s\n', [DirectoryName FileName]);
    end
elseif ischar(LatticeFile)
    load(LatticeFile);
    Lattice = ConfigSetpoint;
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to lattice file %s\n', LatticeFile);
    end
else
    error('Not sure what lattice to cycle to!');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Query to begin measurement %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(DisplayFlag, 'Display')
    tmp = questdlg(['Begin ' getfamilydata('Machine') ' standardization?'], ...
        'MAGNETCYCLE','Yes','No','No');
    if strcmpi(tmp,'No')
        fprintf('   Lattice standardization cancelled\n');
        return
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set cycling curves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Family = fieldnames(Lattice);

% select only asked families
if exist('Magnet','var') && ~isempty(Magnet)
    if iscell(Magnet)
        for k = 1:length(Magnet),
            % For C13 Family special trick to reconstruct the family
            if strcmpi(Magnet{k},'QC13')
                LatticeN.QC13.Setpoint.Data = [
                    Lattice.Q1.Setpoint.Data(7)
                    Lattice.Q2.Setpoint.Data(7)
                    Lattice.Q3.Setpoint.Data(7)
                    Lattice.Q4.Setpoint.Data(13)
                    Lattice.Q5.Setpoint.Data(13:14)
                    Lattice.Q4.Setpoint.Data(14)
                    Lattice.Q6.Setpoint.Data(19)
                    Lattice.Q7.Setpoint.Data(19)
                    Lattice.Q8.Setpoint.Data(19)
                    ];
                LatticeN.QC13.Setpoint.FamilyName = 'QC13';
                FamilyN{k} = Magnet{k};
            end
            [temp flag] = findkeyword(Family,Magnet{k});
            if flag
                LatticeN.(Magnet{k})  = Lattice.(Magnet{k});
                FamilyN{k} = Magnet{k};
            end
        end
    end    
    Lattice = LatticeN;
    Family  = FamilyN';
    cyclingconfiguration(Lattice, Family, varargin{:});
else
    disp('Select first a magnet!');
    return;
end


%%%%%%%%%%%%%%%%%%%
% Start the cycle %
%%%%%%%%%%%%%%%%%%%
if ApplyFlag

    disp('  *****************************************************************');
    disp('  **  Cycling will start!                                        **');
    disp('  **  Are you sure to start cycling magnet                       **');
    disp('  **                                                             **');
    disp('  *****************************************************************');

    tmp = questdlg('Start cycling magnet ?','MAGNETCYCLE','Yes','No','No');
    if strcmpi(tmp,'No')
        disp('Cycling cancelled')
    else
        disp('  ** Cycling starting                                     **');
        Families = Family;
        % Machine switchyard
        switch Machine
            case {'LT1','StorageRing','LT2'}
                % start all selected families for cycling
                h = waitbar(0,sprintf('Starting cycling on magnets: %2d %%',0));
                for k1 = 1:length(Families),
                    Family = Families{k1};
                    % check if family is valid and return it in AO
                    CycleFamily = ['Cycle' Family];
                    cyclingcommand(CycleFamily,'Start');
                    waitbar(k1/length(Families), h, sprintf('Cycling configuration progression: %2d %%', k1/length(Families)*100))
                end
                close(h);

                CyclingEnd = 1;
                % Cycling
                while ~CyclingEnd
                    fprintf('Cycling running, %s',datestr(now));
                    pause(5); %seconds
                    CyclingEnd = anacycling(Families);
                end

            case 'Booster'
                disp('Not implemented yet');
                return;

            otherwise
                error('Unknown machine %s',Machine);
        end

        if strcmpi(DisplayFlag, 'Display')
            fprintf('   %s standardization complete\n', Machine);
        end
    end


end

%==========================================================================
function curve = makecyclingcurve(Inom,Imax,MagnetType,varargin)
% makecyclingcurve - Generates cycling curve used by Cycling Dserver
%
%  INPUTS
%  1. Inom - Value at the end of cycling
%  2. Imax - Maximum value
%  3. MagnetType - Type of magnet ('BEND', 'Q1', 'CH', ...)
%  Optionals parameters
%  4. CyclingMode - Type of cycling process
%                   'Simple' {default}
%                   'Full'
%                   'Startup' - after shutdown
%  5. Machine type - 'LT1', 'LT2', 'StorageRing', 'Booster'
%                     Default is given by mml via getfamilydata('Machine')
%
%
%  OUTPUTS
%  1. curve - 2D array discribing the cycling curve
%             Structure of 2D array in multiple inputs
%
%  EXAMPLES
%  1. makecurve(10,120,'CH')
%  2. makecurve([10 12],[120 130],'CH')
%
%  NOTES
%  1. MagnetType has to be the same for all vectorial inputs
%
%
%  See Also plotcyclecurve

%
% Written by Laurent S. Nadolski

% modification mars 2006 marie
%CyclingMode = 'Simple';
DisplayFlag = 0;

%% INPUT PARSER
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Simple')
        CyclingMode = 'Simple';
        % modification mars 2006 marie
        % se justifie par le fait que varargin n'a qu'un seul argument
        %varargin(i) = [];
    elseif strcmpi(varargin{i},'Full')
        CyclingMode = 'Full';
        % modification mars 2006 marie
        %varargin(i) = [];
    elseif strcmpi(varargin{i},'Startup')
        CyclingMode = 'Startup';
        % modification mars 2006 marie
        %varargin(i) = [];
    elseif strcmpi(varargin{i},'LT1')
        Machine = 'LT1';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Booster')
        Machine = 'Booster';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'LT2')
        Machine = 'LT2';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'StorageRing')
        Machine = 'StorageRing';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end

if ~ischar(MagnetType)
    error('Magnet Type sould be a string')
end

if ~exist('Machine','var')
    Machine = getfamilydata('SubMachine');
end

% if not a single element
if length(Inom) > 1
    for k = 1:length(Inom)
        curve{k} = makecyclingcurve(Inom(k),Imax(k),MagnetType,varargin{:});
    end
else

    %% Main part
    switch Machine
        case 'LT1'
            switch MagnetType
                case {'BEND'}
                    switch CyclingMode
                        case 'Simple'
                            curve = [[0 1] % current time
                                [Imax 30]
                                [Inom 1] ];
                        case 'Full'
                            %curve = [[0 10] % current time
                            %[Imax 180]
                            %[0.95*Inom 180]
                            %[1.05*Inom 180]
                            %[0.95*Inom 180]
                            %[1.05*Inom 180]
                            %[Inom 180] ];
                            curve = [[0 10] % test !
                                [Imax 10]
                                [0.95*Inom 10]
                                [1.05*Inom 10]
                                [0.95*Inom 10]
                                [1.05*Inom 10]
                                [Inom 10] ];
                        case 'Startup'
                            curve = [[0 10] % current time
                                [Imax 1800] % temps de chauffe 30 min
                                [0.95*Inom 180]
                                [1.05*Inom 180]
                                [0.95*Inom 180]
                                [1.05*Inom 180]
                                [Inom 180] ];
                        otherwise
                            error('Unknown Mode: %s', CyclingMode);
                    end
                case {'QP'}
                    switch CyclingMode
                        case 'Simple'
                            % test avec temps plus courts mars 2006
                            curve = [[0 1] % current time
                                [Imax 10]
                                [Inom 1] ];
                            %                             curve = [[0 1] % current time
                            %                                 [Imax 30]
                            %                                 [Inom 1] ];
                        case 'Full'
                            % on raccourcit les temps pour tests mars 2006
                            curve = [[0 10] % current time
                                [Imax 40]
                                [0.95*Inom 10]
                                [1.05*Inom 10]
                                [0.95*Inom 10]
                                [1.05*Inom 10]
                                [Inom 10] ];
                            %                             curve = [[0 10] % current time
                            %                                 [Imax 180]
                            %                                 [0.95*Inom 180]
                            %                                 [1.05*Inom 180]
                            %                                 [0.95*Inom 180]
                            %                                 [1.05*Inom 180]
                            %                                 [Inom 10] ];
                        case 'Startup'
                            % test avec temps courts mars 2006
                            curve = [[0 10] % current time
                                [Imax 20] % temps de chauffe 10 min
                                [0.95*Inom 10]
                                [1.05*Inom 10]
                                [0.95*Inom 10]
                                [1.05*Inom 10]
                                [Inom 20] ];
                            %                             curve = [[0 10] % current time
                            %                                 [Imax 600] % temps de chauffe 10 min
                            %                                 [0.95*Inom 180]
                            %                                 [1.05*Inom 180]
                            %                                 [0.95*Inom 180]
                            %                                 [1.05*Inom 180]
                            %                                 [Inom 180] ];
                        otherwise
                            error('Unknown Mode: %s', CyclingMode);
                    end
                case {'CH','CV'}
                    switch CyclingMode
                        case {'Simple', 'Full','Startup'}
                            curve = [[0 1] % current time
                                [Imax 30]
                                [Inom 1] ];
                        otherwise
                            error('Unknown Mode: %s', CyclingMode);
                    end

                otherwise
                    error('Unknown magnet type: %s', MagnetType)
            end
        case 'LT2'
             switch MagnetType
                case {'BEND'}
                    switch CyclingMode
                        case 'Simple'
                            curve = [[0 10] % current time
                                [Imax 30]
                                [Inom 10] ];
                        case 'Full'
                            %curve = [[0 10] % current time
                            %[Imax 180]
                            %[0.95*Inom 180]
                            %[1.05*Inom 180]
                            %[0.95*Inom 180]
                            %[1.05*Inom 180]
                            %[Inom 180] ];
                            
                            curve = [[0 10] %
                                [Imax 60]
                                [0.95*Inom 60]
                                [1.05*Inom 60]
                                [Inom 10] ];
  
                        case 'Startup'
                            curve = [[0 10] % current time
                                [Imax 1800] % temps de chauffe 30 min
                                [0.95*Inom 180]
                                [1.05*Inom 180]
                                [0.95*Inom 180]
                                [1.05*Inom 180]
                                [Inom 180] ];
                        otherwise
                            error('Unknown Mode: %s', CyclingMode);
                    end
                case {'QP'}
                    switch CyclingMode
                        case 'Simple'
                            % test avec temps plus courts mars 2006
                            curve = [[0 1] % current time
                                [Imax 10]
                                [Inom 1] ];
                            %                             curve = [[0 1] % current time
                            %                                 [Imax 30]
                            %                                 [Inom 1] ];
                        case 'Full'
                            % on raccourcit les temps pour tests mars 2006
                            curve = [[0 10] % current time
                                [Imax 40]
                                [0.95*Inom 10]
                                [1.05*Inom 10]
                                [0.95*Inom 10]
                                [1.05*Inom 10]
                                [Inom 10] ];
                            %                             curve = [[0 10] % current time
                            %                                 [Imax 180]
                            %                                 [0.95*Inom 180]
                            %                                 [1.05*Inom 180]
                            %                                 [0.95*Inom 180]
                            %                                 [1.05*Inom 180]
                            %                                 [Inom 10] ];
                        case 'Startup'
                            % test avec temps courts mars 2006
                            curve = [[0 10] % current time
                                [Imax 20] % temps de chauffe 10 min
                                [0.95*Inom 10]
                                [1.05*Inom 10]
                                [0.95*Inom 10]
                                [1.05*Inom 10]
                                [Inom 20] ];
                            %                             curve = [[0 10] % current time
                            %                                 [Imax 600] % temps de chauffe 10 min
                            %                                 [0.95*Inom 180]
                            %                                 [1.05*Inom 180]
                            %                                 [0.95*Inom 180]
                            %                                 [1.05*Inom 180]
                            %                                 [Inom 180] ];
                        otherwise
                            error('Unknown Mode: %s', CyclingMode);
                    end
                case {'CH','CV'}
                    switch CyclingMode
                        case {'Simple', 'Full','Startup'}
                            curve = [[0 1] % current time
                                [Imax 30]
                                [Inom 1] ];
                        otherwise
                            error('Unknown Mode: %s', CyclingMode);
                    end

                otherwise
                    error('Unknown magnet type: %s', MagnetType)
            end
           
        case 'Booster'
            error('%s: Not implemented yet', Machine)
        case 'StorageRing'

            switch MagnetType
                case {'BEND'}
                    switch CyclingMode
                        case 'Simple'
                            %                             curve = [[0 1] % current time
                            %                                 [Imax 30]
                            %                                 [Inom 1] ];
                        case 'Full'
                            % valeur initiale différente de zéro car zéro
                            % impossible
                            curve = [[20 10] %
                                [Imax 60]
                                [0.95*Inom 60]
                                [1.05*Inom 60]
                                [Inom 10] ];
                        case 'Startup'
                            curve = [[20 10] % current time
                                [Imax 1800] % temps de chauffe 30 min
                                [0.95*Inom 180]
                                [1.05*Inom 180]
                                [0.95*Inom 180]
                                [1.05*Inom 180]
                                [Inom 180] ];
                        otherwise
                            error('Unknown Mode: %s', CyclingMode);
                    end
                case {'Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10','QC13'}
                    switch CyclingMode
                        case 'Simple'
                            % test avec temps plus courts
                            curve = [[sign(Imax)*20 5] % current time non zero consigne
                                [Imax 30]
                                [Inom 5] ];
                        case 'Full'
                            %
                            curve = [[sign(Imax)*20 10] % current time non zero consigne
                                [Imax 30]
                                [0.90*Inom 30]
                                [1.10*Inom 30]
                                [Inom 10] ];
                        case 'Startup'
                            % test avec temps courts mars 2006
                            curve = [[sign(Imax)*20 10] % current time non zero consigne
                                [Imax 20] 
                                [0.90*Inom 10]
                                [1.10*Inom 10]
                                [0.90*Inom 10]
                                [1.10*Inom 10]
                                [Inom 20] ];
                        otherwise
                            error('Unknown Mode: %s', CyclingMode);
                    end
                case {'S1','S2','S3','S4','S5','S6','S7','S8','S9','S10'}
                    switch CyclingMode
                        case 'Simple'
                            % test avec temps plus courts mars 2006
                            curve = [[0 1] % current time
                                [Imax 10]
                                [Inom 1] ];
                        case 'Full'
                            %
                            curve = [[0 10] % current time
                                [Imax 30]
                                [0.90*Inom 30]
                                [1.10*Inom 30]
                                [Inom 10] ];
                        case 'Startup'
                            % test avec temps courts mars 2006
                            curve = [[0 10] % current time
                                [Imax 20] % temps de chauffe 10 min
                                [0.90*Inom 10]
                                [1.10*Inom 10]
                                [0.90*Inom 10]
                                [1.10*Inom 10]
                                [Inom 20] ];
                        otherwise
                            error('Unknown Mode: %s', CyclingMode);
                    end
                otherwise
                    error('Unknown magnet type: %s', MagnetType)
            end
        otherwise
            error('Unknown machine: %s', Machine);
    end

    if DisplayFlag
        fprintf(1,'%s : Inom = %f Imax= %f \n', ...
            CycleAO.DeviceName, CycleAO.Inom, CycleAO.Imax);
        plotcyclingcurve(curve);
    end
end
%==========================================================================
function CyclingEnd = anacycling(Families)
%
%
%

%
% Written by Laurent S. Nadolski

for k1=1:length(Families),
    CycleFamily = ['Cycle' Families{k1}];
    [CycleIndex, CycleAO] = isfamily(CycleFamily);

    rep = tango_group_command_inout2(CycleAO.GroupId,'State',1,0);
    Status = rep.replies.obj_name;
    rep = tango_group_read_attribute(CycleAO.GroupId,'totalProgression');
    totalProgression = rep.replies.value;
end

% look whether all cycling precessus are done
if min(totalProgression) ~= 100
    CyclingEnd = 0;
else
    CylclingEnd = 1;
end

% look for States and error
totalProgression;

%==========================================================================
function cyclingconfiguration(Lattice, Family, varargin);
% cyclingconfiguration
%
%  INPUTS
%  1. Lattice - Structure of setpoints
%  2. Family - Families to cycle to
%
%  See Also magnetcycle, setcyclecurve

%
% Written by Laurent S. Nadolski

%TODO if not a tango group --> treat single case

DisplayFlag = 1;
ConfigFlag  = 1;


if iscell(Family)
    % Build input line
    h = waitbar(0,sprintf('Cycling configuration progression: %2d %%',0))
    for k = 1:length(Family)
        cyclingconfiguration(Lattice,Family{k},varargin{:})
        waitbar(k/length(Family), h, sprintf('Cycling configuration progression: %2d %%',k/length(Family)*100))
    end
    close(h);
else
    %% INPUT PARSER
    for i = length(varargin):-1:1
        if strcmpi(varargin{i},'Display')
            DisplayFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'NoDisplay')
            DisplayFlag = 0;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'NoConfig')
            ConfigFlag = 0;
            varargin(i) = [];
        end
    end
    % Build Cycling configuration name
    CycleFamily = ['Cycle' Family];

    % Check whether CyclingFamily exists
    if ismemberof(CycleFamily,'Cyclage')
        [CycleIndex, CycleAO] = isfamily(CycleFamily);
        CycleAO.Inom = Lattice.(Family).Setpoint.Data;
        %% create cycling curve for each element of the group
        curve = makecyclingcurve(CycleAO.Inom,CycleAO.Imax,Family,varargin{:});

        % upload cycling curve
        if ConfigFlag
            reply = input(['Apply to Dserver new cycling curve to ', Family, '? (y/n)'],'s');
        else
            reply = 'yes';
        end

        switch lower(reply)
            case {'y','yes'}
                dev_name = CycleAO.DeviceName;
                setcyclecurve(dev_name,curve);
            otherwise
                disp('Parameter not set to dserver')
        end
    else
        warning('Family %s not cycled',Family)
    end
end

