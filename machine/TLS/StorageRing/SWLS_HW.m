function Amps = SWLS_HW(Angle,Index)
Energy = getenergy;
Brho = getbrho(Energy);
SWLS.Parameter = [0 25 50 75 100 125 150 175 200 225 250 260 261]; % Current
SWLS.PeakField = [0.000000 1.245164 1.856044 2.414862 2.916582 3.415849 ...
                  3.906895 4.365579 4.825984 5.290268 5.758334 5.944600 6.0];
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
         Angle = Angle / 0.04 / 0.309 * Brho * (-2);
         break;
     elseif Index == SWLSEB(i)
         Angle = Angle / 0.04 / 0.809 * Brho * (-2);
         break;
     elseif Index == SWLSEC(i)
         Angle = Angle / 0.02 * Brho * (-2);
         break;
     elseif Index == SWLSA(j)
         Angle = Angle / 0.04 / 0.309 * Brho ;
         break;
     elseif Index == SWLSB(j)
         Angle = Angle / 0.04 / 0.809 * Brho;
         break;
     elseif Index == SWLSC(j)
         Angle = Angle / 0.02 * Brho;
         break;
    end
end
Amps = interp1(SWLS.PeakField,SWLS.Parameter,Angle,'linear');
return


    