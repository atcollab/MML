function Amps = at2tls(Family, Field, k, DeviceList, Energy)
%AT2TLS - Converts simulator values to amperes
%  Amps = at2tls(Family, Field, K, DeviceList, Energy)
%
%  INPUTS
%  1. Family - Family name
%  2. Field - Sub-field (like 'Setpoint')
%  3. K - "K-value" (AT convention)
%          For dipole:      K = B / Brho
%          For quadrupole:  K = B'/ Brho
%          For sextupole:   K = B"/ Brho / 2
%  4. DeviceList - Device list (Amps and DeviceList must have the same number of rows)
%  5. Energy - Energy in GeV {Default: getenergy}
%              If Energy is a vector, each output column will correspond to that energy.
%              Energy can be anything getenergy accepts, like 'Model' or 'Online'.
%              (Note: If Energy is a vector, then Amps can only have 1 column)
%
%  OUTPUTS
%  1. Amps - Ampere (or real hardware units)
%
%  See also tls2at, hw2physics, physics2hw


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


if size(k,1) == 1 && length(DeviceList) > 1
    k = ones(size(DeviceList,1),1) * k;
elseif size(k,1) ~= size(DeviceList,1)
    error('Rows in K must equal rows in DeviceList or be a scalar');
end


if all(isnan(k))
    Amps = k;
    B = k;
    return
end


% Force Energy and K to have the same number of columns
if all(size(Energy) > 1)
    error('Energy can only be a scalar or vector');
end
Energy = Energy(:)';

if length(Energy) > 1
    if size(k,2) == size(Energy,2)
        % OK
    elseif size(k,2) > 1
        error('If Energy is a vector, then K can only have 1 column.');
    else
        % K has one column, expand to the size of Energy
        k = k * ones(1,size(Energy,2));
    end
else
    Energy = Energy * ones(1,size(k,2));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setpoint and Monitor Fields %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmpi(Field, {'Setpoint','Monitor'}))
    if strcmpi(Family, 'HCM')
        % HCM
        % Rad = BLeff / Brho
        Brho = getbrho(Energy);
        %BLeffPerI = 0.001;   % ????
        %Amps = k .* Brho / BLeffPerI;

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
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(HCM_A,1)
                if all(DeviceList(i,:) == HCM_A(j,:))
                    BLeffPerI =  3.36e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(HCM_SF,1)
                if all(DeviceList(i,:) == HCM_SF(j,:))
                    BLeffPerI =  3.9460603e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(HCM_a48,1)
                if all(DeviceList(i,:) == HCM_a48(j,:))
                    BLeffPerI =  2.24e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(HCM_c40,1)
                if all(DeviceList(i,:) == HCM_c40(j,:))
                    BLeffPerI =  1.879528e-3;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(HCM_a1,1)
                if all(DeviceList(i,:) == HCM_a1(j,:))
                    BLeffPerI =  3.031977e-3;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
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
        %Amps = k .* Brho / BLeffPerI;

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
                    BLeffPerI =  -3.58180858e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(VCM_A,1)
                if all(DeviceList(i,:) == VCM_A(j,:))
                    BLeffPerI =  -3.25e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(VCM_SD,1)
                if all(DeviceList(i,:) == VCM_SD(j,:))
                    BLeffPerI =  -4.62686411e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(VCM_a48,1)
                if all(DeviceList(i,:) == VCM_a48(j,:))
                    BLeffPerI =  -2.19e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(VCM_a1,1)
                if all(DeviceList(i,:) == VCM_a1(j,:))
                    BLeffPerI =  -2.88741e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(VCM_b1,1)
                if all(DeviceList(i,:) == VCM_b1(j,:))
                    BLeffPerI =  -2.90928e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(VCM_H40,1)
                if all(DeviceList(i,:) == VCM_H40(j,:))
                    BLeffPerI =  -5.4e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(VCM_h32,1)
                if all(DeviceList(i,:) == VCM_h32(j,:))
                    BLeffPerI =  -4.6e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end
            for j = 1:size(VCM_h20,1)
                if all(DeviceList(i,:) == VCM_h20(j,:))
                    BLeffPerI =  -2.3e-4;  %  (Tesla-meters)
                    %                Leff = .5;
                    Amps(i,:) = k(i,:) .* Brho ./ BLeffPerI;
                end
            end

            if nargout >= 2
                Leff = 1;
                B(i,:) = BLeffPerI .* Amps(i,:) ./ Leff;
            end
        end
        return

    else
        Amps = k;
    end
    return
end


% If you made it to here, I don't know how to convert it
Amps = k;
return
