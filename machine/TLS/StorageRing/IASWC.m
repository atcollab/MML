function Angle = IASWC(Amps,Index)
Energy = getenergy;
Brho = getbrho(Energy);
IASWC.Parameter = [0 10.0406 11.9611 12.7613 13.7216 14.8418 15.9621 16.4422 ...
                   17.8826 18.6828 19.483 20.4432 49.8906 100.463 200.328 ...
		   250.412 262.904 276.187 288.83]; % Current
IASWC.PeakField = [0 0.5013 0.5577 0.5768 0.5998 0.6234 0.6461 0.6553 0.6812 ...
                   0.695 0.708 0.7214 1.0981 1.6089 2.5348 2.9927 3.1 3.22 ...
		   3.3397];

IASWC.Field = interp1(IASWC.Parameter,IASWC.PeakField,Amps,'linear');
IASWCB0 = IASWC.Field;
IASWCEB0 = IASWCB0*(125325/501300);
IASWC2B0 = IASWCB0*(375975/501300);
IASWCK = IASWCB0/Brho;
IASWCEK = IASWCEB0/Brho;
IASWC2K = IASWC2B0/Brho;
IASWCP = [0.309*IASWCK*0.0061 0.809*IASWCK*0.0061 IASWCK*0.00305];
IASWCEP = [0.309*IASWCEK*0.0061 0.809*IASWCEK*0.0061 IASWCEK*0.00305];
IASWC2P = [0.309*IASWC2K*0.0061 0.809*IASWC2K*0.0061 IASWC2K*0.00305];
IASWCN = -IASWCP;
IASWCEN = -IASWCEP;
IASWC2N = -IASWC2P;

X = family2atindex('IASWC');
IASWCPEA = [ X(1) X(6) ];
IASWCPEB = [ X(2) X(5) ];
IASWCPEC = [ X(3) X(4) ];
IASWCNEA = [ X(91) X(96) ];
IASWCNEB = [ X(92) X(95) ];
IASWCNEC = [ X(93) X(94) ];
IASWCP2A = [ X(85) X(90) ];
IASWCP2B = [ X(86) X(89) ];
IASWCP2C = [ X(87) X(88) ];
IASWCN2A = [ X(7) X(12) ];
IASWCN2B = [ X(8) X(11) ];
IASWCN2C = [ X(9) X(10) ];
IASWCPA  = [ X(13) X(18) X(25) X(30) X(37) X(42) X(49) X(54) X(61) X(66) X(73) X(78) ];
IASWCPB  = [ X(14) X(17) X(26) X(29) X(38) X(41) X(50) X(53) X(62) X(65) X(74) X(77) ];
IASWCPC  = [ X(15) X(16) X(27) X(28) X(39) X(40) X(51) X(52) X(63) X(64) X(75) X(76) ];
IASWCNA  = [ X(19) X(24) X(31) X(36) X(43) X(48) X(55) X(60) X(67) X(72) X(79) X(84) ];
IASWCNB  = [ X(20) X(23) X(32) X(35) X(44) X(47) X(56) X(59) X(68) X(71) X(80) X(83) ];
IASWCNC  = [ X(21) X(22) X(33) X(34) X(45) X(46) X(57) X(58) X(69) X(70) X(81) X(82) ];


for i = 1:12
    j = rem(i,2) + 1;
    
    if Index == IASWCPEA(j)
         Angle = IASWCEP(1);
         break;
     elseif Index == IASWCPEB(j)
         Angle = IASWCEP(2);
         break;
     elseif Index == IASWCPEC(j)
         Angle = IASWCEP(3);
         break;
         
     elseif Index == IASWCNEA(j)
         Angle = IASWCEN(1);
         break;
     elseif Index == IASWCNEB(j)
         Angle = IASWCEN(2);
         break;
     elseif Index == IASWCNEC(j)
         Angle = IASWCEN(3);
         break;
         
     elseif Index == IASWCP2A(j)
         Angle = IASWC2P(1);
         break;
     elseif Index == IASWCP2B(j)
         Angle = IASWC2P(2);
         break;
     elseif Index == IASWCP2C(j)
         Angle = IASWC2P(3);
         break;
         
     elseif Index == IASWCN2A(j)
         Angle = IASWC2N(1);
         break;
     elseif Index == IASWCN2B(j)
         Angle = IASWC2N(2);
         break;
     elseif Index == IASWCN2C(j)
         Angle = IASWC2N(3);
         break;
    
     elseif Index == IASWCPA(i)
         Angle = IASWCP(1);
         break;
     elseif Index == IASWCPB(i)
         Angle = IASWCP(2);
         break;
     elseif Index == IASWCPC(i)
         Angle = IASWCP(3);
         break;

     elseif Index == IASWCNA(i)
         Angle = IASWCN(1);
         break;
     elseif Index == IASWCNB(i)
         Angle = IASWCN(2);
         break;
     elseif Index == IASWCNC(i)
         Angle = IASWCN(3);
         break;
         
    end    
end
return


    