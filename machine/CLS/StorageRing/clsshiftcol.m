function [Xavg]=clsshiftcol(Xresp,buttonA,buttonB,buttonC)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsshiftcol.m 1.2 2007/03/02 09:02:53CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% clsshiftcol(Xresp,buttonA,buttonB,buttonC)
% shifts columns sideways so that similar button responses line up
% arg1,arg2,arg3 are used to compare three different button (row) numbers
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
%figure;surface(X);
%compare different rows
if (buttonA>0)
%figure;plot(X(buttonA,:),'-b');
%hold on;plot(X(buttonB,:),'-r');
%hold on;plot(X(buttonC,:),'-g');
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
%figure;surface(X);
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
XB(49,:)=[];
XB(:,49)=[];
Xavg=XB;

figure;surface(XB);

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsshiftcol.m  $
% Revision 1.2 2007/03/02 09:02:53CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
