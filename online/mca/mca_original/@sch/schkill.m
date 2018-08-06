function SOUT = schkill(SIN)
SOUT = SIN;
T = SIN.TimerID;
timereval(5,T);
SOUT.TimerID = 0;