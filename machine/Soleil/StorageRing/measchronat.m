%function [xix xiz] = measchronat
% MEASCHRONAT - Measure natural chromaticity by varyiong dipole fied
%
%  INPUTS
%
%  OUTPUTS
%  1. xix - horizontal natural chromaticity
%  2. xiz - vertical natural chromaticity

%
% Written by Laurent S. Nadolski

% TODO List
% ajouter fit automatique
% Regler les contantes de temps, la RMN mais entre 15 et 20 s pour mettre à jour la lecture du champ B

nb = 4;
tune= [];
Idip = [];
Rmn = [];
itot = 1.0; % total step for dipole in A
istep = -itot/nb; % stepsize in A

tune_start = gettune;
stepsp('BEND',itot);
fprintf('Dipole current (%f A) is changed by %f\n',getsp('BEND'), itot);
pause(40);
Idip(1) = getsp('BEND');
% for ik1 = 1:100,
%     temp(ik1) = getam('BEND'); pause(0.1)
% end
%Idip(1) = mean(temp);
Rmn(1) = getrmn;
tune(1,:) = gettune

k1 = 2;
for k = nb:-1:-nb+1,    
    stepsp('BEND',istep);    
    pause(30);
    Idip(k1) = getsp('BEND');
%     for ik1 = 1:100,
%         temp(ik1) = getam('BEND'); pause(0.1)
%     end
%    Idip(k1) = mean(temp);
    fprintf('Dipole current (%f A) is changed by %f A\n',Idip(k1), istep);
    tune(k1,:) = gettune
    Rmn(k1) = getrmn;
    k1 = k1 + 1;
end

stepsp('BEND',itot);
fprintf('Dipole current (%f A) is changed back to nominal value by %f A\n',getsp('BEND'), itot);
pause(40);

tune_finish = gettune;

fprintf('Tune variation \n')
fprintf('begin %f %f\n',tune_start)
fprintf('end %f %f\n',tune_finish)

% BUG should accept a array
E = [];

for k = 1:length(Idip),
    E(k) = bend2gev(Idip(k));
end

E0 = 2.73913739373611;
% E = (E-E0)./E0;
% E = E';
E = (Rmn-Rmn(5))./Rmn(5);
E = E';

%%
p1 = polyfit(E,tune(:,1),1)
p2 = polyfit(E,tune(:,2),1)

fprintf('natural chromaticity xix = %4.1f xiz = %4.1f\n',p1(1),p2(1));

%%
figure;
subplot(2,1,1)
suptitle(sprintf('Natural chromaticity xix = %4.1f xiz = %4.1f\n',p1(1),p2(1)));
plot(E*100,tune(:,1),'.-')
hold on
plot(E*100,polyval(p1,E), 'k')

ylabel('nux')
grid on
subplot(2,1,2)
plot(E*100,tune(:,2),'.-')
hold on
plot(E*100,polyval(p2,E), 'k')
ylabel('nuz')
xlabel('Energy deviation [%]');
grid on

xix = p1(1); xiz = p2(1);