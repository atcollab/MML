global THERING;
QSi=findcells(THERING,'FamName','QS');
lqs=THERING{QSi(1)}.Length;
[TwissData, tune]  = twissring(THERING,0,1:length(THERING)+1,'chrom');


ati = atindex(THERING);
ibend = sort([ati.BEND]);
for i = ibend
    THERING{i}.PassMethod = 'BndMPoleSymplectic4RadPass';
    THERING{i}.Energy = 3e9;
end

RADELEMINDEX = sort([ibend]);

%%
ks1=0.05;
ks2=+0.01;
ks3=-0.01;
for i=1:length(QS1i),
    THERING{QS1i(i)}.PolynomA=[0 ks1/lqs 0 0];
end
for i=1:length(QS2i),
    THERING{QS2i(i)}.PolynomA=[0 ks2/lqs 0 0];
end
for i=1:length(QS3i),
    THERING{QS3i(i)}.PolynomA=[0 ks3/lqs 0 0];
end
%%

[ENV, DP, DL] = ohmienvelope(THERING,RADELEMINDEX, 1:length(THERING)+1);
sigmas = cat(2,ENV.Sigma);
sigmax= sigmas(1,:);
sigmay= sigmas(2,:);
tilt=cat(1,ENV.Tilt);

[TwissData, tune]  = twissring(THERING,0,1:length(THERING)+1,'chrom');
beta = cat(1,TwissData.beta);
eta = cat(2,TwissData.Dispersion);
s= cat(1,TwissData.SPos);
epsx = (sigmas(1,:).^2-eta(1,:).^2*DP^2)./beta(:,1)';
epsy = (sigmas(2,:).^2-eta(3,:).^2*DP^2)./beta(:,2)';
emit(1) = median(epsx);
emit(2) = median(epsy);
figure(1)
hold off
subplot(3,1,1)
plot(s,sigmax);
subplot(3,1,2)
plot(s,sigmay);
subplot(3,1,3)
plot(s,tilt)
fprintf(1,'\nepsilon_x = %f\nepsilon_y = %f\ncoupling = %3f\n', 1E9*emit(1), 1e9*emit(2), 100*emit(2)/emit(1))