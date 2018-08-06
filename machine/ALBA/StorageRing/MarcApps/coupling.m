global THERING
ati=atindex(THERING);
qsi=sort([ati.QS]);
ibend = sort([ati.BEND]);
for i = ibend
    THERING{i}.PassMethod = 'BndMPoleSymplectic4RadPass';
    THERING{i}.Energy = 3e9;
end

ls=THERING{qsi(1)}.Length;
RADELEMINDEX = ibend;

spos = findspos(THERING,1:length(THERING)+1);
%%
ks=0.0;
for i=1:length(qsi),
        tks(i)= (-1)^(i+2)*ks/ls;
       THERING{qsi(i)}.PolynomA=[0 tks(i) 0 0];
end
%%
[TwissData, tune]  = twissring(THERING,0,1:length(THERING)+1,'chrom');
beta = cat(1,TwissData.beta);
eta = cat(2,TwissData.Dispersion);

[ENV, DP, DL] = ohmienvelope(THERING,RADELEMINDEX, 1:length(THERING)+1);
sigmas = cat(2,ENV.Sigma);
tilt = cat(2,ENV.Tilt);


figure(1)
plot(spos,tilt*180/pi,'.-')
title('Rotation angle of the beam ellipse [degrees]');
xlabel('s - position [m]');
hold on
drawlattice(0, 0.1*max(tilt*180/pi))
xaxis([0 spos(end)/4])
hold off

figure(2)

%[A, H1, H2] = plotyy(spos,sigmas(1,:),spos,sigmas(2,:));
% set(H1,'Marker','.')
% set(H2,'Marker','.')
% title('Principal axis of the beam ellipse [m]');
% xlabel('s - position [m]');
% hold on
% set(A(1),'XLim',[0 spos(end)/4])
% set(A(2),'XLim',[0 spos(end)/4])
subplot(2,1,1)
title('Horizontal beam size')
plot(spos,1E6*sigmas(1,:),'r.-')
hold on
drawlattice(0, 0.5e6*min(sigmas(1,:)))
xaxis([0 spos(end)/4])
ylabel('\mum')
xlabel('s [m]')
hold off
subplot(2,1,2)
title('Vertical beam size')

plot(spos,1e6*sigmas(2,:),'b.-')
hold on
drawlattice(0, 0.5e6*min(sigmas(2,:)))
xaxis([0 spos(end)/4])
ylabel('\mum')
xlabel('s [m]')

hold off

figure(3)
hold off
title('Dispersion')
plot(spos, eta(1,:),'r')
hold on
plot(spos, eta(3,:))
drawlattice(2.5*min(eta(3,:)), 0.1*max(eta(1,:)))
xaxis([0 spos(end)/4])
ylabel('m')
xlabel('s [m]')


epsx = (sigmas(1,:).^2-eta(1,:).^2*DP^2)./beta(:,1)';
epsy = (sigmas(2,:).^2-eta(3,:).^2*DP^2)./beta(:,2)';
emit(1) = median(epsx);
emit(2) = median(epsy);
fprintf(1,'\n--------------------------------\nex= %f\ney= %f\nk= %f\n', emit(1)*1E9, emit(2)*1E9, 100*emit(2)/emit(1))
fprintf(1,'Maximum Skew component = %f\n', max(abs(tks))*ls/0.15)