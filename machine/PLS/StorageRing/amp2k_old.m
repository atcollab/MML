function k = amp2k(Family, Field, Amps, DeviceList, Energy, C, K2AmpScaleFactor)
%AMP2K - Converts amperes to simulator values
%  k = amp2k(Family, Field, Amps, DeviceList, Energy, Coefficients, K2AmpScaleFactor)
%    or
%  k = amp2k(Family, Field, Amps, DeviceList, Energy, MagnetCoreType, K2AmpScaleFactor)
%
%  Calculates the "K-value" from the coefficients (or MagnetCoreType), current [amps], energy, and linear scale factor
%
%  For dipole:      k = B / Brho
%  For quadrupole:  k = B'/ Brho
%  For sextupole:   k = B"/ Brho / 2  (to be compatible with AT)
%
%  A Coefficients vector or a MagnetCoreType string (coefficient found from magnetcoefficents.m) can be used
%  Amps and Coefficients must have equal number of rows or one must only have one row
%
%  Energy can be anything getenergy accepts, like 'Model' or 'Online'.
%
%  The K2AmpScaleFactor linearly scales the input current:  Amps = Amps ./ K2AmpScaleFactor
%  This can be used to account for linear calibration errors of the power supply and magnet
%
%  NOTES
%  1. If energy is not an input or empty, then the energy is obtained from getenergy.
%  2. Family and Field inputs are not used but there automatically part of the hw2physics call.
%
%  Written by M. Yoon


if nargin < 4
    error('At least 4 inputs required');
end

if nargin < 6
    C = [];
end
if isempty(C)
    %[C, Leff, Family] = magnetcoefficients(Family);
    C = getfamilydata(Family, Field, 'HW2PhysicsParams', DeviceList);
    C = C{1};
    %Leff = getleff(Family, DeviceList(ii,:));
end


if nargin < 5
    Energy = [];
end
if isempty(Energy)
    Energy = getenergy;
elseif ischar(Energy)
    Energy = getenergy(Energy);
end


% If Amps is a row vector make it a column vector
Amps = Amps(:);

% Scale solution if required
if nargin >= 7
    Amps = Amps ./ K2AmpScaleFactor;
end


% if strcmpi(Family, 'BEND')
%     % k is fixed (36 bend = 2*pi)
%     k = 0.087266462*2;     
%     return
% end

if strcmpi(Family, 'SkewQuad')
    for i = 1:size(Amps,1)
        for j = 1:size(Amps,2)
            % Consideration of calibration factor
            if DeviceList(i,1) == 2
                BLeffPerI = -0.55715;
            elseif DeviceList(i,1) == 5
                BLeffPerI =  0.41955;
            elseif DeviceList(i,1) == 8
                BLeffPerI = -0.5672;
            elseif DeviceList(i,1) == 11
                BLeffPerI = -0.4531;
            else
                error('Device not found in skew quad family.');
            end

            k(i,j) = BLeffPerI .* Amps(i,j);

            %if nargout >= 2
            %    B(i,j) = k(i,j) * getbrho(Energy(j));
            %end
        end
    end
    return
end


%brho  = 3.33620907461447 * energy;
brho = getbrho(Energy);


% Compute polynomial expansion:  polynom = c0 + c1*I ...
% For dipole:      polynom = B  * Leff / I
% For quadrupole:  polynom = B' * Leff / I
% For sextupole:   polynom = B" * Leff / I  (use AT unit /2 from MAD units)

% polynom = (C(8)+C(7)*Amps+C(6)*Amps^2+C(5)*Amps^3+C(4)*Amps^4+C(3)*Amps^5+C(2)*Amps^6+C(1)*Amps^7)
% polynom = (c0+c1*Amps+c2*Amps^2+c3*Amps^3+c4*Amps^4+c5*Amps^5+c6*Amps^6+c7*Amps^7)

if ischar(C)
    [C, Leff, Family] = magnetcoefficients(C);
end

if any(size(C,1) ~= length(Amps))
    if length(Amps) == 1
        Amps = ones(size(C,1),1) * Amps;
    elseif size(C,1) == 1
        %C = ones(size(Amps,1),1) * C;
    else
        error('Amps and Coefficients must have equal number of rows or one must only have one row');
    end
end

% B, B', or B" scaled by energy
for i = 1:length(Amps)
    if size(C,1) == 1
        k(i,1) = polyval(C, Amps(i)) / brho;
    else
        k(i,1) = polyval(C(i,:), Amps(i)) / brho;
    end
end



% switch upper(deblank(Family))
% 
%     case 'BEND'    % 110 cm dipole
%         c7=0.0;
%         c6=0.0;
%         c5=0.0;
%         c4=0.0;
%         c3=0.0;
%         c2=0.0;
%         c1=0.001783;
%         c0=0.009846;
%         mag='bend';
%         leff=1.1;
% 
%     case 'Q1'    % 24 cm quadrupole
%         % Find the current from the given polynomial for B'Leff
%         c7=0.;
%         c6=0.;
%         c5=0.;
%         c4=0.;
%         c3=0.;
%         c2=0.;
%         c1=0.00089480;
%         c0=0.00005407;
%         mag='quad';
%         leff=0.24;
% 
%     case 'Q2'    % 53 cm quadrupole
%         % Find the current from the given polynomial for B'Leff
%         c7=0.;
%         c6=0.;
%         c5=0.;
%         c4=0.;
%         c3=0.;
%         c2=0.;
%         c1=0.002088;
%         c0=-0.0008875;
%         mag='quad';
%         leff=0.53;
% 
%     case 'Q3'    % 35 cm quadrupole
%         % Find the current from the given polynomial for B'Leff
%         c7=0.;
%         c6=0.;
%         c5=0.;
%         c4=0.;
%         c3=0.;
%         c2=0.;
%         c1=0.001346;
%         c0=-0.0001671;
%         mag='quad';
%         leff=0.35;
% 
%     case 'Q4'    % 35 cm quadrupole
%         % Find the current from the given polynomial for B'Leff
%         c7=0.;
%         c6=0.;
%         c5=0.;
%         c4=0.;
%         c3=0.;
%         c2=0.;
%         c1=0.0003161;
%         c0=0.00001679;
%         mag='quad';
%         leff=0.35;
% 
%     case 'Q5'    % 53 cm quadrupole
%         % Find the current from the given polynomial for B'Leff
%         c7=0.;
%         c6=0.;
%         c5=0.;
%         c4=0.;
%         c3=0.;
%         c2=0.;
%         c1=0.0004899;
%         c0=-0.00007151;
%         mag='quad';
%         leff=0.53;
% 
%     case 'Q6'    % 24 cm quadrupole
%         % Find the current from the given polynomial for B'Leff
%         c7=0.;
%         c6=0.;
%         c5=0.;
%         c4=0.;
%         c3=0.;
%         c2=0.;
%         c1=0.0002098;
%         c0=0.0001638;
%         mag='quad';
%         leff=0.24;
% 
%     case 'SD'    % 20 cm sextupole
%         % Find the current from the given polynomial for B'Leff
%         c7=0.;
%         c6=0.;
%         c5=0.;
%         c4=0.;
%         c3=0.;
%         c2=0.;
%         c1=0.0001521;
%         c0=-0.00001565;
%         mag='sext';
%         leff=0.2;
% 
%     case 'SF'    % 20 cm sextupole
%         % Find the current from the given polynomial for B'Leff
%         c7=0.;
%         c6=0.;
%         c5=0.;
%         c4=0.;
%         c3=0.;
%         c2=0.;
%         c1=0.0001511;
%         c0=-0.00006671;
%         mag='sext';
%         leff=0.2;
% 
%     case 'HCM'    % 23.2 cm horizontal corrector
%         % Find the current from the given polynomial for B'Leff
%         c7=0.;
%         c6=0.;
%         c5=0.;
%         c4=0.;
%         c3=0.;
%         c2=0.;
%         c1=0.000349;
%         c0=-0.00009796;
%         mag='bend';
%         leff=0.232;
% 
%     case 'VCM'    % 23.2 cm horizontal corrector
%         % Find the current from the given polynomial for B'Leff
%         c7=0.;
%         c6=0.;
%         c5=0.;
%         c4=0.;
%         c3=0.;
%         c2=0.;
%         c1=0.0001744;
%         c0=-0.00002926;
%         mag='bend';
%         leff=0.232;
% 
%     otherwise
%         disp('Warning: Family not found in Amp2K');
%         k=0;
%         return
% 
% end
% 
% 
% %compute polynomial coefficient
% polynom = (c0+c1*cur+c2*cur.^2+c3*cur.^3+c4*cur.^4+c5*cur.^5+c6*cur.^6+c7*cur.^7);
% 
% 
% 
% 
% switch upper(deblank(mag))
%     case 'BEND'
%         kl=(1/brho)*polynom;
%         ki=kl/leff;
%         k=1./ki;
%         Bleff=polynom;
%         field=Bleff/leff;
% 
%     case 'QUAD'
%         ro=0.03;
%         kl=(1/brho/ro)*polynom;
%         k=kl./leff;
%         bprimel=polynom;
%         Bprime=bprimel/leff;
% 
% %UPDATE
%     case 'SEXT'
%         ro=0.03;
%         kl=(2/brho/ro/ro)*polynom;
%         k=kl;
%         bprimel=polynom;
%         Bprime=bprimel/leff;
% 
% end

