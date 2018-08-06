% recherche des indices des BPM entourant les dipoles

L = family2dev('BPMx');
A6a=[];A6b=[];A7a=[];A7b=[];
n=0
j=0;
for i = (1+j):4:16 ;
    %for i = 2:4:16 ;
    %for i = 3:4:16 ;
    %for i = 4:4:16 ;
    n = n+1;
    [I J] = find(L(:,1)==i & L(:,2)==6) ;
    A6a(n) = I;
    [I J] = find(L(:,1)==i & L(:,2)==7) ;
    A7a(n) = I;
end
A6a
A7a

n=0;
%%%%%%%%%%%%%
j = 3
n=0

for i = (1+j):4:16 ;
    %for i = 2:4:16 ;
    %for i = 3:4:16 ;
    %for i = 4:4:16 ;
    n = n+1;
    [I J] = find(L(:,1)==i & L(:,2)==6) ;
    A6b(n) = I;
    [I J] = find(L(:,1)==i & L(:,2)==7) ;
    A7b(n) = I;
end
A6b
A7b

A7c=[];A7db=[];A8ca=[];A8d=[];
n=0
j=1;
for i = (1+j):4:16 ;
    %for i = 2:4:16 ;
    %for i = 3:4:16 ;
    %for i = 4:4:16 ;
    n = n+1;
    [I J] = find(L(:,1)==i & L(:,2)==7) ;
    A7c(n) = I;
    [I J] = find(L(:,1)==i & L(:,2)==8) ;
    A8c(n) = I;
end
A7c
A8c

n=0;
%%%%%%%%%%%%%
j = 2
n=0

for i = (1+j):4:16 ;
    %for i = 2:4:16 ;
    %for i = 3:4:16 ;
    %for i = 4:4:16 ;
    n = n+1;
    [I J] = find(L(:,1)==i & L(:,2)==7) ;
    A7d(n) = I;
    [I J] = find(L(:,1)==i & L(:,2)==8) ;
    A8d(n) = I;
end
A7d
A8d

% action spécifique sur la fonction dispersion
Dz = 0*ones(1,120);
% val = 0.005;
% Dz(A6a(:)) = val;Dz(A7a(:)) = val;Dz(A6b(:)) = val;Dz(A7b(:)) = val;
% Dz(A7c(:)) = val;Dz(A8c(:)) = val;Dz(A7d(:)) = val;Dz(A8d(:)) = val;
% Dz


% à partir de valeur de setskewcorrection
Dz = Dy_Meas;
%Dy = 0*ones(1,120);
Dy = -Dz ; 
val = 2;
Dy(A6a(:)) = Dz(A6a(:))*val;Dy(A7a(:)) = Dz(A7a(:))*val;Dy(A6b(:)) = Dz(A6b(:))*val;Dy(A7b(:)) = Dz(A7b(:))*val;
Dy(A7c(:)) = Dz(A7c(:))*val;Dy(A8c(:)) = Dz(A8c(:))*val;Dy(A7d(:)) = Dz(A7d(:))*val;Dy(A8d(:)) = Dz(A8d(:))*val;

Dy_Meas = Dy ;
figure(6);plot(Dz)
disp('youp!')

