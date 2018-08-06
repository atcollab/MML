%pertes sur chambre

dx=[-12   -8   -3  -2    0  2   3 5 ];
dr=[0.12  8.2  8.5  8.5  8  3.4 1 0 ];
dr=dr/8.5;


a=10;
sig=2.8;
i=0;

for x=-a:0.1:a
    i=i+1;
    p(i)=x-4;
    ax=a-abs(x);
    r(i)=(1-exp(-0.5*(ax/sig)*(ax/sig)));
end

plot(dx,dr,'-ob' ,p,r,'-k')

dn= [ 3  5   6   7    8  9     10 11  12  13  14  15  16  17 18   19  20 21];
dx1=[5   5   5   5    5  3     5  5   5   5   5   5   5   5   4   5   5  5];
dr1=[5.8 3.3 1.9 3.45 3  0.95  5. 3.8 7.3 2.5 7.3 1.4 6.4 0.2 1.7 5.6 0  4];

x0=9-sig*sqrt(-2*log(1-dr1/8.5));
if (abs(x0-dx1)<abs(-x0-dx1))
    dx0=x0-dx1;
else
    dx0=-x0-dx1;
end
 
%mesure BPM
s_bpmx=[14.2382 28.4764 50.2337 64.4719 92.5483 106.7865 128.5438 142.7820];
Zm=[-0.5356 0.2893  -0.3448 0.1526 -0.096 -0.2161 0.0730 -0.0045];
 
%ds1=[1:22]*3.55*2;
dx=(dn-1)*3.55*2;
s=[err_beta(:,1) ; err_beta(:,1)+78.31];
sigz1=[err_beta(:,2) ; err_beta(:,2)]*1000*1.2;
sigz2=-sigz1;
figure(2)
plot(dx,dx0,'-ob',s_bpmx,Zm,'-or',s,sigz1,'-k',s,sigz2,'-k')

