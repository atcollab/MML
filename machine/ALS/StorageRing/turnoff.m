function turnoff(Family, DeviceList, FractionOff)
%TURNOFF - Scale the setpoint
%  turnoff(Family, DeviceList, FractionToChange)
%
%  Slowly turns change a given family (usually a magnet family)
%


% To do:
% 1. Add field input
% 2. Add cell array input


if nargin < 1
    FamilyNum = menu1('Which magnet family do you want to turn off?','HCM','VCM','QF','QD','QFA','SD','SF','BEND','Exit');

    if FamilyNum == 1
        Family = 'HCM';
    elseif FamilyNum == 2
        Family = 'VCM';
    elseif FamilyNum == 3
        Family = 'QF';
    elseif FamilyNum == 4
        Family = 'QD';
    elseif FamilyNum == 5
        Family = 'QFA';
    elseif FamilyNum == 6
        Family = 'SF';
    elseif FamilyNum == 7
        Family = 'SD';
    elseif FamilyNum == 8
        Family = 'BEND';
    elseif FamilyNum == 9
        return;
    else
        error([Family,' not defined.']);
    end
end


if nargin < 2
    DeviceList = [];
end
if isempty(DeviceList)
    DeviceList = getlist(Family);
end
if size(DeviceList,2) == 1
    DeviceList = elem2dev(Family, DeviceList);
end


% Motor chicane magnets
if strcmp(Family, 'HCMCHINCANEM')
    SPzero = 80;
else
    SPzero = 0;
end


% Set HCMs functioning as chicanes to their nominal chicane value
if strcmp(Family, 'HCM')
    if ~strcmpi(getmode('HCM'), 'Simulator')
        % HCM being used as chicane magnets get removed
        % (Only because turning off the motor chicanes is more difficult.)
        HCMRemoveList = [];

        
        % Sector 4 chicanes are all independent magnets
        %                   Off    1.9 GeV   1.5 GeV
        % HCMCHICANEM(4,1)  80.0    26.7      43.0
        % HCMCHICANEM(4,1)  80.0     7.3      24.0

        
        % Sector 6
        %                   Off    1.9 GeV   1.5 GeV
        % HCMCHICANEM(6,1)  80.0    18.0       ?
        % HCMCHICANEM(6,1)  80.0    20.0       ?
        % HCM(6,1)           0.0    18.8       ?
        %if ~isempty(findrowindex([6 1], DeviceList))
        %    try
        %        if getsp('HCMCHICANEM',[6 1]) < 70
        %            % Assume sector 6 chicane is on
        %            HCMRemoveList = [HCMRemoveList; 6 1];
        %        end
        %    catch
        %        fprintf('%s\n', lasterr);
        %        fprintf('Problem reading HCMCHICANEM(6,1), HCM(6,1) will be zeroed.\n\n');
        %    end
        %end

        
        if ~isempty(findrowindex([6 8], DeviceList))
            try
                if getsp('HCMCHICANEM',[7 1]) < 60
                    % Assume sector 11 chicane is on
                    HCMRemoveList = [HCMRemoveList; 6 8];
                end
            catch
                fprintf('%s\n', lasterr);
                fprintf('Problem reading HCMCHICANEM(7,1), HCM(6,8) will be zeroed.\n\n');
            end
        end
        if ~isempty(findrowindex([7 1], DeviceList))
            try
                if getsp('HCMCHICANEM',[7 1]) < 60
                    % Assume sector 11 chicane is on
                    HCMRemoveList = [HCMRemoveList; 7 1];
                end
            catch
                fprintf('%s\n', lasterr);
                fprintf('Problem reading HCMCHICANEM(7,1), HCM(7,1) will be zeroed.\n\n');
            end
        end
        
        % Sector 11
        %                    Off    1.9 GeV   1.5 GeV
        % HCMCHICANEM(11,1)  80.0    40.5      52.0
        % HCMCHICANEM(11,1)  80.0    40.5      52.0
        % HCM(10,8)           0.0   -17.0     -14.0
        % HCM(11,1)           0.0   -17.0     -14.0
        if ~isempty(findrowindex([10 8], DeviceList))
            try
                if getsp('HCMCHICANEM',[11 1]) < 60
                    % Assume sector 11 chicane is on
                    HCMRemoveList = [HCMRemoveList; 10 8];
                end
            catch
                fprintf('%s\n', lasterr);
                fprintf('Problem reading HCMCHICANEM(11,1), HCM(10,8) will be zeroed.\n\n');
            end
        end
        if ~isempty(findrowindex([11 1], DeviceList))
            try
                if getsp('HCMCHICANEM',[11 1]) < 60
                    % Assume sector 11 chicane is on
                    HCMRemoveList = [HCMRemoveList; 11 1];
                end
            catch
                fprintf('%s\n', lasterr);
                fprintf('Problem reading HCMCHICANEM(11,1), HCM(11,1) will be zeroed.\n\n');
            end
        end
        if ~isempty(findrowindex([12 7], DeviceList))
            if strcmp('1.9 GeV, Low Emittance Mode',getfamilydata('OperationalMode'))
                    HCMRemoveList = [HCMRemoveList; 12 7];
            end
        end


        i = findrowindex(HCMRemoveList, DeviceList);
        if ~isempty(i)
            if getfamilydata('Energy') > 1.8
                disp('   HCMs functioning as chicane magnets are not set to zero (turnoff.m)');
                %if ~isempty(findrowindex([6 1], HCMRemoveList))
                %    disp('   HCM[ 6 1] =  18.8');
                %    setsp('HCM', 18.8, [6 1]);
                %end
                if ~isempty(findrowindex([6 8], HCMRemoveList))
                    setsp('HCM', -16, [6 8]);
                    disp('   HCM[6 8] = -16.0');
                end
                if ~isempty(findrowindex([7 1], HCMRemoveList))
                    setsp('HCM', -16, [7 1]);
                    disp('   HCM[7 1] = -16.0');
                end
                if ~isempty(findrowindex([10 8], HCMRemoveList))
                    setsp('HCM', -17, [10 8]);
                    disp('   HCM[10 8] = -17.0');
                end
                if ~isempty(findrowindex([11 1], HCMRemoveList))
                    setsp('HCM', -17, [11 1]);
                    disp('   HCM[11 1] = -17.0');
                end
            else
                %if ~isempty(findrowindex([6 1], HCMRemoveList))
                %    disp('   HCM[ 6 1] =  18.8*1.5/1.9');
                %    setsp('HCM', 18.8*1.5/1.9, [6 1]);
                %end
                if ~isempty(findrowindex([6 8], HCMRemoveList))
                    setsp('HCM', -14, [6 8]);
                    disp('   HCM[6 8] = -14.0');
                end
                if ~isempty(findrowindex([7 1], HCMRemoveList))
                    setsp('HCM', -14, [7 1]);
                    disp('   HCM[7 1] = -14.0');
                end
                if ~isempty(findrowindex([10 8], HCMRemoveList))
                    setsp('HCM', -14, [10 8]);
                    disp('   HCM[10 8] = -14.0');
                end
                if ~isempty(findrowindex([11 1], HCMRemoveList))
                    setsp('HCM', -14, [11 1]);
                    disp('   HCM[11 1] = -14.0');
                end
            end

            
            % Remove the HCM acting as chicane magnets from the turnoff list
            % since they have already been set.
            DeviceList(i,:) = [];
        end
    end
end


% Get setpoints
sp = getsp(Family, DeviceList);


%if strcmp(computer, 'PCWIN') & (strcmp(Family,'HCM') | strcmp(Family,'VCM'))
%  RampFlag = getramp(Family, DeviceList);      % save ramp flags
%  setramp(Family, 0, DeviceList);              % slow mode
%end


% Slowly turn off the correctors
if nargin < 3
    FractionOff = 0;

    %if strcmp(Family,'HCM')
    %   FractionOff = 0;
    %   fprintf('  Horizontal correctors set to %f%% of nominal\n', 100*FractionOff);
    %end

    %if strcmp(Family,'VCM')
    %   FractionOff = 0.30;
    %   fprintf('  Vertical correctors set to %.1f%% of nominal\n', 100*FractionOff);
    %end
end



% Slowly turn off the magnets
for i = 1:-.1:FractionOff
    t0 = clock;
    
    setsp(Family, i*(sp-SPzero)+SPzero, DeviceList);

    if ~strcmpi(getmode('HCM'), 'Simulator')
        sleep(0.25);
    end
    %deltime = etime(clock,t0);
end

setsp(Family, FractionOff*(sp-SPzero)+SPzero, DeviceList);




%if strcmp(computer, 'PCWIN') & (strcmp(Family,'HCM') | strcmp(Family,'VCM'))
%  setramp(Family, RampFlag, DeviceList);       % restore ramp flags
%end


% if size(DeviceList,1) == size(family2dev(Family),1)
%     disp(['  The ', Family,' family has been set to zero.']);
% else
%     disp(['  Part of the ', Family,' family has been set to zero.']);
% end

