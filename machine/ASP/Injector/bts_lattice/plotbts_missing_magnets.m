%% plotbts
% a check of the BTS lattice pre commissioning

% create input Twiss parameter structure( see > help twissline)
TDin.ElemIndex = 1;
TDin.SPos = 0;
TDin.ClosedOrbit= zeros(4,1);
TDin.M44 = zeros(4,4);
betax0 = 4.5;
betay0 = 3.3;
TDin.beta = [betax0 betay0];
alphax0 = 0;
alphay0 = 0;
TDin.alpha = [alphax0 alphay0]; 
TDin.mu = [0 0];
TDin.Dispersion = [0 0 0 0]';

%% calculate the Twiss parameters

% load the booster
btswrk

% lost q43 and q53 to faulty PSU
NI = findcells(THERING,'FamName','q43');
THERING{NI}.K = 0;
THERING{NI}.PolynomB = [0 0 0 0];

NI = findcells(THERING,'FamName','q53');
THERING{NI}.K = 0;
THERING{NI}.PolynomB = [0 0 0 0];

% try to correct by reducing q31 and q32, need to get bx = 9.68 and by = 3.26
NI = findcells(THERING,'FamName','q31');
THERING{NI}.K = THERING{NI}.K * 1;

NI = findcells(THERING,'FamName','q32');
THERING{NI}.K = THERING{NI}.K * 1;

%decrease the strength of q43 and q44

NI = findcells(THERING,'FamName','q44');
THERING{NI}.K = THERING{NI}.K * 0;

%increase the strength of q5s
NI = findcells(THERING,'FamName','q51');
THERING{NI}.K = THERING{NI}.K * 0.8;

NI = findcells(THERING,'FamName','q52');
THERING{NI}.K = THERING{NI}.K * 0.7;




%increase the later quadrupole to compensate
% NI = findcells(THERING,'FamName','q51');
% THERING{NI}.K = THERING{NI}.K * 1.3;
% 
% NI = findcells(THERING,'FamName','q52');
% THERING{NI}.K = THERING{NI}.K * 1.3;
% 
% NI = findcells(THERING,'FamName','q53');
% THERING{NI}.K = THERING{NI}.K * 1.3;


% get the Twiss data
TD = twissline(THERING,0,TDin,1:length(THERING),'chrom');
BETA = cat(1,TD.beta);
S = cat(1,TD.SPos);
ETA = cat(2,TD.Dispersion);
ALPHA = cat(1,TD.alpha);

% calculate the beam size
epsilon_x = 50e-9;
epsilon_y = 0.1 * epsilon_x;
sigma_x = sqrt(epsilon_x*BETA(:,1));
sigma_y = sqrt(epsilon_y*BETA(:,2));

%% Plot results
figure(1)
clf
plot(S,BETA(:,1),'-b');
hold on
plot(S,BETA(:,2),'--r');
plot(S,ETA(1,:)*10,'-.g');
plotelementsat;
legend('betax','betay','etax*10')
hold off
disp('Beta_x = ');
disp(BETA(end,1));
disp('Beta_y = ');
disp(BETA(end,2));
disp('Alpha_x = ');
disp(ALPHA(end,1));
disp('Alpha_y = ');
disp(ALPHA(end,2));

figure(2);
plot(S,4*sigma_x/1e-3,'-b');
hold on
plot(S,4*sigma_y/1e-3,'--r');
plotelementsat
grid on
% text1 = sprintf()

hold off
