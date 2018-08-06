function [Amps, B] = k2amp(Family, Field, k, DeviceList, Energy, BranchFlag)
%K2AMP - Converts simulator values to amperes
%  [Amps, B] = k2amp(Family, Field, K, DeviceList, Energy, BranchFlag)
%
%  INPUTS
%  1. Family - Family name
%  2. Field - Sub-field (like 'Setpoint')
%  3. K - "K-value" in AT convention
%          For dipole:      K = B / Brho
%          For quadrupole:  K = B'/ Brho
%          For sextupole:   K = B"/ Brho / 2
%  4. DeviceList - Device list (Amps and DeviceList must have the same number of rows)
%  5. Energy - Energy in GeV {Default: getenergy}
%              If Energy is a vector, each output column will correspond to that energy.
%              Energy can be anything getenergy accepts, like 'Model' or 'Online'.
%              (Note: If Energy is a vector, then Amps can only have 1 column)
%  6. BranchFlag - 1 -> Lower branch
%                  2 -> Upper branch
%
%  OUTPUTS
%  1. Amps - Ampere (or real hardware units)
%
%  NOTES
%  1. The K-to-Amp conversion is based on the 1.5 to 1.9 hysteresis loops.  Linearly projecting
%     outside this range can produce questionable results.
%  2. If k==0, then Amps and B are set to zero.  This is done because the hysteresis loops 
%     do not interpolate to zero very well.
%  3. This function outputs real units (as expected inside physics2hw).
%
%  See also amp2k, hw2physics, physics2hw, buildramptable

%  Written by Greg Portmann


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


% Hysteresis branch
if nargin < 6
    BranchFlag = [];
else
    if ischar(BranchFlag)
        if strcmpi(BranchFlag, 'Lower')
            % Lower branch
            BranchFlag = 1;
        elseif strcmpi(BranchFlag, 'Upper')
            % Upper branch
            BranchFlag = 2;
        end
    end
end
if isempty(BranchFlag)
    if strcmpi(getfamilydata('HysteresisBranch'),'Lower')
        % Lower branch
        BranchFlag = 1;
    else
        % Upper branch (default)
        BranchFlag = 2;
    end
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



%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%
% Put amp2k as the HCM/VCM conversions
% HCM(1,2,7,8)   BLeff  =  4.070*10-4 * I  (Tesla-meters)
% HCM(3,6)       BLeff  =  9.500*10-4 * I  (Tesla-meters)
% HCM(4,5)       BLeff  = 10.250*10-4 * I  (Tesla-meters)
% VCM(1,2,7,8)   BLeff  =  1.711*10-4 * I  (Tesla-meters)
% VCM(4,5)       BLeff  = -3.000*10-4 * I  (Tesla-meters)
% Rad = BLeff / Brho
if strcmpi(Family, 'HCM')
    Brho = getbrho(Energy);
    for i = 1:size(DeviceList,1)
%         if (all(DeviceList(i,:) == [1 2]) || all(DeviceList(i,:) == [1 7]) || all(DeviceList(i,:) == [2 7]) ||  all(DeviceList(i,:) == [3 2]) || all(DeviceList(i,:) == [3 7]) || all(DeviceList(i,:) == [5 7]) || all(DeviceList(i,:) == [6 7]) || all(DeviceList(i,:) == [7 7]) || all(DeviceList(i,:) == [8 7]) || all(DeviceList(i,:) == [9 7]) || all(DeviceList(i,:) == [10 7]) || all(DeviceList(i,:) == [11 7]))
%             BLeffPerI =  0.88 * 4.070e-4;  %  (Tesla-meters)
%             Leff = .5;
        if any(DeviceList(i,2) == [2 7]) 
            BLeffPerI =  0.88 * 4.070e-4;  %  (Tesla-meters)
            Leff = .5;
        elseif any(DeviceList(i,2) == [1 8])
            BLeffPerI =  0.95 * 4.070e-4;  %  (Tesla-meters)
            Leff = .5;
%         elseif any(DeviceList(i,2) == [1 2 7 8])
%             BLeffPerI =  4.070e-4;  %  (Tesla-meters)
%             Leff = .5;
        elseif all(DeviceList(i,:)==[5 3]) || all(DeviceList(i,:)==[5 6])
            % Skew quad power supply swap
            BLeffPerI = .6329 * 9.500e-4 * .45;  %  (Tesla-meters)
            Leff = 0.2030;
        elseif all(DeviceList(i,:)==[5 5]) || all(DeviceList(i,:)==[7 4])
            % Skew quad power supply swap
            BLeffPerI = .5046 * 10.250e-4 * .45;  %  (Tesla-meters)
            Leff = 0.2030;

        elseif any(DeviceList(i,2) == [3 6])
            BLeffPerI = 0.7667 * 9.500e-4;  %  (Tesla-meters)
            Leff = 0.2030;
        elseif any(DeviceList(i,2) == [4 5])
            BLeffPerI = 0.6156 * 10.250e-4;  %  (Tesla-meters)
            Leff = 0.2030;
        elseif any(DeviceList(i,2) == 10)
            % Center chicane
            BLeffPerI = 1.0753 * .2e-4;  %  (Tesla-meters)
            Leff = 0.2030;
        else
            error('Device not found in HCM family.');
        end

        Amps(i,:) = k(i,:) .* Brho / BLeffPerI;

        if nargout >= 2
            B(i,:) = BLeffPerI .* Amps(i,:) ./ Leff;
        end
    end
        
    % physics2hw expects real units 
    return
end

if strcmpi(Family, 'VCM')
    Brho = getbrho(Energy);
    for i = 1:size(DeviceList,1)
%         if all(DeviceList(i,:) == [6 8])
%             BLeffPerI =  2 * 1.0802 * 1.711e-4;  %  (Tesla-meters)
%             Leff = .5;
%         elseif any(DeviceList(i,2) == [1 8])
%             BLeffPerI =  1.0802 * 1.711e-4;  %  (Tesla-meters)
%             Leff = .5;
%         elseif (all(DeviceList(i,:) == [1 2]) || all(DeviceList(i,:) == [1 7]) || all(DeviceList(i,:) == [2 7]) || all(DeviceList(i,:) == [3 2]) || all(DeviceList(i,:) == [3 7]) || all(DeviceList(i,:) == [5 7]) || all(DeviceList(i,:) == [6 7]) || all(DeviceList(i,:) == [7 7]) || all(DeviceList(i,:) == [8 7]) || all(DeviceList(i,:) == [9 7]) || all(DeviceList(i,:) == [10 7]) || all(DeviceList(i,:) == [11 7]))
%             BLeffPerI =  2.0 * 0.8473 * 1.711e-4;  %  (Tesla-meters)
%             Leff = .5;
%         elseif any(DeviceList(i,2) == [2 7])
%             BLeffPerI =  0.8473 * 1.711e-4;  %  (Tesla-meters)
%             Leff = .5;
        if any(DeviceList(i,2) == [1 8])
            BLeffPerI =  2 * 1.0802 * 1.711e-4;  %  (Tesla-meters)
            Leff = .5;
        elseif any(DeviceList(i,2) == [2 7])
            BLeffPerI =  2.0 * 0.8473 * 1.711e-4;  %  (Tesla-meters)
            Leff = .5;
        elseif any(DeviceList(i,2) == [4 5])
            BLeffPerI = -2.5 *3.0e-4;  %  (Tesla-meters)  2.5 add emperically (Greg Portmann)
            Leff = 0.2030;
        elseif any(DeviceList(i,2) == 10)
            % Center chicane
            BLeffPerI = 0.3532e-4;  %  (Tesla-meters)
            Leff = 0.2030;
        else
            error('Device not found in VCM family.');
        end

        Amps(i,:) = k(i,:) .* Brho / BLeffPerI;

        if nargout >= 2
            B(i,:) = BLeffPerI .* Amps(i,:) ./ Leff;
        end
    end

    % physics2hw expects real units 
    return
end


%%%%%%%%%%%%%%%%%%%
% Chicane Magnets %
%%%%%%%%%%%%%%%%%%%
if any(strcmpi(Family, {'HCMCHICANE','VCMCHICANE'}))
    % Put amp2k as the HCM/VCM conversions
    % HCMCHICANE   BLeff  =  1*10-4 * I  (Tesla-meters)  ???
    % VCMCHICANE   BLeff  =  1*10-4 * I  (Tesla-meters)  ???
    % Rad = BLeff / Brho
        
    Brho = getbrho(Energy);
    
    if strcmpi(Family, 'HCMCHICANE')
        for i = 1:size(DeviceList,1)
            % Just valid for the center chicane trim corrector
            BLeffPerI = 1.0753 * .2e-4;  %  (Tesla-meters)
            Leff = .5;
            
            Amps(i,:) = k(i,:) .* Brho / BLeffPerI;
            if nargout >= 2
                B(i,:) = BLeffPerI .* Amps(i,:) ./ Leff;
            end
        end
    end
    
    if strcmpi(Family, 'VCMCHICANE')
        for i = 1:size(DeviceList,1)
            % Just valid for the center chicane trim corrector
            BLeffPerI =   0.3532e-4;  %  (Tesla-meters)
            Leff = .5;
            
            Amps(i,:) = k(i,:) .* Brho / BLeffPerI;
            if nargout >= 2
                B(i,:) = BLeffPerI .* Amps(i,:) ./ Leff;
            end
        end
    end

    % physics2hw expects real units 
    return
end


%%%%%%%%%%%%%%
% Skew Quads %
%%%%%%%%%%%%%%
if any(strcmpi(Family, {'SQSF','SQSD','SQSHF'}))
    % Scaling factors [A/m^-2]  (based on magnetic measurements of skew quadrupoles)
    ChannelName = family2channel(Family, Field, DeviceList);
    for i = 1:size(k,1)
        for j = 1:size(k,2)
            % SQSF factor are weaker at 1.9 GeV because the higher sextupole strength causes pole saturation.
            if strcmpi(ChannelName(i,9:12), 'SQSF') || strcmpi(ChannelName(i,1:4), 'sqsf') %added last conditional for temp SQSF CAEN setup - 11-05-2010, T.Scarvie
                if Energy(j) > 1.7
                    ScaleFactor = (20.0 / 0.11) * Energy(j) / 1.894;
                else
                    ScaleFactor = (14.0 / 0.11) * Energy(j) / 1.894;
                end
            elseif strcmpi(ChannelName(i,1:13), 'SR05C___HCSF1') || strcmpi(ChannelName(i,1:13), 'SR06C___HCSF1')
                if Energy(j) > 1.7
                    ScaleFactor = (20.0 / 0.11) * Energy(j) / 1.894 / 4.7;
                else
                    ScaleFactor = (14.0 / 0.11) * Energy(j) / 1.894 / 4.7;
                end
            elseif strcmpi(ChannelName(i,1:13), 'SR05C___HCSF2') || strcmpi(ChannelName(i,1:13), 'SR07C___HCSF1')
                if Energy(j) > 1.7
                    ScaleFactor = (6.1 / 0.11) * Energy(j) / 1.894;
                else
                    ScaleFactor = (6.1 / 0.11) * Energy(j) / 1.894;  % probably not correct; but saturation unknow so far
                end
            elseif strcmpi(ChannelName(i,9:12), 'HCSD')
                if Energy(j) > 1.7
                    ScaleFactor = (4.6 / 0.11) * Energy(j) / 1.894;
                    %ScaleFactor = Energy(j) / 1.9 / 0.0238;  % LOCO run on 2005-05-14
                else
                    ScaleFactor = (4.6 / 0.11) * Energy(j) / 1.894;  % probably not correct; but saturation unknow so far
                end
            elseif strcmpi(ChannelName(i,9:12), 'SQSD')
                if Energy(j) > 1.7
                    ScaleFactor = (14.0 / 0.11) * Energy(j) / 1.894;
                else
                    ScaleFactor = (14.0 / 0.11) * Energy(j) / 1.894;  % probably not correct; but saturation unknow so far
                end
            elseif strcmpi(ChannelName(i,7:11), 'SQSHF') || strcmpi(ChannelName(i,9:13), 'SQSHF')
                    ScaleFactor = (45.0 / 0.11) * Energy(j) / 1.894;  
            elseif strcmpi(ChannelName(i,7:11), 'SQSHD') || strcmpi(ChannelName(i,9:13), 'SQSHD')
                    ScaleFactor = (34.0 / 0.10) * Energy(j) / 1.894;  % probably not correct; but saturation unknow so far                    
            else
                error('%s (%s) unknown family', Family, ChannelName(i,:));
            end

            
            % All skew power supplies have the wrong polarity
            ScaleFactor = -ScaleFactor;

            Amps(i,j) = k(i,j) * ScaleFactor;

            if nargout >= 2
                B(i,j) = k(i,j) * getbrho(Energy(j));
            end
        end
    end
    
    % physics2hw expects real units 
    return
end


%%%%%%%%%%%%%%%%%%%%%%%
% Harmonic Sextupoles %
%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmpi(Family, {'SHF','SHD'}))
    % Scaling factors [A/m^-3]  (based on magnetic measurements of sextupoles)
    ChannelName = family2channel(Family, Field, DeviceList);
    for i = 1:size(k,1)
        for j = 1:size(k,2)
            if strcmpi(ChannelName(i,9:11), 'SHF')
                if (all(DeviceList(i,:) == [1 1]) || all(DeviceList(i,:) == [12 2]))
                    ScaleFactor = (89 / 11.7) * Energy(j) /1.894;
                else
                    ScaleFactor = (79 / 15) * Energy(j) /1.894;
                end
            elseif strcmpi(ChannelName(i,9:11), 'SHD')
                ScaleFactor = (96 / (-15)) * Energy(j) / 1.894;
            else
                error('%s unknown family', Family);
            end
            
            Amps(i,j) = k(i,j) * ScaleFactor;
            
            if nargout >= 2
                B(i,j) = k(i,j) * getbrho(Energy(j));
            end
        end
    end
    
    % physics2hw expects real units
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setpoint and Monitor fields %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmpi(Field, {'Setpoint','Monitor'}))

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Magnets in the Ramp Table %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Convert amps to k for ALS:
    % 1. Get the model (ramp table) k-value
    % 2. Convert Amps to Energy-Table
    % 3. Assumption: K = k-model (ramp table) is constant for every point on the BendAmps, Energy table
    %    Therefore,  e = energy according to Amps to BendAmps to GeV
    %                B = k-model * Brho(e)
    %                k(Amps) = B / Brho(Energy)

    DirectoryName = getfamilydata('Directory', 'OpsData');

    % Get the proper table
    % The tables are normalized:  Setpoints = RampTable * (Upper-Lower) + Lower
    if BranchFlag == 1
        % Lower branch
        load([DirectoryName 'alsrampup']);
    else
        % Upper branch
        load([DirectoryName 'alsrampdown']);
    end

    iDevTotal = findrowindex(DeviceList, family2dev(Family,0));    
    
    if ~isfield(RampTable, Family) || ~isfield(RampTable.(Family), 'Physics')
        % K value not known
        error(sprintf('%s.%s needs a simulator value added to the ramp table', Family, Field));
    else
        % Get the model (ramp table) k-value of the "prefect" model
        K = RampTable.(Family).Physics(iDevTotal);
    end


    % If a ramp table is not present then just do to linear ramp (or scale by energy)
    if ~isfield(RampTable, Family)
        RampTable.(Family).(Field) = linspace(0, 1, length(RampTable.GeV));
    else
        if ~isfield(RampTable.(Family), Field)
            if isfield(RampTable.(Family), 'Setpoint')
                % Look for the .Setpoint field
                RampTable.(Family).(Field) = RampTable.(Family).Setpoint;
            else
                RampTable.(Family).(Field) = linspace(0, 1, length(RampTable.GeV));
            end
        end
    end


    % Setpoints = RampTable * (Upper-Lower) + Lower
    UpperLattice = RampTable.UpperLattice.(Field).(Family).(Field).Data;
    LowerLattice = RampTable.LowerLattice.(Field).(Family).(Field).Data;
    iDevUpper = findrowindex(DeviceList, RampTable.UpperLattice.(Field).(Family).(Field).DeviceList);
    iDevLower = findrowindex(DeviceList, RampTable.LowerLattice.(Field).(Family).(Field).DeviceList);

    % Convert to a absolute table
    MagnetTable = RampTable.(Family).(Field);
    MagnetTable = (UpperLattice(iDevUpper) - LowerLattice(iDevLower)) * MagnetTable;
    for j = 1:size(MagnetTable,1)
        MagnetTable(j,:) = MagnetTable(j,:) + LowerLattice(iDevLower(j));
    end


    % Interpolate between the points in the table
    E0 = .51099906e-3;    % Electron rest mass in GeV
    Brho = getbrho(Energy);
    for i = 1:size(k,1)   %length(iDevTotal)
        % Field strength at the present energy
        B(i,:) = k(i,:) .* Brho;

        % For the same field, the ramp table k-value and energy are the following
        BrhoTable = B(i,:) / K(i);
        e = getbrhoinv(BrhoTable);
        %e = sqrt(E0^2 + (.299792458 * BrhoTable).^2) - E0;        % Laurants total energy
        %e = sqrt(E0^2 + (.299792458 * BrhoTable).^2);             % Old code

        % Linear interpolation
        Amps(i,:) = interp1(RampTable.GeV, MagnetTable(i,:), e, 'linear', 'extrap');
    end

    % physics2hw expects real units but the tables are in raw units
    Amps = raw2real(Family, Field, Amps, DeviceList);

    
    % This is a cluge!!!
    % ALS hystersis loops do not interpolate to zero very well.
    % It's better to have zero amps be zero k and be a crazy value.
    Amps(find(k==0)) = 0;
    B(find(k==0)) = 0;

    return
end


% If you made it to here, I don't know how to convert it
Amps = k;
B = k;
return
