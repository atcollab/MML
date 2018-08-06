mode = scaget('SR_ENERGY');

if mode==1.900
    HCM11sp = [38.4;38.4];  %getsp('HCMCHICANEM',[11 1; 11 2])
%    HCM11sp = [40.0;40.0];  %changed for 3-15-06 2-bunch because SR11U___HCM2 was hitting a limit and tripping orbit feedback off when EPU11-2 would move to extreme settings
elseif mode==1.500
    HCM11sp = [52.0;52.0];
else
    disp('Operational Mode is unknown! Assuming 1.9 GeV values for chicane!');
    HCM11sp = [38.4;38.4];  %getsp('HCMCHICANEM',[11 1; 11 2])    
end

fprintf('\n');
fprintf('   Hit Ctrl-c to stop this application.\n');
fprintf('\n');

i = 0;
while 1
    i = i + 1;
    setsp('HCMCHICANEM', HCM11sp, [11 1; 11 2]);
    fprintf('   Setting HCM Motor Chicane [11 1] & [11 2]  %s \n', datestr(clock,0));
    fprintf('   Hit Ctrl-c to stop this application.\r');
    pause(5);
end
    