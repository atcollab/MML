%%
clear angle x_s x_t s kick s etx etpx stored_beam_x stored_beam_px x_entry x_exit px_entry px_exit rad
global THERING;
global refOptic;
rad = true;
nTurns=10;
angle=[0 0];
list= findcells(THERING, 'FamName', 'IK');
ip_i =  findcells(THERING, 'FamName', 'sep_center');
sep_entry =  findcells(THERING, 'FamName', 'sep_entry');
sep_exit =  findcells(THERING, 'FamName', 'sep_exit');
% define the bump
L0 =  268.800296;	% design length  [m]
C0 =   299792458; 	% speed of light [m/s]c
kick_factor= [1.00 1 1 1];
color='k.r.b.g.c.m.k+r+b+g+c+m+k.r.b.g.c.m.k+r+b+g+c+m+';
Trev= L0/C0;
HalfSineTime=5E-6;
Tbum= 2*HalfSineTime;
n_b= round(((HalfSineTime)/Trev)/2); %floor((HalfSineTime/Trev/2));
amplitude=0.011;lin
distancek1_k2=0.7+0.5;
%stored beam
ex0=4.5E-9;
sigma_s=6;
nps=20;
exs=sigma_s*ex0;
bxs=refOptic.twiss.betax(ip_i);
axs=refOptic.twiss.alfax(ip_i);
gxs=refOptic.twiss.gammax(ip_i);
% bxes=refOptic.twiss.betax(ip_0);
% axes=refOptic.twiss.alfax(ip_0);
% gxes=refOptic.twiss.gammax(ip_0);
% injected beam
np=20;
exi0=10E-9;
sigma_i=6;
exi=sigma_i*exi0;
bxi=refOptic.twiss.betax(1);%2.5; 
axi=0;
gxi=(1+axi^2)/bxi;
x_i=-0.021;
px_i=0.3E-3;
%setpum
p_s=-16;
t_s=3;
%%
%for radiation
cavityoff();
radiationoff;
if (rad==true)
    cavityon(3E9)
    radiationon
end

%%
angle(1)=amplitude/distancek1_k2;
% Turn 1
n=1;
kick(n)=angle(1)*cos(pi*(n-1)*Trev/Tbum);
THERING{list(1)}.KickAngle=-angle*kick_factor(1)*cos(2*pi*(n-1)*Trev/Tbum);
THERING{list(2)}.KickAngle=angle*kick_factor(2)*cos(2*pi*(n-1)*Trev/Tbum);;
THERING{list(3)}.KickAngle=angle*kick_factor(3)*cos(2*pi*(n-1)*Trev/Tbum);
THERING{list(4)}.KickAngle=-angle*kick_factor(4)*cos(2*pi*(n-1)*Trev/Tbum);
getsp('IK');
Fp= findorbit4(THERING, 0);
x0=[Fp(1) 0 0 0 0 0]';

n_elements= length(THERING) ;
L=0;
s=0;
%%
for i=1:n_elements
    METHOD= THERING{i}.PassMethod;
    x0=feval(METHOD, THERING{i}, x0);
    x_s(1,i)=x0(1);
    x_t(1,i)=0;
    si=THERING{i}.Length;
    L=L+si;
    s(i)=L;
end
x1=[x_i px_i 0 0 0 0]';
xt0=x1;
disp('Kick amplitude = ')
disp (x_s(1,ip_i))
disp('Kikc strenght =  [mrad]')
disp(angle(1)*1E3)
disp('Injected Beam amplitude =')
disp(x1(1))
for i=ip_i:n_elements
    METHOD= THERING{i}.PassMethod;
    x1=feval(METHOD, THERING{i}, x1);
    x_t(1,i)=x1(1);
end

%%
for n=2:n_b
    kick(n)=angle(1)*cos(pi*(n-1)*Trev/Tbum);
    THERING{list(1)}.KickAngle=-angle*kick_factor(1)*cos(2*pi*(n-1)*Trev/Tbum);
    THERING{list(2)}.KickAngle=angle*kick_factor(2)*cos(2*pi*(n-1)*Trev/Tbum);;
    THERING{list(3)}.KickAngle=angle*kick_factor(3)*cos(2*pi*(n-1)*Trev/Tbum);
    THERING{list(4)}.KickAngle=-angle*kick_factor(4)*cos(2*pi*(n-1)*Trev/Tbum);
    findorbit4(THERING, 0);
    for i=1:n_elements
        METHOD= THERING{i}.PassMethod;
        x0=feval(METHOD, THERING{i}, x0);
        x1=feval(METHOD, THERING{i}, x1);
        x_s(n,i)=x0(1);
        x_t(n,i)=x1(1);
    end
end
THERING{list(1)}.KickAngle=0;
THERING{list(2)}.KickAngle=0;
THERING{list(3)}.KickAngle=0;
THERING{list(4)}.KickAngle=0;
for n=(n_b+1):nTurns
    for i=1:n_elements
        METHOD= THERING{i}.PassMethod;
        x0=feval(METHOD, THERING{i}, x0);
        x1=feval(METHOD, THERING{i}, x1);
        x_s(n,i)=x0(1);
        x_t(n,i)=x1(1);
    end
end
%% Tracking of the ellipse

for i=1:np+1
    theta=(2*pi/np)*(i-1);
    E(1,i)=sqrt(exi*bxi)*cos(theta)+xt0(1);
    E(2,i)=sqrt(exi/bxi)*sin(theta)-axi*(E(1,i)-xt0(1))/bxi+xt0(2);
    E(3,i)=0;
    E(4,i)=0;
    E(5,i)=0;
    E(6,i)=0;
end
etx(1,1:np+1)=E(1,:);
etpx(1,1:np+1)=E(2,:);
% Turn 1
n=1;
kick(n)=angle(1)*cos(pi*(n-1)*Trev/Tbum);
THERING{list(1)}.KickAngle=-angle*kick_factor(1)*cos(pi*(n-1)*Trev/Tbum);
THERING{list(2)}.KickAngle=angle*kick_factor(2)*cos(pi*(n-1)*Trev/Tbum);;
THERING{list(3)}.KickAngle=angle*kick_factor(3)*cos(pi*(n-1)*Trev/Tbum);
THERING{list(4)}.KickAngle=-angle*kick_factor(4)*cos(pi*(n-1)*Trev/Tbum);
Fp= findorbit4(THERING, 0);
x0=[Fp(1) 0 0 0 0 0]';

for i=ip_i:sep_exit,
    METHOD= THERING{i}.PassMethod;
    E=feval(METHOD, THERING{i}, E);
end
x_exit(1,1:np+1)=E(1,:);
px_exit(1,1:np+1)=E(2,:);
for i=sep_exit+1:n_elements,
    METHOD= THERING{i}.PassMethod;
    E=feval(METHOD, THERING{i}, E);
end
x_entry(1,np+1)=0;
xp_entry(1,np+1)=0;

%%
for n=2:n_b
    kick(n)=angle(1)*cos(pi*(n-1)*Trev/Tbum);
    THERING{list(1)}.KickAngle=-angle*kick_factor(1)*cos(pi*(n-1)*Trev/Tbum);
    THERING{list(2)}.KickAngle=angle*kick_factor(2)*cos(pi*(n-1)*Trev/Tbum);;
    THERING{list(3)}.KickAngle=angle*kick_factor(3)*cos(pi*(n-1)*Trev/Tbum);
    THERING{list(4)}.KickAngle=-angle*kick_factor(4)*cos(pi*(n-1)*Trev/Tbum);
    findorbit4(THERING, 0);
    for i=1:sep_entry,
        METHOD= THERING{i}.PassMethod;
        E=feval(METHOD, THERING{i}, E);
    end
    x_entry(n,1:np+1)=E(1,:);
    px_entry(n,1:np+1)=E(2,:);
    for i=sep_entry+1:ip_i
        METHOD= THERING{i}.PassMethod;
        E=feval(METHOD, THERING{i}, E);
    end
    etx(n,1:np+1)=E(1,:);
    etpx(n,1:np+1)=E(2,:);
    for i=ip_i+1:sep_exit,
        METHOD= THERING{i}.PassMethod;
        E=feval(METHOD, THERING{i}, E);
    end
    x_exit(n,1:np+1)=E(1,:);
    px_exit(n,1:np+1)=E(2,:);
    for i=sep_exit+1:n_elements
        METHOD= THERING{i}.PassMethod;
        E=feval(METHOD, THERING{i}, E);
    end
end
THERING{list(1)}.KickAngle=0;
THERING{list(2)}.KickAngle=0;
THERING{list(3)}.KickAngle=0;
THERING{list(4)}.KickAngle=0;
for n=(n_b+1):nTurns
 for i=1:sep_entry,
        METHOD= THERING{i}.PassMethod;
        E=feval(METHOD, THERING{i}, E);
    end
    x_entry(n,1:np+1)=E(1,:);
    px_entry(n,1:np+1)=E(2,:);
    for i=sep_entry+1:ip_i
        METHOD= THERING{i}.PassMethod;
        E=feval(METHOD, THERING{i}, E);
    end
    etx(n,1:np+1)=E(1,:);
    etpx(n,1:np+1)=E(2,:);
    for i=ip_i+1:sep_exit,
        METHOD= THERING{i}.PassMethod;
        E=feval(METHOD, THERING{i}, E);
    end
    x_exit(n,1:np+1)=E(1,:);
    px_exit(n,1:np+1)=E(2,:);
    for i=sep_exit+1:n_elements
        METHOD= THERING{i}.PassMethod;
        E=feval(METHOD, THERING{i}, E);
    end
end
%% creates ellipse stored beam
for i=1:nps+1
    theta=(2*pi/nps)*(i-1);
    EXs(i)=sqrt(exs*bxs)*cos(theta);
    EPXs(i)=sqrt(exs/bxs)*sin(theta)-axs*EXs(1,i)/bxs;
end
for i=1:n_b+1
    stored_beam_x(i,1:nps+1)=EXs(1:nps+1)+x_s(i, ip_i);
    stored_beam_px(i,1:nps+1)=EPXs(1:nps+1);
end
%%
figure(1)
subplot(2,1,2)
plot(s, x_s(1:7,:))
xaxis([0 L0])
subplot(2,1,1)
plot(s, x_t(1:7,:))
xaxis([0 L0])

%%
figure(2)
subplot(1,3,2)
hold off
for i=1:n_b+4
    plot(1e3*etx(i,:), 1e3*etpx(i,:), color((2*i-1):2*i))
    hold on;
end

for i=1:n_b
    plot(1e3*stored_beam_x(i,:), 1e3*stored_beam_px(i,:), color((2*i-1):2*i))
end
legend('1', '2', '3', '4','5','6','7')
v=axis;
l_sx=[v(1) p_s-t_s p_s-t_s p_s p_s v(2)];
l_sy1=[ 0    0            v(3)     v(3) 0   0 ];
l_sy2=[ 0    0            v(4)     v(4) 0   0 ];
area(l_sx, l_sy1);
area(l_sx, l_sy2);
plot(x_s(:, ip_i), 0*x_s(:, ip_i), 'rd')

plot(0,0, 'ks');
hold off
title('Middle of the Septum')
%axis([-30 10 -1 1])
subplot(1,3,3)
hold off
for i=1:n_b+4
    plot(1e3*x_exit(i,:), 1e3*px_exit(i,:), color((2*i-1):2*i))
    hold on;
end
v=axis;
l_sx=[v(1) p_s-t_s p_s-t_s p_s p_s v(2)];
l_sy1=[ 0    0            v(3)     v(3) 0   0 ];
l_sy2=[ 0    0            v(4)     v(4) 0   0 ];
area(l_sx, l_sy1);
area(l_sx, l_sy2);
plot(x_s(:, ip_i), 0*x_s(:, ip_i), 'rd')

plot(0,0, 'ks');
hold off
title('Exit of the Septum')
%axis(v)
subplot(1,3,1)
hold off
for i=1:n_b+4
    plot(1e3*x_entry(i,:), 1e3*px_entry(i,:), color((2*i-1):2*i))
    hold on;
end

%v=axis;
l_sx=[v(1) p_s-t_s p_s-t_s p_s p_s v(2)];
l_sy1=[ 0    0            v(3)     v(3) 0   0 ];
l_sy2=[ 0    0            v(4)     v(4) 0   0 ];
area(l_sx, l_sy1);
area(l_sx, l_sy2);
plot(x_s(:, ip_i), 0*x_s(:, ip_i), 'rd')

plot(0,0, 'ks');
hold off
title('Entrance of the Septum')
%axis(v)
%%
%Acceptance
 for i=1:nTurns
     Acceptace(i)=max((etx(i,:)-x_s(i,ip_i)).*(etx(i,:)-x_s(i,ip_i))*gxs+(etpx(i,:).*etpx(i,:))*bxs);
 end
%%
 figure(83)
 plot(1:nTurns,Acceptace(1:nTurns)*1E6);
 title('Acceptance mm-mrad');
 xlabel('Turn number')
%%
figure(87)
subplot(1,3,2)
hold off
for i=1:nTurns
    plot(1e3*etx(i,:), 1e3*etpx(i,:),'c.')
    hold on;
end

for i=1:n_b
    plot(1e3*stored_beam_x(i,:), 1e3*stored_beam_px(i,:), color((2*i-1):2*i))
end
legend('1', '2', '3', '4','5','6','7')
%v=axis;
l_sx=[v(1) p_s-t_s p_s-t_s p_s p_s v(2)];
l_sy1=[ 0    0            v(3)     v(3) 0   0 ];
l_sy2=[ 0    0            v(4)     v(4) 0   0 ];
area(l_sx, l_sy1);
area(l_sx, l_sy2);
plot(x_s(:, ip_i), 0*x_s(:, ip_i), 'rd')

plot(0,0, 'ks');
hold off
title('Middle of the Septum')
%axis([-30 10 -1 1])
subplot(1,3,3)
hold off
for i=1:nTurns
    plot(1e3*x_exit(i,:), 1e3*px_exit(i,:), 'c.')
    hold on;
end
v=axis;
l_sx=[v(1) p_s-t_s p_s-t_s p_s p_s v(2)];
l_sy1=[ 0    0            v(3)     v(3) 0   0 ];
l_sy2=[ 0    0            v(4)     v(4) 0   0 ];
area(l_sx, l_sy1);
area(l_sx, l_sy2);
plot(x_s(:, ip_i), 0*x_s(:, ip_i), 'rd')

plot(0,0, 'ks');
hold off
title('Exit of the Septum')
%axis(v)
subplot(1,3,1)
hold off
for i=1:nTurns
    plot(1e3*x_entry(i,:), 1e3*px_entry(i,:), 'c.')
    hold on;
end

%v=axis;
l_sx=[v(1) p_s-t_s p_s-t_s p_s p_s v(2)];
l_sy1=[ 0    0            v(3)     v(3) 0   0 ];
l_sy2=[ 0    0            v(4)     v(4) 0   0 ];
area(l_sx, l_sy1);
area(l_sx, l_sy2);
plot(x_s(:, ip_i), 0*x_s(:, ip_i), 'rd')

plot(0,0, 'ks');
hold off
title('Entrance of the Septum')
%axis(v)
%%
figure(810)
step=nTurns/50;
plot3(1e3*etx(int32([1:step:nTurns nTurns]),:), 1e3*etpx(int32([1:step:nTurns nTurns]),:),int32([1:step:nTurns nTurns]),'.')
%%
figure(811)
plot(1e3*etx(int32([1:step:nTurns nTurns]),:), 1e3*etpx(int32([1:step:nTurns nTurns]),:),'.')
hold on
plot(1e3*mean(etx(int32([1:step:nTurns nTurns]),:)),1e3*mean(etpx(int32([1:step:nTurns nTurns]),:)),'.r')
