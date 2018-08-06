a25_Symplectic;
global THERING refOptic;
dk=0.01;
elementlist;
nmax=length(qlist)

for j=1:nmax;
    refTwiss=gettwiss();
    K=THERING{qlist(j)}.PolynomB(2);
    THERING{qlist(j)}.PolynomB(2)=K+dk;
    theTwiss=gettwiss();
    rowx=(theTwiss.betax(qlist)-refTwiss.betax(qlist))/dk;
    rowy=(theTwiss.betay(qlist)-refTwiss.betay(qlist))/dk;
    dq=gettune()-refOptic.tune;
    THERING{qlist(j)}.PolynomB(2)=K;
    for i=1:nmax,
        R(i,j)=rowx(i);
        R(i+nmax,j)=rowy(i);
    end
    
    R(i+nmax+1,j)=dq(1)/dk;
    R(i+nmax+2,j)=dq(2)/dk;
end
%%
[u, w, v]= svd(R);
%%
for i=1:nmax,
    ws(i)=w(i,i);
end
semilogy(ws);
%%
wi=0*w';
for i=1:nmax,
    wi(i,i)=1/ws(i);
end
Ri=v*wi*u';
%%
a25_Symplectic;

global refOptic;

dk=0.1;
K=THERING{qlist(1)}.PolynomB(2)+dk;
THERING{qlist(1)}.PolynomB(2)=K;
plotbeta();
%%
beta_new=gettwiss();
q_new=gettune();
beta_orig=refOptic.twiss;
q_orig=refOptic.tune;
b_orig_x=beta_orig.betax(qlist);
b_orig_y=beta_orig.betay(qlist);

b_new_x=beta_new.betax(qlist);
b_new_y=beta_new.betay(qlist);

b_orig=[[b_orig_x]; [b_orig_y]; q_orig];

b_new=[[b_new_x]; [b_new_y]; q_new];
db=b_new-b_orig;
dKc=Ri*db;
for i=1:nmax,
    K1(i)=THERING{qlist(i)}.PolynomB(2)-dKc(i);
  THERING{qlist(i)}.PolynomB(2)=K1(i);
end
plotbeta();
%% for the real id
 b_bare=dlmread('b_bare.out');
 b_id=dlmread('b_id.out');
dbx=b_bare(:,2)-b_id(:,2);
dby=b_bare(:,3)-b_id(:,3);
db=[dbx;dby];
dKc=Ri*db;
%%
a25_Symplectic;
for i=1:nmax,
    K1(i)=THERING{qlist(i)}.PolynomB(2)-dKc(i);
  THERING{qlist(i)}.PolynomB(2)=K1(i);
end
%%
dlmwrite('dk.dat', dKc)
dlmwrite('k1.dat', K1')
dlmwrite('k2.dat', K2')

%stem(dKc)
for i=1:nmax,
    K=THERING{qlist(i)}.PolynomB(2)-dKc(i); 
    THERING{qlist(i)}.PolynomB(2)=K;
end
