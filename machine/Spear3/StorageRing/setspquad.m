function ErrorFlag = setspquad(varargin)
%SETSPQUAD - Sets the backleg winding quadrupole values for a family
%  ErrorFlag = setspquad(Family, Field, QuadSetpoint, DeviceList, WaitFlag)
%  ErrorFlag = setspquad(Family, QuadSetpoint, DeviceList, WaitFlag)
%  ErrorFlag = setspquad(QMS, QuadSetpoint, WaitFlag)
%  ErrorFlag = setspquad(QMS, WaitFlag)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              QMS Structure
%              Accelerator Object
%  2. Field - (not used, but must be there to be compatible with Mode='Special')
%  3. QuadSetpoint - Quadrupole setpoint for the backleg power supply
%  4. DeviceList ([Sector Device #] or [element #])
%  5. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%
%  OUTPUTS
%  1. ErrorFlag
% 
%  NOTES
%  1. If Family is a cell array, then DeviceList and Field can also be a cell arrays
%
%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%
% Input parsing %
%%%%%%%%%%%%%%%%%
Field = '';
QuadSetpoint = [];
DeviceList = [];
WaitFlag = -2;
UnitsFlag = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') | strcmpi(varargin{i},'model') | strcmpi(varargin{i},'Online') | strcmpi(varargin{i},'Manual')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        UnitsFlag = {'Physics'};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = {'Hardware'};
        varargin(i) = [];
    end
end

if length(varargin) == 0
    error('Must have at least a family name input');
else
    Family = varargin{1};
    if iscell(Family)
        if length(Family) > 1
            error('There is only 1 quadrupole backleg winding power supply so cell arrays greater than 1 do not make sense.');
        else
            Family = Family{1};
        end
    end
    if length(varargin) >= 2
        if iscell(varargin{2})
            if length(varargin{2}) > 1
                error('There is only 1 quadrupole backleg winding power supply so cell arrays greater than 1 do not make sense.');
            else
                if ischar(varargin{2})
                    Field = varargin{2};
                    varargin(2) = [];
                end
            end
        elseif ischar(varargin{2})
            Field = varargin{2};
            varargin(2) = [];
        end
    end
    if length(varargin) >= 2
        QuadSetpoint = varargin{2};
        if iscell(QuadSetpoint)
            if length(QuadSetpoint) > 1
                error('There is only 1 quadrupole backleg winding power supply so cell arrays greater than 1 do not make sense.');
            else
                QuadSetpoint = QuadSetpoint{1};
            end
        end
    end
    if length(varargin) >= 3
        DeviceList = varargin{3};
        if iscell(DeviceList)
            if length(DeviceList) > 1
                error('There is only 1 quadrupole backleg winding power supply so cell arrays greater than 1 do not make sense.');
            else
                DeviceList = DeviceList{1};
            end
        end
    end
    if length(varargin) >= 4
        WaitFlag = varargin{4};
        if iscell(WaitFlag)
            if length(WaitFlag) > 1
                error('There is only 1 quadrupole backleg winding power supply so cell arrays greater than 1 do not make sense.');
            else
                WaitFlag = WaitFlag{1};
            end
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Family or data structure inputs beyond this point %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstruct(Family)
    % Data structure inputs
    if isempty(QuadSetpoint)
        if isfield(Family,'Data')
            QuadSetpoint = Family.Data;
        else
            error('QuadSetpoint input required (or a .Data field must exist for data structure inputs)');
        end
    end
    if isempty(Field)
        if isfield(Family,'Field')
            Field = Family.Field;
        else
            if isfield(Family,'Field')
                Field = Family.Field;
            end
        end
    end
    if isempty(DeviceList)
        if isfield(Family,'DeviceList')
            DeviceList = Family.DeviceList;
        else
            if isfield(Family,'QuadDev')
                DeviceList = Family.QuadDev;
            else
                error('For data structure inputs, DeviceList or QuadDev field must exist or DeviceList must be input.')
            end
        end
    end
    if isempty(UnitsFlag)
        if isfield(Family,'Units')
            UnitsFlag{1} = Family.Units; 
        end
    end
    if isfield(Family,'FamilyName')
        Family = Family.FamilyName;
    else
        if isfield(Family,'QuadFamily')
            Family = Family.QuadFamily;
        else
            error('For data structure inputs FamilyName or QuadFamily field must exist')
        end
    end
else
    % Family string input
    if length(varargin) < 3
        error('3 inputs required when not using a structure input.');
    end
end


% Device list checking
if isempty(DeviceList)
    error('There must be a device list');
end
if (size(DeviceList,2) == 1) 
    DeviceList = elem2dev(Family, DeviceList);
end
if (size(DeviceList,1) > 1) 
    error('There can only be 1 device set at time for the quadrupole backleg');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% CommonName Input:  Convert common names to a DeviceList %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ischar(DeviceList)
    DeviceList = common2dev(DeviceList, Family);
    if isempty(DeviceList)
        error('DeviceList was a string but common names could not be found.');
    end
end


if isempty(QuadSetpoint)
    error('Quadrupole backleg setpoint not found');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change to physics units if requested %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(UnitsFlag,'Physics')
    % Scale factor for backleg windings?
    QuadSetpoint = hw2physics(Family, 'Setpoint', QuadSetpoint, DeviceList);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make the setpoint change %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Mode = getfamilydata(Family, 'Setpoint', 'Mode', DeviceList);
Machine = getfamilydata('Machine'); 

if strcmpi(Mode,'Simulator')
    setsp(Family, QuadSetpoint, DeviceList, WaitFlag); 
    
elseif strcmpi(Machine,'SPEAR3') | strcmpi(Machine,'SPEAR')
    FamilyDeviceChannelTbl = { ...
            'QDX' [ 1  1] 81;...
            'QFX' [ 1  1] 82;...
            'QDY' [ 1  1] 83;...
            'QFY' [ 1  1] 84;...
            'QDZ' [ 1  1] 85;...
            'QFZ' [ 1  1] 86;...
            'QF'  [ 2  1] 87;...
            'QD'  [ 2  1] 88;...
            'QFC' [ 2  1] 89;...
            'QD'  [ 2  2] 90;...
            'QF'  [ 2  2] 91;...
            'QF'  [ 3  1] 92;...
            'QD'  [ 3  1] 93;...
            'QFC' [ 3  1] 94;...
            'QD'  [ 3  2] 95;...
            'QF'  [ 3  2] 96;...
            'QF'  [ 4  1] 65;...
            'QD'  [ 4  1] 66;...
            'QFC' [ 4  1] 67;...
            'QD'  [ 4  2] 68;...
            'QF'  [ 4  2] 69;...
            'QF'  [ 5  1] 70;...
            'QD'  [ 5  1] 71;...
            'QFC' [ 5  1] 72;...
            'QD'  [ 5  2] 73;...
            'QF'  [ 5  2] 74;...
            'QF'  [ 6  1] 75;...
            'QD'  [ 6  1] 76;...
            'QFC' [ 6  1] 77;...
            'QD'  [ 6  2] 78;...
            'QF'  [ 6  2] 79;...
            'QF'  [ 7  1] 49;...
            'QD'  [ 7  1] 50;...
            'QFC' [ 7  1] 51;...
            'QD'  [ 7  2] 52;...
            'QF'  [ 7  2] 53;...
            'QF'  [ 8  1] 54;...
            'QD'  [ 8  1] 55;...
            'QFC' [ 8  1] 56;...
            'QD'  [ 8  2] 57;...
            'QF'  [ 8  2] 58;...
            'QFZ' [ 9  1] 59;...
            'QDZ' [ 9  1] 60;...
            'QFY' [ 9  1] 61;...
            'QDY' [ 9  1] 62;...
            'QFX' [ 9  1] 63;...
            'QDX' [ 9  1] 64;...
            'QDX' [10   1] 33;...
            'QFX' [10   1] 34;...
            'QDY' [10   1] 35;...
            'QFY' [10   1] 36;...
            'QDZ' [10   1] 37;...
            'QFZ' [10   1] 38;...
            'QF'  [11   1] 39;...
            'QD'  [11   1] 40;...
            'QFC' [11   1] 41;...
            'QD'  [11   2] 42;...
            'QF'  [11   2] 43;...
            'QF'  [12   1] 44;...
            'QD'  [12   1] 45;...
            'QFC' [12   1] 46;...
            'QD'  [12   2] 47;...
            'QF'  [12   2] 48;...
            'QF'  [13   1] 17;...
            'QD'  [13   1] 18;...
            'QFC' [13   1] 19;...
            'QD'  [13   2] 20;...
            'QF'  [13   2] 21;...
            'QF'  [14   1] 22;...
            'QD'  [14   1] 23;...
            'QFC' [14   1] 24;...
            'QD'  [14   2] 25;...
            'QF'  [14   2] 26;...
            'QF'  [15   1] 27;...
            'QD'  [15   1] 28;...
            'QFC' [15   1] 29;...
            'QD'  [15   2] 30;...
            'QF'  [15   2] 31;...
            'QF'  [16   1] 1 ;...
            'QD'  [16   1] 2;...
            'QFC' [16   1] 3;...
            'QD'  [16   2] 4;...
            'QF'  [16   2] 5;...
            'QF'  [17   1] 6;...
            'QD'  [17   1] 7;...
            'QFC' [17   1] 8;...
            'QD'  [17   2] 9;...
            'QF'  [17   2] 10;...
            'QFZ' [18   1] 11;...
            'QDZ' [18   1] 12;...
            'QFY' [18   1] 13;...
            'QDY' [18   1] 14;...
            'QFX' [18   1] 15;...
            'QDX' [18   1] 16};
    
    %TblRowMatch = find(QMSChannelSelect==cell2mat(FamilyDeviceChannelTbl(:,3)));
    %TblRowMatch = TblRowMatch(1);
    %Family = FamilyDeviceChannelTbl{TblRowMatch,1};
    %Device = FamilyDeviceChannelTbl{TblRowMatch,2};   
    
    % There can only be scalar inputs
    Family = deblank(Family(1,:));
    DeviceList = DeviceList(1,:);
    QuadSetpoint = QuadSetpoint(1);
    
    try
        MatchFamily = find(strcmp(FamilyDeviceChannelTbl(:,1),Family));
        TBL = FamilyDeviceChannelTbl(MatchFamily,:);
        D = cell2mat(TBL(:,2));
        MatchDevice = find(D(:,1)==DeviceList(1) & D(:,2)==DeviceList(2));
        QMSChannelSelectNew = TBL{MatchDevice,3};
    catch
        error('Switch for this quad not found');    
    end
    
    QMSChannelSelect = getpv('118-QMS1:ChanSelect');    

    % Current QMS settings
    if QMSChannelSelectNew == QMSChannelSelect
        % Same quad - change current only
        %disp(['   Setting QMS current to ',num2str(QuadSetpoint),' Amp']);
        ErrorFlag = setpv('118-QMS1:CurrSetpt', QuadSetpoint);
    else 
        % Switch to a new quad
        ErrorFlag1 = setpv('118-QMS1:ChanSelect', QMSChannelSelectNew);
        
        % This starts a sequence in the IOC that firdt turns the current off
        %disp(['   Switching QMS relay. Wait ',num2str(QMSDELAY),' seconds ...'])
        pause(2);
        %disp(['   Setting QMS current to ',num2str(QuadSetpoint),' Amp']);
        ErrorFlag2 = setpv('118-QMS1:CurrSetpt', QuadSetpoint);
        ErrorFlag = ErrorFlag1 | ErrorFlag2;
    end
    
    
    if WaitFlag==-1 | WaitFlag==-2
        % QMS Setpoint delay (big eddy current transient)
        sleep(1.5);
    end
    
    if WaitFlag & WaitFlag~=-4
        % Base runflag on SP-AM
        Tol = .1;
        TimeoutTol = .5;
        TimeOutPeriodOnWaitFlag = 10;  % Seconds
        t0  = gettime;
        AM  = getamquad(Family, DeviceList);
        RunFlag = abs(QuadSetpoint-AM) > Tol;
        Delta0 = QuadSetpoint-AM;
        
        while any(RunFlag)
            % Pause a little so that the network doesn't get too thrashed
            sleep(.1);
            
            AM  = getamquad(Family, DeviceList);
            RunFlag = abs(QuadSetpoint-AM) > Tol;
            Delta = QuadSetpoint-AM;
        
            % Check if the Delta has changed in the last TimeOutPeriodOnWaitFlag seconds
            if gettime-t0 > TimeOutPeriodOnWaitFlag
                x = (abs(Delta) > Tol) & (abs(abs(Delta)-abs(Delta0)) <= TimeoutTol);
                if any(x)
                    for i = 1:length(x)
                        if x(i)
                            fprintf(sprintf('   %s(%d,%d) monitor does not appear to be changing\n', Family,  DeviceList(i,1), DeviceList(i,2)));
                        end
                    end
                    error(sprintf('Time-Out:  Monitor did not appear to be changing for the last %.1f seconds.',TimeoutTol));
                end
                
                % Reset Delta0 and timeout timer
                Delta0 = Delta;    
                t0 = gettime;
            end
        end
    end
    
    % Add extra delay for continued ramping due to the size of the tolerance
    RampRate = 1;  %???
    T = Tol ./ RampRate;
    if ~isempty(max(T))
        sleep(1.2*max(T));
    end
    
    % BPM Delay
    if WaitFlag == -2
        [N, BPMDelay] = getbpmaverages;
        BPMDelay = 2.2*BPMDelay;
        if ~isempty(BPMDelay)
            sleep(BPMDelay);
        end
    end
    
else
    
    ErrorFlag = setsp(Family, QuadSetpoint, DeviceList, WaitFlag); 
    
end
