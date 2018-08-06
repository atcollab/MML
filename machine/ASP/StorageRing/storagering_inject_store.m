% A simple method to set the sextupoles in the storage ring for injecting
% or storing beam. To inject select "i" and to store select "s". Easy.


disp(' ');
disp('You are about to Change Sextupoles for Storing or Injecting.');
disp('ARE YOU SURE THAT YOU WANT TO CONTINUE?? ');

answer = input('[y/n]: ','s');
if ~strcmp(answer,'y')
    error('... , goodbye.');
    return
end

sfaval_monitor = getsp('SFA');
sdbval_monitor = getsp('SDB');

if (any((sfaval_monitor >= 79.5)&(sfaval_monitor <= 80.5)) && (any((sdbval_monitor >= 45.5)&(sdbval_monitor <= 46.5))))
    disp(' ');
    disp('The Sextupoles are currently set for INJECTING, do you want to change them to Store??');
    answer = input('[y/n]: ','s');
    if ~strcmp(answer,'y')
        disp('Goodbye.');
        return
    elseif strcmp(answer,'y')
        storering = 's'; 
    end
elseif (any((sfaval_monitor >= 69.5)&(sfaval_monitor <= 70.5)) && (any((sdbval_monitor >= 48.5)&(sdbval_monitor <= 49.5))))
    disp(' ');
    disp('The Sextupoles are currently set for STORING, do you want to change them to Inject??');
    answer = input('[y/n]: ','s');
    if ~strcmp(answer,'y')
        disp('Goodbye.');
        return
    elseif strcmp(answer,'y')
        storering = 'i';
    end
else
    disp(' ');
    disp('The Sextupoles are not currently set for INJECTING OR STORING......error!');
    return
end


%Injecting Beam Settings
%-------------------------------------------
%setsp('SFA',80);
%setsp('SDA',85);
%setsp('SFB',45);
%setsp('SDB',46);

if strcmp(storering,'i')
    sfaval_initial = getsp('SFA');
    sdbval_initial = getsp('SDB');
    %     if (any((sfaval_initial == 70)) && (any((sdbval_initial == 49)))
    if (any((sfaval_initial >= 69.5)&(sfaval_initial <= 70.5)) && (any((sdbval_initial >= 48.5)&(sdbval_initial <= 49.5))))
        disp(' ');
        fprintf('\nStepping SFAs and SDBs ');
        for inc=1:20;
            stepsp('SFA',0.5);
            stepsp('SDB',-0.15);
            pause(0.5);
            fprintf('.');
        end
        fprintf(' done.\n');
    elseif (any((sfaval_initial >= 79.5)&(sfaval_initial <= 80.5)) && (any((sdbval_initial >= 45.5)&(sdbval_initial <= 46.5))))
        disp('The sextupoles are already set for Injection');
        break
    else
        disp('Check sextupole set points as they are not currently set to Stored settings');
        disp('To start stepping they must be at SFA = 70 & SDB = 49');
        return
    end
    % There appears to be a small error creeping in on a couple of the
    % sextupoles. After numerous times of stepping up and down the errors
    % in the set points show. To counteract this, a final check and set, of
    % the actual values will be implemented.
    for i = 1:3
        sfaval_final = getsp('SFA');
        if sfaval_final == 80
            break
        elseif any(sfaval_final ~= 80)
            fprintf('\nThere is a very small error in one/more of the SFAs, resetting.....');
            setsp('SFA',80);
            pause(3);
        end
        if i == 3
            fprintf('\nError in setting SFA family to inject mode.......Aborting!');
            return
        end
    end
    fprintf('done.\n');
    for x = 1:3
        sdbval_final = getsp('SDB');
        if sdbval_final == 46
            break
        elseif any(sdbval_final ~= 46)
            fprintf('\nThere is a very small error in one/more of the SDBs, resetting.....');
            setsp('SDB',46);
            pause(3);
        end
        if x == 3
            fprintf('\nError in setting SDB family to inject mode.......Aborting!');
            return
        end
    end
    fprintf('done.\n');


    %Storing Beam Settings
    %-------------------------------------------
    % setsp('SFA',70);
    % setsp('SDA',85);
    % setsp('SFB',45);
    % setsp('SDB',49);

elseif strcmp(storering,'s')
    sfaval_initial = getsp('SFA');
    sdbval_initial = getsp('SDB');
    %     if (any((sfaval_initial == 80)) && (any(sdbval_initial == 46)))
    if (any((sfaval_initial >= 79.5)&(sfaval_initial <= 80.5)) && (any((sdbval_initial >= 45.5)&(sdbval_initial <= 46.5))))
        disp(' ');
        fprintf('\nStepping SFAs and SDBs ');
        for inc=1:20;
            stepsp('SFA',-0.5);
            stepsp('SDB',0.15);
            pause(0.5);
            fprintf('.');
        end
        fprintf(' done.\n');
    elseif (any((sfaval_initial >= 69.5)&(sfaval_initial <= 70.5)) && (any((sdbval_initial >= 48.5)&(sdbval_initial <= 49.5))))
        disp('The Sextupoles are already set for Storing');
        break
    else
        disp('Check sextupole set points as they are not currently set to Injected settings');
        disp('To start stepping they must be at SFA = 80 & SDB = 46');
        return
    end
    % There appears to be a small error creeping in on a couple of the
    % sextupoles. After numerous times of stepping up and down the errors
    % in the set points show. To counteract this, a final check and set, of
    % the actual values will be implemented.
    for i = 1:3
        sfaval_final = getsp('SFA');
        if sfaval_final == 70
            break
        elseif any(sfaval_final ~= 70)
            fprintf('\nThere is a very small error in one/more of the SFA, resetting.....');
            setsp('SFA',70);
            pause(3);
        end
        if i == 3
            fprintf('\nError in setting SFA family to inject mode.......Aborting!');
            return
        end
    end
    fprintf('done.\n');
    for x = 1:3
        sdbval_final = getsp('SDB');
        if sdbval_final == 49
            break
        elseif any(sdbval_final ~= 49)
            fprintf('\nThere is a very small error in one/more of the SDB, resetting.....');
            setsp('SDB',49);
            pause(3);
        end
        if x == 3
            fprintf('\nError in setting SDB family to inject mode.......Aborting!');
            return
        end
    end
    fprintf('done.\n');


else
    error('You failed to make a valid selection... Goodbye');
end