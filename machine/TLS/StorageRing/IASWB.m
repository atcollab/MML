function Angle = IASWB(Amps,Index)
Energy = getenergy;
Brho = getbrho(Energy);
IASWB.Parameter = [0 10.0406 11.9611 12.7613 13.7216 14.8418 15.9621 16.4422 ...
                   17.8826 18.6828 19.483 20.4432 49.8906 100.463 200.328 ...
		   250.412 262.904 276.187 288.83]; % Current
IASWB.PeakField = [0 0.5013 0.5577 0.5768 0.5998 0.6234 0.6461 0.6553 0.6812 ...
                   0.695 0.708 0.7214 1.0981 1.6089 2.5348 2.9927 3.1 3.22 ...
		   3.3397];

IASWB.Field = interp1(IASWB.Parameter,IASWB.PeakField,Amps,'linear');
IASWBB0 = IASWB.Field;
IASWBEB0 = IASWBB0*(125325/501300);
IASWB2B0 = IASWBB0*(375975/501300);
IASWBK = IASWBB0/Brho;
IASWBEK = IASWBEB0/Brho;
IASWB2K = IASWB2B0/Brho;
IASWBP = [0.309*IASWBK*0.0061 0.809*IASWBK*0.0061 IASWBK*0.00305];
IASWBEP = [0.309*IASWBEK*0.0061 0.809*IASWBEK*0.0061 IASWBEK*0.00305];
IASWB2P = [0.309*IASWB2K*0.0061 0.809*IASWB2K*0.0061 IASWB2K*0.00305];
IASWBN = -IASWBP;
IASWBEN = -IASWBEP;
IASWB2N = -IASWB2P;

X = family2atindex('IASWB');
IASWBPEA = [ X(1) X(6) ];
IASWBPEB = [ X(2) X(5) ];
IASWBPEC = [ X(3) X(4) ];
IASWBNEA = [ X(91) X(96) ];
IASWBNEB = [ X(92) X(95) ];
IASWBNEC = [ X(93) X(94) ];
IASWBP2A = [ X(85) X(90) ];
IASWBP2B = [ X(86) X(89) ];
IASWBP2C = [ X(87) X(88) ];
IASWBN2A = [ X(7) X(12) ];
IASWBN2B = [ X(8) X(11) ];
IASWBN2C = [ X(9) X(10) ];
IASWBPA  = [ X(13) X(18) X(25) X(30) X(37) X(42) X(49) X(54) X(61) X(66) X(73) X(78) ];
IASWBPB  = [ X(14) X(17) X(26) X(29) X(38) X(41) X(50) X(53) X(62) X(65) X(74) X(77) ];
IASWBPC  = [ X(15) X(16) X(27) X(28) X(39) X(40) X(51) X(52) X(63) X(64) X(75) X(76) ];
IASWBNA  = [ X(19) X(24) X(31) X(36) X(43) X(48) X(55) X(60) X(67) X(72) X(79) X(84) ];
IASWBNB  = [ X(20) X(23) X(32) X(35) X(44) X(47) X(56) X(59) X(68) X(71) X(80) X(83) ];
IASWBNC  = [ X(21) X(22) X(33) X(34) X(45) X(46) X(57) X(58) X(69) X(70) X(81) X(82) ];


for i = 1:12
    j = rem(i,2) + 1;
    
    if Index == IASWBPEA(j)
         Angle = IASWBEP(1);
         break;
     elseif Index == IASWBPEB(j)
         Angle = IASWBEP(2);
         break;
     elseif Index == IASWBPEC(j)
         Angle = IASWBEP(3);
         break;
         
     elseif Index == IASWBNEA(j)
         Angle = IASWBEN(1);
         break;
     elseif Index == IASWBNEB(j)
         Angle = IASWBEN(2);
         break;
     elseif Index == IASWBNEC(j)
         Angle = IASWBEN(3);
         break;
         
     elseif Index == IASWBP2A(j)
         Angle = IASWB2P(1);
         break;
     elseif Index == IASWBP2B(j)
         Angle = IASWB2P(2);
         break;
     elseif Index == IASWBP2C(j)
         Angle = IASWB2P(3);
         break;
         
     elseif Index == IASWBN2A(j)
         Angle = IASWB2N(1);
         break;
     elseif Index == IASWBN2B(j)
         Angle = IASWB2N(2);
         break;
     elseif Index == IASWBN2C(j)
         Angle = IASWB2N(3);
         break;
    
     elseif Index == IASWBPA(i)
         Angle = IASWBP(1);
         break;
     elseif Index == IASWBPB(i)
         Angle = IASWBP(2);
         break;
     elseif Index == IASWBPC(i)
         Angle = IASWBP(3);
         break;

     elseif Index == IASWBNA(i)
         Angle = IASWBN(1);
         break;
     elseif Index == IASWBNB(i)
         Angle = IASWBN(2);
         break;
     elseif Index == IASWBNC(i)
         Angle = IASWBN(3);
         break;
         
    end    
end
return


    