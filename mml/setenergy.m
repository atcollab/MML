function [ConfigSetpointEnd, ConfigSetpointStart, ConfigSetpointPhysics] = setenergy(varargin)
%SETENERGY - Sets the storage ring energy (GeV) by ramping all lattice magnets
%  [ConfigSetpointEnd, ConfigSetpointStart] = setenergy(Energy, NSteps, Delay)
%
%  INPUTS
%  1. Energy - Desired beam energy in GeV
%              Energy can be a vector to do a energy ramp (or use input #2)
%  2. NSteps - Number of energy step when ramping between the
%              present energy and Energy.  {Default: 1}
%  3. Delay  - Time delay between steps {Default: .1 seconds}
%
%  OUTPUTS
%  1. ConfigSetpointEnd   - Ending   lattice configuration
%  2. ConfigSetpointStart - Starting lattice configuration
%     (same structure as returned by getmachineconfig)
%
%  ALGORITHM
%  1. Update the simulator with the present online setpoints (except the 
%     BEND).  The "K-values" in the simulator will then be based on the 
%     hw2physics conversion which are based on magnet measurements
%     and the present energy as returned by getenergy (AD.Energy).  The
%     BEND magnet is not updated in the simulator because the "K-value"
%     of the BEND never changes.  
%  2. Change the energy variable used by getenergy (AD.Energy) to 
%     the new desired energy. 
%  3. Get the new lattice setpoints in hardware units from the simulator. 
%     In doing so a physics2hw conversion will be done at the new energy.
%  4. Set the new lattice setpoints to the online machine.
%
%  NOTES AND ASSUMPTIONS
%  1. hw2physics and physics2hw must adjust the output values based 
%     on energy (ie, what is returned by getenergy (AD.Energy)).  
%  2. Before calling setenergy, the present lattice is assumed to be at 
%     the value returned by getenergy (AD.Energy).  If bend2gev does not match
%     AD.Energy 
%  3. All the lattice magnets, except the BEND, are relatively scaled based
%     on the energy changes.  The BEND is an absolute setpoint w.r.t. energy.
%     That is, setting the machine to 3.1 GeV will always be the same BEND
%     magnet current.  Where as setting the machine to 3.1 will change the 
%     other (non-BEND) lattice magnets relative to the present energy. 
%  4. Setting the BEND magnet with setsp('BEND', NewGeV, 'Physics') will also
%     change the energy but the reset of the lattice does not get scaled "properly."
%  5. The bend magnet family must be called 'BEND'.
%
%  See also getenergy, sweepenergy, bend2gev, gev2bend

%  Written by Greg Portmann


ModeFlag = '';
UnitsFlag = '';
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
        ModeFlag = 'Simulator';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        ModeFlag = 'Online';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        UnitsFlag = 'Physics';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = 'Hardware';
        varargin(i) = [];
    end
end

if isempty(varargin) 
    Energy = getenergy('Present');  % same as bend2gev
    %error('Energy input required');
end
if length(varargin) >= 1 
    Energy = varargin{1};
end
if length(varargin) >= 2
    NSteps = varargin{2};
else
    NSteps = 1;
end
if length(varargin) >= 3
    TimeDelay = varargin{3};
else
    TimeDelay = .1;
end


if isempty(ModeFlag)
    ModeFlag = getmode('BEND');
end


% Get the starting lattice configuration
ConfigSetpointStart = getmachineconfig(ModeFlag);


% Remove some families
if isfield(ConfigSetpointStart, 'RF')
    ConfigSetpointStart = rmfield(ConfigSetpointStart, 'RF');
end


if strcmpi(getfamilydata('Machine'),'ALS')
    % Remove some more families
    % Skew quadrupoles?
    RemoveFamilyNames = {'HCMCHICANE','HCMCHICANEM','VCMCHICANE','SQEPU','RF','GeV'};
    j = find(isfield(ConfigSetpointStart, RemoveFamilyNames));
    ConfigSetpointStart = rmfield(ConfigSetpointStart, RemoveFamilyNames(j));

    % Remove RampRate, etc fields
    RemoveFieldNames = {'RampRate','TimeConstant','DAC','Trim','FF1','FF2'};
    Fields = fieldnames(ConfigSetpointStart);
    for i = 1:length(Fields)
        j = find(isfield(ConfigSetpointStart.(Fields{i}), RemoveFieldNames));
        ConfigSetpointStart.(Fields{i}) = rmfield(ConfigSetpointStart.(Fields{i}),  RemoveFieldNames(j));
    end
end
ConfigFamilies = fieldnames(ConfigSetpointStart);


% Present energy
PresentEnergy = getenergy(ModeFlag);  % same as bend2gev

% Build the energy vector
Energy = linspace(PresentEnergy, Energy(end), NSteps+1);
Energy = Energy(:)';


% Get the setpoints in physics units
for j = 1:length(ConfigFamilies)
    ConfigSetpointPhysics.(ConfigFamilies{j}).Setpoint = hw2physics(ConfigSetpointStart.(ConfigFamilies{j}).Setpoint, PresentEnergy);
end


if strcmpi(ModeFlag,'Simulator') || strcmpi(ModeFlag,'Model')
    
    setenergymodel(Energy(end));

    % Get the setpoint change
    if nargout >= 1
        %ConfigSetpointEnd = getmachineconfig('Simulator');
        for j = 1:length(ConfigFamilies)
            ConfigSetpointEnd.(ConfigFamilies{j}).Setpoint = physics2hw(ConfigSetpointPhysics.(ConfigFamilies{j}).Setpoint, Energy);
        end
    end

else

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Online Energy Ramping Loop %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if length(Energy) > 1
        fprintf('   0. Starting energy %f GeV\n', PresentEnergy(1));
    else
        fprintf('   Starting energy %f GeV\n', PresentEnergy(1));
    end

    for i = 2:length(Energy)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Keep the "K-values" fixed but change the energy %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Change the AD.Energy
        setfamilydata(Energy(i), 'Energy');
        

        % Set the hysteresis branch for the ramp direction (this determines the tabled used in hw2physics & physics2hw)
        if Energy(i) > Energy(i-1)
            setfamilydata('Lower', 'HysteresisBranch');
        elseif Energy(i) < Energy(i-1)
            setfamilydata('Upper', 'HysteresisBranch');
        end


        % Get the setpoint change (could speed this up if Energy was monotonic)
        for j = 1:length(ConfigFamilies)
            ConfigSetpointEnd.(ConfigFamilies{j}).Setpoint = physics2hw(ConfigSetpointPhysics.(ConfigFamilies{j}).Setpoint, Energy(i));
        end
        
        
        % Set with zero wait
        for j = 1:length(ConfigFamilies)
            setpv(ConfigSetpointEnd.(ConfigFamilies{j}).Setpoint, 0);
        end

        
        % Wait on SP-AM 
        %for j = 1:length(ConfigFamilies)
        %    getpv(ConfigSetpointEnd.(ConfigFamilies{j}).Setpoint, -1);
        %end
        
        
        %%%%%%%%%%%%%%%%%
        % Print results %
        %%%%%%%%%%%%%%%%%
        PresentEnergy = bend2gev;
        if length(Energy) > 1
            fprintf('   %d. Storage ring at %f GeV\n', i, PresentEnergy(1));   
        else
            fprintf('   Storage ring at %f GeV\n', PresentEnergy(1));      
        end
        drawnow;
        
        if i < length(Energy)
            pause(TimeDelay);
        end
    end
    
    % Change the AT model energy just to keep it insync with the accelerator
    setenergymodel(Energy(end));

end
    
