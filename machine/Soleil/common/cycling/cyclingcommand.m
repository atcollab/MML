function varargout= cyclecommand(varargin)
%CYCLINGCOMMAND - Cyclage control for magnet
%
%  INPUTS
%  1. family - Element or family for cycling command
%  2. command - Start, Stop, Pause, Resume
%
%  EXAMPLES
%  1. cyclecommand('LT1/AE/cycleQ.3','Start')
%  2. cyclecommand('CycleQ','Start')
%
%  See also setcyclecurve, getcyclecurve, plotcyclingcurve, LT1cycling

%
% Written by Laurent S. Nadolski

Family = varargin{1};

%% check if family is valid and return it in AO
[FamilyIndex, AO] = isfamily(Family);

%% Commands are case sensitive in TANGO
% Force the right case for supported commands
command = varargin{end};

if strcmpi(command,'Start')
    command = 'Start';
elseif strcmpi(command,'Stop')
    command = 'Stop';
elseif strcmpi(command,'Init')
    command = 'Init';
elseif strcmpi(command,'Pause')
    command = 'Pause';
elseif strcmpi(command,'Resume')
    command = 'Resume';
elseif strcmpi(command,'Status')
    command = 'Status';
elseif strcmpi(command,'State')
    command = 'State';
else
    error('Unknown command')
end

if FamilyIndex

    if (ismemberof(Family,'Cyclage'))
        rep = tango_group_command_inout2(AO.GroupId,command,1,0);        
        for k = 1:length(rep)
            data = rep.replies(k).data;
        end
        varargout{1} = data;
    else
        error('Wrong Family');
%         %%%%%%%%%%%%%%%%
%         % FAMILY INPUT %
%         %%%%%%%%%%%%%%%%
% 
%         % DeviceList
%         if length(varargin) > 1
%             DeviceList =varargin{2};
%         else
%             DeviceList = family2dev(Family);     % Default behavior comes from family2dev
%         end
% 
%         %Convertion to TANGO name
%         Family = family2tango(Family,Field,DeviceList);
%         
    end
else % TANGONAME  
    if strcmpi(command,'Start')
        tango_command_inout2(Family, 'Init');
        tango_command_inout2(Family,command);
    end
end

