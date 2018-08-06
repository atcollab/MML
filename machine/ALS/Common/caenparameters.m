function [Caen, BaseName] = caenparameters(Section, DevName)
%CAENPARAMETERS - Returns the setup parameters for the Caen power supplies
%
% caenparameters('GTB')
% caenparameters('BTS')
% caenparameters('SR')
% caenparameters('SR60')
%
%  See also setcaen, checkcaen

% Written by Greg Portmann

% To do:
% *  Add the 60 A units to SR or add SR60


if nargin < 1 || strcmpi(Section,'GTB')
    
    PIDScaleFactor = .8;
    
    BaseName = {
        'GTL:BC1'
        'GTL:BC2'
        'GTL:HCM1'
        'GTL:VCM1'
        'GTL:HCM2'
        'GTL:VCM2'
        'GTL:HCM3'
        'GTL:VCM3'
        'GTL:HCM4'
        'GTL:VCM4'
        'LN:HCM1'
        'LN:VCM1'
        'LN:HCM2'
        'LN:VCM2'
        'LN:Q1_1'
        'LN:Q1_2'
        'LTB:Q1_1'
        'LTB:Q1_2'
        'LTB:Q2'
        'LTB:HCM1'
        'LTB:HCM2'
        'LTB:Q3_1'
        'LTB:Q3_2'
        'LTB:VCM1'
        'LTB:VCM2'
        'LTB:VCM3'
        'LTB:VCM4'
        'LTB:VCM5'
        'LTB:VCM6'
        'LTB:VCM7'
        'LTB:B3'
        'LTB:Q4_1'
        'LTB:Q4_2'
        'LTB:Q5'
        'LTB:Q6'};
    
    Data = [
        0.0316  0.0007    0 11.6500000   0.04106  -1.500 1.500 5
        0.0316  0.0007    0 11.7100000   0.03922  -1.500 1.500 5
        0.0567  0.00014   0  1.9780000   0.001422 -4.000 4.000 5
        0.0567  0.00014   0  2.0710000   0.00144  -4.000 4.000 5
        0.0216  0.000856  0  1.5160000   0.001431 -4.000 4.000 5
        0.0216  0.000856  0  1.6390000   0.001429 -4.000 4.000 5
        0.0216  0.000856  0  1.4680000   0.00139  -4.000 4.000 5
        0.0216  0.000856  0  1.5140000   0.00141  -4.000 4.000 5
        0.0216  0.000856  0  1.4340000   0.001384 -4.000 4.000 5
        0.0216  0.000856  0  1.4470000   0.001392 -4.000 4.000 5
        0.0532  0.000976  0  5.0160000   0.01406  -4.000 4.000 5
        0.0532  0.000976  0  4.9720000   0.01357  -4.000 4.000 5
        0.0532  0.000976  0  4.9650000   0.01252  -4.000 4.000 5
        0.0532  0.000976  0  4.9480000   0.01295  -4.000 4.000 5
        0.1155  0.000134  0  1.4940000   0.0685    0.000 10.00 5
        0.1191  0.000175  0  0.9680000   0.03496   0.000 10.00 5
        0.114   0.000139  0  1.7500000   0.07479  -0.500 8.000 5
        0.1191  0.000175  0  0.9400000   0.03721  -0.500 8.000 5
        0.1191  0.000175  0  0.9600000   0.03698  -0.500 8.000 5
        0.0588  7.88e-05  0  1.2040000   0.04798  -2.900 2.900 5
        0.0588  7.88e-05  0  1.1210000   0.04922  -2.900 2.900 5
        0.1191  0.000175  0  0.9770000   0.03747  -0.500 8.000 5
        0.1191  0.000175  0  0.9750000   0.03742  -0.500 8.000 5
        0.0594  6.688e-05 0  1.1340000   0.04913  -2.900 2.900 5
        0.0594  6.688e-05 0  1.0350000   0.04929  -2.900 2.900 5
        0.0594  6.688e-05 0  1.0770000   0.04877  -2.900 2.900 5
        0.0594  6.688e-05 0  1.1380000   0.04867  -2.900 2.900 5
        0.0594  6.688e-05 0  0.9090000   0.04842  -2.900 2.900 5
        0.0594  6.688e-05 0  0.8900000   0.04873  -2.900 2.900 5
        0.0594  6.688e-05 0  0.8950000   0.04706  -2.900 2.900 5
        0.2262  0.0003628 0  1.9540000   0.06271  -1.00 10.000 1
        0.12    0.000159  0  0.8440000   0.03743  -0.500 8.000 5
        0.12    0.000159  0  0.8440000   0.03755  -0.500 8.000 5
        0.12    0.000159  0  0.8230000   0.03729  -0.500 8.000 5
        0.12    0.000159  0  0.8180000   0.03745  -0.500 8.000 5
        ];
    PID = PIDScaleFactor * Data(:,1:3);
    R = Data(:,4);
    L = Data(:,5);
    Range = Data(:,6:7);
    SlewRate = Data(:,8);
    
    PS_Model = 'SY3634';
    Location = 'GTB';
    
    
elseif strcmpi(Section,'BTS')
    
    PIDScaleFactor = .8;
    
    BaseName = {
        'BTS:HCM1'
        'BTS:HCM2'
        'BTS:VCM1'
        'BTS:VCM2'
        'BTS:HCM3'
        'BTS:HCM4'
        'BTS:VCM3'
        'BTS:VCM4'
        'BTS:HCM5'
        'BTS:HCM6'
        'BTS:HCM7'
        'BTS:VCM5'
        'BTS:VCM6'
        'BTS:VCM7'
        'BTS:HCM8'
        'BTS:VCM8'
        'BTS:HCM9'
        'BTS:VCM9'};
    
    Data = [
        0.095       3e-05 0  4.9300000     0.8242 -4.000 4.000 1
        0.095       3e-05 0  4.8470000     0.8262 -4.000 4.000 1
        0.095       3e-05 0  4.9000000     0.8211 -4.000 4.000 1
        0.095       3e-05 0  4.7900000     0.8241 -4.000 4.000 1
        0.1145   3.68e-05 0  1.5590000     0.2585 -5.000 5.000 5
        0.1145   3.68e-05 0  1.5570000     0.2618 -5.000 5.000 5
        0.1145   3.68e-05 0  1.5320000     0.2613 -5.000 5.000 5
        0.1145   3.68e-05 0  1.4290000     0.2643 -5.000 5.000 5
        0.1145   3.68e-05 0  0.0000000          0 -5.000 5.000 5
        0.1145   3.68e-05 0  0.0000000          0 -5.000 5.000 5
        0.1145   3.68e-05 0  0.0000000          0 -5.000 5.000 5
        0.1145   3.68e-05 0  0.9561753          0 -5.000 5.000 5
        0.1145   3.68e-05 0  0.9470260          0 -5.000 5.000 5
        0.1145   3.68e-05 0  0.8400000          0 -5.000 5.000 5
        0.095       3e-05 0  0.0000000          0 -3.900 3.900 1
        0.095       3e-05 0  0.0000000          0 -3.900 3.900 1
        0.095       3e-05 0  0.0000000          0 -3.900 3.900 1
        0.095       3e-05 0  0.0000000          0 -3.900 3.900 1
        ];
    PID      = Data(:,1:3) * PIDScaleFactor;
    R        = Data(:,4);
    L        = Data(:,5);
    Range    = Data(:,6:7);
    SlewRate = Data(:,8);
    
    PS_Model = 'SY3634';
    Location = 'BTS';
    
    
elseif strcmpi(Section,'SR')
    
    % 20 Amps units
    BaseName = {
        'SR01C:SQSD1'  % new
        'SR01C:SQSF1'
        'SR02C:SQSD1'
        'SR02C:SQSF1'  % new
        'SR03C:SQSD1'
        'SR03C:SQSD2'
        'SR03C:SQSF1'
        'SR03C:SQSF2'
        'SR04C:SQSD1'
        'SR04C:SQSF1'  % new
        'SR05C:SQSD1'
        'SR05C:SQSD2'
        %        'SR05C:SQSF1'  % Resistance too high for Caen
        'SR05C:SQSF2'
        'SR06C:SQSD1'
        'SR06C:SQSD2'
        %        'SR06C:SQSF1'  % Resistance too high for Caen
        'SR06C:SQSF2'
        'SR07C:SQSD1'
        'SR07C:SQSD2'
        'SR07C:SQSF1'
        'SR07C:SQSF2'
        'SR08C:SQSD1'
        'SR08C:SQSF1'  % new
        'SR09C:SQSD1'  % new
        'SR09C:SQSF1'
        'SR10C:SQSD1'
        'SR10C:SQSF1'  % new
        'SR11C:SQSD1'
        'SR11C:SQSF1'
        'SR12C:SQSD1'
        'SR12C:SQSF1'  % new
        'SR04U:HCM2'
        'SR04U:VCM2'
        'SR06U:HCM2'
        'SR06U:VCM2'
        'SR07U:HCM2'
        'SR07U:VCM2'
        'SR11U:HCM2'
        'SR11U:VCM2'
        'SR04U:Q1'
        'SR04U:Q2'
        %'SR06U:Q1'    % IVID doesn't have a skew
        'SR06U:Q2'
        'SR07U:Q1'
        'SR07U:Q2'
        'SR11U:Q1'
        'SR11U:Q2'
        };
    
    Data = [
        0.2483	0.00108	0	5  % new
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5  % new
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5   % new 'SR04C:SQSF1'
        0.100   0.0003	0	50  % Corrector
        0.100   0.0003	0	50  % Corrector
        %       0.100   0.0003	0	50  % 'SR05C:SQSF1' (Resistance too high for Caen)
        0.100   0.0003	0	50  % Corrector  (about 11 Hz, tau = .015 seconds)
        0.2483	0.00108	0	5   % 'SR06C:SQSD1'
        0.2483	0.00108	0	5   % 'SR06C:SQSD2'
        %       0.100   0.0003	0	5   % 'SR06C:SQSF1' (Resistance too high for Caen)
        0.2483	0.00108	0	5   % 'SR06C:SQSF2'
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5
        0.100   0.0003	0	50  % Corrector
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5  % new
        0.2483	0.00108	0	5  % new
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5  % new
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5
        0.2483	0.00108	0	5  % new 'SR12C:SQSF1'
        0.010   0.0025	0	1000  % 'SR04U:HCM2'
        0.019	0.0013	0	1000  % 'SR04U:VCM2'
        0.0125	0.002	0	1000  % 'SR06U:HCM2'
        0.028	0.002	0	1000  % 'SR06U:VCM2'
        0.0125	0.002	0	1000  % "SR07U:HCM2'
        0.028	0.0002	0	1000  % 'SR07U:VCM2'
        0.01	0.0020  0	1000  % 'SR11U:HCM2'
        0.01	0.0020  0	1000  % 'SR11U:VCM2'
        0.2483	0.00108 0 	 100  % 'SR04U:SQ1
        0.2483	0.00108	0	 100  % 'SR04U:SQ2
        0.02	0.0015	0	 100  % 'SR06U:SQ2
        0.02	0.0015	0	 100  % 'SR07U:SQ1
        0.02	0.0015	0	 100  % 'SR07U:SQ2
        0.02	0.001 	0	 100  % 'SR11U:SQ1
        0.02	0.001 	0	 100  % 'SR11U:SQ2
        ];
    
    PID = Data(:,1:3);
    R   = NaN * Data(:,3);
    L   = NaN * Data(:,3);
    SlewRate = Data(:,4);
    Range = 20 * ones(size(Data,1),1);
    Range([end-1 end]) = 11.5;
    
    PS_Model = 'SY3634';
    Location = 'SR';
    
    
elseif strcmpi(Section,'SR60')
    % 60 Amps units
    BaseName = {
        'SR01C:SQSHD1'
        'SR01C:SQSHF2'
        'SR02C:SQSHF1'
        'SR02C:SQSHF2'
        'SR03C:SQSHF1'
        'SR03C:SQSHF2'
        'SR04C:SQSHF1'
        'SR04C:SQSHF2'
        'SR05C:SQSHF1'
        'SR05C:SQSHF2'
        'SR06C:SQSHF1'
        'SR06C:SQSHF2'
        'SR07C:SQSHF1'
        'SR07C:SQSHF2'
        'SR08C:SQSHF1'
        'SR08C:SQSHF2'
        'SR09C:SQSHF1'
        'SR09C:SQSHF2'
        'SR10C:SQSHF1'
        'SR10C:SQSHF2'
        'SR11C:SQSHF1'
        'SR11C:SQSHF2'
        'SR12C:SQSHF1'
        'SR12C:SQSHD2'
        };
    
    for i = 1:length(BaseName)
        PID(i,:) = [0.00075	0.000025	0];
        R(i,:)   = 0.0760;
        L(i,:)   = 2.0550;
        SlewRate(i,:) = 10;
        Range(i,:) = 50;
    end
    
    PS_Model = 'SY3662';
    Location = 'SR';
    
else
    error('Accelerator section not defined.');
end


% Convert to structure output
for i = 1:size(BaseName,1)
    Caen(i,1).Name = BaseName{i};
    Caen(i,1).SN = NaN;
    Caen(i,1).R = R(i,1);
    Caen(i,1).L = L(i,1);
    Caen(i,1).Kp = PID(i,1);
    Caen(i,1).Ki = PID(i,2);
    Caen(i,1).Kd = PID(i,3);
    Caen(i,1).Limit    = abs(max(Range(i,:)));
    Caen(i,1).SlewRate = abs(SlewRate(i,1));
    Caen(i,1).Model    = PS_Model;
    Caen(i,1).Location = Location;
end


if nargin >= 2
    % Select power supplies
    
    if isempty(DevName) || (iscell(DevName) && isempty(DevName{1}))
        % Select from the whole list
        [BaseName, Index, CloseFlag] = editlist(BaseName, ' ', 0);
        if CloseFlag || isempty(Index)
            fprintf('   Nothing selected in %s\n', Section);
            Caen = [];
            BaseName = '';
            return
        end
        Caen = Caen(Index);
    elseif ischar(DevName)
        % Only if in the list
        %Index = findrowindex(DevName, BaseName);
        Index = find(strcmpi(DevName, BaseName));
        if isempty(Index)
            fprintf('   No BaseName match in section %s\n', Section);
            Caen = [];
            BaseName = '';
            return
        end
        Caen = Caen(Index);
    elseif iscell(DevName)
        % Only if in the list
        Index = [];
        for i = 1:length(DevName)
            i = find(strcmpi(DevName{i}, BaseName));
            if ~isempty(i)
                Index = [Index; i];
            end
        end
        if isempty(Index)
            fprintf('   No BaseName match in section %s\n', Section);
            Caen = [];
            BaseName = '';
            return
        end
        Caen = Caen(Index);
    end
end



