function Err = setid(DeviceList, NewPos, NewVel , WaitFlag, VelocityProfile, InfoFlag)
%SETID - Set the insertion device vertical gap
%  Error = setid(DeviceList, New Position, New Velocity, WaitFlag, VelocityProfile, InfoFlag);
%
%  INPUTS 
%  1. DeviceList - DeviceList list {Default: all devices}
%  2. Position - Insertion device position [mm] {Default: no change}
%  3. Velocity - Insertion device velocity [mm/sec] {Default: no change}
%  4. WaitFlag - Wait conditions after the setpoints are sent
%                0  -> return immediately
%                >0 -> wait until ramping is done then adds an extra delay equal to WaitFlag 
%                -1 -> wait until ramping is done
%                -2 -> wait until ramping is done then adds an extra delay for fresh data 
%                      from the BPMs {Default}
%                -3 -> wait until ramping is done then adds an extra delay for fresh data 
%                      from the tune measurement system
%                -4 -> wait until ramping is done then wait for a carriage return
%  5. VelocityProfile - Profiling of the velocity as a function of gap {Default: no change}
%                       0    -> profile off
%                      else  -> profile on 
%  6. InfoFlag = 0   -> do not print status information {Default: 0}
%               else -> print status information
%

Err = 0;
ExtraDelay = 2;  % ???

if nargin < 1
    DeviceList = [];
end
if isempty(DeviceList)
    DeviceList = family2dev('ID');
end
if size(DeviceList,2) == 1
    %DeviceList = elem2dev('ID', DeviceList);
    DeviceList = [DeviceList ones(size(DeviceList))];
end

if nargin < 2
    NewPos = [];
end
if isempty(NewPos)
    NewPos = getsp('ID', DeviceList);
end

if nargin < 3
    NewVel = [];
end
if isempty(NewVel)
    NewVel = getpv('ID', 'VelocityControl', DeviceList);
end

if nargin < 4
    WaitFlag = [];
end
if isempty(WaitFlag)
    WaitFlag = -2;
end

if nargin < 6
    InfoFlag = 0;
end
if isempty(InfoFlag)
    InfoFlag = 1;
end

if nargin >= 5
    if ~isempty(VelocityProfile)
        if VelocityProfile
            VelocityProfile = 1;
        end
        setpv('ID', 'VelocityProfile', VelocityProfile);
    end
end


if size(NewPos) == [1 1]
    NewPos = NewPos*ones(size(DeviceList,1),1);
elseif size(NewPos) == [size(DeviceList,1) 1]
    % input OK 
else
    error('Size of NewPos must be equal to the DeviceList or a scalar!');
end	

if size(NewVel) == [1 1]
    NewVel = NewVel*ones(size(DeviceList,1),1);
elseif size(NewVel) == [size(DeviceList,1) 1]
    % input OK 
else
    error('Size of NewVel must be equal to the DeviceList or a scalar!');
end	


% Print to screen
if InfoFlag
    fprintf('           ');
    for i = 1:size(DeviceList,1)
        fprintf('    ID%d       ', DeviceList(i,:));
    end
    fprintf('\n');
    
    fprintf('  New SP: ');
    for i = 1:size(DeviceList,1)
        fprintf('  %7.3f mm  ', NewPos(i));
    end
    fprintf('\n');
    
    fprintf('  Old SP: ');
    for i = 1:size(DeviceList,1)
        fprintf('  %7.3f mm  ', getid(DeviceList(i,:),1));
    end
    fprintf('\n');
end


% Set gaps going
setpv('ID', 'VelocityControl', NewVel, DeviceList, 0);
setpv('ID', 'Setpoint',   NewPos, DeviceList, 0);


% Check for errors
[GapPosAM, GapVelAM, RunFlag] = getid(DeviceList);
for i = 1:size(DeviceList,1)
    if (RunFlag(i) < 0)
        if DeviceList(i) == 4 | DeviceList(i) == 11
            switch RunFlag(i,1)
                case -1
                    disp('ERROR: EPU timeout error.');
                case -2    
                    disp('ERROR: EPU PMAC software error.');
                case -3    
                    disp('ERROR: EPU PMAC program stopped.');
                case -4    
                    disp('ERROR: EPU PMAC not initiallized.');
                case -5    
                    disp('ERROR: EPU Amp disabled.');
                case -6
                    disp('ERROR: EPU PMAC status bad.');
                otherwise
                    disp('ERROR: Insertion device error.');
            end
        else
            switch RunFlag(i,1)
                case -16
                    disp('ERROR: Insertion device indexer shutdown active.');
                case -20
                    disp('ERROR: Insertion device stall detected.');
                case -30
                    disp('ERROR: Insertion device CRC error in Battery Backed RAM.');
                case -41
                    disp('ERROR: Insertion device hardware closing limit.');
                case -42
                    disp('ERROR: Insertion device hardware opening limit.');
                case -43
                    disp('ERROR: Insertion device software closing limit.');
                case -44
                    disp('ERROR: Insertion device software opening limit.');
                case -60
                    disp('ERROR: Insertion device shutdown commanded.');
                case -66
                    disp('ERROR: Insertion device fault.');
                case -71
                    disp('ERROR: Insertion device absolute encoder not connected.');
                case -72
                    disp('ERROR: Insertion device bad absolute encoder reading.');
                case -333
                    disp('ERROR: Insertion device RS-232 connection to the ILC not working.');
                otherwise
                    disp('ERROR: Insertion device indexer error.');
            end
        end
    end
end
if any(RunFlag < 0)
    Err = -1;
    error('Insertion device error');
end


if WaitFlag
    [GapPosAM, GapVelAM] = getid(DeviceList);
    Gap0 = GapPosAM;
    t0 = gettime;
    while any(abs(GapPosAM-NewPos) > .050)
        [GapPosAM, GapVelAM, GapRunFlag] = getid(DeviceList);
        
        if any(GapRunFlag < 0)
            Err = -1;
            error('Insertion error occurred.');
        end
        
        if InfoFlag
            fprintf('   New AM: ');
            for i = 1:size(DeviceList,1)
                fprintf('  %7.3f mm  ', GapPosAM(i));
            end
            fprintf('\r');
            pause(1);
        end
        
        % If all the gaps have not changed for 10 seconds break
        if t0+10 < gettime
            if any([abs(GapPosAM-Gap0)<.050 & abs(GapPosAM-NewPos)>.050]) 
                % There is a problem
                disp('   At least one of the gaps are not changing.');
                Err = -2;
                %break;
                error('SP-AM error.');
            end
            t0 = gettime;
            Gap0 = getid(DeviceList);
        end
    end
    
    
    if WaitFlag > 0
        sleep(WaitFlag);
    elseif WaitFlag == -2
        [N, BPMDelay] = getbpmaverages;
        BPMDelay = 2.2*BPMDelay;
        if ~isempty(BPMDelay)
            sleep(BPMDelay);
        end
    elseif WaitFlag == -3
        TUNEDelay = getfamilydata('TUNEDelay');
        if ~isempty(TUNEDelay)
            sleep(TUNEDelay);
        end
    elseif WaitFlag == -4
        tmp = input('   Setpoint changed.  Hit return when ready. ');
    end
    
    pause(ExtraDelay);   
    
    if InfoFlag
        GapPosAM = getid(DeviceList);
        fprintf('   New AM: ');
        for i = 1:size(DeviceList,1)
            fprintf('  %7.3f mm  ', GapPosAM(i));
        end
        fprintf('\r');
        pause(0);
    end
end

if InfoFlag
    fprintf('\n');
end



%if WaitFlag & NewPosition ~= GapSP
%	[Position, Velocity, RunFlag] = getid(DeviceList);
%
%	while (RunFlag-RunFlag0 < .75)
%		[Position, Velocity, RunFlag] = getid(DeviceList);
%
%		if (RunFlag < 0)
%			error('Insertion error occurred.');
%		end
%	end
%end

