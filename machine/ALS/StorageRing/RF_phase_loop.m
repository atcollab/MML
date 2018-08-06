function RF_phase_loop
% This function maintains the beam phase at the hardcoded value, if there is beam present
% goal phase is -130 degrees on SR03S___RFPHASAAM00, for beam currents above 20 mA. The loop runs at 2 Hz
% and the step response time should be about 10 seconds.
%
% This hopefully avoids the problems due to phase drifts we have seen the last two hot days.

% June 9, 2010  C.Steier and T.Scarvie
% Updated 9-22-10 to not react if AM PV is stale, since that problem happened during a CMM reboot and drove the phase to a bad value, causing loss of LFB lock
scale = 1/12/10; % empricially measured slope is about 12 degrees per volt on phase shifter (however, response is not linear)
% second factor of 10 is to include averaging and reduce noise and lengthen time response of loop
%goal=105; % goal for the phase
goal=-130; % goal for the phase changed mid-August 2011 (cabling, splitters changed by G.Portmann)

RFam = getpv('SR03S___RFPHASAAM00');
RFamold = RFam;

disp('Starting RF phase loop...');

pause(3); % leave time for AM to change so loop will work from first iteration

RFamold_loop = getpv('SR03S___RFPHASAAM00');

while 1
    
    if getdcct>20  % only run this loop is beam is present, otherwise phase measurement is poor.
        
        if abs(RFam-RFamold_loop)>0.0000001 % make sure AM value is not stale so phase doesn't get driven to bad value
            
            RFam = getpv('SR03S___RFPHASAAM00');
            RFsp = getpv('SR03S___RFPHLP_AC03');
            
            deltaRFsp = (goal-RFam) * scale;
            
            if deltaRFsp>(0.1)
                deltaRFsp=(0.1);
            elseif deltaRFsp<(-0.1)
                deltaRFsp=(-0.1);
            end
            
            fprintf('RF phase loop: AM = %g SP = %g Actuator = %g deltaSP = %g\n',RFam, goal, RFsp, deltaRFsp);
            
            if any((RFam-RFamold)>10)
                soundtada
                msgbox('The RF phase just took a big jump (>10 degrees), you might want to investigate - the loop is still running');
            end
            
            RFamold = RFam;
            
            if ((RFsp + deltaRFsp)<=9.5) && ((RFsp + deltaRFsp)>=0.5)
                setpv('SR03S___RFPHLP_AC03', RFsp + deltaRFsp);
            else
                warning('Setpoint outside of range, skipping setting it');
            end
            
        else
            disp('RF phase AM channel did not change - no correction made');
        end
        
    else
        disp('RF phase loop: paused due to low beam current (<20 mA)');
    end
    
    pause(0.5);
    
    RFamold_loop = getpv('SR03S___RFPHASAAM00');
    
end