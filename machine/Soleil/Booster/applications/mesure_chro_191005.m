data =[
352.170 0.254 0.158
352.180 0.248 0.154
352.190 0.236 0.144
352.200 0.228 0.144
352.210 0.220 0.138
352.220 0.214 0.134
352.230 0.206 0.130
352.240 0.200 0.124
]
alpha = 3e-2;
delta = (data(:,1)-352.200)/352.200/alpha*100;
nux = data(:,2);
nuz = data(:,3);

figure 
subplot(2,1,1)
plot(delta,nux,'.b');
xlabel('\delta (%)')
ylabel('\nu_x')
grid on
title('tune shift with energy')
subplot(2,1,2);
plot(delta,nuz,'.r');
grid
xlabel('\delta (%)')
ylabel('\nu_z')
