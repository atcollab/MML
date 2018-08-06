% A more improved standardisation of the LTB dipoles and Quadrupoles.

% 31/1/07 DO NOT RUN YET!!!!!

% 19/1/07 Dipoles should not be cycled above 89 as they don't like it and
% will swtich themselves off after oscillating for 5-10 minutes. To stop
% them being cycled accidently using magcycle, magcycle has also been
% altered temporarily to not accept ltb as a valid argument
%

% You get your choice of which magnets get cycled. The dipole section differs from
% dipoleltb in one way only. dipoleltb cycles the dipole separately while
% simplecycleltb cycles them altogether.

disp(' ');
disp('You are about to begin a LTB Cycle.');
disp('ARE YOU SURE THAT YOU WANT TO CONTINUE?? ');

answer = input('[y/n]: ','s');
if ~strcmp(answer,'y')
    disp('Not performing ltb cycle, goodbye.');
    return
end
for l = 1:3
    disp(' ');
    disp('Saving set points of all quads and dipoles.');
    ltbba11vals =getsp('PS-B-A-1-1:CURRENT_SP');
    ltbba12vals =getsp('PS-B-A-1-2:CURRENT_SP');
    ltbbb1vals =getsp('PS-B-B-1:CURRENT_SP');
    ltbq11vals =getsp('PS-Q-1-1:CURRENT_SP');
    ltbq12vals =getsp('PS-Q-1-2:CURRENT_SP');
    ltbq13vals =getsp('PS-Q-1-3:CURRENT_SP');
    ltbq14vals =getsp('PS-Q-1-4:CURRENT_SP');
    ltbq15vals =getsp('PS-Q-1-5:CURRENT_SP');
    ltbq16vals =getsp('PS-Q-1-6:CURRENT_SP');
    ltbq17vals =getsp('PS-Q-1-7:CURRENT_SP');
    ltbq18vals =getsp('PS-Q-1-8:CURRENT_SP');
    ltbq19vals =getsp('PS-Q-1-9:CURRENT_SP');
    ltbq110vals =getsp('PS-Q-1-10:CURRENT_SP');
    ltbq111vals =getsp('PS-Q-1-11:CURRENT_SP');

    % disp(ltbba11vals)
    % disp(ltbba12vals)
    % disp(ltbbb1vals)
    % disp(ltbq11vals)
    % disp(ltbq12vals)
    % disp(ltbq13vals)
    % disp(ltbq14vals)
    % disp(ltbq15vals)
    % disp(ltbq16vals)
    % disp(ltbq17vals)
    % disp(ltbq18vals)
    % disp(ltbq19vals)
    % disp(ltbq110vals)
    % disp(ltbq111vals)

    disp('What do you want to cycle?');
    answer = input('[dipoles//quadrupoles]: ','s');     % All inputs must be excatly as specified otherwise it will terminate.

%     switch lower(answer)
% 
%         case {'dipoles'}                                % This part cycles the Dipoles altogether.
%             %--------------------------------------------------------------------------
%             %                           Dipole Cycle
%             %--------------------------------------------------------------------------
% 
%             ltbba11rdbk =getsp('PS-B-A-1-1:CURRENT_MONITOR');
%             ltbba12rdbk =getsp('PS-B-A-1-2:CURRENT_MONITOR');
%             ltbbb1rdbk =getsp('PS-B-B-1:CURRENT_MONITOR');


            disp(' ');
            pause(1);

            disp('Do you want to cycle Dipoles?');
            answer = input('[y/n]: ','s');
            if ~strcmp(answer,'y')
                disp('Not cycling, goodbye.');
                return
            end;



            for i = 1:3

                disp(' ');
                temp = ['Starting cycle ',num2str(i) ];
                disp(temp);
                disp('Setting the Dipoles to 0:');

                ltbba11min = 0;
                ltbba12min = 0;
                ltbbb1min = 0;

                % All commented out setsp() commands are so that when testing, nothing can cycled by mistake.

                setsp('PS-B-A-1-1:CURRENT_SP',ltbba11min);
                setsp('PS-B-A-1-2:CURRENT_SP',ltbba12min);
                setsp('PS-B-B-1:CURRENT_SP',ltbbb1min);


                for j = 1:6
                    pause(2)

                    ltbba11rdbk =getsp('PS-B-A-1-1:CURRENT_MONITOR');
                    ltbba12rdbk =getsp('PS-B-A-1-2:CURRENT_MONITOR');
                    ltbbb1rdbk =getsp('PS-B-B-1:CURRENT_MONITOR');


                    if     (...
                            abs((ltbba11min-ltbba11rdbk)<.6) &&... % This should be set to ~.6. Set high for error checking
                            abs((ltbba12min-ltbba12rdbk)<.6) &&...
                            abs((ltbbb1min-ltbbb1rdbk)<.6) ...
                            )
                        break;
                    else
                        continue;

                    end;
                    if j > 5
                        setsp('PS-B-A-1-1:CURRENT_SP',ltbba11vals);
                        setsp('PS-B-A-1-2:CURRENT_SP',ltbba12vals);
                        setsp('PS-B-B-1:CURRENT_SP',ltbbb1vals);

                        error('TIME OUT - Adjust dipoles manually.')
                    end;
                end;

                ltbba11rdbk =getsp('PS-B-A-1-1:CURRENT_MONITOR');
                ltbba12rdbk =getsp('PS-B-A-1-2:CURRENT_MONITOR');
                ltbbb1rdbk =getsp('PS-B-B-1:CURRENT_MONITOR');

                disp(ltbba11rdbk)
                disp(ltbba12rdbk)
                disp(ltbbb1rdbk)

                disp('Setting Dipoles to max.')
                ltbba11max = 89;                    % This needs to be increased eventually so that the entire range can be covered
                ltbba12max = 89;
                ltbbb1max = 89;

                setsp('PS-B-A-1-1:CURRENT_SP',ltbba11max);
                setsp('PS-B-A-1-2:CURRENT_SP',ltbba12max);
                setsp('PS-B-B-1:CURRENT_SP',ltbbb1max);

                for j = 1:4
                    pause(3)
                    ltbba11rdbk =getsp('PS-B-A-1-1:CURRENT_MONITOR');
                    ltbba12rdbk =getsp('PS-B-A-1-2:CURRENT_MONITOR');
                    ltbbb1rdbk =getsp('PS-B-B-1:CURRENT_MONITOR');

                    if   (...
                            abs((ltbba11max-ltbba11rdbk)<.6) &&...  % This should be set to ~.6. Set high for error checking
                            abs((ltbba12max-ltbba12rdbk)<.6) &&...
                            abs((ltbbb1max-ltbbb1rdbk)<.6) ...
                            )
                        % If reached desired values
                        break;
                    else
                        % Has not reached values
                        continue;


                    end;
                    if j > 3
                        setsp('PS-B-A-1-1:CURRENT_SP',ltbba11vals);
                        setsp('PS-B-A-1-2:CURRENT_SP',ltbba12vals);
                        setsp('PS-B-B-1:CURRENT_SP',ltbbb1vals);
                        error('TIME OUT - Adjust dipoles manually.')
                    end;


                    ltbba11rdbk =getsp('PS-B-A-1-1:CURRENT_MONITOR');
                    ltbba12rdbk =getsp('PS-B-A-1-2:CURRENT_MONITOR');
                    ltbbb1rdbk =getsp('PS-B-B-1:CURRENT_MONITOR');

                    disp(ltbba11rdbk)
                    disp(ltbba12rdbk)
                    disp(ltbbb1rdbk)

                end;
            end;

            disp(' ');
            disp('Dipoles have finished cycling, now loading saved setpoints.');

            setsp('PS-B-A-1-1:CURRENT_SP',ltbba11vals);
            setsp('PS-B-A-1-2:CURRENT_SP',ltbba12vals);
            setsp('PS-B-B-1:CURRENT_SP',ltbbb1vals);
            pause(5);

            ltbba11rdbk =getsp('PS-B-A-1-1:CURRENT_MONITOR');
            ltbba12rdbk =getsp('PS-B-A-1-2:CURRENT_MONITOR');
            ltbbb1rdbk =getsp('PS-B-B-1:CURRENT_MONITOR');

            disp(ltbba11rdbk)
            disp(ltbba12rdbk)
            disp(ltbbb1rdbk)

            pause(3);
            disp(' ');
            disp('Check all setpoints, adjust and cycle again as needed')

        case {'quadrupoles'}

            %--------------------------------------------------------------------------
            %                   Quadrupole Cycle
            %--------------------------------------------------------------------------

            ltbq11rdbk =getsp('PS-Q-1-1:CURRENT_MONITOR');
            ltbq12rdbk =getsp('PS-Q-1-2:CURRENT_MONITOR');
            ltbq13rdbk =getsp('PS-Q-1-3:CURRENT_MONITOR');
            ltbq14rdbk =getsp('PS-Q-1-4:CURRENT_MONITOR');
            ltbq15rdbk =getsp('PS-Q-1-5:CURRENT_MONITOR');
            ltbq16rdbk =getsp('PS-Q-1-6:CURRENT_MONITOR');
            ltbq17rdbk =getsp('PS-Q-1-7:CURRENT_MONITOR');
            ltbq18rdbk =getsp('PS-Q-1-8:CURRENT_MONITOR');
            ltbq19rdbk =getsp('PS-Q-1-9:CURRENT_MONITOR');
            ltbq110rdbk =getsp('PS-Q-1-10:CURRENT_MONITOR');
            ltbq111rdbk =getsp('PS-Q-1-11:CURRENT_MONITOR');

            disp(' ');
            pause(1);

            disp('Do you want to cycle Quadrupoles?');
            answer = input('[y/n]: ','s');
            if ~strcmp(answer,'y')
                disp('Not cycling, goodbye.');
                return
            end
            for i = 1:3

                disp(' ');
                temp = ['Starting cycle ',num2str(i) ];
                disp(temp);
                disp('Setting the Quadrupoles to 0:');

                ltbq11min = 0;
                ltbq12min = 0;
                ltbq13min = 0;
                ltbq14min = 0;
                ltbq15min = 0;
                ltbq16min = 0;
                ltbq17min = 0;
                ltbq18min = 0;
                ltbq19min = 0;
                ltbq110min = 0;
                ltbq111min = 0;

                setsp('PS-Q-1-1:CURRENT_SP',ltbq11min);
                setsp('PS-Q-1-2:CURRENT_SP',ltbq12min);
                setsp('PS-Q-1-3:CURRENT_SP',ltbq13min);
                setsp('PS-Q-1-4:CURRENT_SP',ltbq14min);
                setsp('PS-Q-1-5:CURRENT_SP',ltbq15min);
                setsp('PS-Q-1-6:CURRENT_SP',ltbq16min);
                setsp('PS-Q-1-7:CURRENT_SP',ltbq17min);
                setsp('PS-Q-1-8:CURRENT_SP',ltbq18min);
                setsp('PS-Q-1-9:CURRENT_SP',ltbq19min);
                setsp('PS-Q-1-10:CURRENT_SP',ltbq110min);
                setsp('PS-Q-1-11:CURRENT_SP',ltbq111min);

                for j = 1:6
                    pause(2)

                    ltbq11rdbk =getsp('PS-Q-1-1:CURRENT_MONITOR');
                    ltbq12rdbk =getsp('PS-Q-1-2:CURRENT_MONITOR');
                    ltbq13rdbk =getsp('PS-Q-1-3:CURRENT_MONITOR');
                    ltbq14rdbk =getsp('PS-Q-1-4:CURRENT_MONITOR');
                    ltbq15rdbk =getsp('PS-Q-1-5:CURRENT_MONITOR');
                    ltbq16rdbk =getsp('PS-Q-1-6:CURRENT_MONITOR');
                    ltbq17rdbk =getsp('PS-Q-1-7:CURRENT_MONITOR');
                    ltbq18rdbk =getsp('PS-Q-1-8:CURRENT_MONITOR');
                    ltbq19rdbk =getsp('PS-Q-1-9:CURRENT_MONITOR');
                    ltbq110rdBk =getsp('PS-Q-1-10:CURRENT_MONITOR');
                    ltbq111rdbk =getsp('PS-Q-1-11:CURRENT_MONITOR');

                    if ( ...
                            abs(ltbq11min-ltbq11rdbk)<.6 &&...  % This should be set to ~.6. Set high for error checking
                            abs(ltbq12min-ltbq12rdbk)<.6 &&...
                            abs(ltbq13min-ltbq13rdbk)<.6 &&...
                            abs(ltbq14min-ltbq14rdbk)<.6 &&...
                            abs(ltbq15min-ltbq15rdbk)<.6 &&...
                            abs(ltbq16min-ltbq16rdbk)<.6 &&...
                            abs(ltbq17min-ltbq17rdbk)<.6 &&...
                            abs(ltbq18min-ltbq18rdbk)<.6 &&...
                            abs(ltbq19min-ltbq19rdbk)<.6 &&...
                            abs(ltbq110min-ltbq110rdbk)<.6 &&...
                            abs(ltbq111min-ltbq111rdbk)<.6 ...
                            )
                        break;
                    else
                        continue;

                    end;
                    if j > 5
                        setsp('PS-Q-1-1:CURRENT_SP',ltbq11vals);
                        setsp('PS-Q-1-2:CURRENT_SP',ltbq12vals);
                        setsp('PS-Q-1-3:CURRENT_SP',ltbq13vals);
                        setsp('PS-Q-1-4:CURRENT_SP',ltbq14vals);
                        setsp('PS-Q-1-5:CURRENT_SP',ltbq15vals);
                        setsp('PS-Q-1-6:CURRENT_SP',ltbq16vals);
                        setsp('PS-Q-1-7:CURRENT_SP',ltbq17vals);
                        setsp('PS-Q-1-8:CURRENT_SP',ltbq18vals);
                        setsp('PS-Q-1-9:CURRENT_SP',ltbq19vals);
                        setsp('PS-Q-1-10:CURRENT_SP',ltbq110vals);
                        setsp('PS-Q-1-11:CURRENT_SP',ltbq111vals);

                        error('TIME OUT - Adjust quadrupoles manually.')
                    end;
                end;

                ltbq11rdbk =getsp('PS-Q-1-1:CURRENT_MONITOR');
                ltbq12rdbk =getsp('PS-Q-1-2:CURRENT_MONITOR');
                ltbq13rdbk =getsp('PS-Q-1-3:CURRENT_MONITOR');
                ltbq14rdbk =getsp('PS-Q-1-4:CURRENT_MONITOR');
                ltbq15rdbk =getsp('PS-Q-1-5:CURRENT_MONITOR');
                ltbq16rdbk =getsp('PS-Q-1-6:CURRENT_MONITOR');
                ltbq17rdbk =getsp('PS-Q-1-7:CURRENT_MONITOR');
                ltbq18rdbk =getsp('PS-Q-1-8:CURRENT_MONITOR');
                ltbq19rdbk =getsp('PS-Q-1-9:CURRENT_MONITOR');
                ltbq110rdbk =getsp('PS-Q-1-10:CURRENT_MONITOR');
                ltbq111rdbk =getsp('PS-Q-1-11:CURRENT_MONITOR');

                %                 disp(ltbq11rdbk)
                %                 disp(ltbq12rdbk)
                %                 disp(ltbq13rdbk)
                %                 disp(ltbq14rdbk)
                %                 disp(ltbq15rdbk)
                %                 disp(ltbq16rdbk)
                %                 disp(ltbq17rdbk)
                %                 disp(ltbq18rdbk)
                %                 disp(ltbq19rdbk)
                %                 disp(ltbq110rdbk)
                %                 disp(ltbq111rdbk)

                disp('Setting Quadrupoles to max.')
                ltbq11max = 13.5;
                ltbq12max = 13.5;
                ltbq14max = 13.5;
                ltbq15max = 13.5;
                ltbq16max = 13.5;
                ltbq17max = 13.5;
                ltbq18max = 13.5;
                ltbq19max = 13.5;
                ltbq110max = 13.5;
                ltbq13max = 13.5;
                ltbq111max = 13.5;

                setsp('PS-Q-1-1:CURRENT_SP',ltbq11max);
                setsp('PS-Q-1-2:CURRENT_SP',ltbq12max);
                setsp('PS-Q-1-3:CURRENT_SP',ltbq13max);
                setsp('PS-Q-1-4:CURRENT_SP',ltbq14max);
                setsp('PS-Q-1-5:CURRENT_SP',ltbq15max);
                setsp('PS-Q-1-6:CURRENT_SP',ltbq16max);
                setsp('PS-Q-1-7:CURRENT_SP',ltbq17max);
                setsp('PS-Q-1-8:CURRENT_SP',ltbq18max);
                setsp('PS-Q-1-9:CURRENT_SP',ltbq19max);
                setsp('PS-Q-1-10:CURRENT_SP',ltbq110max);
                setsp('PS-Q-1-11:CURRENT_SP',ltbq111max);


                for j = 1:4
                    pause(4);

                    ltbq11rdbk =getsp('PS-Q-1-1:CURRENT_MONITOR');
                    ltbq12rdbk =getsp('PS-Q-1-2:CURRENT_MONITOR');
                    ltbq13rdbk =getsp('PS-Q-1-3:CURRENT_MONITOR');
                    ltbq14rdbk =getsp('PS-Q-1-4:CURRENT_MONITOR');
                    ltbq15rdbk =getsp('PS-Q-1-5:CURRENT_MONITOR');
                    ltbq16rdbk =getsp('PS-Q-1-6:CURRENT_MONITOR');
                    ltbq17rdbk =getsp('PS-Q-1-7:CURRENT_MONITOR');
                    ltbq18rdbk =getsp('PS-Q-1-8:CURRENT_MONITOR');
                    ltbq19rdbk =getsp('PS-Q-1-9:CURRENT_MONITOR');
                    ltbq110rdbk =getsp('PS-Q-1-10:CURRENT_MONITOR');
                    ltbq111rdbk =getsp('PS-Q-1-11:CURRENT_MONITOR');

                    if ( ...
                            abs(ltbq11max-ltbq11rdbk)<.6 &&... % This should be set to ~.6. Set high for error checking
                            abs(ltbq12max-ltbq12rdbk)<.6 &&...
                            abs(ltbq13max-ltbq13rdbk)<.6 &&...
                            abs(ltbq14max-ltbq14rdbk)<.6 &&...
                            abs(ltbq15max-ltbq15rdbk)<.6 &&...
                            abs(ltbq16max-ltbq16rdbk)<.6 &&...
                            abs(ltbq17max-ltbq17rdbk)<.6 &&...
                            abs(ltbq18max-ltbq18rdbk)<.6 &&...
                            abs(ltbq19max-ltbq19rdbk)<.6 &&...
                            abs(ltbq110max-ltbq110rdbk)<.6 &&...
                            abs(ltbq111max-ltbq111rdbk)<.6 ...
                            )
                        break;
                    else
                        continue;
                    end;
                    if j > 3
                        setsp('PS-Q-1-1:CURRENT_SP',ltbq11vals);
                        setsp('PS-Q-1-2:CURRENT_SP',ltbq12vals);
                        setsp('PS-Q-1-3:CURRENT_SP',ltbq13vals);
                        setsp('PS-Q-1-4:CURRENT_SP',ltbq14vals);
                        setsp('PS-Q-1-5:CURRENT_SP',ltbq15vals);
                        setsp('PS-Q-1-6:CURRENT_SP',ltbq16vals);
                        setsp('PS-Q-1-7:CURRENT_SP',ltbq17vals);
                        setsp('PS-Q-1-8:CURRENT_SP',ltbq18vals);
                        setsp('PS-Q-1-9:CURRENT_SP',ltbq19vals);
                        setsp('PS-Q-1-10:CURRENT_SP',ltbq110vals);
                        setsp('PS-Q-1-11:CURRENT_SP',ltbq111vals);

                        error('TIME OUT - Adjust quadrupoles manually.')
                    end;
                end;

                ltbq11rdbk =getsp('PS-Q-1-1:CURRENT_MONITOR');
                ltbq12rdbk =getsp('PS-Q-1-2:CURRENT_MONITOR');
                ltbq13rdbk =getsp('PS-Q-1-3:CURRENT_MONITOR');
                ltbq14rdbk =getsp('PS-Q-1-4:CURRENT_MONITOR');
                ltbq15rdbk =getsp('PS-Q-1-5:CURRENT_MONITOR');
                ltbq16rdbk =getsp('PS-Q-1-6:CURRENT_MONITOR');
                ltbq17rdbk =getsp('PS-Q-1-7:CURRENT_MONITOR');
                ltbq18rdbk =getsp('PS-Q-1-8:CURRENT_MONITOR');
                ltbq19rdbk =getsp('PS-Q-1-9:CURRENT_MONITOR');
                ltbq110rdbk =getsp('PS-Q-1-10:CURRENT_MONITOR');
                ltbq111rdbk =getsp('PS-Q-1-11:CURRENT_MONITOR');

                disp(ltbq11rdbk)
                disp(ltbq12rdbk)
                disp(ltbq13rdbk)
                disp(ltbq14rdbk)
                disp(ltbq15rdbk)
                disp(ltbq16rdbk)
                disp(ltbq17rdbk)
                disp(ltbq18rdbk)
                disp(ltbq19rdbk)
                disp(ltbq110rdbk)
                disp(ltbq111rdbk)
            end

            disp(' ');
            disp('Quadrupoles have finished cycling, now loading saved setpoints.');
            setsp('PS-Q-1-1:CURRENT_SP',ltbq11vals);
            setsp('PS-Q-1-2:CURRENT_SP',ltbq12vals);
            setsp('PS-Q-1-3:CURRENT_SP',ltbq13vals);
            setsp('PS-Q-1-4:CURRENT_SP',ltbq14vals);
            setsp('PS-Q-1-5:CURRENT_SP',ltbq15vals);
            setsp('PS-Q-1-6:CURRENT_SP',ltbq16vals);
            setsp('PS-Q-1-7:CURRENT_SP',ltbq17vals);
            setsp('PS-Q-1-8:CURRENT_SP',ltbq18vals);
            setsp('PS-Q-1-9:CURRENT_SP',ltbq19vals);
            setsp('PS-Q-1-10:CURRENT_SP',ltbq110vals);
            setsp('PS-Q-1-11:CURRENT_SP',ltbq111vals);

            pause(5);
            ltbq11rdbk =getsp('PS-Q-1-1:CURRENT_MONITOR');
            ltbq12rdbk =getsp('PS-Q-1-2:CURRENT_MONITOR');
            ltbq13rdbk =getsp('PS-Q-1-3:CURRENT_MONITOR');
            ltbq14rdbk =getsp('PS-Q-1-4:CURRENT_MONITOR');
            ltbq15rdbk =getsp('PS-Q-1-5:CURRENT_MONITOR');
            ltbq16rdbk =getsp('PS-Q-1-6:CURRENT_MONITOR');
            ltbq17rdbk =getsp('PS-Q-1-7:CURRENT_MONITOR');
            ltbq18rdbk =getsp('PS-Q-1-8:CURRENT_MONITOR');
            ltbq19rdbk =getsp('PS-Q-1-9:CURRENT_MONITOR');
            ltbq110rdbk =getsp('PS-Q-1-10:CURRENT_MONITOR');
            ltbq111rdbk =getsp('PS-Q-1-11:CURRENT_MONITOR');

            %             disp(ltbq11rdbk)
            %             disp(ltbq12rdbk)
            %             disp(ltbq13rdbk)
            %             disp(ltbq14rdbk)
            %             disp(ltbq15rdbk)
            %             disp(ltbq16rdbk)
            %             disp(ltbq17rdbk)
            %             disp(ltbq18rdbk)
            %             disp(ltbq19rdbk)
            %             disp(ltbq110rdbk)
            %             disp(ltbq111rdbk)

            pause(3);
            disp(' ');
            disp('Check all setpoints, adjust and cycle again as needed.');
        otherwise
            error('Magnets not found')
            return;
    end;
    disp(' ')
    disp(' ')
    disp('Would you like to cycle something else?')
    ans = input('[y\\n]: ','s');

    if  ~strcmp(ans,'y')
        disp('Cycling finished.');
        disp('Bye Bye')
        return;
    end;
end;