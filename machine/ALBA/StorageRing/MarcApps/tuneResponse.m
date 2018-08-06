a25_Symplectic;
quadlist=findmemberof('QUAD');
nmagnet= size(quadlist,1);
reftune=gettune;
dk=0.001;
maxQ=0.0001;
%%
for i=1:nmagnet,
    magnet=cell2mat(quadlist(i));
    k0=getsp(magnet,1);
    setsp(magnet, k0*(1+dk),1);
    thetune=gettune;
    DtuneX(i)=(thetune(1)-reftune(1))/dk;
    DtuneY(i)=(thetune(2)-reftune(2))/dk;
    setsp(magnet, k0,1);
    AllowedDKx(i)=(maxQ/DtuneX(i));
    AllowedDKy(i)=(maxQ/DtuneY(i));
    AllowedDKxR(i)=AllowedDKx(i)/k0;
    AllowedDKyR(i)=AllowedDKy(i)/k0;
end
%%
figure(1)
hold off
bar(AllowedDKx,'r');
hold on
bar(AllowedDKy,'b');
set(gca,'XTickLabel',quadlist)
Legend ('Horizontal','Vertical',-1)
ylabel('K')
print -deps2c allowed.eps
figure(2)
hold off
bar(100*AllowedDKxR,'r');
hold on
bar(100*AllowedDKyR,'b');
set(gca,'XTickLabel',quadlist)
Legend ('Horizontal','Vertical',-1)
ylabel('K relative %')
print -deps2c relative.eps
figure(2)
figure(3)
bar(DtuneX,'r');
hold on;
bar(DtuneY,'b');
set(gca,'XTickLabel',quadlist)
ylabel('\delta Q_{x,y}/\delta K')
Legend ('Horizontal','Vertical',-1)
print -deps2c response.eps
%%
a25_Symplectic
refAO = getao;
reftwiss=gettwiss;
quadlist=findmemberof('QUAD');
nmagnet= size(quadlist,1);
reftune=gettune;
for i=1:nmagnet,
    magnet=cell2mat(quadlist(i));
    a = getsp(magnet);
    ref_sp{i}= a;
end
%%
%
%Error in the quads
R_error_K=1E-4;
for i=1:nmagnet,
    magnet=cell2mat(quadlist(i));
    nmi=size(ref_sp{i}),1;
    error = R_error_K*randn(nmi);
    clear new_sp;
    for j=1:nmi,
        new_sp(j) = (ref_sp{i}(j))*(1+error(j));
    end
    setsp(magnet, new_sp');
end
%%
newA0=getao;
newtwiss=gettwiss;
q=gettune;
disp q
q-reftune
figure(1)
subplot(2,1,1)
plot(reftwiss.s, reftwiss.betax,'r')  
hold on
plot(reftwiss.s, newtwiss.betax,'+k')  
plot(reftwiss.s, 100*(reftwiss.betax-newtwiss.betax)./reftwiss.betax,'g')
ylabel('\beta_x')
xaxis([0 268.8])
subplot(2,1,2)
plot(reftwiss.s, reftwiss.betay,'b')  
hold on
plot(reftwiss.s, newtwiss.betay,'+k')  
plot(reftwiss.s, 100*(reftwiss.betay-newtwiss.betay)./reftwiss.betay,'g')  
ylabel('\beta_y')
xaxis([0 268.8])
%%
figure(1)
for i=1:nmagnet,
    magnet=cell2mat(quadlist(i));
    a = getsp(magnet);
    sp{i} = a ;
    hold on
    plot (sp{i}./ref_sp{i})
end