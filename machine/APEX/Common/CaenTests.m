%% Inputs

clear

% Caen.Model        = 'A3620';    % 'A3605' 'A3610' 'A3620'  'A3630'
% Caen.SN           = 26;         % 26 & 27 for 20A  IP 131.243.89.60
% Caen.Name         = 'LTB:B3';
% Caen.MaxCurrent   = 20;         % Maximum current

Caen.Model        = 'A3605';     % 'A3605' 'A3610' 'A3620'  'A3630'
Caen.SN           = 38;          %  36 37 38 39       IP 47 48 49 56
Caen.Name         = 'LTB:VCM3';  % 
Caen.MaxCurrent   = 5;           % Maximum current
Caen.SlewRate     = 40;

% Caen.Model        = 'A3605';    % 'A3605' 'A3610' 'A3620'  'A3630'
% Caen.SN           = 61;
% Caen.Name         = 'LTB:VCM7';
% Caen.MaxCurrent   = 5;          % Maximum current


% Caen.Model        = 'A3605';    % 'A3605' 'A3610' 'A3620'  'A3630'
% 
% if 1
%     Caen.SN           = 51;  % 49 51
%     Caen.Name         = 'GTL:BC2';
%     Caen.MaxCurrent   = 1.5;          % Maximum current
%     Caen.Kp = .0316073;
%     Caen.Ki = .000699928;
%     Caen.SlewRate     = 20;
% else
%     Caen.SN           = 64;  % 62 64
%     Caen.Name         = 'GTL:VCM1';
%     Caen.MaxCurrent   = 4.;          % Maximum current
%     Kp = 0.0567354;
%     Ki = 0.000140245;
%     Caen.SlewRate     = 20;
% end


% This is a moving target
Caen.DanTurns = 15;



%% Major initalization
Caen = setcaen(Caen, 'Init');
pause(3);



%% Step response

Caen.Amp = .8;  % 1.0;
setcaen(Caen, 'Step Response', 'Iterations', 1, 'Delay', 0);
pause(1);


%% RMS

Caen.Amp = 0.0;
setcaen(Caen, 'RMS', 'Iterations', 10, 'Delay', 0, 'Figure', 40);
%pause(1);


%% RMSs

FigNum = 10;
for a =  5:-2.5:-5
    fprintf('   RMS at %f amps\n', a);
    Caen.Amp = a;
    FigNum = FigNum + 10;
    setcaen(Caen, 'RMS', 'Iterations', 10, 'Delay', 0, 'FigNum', FigNum);
    %pause(1);
end



%% Long term RMS, etc.

Caen.Amp = 0;  % Must be zero for DC-coupled ztec scope
%setcaen(Caen, 'Drift', 'Iterations', 3*4320, 'Delay', 20); % 4320, 20 sec is 24 hours  
%setcaen(Caen, 'Drift', 'Iterations', 4320, 'Delay', 20);   % 4320, 20 sec is 24 hours  
%setcaen(Caen, 'Drift', 'Iterations', 2160, 'Delay', 20);   % 2160, 20 sec is 12 hours
%setcaen(Caen, 'Drift', 'Iterations',  720, 'Delay', 10);   %  720, 10 sec is  4 hour
 setcaen(Caen, 'Drift', 'Iterations',  360, 'Delay', 10);   %  360, 10 sec is  2 hour

%setcaen(Caen, 'Drift', 'Iterations',  20, 'Delay', 5);     % Testing



%%

setcaen(Caen, 'Off');
return



%% Sine

Caen.Amp = .05;
setcaen(Caen, 'Sine');

%%

% CaenA3605_SN041_-3p5A_Set1.mat      
% CaenA3605_SN041_-5p0A_Set1.mat      
% CaenA3605_SN041_0p0A_Set1.mat       
% CaenA3605_SN041_2p5A_Set1.mat       
% CaenA3605_SN041_5p0A_Set1.mat       
% CaenA3605_SN041_DriftTest_Set1.mat  
% CaenA3605_SN041_Step_Set2.mat

setcaen('Plot', 'FileName', 'CaenA3605_SN041_DriftTest_Set1', 'Figure',1001);
%setcaen('Plot', 'FileName', 'CaenA3605_SN047_DriftTest_Set1', 'Figure',1001);
%setcaen('Plot', 'FileName', 'CaenA3605_SN054_DriftTest_Set1', 'Figure',1001);
%setcaen('Plot', 'FileName', 'CaenA3620_SN026_DriftTest_Set1', 'Figure',1001);

setcaen('Plot', 'FileName', 'CaenA3605_SN041_0p0A_Set1', 'Figure',1011);
setcaen('Plot', 'FileName', 'CaenA3605_SN041_2p5A_Set1', 'Figure',1021);




%%
%setcaen('Plot', 'FileName', 'CaenA3610_SN050_0p0A_Set1', 'Figure',101);
setcaen('Plot', 'FileName', 'CaenA3610_SN050_0p0A_Set2', 'Figure',101);

setcaen('Plot', 'FileName', 'CaenA3610_SN050_2p5A_Set2', 'Figure',103);



%%
setcaen('Plot', 'FileName', 'CaenA36XX_SN049_0p0A_Set2', 'Figure',101);


%%
setcaen('Plot', 'FileName', 'CaenA3610_SN036_0A_Set1', 'Figure',102);
%setcaen('Plot', 'FileName', 'CaenA3610_SN035_0A_25k_Set1', 'Figure',104);


%% Step
setcaen('Plot', 'FileName', 'CaenA36XX_SN049_Step_Set1', 'Figure',102);


%% Step - This magnet is going faster than the rest
setcaen('Plot', 'FileName', 'CaenA36XX_SN062_Step_Set1', 'Figure',200);


%%
%setcaen('Plot', 'FileName', 'CaenA36XX_SN050_DriftTest_0A', 'Figure',104);


% This file has a large temperature shift during the startup shift on Oct 23, 2012
setcaen('Plot', 'FileName', 'CaenA36XX_SN051_DriftTest_0A_Set1', 'Figure',104);



%%
setcaen('Plot', 'FileName', 'CaenA3610_SN035_Sine100_Set1', 'Figure',104);


%%
setcaen('Plot', 'FileName', 'CaenA3610_SN035_Sine200_Set1', 'Figure',104);




%% Scope bit resolution

%load CaenA3610_SN050_0A_Set1

figure(1);
plot(Caen.Scope.t,Caen.Scope.Inp1.Data(1,:)-Caen.Scope.Inp1.Data(1,1))

figure(2);
hist(Caen.Scope.Inp1.Data(1,:)-Caen.Scope.Inp1.Data(1,1), 2^16);



%%
% clear
% %load(.\Old\'CaenA3610_SN027_0A_Filter');
% load 'CaenA3610_SN027_0A
% Caen.Data = Ztec;Caen_A3605_61_3p0Amps_Range10p0_p25Hz_Set1
% Caen.Name = sprintf('CAENA36XX:%d', 1);
% Caen.Command = 'RMS0';
% setcaen(Caen, 'Plot');

% %% Step
% sys = tf([1],[.10 1])
% %step(sys);
% [a,t]=step(sys,0:.001:.6);
% plot(t,a)
% plot(diff(a)./diff(t))


%% Step 
% setpv('CAENA36XX:1:Setpoint',10);
% [a,t]=getpv(['CAENA36XX:1:CurrentRBV   ';'CAENA36XX:1:OutputVoltage'],0:.01:4);


%% Plot step
% h = subplot(2,1,1);
% plot(t,a(1,:),'.-');
% h(2) = subplot(2,1,2);
% plot(t,a(2,:),'.-')
% linkaxes(h,'x');


%% Time constant
% 
% Tau = .45;
% fprintf('   Rise time = %f seconds\n', Tau);
% fprintf('   Bandwidth = %f Hz\n', 1/Tau/2/pi);
% fprintf('   Max slew  = %f Amps/seconds\n', 20/.6);
% 
% %tconst(t, a(1,:));
% %plot(.25*diff(y(1:100:end))./diff(t(1:100:end)))


