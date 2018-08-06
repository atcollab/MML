function srload(LatticeNumber, FeedForwardFlag)
%SRLOAD - Loads the storage ring setpoints from a file (ALS only)
% srload(LatticeNumber, FeedForwardFlag)
%
%  INPUTS
%  1. LatticeNumber = 1, 'Production', 'prod' -> Production lattice
%                   = 2, 'Injection', 'inj' -> Injection lattice
%                   = 3, '', no input -> file menu prompt
%                   = 4 -> Exit
%
%  2. FeedForwardFlag = 0, ignore the magnet setpoint changes due to feed forward {default}
%      FeedForwardFlag = else, add the magnet setpoint changes due to feed forward
%                              before restoring the lattice
%
%  see help setmachineconfig for more details

StartDir = pwd;

if nargin < 2
    FeedForwardFlag = [];
end
if isempty(FeedForwardFlag)
    FeedForwardFlag = 0;
end
if FeedForwardFlag
    error('FeedForwardFlag has not been implemented yet.');
end

if nargin < 1
    % Load the production lattice
    SP = getlattice_als;
else
    if ischar(LatticeNumber)
        if strncmpi(LatticeNumber,'prod',4)
            % Load the production lattice
            LatticeNumber = 1;
        elseif strncmpi(LatticeNumber,'inj',3)
            % Load the injection lattice
            LatticeNumber = 2;
        end
    end
    if LatticeNumber == 1
        % Load the production lattice
        SP = getproductionlattice;
    elseif LatticeNumber == 2
        % Load the injection lattice
        SP = getinjectionlattice;
    elseif LatticeNumber == 3
        % Get from file
        SP = getlattice;
        if isempty(SP)
            return
        end
    elseif LatticeNumber == 4
        return
    end
end


if ~isempty(SP) %added this check to avoid error when cancelling out of getlattice selection box

    % RF frequency should not be set, since correct frequency might have changed substantially since last lattice save
    % Not necessary here because getproductionlattice or getinjectionlattice with remove it depending on the state of AO setup
    %SP = rmfield(SP,'RF');
    
    % zero the corrector trims
    try
        setpv('HCM','Trim',0);
        setpv('VCM','Trim',0);
        disp('   Zeroed the corrector trims.');
    catch
        disp('   Trouble setting the corrector trims to zero!');
    end
    
    try
        setpv('SQEPU', 0);
        disp('   Zeroed the EPU skew quad trim coils (values are set by FF).');
    catch
        disp('   Trouble zeroing the EPU skew quad trim coils.');
    end
    
    % set SR03 scrapers to zero in case they were in during a lattice save
    % (it's difficult to remove them from the lattice save routine)
%     try
%         setpv('TOPSCRAPER',0,[3 1]);
%         setpv('BOTTOMSCRAPER',0,[3 1]);
%         setpv('INSIDESCRAPER',0,[3 1]);
%         disp('   Zeroed the SR03 scrapers.');
%     catch
%         disp('   Trouble setting the SR03 scrapers to zero!');
%     end
    
    % Update .HIGH, .HIHI, .LOW, and .LOLO fields of power supply AM channels for alarm handler
    write_alarms_srmags_nominal;
    % Make the setpoint change
    setmachineconfig(SP, 'NoDisplay');
    % Update .HIGH, .HIHI, .LOW, and .LOLO fields of power supply AM channels for alarm handler
    write_alarms_srmags_single;
    disp('   SRLOAD complete.');
else
    disp('   SRLOAD cancelled.');
end

cd(StartDir);

