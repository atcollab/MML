function Angle = SWLS(Amps,Index)
Energy = getenergy;
Brho = getbrho(Energy);
SWLS.Parameter = [0 25 50 75 100 125 150 175 200 225 250 260 261]; % Current
SWLS.PeakField = [0.000000 1.245164 1.856044 2.414862 2.916582 3.415849 ...
                  3.906895 4.365579 4.825984 5.290268 5.758334 5.944600 6.0];

SWLS.Field = interp1(SWLS.Parameter,SWLS.PeakField,Amps,'linear');
SWLSB0 = SWLS.Field;
SWLSEB0 = -SWLSB0/2;
SWLSK = SWLSB0/Brho;
SWLSEK = SWLSEB0/Brho;
SWLSP = [0.309*SWLSK*0.04 0.809*SWLSK*0.04 SWLSK*0.02];
SWLSEP = [0.309*SWLSEK*0.04 0.809*SWLSEK*0.04 SWLSEK*0.02];
X = family2atindex('SWLS');
SWLSEA = [ X(1) X(6) X(13) X(18) ];
SWLSEB = [ X(2) X(5) X(14) X(17) ];
SWLSEC = [ X(3) X(4) X(15) X(16) ];
SWLSA  = [ X(7) X(12) ];
SWLSB  = [ X(8) X(11) ];
SWLSC  = [ X(9) X(10) ];
for i = 1:4
    if i > 2
        j = i - 2;
    else
        j = i;
    end
    if Index == SWLSEA(i)
         Angle = SWLSEP(1);
         break;
     elseif Index == SWLSEB(i)
         Angle = SWLSEP(2);
         break;
     elseif Index == SWLSEC(i)
         Angle = SWLSEP(3);
         break;
     elseif Index == SWLSA(j)
         Angle = SWLSP(1);
         break;
     elseif Index == SWLSB(j)
         Angle = SWLSP(2);
         break;
     elseif Index == SWLSC(j)
         Angle = SWLSP(3);
         break;
    end
end
return


    