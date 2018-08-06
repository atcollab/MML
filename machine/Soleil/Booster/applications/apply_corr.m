

% apply correcteurs corrx_1 et corrz_1


load 'orbit_super1'


figure(10)
subplot(2,1,1);
bar(Corr_X , 0.5);xlim([1 22]); ylim([-1.5 1.5])
subplot(2,1,2);
bar(Corr_Z , 0.5);xlim([1 22]); ylim([-1.5 1.5])

% ncorrx=22;
setsp('HCOR',Corr_X);
setsp('VCOR',Corr_Z);


