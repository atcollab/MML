alphafac = 20;   %alpha down by a factor of 20
%alphafac = 60;
switch alphafac
    case 20
load R:\Controls\matlab\shifts\xiahuang\12-11-2006\lowalpha\latdxcm208

    case 60
load R:\Controls\matlab\shifts\xiahuang\2007-1-8\latdxcm214.mat

end
L = findspos(THERING, length(THERING)+1);
harm = 372;
c0 = 2.99792458e8;
ati = atindex(THERING);
THERING{ati.RF}.Frequency = c0/L*harm;

%THERING{ati.RF}.passmethod = 'IdentityPass';

