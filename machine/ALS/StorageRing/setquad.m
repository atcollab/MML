function setquad(QMS, QuadSetpoint, WaitFlag, ModeFlag)
%  setquad(QMS, QuadSetpoint, WaitFlag, ModeFlag)
%  Used by quadcenter
%
%  See also getquad


if nargin < 2
    error('At least 2 inputs required');
end
if nargin < 3
    WaitFlag = -2;
end


QuadFamily = QMS.QuadFamily;
QuadDev = QMS.QuadDev;


if nargin < 4
    ModeFlag = getfamilydata(QuadFamily, 'Setpoint', 'Mode', QuadDev);
end

if any(strcmpi(ModeFlag, {'Simulator', 'Model'}))
    
    % Set the quadrupole
    %Tune0 = gettune('Model');
        
    setsp(QuadFamily, QuadSetpoint, QuadDev, 0, 'Simulator');
        
    %Tune1 = gettune('Model');
    %fprintf('\n   Tune0 = %f/%f   Tune1 = %f/%f  DiffTune = %f/%f\n\n', Tune0, Tune1, Tune1-Tune0);

else
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Set the quadrupole %
    %%%%%%%%%%%%%%%%%%%%%%
    fprintf('   Setting quad %s(%d,%d)  (%s)\n', QuadFamily, QuadDev, datestr(now,'yyyy-mm-dd HH:MM:SS.FFF')); drawnow;

    if strcmpi(QuadFamily,'QFA')
        
        % QFA Shunt
        if QuadSetpoint == 0
            setqfashunt(1, 0, QuadDev, 0);
            setqfashunt(2, 0, QuadDev, WaitFlag);
            setqfashunt(1, 0, QuadDev, WaitFlag);
        elseif QuadSetpoint == 1
            setqfashunt(1, 1, QuadDev, 0);
            setqfashunt(2, 0, QuadDev, WaitFlag);
            setqfashunt(1, 1, QuadDev, WaitFlag);
        elseif QuadSetpoint == 2
            setqfashunt(1, 1, QuadDev, 0);
            setqfashunt(2, 1, QuadDev, WaitFlag);
            setqfashunt(1, 1, QuadDev, WaitFlag);
        end
        
        %setqfashunt(1, QuadSetpoint, QuadDev, 0);
        %setqfashunt(2, QuadSetpoint, QuadDev, WaitFlag);
        %setqfashunt(1, QuadSetpoint, QuadDev, WaitFlag);
        %setpv(QuadFamily, 'Shunt1Control', QuadSetpoint, QuadDev, WaitFlag);
        %setpv(QuadFamily, 'Shunt2Control', QuadSetpoint, QuadDev, WaitFlag);

    else
        if 0
            % Ramp just like SR ramping does
            MinPeriod = 0.2037;
            SP = getsp(QuadFamily, QuadDev);
            Delta = (QuadSetpoint - SP);

            N = fix(Delta * 554 / 19);

            if N > 1
                Delta = Delta / N;

                for i = 1:N
                    t0 = gettime;

                    stepsp(QuadFamily, Delta, QuadDev, 0);

                    % Delay for magnet ramping
                    WaitTime = MinPeriod - (gettime-t0);
                    if WaitTime < .025
                        WaitTime = .025;  % Minimum sleep after sets
                    end
                    pause(WaitTime);
                end

                %SPend = getsp(QuadFamily, QuadDev);
            end

            setsp(QuadFamily, QuadSetpoint, QuadDev, WaitFlag);

        else
            % Set the quad ramprate

            %pause(3);
            %Tune0 = gettune;
            
            
            RampRateStart = getpv(QuadFamily, 'RampRate', QuadDev);
            if WaitFlag == -2
                setpv(QuadFamily, 'RampRate', .2, QuadDev, 0);
                pause(.1);  % No good reason
            elseif WaitFlag == -1
                setpv(QuadFamily, 'RampRate', .2, QuadDev, 0);
                pause(.1);  % No good reason
            end
            
            setsp(QuadFamily, QuadSetpoint, QuadDev, WaitFlag);
            
            
            % Restore the quad ramprate
            %if WaitFlag == -2
            setpv(QuadFamily, 'RampRate', RampRateStart, QuadDev, 0);
            %end
        end
    end

    if WaitFlag == -2
        % Add an extra delay for eddy current settling (not power supply SP-AM matching)
        %SP = getpv(QuadFamily, 'Setpoint', QuadDev)
        %AM1 = getpv(QuadFamily, 'Monitor', QuadDev)
        pause(3);  % Was 3 seconds
        %AM2 = getpv(QuadFamily, 'Monitor', QuadDev)
    end

    %pause(3);
    %Tune1 = gettune;
    %fprintf('\n   Tune0 = %f/%f   Tune1 = %f/%f  DiffTune = %f/%f\n\n', Tune0, Tune1, Tune1-Tune0);

end
