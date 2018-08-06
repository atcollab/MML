function tango_starter(starter, command)
% TANGO_STARTER - Interact with a tangostarter, Full interface implemented
%
%  INPUTS
%  1. command - command name among  possibilities
%
%     'DevGetRunningServers'
%     'DevGetStopServers'
%     'DevReadLog'
%     'DevStart'
%     'DevStartAll'
%     'DevStop'
%     'DevStopAll'
%     'Init'
%     'NotifyDaemonState'
%     'StartPollingThread'
%     'State'
%     'Status'
%     'UpdateServersInfo'
%
%  OUTPUTS
%  None
%
%  EXAMPLES
%  1. tango_starter('tango/admin/escaut','DevGetRunningServers')

%
%  Written by Laurent S. Nadolski

if nargin ~= 2
    disp(['Wrong syntax! Try help on ' mfilename])
    return,
end

%% Verify starter responds
%  list of command
cmdDescList = tango_command_list_query(starter);
if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        return;
end

cmdList = [{cmdDescList.cmd_name}];

% look whether the command exists or not
if all(strcmp(command,cmdList) == 0)
    disp('Command unknown')
    disp(['try help ' mfilename])
    return;
else
    icmd = find(strcmp(command,cmdList) == 1);
end

%%
cmdDescList(icmd).in_type
switch cmdDescList(icmd).in_type
    case '-' % DEV_VOID
        % Init, State, Status,UpdateServersInfo,NotifyDaemonState  
        tango_command_inout2(starter,command);
    case '1-by-1 int16' % DEV_SHORT
        % DevStartAll, DevStopAll
        answer = input('Which level? [1-n] \n');
        tango_command_inout2(starter,command,int16(answer));
    case '1-by-1 uint16' % DEV_BOOLEAN
        % DevGetRunnningServers, DevGetStopServers
        answer = input('All ? [1/0] \n');
        rep = tango_command_inout2(starter,command,uint8(answer));
        rep'
    case '1-by-n char' %DEV_STRING
        % DevStart, DevStop, DevReadLog
        disp('If you do not know, try: tango_starter(''DevGetRunningServers'')');
        answer = input('Which dserver? [servername/instance] \n','s');
        tango_command_inout2(starter,command,answer);
    otherwise
        disp('Do Nothing')
end