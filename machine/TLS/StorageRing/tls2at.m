function k = tls2at(Family, Field, Amps, DeviceList, Energy)
%TLS2AT - Converts amperes to simulator values
%  K = tls2at(Family, Field, Amps, DeviceList, Energy)
%
%  INPUTS
%  1. Family - Family name
%  2. Field - Sub-field (like 'Setpoint')
%  3. Amps - Ampere
%  4. DeviceList - Device list (Amps and DeviceList must have the same number of rows)
%  5. Energy - Energy in GeV {Default: getenergy}
%              If Energy is a vector, each output column will correspond to that energy.
%              Energy can be anything getenergy accepts, like 'Model' or 'Online'.
%              (Note: If Energy is a vector, then Amps can only have 1 column)
%
%  OUTPUTS
%  1. K - "K-value" (AT convention)
%     For dipole:      K = B / Brho
%     For quadrupole:  K = B'/ Brho
%     For sextupole:   K = B"/ Brho / 2
%
%  See also at2tls, hw2physics, physics2hw
global THERING

if nargin < 3
    error('At least 3 input required');
end

if isempty(Field)
    Field = 'Setpoint';
end

if nargin < 4
    DeviceList = [];
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end

if nargin < 5
    Energy = [];
end
if isempty(Energy)
    Energy = getenergy;
elseif ischar(Energy)
    Energy = getenergy(Energy);
end


if size(Amps,1) == 1 && length(DeviceList) > 1
    Amps = ones(size(DeviceList,1),1) * Amps;
elseif size(Amps,1) ~= size(DeviceList,1)
    error('Rows in Amps must equal rows in DeviceList or be a scalar');
end


if all(isnan(Amps))
    k = Amps;
    return
end


% Force Energy and Amps to have the same number of columns
if all(size(Energy) > 1)
    error('Energy can only be a scalar or vector');
end
Energy = Energy(:)';

if length(Energy) > 1
    if size(Amps,2) == size(Energy,2)
        % OK
    elseif size(Amps,2) > 1
        error('If Energy is a vector, then Amps can only have 1 column.');
    else
        % Amps has one column, expand to the size of Energy
        Amps = Amps * ones(1,size(Energy,2));
    end
else
    Energy = Energy * ones(1,size(Amps,2));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setpoint and Monitor Fields %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmpi(Field, {'Setpoint','Monitor'}))
    if strcmpi(Family, 'HCM')
        % HCM
        % Rad = BLeff / Brho
        Brho = getbrho(Energy);
        % BLeffPerI = 0.001;   % ????
        % k = BLeffPerI .* Amps ./ Brho;

        HCM_C=[
            1 3
            1 8
            2 2
            2 7
            3 2
            3 6
            4 3
            4 7
            5 2
            5 7
            6 2
            6 6]; % 02/02/2009

        HCM_A=[
            1 4
            1 9
            2 1
            2 3
            2 8
            3 1
            3 3
            3 7
            4 8
            5 1
            5 3
            5 8
            6 1
            6 3]; % 02/02/2009

        HCM_SF=[
            1 5
            1 6
            2 4
            2 5
            3 4
            3 5
            4 4
            4 5
            5 4
            5 5
            6 4
            6 5];% 02/02/2009

        HCM_a48=[
            1 7
            2 6
            4 1
            4 2
            4 6
            5 6];% 02/02/2009

        HCM_c40=[
            1 1
            1 2];% 02/02/2009

        HCM_a1=[
            6 7];% 02/02/2009

        for i = 1:size(DeviceList,1)
            for j = 1:size(HCM_C,1)
                if all(DeviceList(i,:) == HCM_C(j,:))
                    BLeffPerI =  6.04484402e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(HCM_A,1)
                if all(DeviceList(i,:) == HCM_A(j,:))
                    BLeffPerI =  3.36e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(HCM_SF,1)
                if all(DeviceList(i,:) == HCM_SF(j,:))
                    BLeffPerI =  3.9460603e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(HCM_a48,1)
                if all(DeviceList(i,:) == HCM_a48(j,:))
                    BLeffPerI =  2.24e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(HCM_c40,1)
                if all(DeviceList(i,:) == HCM_c40(j,:))
                    BLeffPerI =  1.879528e-3;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(HCM_a1,1)
                if all(DeviceList(i,:) == HCM_a1(j,:))
                    BLeffPerI =  3.031977e-3;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end


            if nargout >= 2
                Leff = 1;
                B(i,:) = BLeffPerI .* Amps(i,:) ./ Leff;
            end
        end
        return


    elseif strcmpi(Family, 'VCM')
        % VCM
        % Rad = BLeff / Brho
        Brho = getbrho(Energy);
        %BLeffPerI = 0.001;   % ????
        %k = BLeffPerI .* Amps ./ Brho;

        VCM_B=[
            1 5
            2 4
            3 5
            4 4
            4 7
            5 2
            6 5
            6 7];% 02/02/2009

        VCM_A=[
            1 3
            1 8
            2 1
            2 2
            2 7
            3 2
            3 3
            3 7
            4 8
            5 1
            5 3
            5 8
            6 2
            6 3];% 02/02/2009

        VCM_SD=[
            1 4
            1 6
            2 3
            2 5
            3 4
            3 6
            4 3
            4 5
            5 4
            5 6
            6 4
            6 6];% 02/02/2009

        VCM_a48=[
            1 7
            2 6
            4 1
            4 2
            4 6
            5 7];% 02/02/2009

        VCM_a1=[
            6 8];% 02/02/2009

        VCM_b1=[
            1 1
            1 2
            5 5];% 02/02/2009

        VCM_H40=[
            6 1];% 02/02/2009

        VCM_h32=[
            3 1];% 02/02/2009

        VCM_h20=[
            5 9];% 02/02/2009

        for i = 1:size(DeviceList,1)
            for j = 1:size(VCM_B,1)
                if all(DeviceList(i,:) == VCM_B(j,:))
                    BLeffPerI =  3.58180858e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(VCM_A,1)
                if all(DeviceList(i,:) == VCM_A(j,:))
                    BLeffPerI =  3.25e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(VCM_SD,1)
                if all(DeviceList(i,:) == VCM_SD(j,:))
                    BLeffPerI =  4.62686411e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(VCM_a48,1)
                if all(DeviceList(i,:) == VCM_a48(j,:))
                    BLeffPerI =  2.19e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(VCM_a1,1)
                if all(DeviceList(i,:) == VCM_a1(j,:))
                    BLeffPerI =  2.88741e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(VCM_b1,1)
                if all(DeviceList(i,:) == VCM_b1(j,:))
                    BLeffPerI =  2.90928e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(VCM_H40,1)
                if all(DeviceList(i,:) == VCM_H40(j,:))
                    BLeffPerI =  5.4e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(VCM_h32,1)
                if all(DeviceList(i,:) == VCM_h32(j,:))
                    BLeffPerI =  4.6e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end
            for j = 1:size(VCM_h20,1)
                if all(DeviceList(i,:) == VCM_h20(j,:))
                    BLeffPerI =  2.3e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    k(i,:) = BLeffPerI .* Amps(i,:) ./ Brho;
                end
            end

            if nargout >= 2
                Leff = 1;
                B(i,:) = BLeffPerI .* Amps(i,:) ./ Leff;
            end
        end
        return

    elseif strcmpi(Family, 'BEND')
    
        A = [0 146.439 340.934 535.757 730.486 827.679 876.938 940.002 974.425 1071.468 1168.572 1200]; % Power supply (Amp) 952.752304
        B = [0 -0.24875 -0.57342 -0.89743 -1.21531 -1.36635 -1.43647 -1.51468 -1.55212 -1.64438 -1.72412 -1.75627];
        C = [0 0.32648 0.7559 1.18394 1.59819 1.7908 1.87823 1.97319 2.01744 2.12478 2.21154 2.25284];  
        A = A / 1000;
        Brho = getbrho(Energy);
        BLeff = interp1(A,C,Amps);
        k = -BLeff  / Brho / 1.22;
        return
        
    elseif strcmpi(Family, 'QD1')
        QD1.PS = [0 37.992 45.612 53.232 60.864 68.484 76.102 78.832 83.714 91.338 98.954 101.4 106.578 114.19 121.832 125.148];
        QD1.B1L = [0 0.92027 1.10031 1.28033 1.46082 1.64092 1.82051 1.88506 1.9993 2.17885 2.3563 2.41282 2.53237 2.70645 2.87743 2.95014]; 
        Brho = getbrho(Energy);
        BLeff = interp1(QD1.PS,QD1.B1L,Amps);
        k = -BLeff  / Brho / 0.35;
        return
        
    elseif strcmpi(Family, 'QF1')
        QF1.PS = [0 30.368 50.492 78.832 101.4 125.148 152.308 188.89 202.93 223.366 250];
        QF1.B1L = [0 -0.7422 -1.2191 -1.8902 -2.4236 -2.9838 -3.6182 -4.45781 -4.7703 -5.2001 -5.64333];
        Brho = getbrho(Energy);
        BLeff = interp1(QF1.PS,QF1.B1L,Amps);
        k = -BLeff  / Brho / 0.35;
        return
        
    elseif strcmpi(Family, 'QD2')
        QD2.PS = [0 37.992 45.612 53.232 60.864 68.484 76.102 78.832 83.714 91.338 98.954 101.4 106.578 114.19 121.832 125.148];
        QD2.B1L = [0 0.65171 0.77939 0.90677 1.03485 1.16202 1.28936 1.33501 1.41628 1.54273 1.66844 1.70846 1.79277 1.91567 2.03608 2.08703]; 
        Brho = getbrho(Energy);
        BLeff = interp1(QD2.PS,QD2.B1L,Amps);
        k = -BLeff  / Brho / 0.24;
        return

    elseif strcmpi(Family, 'QF2')
        QF2.PS = [0 30.368 50.492 78.832 101.4 125.148 152.308 188.89 202.93 223.366 250];
        QF2.B1L = [0 -0.7422 -1.2191 -1.8902 -2.4236 -2.9838 -3.6182 -4.45781 -4.7703 -5.2001 -5.64333];
        Brho = getbrho(Energy);
        BLeff = interp1(QF2.PS,QF2.B1L,Amps);
        k = -BLeff  / Brho / 0.35;
        return
        
    elseif strcmpi(Family, 'SD')
        SD.PS = [0 29.717 49.052 78.537 98.260 116.838 146.246 181.667 195.465 214 233.547 250]; % Amp
        SD.B2L = [0 4.9511 8.0323 12.7231  15.8477 18.7722 23.3264 28.6294 30.5427 32.7048 34.4581 36.492]; % T/M
        Brho = getbrho(Energy);
        BLeff = interp1(SD.PS,SD.B2L,Amps);
        k = -BLeff  / Brho / 0.06 /2;
        return
        
    elseif strcmpi(Family, 'SF')
        SF.PS = [0 29.717 49.052 78.537 98.260 116.838 146.246 181.667 195.465 214 233.547 250]; % Amp
        SF.B2L = [0 4.9511 8.0323 12.7231  15.8477 18.7722 23.3264 28.6294 30.5427 32.7048 34.4581 36.492]; % T/M
        Brho = getbrho(Energy);
        BLeff = interp1(SF.PS,SF.B2L,Amps);
        k = BLeff  / Brho / 0.06 /2;
        return
        
        
    elseif strcmpi(Family, 'SWLS')
        Indices = atindex(THERING);
        AT.ATIndex = buildatindex('SWLS', sort([Indices.SWLS]));
        for i = 1: size(DeviceList,1)
            Index = DeviceList(i,2);
            k(i,1) = SWLS(Amps(i,1),AT.ATIndex(Index));
        end
        return
        
    elseif strcmpi(Family, 'IASW6')
        Indices = atindex(THERING);
        AT.ATIndex = buildatindex('IASW6', sort([Indices.IASW6]));
        for i = 1: size(DeviceList,1)
            Index = DeviceList(i,2);
            k(i,1) = IASW6(Amps(i,1),AT.ATIndex(Index));
        end
        return
        
    elseif strcmpi(Family, 'W20')
        Indices = atindex(THERING);
        AT.ATIndex = buildatindex('W20', sort([Indices.W20]));
        for i = 1: size(DeviceList,1)
            Index = DeviceList(i,2);
            k(i,1) = W20(Amps(i,1),AT.ATIndex(Index));
        end
        return
    
    elseif strcmpi(Family, 'SW6')
        Indices = atindex(THERING);
        AT.ATIndex = buildatindex('SW6', sort([Indices.SW6]));
        for i = 1: size(DeviceList,1)
            Index = DeviceList(i,2);
            k(i,1) = SW6(Amps(i,1),AT.ATIndex(Index));
        end
        return
        
    elseif strcmpi(Family, 'U9')
        Indices = atindex(THERING);
        AT.ATIndex = buildatindex('U9', sort([Indices.U9]));
        for i = 1: size(DeviceList,1)
            Index = DeviceList(i,2);
            k(i,1) = U9(Amps(i,1),AT.ATIndex(Index));
        end
        return
        
    elseif strcmpi(Family, 'U5')
        Indices = atindex(THERING);
        AT.ATIndex = buildatindex('U5', sort([Indices.U5]));
        for i = 1: size(DeviceList,1)
            Index = DeviceList(i,2);
            k(i,1) = U5(Amps(i,1),AT.ATIndex(Index));
        end
        return
        
    elseif strcmpi(Family, 'EPU56')
        Indices = atindex(THERING);
        AT.ATIndex = buildatindex('EPU56', sort([Indices.EPU56]));
        for i = 1: size(DeviceList,1)
            Index = DeviceList(i,2);
            k(i,1) = EPU56(Amps(i,1),AT.ATIndex(Index));
        end
        return
        
    elseif strcmpi(Family, 'IASWB')
        Indices = atindex(THERING);
        AT.ATIndex = buildatindex('IASWB', sort([Indices.IASWB]));
        for i = 1: size(DeviceList,1)
            Index = DeviceList(i,2);
            k(i,1) = IASWB(Amps(i,1),AT.ATIndex(Index));
        end
        return
        
    elseif strcmpi(Family, 'IASWC')
        Indices = atindex(THERING);
        AT.ATIndex = buildatindex('IASWC', sort([Indices.IASWC]));
        for i = 1: size(DeviceList,1)
            Index = DeviceList(i,2);
            k(i,1) = IASWC(Amps(i,1),AT.ATIndex(Index));
        end
        return
        
    else   
        k = Amps;
    end
    return
end


% If you made it to here, I don't know how to convert it
k = Amps;
return

