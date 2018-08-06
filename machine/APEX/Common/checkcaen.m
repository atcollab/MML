function [Caen, ChangesNeeded] = checkcaen(varargin)
%CHECKCAEN - Check initialization of the Caen power supplies
%
%  CaenStruct = checkcaen(ActionString, DeviceName)
%             or
%  CaenStruct = checkcaen(CaenStruct)
%
%  INPUTS
%  1. Accerelerator section
%     checkcaen('APEX')
% 
%  2. DeviceName - to select a particular power supply (like 'GTL:VCM2') 
%                  or '' for a interactive list   
%                  see caenparameters for a full list
%
%  NOTE
%  1. This function will work in any MML mode
%
%  See also caenparameters, setcaen

% Written by Greg Portmann


global ChangesNeeded DisplayFlag


if nargin < 1
    varargin{1}  = 'APEX';
    %error('One input needed.');
end

Section = [];
ChangesNeeded = 0;
DisplayFlag = 'OnForChanges';  %'On'
 
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i}, 'Struct')
        % Ignor, gets separated out later
    elseif strcmpi(varargin{i}, 'Numeric')
        %OutputStruct = 0;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'APEX'}))
        Section = 'APEX';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'Display'}))
        DisplayFlag = varargin{i+1};
        varargin(i:i+1) = [];
    elseif strcmpi(varargin{i},'FileName')
        if length(varargin) >= i+1 && ischar(varargin{i+1})
            FileName = varargin{i+1};
            varargin(i:i+1) = [];
        else
            varargin(i) = [];
        end
    end
end

DevName  = -1;


if length(varargin) >= 1 && isstruct(varargin{1})
    Caen = varargin{1};
    varargin(1) = [];
else
    if length(varargin) >= 1 % && (ischar(varargin{1}) || isempty(varargin{1}))
        DevName = varargin{1};        
        [Caen, BaseName] = caenparameters(Section, DevName);
    else
        [Caen, BaseName] = caenparameters(Section);
    end
end


for i = 1:length(Caen)
    checkcaen_local(Caen(i), DisplayFlag);
end



function Caen = checkcaen_local(Caen, DisplayFlag)

% Newton Raphson Iterations * 5
% Diagnostic Routine Iterations * 4
% Min DC-Link allarm [V] * 11
% Max MOSFET Temperature * 55
% Max SHUNT Temperature *  55
% Ripple - check time [s] ** 1
% Fan minimum speed [#] ** 25

% if any(strcmpi(Caen.Name, {'SOL3'}))
%     fprintf('   \nSkipping %s\n\n', Caen.Name);
%     return;
% end


% Interlocks
% InterlockEnable  0 -> None
%                  1 -> First interlock
%                  7 -> First 3 interlocks
%                 15 -> First 4 interlocks
% InterlockTime [msec]
if any(strcmpi(Caen.Name, {'SOL1','SOL2','SOL3'})) 
    checkpv_local_interlock([Caen.Name,':EEP_Intlk1Name'], 'WATERFLOW');
    checkpv_local_interlock([Caen.Name,':EEP_Intlk2Name'], 'INTLK2');
    checkpv_local_interlock([Caen.Name,':EEP_Intlk3Name'], 'INTLK3');
    InterlockEnable = 1;
    InterlockTime = 1000;
    
elseif strcmpi(Caen.Name, 'LTB:B3')
    checkpv_local_interlock([Caen.Name,':EEP_Intlk1Name'], 'OVERTEMP');
    checkpv_local_interlock([Caen.Name,':EEP_Intlk2Name'], 'WATERFLOW');
    checkpv_local_interlock([Caen.Name,':EEP_Intlk3Name'], 'CRASHOFF');
    InterlockEnable = 7;
    InterlockTime = 1000;
    
elseif length(Caen.Name)>=10 && strcmpi(Caen.Name(7:10), 'SQSH')
    checkpv_local_interlock([Caen.Name,':EEP_Intlk1Name'], 'O/T & WFLW');
    checkpv_local_interlock([Caen.Name,':EEP_Intlk2Name'], 'INTLK2');
    checkpv_local_interlock([Caen.Name,':EEP_Intlk3Name'], 'INTLK3');
    InterlockEnable = 1;
    InterlockTime = 500;
    
elseif length(Caen.Name)>=9 && strcmpi(Caen.Name(7:9), 'SQS')
    checkpv_local_interlock([Caen.Name,':EEP_Intlk1Name'], 'MAGNET');
    checkpv_local_interlock([Caen.Name,':EEP_Intlk2Name'], 'INTLK2');
    checkpv_local_interlock([Caen.Name,':EEP_Intlk3Name'], 'INTLK3');
    InterlockEnable = 1;
    InterlockTime = 500;
    
else
    checkpv_local_interlock([Caen.Name,':EEP_Intlk1Name'], 'INTLK1');
    checkpv_local_interlock([Caen.Name,':EEP_Intlk2Name'], 'INTLK2');
    checkpv_local_interlock([Caen.Name,':EEP_Intlk3Name'], 'INTLK3');
    InterlockEnable = 0;
    InterlockTime = 500;

end
checkpv_local_interlock([Caen.Name,':EEP_Intlk4Name'], 'INTLK4');
checkpv_local_interlock([Caen.Name,':EEP_Intlk5Name'], 'INTLK5');
checkpv_local_interlock([Caen.Name,':EEP_Intlk6Name'], 'INTLK6');
checkpv_local_interlock([Caen.Name,':EEP_Intlk7Name'], 'INTLK7');
checkpv_local_interlock([Caen.Name,':EEP_Intlk8Name'], 'INTLK8');


checkpv_local([Caen.Name,':EEP_TmaxFET'],   55);
checkpv_local([Caen.Name,':EEP_TmaxSHUNT'], 55);

checkpv_local([Caen.Name,':EEP_VminLimit'], 11);


% Add check for interlock state???
% What's the PV type???
% EEP_IntlkEnable  0x1  what is EEP_IntlkEnableOC???
% EEP_IntlkState   0x0
% Interlock time  200 ms?
checkpv_local([Caen.Name,':EEP_IntlkEnable'], InterlockEnable);
checkpv_local([Caen.Name,':EEP_IntlkState'],  0);
checkpv_local([Caen.Name,':EEP_Intlk1Time'],  InterlockTime);
checkpv_local([Caen.Name,':EEP_Intlk2Time'],  InterlockTime);
checkpv_local([Caen.Name,':EEP_Intlk3Time'],  InterlockTime);
checkpv_local([Caen.Name,':EEP_Intlk4Time'],  InterlockTime);

if 1 %strcmpi(DisplayFlag, 'On')
    Caen.Interlock.Enable = getpvonline([Caen.Name,':EEP_IntlkEnable']);
    Caen.Interlock.State  = getpvonline([Caen.Name,':EEP_IntlkState']);
    fprintf('   Interlock Enable:  %s (%.0f)  %s\n', dec2bin(Caen.Interlock.Enable,8), Caen.Interlock.Enable, Caen.Name);
    fprintf('   Interlock  State:  %s (%.0f)  %s\n', dec2bin(Caen.Interlock.State,8), Caen.Interlock.State, Caen.Name);
end

% PID
checkpv_local([Caen.Name,':ControllerKp'], Caen.Kp);
checkpv_local([Caen.Name,':ControllerKi'], Caen.Ki);
checkpv_local([Caen.Name,':ControllerKd'], Caen.Kd);

% Current limit
checkpv_local([Caen.Name,':EEP_Imax'], Caen.Limit + .1);

% Regulation maximum threshold [A]:  (Default: .2 A)
% Regulation out of range threshold [#] **  150000
if any(strcmpi(Caen.Model, {'SY3662'}))
    checkpv_local([Caen.Name,':EEP_IregLim'], .4);
elseif any(strcmpi(Caen.Location, {'GTB','BTS'}))
    checkpv_local([Caen.Name,':EEP_IregLim'], 20);  % ?? Removed to allow for steps with long time constants
else
    checkpv_local([Caen.Name,':EEP_IregLim'], 20);  % was 1.0, Default: .2   ?? Removed to allow for steps with long time constants
end

% Ripple maximum current threshold [A] * .1
%      Default: 1% of max current -> Caen said?
%               appears to be .15 for A3620
% Ripple  out of range threshold [#] ** 100
% Ripple - wait before check [s] ** 5
if any(strcmpi(Caen.Model, {'SY3662'}))
    checkpv_local([Caen.Name,':EEP_IrippleLim'], .4);
elseif any(strcmpi(Caen.Location, {'GTB','BTS'}))
    checkpv_local([Caen.Name,':EEP_IrippleLim'], 20);  % was .4
else
    checkpv_local([Caen.Name,':EEP_IrippleLim'], 20);  % was 1
end

% Ground fault
if any(strcmpi(Caen.Model, {'SY3662'}))
    checkpv_local([Caen.Name,':EEP_IgroundLim'], .05);  % the 60A have a must better ground fault curcuit
elseif any(strcmpi(Caen.Location, {'GTB','BTS'}))
    checkpv_local([Caen.Name,':EEP_IgroundLim'], 1);  % was .2
else
    checkpv_local([Caen.Name,':EEP_IgroundLim'], 1);
end

% Slew rate (doesn't require password)
%checkpv_local([Caen.Name,':SlewRate'], Caen.SlewRate);

% Slew control?
%checkpv_local([Caen.Name,':SlewControl'], 1);

% EPICS slew rate (0->Inf/Off)
%checkpv_local([Caen.Name,':Setpoint.OROC'], 0);


Caen.Version = getpv([Caen.Name,':Version'], 'char');

if strcmpi(DisplayFlag, 'On')
    fprintf('   Check complete for %s (%s)\n', Caen.Name, Caen.Version);
end



function C = getcaen_local(Caen)

C = getcaen(Caen.Name);

FieldNames = fieldnames(Caen);
for i = 1:length(FieldNames)
    C.(FieldNames{i}) = Caen.(FieldNames{i});
end



function checkpv_local_interlock(PV, Val)

global ChangesNeeded DisplayFlag

a = getpv([PV, 'RBV'], 'char');

if strcmp(a, Val)
    % No change
    if strcmpi(DisplayFlag, 'On')
        fprintf('   No change needed to %s (presently %s)\n', PV, a);
    end
else
    % Set PV needed
    if strcmpi(DisplayFlag, 'On')
        fprintf('   You should change: %s to %s (presently %s)\n', PV, Val, a);
    end
    %setpvonline(PV, Val);
    ChangesNeeded = ChangesNeeded + 1;
end


function checkpv_local(PV, Val)

global ChangesNeeded DisplayFlag

if ischar(Val)
    
    a = getpv(PV, 'char');
    
    if strcmp(a, Val)
        % No change
        if strcmpi(DisplayFlag, 'On')
            fprintf('   No change needed to %s (presently %s)\n', PV, a);
        end
    else
        % Set PV needed
        if strcmpi(DisplayFlag, 'On') || strcmpi(DisplayFlag, 'OnForChanges')
            fprintf('   You should change: %s to %s (presently %s)\n', PV, Val, a);
        end
        %setpvonline(PV, Val);
        ChangesNeeded = ChangesNeeded + 1;
    end
    
else
    a = getpvonline(PV, 'double');
    
    if abs(a - Val) < 1e-8
        % No change
        if strcmpi(DisplayFlag, 'On')
            fprintf('   No change needed to %s (presently %f)\n', PV, a);
        end
    else
        % Set PV needed
        if strcmpi(DisplayFlag, 'On') || strcmpi(DisplayFlag, 'OnForChanges')
            fprintf('   You should change: %s to %f (presently %f)\n', PV, Val, a);
        end
        %setpvonline(PV, Val);
        ChangesNeeded = ChangesNeeded + 1;
    end
end

