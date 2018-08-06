function SF_current_loop
% This function maintains the current output of the SF supply (since the control hardware is bypassed)

% June 9, 2010  C.Steier and T.Scarvie

% scale = -1/3.8/10; %-3.8 is the slope of the voltage-to-current vectors below; 10 basically sets the speed of the loop response
scale = -1/3.8/10*10/400; %-3.8 is the slope of the voltage-to-current vectors below; 10 basically sets the speed of the loop response
% offset = 378;

% SFspv=[200 190 180 170 160 150 140 130 120 115 108.5];
% SFamv=[70.8 108.6 146 182 217 252 286 317 345 358 372];

%output scaling seems to have changed 2020-06-22 but supply is still kinda broken, so maybe it will go back to previous when fixed
%SFspv_20100622=[280 270 260 250 240 230 220 210 200 190 180 170 160 150 140 130 120 110 100 90  80  70];
%SFamv_20100622=[0   0   3   5   12  16  26  39  62  91  118 144 171 196 221 245 270 295 320 345 370 395];

SFam(1) = getpv('SR01C___SF_____AM00');
SFam(2) = getpv('SRSF_Mag_I_MonA');
SFam(3) = getpv('SRSF_Mag_I_MonB');

SFamold = SFam;

% Change setpoint (Physics1) to match monitor when starting loop if difference is >10A
if abs(getpv('SRSF_Mag_I_MonA')-getpv('SF','Setpoint'))>10
    setpv('SF',getpv('SRSF_Mag_I_MonA'));
else
    % Don't change the setpoint (Physics1)
end

% Change ramprate if it is too slow, since otherwise loop could become unstable
% if (getpv('SF','RampRate')<0.9) | (getpv('SF','RampRate')>1.5)
%     warning('Found SF ramprate outside of normal range, resetting it to 1 A/s in DAC units, which equals about 3.8 A/s on the power supply');
%     setpv('SF','RampRate',1);
% else
%     % No need to do anything
% end

while 1
    SFam(1) = getpv('SR01C___SF_____AM00');
    SFam(2) = getpv('SRSF_Mag_I_MonA');
    SFam(3) = getpv('SRSF_Mag_I_MonB');
    
%    SFsp = getpv('SR01C___SF_____AC00');
    SFsp = getpv('SR01C___SF_____AC12');
    SFsp2 = getpv('Physics1');
    if (SFsp2>378)
        warning('Requested current larger 378 A - clamping request to 378 A');
        SFsp2=378;
    end
    
    if SFam(2) < 200
        deltaSFsp = (SFsp2 - SFam(1)) * scale;
    else
        deltaSFsp = (SFsp2 - mean([SFam(2) SFam(3)])) * scale;
    end

    if deltaSFsp>(1.0*10/400)
        deltaSFsp=(1.0*10/400);
    elseif deltaSFsp<(-1.0*10/400)
        deltaSFsp=(-1.0*10/400);
    end
    
    fprintf('SF current loop: AM1 = %g AM2= %g AM3 = %g SP = %g Actuator = %g deltaSP = %g\n',SFam(1),SFam(2),SFam(3), SFsp2, SFsp, deltaSFsp);
    
    if any((SFam-SFamold)>50)
%         setpv('SF','RampRate',1000);
%         setpv('SR01C___SF_____AC00',378);
%         pause(1);
%         setpv('SR01C___SF_____AC10',378);
%         pause(1);
%         setpv('SF','RampRate',1);
         setpv('SR01C___SF_____AC12',7.5);
         setpv('SR01C___SF_____AC12.OVAL',7.5);
        error('Power supply might have tripped off ... exiting');      
    end

        SFamold = SFam;

%     if ((SFsp + deltaSFsp)<380) && ((SFsp + deltaSFsp)>100)
%         setpv('SR01C___SF_____AC00', SFsp + deltaSFsp);
%     else
%         warning('Setpoint outside of range, skipping setting it');
%     end

    if ((SFsp + deltaSFsp)<=7.5) && ((SFsp + deltaSFsp)>=2.5)
        setpv('SR01C___SF_____AC12', SFsp + deltaSFsp);
    else
        warning('Setpoint outside of range, skipping setting it');
    end
    
    pause(1.5);
end
