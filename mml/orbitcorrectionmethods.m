function [OCS, SmatNoWeights, S, U, V, Smat] = orbitcorrectionmethods(OCS, Smat, S, U, V)
%ORBITCORRECTIONMETHODS - Some the orbit correction methods used on light sources
%
%  [OCS, Smat, S, U, V] = orbitcorrectionmethods(OCS)                 % Get response matrix & compute SVD correction
%  [OCS, Smat, S, U, V] = orbitcorrectionmethods(OCS, Smat)           % Compute SVD & correction
%  [OCS, Smat, S, U, V] = orbitcorrectionmethods(OCS, Smat, S, U, V)  % Compute correction
%
%  OCS.FitRF - Determines which RF freqency method to use
%  See setorbit for information on all the different flags.
%  
%  NOTES
%  1. OCS.CM.Data is not changed by this function
%     OCS.CM.Delta is the delta correction
%  2. Both row and column weighting of the response matrix can be done.
%     The default is unity row weights and column weight by the std of each column.
% 3.  If the dispersion is needed OCS.Eta will be used first.  Otherwise it depends
%     on the flag settings -- 'GoldenDisp' for the default or 'ModelDisp' for the model.
%
%  See also setorbit, setorbitbump, rmdisp, plotcm

%  Written by Greg Portmann


%  T = V(:,OCS.SVDIndex) * diag(S(OCS.SVDIndex).^(-1)) * U(:,OCS.SVDIndex)';
%  Delcm = T * (BPMWeight .* (GoalOrbitVec - StartOrbitVec));


% Initialize
FitRFDefault = 0;


% Input checking (should add more)
if nargin < 2
    Smat = [];
end
if nargin < 3
    S = [];
    U = [];
    V = [];
end


% This function expects .BPM and .CM to be cell arrays.
% This gets put back at the end of the function.
if ~iscell(OCS.BPM)
    NoCellBPMFlag = 1;
    OCS.BPM = {OCS.BPM};
    OCS.GoalOrbit = {OCS.GoalOrbit};
    if isfield(OCS, 'BPMWeight')
        OCS.BPMWeight = {OCS.BPMWeight};
    end
else
    NoCellBPMFlag = 0;
end
if ~iscell(OCS.CM)
    NoCellCMFlag = 1;
    OCS.CM = {OCS.CM};
    if isfield(OCS, 'CMWeight')
        if ~iscell(OCS.CMWeight)
            OCS.CMWeight = {OCS.CMWeight};
        end
    end
else
    NoCellCMFlag = 0;
end


% RF frequency methods in orbit correction
if ~isfield(OCS, 'FitRF')
    OCS.FitRF = FitRFDefault;
end
if isempty(OCS.FitRF)
    OCS.FitRF = FitRFDefault;
end


%%%%%%%%%%%%%%%%
% The SVD Part %
%%%%%%%%%%%%%%%%
if isempty(U)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get the response matrix %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isempty(Smat)
        for i = 1:length(OCS.BPM)
            Srow = [];
            for j = 1:length(OCS.CM)
                %if ModelRespFlag == 1
                if any(strcmpi(OCS.Flags,'ModelResp'))
                    % When using measbpmresp('Model')
                    % Rmat(1,1) is always horizontal
                    % Rmat(2,2) is always vertical
                    Rmat = measbpmresp('model',OCS.BPM{i},OCS.BPM{i}, OCS.CM{j},OCS.CM{j}, OCS.BPM{i}.Units);
                    if ismemberof(OCS.BPM{i}.FamilyName, gethbpmfamily) && ismemberof(OCS.CM{j}.FamilyName,gethcmfamily)
                        S = Rmat(1,1).Data;
                    elseif ismemberof(OCS.BPM{i}.FamilyName, getvbpmfamily) && ismemberof(OCS.CM{j}.FamilyName,gethcmfamily)
                        S = Rmat(2,1).Data;
                    elseif ismemberof(OCS.BPM{i}.FamilyName, gethbpmfamily) && ismemberof(OCS.CM{j}.FamilyName,getvcmfamily)
                        S = Rmat(1,2).Data;
                    elseif ismemberof(OCS.BPM{i}.FamilyName, getvbpmfamily) && ismemberof(OCS.CM{j}.FamilyName,getvcmfamily)
                        S = Rmat(2,2).Data;
                    else
                        error('Problem getting the model response matrix');
                    end
                else
                    % Get the golden BPM response matrix
                    [S, FileName] = getrespmat(OCS.BPM{i}, OCS.CM{j}, 'Numeric');
                    if any(find(isnan(S)))
                        error('Not all BPMs and correctors exist in the response matrix.');
                    end
                end
                if length(OCS.GoalOrbit{i}) ~= size(S,1)
                    error('The goal orbit vector length does not equal the response matrix row length');
                end

                Srow = [Srow S];
            end
            Smat = [Smat; Srow];
        end
        %SmatCheck = measbpmresp('Model','Numeric');
    end
end

    
%%%%%%%%%%%%%%%%%%
% Get Dispersion %
%%%%%%%%%%%%%%%%%%
if OCS.FitRF
    if ~isfield(OCS,'Eta') || isempty(OCS.Eta)
        Eta = [];
        for i = 1:length(OCS.BPM)
            if any(strcmpi(OCS.Flags,'ModelDisp'))
                %if strcmpi(DispFlag,'ModelDisp')
                DispOrbit = measdisp(OCS.BPM{i}, 'Hardware', 'Numeric', 'Model');
            elseif any(strcmpi(OCS.Flags,'MeasDisp'))
                %elseif strcmpi(DispFlag,'MeasDisp')
                DispOrbit = measdisp(OCS.BPM{i}, 'Hardware', 'Numeric');
            elseif any(strcmpi(OCS.Flags,'GoldenDisp'))
                %elseif strcmpi(DispFlag,'GoldenDisp')
                DispOrbit = getdisp(OCS.BPM{i}, 'Hardware', 'Numeric');
            end

            if strcmpi(OCS.BPM{i}.Units, 'Physics')
                % Put the RF change in physics units, not energy change
                RFhw = physics2hw(OCS.RF);
                DispOrbit = DispOrbit / (OCS.RF.Data / RFhw.Data);
            end

            if isempty(DispOrbit)
                error('Did not find or generate dispersion orbit properly');
            end
            if any(isnan(DispOrbit))
                error('The dispersion data has at least one NaN.');
            end

            % Build Eta vector and save it for the next time
            Eta = [Eta; DispOrbit];
            OCS.Eta{i} = DispOrbit;
        end
    else
        % Build Eta vector
        Eta = [];
        for i = 1:length(OCS.BPM)
            Eta = [Eta; OCS.Eta{i}];
        end
    end
end


% Save a weight free response matrix
SmatNoWeights = Smat;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build the orbit vectors %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
StartOrbitVec = [];
GoalOrbitVec = [];
BPMWeight = [];
for i = 1:length(OCS.BPM)
    StartOrbitVec = [StartOrbitVec; OCS.BPM{i}.Data(:)];
    GoalOrbitVec  = [GoalOrbitVec;  OCS.GoalOrbit{i}(:)];

    if ~isfield(OCS, 'BPMWeight') || isempty(OCS.BPMWeight{i})
        BPMWeight = [BPMWeight; ones(length(OCS.BPM{i}.Data),1)];
    elseif isscalar(OCS.BPMWeight{i})
        BPMWeight = [BPMWeight; ones(length(OCS.BPM{i}.Data),1) * OCS.BPMWeight{i}];
    else
        BPMWeight = [BPMWeight; OCS.BPMWeight{i}(:)];
    end
end


% Build column weight vector
% RF/Dispersion weight (if needed) is done later
CMWeight = [];
for i = 1:length(OCS.CM)
    if ~isfield(OCS, 'CMWeight') || isempty(OCS.CMWeight{i})
        % When using all singular values this does not do anything (besides numerical precision)
        % The amp to radian conversion is probably a better normalizer
        %CMWeight = 1 ./ sqrt(sum(Smat.^2));
        SmatStd = std(Smat)';
        if any(SmatStd == 0)
            % A zero column will cause a Inf
            iNotZero = find(SmatStd ~= 0);
            CMWeight = zeros(length(SmatStd),1);
            CMWeight(iNotZero) = 1./SmatStd(iNotZero);
        else
            CMWeight = 1./SmatStd;
        end


        % No weight
        %CMWeight = ones(size(Smat,2),1);

        %CMWeight = [CMWeight; ones(length(OCS.CM{i}.Data),1)];
        break;
    elseif isscalar(OCS.CMWeight{i})
        CMWeight = [CMWeight; ones(length(OCS.CM{i}.Data),1) * OCS.CMWeight{i}];
    else
        CMWeight = [CMWeight; OCS.CMWeight{i}(:)];
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a column weight to the response matrix %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if isempty(U)
    for j = 1:length(CMWeight)
        Smat(:,j) = Smat(:,j) * CMWeight(j);
    end
%end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a weighted disperion as a column of the response matrix %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if OCS.FitRF == 0
    % Don't fit the RF frequency
    OCS.DeltaRF = 0;
    OCS.RFWeight = [];
elseif any(OCS.FitRF == [1 2 3 4 5])
    % Column weighting (changing the units or sensitivity) seems to be a good thing.
    % (At least at the ALS working in hardware units.)
    % Weight by more than the average std of Smat also seems to give good results but
    % I'm not sure it's necessary or should be done.
    OCS.RFWeight = 10 * mean(std(Smat)) / std(Eta);
    if isinf(OCS.RFWeight) || isnan(OCS.RFWeight) || OCS.RFWeight==0
        OCS.RFWeight = 1;
    end
    Smat = [Smat OCS.RFWeight*Eta];
else
    error('Unknown RF correction method.');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a row weight to the response matrix %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Weighted LS
% Weighted LS was developed for heteroscedastic errors but it's used here for other reasons
% W*(Mmeas - Mmodel) = W*A*b + W*e,  where the e's are gausian, zero mean, independent, but not constant variance
% W is chosen to make E(Wee'W') = sigma * I  (ie, W * e has a constant variance)
%
% The new LS equations are,
% b = inv(Amod'*W' * W*Amod) * Amod'*W' * W*(Xgoal - Xmeasured);      % Parameter fit
% b = V(:,Ivec) * b;
% bvar = inv(Amod'*W'*W*Amod);
%
% Since the weight matrix, W, is only going to be diagonal, it is less memory
% to scaled Amod and (Mmeas-Model) by the diagonal term and not create the matrix W
if ~all(BPMWeight == 1)
    for i = 1:size(Smat,1)
        Smat(i,:) = BPMWeight(i) * Smat(i,:);
    end
end


%%%%%%%%%%%%%%%%
% The SVD Part %
%%%%%%%%%%%%%%%%
if isempty(U)
    if any(any(isnan(Smat)))
        error('The response matrix has at least one NaN.');
    end

    % Do the SVD
    [U, S, V] = svd(Smat, 0);  %'econ');
    S = diag(S);
end


% Determine the singular vector and error check
if isnumeric(OCS.SVDIndex)
    if length(OCS.SVDIndex) == 1
        if rem(OCS.SVDIndex,1) == 0
            OCS.SVDIndex = 1:OCS.SVDIndex;
        else
            % Use threshold
            Ivec = find(S > max(S)*OCS.SVDIndex);
            OCS.SVDIndex = Ivec;
        end
    end
elseif ischar(OCS.SVDIndex)
    if strcmpi(OCS.SVDIndex, 'All')
        OCS.SVDIndex = 1:length(S);
    else
        error('OCS.SVDIndex unknown');
    end
else
    error('OCS.SVDIndex unknown');
end

% Nothing greater then the total number is singular values
i = find(OCS.SVDIndex > length(S));
if ~isempty(i)
    fprintf('   Requested number of singular values is greater than the total -- removing %d.\n',length(i));
    OCS.SVDIndex(i) = length(S);
end

% No non-integers
OCS.SVDIndex = round(OCS.SVDIndex);

% Nothing less than zero
i = find(OCS.SVDIndex <= 0);
OCS.SVDIndex(i) = length(S);

% No repeats
OCS.SVDIndex = sort(OCS.SVDIndex);
i = find(diff(OCS.SVDIndex)==0);
OCS.SVDIndex(i) = [];

if isempty(OCS.SVDIndex)
    error('Singular values vector is empty');
end


if OCS.FitRF == 2 || OCS.FitRF == 3
    % Constrained L.S. with SVD
    % Constraint: Sum of the energy change to zero
    % Note: Model required
    
    R = [];
    HCMEnergyChangeTotal = 0;
    for i = 1:length(OCS.CM)
        if ismemberof(OCS.CM{i}.FamilyName, 'HCM')
            L = getfamilydata('Circumference');

            if ~isfield(OCS.CM{i}, 'Dispersion')
                % Dispersion at the correctors in physics units
                [OCS.CM{i}.Dispersion, DyHCM] = modeldisp([], OCS.CM{i}.FamilyName, OCS.CM{i}.DeviceList, 'Numeric', 'Physics');
            end
            
            % Present corrector setpoint in physics units
            HCM = hw2physics(OCS.CM{i});

            
            % Move ALS specific code to setorbitdefault ???
            if strcmpi(getfamilydata('Machine'),'ALS')
                % For the ALS, either the HCMCHICANE families need to be included or
                % the chicane "part" of the HCMs needs to be removed.  This will remove the chicane.
                Energy = getfamilydata('Energy');

                % Sector 6
                %                   Off    1.9 GeV   1.5 GeV
                % HCMCHICANEM(6,1)  80.0    18.0       ?
                % HCMCHICANEM(6,1)  80.0    20.0       ?
                % HCM(6,1)           0.0    18.8       ?
                ihcm = findrowindex([6 1], OCS.CM{i}.DeviceList);
                if length(ihcm) == 1
                    try
                        if getsp('HCMCHICANEM',[6 1]) < 70
                            % Assume sector 6 chicane is on
                            if Energy == 1.9
                                HCM.Data(ihcm) = HCM.Data(ihcm) + hw2physics(OCS.CM{i}.FamilyName, OCS.CM{i}.Field, -18.8, [6 1]);
                            else
                                HCM.Data(ihcm) = HCM.Data(ihcm) + hw2physics(OCS.CM{i}.FamilyName, OCS.CM{i}.Field,  -18.8*1.5/1.9, [6 1]);
                            end
                        end
                    catch
                        fprintf('%s\n', lasterr);
                        fprintf('Problem reading HCMCHICANEM(6,1).  The chicane "offset" on HCM(6,1) will not be removed.\n\n');
                    end
                end

                % Sector 11
                %                    Off    1.9 GeV   1.5 GeV
                % HCMCHICANEM(11,1)  80.0    40.5      52.0
                % HCMCHICANEM(11,1)  80.0    40.5      52.0
                % HCM(10,8)           0.0   -17.0     -14.0
                % HCM(11,1)           0.0   -17.0     -14.0
                ihcm = findrowindex([10 8], OCS.CM{i}.DeviceList);
                if length(ihcm) == 1
                    try
                        if getsp('HCMCHICANEM',[11 1]) < 60
                            % Assume sector 11 chicane is on
                            if Energy == 1.9
                                HCM.Data(ihcm) = HCM.Data(ihcm) + hw2physics(OCS.CM{i}.FamilyName, OCS.CM{i}.Field, [17; 17], [10 8;11 1]);
                            else
                                HCM.Data(ihcm) = HCM.Data(ihcm) + hw2physics(OCS.CM{i}.FamilyName, OCS.CM{i}.Field, [14; 14], [10 8;11 1]);
                            end
                        end
                    catch
                        fprintf('%s\n', lasterr);
                        fprintf('Due to an error, the chicane "offset" on HCM(10,8) will not be removed.n\n');
                    end
                end
                ihcm = findrowindex([11 1], OCS.CM{i}.DeviceList);
                if length(ihcm) == 1
                    try
                        if getsp('HCMCHICANEM',[11 1]) < 60
                            % Assume sector 11 chicane is on
                            if Energy == 1.9
                                HCM.Data(ihcm) = HCM.Data(ihcm) + hw2physics(OCS.CM{i}.FamilyName, OCS.CM{i}.Field, [17; 17], [10 8;11 1]);
                            else
                                HCM.Data(ihcm) = HCM.Data(ihcm) + hw2physics(OCS.CM{i}.FamilyName, OCS.CM{i}.Field, [14; 14], [10 8;11 1]);
                            end
                        end
                    catch
                        fprintf('%s\n', lasterr);
                        fprintf('Due to an error, the chicane "offset" on HCM(11,1) will not be removed.n\n');
                    end
                end
            end
            % END ALS only
            
            
            % Energy change to remove
            HCMEnergyChangeTotal = HCMEnergyChangeTotal + sum(-1 * HCM.Data .* OCS.CM{i}.Dispersion / getmcf / L);
            
            % Energy scaling must be in physics units, hence the (HCM.Data./OCS.CM{i}.Data)
            if strcmpi(OCS.CM{i}.Units, 'Hardware')
                % PhyicsUnitsScaling = (HCM.Data./OCS.CM{i}.Data);  %This does not work for zero setpoints
                PhyicsUnitsScaling = hw2physics(OCS.CM{i}. FamilyName,OCS.CM{i}.Field, 1, OCS.CM{i}.DeviceList); 
            else
                PhyicsUnitsScaling = 1;
            end
            HCMEnergyChangeScalar = -1 * PhyicsUnitsScaling .* OCS.CM{i}.Dispersion / getmcf / L;
            R = [R HCMEnergyChangeScalar(:)'];
            
            % Sum of correctors to zero
            %R = [R ones(size(HCMEnergyChange(:)'))];
        else
            R = [R zeros(1,size(OCS.CM{i}.DeviceList,1))];
        end
    end
    
    if OCS.FitRF == 2
        % Also remove the energy change due to the present corrector setpoints
        r = -HCMEnergyChangeTotal/2;    % Not sure about the divide by 2
    elseif OCS.FitRF == 3
        % Only remove energy change due to the incremental change in the correctors
        r = 0;
    end
    
    % Add a zero for no constaint on the RF
    R = [R 0];
    

    % Projection onto the columns of Smat*V (or U)
    % Since the correctors are V*b, the restriction in corrector strength is R*V
    X = Smat * V(:,OCS.SVDIndex);
    R = R * V(:,OCS.SVDIndex);
    b = inv(X'*X)*X' * (BPMWeight .* (GoalOrbitVec - StartOrbitVec));
    br = b - inv(X'*X)*R'*inv(R*inv(X'*X)*R')*(R*b-r);
    Delcm = V(:,OCS.SVDIndex) * br;

elseif OCS.FitRF == 4
    % Constrained L.S. with SVD
    % Constraint: dot(DisperionX,   Smat * dHCM) = 0
    %         or  dot(DisperionX' * Smat,  dHCM) = 0 or total dot(DisperionX, Smat * HCM)
    R = [];
    DispDotSmatHCM = 0;
    for i = 1:length(OCS.BPM)
        if strcmpi(OCS.BPM{i}.FamilyName, 'BPMx') || ismemberof(OCS.BPM{i}.FamilyName, 'BPMx')
            if ~isfield(OCS.BPM{i}, 'Dispersion')
                % Dispersion at the correctors in physics units
                [OCS.BPM{i}.Dispersion, Dy] = getdisp(OCS.BPM{i}.FamilyName, OCS.BPM{i}.DeviceList, 'Numeric',  OCS.BPM{i}.Units);
            end
            R = [R OCS.BPM{i}.Dispersion(:)'];
            
            HCM = physics2hw(OCS.CM{i});

            
            % Move ALS specific code to setorbitdefault ???
            if strcmpi(getfamilydata('Machine'),'ALS')
                % For the ALS, either the HCMCHICANE families need to be included or
                % the chicane "part" of the HCMs needs to be removed.  This will remove the chicane.
                Energy = getfamilydata('Energy');

                % Sector 6
                %                   Off    1.9 GeV   1.5 GeV
                % HCMCHICANEM(6,1)  80.0    18.0       ?
                % HCMCHICANEM(6,1)  80.0    20.0       ?
                % HCM(6,1)           0.0    18.8       ?
                ihcm = findrowindex([6 1], OCS.CM{i}.DeviceList);
                if length(ihcm) == 1
                    try
                        if getsp('HCMCHICANEM',[6 1]) < 70
                            % Assume sector 6 chicane is on
                            if Energy == 1.9
                                HCM.Data(ihcm) = HCM.Data(ihcm) - 18.8;
                            else
                                HCM.Data(ihcm) = HCM.Data(ihcm) - 18.8*1.5/1.9;
                            end
                        end
                    catch
                        fprintf('%s\n', lasterr);
                        fprintf('Due to an error, the chicane "offset" on HCM(6,1) will not be removed.\n\n');
                    end
                end

                % Sector 11
                %                    Off    1.9 GeV   1.5 GeV
                % HCMCHICANEM(11,1)  80.0    40.5      52.0
                % HCMCHICANEM(11,1)  80.0    40.5      52.0
                % HCM(10,8)           0.0   -17.0     -14.0
                % HCM(11,1)           0.0   -17.0     -14.0
                ihcm = findrowindex([10 8], OCS.CM{i}.DeviceList);
                if length(ihcm) == 1
                    try
                        if getsp('HCMCHICANEM',[11 1]) < 60
                            % Assume sector 11 chicane is on
                            if Energy == 1.9
                                HCM.Data(ihcm) = HCM.Data(ihcm) + 17;
                            else
                                HCM.Data(ihcm) = HCM.Data(ihcm) + 14;
                            end
                        end
                    catch
                        fprintf('%s\n', lasterr);
                        fprintf('Problem reading HCMCHICANEM(11,1).  The chicane "offset" on HCM(10,8) will not be removed.n\n');
                    end
                end
                ihcm = findrowindex([11 1], OCS.CM{i}.DeviceList);
                if length(ihcm) == 1
                    try
                        if getsp('HCMCHICANEM',[11 1]) < 60
                            % Assume sector 11 chicane is on
                            if Energy == 1.9
                                HCM.Data(ihcm) = HCM.Data(ihcm) + 17;
                            else
                                HCM.Data(ihcm) = HCM.Data(ihcm) + 14;
                            end
                        end
                    catch
                        fprintf('%s\n', lasterr);
                        fprintf('Due to an error, the chicane "offset" on HCM(11,1) will not be removed.n\n');
                    end
                end
            end
            % END ALS only


            % Assumes 1 HCM family and it's first???
            DispDotSmatHCM = DispDotSmatHCM + OCS.BPM{i}.Dispersion'*Smat(1:size(OCS.BPM{i}.DeviceList,1),1:1:size(OCS.CM{i}.DeviceList,1))*HCM.Data;
        else
            R = [R zeros(1,size(OCS.BPM{i}.DeviceList,1))];
        end
    end
    % [OCS.BPM{1}.Dispersion, Dy] = getdisp(OCS.BPM{1}.FamilyName, OCS.BPM{1}.DeviceList, 'Numeric', OCS.BPM{1}.Units);
    % RR = [OCS.BPM{1}.Dispersion(:); zeros(size(OCS.BPM{2}.DeviceList,1),1)]';

    %r = 0;
    r = -1*DispDotSmatHCM;  % Not sure if this should be divided by 2
    R = [R*Smat(:,1:end-1) 0];


    % Projection onto the columns of Smat*V (or U)
    % Since the correctors are V*b, the restriction in corrector strength is R*V
    X = Smat * V(:,OCS.SVDIndex);
    R = R * V(:,OCS.SVDIndex);
    b = inv(X'*X)*X' * (BPMWeight .* (GoalOrbitVec - StartOrbitVec));
    br = b - inv(X'*X)*R'*inv(R*inv(X'*X)*R')*(R*b-r);
    Delcm = V(:,OCS.SVDIndex) * br;
    
    %DelcmNoR = V(:,OCS.SVDIndex) * b;
    %fprintf('   dRF=%g  dRF(NoR)=%g\n',  OCS.RFWeight * Delcm(end),  OCS.RFWeight * DelcmNoR(end));
    
elseif OCS.FitRF == 5
    % Constrained L.S. with SVD
    % Constraint: dot(HCM(Dispersion), dHCM) = 0
    R = [];
    for i = 1:length(OCS.CM)
        if ismemberof(OCS.CM{i}.FamilyName, 'HCM')
            % Assume CM{i} is the same plane as BPM{i}
            if ~isfield(OCS.BPM{i}, 'Dispersion')
                % Dispersion at the horizontal BPMs
                [OCS.BPM{i}.Dispersion, Dy] = getdisp(OCS.BPM{i}.FamilyName, OCS.BPM{i}.DeviceList, 'Numeric',  OCS.BPM{i}.Units);

                % Find the corrector pattern of the dispersion orbit
                %
                % OCS.SVDIndex ????
                % Smat???  make an array
                % Why is Rhcm so different from Rbpmx?
                
                % Assumes 1 HCM family and it's first???
                SmatNoEta = Smat(1:size(OCS.BPM{i}.DeviceList,1),1:size(OCS.CM{i}.DeviceList,1));
                [UU, SS, VV] = svd(SmatNoEta, 'econ');
                SS = diag(SS);

                X = SmatNoEta * VV(:,OCS.SVDIndex);
                b = inv(X'*X)*X' * OCS.BPM{i}.Dispersion;
                OCS.BPM{i}.DispersionCorrectors = VV(:,OCS.SVDIndex) * b;
            end
            R = [R OCS.BPM{i}.DispersionCorrectors(:)'];
        else
            R = [R zeros(1,size(OCS.CM{i}.DeviceList,1))];
        end
    end

    r = 0;  % Should it be an absolute conditional ???
    R = [R 0];


    % Projection onto the columns of Smat*V (or U)
    % Since the correctors are V*b, the restriction in corrector strength is R*V
    X = Smat * V(:,OCS.SVDIndex);
    R = R * V(:,OCS.SVDIndex);
    b = inv(X'*X)*X' * (BPMWeight .* (GoalOrbitVec - StartOrbitVec));
    br = b - inv(X'*X)*R'*inv(R*inv(X'*X)*R')*(R*b-r);
    Delcm = V(:,OCS.SVDIndex) * br;
    
    %DelcmNoR = V(:,OCS.SVDIndex) * b;
    %fprintf('   dRF=%g  dRF(NoR)=%g\n',  OCS.RFWeight * Delcm(end),  OCS.RFWeight * DelcmNoR(end));

else

    % L.S. with SVD algorithm
    % The V matrix columns are the singular vectors in the corrector magnet space
    % The U matrix columns are the singular vectors in the BPM space
    % Smat = U*S*V' where U'*U=I and V*V'=I
    %
    % b is the coef. of the projection onto the columns of Smat*V(:,Ivec) - the corrector space (same space as spanned by U)
    % Sometimes it's interesting to look at the size of these coefficients with singular value number.
    b = U(:,OCS.SVDIndex)' * (BPMWeight .* (GoalOrbitVec - StartOrbitVec));
    b = diag(S(OCS.SVDIndex).^(-1)) * b;

    % Convert the b vector back to coefficents of response matrix
    Delcm = V(:,OCS.SVDIndex) * b;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove Weights for the Correction %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Separate the RF from the correctors
if OCS.FitRF
    % RF frequency is the last actuator
    OCS.DeltaRF = OCS.RFWeight * Delcm(end);
    Delcm = Delcm(1:end-1);
end

% Remove column weights from Delcm
Delcm = Delcm .* CMWeight;
    
    
% Predict Orbit
if OCS.FitRF
    OrbitDeltaTotal = [SmatNoWeights Eta] * [Delcm; OCS.DeltaRF];
else
    OrbitDeltaTotal = SmatNoWeights * Delcm;
end
for j = 1:length(OCS.BPM)
    N = length(OCS.BPM{j}.Data);
    OCS.BPM{j}.PredictedOrbitDelta = OrbitDeltaTotal(1:N);
    OrbitDeltaTotal(1:N) = [];
end


% Don't put the Delcm into OCS.CM so this function can get
% called multiple times before actually correcting the orbit
for i = 1:length(OCS.CM)
    N = length(OCS.CM{i}.Data);
    %OCS.CM{i}.Data = OCS.CM{i}.Data + Delcm(1:N);
    OCS.CM{i}.Delta = Delcm(1:N);
    Delcm(1:N) = [];

    OCS.CMWeight{i} = CMWeight(1:N);
    CMWeight(1:N) = [];
end


% Remove the cell array if the length is one
if NoCellBPMFlag
    OCS.BPM = OCS.BPM{1};
    OCS.GoalOrbit = OCS.GoalOrbit{1};
    if isfield(OCS,'BPMWeight')
        OCS.BPMWeight = OCS.BPMWeight{1};
    end
end
if NoCellCMFlag
    OCS.CM = OCS.CM{1};
    if isfield(OCS,'CMWeight')
        OCS.CMWeight = OCS.CMWeight{1};
    end
end


% Output statistics???
% 1. Correctable orbit
% 2. Not correctable orbit
% 3. Error propagation

    
