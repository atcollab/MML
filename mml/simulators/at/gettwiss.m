function [Optics] = gettwiss(THERING, DP)
%GETWISS - Calculate the twiss parameters
%  [Optics] = gettwiss(THERING, DP)
%
%  GETTWISS calls LINOPT2 for entire ring and returns Twiss parameters
%  See LinOpt2 for description of nomenclarture and mathematics
%
%  Phase calculation from transfer matrices from '0' to location '1' (AIP 184 p. 50)
%  Only need initial alfa, beta
%  M=M44
%  M11: sqrt(beta1/beta0)*(cos(phi) + alfa0*sin(phi))
%  M12: sqrt(beta0*beta1)*sin(phi)
%  M21: (1/sqrt(beta0*beta1))*[(alfa0-alfa1)*cos(phi)-(1+alfa0*alfa1)*sin(phi))
%  M22: sqrt(beta0/beta1)*(cos(phi)-alfa1*sin(phi))
%  phi=atan2(M12,beta0*M11-alfa0*M12)

%  Written by Jeff Corbett


if nargin < 1
    global THERING
end
if nargin < 2
    DP = 1e-8;
end


%load linear optics structure for entire ring
%disp('   Computing Coupled Lattice Parameters ...');
LinData = linopt2(THERING,DP,1:length(THERING)+1);

%compute fractional tune
nux=acos(trace(LinData(1).A/2))/(2*pi);
nuy=acos(trace(LinData(1).B/2))/(2*pi);

%pre-define arrays
NR=length(THERING)+1;
name=cell(NR,1);        %initialize cell for names
s=zeros(NR,1);
len=s;
betax=s;   betay=s;
alfax=s;   alfay=s;
gammax=s;  gammay=s;
etax=s;    etay=s;
etapx=s;   etapy=s;
phix=s;    phiy=s;
curlhx=s;  curlhy=s;
ch1=s; ch2=s; ch3=s;

%compute optics for all elements
for ii=1:NR

    %load position
    s(ii)=LinData(ii).SPos(1);

    %horizontal Twiss parameters
    m22=LinData(ii).A;
    a=m22(1,1);  b=m22(1,2);  c=m22(2,1);  d=m22(2,2);
    betax(ii)=b/sin(2*pi*nux);
    alfax(ii)=(a-d)/(2*sin(2*pi*nux));
    gammax(ii)=-c/sin(2*pi*nux);

    %vertical Twiss parameters
    m22=LinData(ii).B;
    a=m22(1,1);  b=m22(1,2);  c=m22(2,1);  d=m22(2,2);
    betay(ii)=b/sin(2*pi*nuy);
    alfay(ii)=(a-d)/(2*sin(2*pi*nuy));
    gammay(ii)=-c/sin(2*pi*nuy);

    %horizontal phase
    num=LinData(ii).M44(1,2);
    den=LinData(1).beta(1)*LinData(ii).M44(1,1)-LinData(1).alfa(1)*num;
    phix(ii)=atan2(num,den);

    %vertical phase
    num=LinData(ii).M44(3,4);
    den=LinData(1).beta(2)*LinData(ii).M44(3,3)-LinData(1).alfa(2)*num;
    phiy(ii)=atan2(num,den);

    %load element names
    if ii<NR
        if isfield(THERING{ii},'Name')
            name{ii}=THERING{ii}.Name;
        else
            name{ii}=THERING{ii}.FamName;
        end

        %load element lengths
        len(ii)=THERING{ii}.Length;
    end
end

if ii==NR
    name{NR}='End';       %last element has name 'End' and zero length
    len(NR)=0;            %THERING only has NR-1 elements
end

%compute dispersion, derivative
%disp('   Computing Dispersion ...');
dp=1e-6;
orb4=findorbit4(THERING,dp,1:NR);
etax =orb4(1,:)'/dp;
etapx=orb4(2,:)'/dp;
etay =orb4(3,:)'/dp;
etapy=orb4(4,:)'/dp;

%unwrap phase
phix=unwrap(phix)/(2*pi);
phiy=unwrap(phiy)/(2*pi);

%compute integer tunes
qx=round(phix(NR));
if phix(NR)-qx <=0
    qx=qx-1;   % Below half integer
end 
qx=qx+nux;
qy=round(phiy(NR));
if phiy(NR)-qy <=0
    qy=qy-1;   % Below half integer
end 
qy=qy+nuy;

%compute curly-H
for ii=1:NR;
    %horizontal
    ch1(ii)=gammax(ii)*etax(ii)*etax(ii);
    ch2(ii)=2*alfax(ii)*etax(ii)*etapx(ii);
    ch3(ii)=betax(ii)*etapx(ii)*etapx(ii);
    curlhx(ii)= ch1(ii)+ch2(ii)+ch3(ii);
    %vertical
    ch1(ii)=gammay(ii)*etay(ii)*etay(ii);
    ch2(ii)=2*alfay(ii)*etay(ii)*etapy(ii);
    ch3(ii)=betay(ii)*etapy(ii)*etapy(ii);
    curlhy(ii)= ch1(ii)+ch2(ii)+ch3(ii);
end

%load output
Optics.name  =char(name);
Optics.len   =len;
Optics.s     =s;
Optics.betax =betax;
Optics.alfax =alfax;
Optics.gammax=gammax;
Optics.phix  =phix;
%Optics.qx    =qx;
%Optics.nux   =nux;
Optics.etax  =etax;
Optics.etapx =etapx;
Optics.curlhx=curlhx;
%load transport matrices 'A'
for ii=1:NR
    Optics.r11x(ii,1)=LinData(ii).M44(1,1);
    Optics.r12x(ii,1)=LinData(ii).M44(1,2);
    Optics.r21x(ii,1)=LinData(ii).M44(2,1);
    Optics.r22x(ii,1)=LinData(ii).M44(2,2);
end

Optics.betay =betay;
Optics.alfay =alfay;
Optics.gammay=gammay;
Optics.phiy  =phiy;
%Optics.qy    =qy;
%Optics.nuy   =nuy;
Optics.etay  =etay;
Optics.etapy =etapy;
Optics.curlhy=curlhy;
%load transport matrices 'B'
for ii=1:NR
    Optics.r11y(ii,1)=LinData(ii).M44(3,3);
    Optics.r12y(ii,1)=LinData(ii).M44(3,4);
    Optics.r21y(ii,1)=LinData(ii).M44(4,3);
    Optics.r22y(ii,1)=LinData(ii).M44(4,4);
end

% plot(s,phix); hold on; plot(s,phiy,'r');
% figure;
% ip=1:round(NR/4);
% plot(s(ip),betax(ip)); hold on; plot(s(ip),betay(ip),'r'); plot(s(ip),10*Optics.etax(ip),'k');
% figure
% plot(s(ip),curlhx(ip));

%disp(['   Horizontal Tune: ', num2str(qx,'%6.3f')]);
%disp(['   Vertical Tune:   ', num2str(qy,'%6.3f')]);
