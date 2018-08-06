function Angle = U5(Gap,Index)
Energy = getenergy;
Brho = getbrho(Energy);
U5.Parameter = [14 18 19 20 22 25 27 30 35 40 45 50 60 70 120 230 250]; % Gap
U5.PeakField = [0.91533720 0.67329090 0.63140240 0.58600030 0.51216510 ...
                0.41593170 0.36989030 0.30280650 0.22158930 0.15936110 ...
		0.11580370 0.08483674 0.04426467 0.02305669 0.00103300 ...
		0.000000001 0.00000000];

U5.Field = interp1(U5.Parameter,U5.PeakField,Gap,'linear');
%[PE N1 P2 NN PN N2 P1 NE] = [56/916 -32/61 58/61 -1 1 -58/61 32/61 -56/918]
U5B0 = U5.Field;
U5PEB0 = U5B0*56/916; % U5NEB0 = -U5PEB0;
U5P1B0 = U5B0*32/61; % U5N1B0 = -U5P1B0;
U5P2B0 = U5B0*58/61; % U5N2B0 = -U5P2B0;
U5K = U5B0/Brho;
U5PEK = U5PEB0/Brho;
U5P1K = U5P1B0/Brho;
U5P2K = U5P2B0/Brho;
U5P = [0.309*U5K*0.005 0.809*U5K*0.005 U5K*0.0025];
U5PEP = [0.309*U5PEK*0.005 0.809*U5PEK*0.005 U5PEK*0.0025];
U5P1P = [0.309*U5P1K*0.005 0.809*U5P1K*0.005 U5P1K*0.0025];
U5P2P = [0.309*U5P2K*0.005 0.809*U5P2K*0.005 U5P2K*0.0025];
U5N = -U5P;
U5NEP = -U5PEP;
U5N1P = -U5P1P;
U5N2P = -U5P2P;

X = family2atindex('U5');

U5PEA = [ X(1) X(6) ];
U5PEB = [ X(2) X(5) ];
U5PEC = [ X(3) X(4) ];
U5NEA = [ X(931) X(936) ];
U5NEB = [ X(932) X(935) ];
U5NEC = [ X(933) X(934) ];
U5P1A = [ X(925) X(930) ];
U5P1B = [ X(926) X(929) ];
U5P1C = [ X(927) X(928) ];
U5N1A = [ X(7) X(12) ];
U5N1B = [ X(8) X(11) ];
U5N1C = [ X(9) X(10) ];
U5P2A = [ X(13) X(18) ];
U5P2B = [ X(14) X(17) ];
U5P2C = [ X(15) X(16) ];
U5N2A = [ X(919) X(924) ];
U5N2B = [ X(920) X(923) ];
U5N2C = [ X(921) X(922) ];

for k = 1:75
    U5PNA(k) = struct('A', X(25)+12*(k-1),'B', X(30)+12*(k-1));
    U5PNB(k) = struct('A', X(26)+12*(k-1),'B', X(29)+12*(k-1));
    U5PNC(k) = struct('A', X(27)+12*(k-1),'B', X(28)+12*(k-1));
    U5NNA(k) = struct('A', X(19)+12*(k-1),'B', X(24)+12*(k-1));
    U5NNB(k) = struct('A', X(20)+12*(k-1),'B', X(23)+12*(k-1));
    U5NNC(k) = struct('A', X(21)+12*(k-1),'B', X(22)+12*(k-1));
end


for i = 1:75
    if i < 3
        if Index == U5PEA(i) 
            Angle = U5PEP(1);
            break;
        elseif Index == U5PEB(i)
            Angle = U5PEP(2);
            break;
        elseif Index == U5PEC(i)
            Angle = U5PEP(3);
            break;
            
        elseif Index == U5NEA(i)
            Angle = U5NEP(1);
            break;
        elseif Index == U5NEB(i)
            Angle = U5NEP(2);
            break;
        elseif Index == U5NEC(i)
            Angle = U5NEP(3);
            break;
            
        elseif Index == U5P1A(i)
            Angle = U5P1P(1);
            break;
        elseif Index == U5P1B(i)
            Angle = U5P1P(2);
            break;
        elseif Index == U5P1C(i)
            Angle = U5P1P(3);
            break;
            
        elseif Index == U5N1A(i)
            Angle = U5N1P(1);
            break;
        elseif Index == U5N1B(i)
            Angle = U5N1P(2);
            break;
        elseif Index == U5N1C(i)
            Angle = U5N1P(3);
            break;
            
        elseif Index == U5P2A(i)
            Angle = U5P2P(1);
            break;
        elseif Index == U5P2B(i)
            Angle = U5P2P(2);
            break;
        elseif Index == U5P2C(i)
            Angle = U5P2P(3);
            break;
            
        elseif Index == U5N2A(i)
            Angle = U5N2P(1);
            break;
        elseif Index == U5N2B(i)
            Angle = U5N2P(2);
            break;
        elseif Index == U5N2C(i)
            Angle = U5N2P(3);
            break;
            
        end
    end
     
    if (Index == U5PNA(i).A || Index == U5PNA(i).B)
        Angle = U5P(1);
        break;
    elseif (Index == U5PNB(i).A || Index == U5PNB(i).B)
        Angle = U5P(2);
        break;
    elseif (Index == U5PNC(i).A || Index == U5PNC(i).B)
        Angle = U5P(3);
        break;
        
    elseif (Index == U5NNA(i).A || Index == U5NNA(i).B)
        Angle = U5N(1);
        break;
    elseif (Index == U5NNB(i).A || Index == U5NNB(i).B)
        Angle = U5N(2);
        break;
    elseif (Index == U5NNC(i).A || Index == U5NNC(i).B)
        Angle = U5N(3);
        break;
    end

             
end
return


    