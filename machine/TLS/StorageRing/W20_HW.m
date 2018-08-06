function Gap = W20_HW(Angle,Index)
Energy = getenergy;
Brho = getbrho(Energy);
W20.Parameter = [22 22.3 26 30 35 40 45 50 60 70 80 90 100 110 120 130 140 ...
                 150 160 170 180 190 200 210 220 230 285]; % Gap
W20.PeakField = [1.85800442 1.83999121 1.63038117 1.42944175 1.22988308 ...
                 1.07126800 0.94573509 0.84357756 0.68074448 0.56165399 ...
		 0.46678419 0.39248674 0.33061181 0.28011830 0.23751561 ...
		 0.20211365 0.17175343 0.14642083 0.12460224 0.10633915 ...
		 0.09061517 0.07733557 0.06599265 0.05631031 0.04809014 ...
		 0.04107413 0];

% W20.Field = interp1(W20.Parameter,W20.PeakField,Gap,'linear');
% W20B22p5 = W20.Field;
% W20B22p5P1 = W20B22p5/6;
% W20B22p5P2 = -W20B22p5*2/3;
% W20K22p5 = W20B22p5/Brho;
% W20K22p5P1 = W20B22p5P1/Brho;
% W20K22p5P2 = W20B22p5P2/Brho;
% W20ABC22p5 = [0.309*W20K22p5*0.02 0.809*W20K22p5*0.02 W20K22p5*0.01];
% W20ABC22p5P1 = [0.309*W20K22p5P1*0.02 0.809*W20K22p5P1*0.02 W20K22p5P1*0.01];
% W20ABC22p5P2 = [0.309*W20K22p5P2*0.02 0.809*W20K22p5P2*0.02 W20K22p5P2*0.01];
% W20ABC22p5PX = W20ABC22p5;
% W20ABC22p5PC = -W20ABC22p5;

X = family2atindex('W20');
W20P1A = [ X(1) X(6) X(157) X(162) ];
W20P1B = [ X(2) X(5) X(158) X(161) ];
W20P1C = [ X(3) X(4) X(159) X(160) ];
W20P2A = [ X(7) X(12) X(151) X(156) ];
W20P2B = [ X(8) X(11) X(152) X(155) ];
W20P2C = [ X(9) X(10) X(153) X(154) ];
W20PXA = [ X(13) X(18) X(25) X(30) X(37) X(42) X(49) X(54) X(61) X(66) X(73) X(78) ...
           X(85) X(90) X(97) X(102) X(109) X(114) X(121) X(126) X(133) X(138) X(145) X(150) ];
W20PXB = [ X(14) X(17) X(26) X(29) X(38) X(41) X(50) X(53) X(62) X(65) X(74) X(77) ...
           X(86) X(89) X(98) X(101) X(110) X(113) X(122) X(125) X(134) X(137) X(146) X(149) ];
W20PXC = [ X(15) X(16) X(27) X(28) X(39) X(40) X(51) X(52) X(63) X(64) X(75) X(76) ...
           X(87) X(88) X(99) X(100) X(111) X(112) X(123) X(124) X(135) X(136) X(147) X(148) ];
W20PCA = [ X(19) X(24) X(31) X(36) X(43) X(48) X(55) X(60) X(67) X(72) X(79) X(84) ...
           X(91) X(96) X(103) X(108) X(115) X(120) X(127) X(132) X(139) X(144) ];
W20PCB = [ X(20) X(23) X(32) X(35) X(44) X(47) X(56) X(59) X(68) X(71) X(80) X(83) ...
           X(92) X(95) X(104) X(107) X(116) X(119) X(128) X(131) X(140) X(143) ];
W20PCC = [ X(21) X(22) X(33) X(34) X(45) X(46) X(57) X(58) X(69) X(70) X(81) X(82) ...
           X(93) X(94) X(105) X(106) X(117) X(118) X(129) X(130) X(141) X(142) ];



for i = 1:24
    if i < 5
        if Index == W20P1A(i) 
            Angle = Angle / 0.309 / 0.02 * Brho * 6;
            break;
        elseif Index == W20P1B(i)
            Angle = Angle / 0.809 / 0.02 * Brho * 6;
            break;
        elseif Index == W20P1C(i)
            Angle = Angle / 0.01 * Brho * 6;
            break;
        elseif Index == W20P2A(i)
            Angle = Angle / 0.309 / 0.02 * Brho / (-2) * 3;
            break;
        elseif Index == W20P2B(i)
            Angle = Angle / 0.809 / 0.02 * Brho / (-2) * 3;
            break;
        elseif Index == W20P2C(i)
            Angle = Angle / 0.01 * Brho / (-2) * 3;
            break;
        end
    end
     
    if Index == W20PXA(i)
        Angle = Angle / 0.309 / 0.02 * Brho;
        break;
    elseif Index == W20PXB(i)
        Angle = Angle / 0.809 / 0.02 * Brho;
        break;
    elseif Index == W20PXC(i)
        Angle = Angle / 0.01 * Brho;
        break;
    end
     
    if i < 23
        if Index == W20PCA(i) 
            Angle = -Angle / 0.309 / 0.02 * Brho;
            break;
        elseif Index == W20PCB(i) 
            Angle = -Angle / 0.809 / 0.02 * Brho;
            break;
        elseif Index == W20PCC(i) 
            Angle = -Angle / 0.01 * Brho;
            break;
        end
    end
             
end
Gap = interp1(W20.PeakField,W20.Parameter,Angle,'linear');
return


    