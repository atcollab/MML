global GLOBVAL;

global THERING;
try
    close 21 22 23 24 25
catch
end
ati = atindex(THERING);
ibend = sort([ati.BEND]);
for i = ibend
    THERING{i}.PassMethod = 'BndMPoleSymplectic4RadPass';
    THERING{i}.Energy = 3e9;
end

RADELEMINDEX = sort([ibend]);

[ENV, DP, DL] = ohmienvelope(THERING,RADELEMINDEX, 1:length(THERING)+1);
sigmas = cat(2,ENV.Sigma);
tilt = cat(2,ENV.Tilt);
spos = findspos(THERING,1:length(THERING)+1);

figure(21)
plot(spos,tilt*180/pi,'.-')
set(gca,'XLim',[0 spos(end)])
ylabel('Rotation angle of the beam ellipse [degrees]');
xlabel('s - position [m]');

figure(22)
[A, H1, H2] = plotyy(spos,sigmas(1,:),spos,sigmas(2,:));
hold off
plot(spos, 1e6*sigmas(1,:),'b')
hold on
plot(spos, 1e6*sigmas(2,:),'r')
xaxis ([0 spos(end)])
title('Principal axis of the beam ellipse [\mum]');
xlabel('s - position [m]');
legend('Horizontal', 'Vertical')

[TwissData, tune, chrom]  = twissring(THERING,0,1:length(THERING)+1,'chrom');
beta = cat(1,TwissData.beta);
spos = cat(1,TwissData.SPos);
eta = cat(2,TwissData.Dispersion);

epsx = (sigmas(1,:).^2-eta(1,:).^2*DP^2)./beta(:,1)';
figure(23)
plot(spos, epsx)
title('\epsilon_x')
xaxis([0 268.8])
epsy = (sigmas(2,:).^2-eta(3,:).^2*DP^2)./beta(:,2)';

figure(24)
plot(spos, epsy)
title('\epsilon_y')
xaxis([0 268.8])


figure(25)
plot(spos,eta(1,:)','g')
hold on
plot(spos,eta(2,:)','c')
xaxis([0 268.8])

rmstilt_degrees = (180/pi)*norm(tilt)/sqrt(length(tilt))
etay = eta(3,:);
rmsetay_m = norm(etay)/sqrt(length(etay))
% epsx0 = mean(epsx)
% epsy0 = mean(epsy)
epsx0 = median(epsx)
epsy0 = median(epsy)
ratio = 100*epsy0/epsx0
for i = ibend
    THERING{i}.PassMethod = 'BndMPoleSymplectic4Pass';
    THERING{i}.Energy = 3e9;
end
