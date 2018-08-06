% A more improved standardisation of the LTB dipoles and
%
% 19/1/07 Dipoles should not be cycled above 89 as they don't like it and
% will swtich themselves off after oscillating for 5-10 minutes. To stop
% them being cycled accidently using magcycle, magcycle has also been
% altered temporarily to not accept ltb as a valid argument
%
disp(' ');
disp('You are about to begin a LTB Cycle.');
disp('ARE YOU SURE THAT YOU WANT TO CONTINUE?? ');

answer = input('[y/n]: ','s');
if ~strcmp(answer,'y')
    disp('LTB not cycling.');
    return
end
for l = 1:3

    disp(' ');
    disp('Saving set points of dipoles.');
    ltbba11vals =getsp('PS-B-A-1-1:CURRENT_SP');
    ltbba12vals =getsp('PS-B-A-1-2:CURRENT_SP');
    ltbbb1vals =getsp('PS-B-B-1:CURRENT_SP');


    % disp(ltbba11vals)
    % disp(ltbba12vals)
    % disp(ltbbb1vals)

    %--------------------------------------------------------------------------
    %                           Dipole Cycle
    %--------------------------------------------------------------------------

    ltbba11rdbk =getsp('PS-B-A-1-1:CURRENT_MONITOR');
    ltbba12rdbk =getsp('PS-B-A-1-2:CURRENT_MONITOR');
    ltbbb1rdbk =getsp('PS-B-B-1:CURRENT_MONITOR');


    disp(' ');
    pause(1);

    disp('Do you want to cycle Dipoles?');
    answer = input('[y/n]: ','s');
    if ~strcmp(answer,'y')
        disp('Not cycling, goodbye.');
        return
    end


    % As requested you can now choose which Dipole you would like to cycle. The
    % choices are PS-B-A-1-1, PS-B-A-1-2 and PS-B-B-1. They are referrd to as
    % ba11, ba12 and bb1. After the requested dipole has been cycled, you have
    % the option of cycling all the quadrupoles as well. To cycle more then one
    % dipole you must restart the programme for each new Dipole.



    disp('Which dipole do you want to cycle?');
    answer = input('[ba11\\ba12\\bb1]: ','s');

    %This lets the magnet cycle 3 times. If 3 times is not needed then the loop can be terminated at the end of a cycle
%     for k = 1:3
% 
%         switch lower(answer)
% 
%             case {'ba11'}
% 
%                 for i = 1:1

                    disp(' ');
                    temp = ['Starting cycle ',num2str(i) ];
                    disp(temp);
                    disp('Setting the Dipole to 0:');

                    ltbba11min = 0;
                    setsp('PS-B-A-1-1:CURRENT_SP',ltbba11min);

                    % This sets the dipole to zero, if after 5 cycles it hasn't yet come within a certain error margin then it will terminate.
                    for j = 1:5
                        pause(2)

                        ltbba11rdbk =getsp('PS-B-A-1-1:CURRENT_MONITOR');
                        if abs((ltbba11min-ltbba11rdbk)<100)
                            disp('So far i am working!!')
                            break;
                        else
                            continue;
                        end;

                        if j > 4
                            setsp('PS-B-A-1-1:CURRENT_SP',ltbba11vals);
                            error('TIME OUT - Adjust dipoles manually.')
                        end;
                    end;

                    % Sets the dipole to max, works the same way as min. If you wish to change the max value then alter this.
                    disp('Setting Dipoles to max.')
                    ltbba11max = 89;
                    setsp('PS-B-A-1-1:CURRENT_SP',ltbba11max);

                    for j = 1:4
                        pause(3)
                        ltbba11rdbk =getsp('PS-B-A-1-1:CURRENT_MONITOR');
                        if abs((ltbba11min-ltbba11rdbk)<100)
                            disp('So far i am working!!')
                            break;
                        else
                            continue;
                        end;
                        if j > 3
                            setsp('PS-B-A-1-1:CURRENT_SP',ltbba11vals);
                            error('TIME OUT - Adjust dipoles manually.')
                        end;
                    end;

                    ltbba11rdbk =getsp('PS-B-A-1-1:CURRENT_MONITOR');
                    disp('PS-B-A-1-1 is currently set at:')
                    disp(ltbba11rdbk)

                end;

            case {'ba12'}
                for i = 1:1

                    disp(' ');
                    temp = ['Starting cycle ',num2str(i) ];
                    disp(temp);
                    disp('Setting the Dipole to 0:');

                    ltbba12min = 0;
                    setsp('PS-B-A-1-2:CURRENT_SP',ltbba12min);
                    for j = 1:5
                        pause(2)

                        ltbba12rdbk =getsp('PS-B-A-1-2:CURRENT_MONITOR');

                        if abs((ltbba12min-ltbba12rdbk)<100)
                            disp('this part works')
                            break;
                        else
                            continue;
                        end;

                        if j > 4
                            setsp('PS-B-A-1-2:CURRENT_SP',ltbba12vals);
                            error('TIME OUT - Adjust dipoles manually.')
                        end;
                    end;

                    disp('Setting Dipole to max.')

                    ltbba12max = 89;
                    setsp('PS-B-A-1-2:CURRENT_SP',ltbba12max);

                    for j = 1:4
                        pause(3)
                        ltbba11rdbk =getsp('PS-B-A-1-2:CURRENT_MONITOR');
                        if abs((ltbba12min-ltbba12rdbk)<100)
                            disp('So far i am working!!')
                            break;
                        else
                            continue;
                        end;
                        if j > 3
                            setsp('PS-B-A-1-2:CURRENT_SP',ltbba12vals);
                            error('TIME OUT - Adjust dipoles manually.')
                        end;
                    end;

                    ltbba12rdbk =getsp('PS-B-A-1-2:CURRENT_MONITOR');
                    disp('PS-B-A-1-2 is currently set at:')
                    disp(ltbba12rdbk)

                end;
            case {'bb1'}
                for i = 1:1

                    disp(' ');
                    temp = ['Starting cycle ',num2str(i) ];
                    disp(temp);
                    disp('Setting the Dipole to 0:');

                    ltbbb1min = 0;
                    setsp('PS-B-B-1:CURRENT_SP',ltbbb1min);
                    for j = 1:5
                        pause(2)

                        ltbbb1rdbk =getsp('PS-B-B-1:CURRENT_MONITOR');



                        if abs((ltbbb1min-ltbbb1rdbk)<100)
                            disp('This part works')
                            break;
                        else
                            continue;
                        end;

                        if j > 4
                            setsp('PS-B-B-1:CURRENT_SP',ltbbb1vals);
                            error('TIME OUT - Adjust dipoles manually.')
                        end;
                    end;
                end;

                disp('Setting Dipoles to max.')

                ltbbb1max = 89;
                setsp('PS-B-B-1:CURRENT_SP',ltbbb1max);
                for j = 1:3
                    pause(3)
                    ltbbb1rdbk =getsp('PS-B-B-1:CURRENT_MONITOR');
                    if abs((ltbbb1min-ltbbb1rdbk)<100)
                        disp('So far i am working!!')
                        break;
                    else
                    end;
                    if j > 2
                        setsp('PS-B-B-1:CURRENT_SP',ltbbb1vals);
                        error('TIME OUT - Adjust dipoles manually.')
                    end;
                end;

                ltbbb1rdbk =getsp('PS-B-B-1:CURRENT_MONITOR');
                disp('PS-B-B-1 is currently set at:')
                disp(ltbbb1rdbk)
            otherwise
                error('Magnets not found')
                return;
        end;

        disp('')
        disp('Check all set points and adjust as needed')
        disp(' ')
        disp(' ')
        disp('Would you like to cycle again?')
        ans = input('[y\\n]: ','s');

        if  ~strcmp(ans,'y')
            disp('Dipole cycling finished, goodbye.');
            return
        end;
    end;
end;