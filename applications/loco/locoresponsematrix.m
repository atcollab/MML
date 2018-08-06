function RM = locoresponsematrix(RINGData, BPMData, CMData, varargin)
%LOCORESPONSEMATRIX - Calculate the BPM response matrix and dispersion function
% M = LOCORESPONCEMATRIX(RINGData, BPMData, CMData)
%
% Accelerator Toolbox implementation of generic LOCO function
%
% RINGData - must have fields 'Lattice', 'CavityFrequency', 'CavityHarmNumber'
%            RINGData.Lattice - AT lattice cell arrary
%            RINGData.CavityFrequency  [Hz]
%            RINGData.CavityHarmNumber [Hz]
%
% CMData -   must have fields: 'HCMIndex', 'VCMIndex', 'HCMKicks', 'VCMKicks', 'HCMCoupling', 'VCMCoupling'
%            CMData.HCMIndex    - indexes in the AT lattice of elements used as horizontal correctors
%            CMData.VCMIndex    - indexes in the AT lattice of elements used as vertical correctors
%                                 Elements used as correctors in both planes should be included in both lists
%            CMData.HCMKicks    - kick  size [radians] of horizontal correctors in the horizontal plane
%            CMData.VCMKicks    - kick  size [radians] of vertical correctors in the vertical plane
%            CMData.HCMCoupling - corrector coupling coefficient into another plane:
%                                 0.01 coupling means that for 1e-3 kick in the horizontal direction there
%                                 is a 1e-5 rad kick in the vertical direction
%            CMData.VCMCoupling - corrector coupling coefficient into another plane:
%                                 0.01 coupling means that for 1e-3 kick in the vertical direction there
%                                 is a 1e-5 rad kick in the horizontal direction
%
% BPMData -  must have field 'BPMIndex'
%            CMData.BPMIndex - indexes of all BPMs or observation points in the AT lattice
%                              All BPS and observation points (single plane too)
%                              are included in CMData.BPMIndex.
%
% Return value: a matrix with number of rows equal to 2*length(CMData.BPMIndex) and the number of columns
%               equal length(CMData.HCMIndex)+length(CMData.VCMIndex)
%
% Additional string flags (in any order)
%
% LOCORESPONSEMATRIX(...,ClosedOrbitType,...)
%       ClosedOrbitType is 'fixedmomentum',  'fixedpathlength' (default)
%
% LOCORESPONCEMATRIX(..., 'linear') calculates M using linear approximation  !!! including the dispersion terms
%
% LOCORESPONCEMATRIX(..., 'RF', DeltaRF) - 'RF' switch must be followed by the value of DeltaRF [Hz]
%
% LOCORESPONCEMATRIX(..., 'ResponseMatrixMeasurement', 'oneway') - 'oneway' switch is used
%                        when the response matrix was measured only kicking the i-th corrector
%                        to +KicksCoupled(i) one way, default: ResponseMatrixMeasurement = 'bidirectional'
%
% LOCORESPONCEMATRIX(..., 'DispersionMeasurement', 'oneway') - 'oneway' switch is used
%                        when the dispersion was measured only by varying the
%                        RF frequency in one direction, default: DispersionMeasurement = 'bidirectional'
%
% Or a Flags structure can be an input argument:
% LOCORESPONCEMATRIX(..., Flags)
%    Flags.ResponseMatrixMeasurement = 'oneway' or {'bi-directional'}
%    Flags.DispersionMeasurement     = 'oneway' or {'bi-directional'}
%    Flags.ResponseMatrixCalculator  = {'linear'} or 'full'
%    Flags.ClosedOrbitType           = 'fixedmomentum' or {'fixedpathlength'}
%
%  NOTE
%  1. Flag names are not case sensitive
%  2. JR - 12/7/05 added vectorized linear rm calculation (NewVectorizedMethod = 1)

NewVectorizedMethod = 1;

C = 2.99792458e8;

% Defaults
ResponseMatrixMeasurement = 'bidirectional';
DispersionMeasurement     = 'bidirectional';
ResponseMatrixCalculator  = 'linear';
ClosedOrbitType           = 'fixedpathlength';
MachineType               = 'StorageRing';

RFFLAG = 0;
DeltaRF = [];

N = nargin-3;
i = 0;
while i < N
    i = i + 1;
    if isstruct(varargin{i})
        Flags = varargin{i};
        if isfield(Flags,'ResponseMatrixCalculator')
            ResponseMatrixCalculator = Flags.ResponseMatrixCalculator;
        end
        if isfield(Flags,'ClosedOrbitType')
            ClosedOrbitType = Flags.ClosedOrbitType;
        end
        if isfield(Flags,'ResponseMatrixMeasurement')
            ResponseMatrixMeasurement = Flags.ResponseMatrixMeasurement;
        end
        if isfield(Flags,'DispersionMeasurement')
            DispersionMeasurement = Flags.DispersionMeasurement;
        end
        if isfield(Flags,'MachineType')
            MachineType = Flags.MachineType;
        end
    elseif ischar(varargin{i})
        switch lower(varargin{i})
            case 'linear'
                ResponseMatrixCalculator = 'linear';
            case 'full'
                ResponseMatrixCalculator = 'full';
            case 'fixedmomentum'
                ClosedOrbitType = 'fixedmomentum';
            case 'fixedpathlength'
                ClosedOrbitType = 'fixedpathlength';
            case 'rf'
                if (i+4<=nargin) && isnumeric(varargin{i+1})
                    RFFLAG = 1;
                    DeltaRF = varargin{i+1};
                    i = i + 1;
                else
                    error('''RF'' flag must be followed by a numeric value of delta RF [Hz]');
                end
            case 'dispersionmeasurement'
                if (i+4<=nargin) && ischar(varargin{i+1})
                    DispersionMeasurement = varargin{i+1};
                    i = i + 1;
                else
                    error('''DispersionMeasurement'' flag must be followed by ''oneway'' or ''bidirectional''');
                end
            case 'responsematrixmeasurement'
                if (i+4<=nargin) && ischar(varargin{i+1})
                    ResponseMatrixMeasurement = varargin{i+1};
                    i = i + 1;
                else
                    error('''ResponseMatrixMeasurement'' flag must be followed by ''oneway'' or ''bidirectional''');
                end
            case {'storagering','booster','boosterring'}
                MachineType = 'StorageRing';
            case {'transport','linac'}
                MachineType = 'Transport';
            otherwise
                warning('Unknown switch ignored.');
        end
    else
        warning('Unknown switch ignored.');
    end
end


% Input checks
if ~strcmpi(ResponseMatrixMeasurement, 'bidirectional') && ~strcmpi(ResponseMatrixMeasurement, 'oneway')
    error('Unknown ResponseMatrixMeasurement type');
end
if ~strcmpi(DispersionMeasurement, 'bidirectional') && ~strcmpi(DispersionMeasurement, 'oneway')
    error('Unknown DispersionMeasurement type');
end
if ~strcmpi(ResponseMatrixCalculator, 'linear') && ~strcmpi(ResponseMatrixCalculator, 'full')
    error('Unknown ResponseMatrixCalculator method');
end
if ~strcmpi(ClosedOrbitType, 'fixedpathlength') && ~strcmpi(ClosedOrbitType, 'fixedmomentum')
    error('Unknown ClosedOrbitType method');
end
if ~strcmpi(MachineType, 'StorageRing') && ~strcmpi(MachineType, 'Transport')
    error('Unknown MachineType');
end


% Initialize
ATRING = RINGData.Lattice;
NHC = length(CMData.HCMIndex);
NVC = length(CMData.VCMIndex);
NBPM = length(BPMData.BPMIndex);


if strcmpi(MachineType, 'StorageRing')

    if RFFLAG
        % Add an extra column for the orbit responce to the RF frequency change
        RM = zeros(2*NBPM,NHC+NVC+1);
    else
        RM = zeros(2*NBPM,NHC+NVC);
    end

    NE = length(ATRING);
    if strcmpi(ResponseMatrixCalculator, 'Linear')
        % Calculate linear optics and chromatic finctions for the model
        [M44,T,ClosedOrbit] = findm44(ATRING,0,1:NE+1);
        DP = 0.00001;
        ClosedOrbitDP = findorbit4(ATRING,DP,1:NE+1);
        Dispersion = (ClosedOrbitDP-ClosedOrbit)/DP;
        L0 = findspos(ATRING,NE+1);

        %%X1(6)/(DP*L0); % is not the same as mcf(ATRING)???  G. Portmann
        %X1 = ringpass(ATRING,[ClosedOrbitDP(:,1);DP;0]);
        %MCF = X1(6)/(DP*L0);
        MCF = mcf(ATRING);

        % Transfer matrixes through individual correctors
        M44HCOR = cell(1,NHC);
        M44VCOR = cell(1,NVC);
        for i=1:NHC
            M44HCOR{i}=findelemm44(ATRING{CMData.HCMIndex(i)},ATRING{CMData.HCMIndex(i)}.PassMethod,[ClosedOrbit(:,CMData.HCMIndex(i));0;0]);
        end
        for i=1:NVC
            match = find(CMData.VCMIndex(i)==CMData.HCMIndex);
            if match
                M44VCOR{i}=M44HCOR{match};
            else
                M44VCOR{i}=findelemm44(ATRING{CMData.VCMIndex(i)},ATRING{CMData.VCMIndex(i)}.PassMethod,[ClosedOrbit(:,CMData.VCMIndex(i));0;0]);
            end
        end


        % Assemble arrays of corrector kicks including coupling
        HCORTheta = zeros(4,NHC);
        VCORTheta = zeros(4,NVC);

        HCORTheta(2,:) = CMData.HCMKicks(:)';
        HCORTheta(4,:) = CMData.HCMCoupling(:)' .* CMData.HCMKicks(:)';
        VCORTheta(2,:) = CMData.VCMCoupling(:)' .* CMData.VCMKicks(:)';
        VCORTheta(4,:) = CMData.VCMKicks(:)';


        % Calculate closed orbit at the exit of each corrector magnet WITH applied kick
        for i=1:NHC
            CI = CMData.HCMIndex(i);
            InverseT = inv(T(:,:,CI));
            OrbitEntrance = (inv(eye(4)-T(:,:,CI)*M44*InverseT)*...
                T(:,:,CI)*M44*InverseT*(eye(4)+inv(M44HCOR{i}))*HCORTheta(:,i)/2);

            OrbitExit = HCORTheta(:,i)/2+M44HCOR{i}*(OrbitEntrance+HCORTheta(:,i)/2);


            R0 = inv(T(:,:,CI+1))*OrbitExit;

            if NewVectorizedMethod

                % very slow loop - use vector operations instead
                vectind = BPMData.BPMIndex(1:NBPM);

                % convert multidimensional loop to single matrix product
                T3 = T([1, 3],:,vectind);
                T2 = reshape(permute(T3, [1 3 2]), NBPM*2, 4);

                % vector comparison
                bgtc = find(vectind > CMData.HCMIndex(i));
                bltc = find(vectind <= CMData.HCMIndex(i));
                bgtc = [(bgtc - 1) .* 2 + 1 (bgtc - 1) .* 2 + 2];
                bltc = [(bltc - 1) .* 2 + 1 (bltc - 1) .* 2 + 2];

                % conditionally multiply
                Tout1 = T2 * R0;
                Tout2 = T2 * M44 * R0;
                Tout = zeros(size(Tout1));
                Tout(bgtc,:) = Tout1(bgtc,:);
                Tout(bltc,:) = Tout2(bltc,:);

                % interleave the writes
                jjj = zeros(2, NBPM);
                jjj(1,:) = 1:NBPM;
                jjj(2,:) = NBPM+1:NBPM*2;

                RM(jjj(:), i) = Tout;

            else

                for j=1:NBPM
                    if BPMData.BPMIndex(j)>CMData.HCMIndex(i)
                        RM([j, j+NBPM],i) = T([1, 3],:,BPMData.BPMIndex(j))*R0;
                    else
                        RM([j, j+NBPM],i) = T([1, 3],:,BPMData.BPMIndex(j))*M44*R0;
                    end
                end

            end

            if strcmpi(ClosedOrbitType, 'FixedPathLength')
                % Use the average value of the dispersion at entrance and exit
                D = HCORTheta(2,i) * ...
                    (Dispersion(1,CMData.HCMIndex(i))+Dispersion(1,CMData.HCMIndex(i)+1)) * ...
                    Dispersion([1 3],BPMData.BPMIndex) /L0/MCF/2;

                RM(1:NBPM,i) = RM(1:NBPM,i) - D(1,:)';
                RM(NBPM+1:end,i) = RM(NBPM+1:end,i) - D(2,:)';
            end

        end

        for i=1:NVC
            CI = CMData.VCMIndex(i);

            InverseT = inv(T(:,:,CI));
            OrbitEntrance = (inv(eye(4)-T(:,:,CI)*M44*InverseT) * T(:,:,CI) * M44 * ...
                InverseT * (eye(4)+inv(M44VCOR{i}))*VCORTheta(:,i)/2);
            OrbitExit = VCORTheta(:,i)/2+M44VCOR{i}*(OrbitEntrance+VCORTheta(:,i)/2);

            R0 = inv(T(:,:,CI+1))*OrbitExit;

            if NewVectorizedMethod

                % very slow loop - use vector operations instead
                vectind = BPMData.BPMIndex(1:NBPM);

                % convert multidimensional loop to single matrix product
                T3 = T([1, 3],:,vectind);
                T2 = reshape(permute(T3, [1 3 2]), NBPM*2, 4);

                % vector comparison
                bgtc = find(vectind > CMData.VCMIndex(i));
                bltc = find(vectind <= CMData.VCMIndex(i));
                bgtc = [(bgtc - 1) .* 2 + 1 (bgtc - 1) .* 2 + 2];
                bltc = [(bltc - 1) .* 2 + 1 (bltc - 1) .* 2 + 2];

                % conditionally multiply
                Tout1 = T2 * R0;
                Tout2 = T2 * M44 * R0;
                Tout = zeros(size(Tout1));
                Tout(bgtc,:) = Tout1(bgtc,:);
                Tout(bltc,:) = Tout2(bltc,:);

                % interleave the writes
                jjj = zeros(2, NBPM);
                jjj(1,:) = 1:NBPM;
                jjj(2,:) = NBPM+1:NBPM*2;

                RM(jjj(:), i+NHC) = Tout;

            else

                for j=1:NBPM
                    if BPMData.BPMIndex(j)>CMData.VCMIndex(i)
                        RM([j, j+NBPM],i+NHC) = T([1, 3],:,BPMData.BPMIndex(j))*R0;
                    else
                        RM([j, j+NBPM],i+NHC) = T([1, 3],:,BPMData.BPMIndex(j))*M44*R0;
                    end
                end

            end

            % Vertical correctors with coupling to X and non-zero horizontal dispersion
            if strcmpi(ClosedOrbitType, 'FixedPathLength')
                % Use the average value of the dispersion at entrance and exit
                D = VCORTheta(2,i)*(Dispersion(1,CMData.VCMIndex(i))+Dispersion(1,CMData.VCMIndex(i)+1))*...
                    Dispersion([1 3],BPMData.BPMIndex)/L0/MCF/2;
                RM(1:NBPM,NHC+i) = RM(1:NBPM,NHC+i) - D(1,:)';
                RM(NBPM+1:end,NHC+i) = RM(NBPM+1:end,NHC+i) - D(2,:)';
            end
        end

        if RFFLAG
            if strcmpi(DispersionMeasurement, 'Bidirectional')
                ORBITPLUS = findsyncorbit(RINGData.Lattice, (-C*DeltaRF*RINGData.CavityHarmNumber/RINGData.CavityFrequency^2)/2, 1:length(RINGData.Lattice)+1);
                ORBIT0    = findsyncorbit(RINGData.Lattice, ( C*DeltaRF*RINGData.CavityHarmNumber/RINGData.CavityFrequency^2)/2, 1:length(RINGData.Lattice)+1);
            else
                ORBITPLUS = findsyncorbit(RINGData.Lattice, -C*DeltaRF*RINGData.CavityHarmNumber/RINGData.CavityFrequency^2, 1:length(RINGData.Lattice)+1);
                ORBIT0    = findsyncorbit(RINGData.Lattice, 0, 1:length(RINGData.Lattice)+1);
            end
            D = ORBITPLUS([1 3],BPMData.BPMIndex) - ORBIT0([1 3],BPMData.BPMIndex);
            RM(:,end) = [D(1,:)'; D(2,:)'];
        end


    elseif strcmpi(ClosedOrbitType, 'FixedPathLength')
        % Exact calculation using FINDSYNCORBIT

        for i = 1:NHC
            switch ATRING{CMData.HCMIndex(i)}.PassMethod
                case 'CorrectorPass'

                    KickAngle0 = ATRING{CMData.HCMIndex(i)}.KickAngle;

                    if strcmpi(ResponseMatrixMeasurement, 'bidirectional')
                        ATRING{CMData.HCMIndex(i)}.KickAngle(1) = KickAngle0(1) + CMData.HCMKicks(i)/2;
                        ATRING{CMData.HCMIndex(i)}.KickAngle(2) = KickAngle0(2) + CMData.HCMKicks(i)*CMData.HCMCoupling(i)/2;
                        ORBITPLUS = findsyncorbit(ATRING,0,BPMData.BPMIndex);

                        ATRING{CMData.HCMIndex(i)}.KickAngle(1) = KickAngle0(1) - CMData.HCMKicks(i)/2;
                        ATRING{CMData.HCMIndex(i)}.KickAngle(2) = KickAngle0(2) - CMData.HCMKicks(i)*CMData.HCMCoupling(i)/2;
                        ORBITMINUS = findsyncorbit(ATRING,0,BPMData.BPMIndex);
                    else
                        ATRING{CMData.HCMIndex(i)}.KickAngle(1) = KickAngle0(1) + CMData.HCMKicks(i);
                        ATRING{CMData.HCMIndex(i)}.KickAngle(2) = KickAngle0(2) + CMData.HCMKicks(i)*CMData.HCMCoupling(i);
                        ORBITPLUS = findsyncorbit(ATRING,0,BPMData.BPMIndex);

                        ATRING{CMData.HCMIndex(i)}.KickAngle(1) = KickAngle0(1);
                        ATRING{CMData.HCMIndex(i)}.KickAngle(2) = KickAngle0(2);
                        ORBITMINUS = findsyncorbit(ATRING,0,BPMData.BPMIndex);
                    end

                    ATRING{CMData.HCMIndex(i)}.KickAngle = KickAngle0;

                    RM(:,i) = [ORBITPLUS(1,:)-ORBITMINUS(1,:),ORBITPLUS(3,:)-ORBITMINUS(3,:)]';

                case {'StrMPoleSymplectic4Pass','BndMPoleSymplectic4Pass'}
                    error('Not implemented yet');
                otherwise
                    error('Unknown pass method for corrector');
            end
        end

        for i = 1:NVC
            switch ATRING{CMData.VCMIndex(i)}.PassMethod
                case 'CorrectorPass'
                    KickAngle0 = ATRING{CMData.VCMIndex(i)}.KickAngle;

                    if strcmpi(ResponseMatrixMeasurement, 'Bidirectional')
                        ATRING{CMData.VCMIndex(i)}.KickAngle(2) = KickAngle0(2) + CMData.VCMKicks(i)/2;
                        ATRING{CMData.VCMIndex(i)}.KickAngle(1) = KickAngle0(1) + CMData.VCMKicks(i)*CMData.VCMCoupling(i)/2;
                        ORBITPLUS = findsyncorbit(ATRING,0,BPMData.BPMIndex);

                        ATRING{CMData.VCMIndex(i)}.KickAngle(2) = KickAngle0(2) - CMData.VCMKicks(i)/2;
                        ATRING{CMData.VCMIndex(i)}.KickAngle(1) = KickAngle0(1) - CMData.VCMKicks(i)*CMData.VCMCoupling(i)/2;
                        ORBITMINUS = findsyncorbit(ATRING,0,BPMData.BPMIndex);
                    else
                        ATRING{CMData.VCMIndex(i)}.KickAngle(2) = KickAngle0(2) + CMData.VCMKicks(i);
                        ATRING{CMData.VCMIndex(i)}.KickAngle(1) = KickAngle0(1) + CMData.VCMKicks(i)*CMData.VCMCoupling(i);
                        ORBITPLUS = findsyncorbit(ATRING,0,BPMData.BPMIndex);

                        ATRING{CMData.VCMIndex(i)}.KickAngle(2) = KickAngle0(2);
                        ATRING{CMData.VCMIndex(i)}.KickAngle(1) = KickAngle0(1);
                        ORBITMINUS = findsyncorbit(ATRING,0,BPMData.BPMIndex);
                    end

                    ATRING{CMData.VCMIndex(i)}.KickAngle = KickAngle0;

                    RM(:,NHC+i) = [ORBITPLUS(1,:)-ORBITMINUS(1,:),ORBITPLUS(3,:)-ORBITMINUS(3,:)]';

                case {'StrMPoleSymplectic4Pass','BndMPoleSymplectic4Pass'}
                    error('Not implemented yet');
                otherwise
                    error('Unknown pass method for corrector')
            end
        end

        if RFFLAG
            if strcmpi(DispersionMeasurement, 'bidirectional')
                ORBITPLUS = findsyncorbit(RINGData.Lattice, (-C*DeltaRF*RINGData.CavityHarmNumber/RINGData.CavityFrequency^2)/2, 1:length(RINGData.Lattice)+1);
                ORBIT0    = findsyncorbit(RINGData.Lattice, ( C*DeltaRF*RINGData.CavityHarmNumber/RINGData.CavityFrequency^2)/2, 1:length(RINGData.Lattice)+1);
            else
                ORBITPLUS = findsyncorbit(RINGData.Lattice, -C*DeltaRF*RINGData.CavityHarmNumber/RINGData.CavityFrequency^2, 1:length(RINGData.Lattice)+1);
                ORBIT0    = findsyncorbit(RINGData.Lattice, 0, 1:length(RINGData.Lattice)+1);
            end

            D = ORBITPLUS([1 3],BPMData.BPMIndex) - ORBIT0([1 3],BPMData.BPMIndex);
            RM(:,end) = [D(1,:)';D(2,:)'];
        end

    elseif strcmpi(ClosedOrbitType, 'FixedMomentum')
        % ClosedOrbitType = 'fixedmomentum' - Exact calculation using FINDORBIT4
        for i = 1:NHC
            switch ATRING{CMData.HCMIndex(i)}.PassMethod
                case 'CorrectorPass'
                    KickAngle0 = ATRING{CMData.HCMIndex(i)}.KickAngle;

                    if strcmpi(ResponseMatrixMeasurement, 'Bidirectional')
                        ATRING{CMData.HCMIndex(i)}.KickAngle(1) = KickAngle0(1) + CMData.HCMKicks(i)/2;
                        ATRING{CMData.HCMIndex(i)}.KickAngle(2) = KickAngle0(2) + CMData.HCMKicks(i)*CMData.HCMCoupling(i)/2;
                        ORBITPLUS = findorbit4(ATRING,0,BPMData.BPMIndex);

                        ATRING{CMData.HCMIndex(i)}.KickAngle(1) = KickAngle0(1) - CMData.HCMKicks(i)/2;
                        ATRING{CMData.HCMIndex(i)}.KickAngle(2) = KickAngle0(2) - CMData.HCMKicks(i)*CMData.HCMCoupling(i)/2;
                        ORBITMINUS = findorbit4(ATRING,0,BPMData.BPMIndex);
                    else
                        ATRING{CMData.HCMIndex(i)}.KickAngle(1) = KickAngle0(1) + CMData.HCMKicks(i);
                        ATRING{CMData.HCMIndex(i)}.KickAngle(2) = KickAngle0(2) + CMData.HCMKicks(i)*CMData.HCMCoupling(i);
                        ORBITPLUS = findorbit4(ATRING,0,BPMData.BPMIndex);

                        ATRING{CMData.HCMIndex(i)}.KickAngle(1) = KickAngle0(1);
                        ATRING{CMData.HCMIndex(i)}.KickAngle(2) = KickAngle0(2);
                        ORBITMINUS = findorbit4(ATRING,0,BPMData.BPMIndex);
                    end

                    ATRING{CMData.HCMIndex(i)}.KickAngle = KickAngle0;

                    RM(:,i) = [ORBITPLUS(1,:)-ORBITMINUS(1,:),ORBITPLUS(3,:)-ORBITMINUS(3,:)]';

                case {'StrMPoleSymplectic4Pass','BndMPoleSymplectic4Pass'}
                    error('Not implemented yet');
                otherwise
                    error('Unknown pass method for corrector');
            end
        end

        for i = 1:NVC
            switch ATRING{CMData.HCMIndex(i)}.PassMethod
                case 'CorrectorPass'

                    KickAngle0 = ATRING{CMData.HCMIndex(i)}.KickAngle;

                    if strcmpi(ResponseMatrixMeasurement, 'Bidirectional')
                        ATRING{CMData.VCMIndex(i)}.KickAngle(2) = KickAngle0(2) + CMData.VCMKicks(i)/2;
                        ATRING{CMData.VCMIndex(i)}.KickAngle(1) = KickAngle0(1) + CMData.VCMKicks(i)*CMData.VCMCoupling(i)/2;
                        ORBITPLUS = findorbit4(ATRING,0,BPMData.BPMIndex);

                        ATRING{CMData.VCMIndex(i)}.KickAngle(2) = KickAngle0(2) - CMData.VCMKicks(i)/2;
                        ATRING{CMData.VCMIndex(i)}.KickAngle(1) = KickAngle0(1) - CMData.VCMKicks(i)*CMData.VCMCoupling(i)/2;
                        ORBITMINUS = findorbit4(ATRING,0,BPMData.BPMIndex);
                    else
                        ATRING{CMData.VCMIndex(i)}.KickAngle(2) = KickAngle0(2) + CMData.VCMKicks(i);
                        ATRING{CMData.VCMIndex(i)}.KickAngle(1) = KickAngle0(1) + CMData.VCMKicks(i)*CMData.VCMCoupling(i);
                        ORBITPLUS = findorbit4(ATRING,0,BPMData.BPMIndex);

                        ATRING{CMData.VCMIndex(i)}.KickAngle(2) = KickAngle0(2);
                        ATRING{CMData.VCMIndex(i)}.KickAngle(1) = KickAngle0(1);
                        ORBITMINUS = findorbit4(ATRING,0,BPMData.BPMIndex);
                    end

                    ATRING{CMData.VCMIndex(i)}.KickAngle = KickAngle0;

                    RM(:,NHC+i) = [ORBITPLUS(1,:)-ORBITMINUS(1,:),ORBITPLUS(3,:)-ORBITMINUS(3,:)]';

                case {'StrMPoleSymplectic4Pass','BndMPoleSymplectic4Pass'}
                    error('Not implemented yet');
                otherwise
                    error('Unknown pass method for corrector')
            end
        end

        if RFFLAG
            if strcmpi(DispersionMeasurement, 'Bidirectional')
                ORBITPLUS = findsyncorbit(RINGData.Lattice, (-C*DeltaRF*RINGData.CavityHarmNumber/RINGData.CavityFrequency^2)/2, 1:length(RINGData.Lattice)+1);
                ORBIT0    = findsyncorbit(RINGData.Lattice, ( C*DeltaRF*RINGData.CavityHarmNumber/RINGData.CavityFrequency^2)/2, 1:length(RINGData.Lattice)+1);
            else
                ORBITPLUS = findsyncorbit(RINGData.Lattice, -C*DeltaRF*RINGData.CavityHarmNumber/RINGData.CavityFrequency^2, 1:length(RINGData.Lattice)+1);
                ORBIT0    = findsyncorbit(RINGData.Lattice, 0, 1:length(RINGData.Lattice)+1);
            end

            D = ORBITPLUS([1 3],BPMData.BPMIndex) - ORBIT0([1 3],BPMData.BPMIndex);
            RM(:,end) = [D(1,:)'; D(2,:)'];
        end

    else
        error('ClosedOrbitType method unknown');
    end

    % End of storage ring
    
    
else
    
    
    % Transport line
    if RFFLAG
        RFFLAG = 0;
        fprintf('   RF flag ignored for transport lines.\n');
    end

    %if strcmpi(ResponseMatrixCalculator, 'Linear')
    %    ResponseMatrixCalculator = 'Full';
    %    fprintf('   ResponseMatrixCalculator set to ''Full'' for transport lines (linear is actualy slower for small transport lines).\n');
    %end

    RM = zeros(2*NBPM,NHC+NVC);
    
    NE = length(ATRING);

    % Find the response matrix about an initial orbit
    if isfield(ATRING{1}, 'TwissData')
        TwissData = ATRING{1}.TwissData;
        R0 = [TwissData.ClosedOrbit; TwissData.dP; TwissData.dL];
    else
        % Try the middlelayer
        try
            TwissData = getfamilydata('TwissData');
            R0 = [TwissData.ClosedOrbit; TwissData.dP; TwissData.dL];
            if isempty(TwissData)
                R0 = [0 0 0 0 0 0]';
            end
        catch
            R0 = [0 0 0 0 0 0]';
        end
    end

    if strcmpi(ResponseMatrixCalculator, 'Linear')
                       
        % Calculate linear optics and chromatic finctions for the model
        [M44, T, ClosedOrbit1] = findm44(ATRING, 0, 1:NE+1);

        % Don't use the closed orbit that findm44 use.  Use linepass.
        ClosedOrbit = linepass(ATRING, R0, 1:length(ATRING)+1);
    
        % Transfer matrixes through individual correctors
        M44HCOR = cell(1,NHC);
        M44VCOR = cell(1,NVC);

        for i=1:NHC
            M44HCOR{i} = findelemm44(ATRING{CMData.HCMIndex(i)}, ATRING{CMData.HCMIndex(i)}.PassMethod, ClosedOrbit(:,CMData.HCMIndex(i)));
        end
        for i=1:NVC
            match = find(CMData.VCMIndex(i)==CMData.HCMIndex);
            if match
                M44VCOR{i} = M44HCOR{match};
            else
                M44VCOR{i} = findelemm44(ATRING{CMData.VCMIndex(i)}, ATRING{CMData.VCMIndex(i)}.PassMethod, ClosedOrbit(:,CMData.VCMIndex(i)));
            end
        end


        % Assemble arrays of corrector kicks including coupling
        HCORTheta = zeros(4,NHC);
        VCORTheta = zeros(4,NVC);

        HCORTheta(2,:) = CMData.HCMKicks(:)';
        HCORTheta(4,:) = CMData.HCMCoupling(:)' .* CMData.HCMKicks(:)';
        VCORTheta(2,:) = CMData.VCMCoupling(:)' .* CMData.VCMKicks(:)';
        VCORTheta(4,:) = CMData.VCMKicks(:)';


        % Calculate closed orbit at the exit of each corrector magnet WITH applied kick
        for i = 1:NHC
            CI = CMData.HCMIndex(i);
            InverseT = inv(T(:,:,CI));
            
            % Split the kick on either side of the corrector
            OrbitExit = M44HCOR{i} * HCORTheta(:,i)/2 + HCORTheta(:,i)/2;
            OrbitEntrance = inv(M44HCOR{i}) * OrbitExit;
            R0 = InverseT * OrbitEntrance(1:4);
            
            for j = 1:NBPM
                if BPMData.BPMIndex(j) > CMData.HCMIndex(i)
                    RM([j, j+NBPM],i) = T([1 3],:,BPMData.BPMIndex(j)) * R0;
                end
            end
        end

        for i=1:NVC
            CI = CMData.VCMIndex(i);
            InverseT = inv(T(:,:,CI));

            % Split the kick on either side of the corrector
            OrbitExit = M44VCOR{i} * VCORTheta(:,i)/2 + VCORTheta(:,i)/2;
            OrbitEntrance = inv(M44HCOR{i}) * OrbitExit;
            R0 = InverseT * OrbitEntrance(1:4);
            
            for j=1:NBPM
                if BPMData.BPMIndex(j)>CMData.VCMIndex(i)
                    RM([j, j+NBPM],i+NHC) = T([1 3],:,BPMData.BPMIndex(j)) * R0;
                end
            end
        end
        
    elseif strcmpi(ResponseMatrixCalculator, 'Full')
        
        % Exact calculation using linepass
        for i = 1:NHC
            switch ATRING{CMData.HCMIndex(i)}.PassMethod
                case 'CorrectorPass'

                    KickAngle0 = ATRING{CMData.HCMIndex(i)}.KickAngle;

                    if strcmpi(ResponseMatrixMeasurement, 'bidirectional')
                        ATRING{CMData.HCMIndex(i)}.KickAngle(1) = KickAngle0(1) + CMData.HCMKicks(i)/2;
                        ATRING{CMData.HCMIndex(i)}.KickAngle(2) = KickAngle0(2) + CMData.HCMKicks(i)*CMData.HCMCoupling(i)/2;
                        ORBITPLUS = linepass(ATRING,R0,BPMData.BPMIndex);

                        ATRING{CMData.HCMIndex(i)}.KickAngle(1) = KickAngle0(1) - CMData.HCMKicks(i)/2;
                        ATRING{CMData.HCMIndex(i)}.KickAngle(2) = KickAngle0(2) - CMData.HCMKicks(i)*CMData.HCMCoupling(i)/2;
                        ORBITMINUS = linepass(ATRING,R0,BPMData.BPMIndex);
                    else
                        ATRING{CMData.HCMIndex(i)}.KickAngle(1) = KickAngle0(1) + CMData.HCMKicks(i);
                        ATRING{CMData.HCMIndex(i)}.KickAngle(2) = KickAngle0(2) + CMData.HCMKicks(i)*CMData.HCMCoupling(i);
                        ORBITPLUS = linepass(ATRING,R0,BPMData.BPMIndex);

                        ATRING{CMData.HCMIndex(i)}.KickAngle(1) = KickAngle0(1);
                        ATRING{CMData.HCMIndex(i)}.KickAngle(2) = KickAngle0(2);
                        ORBITMINUS = linepass(ATRING,R0,BPMData.BPMIndex);
                    end

                    ATRING{CMData.HCMIndex(i)}.KickAngle = KickAngle0;

                    RM(:,i) = [ORBITPLUS(1,:)-ORBITMINUS(1,:),ORBITPLUS(3,:)-ORBITMINUS(3,:)]';

                case {'StrMPoleSymplectic4Pass','BndMPoleSymplectic4Pass'}
                    error('Not implemented yet');
                otherwise
                    error('Unknown pass method for corrector');
            end
        end

        for i = 1:NVC
            switch ATRING{CMData.VCMIndex(i)}.PassMethod
                case 'CorrectorPass'
                    KickAngle0 = ATRING{CMData.VCMIndex(i)}.KickAngle;

                    if strcmpi(ResponseMatrixMeasurement, 'Bidirectional')
                        ATRING{CMData.VCMIndex(i)}.KickAngle(2) = KickAngle0(2) + CMData.VCMKicks(i)/2;
                        ATRING{CMData.VCMIndex(i)}.KickAngle(1) = KickAngle0(1) + CMData.VCMKicks(i)*CMData.VCMCoupling(i)/2;
                        ORBITPLUS = linepass(ATRING,R0,BPMData.BPMIndex);

                        ATRING{CMData.VCMIndex(i)}.KickAngle(2) = KickAngle0(2) - CMData.VCMKicks(i)/2;
                        ATRING{CMData.VCMIndex(i)}.KickAngle(1) = KickAngle0(1) - CMData.VCMKicks(i)*CMData.VCMCoupling(i)/2;
                        ORBITMINUS = linepass(ATRING,R0,BPMData.BPMIndex);
                    else
                        ATRING{CMData.VCMIndex(i)}.KickAngle(2) = KickAngle0(2) + CMData.VCMKicks(i);
                        ATRING{CMData.VCMIndex(i)}.KickAngle(1) = KickAngle0(1) + CMData.VCMKicks(i)*CMData.VCMCoupling(i);
                        ORBITPLUS = linepass(ATRING,R0,BPMData.BPMIndex);

                        ATRING{CMData.VCMIndex(i)}.KickAngle(2) = KickAngle0(2);
                        ATRING{CMData.VCMIndex(i)}.KickAngle(1) = KickAngle0(1);
                        ORBITMINUS = linepass(ATRING,R0,BPMData.BPMIndex);
                    end

                    ATRING{CMData.VCMIndex(i)}.KickAngle = KickAngle0;

                    RM(:,NHC+i) = [ORBITPLUS(1,:)-ORBITMINUS(1,:),ORBITPLUS(3,:)-ORBITMINUS(3,:)]';

                case {'StrMPoleSymplectic4Pass','BndMPoleSymplectic4Pass'}
                    error('Not implemented yet');
                otherwise
                    error('Unknown pass method for corrector')
            end
        end
    else
        error('Unknown method for transfer lines.');
    end
end
