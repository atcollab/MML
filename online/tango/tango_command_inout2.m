function argout = tango_command_inout2(dev,command,argin)
% TANGO_COMMAND_INOUT2 - enhanced tango_command_inout
%
%  argout=tango_command_inout2(dev,command,argin)
%
% INPUTS
% 1. dev -  device name
% 2. command - command name
% 3. argin - intput arguments
%  
% OUTPUTS
%  1. output arguments
%
% EXAMPLES
%  
% See also tango_command_inout

% Written by Laurent S. Nadolski

if exist('argin','var')
    argout = tango_command_inout(dev,command,argin);
else
    argout = tango_command_inout(dev,command);
end

if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end