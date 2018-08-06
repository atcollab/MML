% recupere les orbit et correcteur de: 
% save 'orbit_super1' 'Xm' 'Zm' 'Corr_X' 'Corr_Z'

load 'orbit_super1'

clear nc K1 K2
for i=1:22,
    nc(i)=i;
    K1(i)=Corr_X(i)*1.2/1000;
    K2(i)=Corr_Z(i)*1.2/1000;
end

plot(Corr_X)
%sprintf('CH%d    HC  %d \n',[nc ; K1])
%sprintf('CV%d    VC  %d \n',[nc ; K2])

    