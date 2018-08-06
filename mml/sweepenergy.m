function sweepenergy(PercentChangeInEnergy)
%SWEEPENERGY - Energy sweep of the storage ring
%  sweepenergy(PercentChangeInEnergy)
%  sweepenergy( .1: .2: 1.1)  ramps up   .1 to 1.1 percent in  .002 GeV steps
%  sweepenergy(-.1:-.2:-1.1)  ramps down .1 to 1.1 percent in -.002 GeV steps
%
%  This function starts at the present online lattice and 
%  leaves the lattice at the last energy step.

%  Written by Greg Portmann


% PercentChangeInEnergy = .1:.2:1.1;


% Get starting lattice
SPstruct = getmachineconfig;
SPcell = field2cell(SPstruct);

SP = SPcell;

% Set to simulator
setmachineconfig(SPstruct, 'Simulator');

Energy0 = getsp('BEND', [1 1], 'Physics');

for i = 1:length(PercentChangeInEnergy)
    NewEnergy = Energy0 * (1 + PercentChangeInEnergy(i)/100);

    % Make the setpoint change w/o a WaitFlag
    for k = 1:length(SPcell)
        try
            if ismemberof(SPcell{k},'Magnet')
                SPcell{k}.Data = (1 + PercentChangeInEnergy(i)/100) * SP{k}.Data;
                setpv(SPcell{k}, 0);
            end
        catch
            fprintf('   Trouble with setsp(%s), hence ignored (sweepenergy)\n', SPcell{k}.FamilyName);
            %lasterr
        end
    end
    
    BEND = getsp('BEND', [1 1]);
    fprintf('   Changing energy to %f GeV (BEND=%f)\n', NewEnergy(1), BEND);
    
    %     % Make the setpoint change with a WaitFlag
    %     for k = 1:length(SPcell)
    %         try
    %             % Set with waiting
    %             setpv(SPcell{k}, -1);
    %         end
    %     end

    fprintf('   Energy   change to %f GeV complete\n', NewEnergy(1));
    fprintf('   Hit return to continue (Ctrl-C to stop)\n\n');
    pause
end





% % Change the energy of the simulator
% setsp('BEND', NewEnergy(1), 'Physics', 'Simulator');
% BENDsim = getsp('BEND', [1 1], 'Simulator', 'Hardware');
% 
% fprintf('   Changing energy to %f GeV (BEND=%f)\n', NewEnergy(1), BENDsim);
% 
% % Get the simluator lattice at the new energy
% SP = getmachineconfig('Simulator');
% 
% % Set to online accelerator
% setmachineconfig(SP, 'Online');
