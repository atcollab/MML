function [ConfigSetpoint] = clsmachine2sim(mode)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsmachine2sim.m 1.2 2007/03/02 09:03:10CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

% CLSMACHINE2SIM
% [ConfigSetpoint] = clsmachine2sim(mode)
%
%  INPUTS
%  1. MODE
%           the mode is simply either 'Online' or 'Archive'

%           ONLINE: will retrieve the current machine settings as they are
%           currently set in the ring
%
%           SIMULATOR: will prompt the user to specify a workspace file that 
%           was previously saved and those settings will be applied to the simulator model setpoints           
% ----------------------------------------------------------------------------------------------

% Modified the original 'machine2sim', by Russ Berg
if(exist('mode'))
    if(strcmpi(mode, 'Archive'))
        DirectoryName = getfamilydata('Directory','ConfigData');
        [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file', DirectoryName);
        if FileName == 0
            fprintf('   No change to lattice (srrestore)');
            return
        end
        load([DirectoryName FileName]);
    end     
    
    %%need to havndle ONLINE 
    
    fprintf('Retrieving setpoints from %s\n',mode); 
    %ConfigSetpoint = getclsconfig(mode);
    setclsconfig(ConfigSetpoint, 'Simulator');
else
    fprintf('mode not specified:> ''Online'' or ''Archive''\n'); 
    fprintf('\t\t\tex: clsmachine2sim(''Archive'')'); 
    
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsmachine2sim.m  $
% Revision 1.2 2007/03/02 09:03:10CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
