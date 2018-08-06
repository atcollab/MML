

% save correcteurs

corrz = getam('VCOR');
save 'corrz_5' corrz

corrx = getam('HCOR');
save 'corrx_5' corrx

figure(10);
subplot(2,1,1);
bar(corrx , 0.8);xlim([0 22]); ylim([-1.5 1.5]);
subplot(2,1,2);
bar(corrz , 0.8);xlim([0 22]); ylim([-1.5 1.5]);