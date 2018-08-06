function SOUT = scheduler(SIN)
if ~isa(SIN,'sch')
    error('Argument must be an ''sch'' class');
end

SOUT = SIN;
CP = SIN.CurrentPos;
SOUT.CurrentPos = CP+1;

if CP <= length(SOUT.Commands)
    if strcmp(lower(SOUT.TriggerType),'internal')
        timercbstring = [SIN.Commands{CP},';',inputname(1),'= scheduler(',inputname(1),');'];
        SOUT.TimerID = timereval(1,SIN.Params{CP},timercbstring);
    end
else
    disp('Sequence completed')
    SOUT.TimerID = 0;
    SOUT.CurrentPos = 1;
end
