function SCH = sch(COMMANDS, INSTRUCTIONS, PARAMS)
%SCH constructor for 'sch' - scheduler sequence class
% to be given to SHEDULER
%   SCH(COMMANDS, SCHEDULE, PARAMS)
%    COMMANDS      cell array of matlab commands to be executed as a sequence
%    INSTRUCTIONS  one of the scheduler instructions DELAY CONDITION GOTO 
if ~(iscell(COMMANDS) & iscell(INSTRUCTIONS) & iscell(PARAMS))
    error('All arguments must be cell arrays')
end
L = length(COMMANDS);
if ~(L==length(INSTRUCTIONS) & L==length(PARAMS))
    error('All input array must be the same length')
end
S = struct('CurrentPos',1,'TimerID', 0, 'TriggerType','internal', 'Commands',{COMMANDS},'Instructions',{INSTRUCTIONS},'Params',{PARAMS});

SCH = class(S,'sch');