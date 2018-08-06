function coeff = magnetcoefficients(MagnetCoreType)
% C = magnetcoefficients(MagnetCoreType)

if nargin < 1
    error('MagnetCoreType input required');
end

% For a string matrix
if iscell(MagnetCoreType)
    for i = 1:size(MagnetCoreType,1)
        for j = 1:size(MagnetCoreType,2)
            [C{i,j}, Leff{i,j}, MagnetType{i,j}, A{i,j}] = magnetcoefficients(MagnetCoreType{i});
        end
    end
    return
end

% For a string matrix
if size(MagnetCoreType,1) > 1
    C=[]; Leff=[]; MagnetType=[]; A=[];
    for i = 1:size(MagnetCoreType,1)
        [C1, Leff1, MagnetType1, A1] = magnetcoefficients(MagnetCoreType(i,:));
        C(i,:) = C1;
        Leff(i,:) = Leff1;
        MagnetType = strvcat(MagnetType, MagnetType1);
        A(i,:) = A1;
    end
    return
end


switch upper(deblank(MagnetCoreType))

    % might need to add the cases for LTB
%     case 'LTB_BEND'
%     case 'LTB_QUAD'
%     case 'LTB_HCOR'
%     case 'LTB_VCOR'
    case 'BD1'    % BD magnet on power supply one
        Leff = 1.15;

        I = [0 100 200	300	400	500	600	700	800	900];
        bd1 = [0 0.17634465,0.354729813,0.53331,0.71168175,0.889471688,1.066861063,1.240527563,1.401435875,1.5250375]/1.15;

        % Generate extra points to 'enhance' the linearity
        % at lower currents.
        [C S mu] = polyfit(I(1:4),bd1(1:4),1);
        I_gen = [25 50 150 250 350];
        bd1_gen = polyval(C,I_gen,[],mu);
        [I ind] = sort([I I_gen]);
        bd1_temp = [bd1 bd1_gen];
        bd1 = bd1_temp(ind);
        
        [C S mu] = polyfit(I,bd1,7);

        MagnetType = 'bend';

    case 'BD2'    % BD magnet on power supply two
        Leff = 1.15;
        I = [0 100	200	300	400	500	600	700	800	900];
        bd2 = [0 0.176389419,0.354823156,0.533456813,0.711890188,0.889591313,1.0672725,1.241055,1.401981438,1.525468875]/1.15;

        % Generate extra points to 'enhance' the linearity
        % at lower currents.
        [C S mu] = polyfit(I(1:4),bd2(1:4),1);
        I_gen = [25 50 150 250 350];
        bd2_gen = polyval(C,I_gen,[],mu);
        [I ind] = sort([I I_gen]);
        bd2_temp = [bd2 bd2_gen];
        bd2 = bd2_temp(ind);
        
        [C S mu] = polyfit(I,bd2,7);
        
        MagnetType = 'bend';

    case 'BF'    % BF magnet
        Leff = 1.35;
        I = [0 100	200	300	400	500	600	700	800	900];
        bf = [0 0.071244,0.143297,0.215689,0.288220,0.360674,0.433309,0.505555,0.577666,0.649690]/1.35;

        % Generate extra points to 'enhance' the linearity
        % at lower currents.
        [C S mu] = polyfit(I(1:4),bf(1:4),1);
        I_gen = [25 50 150 250 350];
        bf_gen = polyval(C,I_gen,[],mu);
        [I ind] = sort([I I_gen]);
        bf_temp = [bf bf_gen];
        bf = bf_temp(ind);
        
        [C S mu] = polyfit(I,bf,7);
        
        MagnetType = 'bend';

    case 'QD'
        I = [0	10	20	30	40	50	60	70	80	85	90	95	100];
        % Values during ramp up
        qd1 = [0.0000,0.8029,1.5721,2.3438,3.1168,3.8904,4.6649,5.4400,6.2165,6.6038,6.9918,7.3804,7.7691];
        % values during ramp down
%         qd2 = [0.0466,0.8207,1.5961,2.3721,3.1489,3.9238,4.6974,5.4692,6.2405,6.6238,7.0068,7.3883,7.7691];
        % take average of the two;
%         qd_average = mean([qd1; qd2],1);
%         [C S mu] = polyfit(I,qd_average,8);
        [C S mu] = polyfit(I,qd1,5);

    case {'QF'}
        I = [0	25	50	75	100	125	150	175	200	225	250	275	300	325	350	375	400	425	450	475	500];
        % Values during ramp up
        qf1 = [ 0.000, 1.596, 3.138, 4.687, 6.238, 7.792, 9.349,10.905,12.461,14.017,15.571,17.124,18.678,20.225,21.767,23.301,24.815,26.279,27.627,28.828,29.919];
        % values during ramp down
%         qf2 = [ 0.067, 1.622, 3.181, 4.741, 6.300, 7.859, 9.419,10.977,12.535,14.093,15.649,17.204,18.760,20.309,21.854,23.389,24.904,26.366,27.696,28.867,29.919];
        % take average of the two;
%         qf_average = mean([qf1; qf2],1);
%         [C S mu] = polyfit(I,qf_average,8);
        [C S mu] = polyfit(I,qf1,5);

    case {'SF'}
        I = [0	1.69	5.004	8.413	10.007	15.011	16.805	20.035];
        sf = [1.744635576	34.0891218	97.17091481	162.3039763	192.808665	289.0808282	323.6034655	386.040272];
        [C S mu] = polyfit(I,sf,5);
        
        MagnetType = 'sext';

    case {'SD'}
        I = [0	5.048	10.069	15.098	19.323	20.142	25.149];
        sd = [-3.568572769	-131.5613828	-260.7701509	-390.9834061	-499.1508119	-520.2979097	-649.5066779];
        [C S mu] = polyfit(I,sd,5);
        
        MagnetType = 'sext';
        
    case 'HCM'    % 15 cm horizontal corrector
        % Magnet Spec: Theta = 1.5e-3 radians @ 3 GeV and 30 amps
        % Theta = BLeff / Brho    [radians]
        % Therefore,
        %       Theta = ((BLeff/Amp)/ Brho) * I 
        %       BLeff/Amp = 1.5e-3 * getbrho(3) / 30
        %       B*Leff = a0 * I   => a0 = 1.5e-3 * getbrho(3) / 30
        %
        % The C coefficients are w.r.t B
        %       B = c0 + c1*I = (0 + a0*I)/Leff 
        % However, AT uses Theta in radians so the A coefficients  
        % must be used for correctors with the middle layer with 
        % the addition of the DC term
        
        % Find the current from the given polynomial for BLeff and B
        % NOTE: AT used BLeff (A) for correctors
        Leff = 0.2;
        I = [0	1.011	2.01	3.01	4.006	5.005	6	7.014	8.012	9.008	9.9055	10.005];
        B = -Leff*[0.000095	0.00655	0.012905	0.019265	0.025615	0.03199	0.03834	0.044815	0.05118	0.057545	0.063315	0.06392];
        
        [C S mu] = polyfit(I,B,1);
        
        MagnetType = 'COR';       
        
    case 'VCM'    % 15 cm vertical corrector
        Leff = 0.2;
        I = [0	1.011	2.011	3.01	4.005	5.005	6.018	7.013	8.011	9.007	9.904	10.004];
        B = -Leff*[0.000065	0.006585	0.012985	0.0194	0.025785	0.03222	0.038735	0.04514	0.051565	0.057975	0.06375	0.064395];
        
        [C S mu] = polyfit(I,B,1);

        MagnetType = 'COR';       

otherwise 
        error(sprintf('MagnetCoreType %s is not unknown', MagnetCoreType));
        %k = 0;
        %MagnetType = '';
        %return
end

coeff = [mu' C];

% Power Series Denominator (Factoral) be AT compatible
% if strcmpi(MagnetType,'SEXT')
%     C = C / 2;
% end
% if strcmpi(MagnetType,'OCTO')
%     C = C / 6;
% end
