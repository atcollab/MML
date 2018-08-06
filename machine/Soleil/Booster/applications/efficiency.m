% rendement BOOSTER/LT1

clear charge

file='/home/operateur/Alex/current_linac_booster_trend.txt'
fid=fopen(file,'r');
charge = fscanf(fid, '%g %g %g', [3 inf]) ;
charge(1,:)=charge(1,:)-charge(1,1);
charge(2,:)=-charge(2,:)+0.044;
r=charge(2,:)./charge(3,:);
fclose(fid);
save('efficacité', 'charge')
figure(200)
plot(charge(1,:),charge(2,:),'-r',charge(1,:),charge(3,:),'-b')
ylim([0 4]); grid on;

figure(201)
plot(charge(1,:),r,'-r')
ylim([0.8 1]); grid on;

