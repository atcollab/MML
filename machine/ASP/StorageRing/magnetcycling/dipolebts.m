% This will cycle one dipole at a time in the BTS.
%
%  The BTS cycle that could
%
disp(' ');
disp('You are about to begin a BTS Cycle.');
disp('ARE YOU SURE THAT YOU WANT TO CONTINUE?? ');

answer = input('[y/n]: ','s');
if ~strcmp(answer,'y')
    disp('Not performing bts cycle, goodbye.');
    return
end

%--------------------------------------------------------------------------
%                           Dipole Cycle
%--------------------------------------------------------------------------

% grabs all initial set points and saves them for later. them to screen so
% that you know what they are to start with

disp(' ');
disp('Saving set points of all dipoles.');
bts31vals =getsp('PS-BA-3-1:CURRENT_SP');
bts32vals =getsp('PS-BA-3-2:CURRENT_SP');
bts33vals =getsp('PS-BA-3-3:CURRENT_SP');
bts34vals =getsp('PS-BA-3-4:CURRENT_SP');

% disp(bts31vals)
% disp(bts32vals)
% disp(bts33vals)
% disp(bts34vals)

bts31rdbk =getsp('PS-BA-3-1:CURRENT_MONITOR');
bts32rdbk =getsp('PS-BA-3-2:CURRENT_MONITOR');
bts33rdbk =getsp('PS-BA-3-3:CURRENT_MONITOR');
bts34rdbk =getsp('PS-BA-3-4:CURRENT_MONITOR');

disp(' ');
pause(1);

% check so see if you haven't accidently started the cycle

disp('Do you want to cycle the Dipoles?');
answer = input('[y/n]: ','s');
if ~strcmp(answer,'y')
    disp('Not cycling, goodbye.');
    return
end

% Here is where we pick which dipole you want to cycle. inputs must be
% exactly as displayed.

disp('Which dipole do you want to cycle?');
answer = input('[bts31\\bts32\\bts33\\bts34]: ','s');

% This lets the magnet cycle 3 times. If 3 times is not needed then the loop can be terminated at the end of a cycle
% for j = 1:3
% 
%     switch lower(answer)
% 
%         case {'bts31'}
% 
%             for i = 1:1
% 
%                 disp(' ');
%                 temp = ['Starting cycle ',num2str(i) ];
                disp(temp);
                disp('Setting the Dipole to 0:');

                bts31min = 0;

                setsp('PS-BA-3-1:CURRENT_SP',bts31min);

                for j = 1:5
                    pause(3)

                    bts31rdbk =getsp('PS-BA-3-1:CURRENT_MONITOR');
                    if abs(bts31min-bts31rdbk)<155
                        disp('I think I can.')
                        break;
                    else
                        continue;
                    end;

                    if j > 4
                        setsp('PS-BA-3-1:CURRENT_SP',bts31vals);

                        disp('I thought I could.')
                        error('TIME OUT - Adjust dipole manually.')
                    end;
                end;
                bts31rdbk =getsp('PS-BA-3-1:CURRENT_MONITOR');
                disp(bts31rdbk)


                disp('Setting magnets to max.')
                bts31max = 155;
                for j = 1:4
                    pause(3)

                    bts31rdbk =getsp('PS-BA-3-1:CURRENT_MONITOR');
                    setsp('PS-BA-3-1:CURRENT_SP',bts31max);

                    if abs(bts31max-bts31rdbk)<155
                        disp('I know I can.')
                        break;
                    else
                        continue;
                    end;

                    if j > 3
                        setsp('PS-BA-3-1:CURRENT_SP',bts31vals);
                        disp('I thought I could.')
                        error('TIME OUT - Adjust dipole manually.')

                        bts31rdbk =getsp('PS-BA-3-1:CURRENT_MONITOR');
                        disp(bts31rdbk)
                    end;
                end;
            end;
            pause(3)
            disp(' ')
            disp(bts31rdbk)
            disp('I knew I could!')

            disp(' ');
            disp('Check all set points, adjust and cycle again as needed');


        case {'bts32'}

            for i = 1:1

                disp(' ');
                temp = ['Starting cycle ',num2str(i) ];
                disp(temp);
                disp('Setting the Dipole to 0:');

                bts32min = 0;

                setsp('PS-BA-3-2:CURRENT_SP',bts32min);

                for j = 1:5
                    pause(3)

                    bts32rdbk =getsp('PS-BA-3-2:CURRENT_MONITOR');
                    if abs(bts32min-bts32rdbk)<155
                        disp('I think I can.')
                        break;
                    else
                        continue;
                    end;

                    if j > 4
                        setsp('PS-BA-3-2:CURRENT_SP',bts32vals);

                        disp('I thought I could.')
                        error('TIME OUT - Adjust dipole manually.')
                    end;
                end;
                bts32rdbk =getsp('PS-BA-3-2:CURRENT_MONITOR');
                disp(bts32rdbk)


                disp('Setting magnets to max.')
                bts32max = 155;
                
                for j = 1:4
                    pause(3)

                    bts32rdbk =getsp('PS-BA-3-2:CURRENT_MONITOR');
                    setsp('PS-BA-3-2:CURRENT_SP',bts32max);

                    if abs(bts32max-bts32rdbk)<155
                        disp('I know I can.')
                        break;
                    else
                        continue;
                    end;

                    if j > 3
                        setsp('PS-BA-3-2:CURRENT_SP',bts32vals);
                        disp('I thought I could.')
                        error('TIME OUT - Adjust dipole manually.')

                        bts32rdbk =getsp('PS-BA-3-2:CURRENT_MONITOR');
                        disp(bts32rdbk)
                    end;
                end;
            end;
            pause(3)
            disp(' ')
            disp(bts32rdbk)
            disp('I knew I could!')

            disp(' ');
            disp('Check all set points, adjust and cycle again as needed');

        case {'bts33'}

            for i = 1:1

                disp(' ');
                temp = ['Starting cycle ',num2str(i) ];
                disp(temp);
                disp('Setting the Dipole to 0:');

                bts33min = 0;

                setsp('PS-BA-3-3:CURRENT_SP',bts33min);

                for j = 1:5
                    pause(3)

                    bts33rdbk =getsp('PS-BA-3-3:CURRENT_MONITOR');
                    if abs(bts33min-bts33rdbk)<155
                        disp('I think I can.')
                        break;
                    else
                        continue;
                    end;

                    if j > 4
                        setsp('PS-BA-3-3:CURRENT_SP',bts33vals);

                        disp('I thought I could.')
                        error('TIME OUT - Adjust dipole manually.')
                    end;
                end;
                bts33rdbk =getsp('PS-BA-3-3:CURRENT_MONITOR');
                disp(bts33rdbk)


                disp('Setting magnets to max.')
                bts33max = 155;
                for j = 1:3
                    pause(3)

                    bts33rdbk =getsp('PS-BA-3-3:CURRENT_MONITOR');
                    setsp('PS-BA-3-3:CURRENT_SP',bts33max);

                    if abs(bts33max-bts33rdbk)<155
                        disp('I know I can.')
                        break;
                    else
                        continue;
                    end;

                    if j > 2
                        setsp('PS-BA-3-3:CURRENT_SP',bts33vals);
                        disp('I thought I could.')
                        error('TIME OUT - Adjust dipole manually.')

                        bts33rdbk =getsp('PS-BA-3-3:CURRENT_MONITOR');
                        disp(bts33rdbk)
                    end;
                end;
            end;
            pause(3)
            disp(' ')
            disp(bts33rdbk)
            disp('I knew I could!')

            disp(' ');
            disp('Check all set points, adjust and cycle again as needed');


        case {'bts34'}

            for i = 1:1

                disp(' ');
                temp = ['Starting cycle ',num2str(i) ];
                disp(temp);
                disp('Setting the Dipole to 0:');

                bts34min = 0;

                setsp('PS-BA-3-4:CURRENT_SP',bts34min);

                for j = 1:5
                    pause(3)

                    bts34rdbk =getsp('PS-BA-3-4:CURRENT_MONITOR');
                    if abs(bts34min-bts34rdbk)<155
                        disp('I think I can.')
                        break;
                    else
                        continue;
                    end;

                    if j > 4
                        setsp('PS-BA-3-4:CURRENT_SP',bts34vals);

                        disp('I thought I could.')
                        error('TIME OUT - Adjust dipole manually.')
                    end;
                end;
                bts34rdbk =getsp('PS-BA-3-4:CURRENT_MONITOR');
                disp(bts34rdbk)


                disp('Setting magnets to max.')
                bts34max = 155;
                for j = 1:4
                    pause(3)

                    bts34rdbk =getsp('PS-BA-3-4:CURRENT_MONITOR');
                    setsp('PS-BA-3-4:CURRENT_SP',bts34max);

                    if abs(bts34max-bts34rdbk)<155
                        disp('I know I can.')
                        break;
                    else
                        continue;
                    end;

                    if j > 3
                        setsp('PS-BA-3-4:CURRENT_SP',bts34vals);
                        disp('I thought I could.')
                        error('TIME OUT - Adjust dipole manually.')

                        bts34rdbk =getsp('PS-BA-3-4:CURRENT_MONITOR');
                        disp(bts34rdbk)
                    end;
                end;
            end;
            pause(3)
            disp(' ')
            disp(bts34rdbk)
            disp('I knew I could!')

            disp(' ');
            disp('Check all set pointsand adjust as needed')

        otherwise
            error('Magnet not found')
            return;

    end;
    disp(' ')
    disp(' ')
    disp('Would you like to cycle again?')
    ans = input('[y\\n]: ','s');

    if  ~strcmp(ans,'y')
        disp('Dipole cycling finished, goodbye.');
        return
    end;
end;
