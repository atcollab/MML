function turnoffbumps
%TURNOFFBUMPS - Turns off the BTS Bump and Septa magnets
%  turnoffbumps
% 
%  Note: Called by srcontrol in case they are on when orbit feedback is started
%

N=40;
TimeOut = 2*60;

if (getsp('SR01S___SEK____BC21')==0) && (getsp('SR01S___SEN____BC20')==0) && (getsp('SR01S___BUMP1__BC21')==0) 
	disp('   SEN, SEK, and BUMP1 already OFF');
	return
end

% Turn off Bumps and BTS magnets
disp('   Zeroing Bump and Septa Magnets');

% First save the last setpoint if the magnet is on
SEKsp = getsp('SR01S___SEK____AC01');
SENsp = getsp('SR01S___SEN____AC00');
BUMP1sp = getsp('SR01S___BUMP1__AC00');

SEKspGoal = 0;
SENspGoal = 0;
BUMP1spGoal = 0;

% Print to the screen
fprintf('                  SEK         SEN         BUMP1\n');
fprintf('   Starting SP: %8.2f    %8.2f    %8.2f\n', SEKsp, SENsp, BUMP1sp);
fprintf('       Goal SP: %8.2f    %8.2f    %8.2f\n', SEKspGoal, SENspGoal, BUMP1spGoal);

t0 = clock;
SEKam = getam('SR01S___SEK____AM02');
SENam = getam('SR01S___SEN____AM00');
BUMP1am = getam('SR01S___BUMP1__AM00');

for i = 1:N
   % Set SP
   setsp('SR01S___SEK____AC01', SEKsp + i*(SEKspGoal-SEKsp)/N);
   setsp('SR01S___SEN____AC00', SENsp + i*(SENspGoal-SENsp)/N);
   setsp('SR01S___BUMP1__AC00', BUMP1sp + i*(BUMP1spGoal-BUMP1sp)/N);
   sleep(1);
   
   SEKam = getam('SR01S___SEK____AM02');
   SENam = getam('SR01S___SEN____AM00');
   BUMP1am = getam('SR01S___BUMP1__AM00');
   
   fprintf('    Present AM: %8.2f    %8.2f    %8.2f\r', SEKam, SENam, BUMP1am);
   pause(0);
end

while any([abs(SEKam-SEKspGoal)>20 abs(SENam-SENspGoal)>20 abs(BUMP1am-BUMP1spGoal)>20]) && etime(clock,t0)<=TimeOut
   SEKam = getam('SR01S___SEK____AM02');
   SENam = getam('SR01S___SEN____AM00');
   BUMP1am = getam('SR01S___BUMP1__AM00');
   
   fprintf('    Present AM: %8.2f    %8.2f    %8.2f\r', SEKam, SENam, BUMP1am);
   pause(0);
end

if  etime(clock,t0) >= TimeOut
   fprintf('\n    WARNING: Timed-out waiting for SP-AM to be within tolerance (%d second timeout)\n', TimeOut);
   fprintf('             BTS and BUMP magnets may or may not be OFF\n\n'); 
   return
else
   % Extra delay
   t0 = clock; 
   while etime(clock,t0) < 5
      SEKam = getam('SR01S___SEK____AM02');
      SENam = getam('SR01S___SEN____AM00');
      BUMP1am = getam('SR01S___BUMP1__AM00');
      
      fprintf('    Present AM: %8.2f    %8.2f    %8.2f\r', SEKam, SENam, BUMP1am);
      pause(0);
   end
   fprintf('\n');
end

% Turn bumps off and restore the last SP
disp('   SEN, SEK, and BUMP1 OFF (AM might still be dropping a little)');

setsp('SR01S___SEK____BC21', 0);
setsp('SR01S___SEN____BC20', 0);
setsp('SR01S___BUMP1__BC21', 0);

setsp('SR01S___SEK____AC01', SEKsp);
setsp('SR01S___SEN____AC00', SENsp);
setsp('SR01S___BUMP1__AC00', BUMP1sp);

disp('  ');

