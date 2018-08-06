function btsbumps(OnOffStr)
%  btsbumps(On/Off)
%

global BTS1spGlobal BTS2spGlobal BTS3spGlobal BTS4spGlobal SEKspGoal SENspGoal BUMP1spGlobal 

N=40;
TimeOut = 2*60;

if nargin < 1
   error('  BTSBUMPS:  1 input required.');
end

if strcmpi(OnOffStr,'On')
   disp('                                   Setting BTS and Bump1 Magnets');

   % Check if anything is already on
   BTS1am = scaget('BTS_____B1_____AM00');
   BTS2am = scaget('BTS_____B2_____AM00');
   BTS3am = scaget('BTS_____B3_____AM00');
   BTS4am = scaget('BTS_____B4_____AM00');
   SEKam = scaget('SR01S___SEK____AM02');
   SENam = scaget('SR01S___SEN____AM00');
   BUMP1am = scaget('SR01S___BUMP1__AM00');

   SEKsp = scaget('SR01S___SEK____AC01');
   SENsp = scaget('SR01S___SEN____AC00');
   BUMP1sp = scaget('SR01S___BUMP1__AC00');
     
   %if abs(BTS1am)>20 | abs(BTS2am)>20 | abs(BTS3am)>20 | abs(BTS4am)>20 | ...
   if (scaget('SR01S___SEK____BC21')==1 && SEKsp>0) || ...
      (scaget('SR01S___SEN____BC20')==1 && SENsp>0) || ...
      (scaget('SR01S___BUMP1__BC21')==1 && BUMP1sp>0) 
      fprintf('                 BTS1       BTS2       BTS3       BTS4       SEK         SEN         BUMP1\n');
      fprintf('  Present AM:  %7.2f    %7.2f    %7.2f    %7.2f    %8.2f    %8.2f    %8.2f\r', BTS1am, BTS2am, BTS3am, BTS4am, SEKam, SENam, BUMP1am);
      fprintf('\n  Atleast one of the bump magnets (SEN, SEK, or BUMP1) is on already.\n');
      fprintf('  This program will not change any of these magnets automatically.\n'); 
      fprintf('  Turn the BTS (1-4) and bump magnets on manually and hit return when done.');
      pause;
      disp(' ');
      BTS1am = scaget('BTS_____B1_____AM00');
      BTS2am = scaget('BTS_____B2_____AM00');
      BTS3am = scaget('BTS_____B3_____AM00');
      BTS4am = scaget('BTS_____B4_____AM00');
      SEKam = scaget('SR01S___SEK____AM02');
      SENam = scaget('SR01S___SEN____AM00');
      BUMP1am = scaget('SR01S___BUMP1__AM00');
      fprintf('                 BTS1       BTS2       BTS3       BTS4       SEK         SEN         BUMP1\n');
      fprintf('  Present AM:  %7.2f    %7.2f    %7.2f    %7.2f    %8.2f    %8.2f    %8.2f\r', BTS1am, BTS2am, BTS3am, BTS4am, SEKam, SENam, BUMP1am);
      disp(' ');
      return
   end
   
   % Setpoint always saved in the SP channel
   SEKspGoal = scaget('SR01S___SEK____AC01');
   SENspGoal = scaget('SR01S___SEN____AC00');
   BUMP1spGoal = scaget('SR01S___BUMP1__AC00');

   
   % Zero the setpoint
   scaput('SR01S___SEK____AC01', 0);
   scaput('SR01S___SEN____AC00', 0);
   scaput('SR01S___BUMP1__AC00', 0);
   pause(1);
   
   % Turn bumps on
   scaput('SR01S___SEK____BC21', 1);
   scaput('SR01S___SEN____BC20', 1);
   scaput('SR01S___BUMP1__BC21', 1);
   
   
   % Turn on Bumps and BTS magnets
   if isempty(BTS1spGlobal)
      BTS1spGoal = 634;
   else
      BTS1spGoal = BTS1spGlobal;
   end
   if isempty(BTS2spGlobal)
      BTS2spGoal = 636.4;
   else
      BTS2spGoal = BTS2spGlobal;
   end
   if isempty(BTS3spGlobal)
      BTS3spGoal = 635.91;
   else
      BTS3spGoal = BTS3spGlobal;
   end
   if isempty(BTS4spGlobal)
      BTS4spGoal = 591.88;
   else
      BTS4spGoal = BTS4spGlobal;
   end


   % Reset and turn on BTS magnets, if necessary
   % Turn off reset
   scaput('BTS_____B1___R_BC23', 0);
   scaput('BTS_____B2___R_BC23', 0);
   scaput('BTS_____B3___R_BC23', 0);
   scaput('BTS_____B4___R_BC23', 0);
   pause(1);

   % If off, reset
   if scaget('BTS_____B1_____BC22') == 0
      scaput('BTS_____B1___R_BC23', 1);
   end
   if scaget('BTS_____B2_____BC22') == 0
      scaput('BTS_____B2___R_BC23', 1);
   end
   if scaget('BTS_____B3_____BC22') == 0
      scaput('BTS_____B3___R_BC23', 1);
   end
   if scaget('BTS_____B4_____BC22') == 0
      scaput('BTS_____B4___R_BC23', 1);
   end
   pause(1);

   % Turn on
   scaput('BTS_____B1_____BC22', 1);
   scaput('BTS_____B2_____BC22', 1);
   scaput('BTS_____B3_____BC22', 1);
   scaput('BTS_____B4_____BC22', 1);

   % Turn off reset
   scaput('BTS_____B1___R_BC23', 0);
   scaput('BTS_____B2___R_BC23', 0);
   scaput('BTS_____B3___R_BC23', 0);
   scaput('BTS_____B4___R_BC23', 0);


elseif strcmpi(OnOffStr, 'Off')
   % Check if all ready on
   BTS1am = scaget('BTS_____B1_____AM00');
   BTS2am = scaget('BTS_____B2_____AM00');
   BTS3am = scaget('BTS_____B3_____AM00');
   BTS4am = scaget('BTS_____B4_____AM00');
   BTS1sp = scaget('BTS_____B1_____AC00');
   BTS2sp = scaget('BTS_____B2_____AC00');
   BTS3sp = scaget('BTS_____B3_____AC00');
   BTS4sp = scaget('BTS_____B4_____AC00');

   if (abs(BTS1am)<20 && BTS1sp==0 && scaget('BTS_____B1_____BC22')==0) && ...
      (abs(BTS2am)<20 && BTS2sp==0 && scaget('BTS_____B2_____BC22')==0) && ...
      (abs(BTS3am)<20 && BTS3sp==0) && ...
      (abs(BTS4am)<20 && BTS4sp==0) && ...
      (scaget('SR01S___SEK____BC21')==0) && ...
      (scaget('SR01S___SEN____BC20')==0) && ...
      (scaget('SR01S___BUMP1__BC21')==0) 
      disp('  BTS1, BTS2, BTS3, and BTS4 already zeroed');
      disp('  BTS1 and BTS2 already OFF');
      disp('  SEN, SEK, and BUMP1 already OFF');
      return
   end
   

   % Turn off Bumps and BTS magnets
   disp('                                   Zeroing BTS and Bump Magnets');
   
   % First save the last setpoint if the magnet is on
   BTS1am = scaget('BTS_____B1_____AM00');
   BTS2am = scaget('BTS_____B2_____AM00');
   BTS3am = scaget('BTS_____B3_____AM00');
   BTS4am = scaget('BTS_____B4_____AM00');
   if abs(BTS1am) > 25
      BTS1spGlobal = scaget('BTS_____B1_____AC00');
   end
   if abs(BTS2am) > 25
      BTS2spGlobal = scaget('BTS_____B2_____AC00');
   end
   if abs(BTS3am) > 25
      BTS3spGlobal = scaget('BTS_____B3_____AC00');
   end
   if abs(BTS4am) > 25
      BTS4spGlobal = scaget('BTS_____B4_____AC00');
   end
   
   SEKspGlobal = scaget('SR01S___SEK____AC01');
   SENspGlobal = scaget('SR01S___SEN____AC00');
   BUMP1spGlobal = scaget('SR01S___BUMP1__AC00');
   
   BTS1spGoal = 0;
   BTS2spGoal = 0;
   BTS3spGoal = 0;
   BTS4spGoal = 0;
   
   SEKspGoal = 0;
   SENspGoal = 0;
   BUMP1spGoal = 0;
else
   error('  BTSBUMPS:  input not valid.');
end


% Print to the screen
BTS1sp = scaget('BTS_____B1_____AC00');
BTS2sp = scaget('BTS_____B2_____AC00');
BTS3sp = scaget('BTS_____B3_____AC00');
BTS4sp = scaget('BTS_____B4_____AC00');
SEKsp = scaget('SR01S___SEK____AC01');
SENsp = scaget('SR01S___SEN____AC00');
BUMP1sp = scaget('SR01S___BUMP1__AC00');


fprintf('                 BTS1       BTS2       BTS3       BTS4       SEK         SEN         BUMP1\n');
fprintf('  Starting SP: %7.2f    %7.2f    %7.2f    %7.2f    %8.2f    %8.2f    %8.2f\n', BTS1sp, BTS2sp, BTS3sp, BTS4sp, SEKsp, SENsp, BUMP1sp);
fprintf('      Goal SP: %7.2f    %7.2f    %7.2f    %7.2f    %8.2f    %8.2f    %8.2f\n', BTS1spGoal, BTS2spGoal, BTS3spGoal, BTS4spGoal, SEKspGoal, SENspGoal, BUMP1spGoal);

t0 = clock;
BTS1am = scaget('BTS_____B1_____AM00');
BTS2am = scaget('BTS_____B2_____AM00');
BTS3am = scaget('BTS_____B3_____AM00');
BTS4am = scaget('BTS_____B4_____AM00');
SEKam = scaget('SR01S___SEK____AM02');
SENam = scaget('SR01S___SEN____AM00');
BUMP1am = scaget('SR01S___BUMP1__AM00');

for i = 1:N
   % Set SP
   scaput('BTS_____B1_____AC00', BTS1sp + i*(BTS1spGoal-BTS1sp)/N);
   scaput('BTS_____B2_____AC00', BTS2sp + i*(BTS2spGoal-BTS2sp)/N);
   scaput('BTS_____B3_____AC00', BTS3sp + i*(BTS3spGoal-BTS3sp)/N);
   scaput('BTS_____B4_____AC00', BTS4sp + i*(BTS4spGoal-BTS4sp)/N);
   scaput('SR01S___SEK____AC01', SEKsp + i*(SEKspGoal-SEKsp)/N);
   scaput('SR01S___SEN____AC00', SENsp + i*(SENspGoal-SENsp)/N);
   scaput('SR01S___BUMP1__AC00', BUMP1sp + i*(BUMP1spGoal-BUMP1sp)/N);
   sleep(1);
   
   BTS1am = scaget('BTS_____B1_____AM00');
   BTS2am = scaget('BTS_____B2_____AM00');
   BTS3am = scaget('BTS_____B3_____AM00');
   BTS4am = scaget('BTS_____B4_____AM00');
   SEKam = scaget('SR01S___SEK____AM02');
   SENam = scaget('SR01S___SEN____AM00');
   BUMP1am = scaget('SR01S___BUMP1__AM00');
   
   fprintf('   Present AM: %7.2f    %7.2f    %7.2f    %7.2f    %8.2f    %8.2f    %8.2f\r', BTS1am, BTS2am, BTS3am, BTS4am, SEKam, SENam, BUMP1am);
   pause(0);
end

while any([abs(BTS1am-BTS1spGoal)>15 abs(BTS2am-BTS2spGoal)>15 abs(BTS2am-BTS3spGoal)>15 abs(BTS4am-BTS4spGoal)>15]) && etime(clock,t0)<=TimeOut
%           abs(SEKam-SEKspGoal)>20 abs(SENam-SENspGoal)>20 abs(BUMP1am-BUMP1spGoal)>20]) & etime(clock,t0)<=TimeOut
   BTS1am = scaget('BTS_____B1_____AM00');
   BTS2am = scaget('BTS_____B2_____AM00');
   BTS3am = scaget('BTS_____B3_____AM00');
   BTS4am = scaget('BTS_____B4_____AM00');
   SEKam = scaget('SR01S___SEK____AM02');
   SENam = scaget('SR01S___SEN____AM00');
   BUMP1am = scaget('SR01S___BUMP1__AM00');
   
   fprintf('   Present AM: %7.2f    %7.2f    %7.2f    %7.2f    %8.2f    %8.2f    %8.2f\r', BTS1am, BTS2am, BTS3am, BTS4am, SEKam, SENam, BUMP1am);
   pause(0);
end

if  etime(clock,t0) >= TimeOut
   fprintf('\n   WARNING: Timed-out waiting for SP-AM to be within tolerance (%d second timeout)\n', TimeOut);
   if strcmpi(OnOffStr, 'Off') 
      fprintf('            BTS and BUMP magnets may or may not be OFF\n\n'); 
   else
      fprintf('            BTS and BUMP magnets may or may not be ON\n\n'); 
   end
   return
else
   % Extra delay
   t0 = clock; 
   while etime(clock,t0) < 5
      BTS1am = scaget('BTS_____B1_____AM00');
      BTS2am = scaget('BTS_____B2_____AM00');
      BTS3am = scaget('BTS_____B3_____AM00');
      BTS4am = scaget('BTS_____B4_____AM00');
      
      SEKam = scaget('SR01S___SEK____AM02');
      SENam = scaget('SR01S___SEN____AM00');
      BUMP1am = scaget('SR01S___BUMP1__AM00');
      
      fprintf('   Present AM: %7.2f    %7.2f    %7.2f    %7.2f    %8.2f    %8.2f    %8.2f\r', BTS1am, BTS2am, BTS3am, BTS4am, SEKam, SENam, BUMP1am);
      pause(0);
   end
   fprintf('\n');
end


if strcmpi(OnOffStr, 'Off') 
   % Turn BTS1 and BTS2 off
   disp('  BTS1, BTS2, BTS3, and BTS4 zeroed');
   disp('  BTS1 and BTS2 OFF');
   scaput('BTS_____B1_____BC22', 0);
   scaput('BTS_____B2_____BC22', 0);

   % Turn bumps off and restore the last SP
   disp('  SEN, SEK, and BUMP1 OFF (AM might still be dropping a little)');
   scaput('SR01S___SEK____BC21', 0);
   scaput('SR01S___SEN____BC20', 0);
   scaput('SR01S___BUMP1__BC21', 0);
   
   scaput('SR01S___SEK____AC01', SEKspGlobal);
   scaput('SR01S___SEN____AC00', SENspGlobal);
   scaput('SR01S___BUMP1__AC00', BUMP1spGlobal);
else
   disp('  BTS1, BTS2, BTS3, and BTS4 reached setpoint');
   disp('  SEN, SEK, and BUMP1 ON (AM might still be rising a little)');
end

disp('  ');

