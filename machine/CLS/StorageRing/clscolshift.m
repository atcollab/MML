function clscolshift(Xresp,arg1,arg2,arg3)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clscolshift.m 1.2 2007/03/02 09:02:16CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% matrixshift(Xresp)
% shifts every 4th row so that similar kicks line up
% arg1,arg2,arg3 are used to compare three different row numbers
% some manipulation can be done
% then shifts back
% ----------------------------------------------------------------------------------------------

figure;surface(Xresp);
X=zeros(48);
XB=zeros(48);
Xav=zeros(48);


for j=0:11
    k=j*4;
for i=1:(48-k)
    X(1+k,i)=Xresp(1+k,i+k);
    X(2+k,i)=Xresp(2+k,i+k);
    X(3+k,i)=Xresp(3+k,i+k);
    X(4+k,i)=Xresp(4+k,i+k);
end
for i=(48-k+1):48
   X(1+k,i)=Xresp(1+k,i-48+k);
   X(2+k,i)=Xresp(2+k,i-48+k);
   X(3+k,i)=Xresp(3+k,i-48+k);
   X(4+k,i)=Xresp(4+k,i-48+k);
end

end
figure;surface(X);
%compare different rows
if (arg1>0)
figure;plot(X(arg1,:),'-b');
hold on;plot(X(arg2,:),'-r');
hold on;plot(X(arg3,:),'-g');
end
% average similar rows

for j=0:11
    for i=1:48
    Xav(1,i) = Xav(1,i) + X(j*4+1,i) ;
    Xav(2,i) = Xav(2,i) + X(j*4+2,i) ;
    Xav(3,i) = Xav(3,i) + X(j*4+3,i) ;
    Xav(4,i) = Xav(4,i) + X(j*4+4,i) ;
     
end
end

for j=0:11
    for i=1:48
    X(j*4+1,i)= Xav(1,i)/12;
    X(j*4+2,i)= Xav(2,i)/12;
    X(j*4+3,i)= Xav(3,i)/12;
    X(j*4+4,i)= Xav(4,i)/12;
end
end
figure;surface(X);
% end averaging

% now shift back

for j=0:11
    k=j*4;
for i=1:(48-k)
    XB(1+k,i+k)=X(1+k,i);
    XB(2+k,i+k)=X(2+k,i);
    XB(3+k,i+k)=X(3+k,i);
    XB(4+k,i+k)=X(4+k,i);
end
for i=(48-k+1):48
   XB(1+k,i-48+k)=X(1+k,i);
   XB(2+k,i-48+k)=X(2+k,i);
   XB(3+k,i-48+k)=X(3+k,i);
   XB(4+k,i-48+k)=X(4+k,i);
end
end

figure;surface(XB);

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clscolshift.m  $
% Revision 1.2 2007/03/02 09:02:16CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
