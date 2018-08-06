function clsshiftrow(Xresp,kickA,kickB,kickC)

% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsshiftrow.m 1.2 2007/03/02 09:02:29CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% clsshiftrow(Xresp,kickA,kickB,kickC)
% shifts rows down so that similar kicker responses line up
% arg1,arg2,arg3 are used to compare three different kicker (column) numbers
% after shifting similar responses can be averaged (or whatever)
% new responses are then shifted back to create a new response matrix
% ----------------------------------------------------------------------------------------------

Xresp(49,:)=0;
figure;surface(Xresp);

X=zeros(49);
XB=zeros(49);
Xav=zeros(49);


for j=0:11
    k=j*4;
for i=1:(48-k)
    X(i,1+k)=Xresp(i+k,1+k);
    X(i,2+k)=Xresp(i+k,2+k);
    X(i,3+k)=Xresp(i+k,3+k);
    X(i,4+k)=Xresp(i+k,4+k);
end
for i=(48-k+1):48
   X(i,1+k)=Xresp(i-48+k,1+k);
   X(i,2+k)=Xresp(i-48+k,2+k);
   X(i,3+k)=Xresp(i-48+k,3+k);
   X(i,4+k)=Xresp(i-48+k,4+k);
end

end
figure;surface(X);
%compare different columnsh
if (kickA>0)
figure;plot(X(:,kickA),'-b');
hold on;plot(X(:,kickB),'-r');
hold on;plot(X(:,kickC),'-g');
end
% average similar columns

for j=0:11
    for i=1:48
    Xav(i,1) = Xav(i,1) + X(i,j*4+1) ;
    Xav(i,2) = Xav(i,2) + X(i,j*4+2) ;
    Xav(i,3) = Xav(i,3) + X(i,j*4+3) ;
    Xav(i,4) = Xav(i,4) + X(i,j*4+4) ;
     
end
end

for j=0:11
    for i=1:48
    X(i,j*4+1)= Xav(i,1)/12;
    X(i,j*4+2)= Xav(i,2)/12;
    X(i,j*4+3)= Xav(i,3)/12;
    X(i,j*4+4)= Xav(i,4)/12;
end
end
figure;surface(X);
% end averaging

% now shift back

for j=0:11
    k=j*4;
for i=1:(48-k)
    XB(i+k,1+k)=X(i,1+k);
    XB(i+k,2+k)=X(i,2+k);
    XB(i+k,3+k)=X(i,3+k);
    XB(i+k,4+k)=X(i,4+k);
end
for i=(48-k+1):48
   XB(i-48+k,1+k)=X(i,1+k);
   XB(i-48+k,2+k)=X(i,2+k);
   XB(i-48+k,3+k)=X(i,3+k);
   XB(i-48+k,4+k)=X(i,4+k);
end
end

figure;surface(XB);

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsshiftrow.m  $
% Revision 1.2 2007/03/02 09:02:29CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
