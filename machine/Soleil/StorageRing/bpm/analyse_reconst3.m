
num = 12;

X = AM.Data.X(:,num:num+5)';
Z = AM.Data.Z(:,num:num+5)';


[X1 X2 X3 X4] = deal(X(1,:),X(2,:),X(3,:),X(4,:));
[Z1 Z2 Z3 Z4] = deal(Z(1,:),Z(2,:),Z(3,:),Z(4,:));

%% Algo 4 turns
nux = acos((X2-X1+X4-X3)/2./(X3-X2))/2/pi;
nuz = acos((Z2-Z1+Z4-Z3)/2./(Z3-Z2))/2/pi;

Xcod = (X3.*(X1+X3)-X2.*(X2+X4))./((X1-X4) + 3*(X3-X2));
Zcod = (Z3.*(Z1+Z3)-Z2.*(Z2+Z4))./((Z1-Z4) + 3*(Z3-Z2));

spos = getspos('BPMx');

figure
plot(spos,Xcod,'b.-',spos,Zcod,'r.-');
xlabel('s-position [m]');
ylabel('Close orbit [mm]');
legend('Xcod','Zcod');
grid on
yaxis([-7 7])

% disregard cplx results
nux(imag(nux) ~= 0) = NaN;
nuz(imag(nuz) ~= 0) = NaN;

figure
subplot(2,2,[1 2])
plot(spos,nux,'b.',spos,nuz,'r.')
xlabel('s-position [m]')
ylabel('tune fractionnal part')
title('4-turn Algorithm')
legend(sprintf('nux %f',mean(nux(~isnan(nux)))),sprintf('nuz %f',mean(nuz(~isnan(nuz)))));
grid on
yaxis([0 0.5])

subplot(2,2,3)
hist(nux(~isnan(nux)))
xlabel('Fractional tune nux')
grid on

subplot(2,2,4)
hist(nuz(~isnan(nuz)))
xlabel('Fractional tune nuz')
grid on

