[i s dp sloss sname]=textread('momemtum_acceptance.out','%d %f %f %f %s','headerlines',3);
%%
s_bin=0;
s_bin(1)=0;
L=0;
for i=1:(length(s)/2),
    s_bin(i+1)=s(i);
end
for i=1:(length(s_bin)-1),
    splot(i)=(s_bin(i+1)+s_bin(i))/2;
end
splot(length(s_bin))=(268.8+s_bin(length(s_bin)))/2;
for i=1:(length(s)/2-1),
    L(i)=s(i+1)-s(i);
end
L((length(s)/2))=268.8-s((length(s)/2));
%%
slp=0;
sln=0;
count_p=0;
count_p_r=0;
count_n=0;
count_n_r=0;

slp=sloss(dp>0);
count_p=hist(slp, s_bin);
total=sum(count_p);
count_p_r=100*count_p/total;

sln=sloss(dp<0);
count_n=hist(sln, s_bin);
total=sum(count_n);
count_n_r=100*count_n/total;
%%
avep=0;
aven=0;
lmin=min(L);
k=1;
nl=0;
for i=1:length(slp),
    nl(i)=int32(L(i)/lmin);
    for j=1:nl(i),
        avep(k)=slp(i);
        aven(k)=sln(i);
        k=k+1;
    end
end

averaged_p=hist(avep, s_bin);
total_a=sum(averaged_p);
averaged_p=100*averaged_p/total_a;


averaged_n=hist(aven, s_bin);
total_a=sum(averaged_n);
averaged_n=100*averaged_n/total_a;
%%
file0 = 'chambre.out';

try
    [num dummy sc mxch pxch vch ] = textread(file0,'%d %s %f %f %f %f','headerlines',3);
catch
    error('Error while opening file %s',file0)
end

%%
subplot(5,1,[1 2])

plot(sc,pxch,'r-');
hold on
plot(sc,mxch,'r-');
drawlattice(0, 10)
xaxis([0 270]);
plot(sc,vch,'b-');
hold on
plot(sc,-vch,'b-');

grid on
ylabel('x-y (mm)')
title('Vacuum pipe dimensions')

% subplot(5,1,[2 3])
% bar(splot, count_p_r,'b','BarWidth',4,'EdgeColor','b');
% hold on
% bar(splot, -count_n_r,'r','BarWidth',4,'EdgeColor','r');
% hold off
% xaxis([0 max(s)+1])
% ylabel('%')
% legend('Position of the losses, positive','Position of the losses, negative')
%subplot(5,1,[3 5])
%bar(splot, averaged_p,'b','BarWidth',4,'EdgeColor','b');
%hold on
%bar(splot, -averaged_n,'r','BarWidth',4,'EdgeColor','r');
%ylabel('%')
subplot(5,1,[3 5])
bar(splot, (averaged_p+averaged_n)/2,'b','BarWidth',4,'EdgeColor','b');
hold on
hold off
xaxis([0 270])
ylabel('%')
xlabel('s [m]')
legend('Percentage of losses')
