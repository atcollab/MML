%% Booster Orbit
% Get the orbit at two different currents.
% This is required since the attenuation on the cables going into the
% Bergoz modules is 40 dB different at the maximum.  At high currents some
% BPMs saturate, while at low current the others fluctuate too much

% get the CA id of the timing PVs that control when the orbit is measured.
% Taking an orbit measurement at different times on the beam decay curve
% gives the different currents we need.  The booster should not be ramped
% so the orbit can be corrected at the injection energy first.
id_C = mcaopen('DLY_5:CHANNEL_C_SP');
delay_C = mcaget(id_C);
id_D = mcaopen('DLY_5:CHANNEL_D_SP');
delay_D = mcaget(id_D);

% calc the pulse width
delta_T = delay_D - delay_C;
fprintf('pulse width = %g\n',delta_T);
 
% set which BPMs are used for low and high currents
lowA = [9:13,15:21];
highA = [1:3,5:6,8,22:32];

%%  Set current and take measurements
%% LOW
% set the measurement to the low current beam
delay_C = 0.300;
delay_D = delay_C + delta_T;
mcaput(id_C,delay_C);
sleep(5);

% X = getx;
% Y = gety;
X = getx(elem2dev('BPMx',sort([lowA,highA])),'Struct');
Y = gety(elem2dev('BPMy',sort([lowA,highA])),'Struct');

newX = X;
newY = Y;

figure(33)
subplot(2,1,1)
plot(newX.Data)
subplot(2,1,2)
plot(newY.Data)


%% HIGH
% set the measurement to the high current beam
delay_C = 0.100;
delay_D = delay_C + delta_T;
mcaput(id_C,delay_C);
sleep(5);

% X = getx;
% Y = gety;
X = getx(elem2dev('BPMx',sort([lowA,highA])),'Struct');
Y = gety(elem2dev('BPMy',sort([lowA,highA])),'Struct');

for i = [1:6,18:29]
    newX.Data(i) = X.Data(i);
    newY.Data(i) = Y.Data(i);
end


figure(33)
subplot(2,1,1)
plot(newX.Data)
subplot(2,1,2)
plot(newY.Data)

%% Setup Structures
hcm = getsp('HCM','Struct');
vcm = getsp('VCM','Struct');

%% Calculate the orbit correction 
% Global orbit correction is obtained by using setorbit. Number of
% iterations to attain full correction is 20 iterations and never use all
% the eigenvalues in the calculations ie < 24 for the horizontal and < 12
% for the vertical. One can also assign a weighting for the 30 bpms that
% are being used (remembering that 7 and 14 are not being used). 
iterations = 20;
h_eigenvalues = [1:20];
v_eigenvalues = [1:9];

bpmweight = ones(30,1);

figure(34)

%% Horizontal orbit correction
[CM, RF, OCS0, RF0, V, Svalues, b] = ...
    setorbit(zeros(length(X.DeviceList),1),X,hcm,iterations,h_eigenvalues,'Display','ModelResp','ModelDisp');

%% Vertical orbit correction
[CM, RF, OCS0, RF0, V, Svalues, b] = ...
    setorbit(zeros(length(Y.DeviceList),1),Y,vcm,iterations,v_eigenvalues,'Display','ModelResp','ModelDisp');