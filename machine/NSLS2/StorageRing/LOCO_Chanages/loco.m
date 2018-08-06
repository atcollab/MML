function [LocoModel, BPMData, CMData, FitParameters, LocoFlags, RINGData] = loco(LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData)
%LOCO - Main routine for the LOCO algorithm
%
%  [LocoModel, BPMData, CMData, FitParameters, LocoFlags, RINGData] = loco(LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData)
%
%  See LocoManual.doc for details
%
%  See also locogui, locofilecheck, locoresponsematrix, locosetlatticeparam

%  Written by Greg Portmann, James SaFranek, Andrei Terebilo, and Xiaobiao Huang
%  Xi Yang made modification with the choice of using saved Jacobian
%  instead of calculating every time. Also, svd(JtJ) in GN and GN with cost
%  function using similar method LM used (reduced time for svd
%  tremendously)


if nargin == 0
    locogui;
    return;
end

% Initialize
RMSGoal = 1e-6;           % RMS change in the response matrix for parameter changes [meters]
RMSToleranceFactor = 10;  % Lower tolerance for excepting the response matrix without recomputing (/3 for upper tolerance)

% If LocoFlags.Normalization.ByRMSFlag, then normalize by sum(Mmodel.^2)
%                            else normalize to keep things similar to the response matrix
LocoFlags.Normalization.ByRMSFlag = 0;


% Check inputs and add defaults
[BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck({BPMData, CMData, LocoMeasData, [], FitParameters, LocoFlags, RINGData});
[BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = LOCOInputChecks(BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData);



% UNITS CONVERSIONS (to be combatible with tracking code)
% Convert corrector kicks used in the response matrix to radians
CMData.HCMKicks = CMData.HCMKicks(:) / 1000;   % milliradian to radians (column vector)
CMData.VCMKicks = CMData.VCMKicks(:) / 1000;   % milliradian to radians (column vector)

% Convert the measured response matrix to meters
LocoMeasData.M = LocoMeasData.M / 1000;

% Convert the BPMSTD to meters and make the same size as a response matrix
LocoMeasData.BPMSTD = LocoMeasData.BPMSTD / 1000;    % mm to meters
Mstd = LocoMeasData.BPMSTD * ones(1,size(LocoMeasData.M,2));

% Convert orbit for "dispersion" in meters in column vector format
LocoMeasData.Eta = LocoMeasData.Eta(:) / 1000;       % mm to meters
% END UNITS CONVERTSION


% Pack the kicks into one vector
Kicks = [CMData.HCMKicks(CMData.HCMGoodDataIndex);
         CMData.VCMKicks(CMData.VCMGoodDataIndex)];


% Use the entire family of BPMs in the model response matrix, then index later (not much difference computationally)
[A_NRows, A_NCols, N] = LocoJacobianSize(LocoModel, LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData);
BPMIndexShortX = BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex);
BPMIndexShortY = length(BPMData.BPMIndex)+BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex);
BPMIndexShort = [BPMIndexShortX(:)' BPMIndexShortY(:)'];


% Remove unwanted data from the Mmeas and Mstd
Mmeas = LocoMeasData.M([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], [CMData.HCMGoodDataIndex length(CMData.HCMIndex)+CMData.VCMGoodDataIndex]);
Mstd  =           Mstd([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], [CMData.HCMGoodDataIndex length(CMData.HCMIndex)+CMData.VCMGoodDataIndex]);

% If including dispersion then Mstd and Mmeas must include disperion term
if strcmpi((LocoFlags.Dispersion),'yes')
    Xstd = LocoMeasData.BPMSTD(BPMData.HBPMGoodDataIndex);
    Ystd = LocoMeasData.BPMSTD(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex);

    if isempty(LocoMeasData.Eta)
        error('Measured dispersion (LocoMeasData.Eta) can not be empty when including dispersion');
    end
    EtaX = LocoMeasData.Eta(BPMData.HBPMGoodDataIndex);
    EtaY = LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex);

    LocoFlags.HorizontalDispersionWeight = abs(LocoFlags.HorizontalDispersionWeight);
    LocoFlags.VerticalDispersionWeight   = abs(LocoFlags.VerticalDispersionWeight);

    % Should remove the dispersion if both weights are zero
    if LocoFlags.HorizontalDispersionWeight == 0
        LocoFlags.HorizontalDispersionWeight = eps;
    end
    if LocoFlags.VerticalDispersionWeight == 0
        LocoFlags.VerticalDispersionWeight = eps;
    end

    % Weight the dispersion
    Mstd  = [Mstd  [Xstd/LocoFlags.HorizontalDispersionWeight; Ystd/LocoFlags.VerticalDispersionWeight]];
    Mmeas = [Mmeas [EtaX; EtaY]];
end


% Convert to a column vector
Mstd  = Mstd(:);
Mmeas = Mmeas(:);


% Build the corrector magnet data structures to be used with locoresponsematrix
if isfield(CMData, 'FamName')
    CMDataRM.FamName = CMData.FamName;
end
CMDataRM.HCMIndex = CMData.HCMIndex(CMData.HCMGoodDataIndex);
CMDataRM.VCMIndex = CMData.VCMIndex(CMData.VCMGoodDataIndex);
CMDataRM.HCMKicks = CMData.HCMKicks(CMData.HCMGoodDataIndex);
CMDataRM.VCMKicks = CMData.VCMKicks(CMData.VCMGoodDataIndex);
CMDataRM.HCMCoupling = CMData.HCMCoupling(CMData.HCMGoodDataIndex);
CMDataRM.VCMCoupling = CMData.VCMCoupling(CMData.VCMGoodDataIndex);
CMDataRM.HCMEnergyShift = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
CMDataRM.VCMEnergyShift = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BUILD THE JACOBIAN MATRIX, A  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi((LocoFlags.Jacobian), 'yes')
    [A, b_old, Mmodel, iNoCoupling, LocoFlags] = BuildTheJacobian(LocoMeasData, LocoModel, BPMData, CMData, CMDataRM, FitParameters, LocoFlags, RINGData, A_NRows, A_NCols, N, Kicks, BPMIndexShort, RMSGoal, RMSToleranceFactor);
  save('Jacobian.mat','A');
else
    [A, b_old, Mmodel, iNoCoupling, LocoFlags] = CallTheJacobian(LocoMeasData, LocoModel, BPMData, CMData, CMDataRM, FitParameters, LocoFlags, RINGData, A_NRows, A_NCols, N, Kicks, BPMIndexShort, RMSGoal, RMSToleranceFactor);
end

% When using the fixed momentum response matrix calculator, the merit function becomes:
%              Merit = Mmeas_ij - Mmod_ij - Dp/p_j * eta_i
%              where eta_i is the measured eta (not the model eta)
% This is done by changing Mmodel to (Mmodel_ij + Dp/p_j * eta_i)
%if strcmpi((CMData.FitHCMEnergyShift),'yes') | strcmpi((CMData.FitVCMEnergyShift),'yes')
if strcmpi((LocoFlags.ClosedOrbitType), 'fixedmomentum')
    HCMEnergyShift = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
    VCMEnergyShift = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);

    %Mmodel = reshape(Mmodel,N.HBPM+N.VBPM,N.HCM+N.VCM);

    if ~exist('AlphaMCF')
        AlphaMCF = locomcf(RINGData);
        EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
        EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    end

    for i = 1:length(HCMEnergyShift)
        Mmodel(:,i) = Mmodel(:,i) + HCMEnergyShift(i) * [EtaXmcf; EtaYmcf];
    end

    for i = 1:length(VCMEnergyShift)
        Mmodel(:,N.HCM+i) = Mmodel(:,N.HCM+i) + VCMEnergyShift(i) * [EtaXmcf; EtaYmcf];
    end
end


% Column vectorize the model
% Note: Mmodel still has the coupling and outliers at this point.  iOutliers get computed later and is indexed on column format.
Mmodel = Mmodel(:);


% Remove coupling rows
if strcmpi(LocoFlags.Coupling,'No')
    Mmodel = Mmodel(iNoCoupling,:);
    Mmeas = Mmeas(iNoCoupling,:);
    Mstd = Mstd(iNoCoupling,:);
end


% Compute the partial of chi^2 w.r.t. each parameter change
LocoFlags = CalcPartialChi2(A, Mstd, LocoFlags, N);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  LEAST SQUARES (SVD) MINIMIZATION %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% min | A*b - (Mmeas - Mmodel) |
%  b
%
% Note 1: ChiSquare has the outliers removed.
% Note 2: ChiSquareVector is only computed if the user requests it with LocoFlags.SVmethod=[] (interactive).


% Weighted LS
% Since BPM errors can be heteroscedastic, weighted LS is used.
% W*(Mmeas - Mmodel) = W*A*b + W*e,  where the e's are gausian, zero mean, independent, but not constant variance
% W is chosen to make E(Wee'W') = sigma * I  (ie, W * e has a constant variance)
%
% The new LS equations are,
% b = inv(Amod'*W'*W*Amod)*Amod'*W'*W*(Mmeas - Mmodel);      % Parameter fit
% b = V(:,Ivec) * b;
% bvar = inv(Amod'*W'*W*Amod);
%
% Since the weight matrix, W, is only going to be diagonal, it is less memory
% to scaled Amod and (Mmeas-Model) by the diagonal term and not create the matrix W
for i = 1:length(Mstd)
    A(i,:) = A(i,:) / Mstd(i);
end


% Look for outliers in Mmeas
% Remove row from A, Mmeas, Mmodel if any element of Mmeas-Mmodel is greater than LocoFlags.OutlierFactor time the std(Mmeas-Mmodel).
% The test is done twice in case an outlier is very large and can affect the mean and std.
%y = Mmeas;             % All points in the measurement shouldn't be too far from the std (this does not work for dispersion)
y = Mmeas - Mmodel;     % If the model is far off from the measurement, this could be a problem (make the LocoFlags.OutlierFactor large)

% % Note: dispersion error should be scaled by the weight (maybe this should be made a separate outlier test)
% % Remove the weight on the dispersion for the outlier calculation
% if strcmpi((LocoFlags.Dispersion),'yes')
%     % Horizontal and vertical dispersion were added to the response matrix
%     WeightedEta = y(end-N.BPM+1:end);
%     UnWeightedEtaX = WeightedEta(1:N.HBPM) * LocoFlags.HorizontalDispersionWeight;
%     UnWeightedEtaY = WeightedEta(N.HBPM+(1:N.VBPM)) * LocoFlags.VerticalDispersionWeight;
%     y(end-N.BPM+1:end) = [UnWeightedEtaX; UnWeightedEtaY];
% end

i1 = find(abs(y-mean(y)) >  LocoFlags.OutlierFactor*std(y));             % Index of bad  data points, first  test
j1 = find(abs(y-mean(y)) <= LocoFlags.OutlierFactor*std(y));             % Index of good data points, first  test
i2 = find(abs(y(j1)-mean(y(j1))) > LocoFlags.OutlierFactor*std(y(j1)));  % Index of bad  data points, second test
iOutliers = sort([i1; j1(i2)]);

if isempty(iOutliers)
    fprintf('   No outliers in the data set.\n');
else
    fprintf('   std(Model-Measurement) = %f mm (with outliers)\n', 1000*std(Mmeas-Mmodel));
    A(iOutliers,:)      = [];
    Mmeas(iOutliers,:)  = [];
    Mmodel(iOutliers,:) = [];
    Mstd(iOutliers,:)   = [];
    fprintf('   %d outliers removed out of %d points (> %d sigma) (%d first test + %d second test).\n', length(iOutliers), length(y), LocoFlags.OutlierFactor, length(i1), length(j1(i2)));
end
fprintf('   std(Model-Measurement) = %f mm\n', 1000*std(Mmeas-Mmodel));


% Normalize A  (which can be thought of as a change in units of the parameters)
% Force the square sum of the column of A for parameter fits to that of Mmodel
% Divid the CMs by the kick
% A = [BPMHgains BPMHcoupling BPMVcoupling BPMVgains HCMkick VCMkick HCMcoupling VCMcoupling HCMEnergyShift VCMEnergyShift RF ParamFits]
Mmodelsq = sum((Mmodel./Mstd).^2);  %sum(Mmodel.^2);
if strcmpi((FitParameters.FitRFFrequency),'yes')
    % Always normalize the RF frequency fit
    %LocoFlags.Normalization.FactorRF = sqrt(sum(A(:,end-length(FitParameters.Params):end-length(FitParameters.Params)).^2) / Mmodelsq)';
    LocoFlags.Normalization.FactorRF = 1 / FitParameters.DeltaRF / 10;    % Extra weighted just to get a better fit
    A(:,end-length(FitParameters.Params)) = A(:,end-length(FitParameters.Params)) / LocoFlags.Normalization.FactorRF;
else
    LocoFlags.Normalization.FactorRF = [];
end

LocoFlags.Normalization.Factor = [];
if strcmpi(LocoFlags.Normalization.Flag,'yes')
    if LocoFlags.Normalization.ByRMSFlag
        % Entire A matrix
        % Note: the RF freq will get normalized twice but that's OK
        LocoFlags.Normalization.Factor = sqrt(sum(A.^2) / Mmodelsq)';
        for i = 1:length(LocoFlags.Normalization.Factor)
            A(:,i) = A(:,i) / LocoFlags.Normalization.Factor(i);
        end

        %% Just the parameter fits
        %if length(FitParameters.Params) ~= 0
        %    LocoFlags.Normalization.Factor = sqrt(sum(A(:,end-length(FitParameters.Params)+1:end).^2) / Mmodelsq)';
        %    for i = 1:length(FitParameters.Params)
        %        A(:,i+end-length(FitParameters.Params)) = A(:,i+end-length(FitParameters.Params)) / LocoFlags.Normalization.Factor(i);
        %    end
        %end
    else
        % BPMs do not need a normalization factor since everything is normalized to the BPMs

        % Corrector magnets
        if ~isempty(LocoFlags.Normalization.FactorCM)
            for i = 1:length(LocoFlags.Normalization.FactorCM)
                A(:,i+N.BPMfit) = A(:,i+N.BPMfit) / LocoFlags.Normalization.FactorCM(i);
            end
        end
        if strcmpi((CMData.FitCoupling),'yes')
            NN = length(LocoFlags.Normalization.FactorCM);
            for i = 1:N.HCM+N.VCM
                LocoFlags.Normalization.FactorCM(NN+i,1) = sqrt(sum(A(:,N.BPMfit+NN+i).^2) / Mmodelsq);
                A(:,i+N.BPMfit+NN) = A(:,i+N.BPMfit+NN) / LocoFlags.Normalization.FactorCM(NN+i);
            end
        end
        if strcmpi((CMData.FitHCMEnergyShift),'yes')
            %NN = length(LocoFlags.Normalization.FactorCM);
            %for i = 1:N.HCM
            %    LocoFlags.Normalization.FactorCM(NN+i) = sqrt(sum(A(:,N.BPMfit+NN+i).^2) / Mmodelsq);
            %    A(:,i+N.BPMfit+NN) = A(:,i+N.BPMfit+NN) / LocoFlags.Normalization.FactorCM(NN+i);
            %end
            NN = N.BPMfit + length(LocoFlags.Normalization.FactorCM);
            A(:,NN+1:NN+N.HCM) = A(:,NN+1:NN+N.HCM) / LocoFlags.Normalization.FactorHCMEnergy;
        end
        if strcmpi((CMData.FitVCMEnergyShift),'yes')
            %NN = length(LocoFlags.Normalization.FactorCM);
            %for i = 1:N.VCM
            %    LocoFlags.Normalization.FactorCM(NN+i) = sqrt(sum(A(:,N.BPMfit+NN+i).^2) / Mmodelsq);
            %    A(:,i+N.BPMfit+NN) = A(:,i+N.BPMfit+NN) / LocoFlags.Normalization.FactorCM(NN+i);
            %end
            NN = N.BPMfit + length(LocoFlags.Normalization.FactorCM) + N.HCM;
            A(:,NN+1:NN+N.VCM) = A(:,NN+1:NN+N.VCM) / LocoFlags.Normalization.FactorVCMEnergy;
        end

        % Parameter fits
        if ~isempty(FitParameters.Params)
            LocoFlags.Normalization.Factor = sqrt(sum(A(:,end-length(FitParameters.Params)+1:end).^2) / Mmodelsq)';
            for i = 1:length(FitParameters.Params)
                A(:,i+end-length(FitParameters.Params)) = A(:,i+end-length(FitParameters.Params)) / LocoFlags.Normalization.Factor(i);
            end
        end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Include a cost function by adding rows to the Jacobian matrix A and response vector y %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if any(strcmpi(LocoFlags.Method.Name, {'Gauss-Newton With Cost Function', 'Levenberg-Marquardt'}))  ???
%if strcmpi(LocoFlags.Method.Name, 'Gauss-Newton With Cost Function') || (strcmpi(LocoFlags.Method.Name, 'Levenberg-Marquardt') && isfield(FitParameters, 'Cost'))
if strcmpi(LocoFlags.Method.Name, 'Gauss-Newton With Cost Function')
    % Partition a cost matrix
    
    CostVector = GetFromLocoFlagsMethods('Cost', LocoFlags, BPMData, CMData, FitParameters);
    
    % Look for a scaling of the costs
    if isfield(LocoFlags.Method, 'CostScaleFactor') && ~isempty(LocoFlags.Method.CostScaleFactor)
        CostVector = LocoFlags.Method.CostScaleFactor * CostVector;
    end
    
    if isempty(CostVector)
        % Create and save the costs (like scaled-LM)
        if isfield(LocoFlags.Method, 'CostScaleFactor') && ~isempty(LocoFlags.Method.CostScaleFactor)
            fprintf('   Cost vector is empty, using CostScaleFactor*sqrt(diag(A''*A) as a staring point.\n');
            fprintf('   (Same as the scaled Levenberg-Marquardt with Lambda replaced with CostScaleFactor.)\n');
            CostVector = LocoFlags.Method.CostScaleFactor * sqrt(diag(A' * A));
        else
            fprintf('   Cost vector is empty, using .01*sqrt(diag(A''*A) as a staring point.\n');
            fprintf('   (Same as the scaled Levenberg-Marquardt with Lambda = .01)\n');
            CostVector = .01 * sqrt(diag(A' * A));
        end
        LocoFlags = AddMethodToLocoFlags('Cost', CostVector, LocoFlags, BPMData, CMData, FitParameters, N);
    end

    NumCosts  = length(CostVector);
    Arows = size(A,1);
    if strcmpi(LocoFlags.SinglePrecision, 'yes')
        A = [A; zeros(NumCosts, size(A,2), 'single')];
    else
        A = [A; zeros(NumCosts, size(A,2))];
    end
    fprintf('   Adding cost to the gradient matrix (%d rows)\n', NumCosts);

    % Add the cost function
    FieldCell = fieldnames(LocoFlags.Method.Cost);
    for i = 1:length(FieldCell)
        Cost = LocoFlags.Method.Cost.(FieldCell{i});
        for j = 1:length(Cost)
            Arows = Arows + 1;
            A(Arows, N.Index.(FieldCell{i})+j-1) = Cost(i);
        end
    end
    
    % This only works because there should always be a fit parameter cost (should fix this???)
    %MeanMstd = mean(Mstd);
    %for ii = 1:NumCosts  
    %    A(end-ii, end-ii) = CostVector(end-ii);
    %end
end


% % Compute S and select the singular vectors (A should already be single at this point -> check this???)
% if strcmpi(LocoFlags.SinglePrecision, 'yes')
%     A = single(A);
% end


% Weight the model error to be fit
y = (Mmeas - Mmodel) ./ Mstd;


%%%%%%%%%%%%%%%%%
% Cost Function %
%%%%%%%%%%%%%%%%%
%if any(strcmpi(LocoFlags.Method.Name, {'Gauss-Newton With Cost Function', 'Levenberg-Marquardt'}))  ???
%if strcmpi(LocoFlags.Method.Name, 'Gauss-Newton With Cost Function') || (strcmpi(LocoFlags.Method.Name, 'Levenberg-Marquardt') && isfield(FitParameters, 'Cost'))
if strcmpi(LocoFlags.Method.Name, 'Gauss-Newton With Cost Function')
    % Add the extra parameters (costs) to y
    y(end + (1:NumCosts)) = 0;
end


% Single precision conversion
if strcmpi(LocoFlags.SinglePrecision, 'yes')
    y = single(y);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve the Minimization Problem %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if any(strcmpi(LocoFlags.Method.Name, {'Gauss-Newton', 'Gauss-Newton With Cost Function'}))

%     fprintf('   %s Method\n', LocoFlags.Method.Name);
% 
%     % SVD calculation (Gauss-Newton method or U, S, V save requested)
%     fprintf('   Computing SVD (%d,%d) ... ', size(A)); tic
%     [U, S, V] = svd(A,0);
%     fprintf('%f seconds. \n',toc);
% 
%     % Save data if requested by the user
%     % Note: 1. A is weighted by the sigma.  This can be removed if A would saved earier.
%     %       2. Outliers are removed from A, U, S, and V
%     if ischar(LocoFlags.SVDDataFileName) && ~isempty(LocoFlags.SVDDataFileName)
%         save(LocoFlags.SVDDataFileName, 'A','U','S','V');
%     end
% 
%     [b_delta, b_std, LocoFlags] = LOCO_GaussNewton_Search(A, y, U, S, V, Mmodel, Mmeas, Mstd, LocoFlags, CMData, FitParameters, N);
% 
%     % Remove the normalization factor
%     b_delta = RemoveNormalizationFactors(b_delta, N, CMData, FitParameters, LocoFlags);
%     b_new = b_old + b_delta;
%     [LocoModel, BPMData, CMData, FitParameters, LocoFlags, RINGData] = MeritFunctionAndBookKeeping(LocoMeasData, BPMData, CMData, CMDataRM, FitParameters, LocoFlags, RINGData, b_new, b_std, N, BPMIndexShort, iNoCoupling, iOutliers);
    
   %%%%%%%%%%%%%%%%%%%
   %modify svd(JtJ) instead of svd(J)
   %%%%%%%%%%%%%%%%%%%
    fprintf('   %s Method\n', LocoFlags.Method.Name);

    % SVD calculation 
    ay = A' * y;
    C = A'*A; 
    
    fprintf('   Computing SVD (%d,%d) ... ', size(C)); tic
    [U, S] = svd(C);
    fprintf('%f seconds. \n',toc);
    
    LocoFlags.Method.SV = diag(S);    
    Ivec = SingularValueSelectionLM(A, S, U, ay, Mstd, Mmeas, Mmodel, LocoFlags.SVmethod);
    LocoFlags.Method.SVIndex = Ivec; 
    
 
    Chi2_0 = lococalcchi2(LocoModel, LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData, 0);
  
    fprintf('   Computing the least square minimization ... '); tic
    b = U(:,Ivec)' * ay;

        % Looping uses less memory
        %b = diag(diag(S(Ivec,Ivec)).^(-1)) * b;
        for iSVD = 1:length(Ivec)
            b(iSVD) = b(iSVD) / S(Ivec(iSVD),Ivec(iSVD));
        end

        % b at this point is the projection onto the columns of C*V(:,Ivec)
        % Convert the vector b back to coefficents of C  (V=U for svd(A'*A))
        b = U(:,Ivec) * b;
        fprintf('%f seconds. \n',toc);        
        
        % Ignor variance for now
        b_std = NaN * ones(size(U,1),1);
     
        %SValues = diag(S);
        b_delta = b;

        % Remove the normalization factor
        b_delta = RemoveNormalizationFactors(b_delta, N, CMData, FitParameters, LocoFlags);
        b_new = b_old + b_delta;
        [LocoModel, BPMData, CMData, FitParameters, LocoFlags, RINGData] = MeritFunctionAndBookKeeping(LocoMeasData, BPMData, CMData, CMDataRM, FitParameters, LocoFlags, RINGData, b_new, b_std, N, BPMIndexShort, iNoCoupling, iOutliers);
  
    % Save data if requested by the user
    % Note: 1. A is weighted by the sigma.  This can be removed if A would saved earier.
    %       2. Outliers are removed from A, U, and S
    if ischar(LocoFlags.SVDDataFileName) && ~isempty(LocoFlags.SVDDataFileName)
        save(LocoFlags.SVDDataFileName, 'A','U','S');
    end
%     % Save data if requested by the user
%     % Note: 1. A is weighted by the sigma.  This can be removed if A would saved earier.
%     %       2. Outliers are removed from A, U, S, and V
%     if ischar(LocoFlags.SVDDataFileName) && ~isempty(LocoFlags.SVDDataFileName)
%         save(LocoFlags.SVDDataFileName, 'A','U','S','V');
%     end

%    [b_delta, b_std, LocoFlags] = LOCO_GaussNewton_Search(A, y, U, S, V, Mmodel, Mmeas, Mstd, LocoFlags, CMData, FitParameters, N);

   
    
    
elseif strcmpi(LocoFlags.Method.Name, 'Levenberg-Marquardt')

    fprintf('   Levenberg-Marquardt Method\n');
    fprintf('   Starting Lambda = %s\n', num2str(LocoFlags.Method.Lambda));
    fprintf('   Maximum iterations = %d\n', LocoFlags.Method.MaxIter);

    LMlambda = LocoFlags.Method.Lambda;

    ay = A' * y;
    C = A'*A + LMlambda * eye(size(A,2));
    fprintf('   Computing SVD (%d,%d) ... ', size(C)); tic
    [U, S] = svd(C);
    fprintf('%f seconds. \n',toc);

    LocoFlags.Method.SV = diag(S);    
    Ivec = SingularValueSelectionLM(A, S, U, ay, Mstd, Mmeas, Mmodel, LocoFlags.SVmethod);
    LocoFlags.Method.SVIndex = Ivec;

    Chi2_0 = lococalcchi2(LocoModel, LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData, 0);

    % Save the starting iteration
    LocoModel0 = LocoModel;
    BPMData0 = BPMData;
    CMData0 = CMData;
    FitParameters0 = FitParameters;
    LocoFlags0 = LocoFlags;
    RINGData0 = RINGData;
    
    cnt = 0;
    BetterMinimumFlag = 0;
    disp(' ');
    while cnt < LocoFlags.Method.MaxIter
        disp(['   Lambda = ' num2str(LMlambda)]);

        fprintf('   Computing the least square minimization ... '); tic
        b = U(:,Ivec)' * ay;

        % Looping uses less memory
        %b = diag(diag(S(Ivec,Ivec)).^(-1)) * b;
        for iSVD = 1:length(Ivec)
            b(iSVD) = b(iSVD) / S(Ivec(iSVD),Ivec(iSVD));
        end

        % b at this point is the projection onto the columns of C*V(:,Ivec)
        % Convert the vector b back to coefficents of C  (V=U for svd(A'*A))
        b = U(:,Ivec) * b;
        fprintf('%f seconds. \n',toc);        
        
        % Ignor variance for now
        b_std = NaN * ones(size(U,1),1);
     
        %SValues = diag(S);
        b_delta = b;

        % Remove the normalization factor
        b_delta = RemoveNormalizationFactors(b_delta, N, CMData, FitParameters, LocoFlags);
        b_new = b_old + b_delta;
        [LocoModel, BPMData, CMData, FitParameters, LocoFlags, RINGData] = MeritFunctionAndBookKeeping(LocoMeasData, BPMData, CMData, CMDataRM, FitParameters, LocoFlags, RINGData, b_new, b_std, N, BPMIndexShort, iNoCoupling, iOutliers);

        if FitParameters.Chi2.Chi2 < Chi2_0
            LMlambda = LMlambda/10.;
            BetterMinimumFlag = 1;
            break;
        else
            % Not good!, restore values
            LocoModel = LocoModel0;
            BPMData = BPMData0;
            CMData = CMData0;
            FitParameters = FitParameters0;
            LocoFlags = LocoFlags0;
            RINGData = RINGData0;
            b_new = b_old;

            LMlambda = 10 * LMlambda;

            if LMlambda > 1e15
                break;
            end
        end

        cnt = cnt + 1;
        if cnt < LocoFlags.Method.MaxIter
            C = A'*A + LMlambda * eye(size(A,2));
            fprintf('   Computing SVD (%d,%d) ... ', size(C)); tic
            [U, S] = svd(C);
            fprintf('%f seconds. \n',toc);
        end
    end

    LocoFlags.Method.LambdaFinal = LMlambda;

    % Save the costs
    LocoFlags = AddMethodToLocoFlags('Cost', sqrt(LMlambda)*ones(size(A,2),1), LocoFlags, BPMData, CMData, FitParameters, N);

    if ~BetterMinimumFlag
        LocoModel = MeritFunctionAndBookKeeping(LocoMeasData, BPMData, CMData, CMDataRM, FitParameters, LocoFlags, RINGData, b_new, b_std, N, BPMIndexShort, iNoCoupling, iOutliers);
        LocoFlags.Method.BetterSolution = 'No';
        fprintf('   No better solution found.\n\n');
    else
        LocoFlags.Method.BetterSolution = 'Yes';
    end

    % Save data if requested by the user
    % Note: 1. A is weighted by the sigma.  This can be removed if A would saved earier.
    %       2. Outliers are removed from A, U, and S
    if ischar(LocoFlags.SVDDataFileName) && ~isempty(LocoFlags.SVDDataFileName)
        save(LocoFlags.SVDDataFileName, 'A','U','S');
    end


elseif strcmpi(LocoFlags.Method.Name, 'Scaled Levenberg-Marquardt')
    
    fprintf('   Scaled Levenberg-Marquardt Method\n');
    fprintf('   Starting Lambda = %s\n', num2str(LocoFlags.Method.Lambda));
    fprintf('   Maximum iterations = %d\n', LocoFlags.Method.MaxIter);
        
    LMlambda = LocoFlags.Method.Lambda;    
                         
    ay = A' * y;
    C  = A' * A;
        
    % D = sqrt(diag(diag(A'*A)))
    % C = A' * A + LMlambda * D'*D;
    % D'*D can be thought of as a damping term or a costs (Cost=sqrt(diag(D'*D)))
    DD = diag(diag(C));
    C = C + LMlambda * DD;

    fprintf('   Computing SVD (%d,%d) ... ', size(C)); tic
    [U, S] = svd(C);
    fprintf('%f seconds. \n',toc);

    LocoFlags.Method.SV = diag(S);
    Ivec = SingularValueSelectionLM(A, S, U, ay, Mstd, Mmeas, Mmodel, LocoFlags.SVmethod);
    LocoFlags.Method.SVIndex = Ivec;

    Chi2_0 = lococalcchi2(LocoModel, LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData, 0);
    fprintf('   Starting Chi^2 = %f\n', Chi2_0);


    % Save the starting iteration
    LocoModel0 = LocoModel;
    BPMData0 = BPMData;
    CMData0 = CMData;
    FitParameters0 = FitParameters;
    LocoFlags0 = LocoFlags;
    RINGData0 = RINGData;

    cnt = 0;
    BetterMinimumFlag = 0;
    while cnt < LocoFlags.Method.MaxIter
        disp(['   Lambda = ' num2str(LMlambda)]);

        fprintf('   Computing the least square minimization ... '); tic
        b = U(:,Ivec)' * ay;

        % Looping uses less memory
        %b = diag(diag(S(Ivec,Ivec)).^(-1)) * b;
        for iSVD = 1:length(Ivec)
            b(iSVD) = b(iSVD) / S(Ivec(iSVD),Ivec(iSVD));
        end

        % b at this point is the projection onto the columns of C*V(:,Ivec)
        % Convert the vector b back to coefficents of C (V=U for svd(A'*A))
        b = U(:,Ivec) * b;
        fprintf('%f seconds. \n',toc);        
        
        % Ignor variance for now ???
        b_std = NaN * ones(size(U,1),1);

        %SValues = diag(S);
        b_delta = b;

        % Remove the normalization factor
        b_delta = RemoveNormalizationFactors(b_delta, N, CMData, FitParameters, LocoFlags);
        b_new = b_old + b_delta;
        [LocoModel, BPMData, CMData, FitParameters, LocoFlags, RINGData] = MeritFunctionAndBookKeeping(LocoMeasData, BPMData, CMData, CMDataRM, FitParameters, LocoFlags, RINGData, b_new, b_std, N, BPMIndexShort, iNoCoupling, iOutliers);
        fprintf('   Trial Chi^2 = %f\n', FitParameters.Chi2.Chi2);

        if FitParameters.Chi2.Chi2 < Chi2_0
            LMlambda = LMlambda/10.;
            BetterMinimumFlag = 1;
            break;
        else
            % Not good!, restore values
            LocoModel = LocoModel0;
            BPMData = BPMData0;
            CMData = CMData0;
            FitParameters = FitParameters0;
            LocoFlags = LocoFlags0;
            RINGData = RINGData0;
            b_new = b_old;

            LMlambda = 10 * LMlambda;

            if LMlambda > 1e15
                break;
            end
        end

        cnt = cnt + 1;
        if cnt < LocoFlags.Method.MaxIter
            % D = sqrt(diag(diag(A'*A)))
            % C = A' * A + LMlambda * D'*D;
            C = A' * A + LMlambda * DD;
            fprintf('   Computing SVD (%d,%d) ... ', size(C)); tic
            [U, S] = svd(C);
            fprintf('%f seconds. \n',toc);
        end
    end

    LocoFlags.Method.LambdaFinal = LMlambda;

    % Save the costs
    LocoFlags = AddMethodToLocoFlags('Cost', sqrt(LMlambda*diag(DD)), LocoFlags, BPMData, CMData, FitParameters, N);

    if ~BetterMinimumFlag
        LocoModel = MeritFunctionAndBookKeeping(LocoMeasData, BPMData, CMData, CMDataRM, FitParameters, LocoFlags, RINGData, b_new, b_std, N, BPMIndexShort, iNoCoupling, iOutliers);
        LocoFlags.Method.BetterSolution = 'No';
        fprintf('   No better solution found.\n\n');
    else
        LocoFlags.Method.BetterSolution = 'Yes';
    end

    % Save data if requested by the user
    % Note: 1. A is weighted by the sigma.  This can be removed if A would saved earier.
    %       2. Outliers are removed from A, U, and S
    if ischar(LocoFlags.SVDDataFileName) && ~isempty(LocoFlags.SVDDataFileName)
        save(LocoFlags.SVDDataFileName, 'A','U','S');
    end

else
    error('Minimum search method unknown (%s)', LocoFlags.Method.Name);
end


% Unit conversions (back to LOCO units)
CMData.HCMKicks = 1000*CMData.HCMKicks;        % radian to milliradians
CMData.VCMKicks = 1000*CMData.VCMKicks;        % radian to milliradians
CMData.HCMKicksSTD = 1000*CMData.HCMKicksSTD;  % radian to milliradians
CMData.VCMKicksSTD = 1000*CMData.VCMKicksSTD;  % radian to milliradians
LocoModel.M   = 1000*LocoModel.M;              % meters to millimeters
LocoModel.Eta = 1000*LocoModel.Eta;            % meters to millimeters

if strcmpi((CMData.FitKicks),'yes')
    LocoFlags.Method.PartialChi2.HCMKicks = LocoFlags.Method.PartialChi2.HCMKicks / 1000;
    LocoFlags.Method.PartialChi2.VCMKicks = LocoFlags.Method.PartialChi2.VCMKicks / 1000;
end
if strcmpi((CMData.FitCoupling),'yes')
    LocoFlags.Method.PartialChi2.HCMCoupling = LocoFlags.Method.PartialChi2.HCMCoupling / 1000;
    LocoFlags.Method.PartialChi2.VCMCoupling = LocoFlags.Method.PartialChi2.VCMCoupling / 1000;
end


% Clear DeltaChi2 (it gets computed in locogui)
if isfield(LocoFlags.Method, 'DeltaChi2')
    LocoFlags.Method = rmfield(LocoFlags.Method, 'DeltaChi2');
end

%%%%%%%%%%%%%%%
% END OF LOCO %
%%%%%%%%%%%%%%%






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Original LOCO Gauss-Newton Search Minimization Method %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [b, b_std, LocoFlags] = LOCO_GaussNewton_Search(A, y, U, S, V, Mmodel, Mmeas, Mstd, LocoFlags, CMData, FitParameters, N)

% Singular value selection
ChiSquareVector = [];
if isempty(LocoFlags.SVmethod)
    % Interactively select singular value
    SVDquestion = 'Select Again';
    while strcmp(SVDquestion,'Select Again')
        h1 = figure;
        set(h1,'units','normalized','position', [.05 .4 .45 .45]);
        subplot(2,1,1);
        semilogy(diag(S),'-b'); hold on;
        xlabel('Singular Value Number');
        ylabel('Magnitude');
        axis([1 length(diag(S)) min(diag(S)) max(diag(S))]);

        subplot(2,1,2);
        semilogy(diag(S)/max(diag(S)),'-b'); hold on;
        xlabel('Singular Value Number');
        ylabel('Magnitude / Max(SV)');
        a = axis;
        axis([1 length(diag(S)) a(3) a(4)]);

        if ~exist('SVDquestion2')   % Only ask once
            SVDquestion2 = questdlg('Do you want to compute chi-square as a function of S-values (Note: this can be quite time consuming)?','LOCO','Yes','No','No');
            if strcmp(SVDquestion2, 'Yes')
                % Compute Chi-square as a function of S-values
                fprintf('   Computing chi-square for as a function of S-value ... '); tic

                warning off;
                for i = 1:length(diag(S))
                    lastwarn('');
                    Amod = U(:,1:i) * S(1:i,1:i);
                    b = Amod \ y;                % Parameter fit
                    b = V(:,1:i) * b;
                    Mfit = Mstd .* (A*b);        % Response matrix change for the parameter change
                    Mmodelnew = Mmodel + Mfit;   % New model response matrix
                    ChiSquareVector(i) = sum(((Mmeas - Mmodelnew) ./ Mstd) .^ 2) / length(Mstd);
                    if ~isempty(lastwarn)
                        fprintf('\n   S-value number %d warning: %s', i, lastwarn);
                    else
                        LastGoodSvalue = i;
                    end
                end
                warning on;
                fprintf('\n   %f seconds to compute chi-square for as a function of S-value. \n',toc);

            else
                LastGoodSvalue = length(diag(S));  % All S-values
            end
        end

        if strcmp(SVDquestion2, 'Yes')
            h2 = figure;
            set(h2,'units','normalized','position', [.51 .4 .45 .45]);
            semilogy(1:length(diag(S)),ChiSquareVector,'-b');
            xlabel('Singular Value Number');
            ylabel('\fontsize{10}\chi^{2} _{/ S.O.F}');
            %axis tight;
            a = axis;
            axis([1 length(diag(S)) a(3) a(4)]);
        end

        def={sprintf('[%d:%d]',1,LastGoodSvalue)};
        answer=inputdlg({'Which singular values:'},'LOCO',1,def);
        if isempty(answer)
            close(h1);
            if strcmp(SVDquestion2, 'Yes'); close(h2); end
            error('Loco stopped at the users request.');
        end

        Ivec = str2num(answer{1});
        figure(h1);
        subplot(2,1,1);
        hold on;
        semilogy(Ivec, diag(S(Ivec,Ivec)),'og','MarkerSize',2);

        SValues = diag(S);
        x=1:length(SValues);
        x(Ivec)=[];
        SValues(Ivec)=[];
        semilogy(x, SValues,'xr','MarkerSize',4);
        hold off

        subplot(2,1,2);
        hold on;
        semilogy(Ivec, diag(S(Ivec,Ivec))/max(diag(S)),'og','MarkerSize',2);
        semilogy(x, SValues/max(diag(S)),'xr','MarkerSize',4);
        hold off

        if strcmp(SVDquestion2, 'Yes')
            figure(h2);
            hold on;
            semilogy(Ivec,ChiSquareVector(Ivec),'og','MarkerSize',2);
            hold off;
        end

        SVDquestion = questdlg('Do you want to continue?','LOCO','Continue','Select Again','Select Again');

        switch SVDquestion
            case 'Continue',
                LocoFlags.SVmethod = Ivec;
        end
        close(h1);
        if strcmp(SVDquestion2, 'Yes')
            close(h2);
        end
    end

elseif strcmpi((LocoFlags.SVmethod),'rank')
    % Base on  rank deficient warning
    % Compute Chi-square as a function of S-values
    fprintf('   Computing chi-square as a function of S-value ... '); tic

    LastGoodSvalue = 0;
    warning off;

    % Search end:1, looking for a warning (assumes that all larger singular values will not have a warning)
    ChiSquareVector = NaN * ones(length(diag(S)),1);
    for i = length(diag(S)):-1:1
        lastwarn('');
        Amod = U(:,1:i) * S(1:i,1:i);
        b = Amod \ y;                % Parameter fit
        b = V(:,1:i) * b;
        %b = V(:,1:i) * ((U(:,1:i) * S(1:i,1:i)) \ y);

        Mfit = Mstd .* (A*b);        % Response matrix change for the parameter change
        Mmodelnew = Mmodel + Mfit;   % New model response matrix
        ChiSquareVector(i) = sum(((Mmeas - Mmodelnew) ./ Mstd) .^ 2) / length(Mstd);

        if isempty(lastwarn)
            % If Amod \ y is OK, check that inv(Amod'*Amod) for the variance calculation
            %fprintf('%d removed for inv() \n',i);
            bvar = V(:,1:i)*inv(Amod'*Amod)*V(:,1:i)';
        end
        if isempty(lastwarn)
            LastGoodSvalue = i;
            break;     % Once you get a good one assume that the rest are good
        else
            fprintf('\n   S-value number %d warning: %s', i, lastwarn);
        end
    end

    warning on;
    if LastGoodSvalue == 1
        error('Rank method for adjusting singular values failed.  Make sure the response matrix is good.');
    end

    Ivec = 1:LastGoodSvalue;
    fprintf('\n   %f seconds to compute chi-square as a function of S-value (rank method). \n',toc);

elseif length(LocoFlags.SVmethod) > 1
    Ivec = LocoFlags.SVmethod;


    % % Cost function
    % Ivec = 1:size(A,2)-8;


    if max(Ivec) > length(diag(S))
        error('The number of singular values requested is greater than the total number.');
    end
else
    % Base on a threshold of min/max singular value
    Ivec = find(diag(S) > max(diag(S))*LocoFlags.SVmethod);
end


% SVD info
fprintf('   %d total singular values, %d used in fit, %d removed. \n', length(diag(S)), length(Ivec), length(diag(S))-length(Ivec));


% Parameter fit
% A = U*S*V'
% Remove the E-vectors from the least squares minimization
% Project on to the modified A matrix, Amod, instead of A
% Least squares solution to y = Amod * b + e
% Amod = U(:,Ivec) * S(Ivec,Ivec)  * V(:,Ivec)
% U'*U=I and V*V'=I
% b = Amod \ y is equivalent to b = inv(Amod'*Amod) * Amod' * y
% b = A \ y;

fprintf('   Computing the least square minimization ... '); tic
b = U(:,Ivec)' * y;
b = diag(diag(S(Ivec,Ivec)).^(-1)) * b;       % Looping would use less memory

% b at this point is the projection onto the columns of A*V(:,Ivec)
% Convert the vector b back to coefficents of A
b = V(:,Ivec) * b;
fprintf('%f seconds. \n',toc);


% Variance of the parameters
% Note: the inv(Amod'*Amod) has zero covariance terms
if strcmpi(LocoFlags.CalculateSigma, 'Yes')
    % Compute the covariance matrix
    % Only the variance terms are used, the covariance terms are probably interesting
    % and can be output to a file for further analysis.
    if strcmpi((LocoFlags.Dispersion),'yes') && ~(LocoFlags.HorizontalDispersionWeight == 1 && LocoFlags.VerticalDispersionWeight == 1)
        % Dispersion weight need to be removed:  T E{uu'} T' not an identity matrix
        fprintf('   Computing the fit parameter covariance.  Since the disperson weights are not 1,\n'); tic
        fprintf('   the covariance matrix calculation is more involved.  ... ');
        for i = 1:N.HCM
            U(end-N.BPM+i,:) = LocoFlags.HorizontalDispersionWeight * U(end-N.BPM+i,:);
        end
        for i = 1:N.VCM
            U(end-N.VCM+i,:) = LocoFlags.VerticalDispersionWeight * U(end-N.VCM+i,:);
        end
        CovFit = V(:,Ivec) * diag(diag(S(Ivec,Ivec)).^(-1)) * U(:,Ivec)' * U(:,Ivec) * diag(diag(S(Ivec,Ivec)).^(-1)) * V(:,Ivec)';
        fprintf('%f seconds. \n',toc);
    else
        CovFit = V(:,Ivec) * diag(diag(S(Ivec,Ivec)).^(-1));
        CovFit = CovFit * CovFit';

        % same as (C. Steier)
        %CovFit = diag(diag(S(Ivec,Ivec)).^(-2));
        %CovFit = V(:,Ivec) * CovFit * V(:,Ivec)';   % Convert back to coefficents of A
        %b_std = sqrt(diag(CovFit));
    end

    % Remove the normalization factors (Column weights) from the covariance matrix
    if strcmpi(LocoFlags.Normalization.Flag,'yes')
        if LocoFlags.Normalization.ByRMSFlag
            % Entire A matrix
            NormFactor = abs(NormalizationFact(:));

            % RF will double normalization
            if strcmpi((FitParameters.FitRFFrequency),'yes')
                NormFactor(end-length(FitParameters.Params)) = NormFactor(end-length(FitParameters.Params)) * abs(LocoFlags.Normalization.FactorRF);
            end
        else
            NormFactor = ones(N.BPMfit, 1);    % BPMs
            NormFactor = [NormFactor; abs(LocoFlags.Normalization.FactorCM)];    % CMs
            if strcmpi((CMData.FitHCMEnergyShift),'yes')
                NormFactor = [NormFactor; ones(N.HCM,1)*abs(LocoFlags.Normalization.FactorHCMEnergy)];    % HCM Energy Shift
            end
            if strcmpi((CMData.FitVCMEnergyShift),'yes')
                NormFactor = [NormFactor; ones(N.VCM,1)*abs(LocoFlags.Normalization.FactorVCMEnergy)];    % VCM Energy Shift
            end
            if strcmpi((FitParameters.FitRFFrequency),'yes')
                NormFactor = [NormFactor; abs(LocoFlags.Normalization.FactorRF)];    % RF
            end
            if ~isempty(FitParameters.Params)
                NormFactor = [NormFactor; abs(LocoFlags.Normalization.Factor)];    % Parameter fits
            end
        end

        CovFit = CovFit * diag(NormFactor.^-1);
        CovFit = diag(NormFactor.^-1) * CovFit;
    end

    b_std = sqrt(diag(CovFit));


    % Add the full covariance term to the data save (if requested by the user)
    if ~isempty(LocoFlags.SVDDataFileName) && ischar(LocoFlags.SVDDataFileName)
        save(LocoFlags.SVDDataFileName, 'CovFit', '-append');
    end

    clear CovFit

else
    b_std = NaN * ones(size(V,1),1);
end


% A is not used anymore
clear A


% Remove the weights from A and compute the new model response matrix (w/o outliers)
%for i = 1:length(Mstd)
%    Asave(i,:) = Asave(i,:) * Mstd(i);
%end
%Mfit   = Asave*b;           % Response matrix change for the parameter change
%Mmodel = Mmodel + Mfit;     % New model response matrix
%ChiSquare = sum(((Mmeas - Mmodel) ./ Mstd) .^ 2) / length(Mstd);  % Outliers removed
%fprintf('   Chi-square = %f (Computed from Mmodel(old) + A*b)\n', ChiSquare);


LocoFlags.Method.SV = diag(S);
LocoFlags.Method.SVIndex = Ivec;

%%%%%%%%%%%%%%%%%%%%%%%
% END OF GAUSS-NEWTON %
%%%%%%%%%%%%%%%%%%%%%%%




function LocoFlags = CalcPartialChi2(A, Mstd, LocoFlags, N)
% Compute the partial of chi^2 w.r.t. each parameter change
% ChiSquare = sum(((Mmeas - Mmodel) ./ Mstd) .^ 2) / (length(Mstd)-NumberOfFitParameters);   % mean e'*e = sigma*(n-k)
%Chi2_Nomial = lococalcchi2(LocoModel, LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData, 0);
ColnCounter = 0;
for i = 1:N.HBPMGain
    ColnCounter = ColnCounter + 1;
    LocoFlags.Method.PartialChi2.HBPMGain(i,1) = sum( (A(:,ColnCounter) ./ Mstd) .^ 2) / (length(Mstd)-size(A,2));
end
for i = 1:N.HBPMCoupling
    ColnCounter = ColnCounter + 1;
    LocoFlags.Method.PartialChi2.HBPMCoupling(i,1) = sum( (A(:,ColnCounter) ./ Mstd) .^ 2) / (length(Mstd)-size(A,2));
end
for i = 1:N.VBPMCoupling
    ColnCounter = ColnCounter + 1;
    LocoFlags.Method.PartialChi2.VBPMCoupling(i,1) = sum( (A(:,ColnCounter) ./ Mstd) .^ 2) / (length(Mstd)-size(A,2));
end
for i = 1:N.VBPMGain
    ColnCounter = ColnCounter + 1;
    LocoFlags.Method.PartialChi2.VBPMGain(i,1) = sum( (A(:,ColnCounter) ./ Mstd) .^ 2) / (length(Mstd)-size(A,2));
end
for i = 1:N.HCMKicks
    ColnCounter = ColnCounter + 1;
    LocoFlags.Method.PartialChi2.HCMKicks(i,1) = sum( (A(:,ColnCounter) ./ Mstd) .^ 2) / (length(Mstd)-size(A,2));
end
for i = 1:N.VCMKicks
    ColnCounter = ColnCounter + 1;
    LocoFlags.Method.PartialChi2.VCMKicks(i,1) = sum( (A(:,ColnCounter) ./ Mstd) .^ 2) / (length(Mstd)-size(A,2));
end
for i = 1:N.HCMCoupling
    ColnCounter = ColnCounter + 1;
    LocoFlags.Method.PartialChi2.HCMCoupling(i,1) = sum( (A(:,ColnCounter) ./ Mstd) .^ 2) / (length(Mstd)-size(A,2));
end
for i = 1:N.VCMCoupling
    ColnCounter = ColnCounter + 1;
    LocoFlags.Method.PartialChi2.VCMCoupling(i,1) = sum( (A(:,ColnCounter) ./ Mstd) .^ 2) / (length(Mstd)-size(A,2));
end
for i = 1:N.HCMEnergyShift
    ColnCounter = ColnCounter + 1;
    LocoFlags.Method.PartialChi2.HCMEnergyShift(i,1) = sum( (A(:,ColnCounter) ./ Mstd) .^ 2) / (length(Mstd)-size(A,2));
end
for i = 1:N.VCMEnergyShift
    ColnCounter = ColnCounter + 1;
    LocoFlags.Method.PartialChi2.VCMEnergyShift(i,1) = sum( (A(:,ColnCounter) ./ Mstd) .^ 2) / (length(Mstd)-size(A,2));
end
for i = 1:N.RF
    ColnCounter = ColnCounter + 1;
    LocoFlags.Method.PartialChi2.VCMEnergyShift(i,1) = sum( (A(:,ColnCounter) ./ Mstd) .^ 2) / (length(Mstd)-size(A,2));
end
for i = 1:N.FitParameters
    ColnCounter = ColnCounter + 1;
    LocoFlags.Method.PartialChi2.FitParameters(i,1) = sum( (A(:,ColnCounter) ./ Mstd) .^ 2) / (length(Mstd)-size(A,2));
end





function [A, b_old, Mmodel, iNoCoupling, LocoFlags] = BuildTheJacobian(LocoMeasData, LocoModel, BPMData, CMData, CMDataRM, FitParameters, LocoFlags, RINGData, A_NRows, A_NCols, N, Kicks, BPMIndexShort, RMSGoal, RMSToleranceFactor)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BUILD THE JACOBIAN MATRIX, A  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The gradient matrix, A, is the delta response matrix w.r.t. the BPMs, corrector magnets, RF, and parameters in FitParameters.Params
% A = [BPMHgains BPMHcoupling BPMVcoupling BPMVgains HCMkick VCMkick HCMcoupling VCMcoupling HCMEnergyShift VCMEnergyShift RF ParamFits]

% Pre-Allocate the A matrix - this help with memory management and time
if strcmpi(LocoFlags.SinglePrecision, 'yes')
    A = zeros(A_NRows, A_NCols, 'single');
else
    A = zeros(A_NRows, A_NCols);
end

% Find nominal response matrix
fprintf('   Computing nominal response matrix (%s, %s) ... ', LocoFlags.ResponseMatrixCalculator, LocoFlags.ClosedOrbitType); tic
if strcmpi((LocoFlags.Dispersion),'yes')
    % Add "dispersion" as a column of the response matrix
    Mmodel = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags, 'RF', FitParameters.DeltaRF);
else
    Mmodel = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags);
end
fprintf('%f seconds. \n',toc);


% To remove the off-diagonal part of the A matrix find the index vector, iNoCoupling, of rows to keep
if strcmpi((LocoFlags.Coupling),'no')
    CF = [ ones(N.HBPM,N.HCM) zeros(N.HBPM,N.VCM);
          zeros(N.VBPM,N.HCM)  ones(N.VBPM,N.VCM)];

    % Keep the dispersion
    if strcmpi((LocoFlags.Dispersion),'yes')
        % Keep the horizontal and vertical part of the "dispersion" orbit
        CF = [CF [2*ones(N.HBPM,1); zeros(N.VBPM,1)]];    % Make zeros to ignor dispersion
    end

    CF = CF(:);
    iNoCoupling = find(CF > 0);               % Rows of A to keep when ignoring coupling
    %iHorizontalDispersion = find(CF == 2);   % Rows of A corresponding to horizontal dispersion
    %iVerticalDispersion = find(CF == 3);     % Rows of A corresponding to vertical dispersion
    clear CF
else
    if strcmpi((LocoFlags.Dispersion),'yes')
        iNoCoupling = (1:(N.VBPM+N.HBPM)*(N.HCM+N.VCM+1))';
    else
        iNoCoupling = (1:(N.VBPM+N.HBPM)*(N.HCM+N.VCM))';
    end
end


% BPM gain and coupling
% In order to fit the coupling term both horizontal and vertical data
% must be available.  If there are single plane BPMs, then missing planes
% gets removed after C * Mmodel is computed.
% Note:  BPM gains/coupling are still used even if gains/coupling are not fitted

% Make sure everything is a column vector
BPMData.HBPMGain = BPMData.HBPMGain(:);
BPMData.VBPMGain = BPMData.VBPMGain(:);
BPMData.HBPMCoupling = BPMData.HBPMCoupling(:);
BPMData.VBPMCoupling = BPMData.VBPMCoupling(:);

C11 = ones(length(BPMData.BPMIndex),1);
C11(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex)) = BPMData.HBPMGain(BPMData.HBPMGoodDataIndex);

C12 = zeros(length(BPMData.BPMIndex),1);
C12(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex)) = BPMData.HBPMCoupling(BPMData.HBPMGoodDataIndex);

C21 = zeros(length(BPMData.BPMIndex),1);
C21(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex)) = BPMData.VBPMCoupling(BPMData.VBPMGoodDataIndex);

C22 = ones(length(BPMData.BPMIndex),1);
C22(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex)) = BPMData.VBPMGain(BPMData.VBPMGoodDataIndex);

C = [diag(C11) diag(C12)
     diag(C21) diag(C22)];
clear C11 C12 C21 C22


% "Parity" check
if length(iNoCoupling) ~= A_NRows
    error('length(iNoCoupling) (%d) should be equal to A_NRows (%d)', length(iNoCoupling), A_NRows);
end


% BPM fit parameters
% Construct Abpm = [Hgains Hcoupling Vcoupling Vgains]
b_old = [];
Acolindex = 1;

if strcmpi((BPMData.FitGains),'yes')
    % Horizontal BPMs Gains
    for i = 1:N.HBPM
        Mdiff = [zeros(i-1,size(Mmodel,2)); Mmodel(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex(i)),:); zeros(N.BPM-i,size(Mmodel,2))];
        Mdiff = Mdiff(:);
        A(:,Acolindex) = Mdiff(iNoCoupling);
        Acolindex = Acolindex + 1;
    end
    b_old = BPMData.HBPMGain(BPMData.HBPMGoodDataIndex);
end
if strcmpi((BPMData.FitCoupling),'yes')
    %  Horizontal coupling term
    for i = 1:N.HBPM
        Mdiff = [zeros(i-1,size(Mmodel,2)); Mmodel(length(BPMData.BPMIndex)+BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex(i)),:); zeros(N.BPM-i,size(Mmodel,2))];
        Mdiff = Mdiff(:);
        A(:,Acolindex) = Mdiff(iNoCoupling);
        Acolindex = Acolindex + 1;
    end

    %  Vertical coupling term
    for i = 1:N.VBPM
        Mdiff = [zeros(N.HBPM+i-1,size(Mmodel,2)); Mmodel(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex(i)),:); zeros(N.VBPM-i,size(Mmodel,2))];
        Mdiff = Mdiff(:);
        A(:,Acolindex) = Mdiff(iNoCoupling);
        Acolindex = Acolindex + 1;
    end
    b_old = [b_old; BPMData.HBPMCoupling(BPMData.HBPMGoodDataIndex); BPMData.VBPMCoupling(BPMData.VBPMGoodDataIndex)];
end
if strcmpi((BPMData.FitGains),'yes')
    % Vertical BPMs Gains
    for i = 1:N.VBPM
        Mdiff = [zeros(N.HBPM+i-1,size(Mmodel,2)); Mmodel(length(BPMData.BPMIndex)+BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex(i)),:); zeros(N.VBPM-i,size(Mmodel,2))];
        Mdiff = Mdiff(:);
        A(:,Acolindex) = Mdiff(iNoCoupling);
        Acolindex = Acolindex + 1;
    end
    b_old = [b_old; BPMData.VBPMGain(BPMData.VBPMGoodDataIndex)];
end


% Rotate Mmodel and remove BPMs not in the measured response matrix
Mmodel = C * Mmodel;
Mmodel = Mmodel(BPMIndexShort, :);


% Compute corrector gain response matrix, Acor
LocoFlags.Normalization.FactorCM = [];
if strcmpi((CMData.FitKicks),'yes')
    % Compute Acor by scaling Mmodel (don't include dispersion)
    
    % Acor = zeros(N.BPM*(N.HCM+N.VCM),N.HCM+N.VCM);
    % for i=1:N.HCM+N.VCM
    %     Acor((i-1)*N.BPM+(1:N.BPM),i) = Mmodel(:,i) / Kicks(i);
    % end
    %
    % % Assume that the change in dispersion due to a corrector magnet is zero
    % if strcmpi((LocoFlags.Dispersion),'yes')
    %     Acor = [Acor; zeros(N.BPM,N.HCM+N.VCM)];
    % end
    %
    % A(:,Acolindex:(Acolindex+N.HCM+N.VCM-1)) = Acor(iNoCoupling,:);
    %
    % Acolindex = Acolindex + N.HCM+N.VCM;

    for i=1:N.HCM+N.VCM
        if strcmpi(LocoFlags.SinglePrecision, 'yes')
            Acor = zeros(N.BPM*(N.HCM+N.VCM),1,'single');
        else
            Acor = zeros(N.BPM*(N.HCM+N.VCM),1);
        end

        Acor((i-1)*N.BPM+(1:N.BPM),1) = Mmodel(:,i) / Kicks(i);

        % Assume that the change in dispersion due to a corrector magnet is zero
        if strcmpi((LocoFlags.Dispersion),'yes')
            if strcmpi(LocoFlags.SinglePrecision, 'yes')
                Acor = [Acor; zeros(N.BPM,1,'single')];
            else
                Acor = [Acor; zeros(N.BPM,1)];
            end
        end

        A(:,Acolindex) = Acor(iNoCoupling,:);

        Acolindex = Acolindex + 1;
    end

    LocoFlags.Normalization.FactorCM = 1 ./ Kicks;
    b_old = [b_old; Kicks];
end


% Compute corrector coupling response matrix
if strcmpi((CMData.FitCoupling),'yes')
    % Compute Acor numerically
    CMCouplingDeltas = 1e-6;    % Coupling size should be based a computer round off error ???
    CMDataRM.HCMCoupling = CMDataRM.HCMCoupling + CMCouplingDeltas * ones(length(CMDataRM.HCMCoupling),1);
    CMDataRM.VCMCoupling = CMDataRM.VCMCoupling + CMCouplingDeltas * ones(length(CMDataRM.VCMCoupling),1);

    fprintf('   Computing nominal response matrix for a change in corrector magnet coupling (%s, %s) ... ', LocoFlags.ResponseMatrixCalculator, LocoFlags.ClosedOrbitType); tic
    if strcmpi((LocoFlags.Dispersion),'yes')
        % Add "dispersion" as a column of the response matrix
        GR = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags, 'RF', FitParameters.DeltaRF);
    else
        GR = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags);
    end
    fprintf('%f seconds. \n', toc);

    % Rotate by the BPM gain, roll, crunch
    GR = C * GR;

    % Remove BPMs not in the response matrix
    GR = GR(BPMIndexShort, :);

    if strcmpi(LocoFlags.SinglePrecision, 'yes')
        GR = single(GR);
    end

    %Acor = zeros(N.BPM*(N.HCM+N.VCM),N.HCM+N.VCM);
    %for i=1:N.HCM+N.VCM
    %    Acor((i-1)*N.BPM+(1:N.BPM),i) = (GR(:,i)-Mmodel(:,i)) / CMCouplingDeltas;
    %end
    %
    %% Assume that the change in dispersion due to a corrector magnet is zero
    %if strcmpi((LocoFlags.Dispersion),'yes')
    %    Acor = [Acor; zeros(N.BPM,N.HCM+N.VCM)];
    %end
    %
    %A(:,Acolindex:(Acolindex+N.HCM+N.VCM-1)) = Acor(iNoCoupling,:);
    %Acolindex = Acolindex+N.HCM+N.VCM;
    
    for i=1:N.HCM+N.VCM
        Acor = zeros(N.BPM*(N.HCM+N.VCM),1);
        Acor((i-1)*N.BPM+(1:N.BPM),1) = (GR(:,i)-Mmodel(:,i)) / CMCouplingDeltas;

        % Assume that the change in dispersion due to a corrector magnet is zero
        if strcmpi((LocoFlags.Dispersion),'yes')
            if strcmpi(LocoFlags.SinglePrecision, 'yes')
                Acor = [Acor; zeros(N.BPM,1,'single')];
            else
                Acor = [Acor; zeros(N.BPM,1)];
            end
        end

        A(:,Acolindex) = Acor(iNoCoupling,:);
        Acolindex = Acolindex + 1;
    end
    
    
    % Return the coupling vectors back to normal
    CMDataRM.HCMCoupling = CMDataRM.HCMCoupling - CMCouplingDeltas * ones(length(CMDataRM.HCMCoupling),1);
    CMDataRM.VCMCoupling = CMDataRM.VCMCoupling - CMCouplingDeltas * ones(length(CMDataRM.VCMCoupling),1);
    
    b_old = [b_old; CMDataRM.HCMCoupling; CMDataRM.VCMCoupling];
end


% Fit the energy shift at the corrector magnets
% Note: energy shift fits have not been optimized for memory yet!
if strcmpi((CMData.FitHCMEnergyShift),'yes')
    AlphaMCF = locomcf(RINGData);
    EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;

    % Compute Acor from the measured dispersion
    Acor = zeros(N.BPM*(N.HCM+N.VCM), N.HCM);
    for i = 1:N.HCM
        Acor((i-1)*N.BPM+(1:N.HBPM), i) = EtaXmcf;

        % Plus the coupling term to the vertical plane
        Acor((i-1)*N.BPM+N.HBPM+(1:N.VBPM), i) = EtaYmcf;
        %Acor((i-1)*N.BPM+N.HBPM+(1:N.VBPM), i) = CMDataRM.HCMCoupling(i) * EtaYmcf;
        %Acor((i-1)*N.BPM+N.HBPM+(1:N.VBPM), i) = zeros(size(EtaYmcf));
    end

    % Assume that the change in dispersion due to a energy shift is zero
    if strcmpi((LocoFlags.Dispersion),'yes')
        Acor = [Acor; zeros(N.BPM,N.HCM)];
    end

    A(:,Acolindex:(Acolindex+N.HCM-1)) = Acor(iNoCoupling,:);
    Acolindex = Acolindex + N.HCM;
    
    LocoFlags.Normalization.FactorHCMEnergy = abs(AlphaMCF * LocoMeasData.RF / LocoMeasData.DeltaRF);
    b_old = [b_old; CMDataRM.HCMEnergyShift;];
else
    LocoFlags.Normalization.FactorHCMEnergy = [];
end


if strcmpi((CMData.FitVCMEnergyShift),'yes')
    if ~exist('AlphaMCF')
        AlphaMCF = locomcf(RINGData);
        EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
        EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    end

    % Compute Acor from the measured dispersion
    Acor = zeros(N.BPM*(N.HCM+N.VCM), N.VCM);
    for i = 1:N.VCM
        Acor((N.HCM+i-1)*N.BPM+N.HBPM+(1:N.VBPM), i) = EtaYmcf;

        % Plus the coupling term to the horizontal plane
        Acor((N.HCM+i-1)*N.BPM+(1:N.HBPM), i) = EtaXmcf;
        %Acor((i-1)*N.BPM+(1:N.HBPM), i) = CMDataRM.VCMCoupling(i) * EtaXmcf;
        %Acor((i-1)*N.BPM+(1:N.HBPM), i) = zeros(size(EtaXmcf));
    end

    % Assume that the change in dispersion due to a energy shift is zero
    if strcmpi((LocoFlags.Dispersion),'yes')
        Acor = [Acor; zeros(N.BPM,N.VCM)];
    end

    A(:,Acolindex:(Acolindex+N.VCM-1)) = Acor(iNoCoupling,:);
    Acolindex = Acolindex + N.VCM;
    
    LocoFlags.Normalization.FactorVCMEnergy = abs(AlphaMCF * LocoMeasData.RF / LocoMeasData.DeltaRF);
    b_old = [b_old; CMDataRM.VCMEnergyShift];
else
    LocoFlags.Normalization.FactorVCMEnergy = [];
end

clear Acor


% Include RF Frequency as a parameter
if strcmpi((FitParameters.FitRFFrequency),'yes')
    % A weighted and rotated "Disperion" is stored in the last column of Mmodel (change in orbit due to change in RF frequency and rotate by the BPM gain, roll, crunch)
    Mrf = [zeros(N.BPM,N.HCM+N.VCM) Mmodel(:,end)/FitParameters.DeltaRF];
    Mrf = Mrf(:);

    % Include in the A matrix
    A(:,Acolindex) = Mrf(iNoCoupling);
    Acolindex = Acolindex + 1;
    %pack;  % pack is a command line only function for the Matlab 2006b release and forward
    b_old = [b_old; FitParameters.DeltaRF];
end


% Compute response matrix for the rest of the parameters
FitParameters.Values = FitParameters.Values(:);      % Force a column vector
for i = 1:length(FitParameters.Params)
    % Find the correct delta to use:
    % If LocoFlags.AutoCorrectDelta = 'yes', then correct the delta on every iteration and recompute
    %                                  if outside the RMSGoal/RMSToleranceFactor or RMSGoal*RMSToleranceFactor/3
    % If LocoFlags.AutoCorrectDelta = 'no', then the user input will be used (unless it's NaN).
    % If FitParameters.Deltas = NaN, then guess a value of .1% of FitParameters.Values and test using the RMSGoal check.
    DeltaCheckFlag = 1;
    while DeltaCheckFlag
        % If a delta is not given, then set it to .1% of the value and check that it is OK
        if isnan(FitParameters.Deltas(i))
            FitParameters.Deltas(i) = .001 * FitParameters.Values(i);
            if FitParameters.Deltas(i) == 0
                FitParameters.Deltas(i) = 1e-6;     % You just have to guess something and have it auto-correct
            end
            OneTimeAutoCorrect = 'yes';   % In case auto correction is not on
        else
            OneTimeAutoCorrect = 'no';
        end


        % Compute the response matrix with the parameter change
        RINGData = locosetlatticeparam(RINGData, FitParameters.Params{i}, FitParameters.Values(i)+FitParameters.Deltas(i));

        fprintf('   Parameter #%d, Computing response matrix (%s, %s) ... ', i, LocoFlags.ResponseMatrixCalculator, LocoFlags.ClosedOrbitType); tic
        if strcmpi((LocoFlags.Dispersion),'yes')
            % Add "dispersion" as a column of the response matrix
            Mparam = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags, 'RF', FitParameters.DeltaRF);
        else
            Mparam = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags);
        end
        fprintf('%f seconds. \n', toc);


        % Rotate by the BPM gain, roll, crunch
        Mparam = C * Mparam;

        % Remove BPMs not in the response matrix
        Mparam = Mparam(BPMIndexShort, :);

        % Response matrix gradient
        Mdiff = Mparam - Mmodel;
        Mdiff = Mdiff(:);

        % Compute rms response matrix change (ignor weighted dispersion)
        if strcmpi((LocoFlags.Dispersion),'yes')
            Mdiff_nodispersion = Mparam(:,1:end-1) - Mmodel(:,1:end-1);
            Mdiff_nodispersion = Mdiff_nodispersion(:);
            RMSDelta = sqrt(sum(Mdiff_nodispersion.^2)/length(Mdiff_nodispersion));
            clear Mdiff_nodispersion
        else
            RMSDelta = sqrt(sum(Mdiff.^2)/length(Mdiff));
        end

        % If the RMSDelta is inf, just error (not good, not fixable)
        if isinf(RMSDelta) || RMSDelta==0
            fprintf('   Parameter #%d, RMS(Model(Delta=%0.5g)-Model(0))=%0.5g mm\n', i, FitParameters.Deltas(i), 1000*RMSDelta);
            error('LOCO error:  RMS difference must be finite and not zero');
        end

        % Save the delta used to compute the response matrix (this might be a little confusing since the new FitParameters.Deltas
        % may not be the same as the one used to compute the response matrix due to the auto correction algorithm).
        Delta = FitParameters.Deltas(i);

        if strcmpi((LocoFlags.AutoCorrectDelta),'yes') || strcmpi((OneTimeAutoCorrect),'yes')
            if RMSDelta < RMSGoal/RMSToleranceFactor
                % Delta too small, recompute
                fprintf('   Parameter #%d, Response matrix delta too small, RMS(Model(%0.5g)-Model(%0.5g))=%0.5g mm\n', i, FitParameters.Values(i)+FitParameters.Deltas(i), FitParameters.Values(i), 1000*RMSDelta);
                FitParameters.Deltas(i) = FitParameters.Deltas(i) * RMSGoal / RMSDelta;
            elseif RMSDelta > RMSGoal*RMSToleranceFactor/3
                % Delta too large, recompute
                fprintf('   Parameter #%d, Response matrix delta too big, RMS(Model(%0.5g)-Model(%0.5g))=%0.5g mm\n', i, FitParameters.Values(i)+FitParameters.Deltas(i), FitParameters.Values(i), 1000*RMSDelta);
                FitParameters.Deltas(i) = FitParameters.Deltas(i) * RMSGoal / RMSDelta;
            else
                % Use the response matrix but correct the delta
                fprintf('   Parameter #%d, Response matrix delta OK, RMS(Model(%0.5g)-Model(%0.5g))=%0.5g mm\n', i, FitParameters.Values(i)+FitParameters.Deltas(i), FitParameters.Values(i), 1000*RMSDelta);
                FitParameters.Deltas(i) = FitParameters.Deltas(i) * RMSGoal / RMSDelta;
                fprintf('   Parameter #%d, Autocorrection of delta, the new Delta = %g\n', i, FitParameters.Deltas(i));
                DeltaCheckFlag = 0;
            end
        else
            % Autocorrect delta off, warn if too big or small
            DeltaCheckFlag = 0;
            if RMSDelta < RMSGoal/RMSToleranceFactor
                % Delta is small
                fprintf('   WARNING:  Parameter #%d, Delta for response matrix is small, RMS(Model(Delta=%0.5g)-Model(Nominal))=%f mm.\n', i, FitParameters.Deltas(i), 1000*RMSDelta);
            elseif RMSDelta > RMSGoal*RMSToleranceFactor/3
                % Delta is large
                fprintf('   WARNING:  Parameter #%d, Delta for response matrix is large, RMS(Model(Delta=%0.5g)-Model(Nominal))=%f mm.\n', i, FitParameters.Deltas(i), 1000*RMSDelta);
            end
        end
    end


    % Restore the nominal setpoint
    RINGData = locosetlatticeparam(RINGData, FitParameters.Params{i}, FitParameters.Values(i));

    % Include in the A matrix
    A(:,Acolindex) = Mdiff(iNoCoupling)/Delta;
    Acolindex = Acolindex + 1;
    b_old = [b_old; FitParameters.Values(i)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A, b_old, Mmodel, iNoCoupling, LocoFlags] = CallTheJacobian(LocoMeasData, LocoModel, BPMData, CMData, CMDataRM, FitParameters, LocoFlags, RINGData, A_NRows, A_NCols, N, Kicks, BPMIndexShort, RMSGoal, RMSToleranceFactor)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  USE SAVED JACOBIAN MATRIX, A  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The gradient matrix, A, is the delta response matrix w.r.t. the BPMs, corrector magnets, RF, and parameters in FitParameters.Params
% A = [BPMHgains BPMHcoupling BPMVcoupling BPMVgains HCMkick VCMkick HCMcoupling VCMcoupling HCMEnergyShift VCMEnergyShift RF ParamFits]

% Pre-Allocate the A matrix - this help with memory management and time
if strcmpi(LocoFlags.SinglePrecision, 'yes')
    A = zeros(A_NRows, A_NCols, 'single');
else
    A = zeros(A_NRows, A_NCols);
end

% Load full Jacobian matrix
load('Jacobian.mat');

% Find nominal response matrix
fprintf('   Computing nominal response matrix (%s, %s) ... ', LocoFlags.ResponseMatrixCalculator, LocoFlags.ClosedOrbitType); tic
if strcmpi((LocoFlags.Dispersion),'yes')
    % Add "dispersion" as a column of the response matrix
    Mmodel = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags, 'RF', FitParameters.DeltaRF);
else
    Mmodel = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags);
end
fprintf('%f seconds. \n',toc);


% To remove the off-diagonal part of the A matrix find the index vector, iNoCoupling, of rows to keep
if strcmpi((LocoFlags.Coupling),'no')
    CF = [ ones(N.HBPM,N.HCM) zeros(N.HBPM,N.VCM);
          zeros(N.VBPM,N.HCM)  ones(N.VBPM,N.VCM)];

    % Keep the dispersion
    if strcmpi((LocoFlags.Dispersion),'yes')
        % Keep the horizontal and vertical part of the "dispersion" orbit
        CF = [CF [2*ones(N.HBPM,1); zeros(N.VBPM,1)]];    % Make zeros to ignor dispersion
    end

    CF = CF(:);
    iNoCoupling = find(CF > 0);               % Rows of A to keep when ignoring coupling
    %iHorizontalDispersion = find(CF == 2);   % Rows of A corresponding to horizontal dispersion
    %iVerticalDispersion = find(CF == 3);     % Rows of A corresponding to vertical dispersion
    clear CF
else
    if strcmpi((LocoFlags.Dispersion),'yes')
        iNoCoupling = (1:(N.VBPM+N.HBPM)*(N.HCM+N.VCM+1))';
    else
        iNoCoupling = (1:(N.VBPM+N.HBPM)*(N.HCM+N.VCM))';
    end
end


% BPM gain and coupling
% In order to fit the coupling term both horizontal and vertical data
% must be available.  If there are single plane BPMs, then missing planes
% gets removed after C * Mmodel is computed.
% Note:  BPM gains/coupling are still used even if gains/coupling are not fitted

% Make sure everything is a column vector
BPMData.HBPMGain = BPMData.HBPMGain(:);
BPMData.VBPMGain = BPMData.VBPMGain(:);
BPMData.HBPMCoupling = BPMData.HBPMCoupling(:);
BPMData.VBPMCoupling = BPMData.VBPMCoupling(:);

C11 = ones(length(BPMData.BPMIndex),1);
C11(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex)) = BPMData.HBPMGain(BPMData.HBPMGoodDataIndex);

C12 = zeros(length(BPMData.BPMIndex),1);
C12(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex)) = BPMData.HBPMCoupling(BPMData.HBPMGoodDataIndex);

C21 = zeros(length(BPMData.BPMIndex),1);
C21(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex)) = BPMData.VBPMCoupling(BPMData.VBPMGoodDataIndex);

C22 = ones(length(BPMData.BPMIndex),1);
C22(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex)) = BPMData.VBPMGain(BPMData.VBPMGoodDataIndex);

C = [diag(C11) diag(C12)
     diag(C21) diag(C22)];
clear C11 C12 C21 C22


% "Parity" check
if length(iNoCoupling) ~= A_NRows
    error('length(iNoCoupling) (%d) should be equal to A_NRows (%d)', length(iNoCoupling), A_NRows);
end


% BPM fit parameters
% Construct Abpm = [Hgains Hcoupling Vcoupling Vgains]
b_old = [];
Acolindex = 1;

if strcmpi((BPMData.FitGains),'yes')
    % Horizontal BPMs Gains
    for i = 1:N.HBPM
        Mdiff = [zeros(i-1,size(Mmodel,2)); Mmodel(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex(i)),:); zeros(N.BPM-i,size(Mmodel,2))];
        Mdiff = Mdiff(:);
        A(:,Acolindex) = Mdiff(iNoCoupling);
        Acolindex = Acolindex + 1;
    end
    b_old = BPMData.HBPMGain(BPMData.HBPMGoodDataIndex);
end
if strcmpi((BPMData.FitCoupling),'yes')
    %  Horizontal coupling term
    for i = 1:N.HBPM
        Mdiff = [zeros(i-1,size(Mmodel,2)); Mmodel(length(BPMData.BPMIndex)+BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex(i)),:); zeros(N.BPM-i,size(Mmodel,2))];
        Mdiff = Mdiff(:);
        A(:,Acolindex) = Mdiff(iNoCoupling);
        Acolindex = Acolindex + 1;
    end

    %  Vertical coupling term
    for i = 1:N.VBPM
        Mdiff = [zeros(N.HBPM+i-1,size(Mmodel,2)); Mmodel(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex(i)),:); zeros(N.VBPM-i,size(Mmodel,2))];
        Mdiff = Mdiff(:);
        A(:,Acolindex) = Mdiff(iNoCoupling);
        Acolindex = Acolindex + 1;
    end
    b_old = [b_old; BPMData.HBPMCoupling(BPMData.HBPMGoodDataIndex); BPMData.VBPMCoupling(BPMData.VBPMGoodDataIndex)];
end
if strcmpi((BPMData.FitGains),'yes')
    % Vertical BPMs Gains
    for i = 1:N.VBPM
        Mdiff = [zeros(N.HBPM+i-1,size(Mmodel,2)); Mmodel(length(BPMData.BPMIndex)+BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex(i)),:); zeros(N.VBPM-i,size(Mmodel,2))];
        Mdiff = Mdiff(:);
        A(:,Acolindex) = Mdiff(iNoCoupling);
        Acolindex = Acolindex + 1;
    end
    b_old = [b_old; BPMData.VBPMGain(BPMData.VBPMGoodDataIndex)];
end


% Rotate Mmodel and remove BPMs not in the measured response matrix
Mmodel = C * Mmodel;
Mmodel = Mmodel(BPMIndexShort, :);


% Compute corrector gain response matrix, Acor
LocoFlags.Normalization.FactorCM = [];
if strcmpi((CMData.FitKicks),'yes')
    % Compute Acor by scaling Mmodel (don't include dispersion)
    
    % Acor = zeros(N.BPM*(N.HCM+N.VCM),N.HCM+N.VCM);
    % for i=1:N.HCM+N.VCM
    %     Acor((i-1)*N.BPM+(1:N.BPM),i) = Mmodel(:,i) / Kicks(i);
    % end
    %
    % % Assume that the change in dispersion due to a corrector magnet is zero
    % if strcmpi((LocoFlags.Dispersion),'yes')
    %     Acor = [Acor; zeros(N.BPM,N.HCM+N.VCM)];
    % end
    %
    % A(:,Acolindex:(Acolindex+N.HCM+N.VCM-1)) = Acor(iNoCoupling,:);
    %
    % Acolindex = Acolindex + N.HCM+N.VCM;

    for i=1:N.HCM+N.VCM
        if strcmpi(LocoFlags.SinglePrecision, 'yes')
            Acor = zeros(N.BPM*(N.HCM+N.VCM),1,'single');
        else
            Acor = zeros(N.BPM*(N.HCM+N.VCM),1);
        end

        Acor((i-1)*N.BPM+(1:N.BPM),1) = Mmodel(:,i) / Kicks(i);

        % Assume that the change in dispersion due to a corrector magnet is zero
        if strcmpi((LocoFlags.Dispersion),'yes')
            if strcmpi(LocoFlags.SinglePrecision, 'yes')
                Acor = [Acor; zeros(N.BPM,1,'single')];
            else
                Acor = [Acor; zeros(N.BPM,1)];
            end
        end

        A(:,Acolindex) = Acor(iNoCoupling,:);

        Acolindex = Acolindex + 1;
    end

    LocoFlags.Normalization.FactorCM = 1 ./ Kicks;
    b_old = [b_old; Kicks];
end


% Compute corrector coupling response matrix
if strcmpi((CMData.FitCoupling),'yes')
    % Compute Acor numerically
    CMCouplingDeltas = 1e-6;    % Coupling size should be based a computer round off error ???
    CMDataRM.HCMCoupling = CMDataRM.HCMCoupling + CMCouplingDeltas * ones(length(CMDataRM.HCMCoupling),1);
    CMDataRM.VCMCoupling = CMDataRM.VCMCoupling + CMCouplingDeltas * ones(length(CMDataRM.VCMCoupling),1);

    fprintf('   Computing nominal response matrix for a change in corrector magnet coupling (%s, %s) ... ', LocoFlags.ResponseMatrixCalculator, LocoFlags.ClosedOrbitType); tic
    if strcmpi((LocoFlags.Dispersion),'yes')
        % Add "dispersion" as a column of the response matrix
        GR = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags, 'RF', FitParameters.DeltaRF);
    else
        GR = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags);
    end
    fprintf('%f seconds. \n', toc);

    % Rotate by the BPM gain, roll, crunch
    GR = C * GR;

    % Remove BPMs not in the response matrix
    GR = GR(BPMIndexShort, :);

    if strcmpi(LocoFlags.SinglePrecision, 'yes')
        GR = single(GR);
    end

    %Acor = zeros(N.BPM*(N.HCM+N.VCM),N.HCM+N.VCM);
    %for i=1:N.HCM+N.VCM
    %    Acor((i-1)*N.BPM+(1:N.BPM),i) = (GR(:,i)-Mmodel(:,i)) / CMCouplingDeltas;
    %end
    %
    %% Assume that the change in dispersion due to a corrector magnet is zero
    %if strcmpi((LocoFlags.Dispersion),'yes')
    %    Acor = [Acor; zeros(N.BPM,N.HCM+N.VCM)];
    %end
    %
    %A(:,Acolindex:(Acolindex+N.HCM+N.VCM-1)) = Acor(iNoCoupling,:);
    %Acolindex = Acolindex+N.HCM+N.VCM;
    
    for i=1:N.HCM+N.VCM
        Acor = zeros(N.BPM*(N.HCM+N.VCM),1);
        Acor((i-1)*N.BPM+(1:N.BPM),1) = (GR(:,i)-Mmodel(:,i)) / CMCouplingDeltas;

        % Assume that the change in dispersion due to a corrector magnet is zero
        if strcmpi((LocoFlags.Dispersion),'yes')
            if strcmpi(LocoFlags.SinglePrecision, 'yes')
                Acor = [Acor; zeros(N.BPM,1,'single')];
            else
                Acor = [Acor; zeros(N.BPM,1)];
            end
        end

        A(:,Acolindex) = Acor(iNoCoupling,:);
        Acolindex = Acolindex + 1;
    end
    
    
    % Return the coupling vectors back to normal
    CMDataRM.HCMCoupling = CMDataRM.HCMCoupling - CMCouplingDeltas * ones(length(CMDataRM.HCMCoupling),1);
    CMDataRM.VCMCoupling = CMDataRM.VCMCoupling - CMCouplingDeltas * ones(length(CMDataRM.VCMCoupling),1);
    
    b_old = [b_old; CMDataRM.HCMCoupling; CMDataRM.VCMCoupling];
end


% Fit the energy shift at the corrector magnets
% Note: energy shift fits have not been optimized for memory yet!
if strcmpi((CMData.FitHCMEnergyShift),'yes')
    AlphaMCF = locomcf(RINGData);
    EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;

    % Compute Acor from the measured dispersion
    Acor = zeros(N.BPM*(N.HCM+N.VCM), N.HCM);
    for i = 1:N.HCM
        Acor((i-1)*N.BPM+(1:N.HBPM), i) = EtaXmcf;

        % Plus the coupling term to the vertical plane
        Acor((i-1)*N.BPM+N.HBPM+(1:N.VBPM), i) = EtaYmcf;
        %Acor((i-1)*N.BPM+N.HBPM+(1:N.VBPM), i) = CMDataRM.HCMCoupling(i) * EtaYmcf;
        %Acor((i-1)*N.BPM+N.HBPM+(1:N.VBPM), i) = zeros(size(EtaYmcf));
    end

    % Assume that the change in dispersion due to a energy shift is zero
    if strcmpi((LocoFlags.Dispersion),'yes')
        Acor = [Acor; zeros(N.BPM,N.HCM)];
    end

    A(:,Acolindex:(Acolindex+N.HCM-1)) = Acor(iNoCoupling,:);
    Acolindex = Acolindex + N.HCM;
    
    LocoFlags.Normalization.FactorHCMEnergy = abs(AlphaMCF * LocoMeasData.RF / LocoMeasData.DeltaRF);
    b_old = [b_old; CMDataRM.HCMEnergyShift;];
else
    LocoFlags.Normalization.FactorHCMEnergy = [];
end


if strcmpi((CMData.FitVCMEnergyShift),'yes')
    if ~exist('AlphaMCF')
        AlphaMCF = locomcf(RINGData);
        EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
        EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    end

    % Compute Acor from the measured dispersion
    Acor = zeros(N.BPM*(N.HCM+N.VCM), N.VCM);
    for i = 1:N.VCM
        Acor((N.HCM+i-1)*N.BPM+N.HBPM+(1:N.VBPM), i) = EtaYmcf;

        % Plus the coupling term to the horizontal plane
        Acor((N.HCM+i-1)*N.BPM+(1:N.HBPM), i) = EtaXmcf;
        %Acor((i-1)*N.BPM+(1:N.HBPM), i) = CMDataRM.VCMCoupling(i) * EtaXmcf;
        %Acor((i-1)*N.BPM+(1:N.HBPM), i) = zeros(size(EtaXmcf));
    end

    % Assume that the change in dispersion due to a energy shift is zero
    if strcmpi((LocoFlags.Dispersion),'yes')
        Acor = [Acor; zeros(N.BPM,N.VCM)];
    end

    A(:,Acolindex:(Acolindex+N.VCM-1)) = Acor(iNoCoupling,:);
    Acolindex = Acolindex + N.VCM;
    
    LocoFlags.Normalization.FactorVCMEnergy = abs(AlphaMCF * LocoMeasData.RF / LocoMeasData.DeltaRF);
    b_old = [b_old; CMDataRM.VCMEnergyShift];
else
    LocoFlags.Normalization.FactorVCMEnergy = [];
end

clear Acor


% Include RF Frequency as a parameter
if strcmpi((FitParameters.FitRFFrequency),'yes')
    % A weighted and rotated "Disperion" is stored in the last column of Mmodel (change in orbit due to change in RF frequency and rotate by the BPM gain, roll, crunch)
    Mrf = [zeros(N.BPM,N.HCM+N.VCM) Mmodel(:,end)/FitParameters.DeltaRF];
    Mrf = Mrf(:);

    % Include in the A matrix
    A(:,Acolindex) = Mrf(iNoCoupling);
    Acolindex = Acolindex + 1;
    %pack;  % pack is a command line only function for the Matlab 2006b release and forward
    b_old = [b_old; FitParameters.DeltaRF];
end


% Use the saved Jacobian for the rest of the parameters
FitParameters.Values = FitParameters.Values(:);      % Force a column vector
for i = 1:length(FitParameters.Params)
    % Include in the A matrix
    Acolindex = Acolindex + 1;
    b_old = [b_old; FitParameters.Values(i)];
end


function OutputVector = GetFromLocoFlagsMethods(Field, LocoFlags, BPMData, CMData, FitParameters)

OutputVector = [];

if strcmpi((BPMData.FitGains),'yes') && isfield(LocoFlags.Method.(Field),'HBPMGain')
    OutputVector = [OutputVector; LocoFlags.Method.(Field).HBPMGain];
end
if strcmpi((BPMData.FitCoupling),'yes') && isfield(LocoFlags.Method.(Field),'HBPMCoupling')
    OutputVector = [OutputVector; LocoFlags.Method.(Field).HBPMCoupling];
end
if strcmpi((BPMData.FitCoupling),'yes') && isfield(LocoFlags.Method.(Field),'VBPMCoupling')
    OutputVector = [OutputVector; LocoFlags.Method.(Field).VBPMCoupling];
end
if strcmpi((BPMData.FitGains),'yes') && isfield(LocoFlags.Method.(Field),'VBPMGain')
    OutputVector = [OutputVector; LocoFlags.Method.(Field).VBPMGain];
end
if strcmpi((CMData.FitKicks),'yes') && isfield(LocoFlags.Method.(Field),'HCMKicks')
    OutputVector = [OutputVector; LocoFlags.Method.(Field).HCMKicks];
end
if strcmpi((CMData.FitKicks),'yes') && isfield(LocoFlags.Method.(Field),'VCMKicks')
    OutputVector = [OutputVector; LocoFlags.Method.(Field).VCMKicks];
end
if strcmpi((CMData.FitCoupling),'yes') && isfield(LocoFlags.Method.(Field),'HCMCoupling')
    OutputVector = [OutputVector; LocoFlags.Method.(Field).HCMCoupling];
end
if strcmpi((CMData.FitCoupling),'yes') && isfield(LocoFlags.Method.(Field),'VCMCoupling')
    OutputVector = [OutputVector; LocoFlags.Method.(Field).VCMCoupling];
end
if strcmpi((CMData.FitHCMEnergyShift),'yes') && isfield(LocoFlags.Method.(Field),'HCMEnergyShift')
    OutputVector = [OutputVector; LocoFlags.Method.(Field).HCMEnergyShift];
end
if strcmpi((CMData.FitVCMEnergyShift),'yes') && isfield(LocoFlags.Method.(Field),'VCMEnergyShift')
    OutputVector = [OutputVector; LocoFlags.Method.(Field).VCMEnergyShift];
end
if strcmpi((FitParameters.FitRFFrequency),'yes') && isfield(LocoFlags.Method.(Field),'RF')
    OutputVector = [OutputVector; LocoFlags.Method.(Field).RF];
end
OutputVector = [OutputVector; LocoFlags.Method.(Field).FitParameters];



function LocoFlags = AddMethodToLocoFlags(Field, InputVector, LocoFlags, BPMData, CMData, FitParameters, N)

InputVector = InputVector(:);

if strcmpi((BPMData.FitGains),'yes')
    %LocoFlags.Method.(Field).HBPMGain = zeros(length(N.HBPM),1);
    %for i = 1:N.HBPMGain
    %    LocoFlags.Method.(Field).HBPMGain(BPMData.HBPMGoodDataIndex(i),1) = InputVector(i);
    %
    LocoFlags.Method.(Field).HBPMGain = InputVector(1:N.HBPMGain);
    InputVector(1:N.HBPMGain) = [];
    LocoFlags.Method.(Field) = MakeLastField(LocoFlags.Method.(Field), 'HBPMGain');
end

if strcmpi((BPMData.FitCoupling),'yes')
    %LocoFlags.Method.(Field).HBPMCoupling = zeros(length(N.HBPM),1);
    %for i = 1:N.HBPMCoupling
    %    LocoFlags.Method.(Field).HBPMCoupling(BPMData.HBPMGoodDataIndex(i),1) = InputVector(i);
    %end
    LocoFlags.Method.(Field).HBPMCoupling = InputVector(1:N.HBPMCoupling);
    InputVector(1:N.HBPMCoupling) = [];
    LocoFlags.Method.(Field) = MakeLastField(LocoFlags.Method.(Field), 'HBPMCoupling');
end

if strcmpi((BPMData.FitCoupling),'yes')
    %LocoFlags.Method.(Field).VBPMCoupling = zeros(length(N.VBPM),1);
    %for i = 1:N.VBPMCoupling
    %    LocoFlags.Method.(Field).VBPMCoupling(BPMData.VBPMGoodDataIndex(i),1) = InputVector(i);
    %end
    LocoFlags.Method.(Field).VBPMCoupling = InputVector(1:N.VBPMCoupling);
    InputVector(1:N.VBPMCoupling) = [];
    LocoFlags.Method.(Field) = MakeLastField(LocoFlags.Method.(Field), 'VBPMCoupling');
end

if strcmpi((BPMData.FitGains),'yes')
    %LocoFlags.Method.(Field).VBPMGain = zeros(length(N.VBPM),1);
    %for i = 1:N.VBPMGain
    %    LocoFlags.Method.(Field).VBPMGain(BPMData.VBPMGoodDataIndex(i),1) = InputVector(i);
    %end
    LocoFlags.Method.(Field).VBPMGain = InputVector(1:N.VBPMGain);
    InputVector(1:N.VBPMGain) = [];
    LocoFlags.Method.(Field) = MakeLastField(LocoFlags.Method.(Field), 'VBPMGain');
end

if strcmpi((CMData.FitKicks),'yes')
    %LocoFlags.Method.(Field).HCMKicks = zeros(length(N.HCM),1);
    %for i = 1:N.HCMKicks
    %    LocoFlags.Method.(Field).HCMKicks(CMData.HCMGoodDataIndex(i),1) = InputVector(i);
    %end
    LocoFlags.Method.(Field).HCMKicks = InputVector(1:N.HCMKicks);
    InputVector(1:N.HCMKicks) = [];
    LocoFlags.Method.(Field) = MakeLastField(LocoFlags.Method.(Field), 'HCMKicks');
end

if strcmpi((CMData.FitKicks),'yes')
    %LocoFlags.Method.(Field).VCMKicks = zeros(length(N.VCM),1);
    %for i = 1:N.VCMKicks
    %    LocoFlags.Method.(Field).VCMKicks(CMData.VCMGoodDataIndex(i),1) = InputVector(i);
    %end
    LocoFlags.Method.(Field).VCMKicks = InputVector(1:N.VCMKicks);
    InputVector(1:N.VCMKicks) = [];
    LocoFlags.Method.(Field) = MakeLastField(LocoFlags.Method.(Field), 'VCMKicks');
end

if strcmpi((CMData.FitCoupling),'yes')
    %LocoFlags.Method.(Field).HCMCoupling = zeros(length(N.HCM),1);
    %for i = 1:N.HCMCoupling
    %    LocoFlags.Method.(Field).HCMCoupling(CMData.HCMGoodDataIndex(i),1) = InputVector(i);
    %end
    LocoFlags.Method.(Field).HCMCoupling = InputVector(1:N.HCMCoupling);
    InputVector(1:N.HCMCoupling) = [];
    LocoFlags.Method.(Field) = MakeLastField(LocoFlags.Method.(Field), 'HCMCoupling');
end

if strcmpi((CMData.FitCoupling),'yes')
    %LocoFlags.Method.(Field).VCMCoupling = zeros(length(N.VCM),1);
    %for i = 1:N.VCMCoupling
    %    LocoFlags.Method.(Field).VCMCoupling(CMData.VCMGoodDataIndex(i),1) = InputVector(i);
    %end
    LocoFlags.Method.(Field).VCMCoupling = InputVector(1:N.VCMCoupling);
    InputVector(1:N.VCMCoupling) = [];
    LocoFlags.Method.(Field) = MakeLastField(LocoFlags.Method.(Field), 'VCMCoupling');
end

if strcmpi(CMData.FitHCMEnergyShift, 'Yes')
    %LocoFlags.Method.(Field).HCMEnergyShift = zeros(length(N.HCM),1);
    %for i = 1:N.HCMEnergyShift
    %    LocoFlags.Method.(Field).HCMEnergyShift(CMData.HCMGoodDataIndex(i),1) = InputVector(i);
    %end
    LocoFlags.Method.(Field).HCMEnergyShift = InputVector(1:N.HCMEnergyShift);
    InputVector(1:N.HCMEnergyShift) = [];
    LocoFlags.Method.(Field) = MakeLastField(LocoFlags.Method.(Field), 'HCMEnergyShift');
end

if strcmpi(CMData.FitVCMEnergyShift, 'Yes')
    %LocoFlags.Method.(Field).VCMEnergyShift = zeros(length(N.VCM),1);
    %for i = 1:N.VCMEnergyShift
    %    LocoFlags.Method.(Field).VCMEnergyShift(CMData.VCMGoodDataIndex(i),1) = InputVector(i);
    %end
    LocoFlags.Method.(Field).VCMEnergyShift = InputVector(1:N.VCMEnergyShift);
    InputVector(1:N.VCMEnergyShift) = [];
    LocoFlags.Method.(Field) = MakeLastField(LocoFlags.Method.(Field), 'VCMEnergyShift');
end

if strcmpi((FitParameters.FitRFFrequency),'yes')
    LocoFlags.Method.(Field).RF = InputVector(1);
    InputVector(1) = [];
    LocoFlags.Method.(Field) = MakeLastField(LocoFlags.Method.(Field), 'RF');
end


%for i = 1:N.FitParameters
%FitParameters.(Field).Index{i} = i;
%FitParameters.Cost{i} = InputVector(end-length(FitParameters.Values)+i) * MeanMstd;
%end
LocoFlags.Method.(Field).FitParameters = InputVector(:);
InputVector(1:N.FitParameters) = [];
LocoFlags.Method.(Field) = MakeLastField(LocoFlags.Method.(Field), 'FitParameters');


% Parity check
if ~isempty(InputVector)
    error('Cost vector length too long');
end


function S = MakeLastField(S, Field)
% Force to the last field
FieldsCell = fieldnames(S);
if length(FieldsCell) > 1
    i = find(strcmpi(Field, FieldsCell) == 1);
    iOrder = 1:length(FieldsCell);
    iOrder(end+1) = i;
    iOrder(i) = [];    
    S = orderfields(S, iOrder);
end


function Ivec = SingularValueSelectionLM(A, S, U, ay, Mstd, Mmeas, Mmodel, SVmethod)


% Singular value selection
ChiSquareVector = [];
if isempty(SVmethod)
    % Interactively select singular value
    SVDquestion = 'Select Again';
    while strcmp(SVDquestion,'Select Again')
        h1 = figure;
        set(h1,'units','normalized','position', [.05 .4 .45 .45]);
        subplot(2,1,1);
        semilogy(diag(S),'-b'); hold on;
        xlabel('Singular Value Number');
        ylabel('Magnitude');
        axis([1 length(diag(S)) min(diag(S)) max(diag(S))]);

        subplot(2,1,2);
        semilogy(diag(S)/max(diag(S)),'-b'); hold on;
        xlabel('Singular Value Number');
        ylabel('Magnitude / Max(SV)');
        a = axis;
        axis([1 length(diag(S)) a(3) a(4)]);

        if ~exist('SVDquestion2')   % Only ask once
            SVDquestion2 = questdlg('Do you want to compute chi-square as a function of S-values (Note: this can be quite time consuming)?','LOCO','Yes','No','No');
            if strcmp(SVDquestion2, 'Yes')
                % Compute Chi-square as a function of S-values
                fprintf('   Computing chi-square for as a function of S-value ... '); tic

                warning off;
                for i = 1:length(diag(S))
                    lastwarn('');
                    Cmod = U(:,1:i) * S(1:i,1:i);
                    b = Cmod \ ay;
                    b = U(:,1:i) * b;
                    Mfit = Mstd .* (A*b);        % Response matrix change for the parameter change
                    Mmodelnew = Mmodel + Mfit;   % New model response matrix
                    ChiSquareVector(i) = sum(((Mmeas - Mmodelnew) ./ Mstd) .^ 2) / length(Mstd);
                    if ~isempty(lastwarn)
                        fprintf('\n   S-value number %d warning: %s', i, lastwarn);
                    else
                        LastGoodSvalue = i;
                    end
                end
                warning on;
                fprintf('\n   %f seconds to compute chi-square for as a function of S-value. \n',toc);

            else
                LastGoodSvalue = length(diag(S));  % All S-values
            end
        end

        if strcmp(SVDquestion2, 'Yes')
            h2 = figure;
            set(h2,'units','normalized','position', [.51 .4 .45 .45]);
            semilogy(1:length(diag(S)),ChiSquareVector,'-b');
            xlabel('Singular Value Number');
            ylabel('\fontsize{10}\chi^{2} _{/ D.O.F}');
            %axis tight;
            a = axis;
            axis([1 length(diag(S)) a(3) a(4)]);
        end

        def={sprintf('[%d:%d]',1,LastGoodSvalue)};
        answer=inputdlg({'Which singular values:'},'LOCO',1,def);
        if isempty(answer)
            close(h1);
            if strcmp(SVDquestion2, 'Yes'); close(h2); end
            error('Loco stopped at the users request.');
        end

        Ivec = str2num(answer{1});
        figure(h1);
        subplot(2,1,1);
        hold on;
        semilogy(Ivec, diag(S(Ivec,Ivec)),'og','MarkerSize',2);

        SValues = diag(S);
        x=1:length(SValues);
        x(Ivec)=[];
        SValues(Ivec)=[];
        semilogy(x, SValues,'xr','MarkerSize',4);
        hold off

        subplot(2,1,2);
        hold on;
        semilogy(Ivec, diag(S(Ivec,Ivec))/max(diag(S)),'og','MarkerSize',2);
        semilogy(x, SValues/max(diag(S)),'xr','MarkerSize',4);
        hold off

        if strcmp(SVDquestion2, 'Yes')
            figure(h2);
            hold on;
            semilogy(Ivec,ChiSquareVector(Ivec),'og','MarkerSize',2);
            hold off;
        end

        SVDquestion = questdlg('Do you want to continue?','LOCO','Continue','Select Again','Select Again');

        switch SVDquestion
            case 'Continue',
                SVmethod = Ivec;
        end
        close(h1);
        if strcmp(SVDquestion2, 'Yes')
            close(h2);
        end
    end

elseif strcmpi((SVmethod),'rank')
    % Base on  rank deficient warning
    % Compute Chi-square as a function of S-values
    fprintf('   Computing chi-square as a function of S-value ... '); tic

    LastGoodSvalue = 0;
    warning off;

    % Search end:1, looking for a warning (assumes that all larger singular values will not have a warning)
    ChiSquareVector = NaN * ones(length(diag(S)),1);
    for i = length(diag(S)):-1:1
        lastwarn('');
        Cmod = U(:,1:i) * S(1:i,1:i);
        b = Cmod \ ay;
        b = U(:,1:i) * b;
        %b = V(:,1:i) * ((U(:,1:i) * S(1:i,1:i)) \ y);

        Mfit = Mstd .* (A*b);        % Response matrix change for the parameter change
        Mmodelnew = Mmodel + Mfit;   % New model response matrix
        ChiSquareVector(i) = sum(((Mmeas - Mmodelnew) ./ Mstd) .^ 2) / length(Mstd);

        if isempty(lastwarn)
            % If Cmod \ y is OK, check that inv(Cmod'*Cmod) for the variance calculation
            %fprintf('%d removed for inv() \n',i);
            bvar = U(:,1:i)*inv(Cmod'*Cmod)*U(:,1:i)';
        end
        if isempty(lastwarn)
            LastGoodSvalue = i;
            break;     % Once you get a good one assume that the rest are good
        else
            fprintf('\n   S-value number %d warning: %s', i, lastwarn);
        end
    end

    warning on;
    if LastGoodSvalue == 1
        error('Rank method for adjusting singular values failed.  Make sure the response matrix is good.');
    end

    Ivec = 1:LastGoodSvalue;
    fprintf('\n   %f seconds to compute chi-square as a function of S-value (rank method). \n',toc);

elseif length(SVmethod) > 1
    Ivec = SVmethod;


    % % Cost function
    % Ivec = 1:size(A,2)-8;


    if max(Ivec) > length(diag(S))
        error('The number of singular values requested is greater than the total number.');
    end
else
    % Base on a threshold of min/max singular value
    Ivec = find(diag(S) > max(diag(S))*SVmethod);
end


% SVD info
fprintf('   %d total singular values, %d used in fit, %d removed. \n', length(diag(S)), length(Ivec), length(diag(S))-length(Ivec));



function [LocoModel, BPMData, CMData, FitParameters, LocoFlags, RINGData] = MeritFunctionAndBookKeeping(LocoMeasData, BPMData, CMData, CMDataRM, FitParameters, LocoFlags, RINGData, b_new, b_std, N, BPMIndexShort, iNoCoupling, iOutliers)

NumberOfFitParameters = length(b_new);


% Separate corrector gains from the rest of the parameters
%fprintf('   Total number of parameters fit = %d\n', length(b_new));

% Horizontal BPM gains
if strcmpi((BPMData.FitGains),'yes')
    BPMData.HBPMGain(BPMData.HBPMGoodDataIndex) = b_new(1:N.HBPM);
    b_new(1:N.HBPM) = [];

    BPMData.HBPMGainSTD(BPMData.HBPMGoodDataIndex) = b_std(1:N.HBPM);
    b_std(1:N.HBPM) = [];
end

% Horizontal BPM coupling
if strcmpi((BPMData.FitCoupling),'yes')
    BPMData.HBPMCoupling(BPMData.HBPMGoodDataIndex) = b_new(1:N.HBPM);
    b_new(1:N.HBPM) = [];

    BPMData.HBPMCouplingSTD(BPMData.HBPMGoodDataIndex) = b_std(1:N.HBPM);
    b_std(1:N.HBPM) = [];
end

% Vertical BPM coupling
if strcmpi((BPMData.FitCoupling),'yes')
    BPMData.VBPMCoupling(BPMData.VBPMGoodDataIndex) = b_new(1:N.VBPM);
    b_new(1:N.VBPM) = [];

    BPMData.VBPMCouplingSTD(BPMData.VBPMGoodDataIndex) = b_std(1:N.VBPM);
    b_std(1:N.VBPM) = [];
end

% Vertical BPM gains
if strcmpi((BPMData.FitGains),'yes')
    BPMData.VBPMGain(BPMData.VBPMGoodDataIndex) = b_new(1:N.VBPM);
    b_new(1:N.VBPM) = [];

    BPMData.VBPMGainSTD(BPMData.VBPMGoodDataIndex) = b_std(1:N.VBPM);
    b_std(1:N.VBPM) = [];
end

% Corrector magnet gains
if strcmpi((CMData.FitKicks),'yes')
    CMData.HCMKicks(CMData.HCMGoodDataIndex) = b_new(1:N.HCM);
    b_new(1:N.HCM) = [];

    CMData.HCMKicksSTD(CMData.HCMGoodDataIndex) = b_std(1:N.HCM);
    b_std(1:N.HCM) = [];
end

if strcmpi((CMData.FitKicks),'yes')
    CMData.VCMKicks(CMData.VCMGoodDataIndex) = b_new(1:N.VCM);
    b_new(1:N.VCM) = [];

    CMData.VCMKicksSTD(CMData.VCMGoodDataIndex) = b_std(1:N.VCM);
    b_std(1:N.VCM) = [];
end

% Corrector magnet coupling
if strcmpi((CMData.FitCoupling),'yes')
    CMData.HCMCoupling(CMData.HCMGoodDataIndex) = b_new(1:N.HCM);
    b_new(1:N.HCM) = [];

    CMData.HCMCouplingSTD(CMData.HCMGoodDataIndex) = b_std(1:N.HCM);
    b_std(1:N.HCM) = [];
end

if strcmpi((CMData.FitCoupling),'yes')
    CMData.VCMCoupling(CMData.VCMGoodDataIndex) = b_new(1:N.VCM);
    b_new(1:N.VCM) = [];

    CMData.VCMCouplingSTD(CMData.VCMGoodDataIndex) = b_std(1:N.VCM);
    b_std(1:N.VCM) = [];
end

% Corrector magnet energy shifts
if strcmpi((CMData.FitHCMEnergyShift),'yes')
    CMData.HCMEnergyShift(CMData.HCMGoodDataIndex) = b_new(1:N.HCM);
    b_new(1:N.HCM) = [];

    CMData.HCMEnergyShiftSTD(CMData.HCMGoodDataIndex) = b_std(1:N.HCM);
    b_std(1:N.HCM) = [];
end
if strcmpi((CMData.FitVCMEnergyShift),'yes')
    CMData.VCMEnergyShift(CMData.VCMGoodDataIndex) = b_new(1:N.VCM);
    b_new(1:N.VCM) = [];

    CMData.VCMEnergyShiftSTD(CMData.VCMGoodDataIndex) = b_std(1:N.VCM);
    b_std(1:N.VCM) = [];
end

% RF Frequency parameter fit
if strcmpi((FitParameters.FitRFFrequency),'yes')
    FitParameters.DeltaRF = b_new(1);
    b_new(1) = [];

    FitParameters.DeltaRFSTD = b_std(1);
    b_std(1) = [];
end


% The rest of the parameter fits
FitParameters.Values    = b_new;
FitParameters.ValuesSTD = b_std;


% Change RINGData for the values in FitParameters.Params
for i = 1:length(FitParameters.Params)
    RINGData = locosetlatticeparam(RINGData, FitParameters.Params{i}, FitParameters.Values(i));
end


% Compute the new model response matrix with dispersion for saving
fprintf('   Computing final response matrix (after fit) (%s, %s) ... ', LocoFlags.ResponseMatrixCalculator, LocoFlags.ClosedOrbitType); tic
CMDataRM.HCMKicks    = CMData.HCMKicks(CMData.HCMGoodDataIndex);
CMDataRM.VCMKicks    = CMData.VCMKicks(CMData.VCMGoodDataIndex);
CMDataRM.HCMCoupling = CMData.HCMCoupling(CMData.HCMGoodDataIndex);
CMDataRM.VCMCoupling = CMData.VCMCoupling(CMData.VCMGoodDataIndex);
warning off;
lastwarn('');

if isempty(FitParameters.DeltaRF)
    Mmodel = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags);
else
    Mmodel = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags, 'RF', FitParameters.DeltaRF);
end
warning on;
fprintf('%f seconds. \n',toc);
if ~isempty(lastwarn)
    fprintf('\n   Warning computing the final response matrix:\n         %s\n', lastwarn);
    fprintf(  '   Check the final values of the fits to make sure they are in a reasonable range for\n');
    fprintf(  '   this accelerator.  Check the input data and/or reduce the number of singular values.\n\n');
end


% Rotate Mmodel and remove BPMs not in the measured response matrix
C11 = ones(length(BPMData.BPMIndex),1);
C11(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex)) = BPMData.HBPMGain(BPMData.HBPMGoodDataIndex);

C12 = zeros(length(BPMData.BPMIndex),1);
C12(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex)) = BPMData.HBPMCoupling(BPMData.HBPMGoodDataIndex);

C21 = zeros(length(BPMData.BPMIndex),1);
C21(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex)) = BPMData.VBPMCoupling(BPMData.VBPMGoodDataIndex);

C22 = ones(length(BPMData.BPMIndex),1);
C22(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex)) = BPMData.VBPMGain(BPMData.VBPMGoodDataIndex);

C = [diag(C11) diag(C12)
    diag(C21) diag(C22)];
clear C11 C12 C21 C22

Mmodel = C * Mmodel;
Mmodel = Mmodel(BPMIndexShort, :);


% Put the model and dispersion in the proper structures to output
LocoModel = struct('M',[], 'OutlierIndex',[], 'Eta',[], 'EtaOutlierIndex',[], 'ChiSquare',[]);
if isempty(FitParameters.DeltaRF)
    LocoModel.M   = Mmodel;
    LocoModel.Eta = [];
else
    LocoModel.M   = Mmodel(:,1:end-1);
    LocoModel.Eta = Mmodel(:,end);
end


% Outliers must reference the coupled model since that is how the model is stored
iOutliersOld = iOutliers;
if strcmpi((LocoFlags.Coupling),'no')
    tmp = zeros(size(Mmodel(:)));
    tmp(iNoCoupling(iOutliers)) = 1;
    iOutliers = find(tmp==1);
    clear tmp
end


% Separate Mmodel outliers from Eta outliers
if strcmpi((LocoFlags.Dispersion),'yes')
    i = find(iOutliers <= (N.HBPM+N.VBPM)*(N.HCM+N.VCM));
    LocoModel.OutlierIndex = iOutliers(i);
    i = find(iOutliers > (N.HBPM+N.VBPM)*(N.HCM+N.VCM));
    LocoModel.EtaOutlierIndex = iOutliers(i) - ((N.HBPM+N.VBPM)*(N.HCM+N.VCM));
else
    LocoModel.OutlierIndex = iOutliers;
    LocoModel.EtaOutlierIndex = [];
end

% Compute chi-squared based on new model
Mmeas = LocoMeasData.M;
Mmeas = Mmeas([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], [CMData.HCMGoodDataIndex length(CMData.HCMIndex)+CMData.VCMGoodDataIndex]);

Mstd = LocoMeasData.BPMSTD * ones(1,size(LocoMeasData.M,2));
Mstd = Mstd ([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], [CMData.HCMGoodDataIndex length(CMData.HCMIndex)+CMData.VCMGoodDataIndex]);

Xstd = LocoMeasData.BPMSTD(BPMData.HBPMGoodDataIndex);
Ystd = LocoMeasData.BPMSTD(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex);


% When using the fixed momentum response matrix calculator, the merit function becomes:
%              Merit = Mmeas_ij - Mmod_ij - Dp/p_j * eta_i
%              where eta_i is the measured eta (not the model eta)
% This is done by changing Mmodel to (Mmodel_ij + Dp/p_j * eta_i)
%if strcmpi((CMData.FitHCMEnergyShift),'yes') | strcmpi((CMData.FitVCMEnergyShift),'yes')
if strcmpi((LocoFlags.ClosedOrbitType), 'fixedmomentum')
    HCMEnergyShift = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
    VCMEnergyShift = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);

    if ~exist('AlphaMCF')
        AlphaMCF = locomcf(RINGData);
        EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
        EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    end

    for i = 1:length(HCMEnergyShift)
        Mmodel(:,i) = Mmodel(:,i) + HCMEnergyShift(i) * [EtaXmcf; EtaYmcf];
    end

    for i = 1:length(VCMEnergyShift)
        Mmodel(:,N.HCM+i) = Mmodel(:,N.HCM+i) + VCMEnergyShift(i) * [EtaXmcf; EtaYmcf];
    end
end

Mstd  = Mstd(:);
Mmeas = Mmeas(:);
if strcmpi((LocoFlags.Dispersion),'yes')
    EtaX = LocoMeasData.Eta(BPMData.HBPMGoodDataIndex);
    EtaY = LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex);

    Mstd  = [Mstd;  [Xstd; Ystd]];
    Mmeas = [Mmeas; [EtaX; EtaY]];
else
    if ~isempty(FitParameters.DeltaRF)
        Mmodel = Mmodel(:,1:end-1);
    end
end
Mmodel = Mmodel(:);

% Remove coupling rows
if strcmpi((LocoFlags.Coupling),'no')
    Mmodel = Mmodel(iNoCoupling,:);
    Mmeas = Mmeas(iNoCoupling,:);
    Mstd = Mstd(iNoCoupling,:);
end

Mmeas(iOutliersOld) = [];
Mmodel(iOutliersOld) = [];
Mstd(iOutliersOld) = [];
%ChiSquare = sum(((Mmeas - Mmodel) ./ Mstd) .^ 2) / length(Mstd);
ChiSquare = sum(((Mmeas - Mmodel) ./ Mstd) .^ 2) / (length(Mstd)-NumberOfFitParameters);   % mean e'*e = sigma*(n-k)
fprintf('   Chi-square/D.O.F. = %f (N=%d, K=%d) (computed from final response matrix)\n\n', ChiSquare, length(Mstd), NumberOfFitParameters);
LocoModel.ChiSquare = ChiSquare;  % This may get removed in the future


% Empty .Chi2 of any old data
% It usually gets calcuated in locogui
FitParameters.Chi2 = [];
FitParameters.Chi2.Chi2 = ChiSquare;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove the Normalization Factors %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function b_delta = RemoveNormalizationFactors(b_delta, N, CMData, FitParameters, LocoFlags)

if strcmpi(FitParameters.FitRFFrequency, 'yes')
    b_delta(end-length(FitParameters.Params):end-length(FitParameters.Params)) = b_delta(end-length(FitParameters.Params):end-length(FitParameters.Params)) / LocoFlags.Normalization.FactorRF;
    %b_std(  end-length(FitParameters.Params):end-length(FitParameters.Params)) = b_std(  end-length(FitParameters.Params):end-length(FitParameters.Params)) / abs(LocoFlags.Normalization.FactorRF);
end
if strcmpi(LocoFlags.Normalization.Flag, 'yes')
    if LocoFlags.Normalization.ByRMSFlag
        % Entire A matrix
        b_delta = b_delta ./ LocoFlags.Normalization.Factor;
        %b_std   = b_std   ./ abs(LocoFlags.Normalization.Factor);

        %% Just parameter fits
        %if length(FitParameters.Params) ~= 0
        %    b_delta(end-length(FitParameters.Params)+1:end) = b_delta(end-length(FitParameters.Params)+1:end) ./ LocoFlags.Normalization.Factor;
        %    b_std(  end-length(FitParameters.Params)+1:end) = b_std(  end-length(FitParameters.Params)+1:end) ./ abs(LocoFlags.Normalization.Factor);
        %end
    else
        % CMs
        if ~isempty(LocoFlags.Normalization.FactorCM)
            b_delta(N.BPMfit+1:N.BPMfit+length(LocoFlags.Normalization.FactorCM)) = b_delta(N.BPMfit+1:N.BPMfit+length(LocoFlags.Normalization.FactorCM)) ./ LocoFlags.Normalization.FactorCM;
            %b_std(  N.BPMfit+1:N.BPMfit+length(LocoFlags.Normalization.FactorCM)) = b_std(  N.BPMfit+1:N.BPMfit+length(LocoFlags.Normalization.FactorCM)) ./ abs(LocoFlags.Normalization.FactorCM);
        end
        if strcmpi(CMData.FitHCMEnergyShift, 'yes')
            NN = N.BPMfit + length(LocoFlags.Normalization.FactorCM);
            b_delta(NN+1:NN+N.HCM) = b_delta(NN+1:NN+N.HCM) / LocoFlags.Normalization.FactorHCMEnergy;
            %b_std(NN+1:NN+N.HCM)   = b_std(NN+1:NN+N.HCM)   / abs(LocoFlags.Normalization.FactorHCMEnergy);
        end
        if strcmpi(CMData.FitVCMEnergyShift, 'yes')
            NN = N.BPMfit + length(LocoFlags.Normalization.FactorCM) + N.HCM;
            b_delta(NN+1:NN+N.VCM) = b_delta(NN+1:NN+N.VCM) / LocoFlags.Normalization.FactorVCMEnergy;
            %b_std(NN+1:NN+N.VCM)   = b_std(NN+1:NN+N.VCM)   / abs(LocoFlags.Normalization.FactorVCMEnergy);
        end

        % Parameter fits
        if ~isempty(FitParameters.Params)
            b_delta(end-length(FitParameters.Params)+1:end) = b_delta(end-length(FitParameters.Params)+1:end) ./ LocoFlags.Normalization.Factor;
            %b_std(  end-length(FitParameters.Params)+1:end) = b_std(  end-length(FitParameters.Params)+1:end) ./ abs(LocoFlags.Normalization.Factor);
        end
    end
end




function [NRows, NCols, N] = LocoJacobianSize(varargin)
%LOCOJACOBIANSIZE - Calculate size the Jacobian matrix used in LOCO
%
%  [NRows, NCols, N] = LocoJacobianSize(LOCOFileName, IterNumber)
%  [NRows, NCols, N] = LocoJacobianSize(LocoModel, LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData, IterationNumber)
%
%  INPUTS
%  1. LOCOFileName - LOCO file name
%  2. Niter - LOCO iteration number (0,1, ...) {Default: last iteration}
%
%
%  OUTPUTS
%  1. NRows - Rows in A
%  2. NCols - Columns in A
%  3. N - Structure of various sizes


% Parse input
LOCOFileName = '';
IterNumber = [];
DisplayFlag = '';
NRows = 0;
NCols = 0;
N.BPMfit = 0;


% First strip out the strings
for i = length(varargin):-1:1
    if ischar(varargin{i})
        if any(strcmpi(varargin{i},{'NoDisplay','NoPlot'}))
            DisplayFlag = 'NoDisplay';
            varargin(i) = [];
        elseif any(strcmpi(varargin{i},{'Display','Plot'}))
            DisplayFlag = 'Display';
            varargin(i) = [];
        else
            LOCOFileName = varargin{i};
            varargin(i) = [];
        end
    end
end

if length(varargin) > 3    
    LocoModel     = varargin{1};
    LocoMeasData  = varargin{2};
    BPMData       = varargin{3};
    CMData        = varargin{4};
    FitParameters = varargin{5};
    LocoFlags     = varargin{6};
    RINGData      = varargin{7};
    varargin(1:7) = [];
else
    % LOCO file
    if isempty(LOCOFileName)
        [FileName, PathName] = uigetfile('*.mat', 'Select A LOCO File', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        if isequal(FileName,0) || isequal(PathName,0)
            return
        end
        LOCOFileName= [PathName, FileName];
    elseif LOCOFileName(1) == '.'
        [FileName, PathName] = uigetfile('*.mat', 'Select A LOCO File');

        if isequal(FileName,0) || isequal(PathName,0)
            return
        end
        LOCOFileName= [PathName, FileName];
    end

    load(LOCOFileName);
end


% Iterations
if ~isempty(varargin)
    IterNumber = varargin{1};
    varargin(1) = [];
end
if isempty(IterNumber)
    IterNumber = length(BPMData)-1;
end
if IterNumber<0 || IterNumber>(length(FitParameters)-1)
    error('Iteration number must be between 0 and %d', length(FitParameters)-1);
end

IterNumber = IterNumber + 1;
LocoModel     = LocoModel(IterNumber);
BPMData       = BPMData(IterNumber);
CMData        = CMData(IterNumber);
FitParameters = FitParameters(IterNumber);
LocoFlags     = LocoFlags(IterNumber);


N.HBPM = length(BPMData.HBPMGoodDataIndex);
N.VBPM = length(BPMData.VBPMGoodDataIndex);
N.BPM  = N.HBPM + N.VBPM;
N.HCM  = length(CMData.HCMGoodDataIndex);
N.VCM  = length(CMData.VCMGoodDataIndex);
N.CM   = N.HCM + N.VCM;


% Number of rows
if strcmpi((LocoFlags.Dispersion),'yes')
    if strcmpi(LocoFlags.Coupling, 'No')
        NRows = N.HBPM*(N.HCM+1) + N.VBPM*N.VCM;  % No off-diagonal terms
    else
        NRows = N.BPM * (N.CM+1);
    end
else
    if strcmpi(LocoFlags.Coupling, 'No')
        NRows = N.HBPM*N.HCM + N.VBPM*N.VCM;  % No off-diagonal terms
    else
        NRows = N.BPM * N.CM;
    end
end


% BPMs
if strcmpi((BPMData.FitGains),'yes')
    N.Index.HBPMGain = NCols + 1;
    N.HBPMGain = length(BPMData.HBPMGoodDataIndex);
    NCols = NCols + N.HBPMGain;
else
    N.Index.HBPMGain = [];
    N.HBPMGain = 0;
end

if strcmpi((BPMData.FitCoupling),'yes')
    N.Index.HBPMCoupling = NCols + 1;
    N.HBPMCoupling = length(BPMData.HBPMGoodDataIndex);
    NCols = NCols + N.HBPMCoupling;
else
    N.Index.HBPMCoupling = [];
    N.HBPMCoupling = 0;
end

if strcmpi((BPMData.FitCoupling),'yes')
    N.Index.VBPMCoupling = NCols + 1;
    N.VBPMCoupling = length(BPMData.VBPMGoodDataIndex);
    NCols = NCols + N.VBPMCoupling;
else
    N.Index.VBPMCoupling = [];
    N.VBPMCoupling = 0;
end

if strcmpi((BPMData.FitGains),'yes')
    N.Index.VBPMGain = NCols + 1;
    N.VBPMGain = length(BPMData.VBPMGoodDataIndex);
    NCols = NCols + N.VBPMGain;
else
    N.Index.VBPMGain = [];
    N.VBPMGain = 0;
end
N.BPMfit = NCols;


% CMs
if strcmpi((CMData.FitKicks),'yes')
    N.Index.HCMKicks = NCols + 1;
    N.HCMKicks = length(CMData.HCMGoodDataIndex);
    NCols = NCols + N.HCMKicks;
    N.HCMfit = N.HCMKicks;
else
    N.Index.HCMKicks = [];
    N.HCMKicks = 0;
end

if strcmpi((CMData.FitKicks),'yes')
    N.Index.VCMKicks = NCols + 1;
    N.VCMKicks = length(CMData.VCMGoodDataIndex);
    NCols = NCols + N.VCMKicks;
    N.VCMfit = N.VCMKicks;
else
    N.Index.VCMKicks = [];
    N.VCMKicks = 0;
end

if strcmpi((CMData.FitCoupling),'yes')
    N.Index.HCMCoupling = NCols + 1;
    N.HCMCoupling = length(CMData.HCMGoodDataIndex);
    NCols = NCols + N.HCMCoupling;
    N.HCMfit = N.HCMfit + N.HCMCoupling;
else
    N.Index.HCMCoupling = [];
    N.HCMCoupling = 0;
end

if strcmpi((CMData.FitCoupling),'yes')
    N.Index.VCMCoupling = NCols + 1;
    N.VCMCoupling = length(CMData.VCMGoodDataIndex);
    NCols = NCols + N.VCMCoupling;
    N.VCMfit = N.VCMfit + N.VCMCoupling;
else
    N.Index.VCMCoupling = [];
    N.VCMCoupling = 0;
end

if strcmpi((CMData.FitHCMEnergyShift),'yes')
    N.Index.HCMEnergyShift = NCols + 1;
    N.HCMEnergyShift = length(CMData.HCMGoodDataIndex);
    NCols = NCols + N.HCMEnergyShift;
    %N.HCMfit = N.HCMfit + N.HCMCoupling;
else
    N.Index.HCMEnergyShift = [];
    N.HCMEnergyShift = 0;
end

if strcmpi((CMData.FitVCMEnergyShift),'yes')
    N.Index.VCMEnergyShift = NCols+1;
    N.VCMEnergyShift = length(CMData.VCMGoodDataIndex);
    NCols = NCols + N.VCMEnergyShift;
    %N.NVCMfit = N.NVCMfit + N.VCMCoupling;
else
    N.Index.VCMEnergyShift = [];
    N.VCMEnergyShift = 0;
end


% RF
if strcmpi((FitParameters.FitRFFrequency),'yes')
    N.Index.RF = NCols + 1;
    N.RF = 1;
    NCols = NCols + 1;
else
    N.Index.RF = [];
    N.RF = 0;
end


% Parameter fits
N.Index.FitParameters = NCols+1;
N.FitParameters = length(FitParameters.Values);
NCols = NCols + N.FitParameters;




function [BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = LOCOInputChecks(BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData)
if strcmpi(FitParameters.FitRFFrequency,'yes')
    if strcmpi(LocoFlags.Dispersion,'no')
        LocoFlags.Dispersion = 'Yes';
        fprintf('   Warning:  Include dispersion flag cannot be off when fitting the RF frequency.\n');
        fprintf('             Hence, it has been turned on.\n');
    end
end

% BPM coupling cannot be be fit without the off-diagonal terms being included
if strcmpi(BPMData.FitCoupling,'yes')
    if strcmpi(LocoFlags.Coupling,'no')
        fprintf('   Warning:  BPM coupling cannot be fit without the off-diagonal terms flag turned on.\n');
        fprintf('             Hence, the include off-diagonal terms flag has been turned on.\n');
    end
    LocoFlags.Coupling = 'Yes';
    LocoFlags.Coupling = 'Yes';
    %BPMData.HBPMCoupling = zeros(length(BPMData.HBPMIndex),1);
    %BPMData.VBPMCoupling = zeros(length(BPMData.VBPMIndex),1);
end

% CM roll cannot be be fit without the off-diagonal terms being included
if strcmpi(CMData.FitCoupling,'yes')
    if strcmpi(LocoFlags.Coupling,'no')
        fprintf('   Warning:  Corrector magnets rolls cannot be fit without the off-diagonal terms flag turned on.\n');
        fprintf('             Hence, the include off-diagonal terms flag has been turned on.\n');
    end
    LocoFlags.Coupling = 'Yes';
    LocoFlags.Coupling = 'Yes';
    %CMData.HCMCoupling = zeros(length(CMData.HCMIndex),1);
    %CMData.VCMCoupling = zeros(length(CMData.VCMIndex),1);
end

if strcmpi(CMData.FitHCMEnergyShift,'yes') || strcmpi(CMData.FitHCMEnergyShift,'yes')
    if ~strcmpi(LocoFlags.ClosedOrbitType,'fixedmomentum')
        LocoFlags.ClosedOrbitType = 'fixedmomentum';
        fprintf('   Warning:  When fitting energy shifts at the corrector magnets the constant\n');
        fprintf('             momentum method must be used. Hence it has been turned on.\n');
    end
end

if strcmpi((CMData.FitHCMEnergyShift),'no') && strcmpi((CMData.FitHCMEnergyShift),'no')
    if ~strcmpi((LocoFlags.ClosedOrbitType),'fixedpathlength')
        %LocoFlags.ClosedOrbitType = 'fixedpathlength';
        fprintf('   Warning:  When not fitting energy shifts at the corrector magnets\n');
        fprintf('             usually the fix path length method is used.  The energy shift\n');
        fprintf('             at the corrector magnets will still be used to adjust the model.\n');
    end
end

if isempty(LocoMeasData.Eta) && strcmpi((LocoFlags.ClosedOrbitType),'fixedmomentum')
    error('Measured dispersion (LocoMeasData.Eta) can not be empty when using fixed momentum');
end


% Fill the standard deviations with NaN so the vectors get sized properly
BPMData.HBPMGainSTD = NaN*ones(length(BPMData.HBPMIndex),1);
BPMData.VBPMGainSTD = NaN*ones(length(BPMData.VBPMIndex),1);
BPMData.HBPMCouplingSTD = NaN*ones(length(BPMData.HBPMIndex),1);
BPMData.VBPMCouplingSTD = NaN*ones(length(BPMData.VBPMIndex),1);

CMData.HCMKicksSTD = NaN*ones(length(CMData.HCMIndex),1);
CMData.VCMKicksSTD = NaN*ones(length(CMData.VCMIndex),1);
CMData.HCMCouplingSTD = NaN*ones(length(CMData.HCMIndex),1);
CMData.VCMCouplingSTD = NaN*ones(length(CMData.VCMIndex),1);

FitParameters.ValuesSTD = [];
FitParameters.DeltaRFSTD = [];


fprintf('   Number of BPM:  %d horizontal %d vertical\n', length(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex)), length(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex)));
fprintf('   Number of CM:   %d horizontal %d vertical\n', length(CMData.HCMIndex(CMData.HCMGoodDataIndex)), length(CMData.VCMIndex(CMData.VCMGoodDataIndex)));


% Set the lattice model to the starting LocoValues
for i = 1:length(FitParameters.Params)
    RINGData = locosetlatticeparam(RINGData, FitParameters.Params{i}, FitParameters.Values(i));
end




% LM variance???
%         % Variance of the parameters
%         % Note: the inv(Amod'*Amod) has zero covariance terms
%         if strcmpi(LocoFlags.CalculateSigma, 'Yes')
%             % Compute the covariance matrix
%             % Only the variance terms are used, the covariance terms are probably interesting
%             % and can be output to a file for further analysis.
%             if strcmpi((LocoFlags.Dispersion),'yes') && ~(LocoFlags.HorizontalDispersionWeight == 1 && LocoFlags.VerticalDispersionWeight == 1)
%                 % Dispersion weight need to be removed:  T E{uu'} T' not an identity matrix
%                 %XB, this seems to be inappropriate if we need to take out the dispersion weight.
%                 %             for i = 1:N.HCM
%                 %                 U(end-N.BPM+i,:) = LocoFlags.HorizontalDispersionWeight * U(end-N.BPM+i,:);
%                 %             end
%                 %             for i = 1:N.VCM
%                 %                 U(end-N.VCM+i,:) = LocoFlags.VerticalDispersionWeight * U(end-N.VCM+i,:);
%                 %             end
%                 %CovFit = V(:,Ivec) * diag(diag(S(Ivec,Ivec)).^(-1)) * U(:,Ivec)' * U(:,Ivec) * diag(diag(S(Ivec,Ivec)).^(-1)) * V(:,Ivec)';
%                 
%                 CovFit = V(:,Ivec) * diag(diag(S(Ivec,Ivec)).^(-1))  * V(:,Ivec)';
%             else
%                 CovFit = V(:,Ivec) * diag(diag(S(Ivec,Ivec)).^(-1));
%                 CovFit = CovFit * CovFit';
%             end
% 
% 
%             % Remove the normalization factors (Column weights) from the covariance matrix
%             if strcmpi(NormalizeFlag,'yes')
%                 if NormalizationByRMSFlag
%                     % Entire A matrix
%                     NormFactor =  abs(NormalizationFact(:));
% 
%                     % RF will double normalization
%                     if strcmpi((FitParameters.FitRFFrequency),'yes')
%                         NormFactor(end-length(FitParameters.Params)) = NormFactor(end-length(FitParameters.Params)) * abs(NormalizationFactRF);
%                     end
%                 else
%                     NormFactor = ones(N.BPMfit, 1);    % BPMs
%                     NormFactor = [NormFactor; abs(NormalizationFactCM)];    % CMs
%                     if strcmpi((CMData.FitHCMEnergyShift),'yes')
%                         NormFactor = [NormFactor; ones(N.HCM,1)*abs(NormalizationFactHCMEnergy)];    % HCM Energy Shift
%                     end
%                     if strcmpi((CMData.FitVCMEnergyShift),'yes')
%                         NormFactor = [NormFactor; ones(N.VCM,1)*abs(NormalizationFactVCMEnergy)];    % VCM Energy Shift
%                     end
%                     if strcmpi((FitParameters.FitRFFrequency),'yes')
%                         NormFactor = [NormFactor; abs(NormalizationFactRF)];    % RF
%                     end
%                     if ~isempty(FitParameters.Params)
%                         NormFactor = [NormFactor; abs(NormalizationFact)];    % Parameter fits
%                     end
%                 end
% 
%                 CovFit = CovFit * diag(NormFactor.^-1);
%                 CovFit = diag(NormFactor.^-1) * CovFit;
%             end
% 
%             b_std = sqrt(diag(CovFit));
% 
% 
%             % Add the full covariance term to the data save (if requested by the user)
%             if ~isempty(LocoFlags.SVDDataFileName) && ischar(LocoFlags.SVDDataFileName)
%                 save(LocoFlags.SVDDataFileName, 'CovFit', '-append');
%             end
% 
%             clear CovFit
% 
%         else
%             b_std = NaN * ones(size(V,1),1);
%         end



% if strcmpi((BPMData.FitGains),'yes')
% end
% if strcmpi((BPMData.FitCoupling),'yes')
% end
% if strcmpi((BPMData.FitCoupling),'yes')
% end
% if strcmpi((BPMData.FitGains),'yes')
% 
% if strcmpi((CMData.FitKicks),'yes')
% end
% if strcmpi((CMData.FitKicks),'yes')
% end
% if strcmpi((CMData.FitCoupling),'yes')
% end
% if strcmpi((CMData.FitCoupling),'yes')
% end
% 
% if strcmpi((CMData.FitHCMEnergyShift),'yes')
% end
% if strcmpi((CMData.FitVCMEnergyShift),'yes')
% end
% 
% if strcmpi((FitParameters.FitRFFrequency),'yes')
% end
% 
% Fit Parameters
