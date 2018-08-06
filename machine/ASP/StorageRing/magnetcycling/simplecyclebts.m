% A more improved standardisation of the BTS dipoles.
%
%

disp(' ');
disp('You are about to begin a BTS Dipole Cycle.');
disp('ARE YOU SURE THAT YOU WANT TO CONTINUE?? ');

answer = input('[y/n]: ','s');
if ~strcmp(answer,'y')
    disp('Not performing bts cycle, goodbye.');
    return
end
for l = 1:3
    %--------------------------------------------------------------------------
    %                           Dipole Cycle
    %--------------------------------------------------------------------------
    disp(' ');
    disp('Saving set points of all dipoles.');
    bts31vals =getsp('PS-BA-3-1:CURRENT_SP');
    bts32vals =getsp('PS-BA-3-2:CURRENT_SP');
    bts33vals =getsp('PS-BA-3-3:CURRENT_SP');
    bts34vals =getsp('PS-BA-3-4:CURRENT_SP');

    disp(bts31vals)
    disp(bts32vals)
    disp(bts33vals)
    disp(bts34vals)

    bts31rdbk =getsp('PS-BA-3-1:CURRENT_MONITOR');
    bts32rdbk =getsp('PS-BA-3-2:CURRENT_MONITOR');
    bts33rdbk =getsp('PS-BA-3-3:CURRENT_MONITOR');
    bts34rdbk =getsp('PS-BA-3-4:CURRENT_MONITOR');

    disp(' ');
    pause(1);

    disp('Do you want to cycle the Dipoles?');
    answer = input('[y/n]: ','s');
    if ~strcmp(answer,'y')
        disp('Not cycling, goodbye.');
        return
%     end
%     
%     for k = 1:3
%     disp('Setting dipoles to zero.')
%     
%         bts31min = 0;
%         bts32min = 0;
        bts33min = 0;
        bts34min = 0;

        setsp('PS-BA-3-1:CURRENT_SP',bts31min);
        setsp('PS-BA-3-2:CURRENT_SP',bts32min);
        setsp('PS-BA-3-3:CURRENT_SP',bts33min);
        setsp('PS-BA-3-4:CURRENT_SP',bts34min);

        for j = 1:6
            pause(3)

            bts31rdbk =getsp('PS-BA-3-1:CURRENT_MONITOR');
            bts32rdbk =getsp('PS-BA-3-2:CURRENT_MONITOR');
            bts33rdbk =getsp('PS-BA-3-3:CURRENT_MONITOR');
            bts34rdbk =getsp('PS-BA-3-4:CURRENT_MONITOR');

            if ( ...
                    abs(bts31min-bts31rdbk)<.6 &&...
                    abs(bts32min-bts32rdbk)<.6 &&...
                    abs(bts33min-bts33rdbk)<.6 &&...
                    abs((bts34min-bts34rdbk)<.6) ...
                    )
                break;
            else
                continue;
            end;
            if j > 5
                setsp('PS-BA-3-1:CURRENT_SP',bts31vals);
                setsp('PS-BA-3-2:CURRENT_SP',bts32vals);
                setsp('PS-BA-3-3:CURRENT_SP',bts33vals);
                setsp('PS-BA-3-4:CURRENT_SP',bts34vals);
                error('TIME OUT - Adjust dipole manually.')
            end;
        end;

        bts31rdbk =getsp('PS-BA-3-1:CURRENT_MONITOR');
        bts32rdbk =getsp('PS-BA-3-2:CURRENT_MONITOR');
        bts33rdbk =getsp('PS-BA-3-3:CURRENT_MONITOR');
        bts34rdbk =getsp('PS-BA-3-4:CURRENT_MONITOR');
%         disp(bts31rdbk)
%         disp(bts32rdbk)
%         disp(bts33rdbk)
%         disp(bts34rdbk)

        disp('Setting Dipoles to max.')
        bts31max = 155;
        bts32max = 155;
        bts33max = 155;
        bts34max = 155;

        for j = 1:4
            pause(3)

            bts31rdbk =getsp('PS-BA-3-1:CURRENT_MONITOR');
            bts32rdbk =getsp('PS-BA-3-2:CURRENT_MONITOR');
            bts33rdbk =getsp('PS-BA-3-3:CURRENT_MONITOR');
            bts34rdbk =getsp('PS-BA-3-4:CURRENT_MONITOR');

            setsp('PS-BA-3-1:CURRENT_SP',bts31max);
            setsp('PS-BA-3-2:CURRENT_SP',bts32max);
            setsp('PS-BA-3-3:CURRENT_SP',bts33max);
            setsp('PS-BA-3-4:CURRENT_SP',bts34max);

            if ( ...
                    abs(bts31max-bts31rdbk)<.6 &&...
                    abs(bts32max-bts32rdbk)<.6 &&...
                    abs(bts33max-bts33rdbk)<.6 &&...
                    abs(bts34max-bts34rdbk)<.6 ...
                    )
                break;
            else
                continue;
            end;
            if j > 3
                setsp('PS-BA-3-1:CURRENT_SP',bts31vals);
                setsp('PS-BA-3-2:CURRENT_SP',bts32vals);
                setsp('PS-BA-3-3:CURRENT_SP',bts33vals);
                setsp('PS-BA-3-4:CURRENT_SP',bts34vals);
                error('TIME OUT - Adjust dipoled manually.')
            end;
        end;


    end;

    bts31rdbk =getsp('PS-BA-3-1:CURRENT_MONITOR');
    bts32rdbk =getsp('PS-BA-3-2:CURRENT_MONITOR');
    bts33rdbk =getsp('PS-BA-3-3:CURRENT_MONITOR');
    bts34rdbk =getsp('PS-BA-3-4:CURRENT_MONITOR');

%     disp(bts31rdbk)
%     disp(bts32rdbk)
%     disp(bts33rdbk)
%     disp(bts34rdbk)


    disp(' ');
    disp('Standardising of the Dipoles complete, now loading saved setpoints.');
    setsp('PS-BA-3-1:CURRENT_SP',bts31vals);
    setsp('PS-BA-3-2:CURRENT_SP',bts32vals);
    setsp('PS-BA-3-3:CURRENT_SP',bts33vals);
    setsp('PS-BA-3-4:CURRENT_SP',bts34vals);

    pause(5);

    bts31rdbk =getsp('PS-BA-3-1:CURRENT_MONITOR');
    bts32rdbk =getsp('PS-BA-3-2:CURRENT_MONITOR');
    bts33rdbk =getsp('PS-BA-3-3:CURRENT_MONITOR');
    bts34rdbk =getsp('PS-BA-3-4:CURRENT_MONITOR');
    disp(bts31rdbk)
    disp(bts32rdbk)
    disp(bts33rdbk)
    disp(bts34rdbk)
    pause(3);
    disp(' ');
    disp('Check all set points, adjust and cycle again as needed');

    disp(' ')
    disp(' ')
    disp('Would you like to cycle again?')
    ans = input('[y\\n]: ','s');

    if  ~strcmp(ans,'y')
        disp('Cycling finished.');
        disp('Bye Bye')
        return;
    end;
end;
