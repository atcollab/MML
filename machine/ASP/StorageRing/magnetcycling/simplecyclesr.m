% This cycles the quadrupole, sextupoles and dipole in the storage ring.
% It can be run as part of magcycle or by itself.
% Designed so that you can choose which magnets you want cycled. The two
% sections are Dipole and Quads/Sextupoles.



disp(' ');
disp('You are about to begin a Storage Ring Cycle.');
disp('ARE YOU SURE THAT YOU WANT TO CONTINUE?? ');

answer = input('[y/n]: ','s');
if ~strcmp(answer,'y')
    disp('Not performing Storage Ring cycle, goodbye.');
    return
end
for l = 1:3
    disp(' ');
    disp('Saving set points of all Storage Ring quads, sextupoles, and dipole.');
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

    % disp(qfavals)
    % disp(qdavals)
    % disp(qfbvals)
    % disp(sfavals)
    % disp(sfbvals)
    % disp(sdavals)
    % disp(sdbvals)
    % disp(dbmvals)

    qfardbk = getsp('QFA');
    qdardbk = getsp('QDA');
    qfbrdbk = getsp('QFB');
    sfardbk = getsp('SFA');
    sfbrdbk = getsp('SFB');
    sdardbk = getsp('SDA');
    sdbrdbk = getsp('SDB');
    dbmrdbk = getsp('SR00DPS01:CURRENT_SP');



    disp('What do you want to cycle');
    answer = input('[quadsexts//dipole]: ','s');
    switch lower(answer)

        case {'quadsexts'}

            %--------------------------------------------------------------------------
            %                           Quad and Sextupole Cycle
            %--------------------------------------------------------------------------
            disp('Which do you wish to cycle?');
            answer = input('[quads//sexts//all]: ','s');

            switch lower(answer)
                case {'all'}

                    fams = {'QFA','QDA','QFB','SFA','SDA','SFB','SDB'};
                    %
                    for i = 1:3

                        disp(' ');
                        temp = ['Starting Storage Ring cycle ',num2str(i) ];
                        disp(temp);
                        disp('Setting the following families to 0:');

                        qfamin = 0;
                        qdamin = 0;
                        qfbmin = 0;
                        sfamin = 0;
                        sfbmin = 0;
                        sdamin = 0;
                        sdbmin = 0;

                        minvals = {qfamin qdamin qfbmin sfamin sfbmin sdamin sdbmin};

                        setsp(fams,minvals);

                        for j = 1:5
                            pause(3)

                            qfardbk = getsp('QFA');
                            qdardbk = getsp('QDA');
                            qfbrdbk = getsp('QFB');
                            sfardbk = getsp('SFA');
                            sfbrdbk = getsp('SFB');
                            sdardbk = getsp('SDA');
                            sdbrdbk = getsp('SDB');

                            if ( ...
                                    abs(qfamin-qfardbk)<5 &...       % These should be set to ~5. Set high for testing
                                    abs(qdamin-qdardbk)<5 &...
                                    abs(qfbmin-qfbrdbk)<5 &...
                                    abs(sfamin-sfardbk)<5 &...
                                    abs(sdamin-sdardbk)<5 &...
                                    abs(sdbmin-sdbrdbk)<5 ...
                                    )

                                continue
                                disp(qfavals)
                                disp(qdavals)
                                disp(qfbvals)
                                disp(sfavals)
                                disp(sfbvals)
                                disp(sdavals)
                                disp(sdbvals)

                                setsp('QFA',qfavals,'hardware');
                                setsp('QFB',qfbvals,'hardware');
                                setsp('QDA',qdavals,'hardware');
                                setsp('SFA',sfavals,'hardware');
                                setsp('SFB',sfbvals,'hardware');
                                setsp('SDA',sdavals,'hardware');
                                setsp('SDB',sdbvals,'hardware');

                                return;
                            end;

                            if (abs(sfbmin-sfbrdbk)<200 )


                                continue
                                disp(qfavals)
                                disp(qdavals)
                                disp(qfbvals)
                                disp(sfavals)
                                disp(sfbvals)
                                disp(sdavals)
                                disp(sdbvals)

                                setsp('QFA',qfavals,'hardware');
                                setsp('QFB',qfbvals,'hardware');
                                setsp('QDA',qdavals,'hardware');
                                setsp('SFA',sfavals,'hardware');
                                setsp('SFB',sfbvals,'hardware');
                                setsp('SDA',sdavals,'hardware');
                                setsp('SDB',sdbvals,'hardware');

                                return;
                            end;
                            if j > 5

                                setsp('QFA',qfavals,'hardware');
                                setsp('QFB',qfbvals,'hardware');
                                setsp('QDA',qdavals,'hardware');
                                setsp('SFA',sfavals,'hardware');
                                setsp('SFB',sfbvals,'hardware');
                                setsp('SDA',sdavals,'hardware');
                                setsp('SDB',sdbvals,'hardware');
                                error('TIME OUT - Adjust Storage Ring dipole manually.')
                            end;
                        end;
                        disp('Setting Storage Ring magnets to max.')

                        qfamax = 160;
                        qfbmax = 90;
                        qdamax = 160;
                        sfamax = 90;
                        sfbmax = 90;
                        sdamax = 60;
                        sdbmax = 80;

                        maxvals = {qfamax qfbmax qdamax sfamax sfbmax sdamax sdbmax};
                        setsp(fams,maxvals);
                        for j = 1:5
                            pause(3)

                            qfardbk = getsp('QFA');
                            qdardbk = getsp('QDA');
                            qfbrdbk = getsp('QFB');
                            sfardbk = getsp('SFA');
                            sfbrdbk = getsp('SFB');
                            sdardbk = getsp('SDA');
                            sdbrdbk = getsp('SDB');

                            if ( ...
                                    abs(qfamax-qfardbk)<5 &...            % These should be set to ~5. Set high for testing
                                    abs(qdamax-qdardbk)<5 &...
                                    abs(qfbmax-qfbrdbk)<5 &...
                                    abs(sfamax-sfardbk)<5 &...
                                    abs(sdamax-sdardbk)<5 &...
                                    abs(sdbmax-sdbrdbk)<5 ...
                                    )

                                continue

                                disp(qfavals)
                                disp(qdavals)
                                disp(qfbvals)
                                disp(sfavals)
                                disp(sfbvals)
                                disp(sdavals)
                                disp(sdbvals)

                                setsp('QFA',qfavals,'hardware');
                                setsp('QFB',qfbvals,'hardware');
                                setsp('QDA',qdavals,'hardware');
                                setsp('SFA',sfavals,'hardware');
                                setsp('SFB',sfbvals,'hardware');
                                setsp('SDA',sdavals,'hardware');
                                setsp('SDB',sdbvals,'hardware');

                                return;
                            end;

                            if( abs(sfbmax-sfbrdbk)<5 )
                                continue

                                disp(qfavals)
                                disp(qdavals)
                                disp(qfbvals)
                                disp(sfavals)
                                disp(sfbvals)
                                disp(sdavals)
                                disp(sdbvals)

                                setsp('QFA',qfavals,'hardware');
                                setsp('QFB',qfbvals,'hardware');
                                setsp('QDA',qdavals,'hardware');
                                setsp('SFA',sfavals,'hardware');
                                setsp('SFB',sfbvals,'hardware');
                                setsp('SDA',sdavals,'hardware');
                                setsp('SDB',sdbvals,'hardware');

                                return;
                            end;
                            if j > 5

                                setsp('QFA',qfavals,'hardware');
                                setsp('QFB',qfbvals,'hardware');
                                setsp('QDA',qdavals,'hardware');
                                setsp('SFA',sfavals,'hardware');
                                setsp('SFB',sfbvals,'hardware');
                                setsp('SDA',sdavals,'hardware');
                                setsp('SDB',sdbvals,'hardware');
                                error('TIME OUT - Adjust Storage Ring dipole manually.')
                            end;
                        end;

                    end;

                    disp(' ');
                    disp('Cycling of the Storage Ring quad and sextupole families complete, now loading saved setpoints.');
                    setsp('QFA',qfavals,'hardware');
                    setsp('QFB',qfbvals,'hardware');
                    setsp('QDA',qdavals,'hardware');
                    setsp('SFA',sfavals,'hardware');
                    setsp('SFB',sfbvals,'hardware');
                    setsp('SDA',sdavals,'hardware');
                    setsp('SDB',sdbvals,'hardware');
                    pause(3);
                    disp(qfavals)
                    disp(qdavals)
                    disp(qfbvals)
                    disp(sfavals)
                    disp(sfbvals)
                    disp(sdavals)
                    disp(sdbvals)

                    disp(' ');
                    disp('Check all setpoints, adjust and cycle again as needed.');

                case {'quads'}

                    fams = {'QFA','QDA','QFB'};
                    %
                    for i = 1:3

                        disp(' ');
                        temp = ['Starting quadrupole cycle ',num2str(i) ];
                        disp(temp);
                        disp('Setting the following families to 0:');

                        qfamin = 0;
                        qdamin = 0;
                        qfbmin = 0;

                        minvals = {qfamin qdamin qfbmin};

                        setsp(fams,minvals);

                        for j = 1:5
                            pause(3)

                            qfardbk = getsp('QFA');
                            qdardbk = getsp('QDA');
                            qfbrdbk = getsp('QFB');


                            if ( ...
                                    abs(qfamin-qfardbk)<5 &...       % These should be set to ~5. Set high for testing
                                    abs(qdamin-qdardbk)<5 &...
                                    abs(qfbmin-qfbrdbk)<5 ...
                                    )


                                continue
                                disp(qfavals)
                                disp(qdavals)
                                disp(qfbvals)

                                setsp('QFA',qfavals,'hardware');
                                setsp('QFB',qfbvals,'hardware');
                                setsp('QDA',qdavals,'hardware');

                                return;
                            end;

                            if j > 5

                                setsp('QFA',qfavals,'hardware');
                                setsp('QFB',qfbvals,'hardware');
                                setsp('QDA',qdavals,'hardware');

                                error('TIME OUT - Adjust Storage Ring quads manually.')
                            end;
                        end;
                        disp('Setting Storage Ring quads to max.')

                        qfamax = 160;
                        qfbmax = 90;
                        qdamax = 160;

                        maxvals = {qfamax qfbmax qdamax};
                        setsp(fams,maxvals);
                        for j = 1:5
                            pause(3)

                            qfardbk = getsp('QFA');
                            qdardbk = getsp('QDA');
                            qfbrdbk = getsp('QFB');


                            if ( ...
                                    abs(qfamax-qfardbk)<5 &...            % These should be set to ~5. Set high for testing
                                    abs(qdamax-qdardbk)<5 &...
                                    abs(qfbmax-qfbrdbk)<5 ...
                                    )

                                continue

                                disp(qfavals)
                                disp(qdavals)
                                disp(qfbvals)


                                setsp('QFA',qfavals,'hardware');
                                setsp('QFB',qfbvals,'hardware');
                                setsp('QDA',qdavals,'hardware');

                                return;
                            end;


                            if j > 5

                                setsp('QFA',qfavals,'hardware');
                                setsp('QFB',qfbvals,'hardware');
                                setsp('QDA',qdavals,'hardware');

                                error('TIME OUT - Adjust Storage Ring quads manually.')
                            end;
                        end;
                    end;

                    disp(' ');
                    disp('Cycling of the Storage Ring quad families complete, now loading saved setpoints.');
                    setsp('QFA',qfavals,'hardware');
                    setsp('QFB',qfbvals,'hardware');
                    setsp('QDA',qdavals,'hardware');

                    pause(3);
                    disp(qfavals)
                    disp(qdavals)
                    disp(qfbvals)

                    disp(' ');
                    disp('Check all setpoints, adjust and cycle again as needed.');

                case {'sexts'}

                    fams = {'SFA','SDA','SFB','SDB'};
                    %
                    for i = 1:3

                        disp(' ');
                        temp = ['Starting sextupole cycle ',num2str(i) ];
                        disp(temp);
                        disp('Setting the following families to 0:');

                        sfamin = 0;
                        sfbmin = 0;
                        sdamin = 0;
                        sdbmin = 0;

                        minvals = {sfamin sfbmin sdamin sdbmin};

                        setsp(fams,minvals);

                        for j = 1:5
                            pause(3)

                            sfardbk = getsp('SFA');
                            sfbrdbk = getsp('SFB');
                            sdardbk = getsp('SDA');
                            sdbrdbk = getsp('SDB');

                            if ( ...
                                    abs(sfamin-sfardbk)<5 &...     % These should be set to ~5. Set high for testing
                                    abs(sdamin-sdardbk)<5 &...
                                    abs(sdbmin-sdbrdbk)<5 ...
                                    )

                                continue

                                disp(sfavals)
                                disp(sfbvals)
                                disp(sdavals)
                                disp(sdbvals)


                                setsp('SFA',sfavals,'hardware');
                                setsp('SFB',sfbvals,'hardware');
                                setsp('SDA',sdavals,'hardware');
                                setsp('SDB',sdbvals,'hardware');

                                return;
                            end;

                            if (abs(sfbmin-sfbrdbk)<200 )


                                continue

                                disp(sfavals)
                                disp(sfbvals)
                                disp(sdavals)
                                disp(sdbvals)

                                setsp('SFA',sfavals,'hardware');
                                setsp('SFB',sfbvals,'hardware');
                                setsp('SDA',sdavals,'hardware');
                                setsp('SDB',sdbvals,'hardware');

                                return;
                            end;
                            if j > 4

                                setsp('SFA',sfavals,'hardware');
                                setsp('SFB',sfbvals,'hardware');
                                setsp('SDA',sdavals,'hardware');
                                setsp('SDB',sdbvals,'hardware');
                                error('TIME OUT - Adjust Storage Ring sextupoles manually.')
                            end;
                        end;
                        disp('Setting Storage Ring sextupoles to max.')

                        sfamax = 90;
                        sfbmax = 90;
                        sdamax = 60;
                        sdbmax = 80;

                        maxvals = {sfamax sfbmax sdamax sdbmax};
                        setsp(fams,maxvals);
                        for j = 1:5
                            pause(3)

                            sfardbk = getsp('SFA');
                            sfbrdbk = getsp('SFB');
                            sdardbk = getsp('SDA');
                            sdbrdbk = getsp('SDB');

                            if ( ...
                                    abs(sfamax-sfardbk)<5 &...
                                    abs(sdamax-sdardbk)<5 &...
                                    abs(sdbmax-sdbrdbk)<5 ...      % These should be set to ~5. Set high for testing
                                    )

                                continue

                                disp(sfavals)
                                disp(sfbvals)
                                disp(sdavals)
                                disp(sdbvals)

                                setsp('SFA',sfavals,'hardware');
                                setsp('SFB',sfbvals,'hardware');
                                setsp('SDA',sdavals,'hardware');
                                setsp('SDB',sdbvals,'hardware');

                                return;
                            end;

                            if( abs(sfbmax-sfbrdbk)<5 )
                                continue

                                disp(sfavals)
                                disp(sfbvals)
                                disp(sdavals)
                                disp(sdbvals)

                                setsp('SFA',sfavals,'hardware');
                                setsp('SFB',sfbvals,'hardware');
                                setsp('SDA',sdavals,'hardware');
                                setsp('SDB',sdbvals,'hardware');

                                return;
                            end;
                            if j > 4
                                setsp('SFA',sfavals,'hardware');
                                setsp('SFB',sfbvals,'hardware');
                                setsp('SDA',sdavals,'hardware');
                                setsp('SDB',sdbvals,'hardware');
                                error('TIME OUT - Adjust Storage Ring sextupoles manually.')
                            end;
                        end;
                    end;

                    disp(' ');
                    disp('Cycling of the Storage Ring sextupole families complete, now loading saved setpoints.');

                    setsp('SFA',sfavals,'hardware');
                    setsp('SFB',sfbvals,'hardware');
                    setsp('SDA',sdavals,'hardware');
                    setsp('SDB',sdbvals,'hardware');
                    pause(3);

                    disp(sfavals)
                    disp(sfbvals)
                    disp(sdavals)
                    disp(sdbvals)

                    disp(' ');
                    disp('Check all setpoints, adjust and cycle again as needed.');
                otherwise
                    disp('Magnets not found.')
                    return;
            end;
        case {'dipole'}
            %-----------------------------------------------------------------------
            %                           Dipole cycle
            %-----------------------------------------------------------------------

            disp('Do you want to standardise the Storage Ring dipole?');
            answer = input('[y/n]: ','s');
            if ~strcmp(answer,'y')
                disp('Standardising Storage Ring complete, goodbye.');
                return
            end
            dps01rdbk = getsp('SR00DPS01:CURRENT_MONITOR');
            % Change this to i = 1:3 for 3 cycles
            for i = 1:3
                disp(' ');
                temp = ['Starting Storage Ring dipole cycle ',num2str(i) ];
                disp(temp);
                disp('Setting the Storage Ring dipole to 0:');
                dbmmin = 0;

                setsp('SR00DPS01:CURRENT_SP',dbmmin);
                for j = 1:5
                    pause(3)

                    dbmrdbk =getsp('SR00DPS01:CURRENT_MONITOR');

                    if abs(dbmmin-dbmrdbk)<.6              % This should be set to ~.6. Set high for testing
                        continue

                        disp(dbmrdbk)
                        setsp('SR00DSP01:CURRENT_SP',dbmvals);

                        return;
                    end;
                    if j > 4
                        setsp('PS-BA-3-1:CURRENT_SP',dbmvals);

                        error('TIME OUT - Adjust Storage Ring dipole manually.')
                    end;
                end;

                disp('Setting Storage Ring dipole to max.')

                pause(6);
                dbmmax = 660;

                setsp('SR00DPS01:CURRENT_SP',dbmmax);
                for j = 1:5
                    pause(3)

                    dbmrdbk =getsp('SR00DPS01:CURRENT_MONITOR');

                    if abs(dbmmax-dbmrdbk)<.6              % This should be set to ~.6. Set high for testing
                        continue

                        disp(dbmrdbk)
                        setsp('SR00DPS01:CURRENT_SP',dbmval);

                        return;
                    end;
                    if j > 4
                        setsp('SR00DPS01:CURRENT_SP',dbmval);

                        error('TIME OUT - Adjust Storage Ring dipole manually.')
                    end;
                end;



                disp(' ');
                disp('Standardising of the Storage Ring dipole complete, now loading saved setpoint.');
                setsp('SR00DPS01:CURRENT_SP',dbmval);
                pause(3);
                disp(' ');
                disp('Check the Storage Ring dipole went to its setpoint and adjust if required.');
            end;
        otherwise
            error('Magnets not found.')
            return
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