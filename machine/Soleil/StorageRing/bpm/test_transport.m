% Mode transport

% 19 mai 2006
% Written by Laurent S. Nadolski

global THERING
BPMindex = family2atindex('BPMx');
spos = getspos('BPMx');
X00 = [0 0 0 0 0 0]';
X01 = linepass(THERING, X00(:,end), 1:length(THERING)+1);

h1 = subplot(5,1,[1 2]);
plot(spos,X01(1,BPMindex)*1e3,'.-');
ylabel('X (mm)')

h2 = subplot(5,1,[4 5]);
plot(spos,X01(3,BPMindex)*1e3,'.-');
ylabel('Z (mm)') 

h3 = subplot(5,1,3);
drawlattice
% xaxis([1 getcircumference]);
xaxis([42 82]);
    

linkaxes([h1 h2 h3],'x')
set([h1 h2 h3],'XGrid','On','YGrid','On');
 