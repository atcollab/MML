% A more improved standardisation of the Storage Ring quads, sextupoles,
% and an option to cycle the dipole magnet as well.
%
%
disp(' ');
disp('You are about to begin a Storage Ring Cycle.');
disp('ARE YOU SURE THAT YOU WANT TO CONTINUE?? ');

answer = input('[y/n]: ','s');
if ~strcmp(answer,'y')
    disp('Not performing simplecycle, goodbye.');
    return
end

%--------------------------------------------------------------------------
%                           Quad and Sextupole Cycle
%--------------------------------------------------------------------------
disp(' ');
disp('Saving set points of all quads, sextupoles, and dipole.');
qfavals = getsp('QFA');
qdavals = getsp('QDA');
qfbvals = getsp('QFB');
sfavals = getsp('SFA');
sfbvals = getsp('SFB');
sdavals = getsp('SDA');
sdbvals = getsp('SDB');
dbmval = getsp('SR00DPS01:CURRENT_SP');
disp(' ');
pause(1);

disp('Do you want to standardise the quad and sextupole families?');
answer = input('[y/n]: ','s');
if ~strcmp(answer,'y')
    disp('Not standardising, goodbye.')
    return
end

fams = {'QFA','QDA','QFB','SFA','SDA','SFB','SDB'};

for i = 1:3
    vals = {0 0 0 0 0 0 0};
    disp(' ');
    temp = ['Starting cycle ',num2str(i) ];
    disp(temp);
    disp('Setting the following families to 0:');
    setsp(fams,vals);

    answer = input('Did all magnets go to zero? [y/n]: ','s');

    while ~strcmp(answer,'y')
        disp('waiting...');
        pause(3);
        answer = input('Now did they go to zero? [y/n]: ','s');
    end

    disp('Setting magnets to max.')

    vals = {160 90 160 90 90 60 80};
    setsp(fams,vals);

    answer = input('Did all magnets go to max? [y/n]: ','s');

    while ~strcmp(answer,'y')
        disp('waiting...');
        pause(3);
        answer = input('Now did they go to max? [y/n]: ','s');
    end
end

disp(' ');
disp('Standardising of the quad and sextupole families complete, now loading saved setpoints.');
setsp('QFA',qfavals,'hardware');
setsp('QFB',qfbvals,'hardware');
setsp('QDA',qdavals,'hardware');
setsp('SFA',sfavals,'hardware');
setsp('SFB',sfbvals,'hardware');
setsp('SDA',sdavals,'hardware');
setsp('SDB',sdbvals,'hardware');
pause(3);
disp(' ');
disp('Check all quads and sextupoles went to their setpoints and adjust if required.');


%-----------------------------------------------------------------------
%                           Optional dipole cycle
%-----------------------------------------------------------------------
disp('Do you want to standardise the dipole?');
answer = input('[y/n]: ','s');
if ~strcmp(answer,'y')
    disp('Standardising complete, goodbye.');
    return
end
for i = 1:1
    disp(' ');
    temp = ['Starting dipole cycle ',num2str(i) ];
    disp(temp);
    disp('Setting the dipole to 0:');
    setsp('SR00DPS01:CURRENT_SP',0);
    disp('Waiting......');
    pause(6);

    answer = input('Did the dipole go to zero? [y/n]: ','s');

    while ~strcmp(answer,'y')
        disp('Waiting......');
        pause(6);
        answer = input('Now did it go to zero? [y/n]: ','s');
    end

    disp('Setting dipole to max.')
    setsp('SR00DPS01:CURRENT_SP',660);
    disp('Waiting......');
    pause(6);
    answer = input('Did the dipole go to max? [y/n]: ','s');

    while ~strcmp(answer,'y')
        disp('Waiting......');
        pause(6);
        answer = input('Now did it go to max? [y/n]: ','s');
    end
end

disp(' ');
disp('Standardising of the dipole complete, now loading saved setpoint.');
setsp('SR00DPS01:CURRENT_SP',dbmval);
pause(3);
disp(' ');
disp('Check the dipole went to its setpoint and adjust if required.');
disp('Standardising complete.');
