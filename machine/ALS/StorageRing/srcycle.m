function FailFlag = srcycle(varargin)
%SRCYCLE - Storage ring cycle
%  srcycle(SuperBendFlag {'Yes'/'No'}, ChicaneAndSkewQuadFlag {'Yes'/'No'})
%  srcycle('SuperBend'  , 'ChicaneAndSkewQuad')
%  srcycle('NoSuperBend', 'NoChicaneAndSkewQuad')  {Default}
%
%  See also srramp, setmachineconfig


% Revision History
%
% 2001-05-15, Christoph Steier
% Three major changes:
% 1) Changed cycling routine (mostly for the 1.9 GeV case), to avoid damaging QF/QD power supplies.
%    Old cycle: current status -> injection lattice -> max current -> zero -> injection -> production -> injection
%    New cycle: current status -> injection lattice -> ramp to production -> ramp to injection -> ramp to production -> ramp to injection
% 2) The vertical chicane are now included in cycling, since they now are always on.
% 3) Included pause statements in old cycling routine (still used for 1.5 GeV) to reduce likelihood of power supply failures
%
% 2001-09-21, Tom Scarvie
% Changed 1.9 GeV cycle so that superbend magnets are only ramped 1.5 -> 1.9 -> 1.5 once; they are skipped the second time around to speed up the cycle
%
% NOTE: Cycling for any energy except 1.9 GeV doesn't include the BSC, VCBSC, or QDA magnets yet.
%
% 2001-09-24, Tom Scarvie
% Added SuperBendFlag argument to allow for not cycling the superbends
%
% 2001-10-19, T. Scarvie
% Added setting the BSCramprate to 0.4 A/s initially for safety, now that ramping sets it to 0.8 A/s
%
% 2001-10-25, T.Scarvie
% Changed routine so that skew quads and chicane magnets cycle simultaneously to speed up ramp
%
% 2002-04-29, T.Scarvie
% Changed cycling so that the SR04 middle horizontal chicane (trim coil of motor chicane) does not cycle
%
% 2002-06-18, T.Scarvie
% Added step to home the SR04 motor chicane magnets after cycling the outer chicane magnets
% 2002-07-17, T.Scarvie
% Added step to home the SR11 motor chicane magnets after cycling the outer chicane magnets
%
% 2002-08-21, T.Scarvie
% Changed cycling so that the superbends cycle last if requested (additional cool-off time in case of a spindown)
%
% 2003-03-10, T.Scarvie
% Changed to ramp superbends at 0.8 A/s if temperatures are normal (below 4.65 K for coils), 0.3 A/s otherwise
%
% 2003-04-25, C. Steier
% Changed initial srload to use smaller ramprates for Superbends if their current was below
% 150 A, when cycling was started (to avoid excessive heating in high inductance regime)
%
% 2003-05-28, C. Steier
% disabled homing for motor 3 (translation) of chicane in sector 11 (translation stage is
% currently broken and mechanically locked out)
%
% 2004-11-04, G. Portmann
% Made middle layer compatible
%
% 2005-01-10, T. Scarvie
% Made more changes to ensure middle layer compatibility (eg: getsp('BSCramprate') caused core dumps in Linux)
%
% 2005-11-08, G. Portmann
% Added buildramptable so amp2k and k2amp are based the mini-cycle
% The mini-cycle is done between RampTable.UpperLattice.Setpoint & RampTable.LowerLattice.Setpoint
% not the Production and Injection lattices.  This allows for the 1.5 production lattice to be at 1.5 GeV.
% Made more simulator compatible.


%%%%%%%%%%%%%%
% Initialize %
%%%%%%%%%%%%%%

% Input flags
FailFlag = 0;
SuperBendFlag = '';
ChicaneAndSkewQuadFlag = '';
DisplayFlag = 1;
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'Super Bend', 'SuperBend', 'Super Bends', 'SuperBends', 'SB'}))
        SuperBendFlag = 'Yes';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'No Super Bend', 'No SuperBend', 'NoSuperBend', 'No Super Bends', 'No SuperBends', 'NoSuperBends', 'NoSB'}))
        SuperBendFlag = 'No';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'Chicane', 'SkewQuad', 'ChicaneSkewQuad', 'ChicaneAndSkewQuad'}))
        ChicaneAndSkewQuadFlag = 'Yes';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'NoChicane', 'NoSkewQuad', 'NoChicaneSkewQuad', 'NoChicaneAndSkewQuad'}))
        ChicaneAndSkewQuadFlag = 'No';
        varargin(i) = [];
    end
end


%%%%%%%%%%%%%%%%%%
% Input checking %
%%%%%%%%%%%%%%%%%%
if length(varargin) >= 1
    SuperBendFlag = varargin{1};
end
if isempty(SuperBendFlag)
    SuperBendFlag = 'No';
end
if strcmpi(SuperBendFlag,'Yes')
    fprintf('   The superbend magnets will be cycled.\n');
elseif strcmpi(SuperBendFlag,'No')
    fprintf('   The superbend magnets will not be cycled.\n');
else
    error('Superbend cycle input must be ''No'' or ''Yes''.  Cycle aborted.');
end

if length(varargin) >= 2
    ChicaneAndSkewQuadFlag = varargin{2};
end
if isempty(ChicaneAndSkewQuadFlag)
    ChicaneAndSkewQuadFlag = 'No';
end
if strcmpi(ChicaneAndSkewQuadFlag,'Yes')
    fprintf('   Chicane magnets will be cycled.\n');
elseif strcmpi(ChicaneAndSkewQuadFlag,'No')
    fprintf('   Chicane magnets will not be cycled.\n');
else
    error('Chicane cycle input must be ''No'' or ''Yes''.  Cycle aborted.');
end

if length(varargin) >= 3
    FullCycleFlag = varargin{3};
end
if isempty(FullCycleFlag)
    FullCycleFlag = 'Yes';  % Default cycle
end
if strcmpi(FullCycleFlag,'Yes')
    fprintf('   Full storage ring cycle.\n');
else
    fprintf('   Mini storage ring cycle.\n');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build the ramp tables & load the upper/lower hysteresis lattices %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This updates the ramptables used in srcycle, amp2k, k2amp, etc.
buildramptable;

GeVUpper = getfamilydata('HysteresisLoopUpperEnergy');
GeVLower = getfamilydata('HysteresisLoopLowerEnergy');

% Get the lattices from the new ramp table
load([getfamilydata('Directory','OpsData'), 'alsrampup.mat']);
UpperLattice = RampTable.UpperLattice.Setpoint;
UpperLattice = RemoveSomeFamilies(UpperLattice);
UpperLattice = RemoveSomeFields(UpperLattice);

LowerLattice = RampTable.LowerLattice.Setpoint;
LowerLattice = RemoveSomeFamilies(LowerLattice);
LowerLattice = RemoveSomeFields(LowerLattice);

% No superbend lattice
UpperLatticeNoSB = UpperLattice;
i = findrowindex([4 2;8 2;12 2], UpperLattice.BEND.Setpoint.DeviceList);
UpperLatticeNoSB.BEND.Setpoint.Data(i) = [];
UpperLatticeNoSB.BEND.Setpoint.DeviceList(i,:) = [];
UpperLatticeNoSB.BEND.Setpoint.Status(i) = [];

LowerLatticeNoSB = LowerLattice;
i = findrowindex([4 2;8 2;12 2], LowerLattice.BEND.Setpoint.DeviceList);
LowerLatticeNoSB.BEND.Setpoint.Data(i) = [];
LowerLatticeNoSB.BEND.Setpoint.DeviceList(i,:) = [];
LowerLatticeNoSB.BEND.Setpoint.Status(i) = [];


%%%%%%%%%%%%%%%%%%%
% Cycle if online %
%%%%%%%%%%%%%%%%%%%
if strcmpi(getmode('BEND'),'Online')
    try
        fprintf('   Starting a cycle for the %s operational mode.\n', getfamilydata('OperationalMode'));


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Set the superbend ramp rate limit %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SuperBendCheck;


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Zero trim & feed forward channels %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Open ID's ???
        setpv('HCM', 'Trim', 0);
        setpv('VCM', 'Trim', 0);
        setpv('HCM', 'FF1', 0);
        setpv('HCM', 'FF1', 0);
        setpv('VCM', 'FF2', 0);
        setpv('VCM', 'FF2', 0);
        setpv('QF', 'FF', 0);
        setpv('QD', 'FF', 0);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Start from the upper hysteresis lattice %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Get the BEND and SBEND energy
        EnergyBEND  = bend2gev('BEND','Setpoint',getsp('BEND',[1 1]),[1 1]);
        EnergySBEND = bend2gev('BEND','Setpoint',getsp('BEND',[4 2;8 2;12 2]),[4 2;8 2;12 2]);

        if strcmpi(SuperBendFlag, 'No')
            Energy = EnergyBEND;

            if any(abs(getfamilydata('InjectionEnergy')-EnergySBEND)>.001) || any(abs(getfamilydata('Energy')-EnergySBEND)>.001)
                fprintf('   Warning:  Superbend are not cycled and there are not at the %.1f GeV injection energy or %.1f GeV production energy.\n', getfamilydata('InjectionEnergy'), getfamilydata('Energy'));
            end
        else
            % Base energy on the superbend since ramp speed is very important for the superbend
            Energy = min([EnergyBEND; EnergySBEND]);
        end

        % Go to the starting lattice
        if abs(Energy-GeVUpper)>.001
            % Ramp to the upper lattice
            if strcmpi(SuperBendFlag,'No')
                fprintf('   Ramping to upper hysteresis lattice without superbends.\n');
                srramp('Upper', 'NoSuperBend', 'LinearToUpperLattice');
            else
                fprintf('   Ramping to upper hysteresis lattice with superbends.\n');
                srramp('Upper', 'LinearToUpperLattice');
            end
            pause(2);
            a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        end

        % Load the upper lattice to make sure every magnet is at the starting point for a cycle
        if strcmpi(SuperBendFlag,'No')
            fprintf('   Loading the upper lattice without superbends ... ');
            setmachineconfig(UpperLatticeNoSB);
        else
            fprintf('   Loading the upper lattice ... ');
            setmachineconfig(UpperLattice);
        end
        pause(2);
        a = clock;
        fprintf('Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Cycle the chicanes and skew quadrupoles %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if strcmp(ChicaneAndSkewQuadFlag, 'Yes')
            % Cycle chicane and skew quadrupoles
            CycleChicaneAndSkewQuadrupoles;

%             % Home the motor chicane
% %            fprintf('   Homing the SR04U, SR06U, and SR11U motor chicane magnets...');
%             fprintf('   Homing the SR04U and SR11U motor chicane magnets...');
%             HomeMotorChicanes;
%             a = clock; fprintf(' Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
% 
%             % Home the Jackson Hole scrapers
%             fprintf('   Homing the SR01C, SR02C, and SR12C Jackson Hole scrapers...');
%             HomeJHScrapers;
%             a = clock; fprintf(' Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        end
        

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Mini-Cycle without ramping the superbends %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if strcmpi(FullCycleFlag,'Yes')
            % Ramp to lower lattice without ramping the superbends
            fprintf('   Ramping to lower hysteresis lattice without superbends.\n');
            srramp('Lower', 'NoSuperBend');
            %setmachineconfig(LowerLatticeNoSB);
            pause(5);
            a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

            % Ramp to upper lattice without ramping the superbends
            fprintf('   Ramping to upper hysteresis lattice without superbends.\n');
            srramp('Upper', 'NoSuperBend');
            %setmachineconfig(UpperLatticeNoSB);
            pause(5);
            a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % For the second mini-cycle, only cycle the superbends if requested %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Ramp down to lower lattice
        if strcmpi(SuperBendFlag,'No')
            fprintf('   Ramping to lower hysteresis lattice without superbends.\n');
            srramp('Lower', 'NoSuperBend');
            %setmachineconfig(LowerLatticeNoSB);
        elseif strcmpi(SuperBendFlag,'Yes')
            fprintf('   Ramping to lower hysteresis lattice including the superbends.\n');
            FailFlag = srramp('Lower');
            if FailFlag
                error('Superbends over temperature.');
            end
        end
        a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

        % Ramp to high lattice, if injecting at 1.9 GeV
        if getfamilydata('InjectionEnergy') > 1.7
            if strcmpi(SuperBendFlag,'No')
                fprintf('   Ramping to upper hysteresis lattice without superbends.\n');
                srramp('Upper', 'NoSuperBend');
                %setmachineconfig(UpperLatticeNoSB);
            elseif strcmpi(SuperBendFlag,'Yes')
                fprintf('   Ramping to upper hysteresis lattice including the superbends.\n');
                FailFlag = srramp('Upper');
                if FailFlag
                    error('Superbends over temperature.');
                end
            end
            pause(5);
            a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        end

        % Lattice load is now done in srcontrol!!!
        %fprintf('   Loading the injection lattice   ...');
        %setmachineconfig('Injection');
        %pause(2);
        %a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

        fprintf('   Storage ring cycle completed.\n');

    catch
        fprintf('\n  **********************\n');
        fprintf(  '  **  Cycle aborted!  **\n');
        fprintf(  '  **********************\n\n');
        sound tada
        %fprintf('\n   %s\n', lasterr);
        rethrow(lasterror);
    end
end



%%%%%%%%%%%%%%%
% Subroutines %
%%%%%%%%%%%%%%%

function BSCramprate = SuperBendCheck
% This function protects the superbends on the first load to the injection lattice
%
% Set the superbend ramprate to 0.8A/s if the coil temps are acceptable

Templimit = 4.45;
[BSCcoiltemps, BSCcoilnames] = getsuperbendtemperatures;
if any(BSCcoiltemps > Templimit)
    BSCramprate = 0.3;

    bscnum = (find(BSCcoiltemps > Templimit));
    sound tada;
    fprintf('   The temperature of one of the superbend magnets is too high.\n');
    for i=1:length(bscnum)
        fprintf('   The Coil Temperature of %s is %.2f K.  It should be below %.2f K.\n', BSCcoilnames{bscnum(i)}, BSCcoiltemps(bscnum(i)), Templimit);
    end
    fprintf('   A reduced ramp rate will be used for the cycle.  However, if a temperature\n');
    fprintf('   warning persists, there may be a problem with one of the superbends!\n');
else
    BSCramprate = 0.8;
end

% In case the current is small, heating is much worse because of large magnet inductance at small field -> reduce ramprates
if min(getsp('BEND',[4 2;8 2;12 2])) < 150     % changed to min (G. Portmann 11-18-2005)
    if BSCramprate > 0.6
        BSCramprate = .4;
    else
        BSCramprate = .2;
    end
end

setpv('BEND', 'RampRate', BSCramprate, [4 2;8 2;12 2]);
fprintf('   The superbend ramp rate is being set to %.2f A/s.\n', BSCramprate);



function CycleChicaneAndSkewQuadrupoles

% Disable cycling for skew quadrupoles which are not switched on
% SQSDlist = getlist('SQSD');
% SQSFlist = getlist('SQSF');
% SQSDon=getam('SQSDon');
% SQSFon=getam('SQSFon');
% SQSDindex=find(SQSDon==1);
% SQSFindex=find(SQSFon==1);
% SQSDlist=SQSDlist(SQSDindex,:);
% SQSFlist=SQSFlist(SQSFindex,:);

% cycle skew quads and chicanes simultaneously
fprintf('   Going to maximum on the chicane and skew quad magnets ... ');
Amps = 6;
setsp('SQSD', Amps, [], 0);
setsp('SQSF', Amps, [], 0);
setsp('HCMCHICANE', [-50;-50;50;50], [], 0);
%setsp('VCMCHICANE', [50;0;50;0;0], [], 0);

% Check for rampflags complete
setsp('SQSD', Amps, []);
setsp('SQSF', Amps, []);
setsp('HCMCHICANE', [-50;-50;50;50], [], -2);
%setsp('VCMCHICANE', [50;0;50;0;0], [], -2);
pause(2);
a = clock; fprintf('Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));


fprintf('   Going to negative maximum on the chicane and skew quadrupole magnets ... ');
Amps = -6;
setsp('SQSD', Amps, [], 0);
setsp('SQSF', Amps, [], 0);
setsp('HCMCHICANE', [50;50;-50;-50], [], 0);
%setsp('VCMCHICANE', [-50;0;-50;0;0], [], 0);

% Check for rampflags complete
setsp('SQSD', Amps, []);
setsp('SQSF', Amps, []);
setsp('HCMCHICANE', [50;50;-50;-50], [], -2);
%setsp('VCMCHICANE', [-50;0;-50;0;0], [], -2);
pause(2);
a = clock; fprintf('Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));


fprintf('   Going to zero on the chicane and skew quadrupole magnets ... ');
Amps = 0;
setsp('SQSD', Amps, [], 0);
setsp('SQSF', Amps, [], 0);
setsp('HCMCHICANE', [0;0;0;0], [], 0);
%setsp('VCMCHICANE', [0;0;0;0;0], [], 0);

% Check for rampflags complete
setsp('SQSD', Amps, []);
setsp('SQSF', Amps, []);
setsp('HCMCHICANE', [0;0;0;0], [], -2);
%setsp('VCMCHICANE', [0;0;0;0;0], [], -2);
pause(2);
a = clock; fprintf('Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));



function HomeMotorChicanes

disp('  Not homing the Motor Chicanes as they do not need homing any longer.');

% % Set the motor chicane rotational speed to 10.0 deg/s
% % (same as the default) so homing is not slow
% setpv('HCMCHICANEM','RampRate',10);
% 
% % Home the motor chicane (sectors 6+7 do not require homing)
% setpv('SR04U___HCM2M1_BC00.VAL',1);
% setpv('SR04U___HCM2M2_BC00.VAL',1);
% %   setpv('SR04U___HCM2M3_BC00.VAL',1);  % Drive is off
% setpv('SR11U___HCM2M1_BC00.VAL',1);
% setpv('SR11U___HCM2M2_BC00.VAL',1);
% %	setpv('SR11U___HCM2M3_BC00.VAL',1); % horizontal drive not enabled for this chicane
% 
% % Print dots until it's done
% t0=gettime;
% while getpv('SR04U___HCM2M1_BC00.VAL')~=0 || getpv('SR04U___HCM2M2_BC00.VAL')~=0 || ...  % getpv('SR04U___HCM2M3_BC00.VAL')~=0 || ...
%         getpv('SR11U___HCM2M1_BC00.VAL')~=0 || getpv('SR11U___HCM2M2_BC00.VAL')~=0         % || getpv('SR11U___HCM2M3_BC00.VAL')~=0
% %        getpv('SR06U___HCM2M1_BC00.VAL')~=0 || getpv('SR06U___HCM2M2_BC00.VAL')~=0 || ...  % New chicane controls does not need homing anymore
%     fprintf('.');
%     pause(4);
%     if (gettime-t0) > 120
%         fprintf('\n\n');
%         break
%     end
% end
% pause(2);
% 
% NumberOfErrors = 0;
% if getam('SR04U___HCM2M1_BM00.VAL')==1
%     fprintf('   There was a problem homing SR04 chicane magnet motor 1!\n');
%     NumberOfErrors = NumberOfErrors + 1;
% end
% if getam('SR04U___HCM2M2_BM00.VAL')==1
%     fprintf('   There was a problem homing SR04 chicane magnet motor 2!\n');
%     NumberOfErrors = NumberOfErrors + 1;
% end
% %if getam('SR04U___HCM2M3_BM00.VAL')==1
% %    fprintf('   There was a problem homing SR04 chicane magnet motor 3!\n');
% %    NumberOfErrors = NumberOfErrors + 1;
% %end
% % if getam('SR06U___HCM2M1_BM00.VAL')==1                % new chicane controls does not need homing anymore
% %     fprintf('   There was a problem homing SR06 chicane magnet motor 1!\n');
% %     NumberOfErrors = NumberOfErrors + 1;
% % end
% % if getam('SR06U___HCM2M2_BM00.VAL')==1
% %     fprintf('   There was a problem homing SR06 chicane magnet motor 2!\n');
% %     NumberOfErrors = NumberOfErrors + 1;
% % end
% if getam('SR11U___HCM2M1_BM00.VAL')==1
%     fprintf('   There was a problem homing SR11 chicane magnet motor 1!\n');
%     NumberOfErrors = NumberOfErrors + 1;
% end
% if getam('SR11U___HCM2M2_BM00.VAL')==1
%     fprintf('   There was a problem homing SR11 chicane magnet motor 2!\n');
%     NumberOfErrors = NumberOfErrors + 1;
% end
% %	if getam('SR11U___HCM2M3_BM00.VAL')==1
% %    fprintf('   There was a problem homing SR11 chicane magnet motor 3!\n');
% %    NumberOfErrors = NumberOfErrors + 1;
% %	end
% 
% if getpv('SR04U___HCM2M1_BM00.VAL')==0 && getpv('SR04U___HCM2M2_BM00.VAL')==0  && getpv('SR04U___HCM2M1_BC00.VAL')==0 && getpv('SR04U___HCM2M2_BC00.VAL')==0 %&& getpv('SR04U___HCM2M3_BC00.VAL')==0 && getpv('SR04U___HCM2M3_BM00.VAL')==0
%     %fprintf('   The SR04 motor chicane magnet has been homed; the proper values will be loaded with the lattice.\n');
% else
%     fprintf('   There was a problem homing the SR04 motor chicane magnet.\n');
%     NumberOfErrors = NumberOfErrors + 1;
% end
% % if getpv('SR06U___HCM2M1_BM00.VAL')==0 && getpv('SR06U___HCM2M2_BM00.VAL')==0 && getpv('SR06U___HCM2M1_BC00.VAL')==0 && getpv('SR06U___HCM2M2_BC00.VAL')==0 % new controls for sector 6 chicane does not need homing anymore
% %     %fprintf('   The SR06 motor chicane magnet has been homed; the proper values will be loaded with the lattice.\n');
% % else
% %     fprintf('   There was a problem homing the SR06 motor chicane magnet.\n');
% %     NumberOfErrors = NumberOfErrors + 1;
% % end
% if getpv('SR11U___HCM2M1_BM00.VAL')==0 && getpv('SR11U___HCM2M2_BM00.VAL')==0 && getpv('SR11U___HCM2M1_BC00.VAL')==0 && getpv('SR11U___HCM2M2_BC00.VAL')==0 % && getpv('SR11U___HCM2M3_BC00.VAL')==0 && getpv('SR11U___HCM2M3_BM00.VAL')==0
%     %fprintf('   The SR11 motor chicane magnet has been homed; the proper values will be loaded with the lattice.\n');
% else
%     fprintf('   There was a problem homing the SR11 motor chicane magnet.\n');
%     NumberOfErrors = NumberOfErrors + 1;
% end
% 
% if NumberOfErrors
%     soundquestion_nobits;
%     fprintf('   %d error(s) homing the motor chicanes (SR04 Chicane: crate srioc040.als.lbl.gov, SR06 Chicane: crate srioc06u03, SR11 Chicane: srioc110.als.lbl.gov)', NumberOfErrors);
%     fprintf('   Tired of waiting for the motor chicanes to home! A likely solution is rebooting the appropriate IOC crate.\n\n');
%     
%     ErrorTest = questdlg( ...
%         {'Trouble homing the motor chicanes!',' ','Continue the cycle anyways, or stop now?'}, ...
%         'SRCYCLE: Motor Chicane','Continue','Stop','Stop');
%     
%     if strcmp(ErrorTest,'Stop')
%         error(sprintf('%d error(s) homing the motor chicanes', NumberOfErrors));
%     end
% end


function HomeJHScrapers

% don't home the scrapers as it is done by Controls Group during startup
disp('  Not homing the Jackson Hole scrapers as it is done by Controls Group during startup.');

% % Home the Jackson Hole scrapers
% setpv('SR01C___SCRAP1TAC01_ctrl',1);
% setpv('SR01C___SCRAP1BAC01_ctrl',1);
% setpv('SR02C___SCRAP1TAC01_ctrl',1);
% setpv('SR02C___SCRAP1BAC01_ctrl',1);
% setpv('SR02C___SCRAP6TAC01_ctrl',1);
% setpv('SR12C___SCRAP6TAC01_ctrl',1);
% 
% % Print dots until it's done
% t0=gettime;
% while getpv('SR01C___SCRAP1TAC01_hchk')==0 || getpv('SR01C___SCRAP1BAC01_hchk')==0 || ...
%       getpv('SR02C___SCRAP1TAC01_hchk')==0 || getpv('SR02C___SCRAP1BAC01_hchk')==0 || ...
%       getpv('SR02C___SCRAP6TAC01_hchk')==0 || getpv('SR12C___SCRAP6TAC01_hchk')==0;
%     fprintf('.');
%     pause(4);
%     if (gettime-t0)>120
%         fprintf('\n\n   There is a problem homing the Jackson Hole scrapers! A likely solution is rebooting the appropriate IOC crate.\n');
%         error('(SR01C and SR12C JH scrapers: crate s011123.als.lbl.gov, SR02C JH scrapers: crate s021820.als.lbl.gov)');
%     end
% end
pause(2);


function Lattice = RemoveSomeFamilies(Lattice)
% Remove families
%RemoveFamilyNames = {'HCMCHICANE','HCMCHICANEM','VCMCHICANE','SQEPU','SQSF','SQSD','RF','GeV','DCCT','Physics1'}; %remove SF from cycling due to temporary control reconfiguration - T.Scarvie, 20100609, added back in 20101102, T.Scarvie
RemoveFamilyNames = {'HCMCHICANE','HCMCHICANEM','VCMCHICANE','SQEPU','SQSF','SQSD','SHF','SHD','SQSHF','RF','GeV','DCCT'};
j = find(isfield(Lattice, RemoveFamilyNames));
Lattice = rmfield(Lattice, RemoveFamilyNames(j));



function Lattice  = RemoveSomeFields(Lattice)
% Remove fields
RemoveFieldNames = {'RampRate','TimeConstant','DAC','Trim','FF1','FF2'};
Fields = fieldnames(Lattice);
for i = 1:length(Fields)
    j = find(isfield(Lattice.(Fields{i}), RemoveFieldNames));
    Lattice.(Fields{i}) = rmfield(Lattice.(Fields{i}), RemoveFieldNames(j));
end



%     % The ALS does not do this max/min cycle anymore!!!!!!!!!!!!!!!!!!!
%
%     % Load max sp, with skew quads zero
%     fprintf('  Going to maximum setpoints on BEND, QFA, SF, SD, QF, QD, and chicane magnets.\n');
%     % Superbend max ???
%     BENDsp = 911;
%     QFAsp = [550; 550; 550; 550];
%     SFsp = 378;
%     SDsp = 378;
%     % taken out on Aug. 7, 2000 because of multiple power supply failures
%     %QFsp = 100;
%     %QDsp = 100;
%     QFsp = 95;
%     QDsp = 98;
%
%     % Set all magnets without waiting for rampflag
%     setsp('HCMCHICANE', [-50;-50;50;0], [], 0);
%     setsp('BEND', BENDsp, [1 1], 0);
%     setsp('QFA', QFAsp, [], 0);
%     setsp('SF', SFsp, [], 0);
%     setsp('SD', SDsp, [], 0);
%     setsp('QF', QFsp, [], 0);
%     setsp('QD', QDsp, [], 0);
%
%     % Check for rampflag complete
%     setsp('HCMCHICANE', [-50;-50;50;0], [], -2);
%     setsp('BEND', BENDsp, [1 1], -2);
%     setsp('QFA', QFAsp, [], -2);
%     setsp('SF', SFsp, -2);
%     setsp('SD', SDsp, -2);
%     setsp('QF', QFsp, [], -2);
%     setsp('QD', QDsp, [], -2);
%
%     [tmp, iQF] = max(abs(getam('QF')-QFsp));
%     [tmp, iQD] = max(abs(getam('QD')-QDsp));
%     qfaam = getam('QFA');
%     fprintf('  Setpoints:  BEND=%5.1f QFA=%5.1f,%5.1f,%5.1f,%5.1f SF=%5.1f SD=%5.1f QF(%d)=%5.1f QD(%d)=%5.1f amps\n', BENDsp, QFAsp(1), QFAsp(2), QFAsp(3), QFAsp(4), SFsp, SDsp, iQF, QFsp, iQD, QDsp);
%     fprintf('  Monitors:   BEND=%5.1f QFA=%5.1f,%5.1f,%5.1f,%5.1f SF=%5.1f SD=%5.1f QF(%d)=%5.1f QD(%d)=%5.1f amps\n', getam('BEND'), qfaam(1), qfaam(2), qfaam(3), qfaam(4), getam('SF'), getam('SD'), iQF, getam('QF',iQF), iQD, getam('QD',iQD));
%
%     fprintf('    pausing for 30 seconds ...\n');
%     pause(30);
%
%
%     % Load zero SP
%     fprintf('  Going to minimum setpoints on BEND, QFA, SF, SD, QF, QD, and chicane magnets.\n');
%     BENDsp = 0;
%     QFAsp = [0;0;0;0];
%     SFsp = 0;
%     SDsp = 0;
%     QFsp = 0;
%     QDsp = 0;
%
%     % Set all magnets without waiting for rampflag
%     setsp('HCMCHICANE', [50;50;-50;0], [], 0);
%     setsp('BEND', BENDsp, [1 1], 0);
%     setsp('QFA', QFAsp, [], 0);
%     setsp('SF', SFsp, 1, 0);
%     setsp('SD', SDsp, 1, 0);
%     setsp('QF', QFsp, [], 0);
%     setsp('QD', QDsp, [], 0);
%
%     % Check for rampflag complete
%     setsp('HCMCHICANE', [50;50;-50;0], [], -2);
%     fprintf('  Going to zero on the chicane magnets.\n');
%     setsp('HCMCHICANE', [0;0;0;], [], 0);
%     setsp('BEND', BENDsp, [1 1], -2);
%     setsp('QFA', QFAsp, [], -2);
%     setsp('SF', SFsp, -2);
%     setsp('SD', SDsp, -2);
%     setsp('QF', QFsp, [], -2);
%     setsp('QD', QDsp, [], -2);
%
%     [tmp, iQF] = max(abs(getam('QF')-QFsp));
%     [tmp, iQD] = max(abs(getam('QD')-QDsp));
%     qfaam = getam('QFA');
%     fprintf('  Setpoints:  BEND=%5.1f QFA=%5.1f,%5.1f,%5.1f,%5.1f SF=%5.1f SD=%5.1f QF(%d)=%5.1f QD(%d)=%5.1f amps\n', BENDsp, QFAsp(1), QFAsp(2), QFAsp(3), QFAsp(4), SFsp, SDsp, iQF, QFsp, iQD, QDsp);
%     fprintf('  Monitors:   BEND=%5.1f QFA=%5.1f,%5.1f,%5.1f,%5.1f SF=%5.1f SD=%5.1f QF(%d)=%5.1f QD(%d)=%5.1f amps\n', getam('BEND'), qfaam(1), qfaam(2), qfaam(3), qfaam(4), getam('SF'), getam('SD'), iQF, getam('QF',iQF), iQD, getam('QD',iQD));
%
%     fprintf('    pausing for 30 seconds ...\n');
%     pause(30);
%     setsp('HCMCHICANE', [0;0;0;0], [], -2);