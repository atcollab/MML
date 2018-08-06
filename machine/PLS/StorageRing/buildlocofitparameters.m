function [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocofitparameters(FileName)
%BUILDLOCOFITPARAMETERS - PLS LOCO fit parameters
%
%  [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocoinput(FileName)



%%%%%%%%%%%%%%
% Input file %
%%%%%%%%%%%%%%
if nargin == 0
    [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat','Select a LOCO input file');
    if FilterIndex == 0 
        return;
    end
    FileName = [DirectoryName, FileName];
end

load(FileName);



%%%%%%%%%%%%%%%%%%%%%%
% Remove bad devices %
%%%%%%%%%%%%%%%%%%%%%%
RemoveHCMDeviceList = [];
RemoveVCMDeviceList = [];

RemoveHBPMDeviceList = [7 2; 11 8];
RemoveVBPMDeviceList = [11 8];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is only works on the first iteration %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('BPMData','var') && length(BPMData)>1
    BPMData = BPMData(1);
end
if exist('CMData','var') && length(CMData)>1
    CMData = CMData(1);
end
if exist('FitParameters','var') && length(FitParameters)>1
    FitParameters = FitParameters(1);
end
if exist('LocoFlags','var') && length(LocoFlags)>1
    LocoFlags = LocoFlags(1);
end
if exist('LocoModel','var') && length(LocoModel)>1
    LocoModel = LocoModel(1);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure the start point in loaded in the AT model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(FitParameters)
    for i = 1:length(FitParameters.Params)
        RINGData = locosetlatticeparam(RINGData, FitParameters.Params{i}, FitParameters.Values(i));
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tune up a few parameters based on the MachineConfig %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    if isfield(LocoMeasData, 'MachineConfig')
        % Sextupoles
        if all(MachineConfig.SF.Setpoint.Data == 0)
            fprintf('   Turning SF family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SF')';
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end
        if all(MachineConfig.SD.Setpoint.Data == 0)
            fprintf('   Turning SD family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SD')';
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end

        % Skew quadrupoles
        if all(MachineConfig.SkewQuad.Setpoint.Data == 0)
           fprintf('   SkewQuad family was at zero when the response matrix was taken.\n');
        end
    end
catch
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocoFlags to change from the default %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocoFlags.Threshold = 1e-5;
% LocoFlags.OutlierFactor = 10;
% LocoFlags.SVmethod = 1e-2;
% LocoFlags.HorizontalDispersionWeight = 12.5;
% LocoFlags.VerticalDispersionWeight = 12.5;
% LocoFlags.AutoCorrectDelta = 'Yes';
LocoFlags.Coupling = 'No';
LocoFlags.Dispersion = 'No';
% LocoFlags.Normalize = 'Yes';
% LocoFlags.ResponseMatrixCalculatorFlag1 = 'Linear';
% LocoFlags.ResponseMatrixCalculatorFlag2 = 'FixedPathLength';
% LocoFlags.CalculateSigma = 'No';
% LocoFlags.SinglePrecision = 'Yes';


CMData.FitKicks    = 'Yes';
CMData.FitCoupling = 'No';

BPMData.FitGains    = 'Yes';
BPMData.FitCoupling = 'No';


% CMs to disable
j = findrowindex(RemoveHCMDeviceList, LocoMeasData.HCM.DeviceList);
if ~isempty(j)
    CMData.HCMGoodDataIndex(j) = [];
end

j = findrowindex(RemoveVCMDeviceList, LocoMeasData.VCM.DeviceList);
if ~isempty(j)
    CMData.VCMGoodDataIndex(j) = [];
end


% BPMs to disable
j = findrowindex(RemoveHBPMDeviceList, LocoMeasData.HBPM.DeviceList);
if ~isempty(j)
    irm = findrowindex(j(:),BPMData.HBPMGoodDataIndex(:));
    BPMData.HBPMGoodDataIndex(irm) = [];
end

j = findrowindex(RemoveVBPMDeviceList, LocoMeasData.VBPM.DeviceList);
if ~isempty(j)
    irm = findrowindex(j(:),BPMData.VBPMGoodDataIndex(:));
    BPMData.VBPMGoodDataIndex(irm) = [];
end



%%%%%%%%%%%%%%%%%
% FitParameters %
%%%%%%%%%%%%%%%%%

% Individual magnets
% For each parameter which is fit in the model a numerical response matrix
% gradient needs to be determined.  The FitParameters data structure determines what
% parameter in the model get varied and how are they grouped.  For no parameter fits, set
% FitParameters.Params to an empty vector.
%     FitParameters.Params = parameter group definition (cell array for AT)
%     FitParameters.Values = Starting value for the parameter fit
%     FitParameters.Deltas = change in parameter value used to compute the gradient (NaN forces loco to choose, see auto-correct delta flag below)
%     FitParameters.FitRFFrequency = ('Yes'/'No') Fit the RF frequency?
%     FitParameters.DeltaRF = Change in RF frequency when measuring "dispersion".
%                             If the RF frequency is being fit the output is stored here.
%
% The FitParameters structure also contains the standard deviations of the fits:
%     LocoValuesSTD
%     FitParameters.DeltaRFSTD
%
% Note: FitParameters.DeltaRF is used when including dispersion in the response matrix.
%       LocoMeasData.DeltaRF is not used directly in loco.  Usually one would set
%       FitParameters.DeltaRF = LocoMeasData.DeltaRF as a starting point for the RF frequency.

FitParameters = [];
FitParameters.Values = [];
FitParameters.Deltas = [];

ButtonName = questdlg('Which LOCO fit parameter?','FIT PARAMETERS','Special Fit','Fit By Power Supply','Fit Individual Magnets','Fit By Power Supply');
drawnow;
switch ButtonName
        case 'Special Fit'

        fprintf('\n   Special fit\n');
        fprintf('       1 Q1    (1)\n');
        fprintf('    2-13 Q2   (12)\n');
        fprintf('   14-25 Q3   (12)\n');
        fprintf('      26 Q4    (1)\n');
        fprintf('      27 Q5    (1)\n');
        fprintf('      28 Q6    (1)\n');

        N = 0;     
        
        % 1 Q1 K-values
        QI = findcells(RINGData.Lattice,'FamName','Q1');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI,'K');
        FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(1));
        FitParameters.Deltas(N,1) = NaN;


        % 12 Q2 K-values
        QI = findcells(RINGData.Lattice,'FamName','Q2');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI([1 end]),'K');
        FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(1));
        FitParameters.Deltas(N,1) = NaN;
        for loop=2:2:length(QI)-1
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI([loop loop+1]),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(loop));
            FitParameters.Deltas(N,1) = NaN;
        end
        
        % 12 Q3 K-values
        QI = findcells(RINGData.Lattice,'FamName','Q3');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI([1 end]),'K');
        FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(1));
        FitParameters.Deltas(N,1) = NaN;
        for loop=2:2:length(QI)-1
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI([loop loop+1]),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(loop));
            FitParameters.Deltas(N,1) = NaN;
        end

        % Q4 K-value
        QI = findcells(RINGData.Lattice,'FamName','Q4');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI,'K');
        FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(1));
        FitParameters.Deltas(N,1) = NaN;

        % Q5 K-value
        QI = findcells(RINGData.Lattice,'FamName','Q5');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI,'K');
        FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(1));
        FitParameters.Deltas(N,1) = NaN;

        % Q6 K-value
        QI = findcells(RINGData.Lattice,'FamName','Q6');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI,'K');
        FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(1));
        FitParameters.Deltas(N,1) = NaN;
        
    
    case 'Fit By Power Supply'

        fprintf('\n   Parameter fits by power supply\n');
        fprintf('    1-12 Q1   (12)\n');
        fprintf('   13-24 Q2   (12)\n');
        fprintf('   25-36 Q3   (12)\n');
        fprintf('      37 Q4    (1)\n');
        fprintf('      38 Q5    (1)\n');
        fprintf('      39 Q6    (1)\n');

        N = 0;     
        
        % 12 Q1 K-values
        QI = findcells(RINGData.Lattice,'FamName','Q1');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI([1 end]),'K');
        FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(1));
        FitParameters.Deltas(N,1) = NaN;
        for loop=2:2:length(QI)-1
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI([loop loop+1]),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(loop));
            FitParameters.Deltas(N,1) = NaN;
        end


        % 12 Q2 K-values
        QI = findcells(RINGData.Lattice,'FamName','Q2');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI([1 end]),'K');
        FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(1));
        FitParameters.Deltas(N,1) = NaN;
        for loop=2:2:length(QI)-1
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI([loop loop+1]),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(loop));
            FitParameters.Deltas(N,1) = NaN;
        end
        
        % 12 Q3 K-values
        QI = findcells(RINGData.Lattice,'FamName','Q3');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI([1 end]),'K');
        FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(1));
        FitParameters.Deltas(N,1) = NaN;
        for loop=2:2:length(QI)-1
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI([loop loop+1]),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(loop));
            FitParameters.Deltas(N,1) = NaN;
        end

        % Q4 K-value
        QI = findcells(RINGData.Lattice,'FamName','Q4');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI,'K');
        FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(1));
        FitParameters.Deltas(N,1) = NaN;

        % Q5 K-value
        QI = findcells(RINGData.Lattice,'FamName','Q5');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI,'K');
        FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(1));
        FitParameters.Deltas(N,1) = NaN;

        % Q6 K-value
        QI = findcells(RINGData.Lattice,'FamName','Q6');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI,'K');
        FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(1));
        FitParameters.Deltas(N,1) = NaN;

        Nfit_NoWithSkeqQuads = N;

        ButtonName = questdlg('Skew Quadrupole Fit?','SKEW QUADRUPOLE','Do Not Fit','Fit By Power Supply','Fit All 24 Magnets','Fit By Power Supply');
        switch ButtonName
            case 'Do Not Fit'
                fprintf('   Skewquad family not fit.\n\n');

            case 'Fit By Power Supply'
                fprintf('   40-43 SkewQuad (4)\n');
                
                % Skew quadrupoles are in the sextupoles
                SFI = findcells(RINGData.Lattice,'FamName','SF');
                SDI = findcells(RINGData.Lattice,'FamName','SD');

                for Sector = [2 5 8 11]
                    % 4 Skew quad power supplies.  Each supply seried to all skews in that sector
                    if length(SFI) == 24
                        sflist = [2*(Sector-1)+1 2*(Sector-1)+2];
                        sdlist = [2*(Sector-1)+1 2*(Sector-1)+2];
                        N = N + 1;
                        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,[SFI(sflist) SDI(sdlist)],'s');
                    elseif length(SFI) == 48
                        % Split sextupoles
                        sflist = [4*(Sector-1)+1:4*(Sector-1)+4];
                        sdlist = [4*(Sector-1)+1:4*(Sector-1)+4];
                        N = N + 1;
                        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,[SFI(sflist) SDI(sdlist)],'s');
                    else
                        error('   Error setting the skew quadrupole parameter group.');
                    end
                end
                FitParameters.Values = [FitParameters.Values; zeros(4,1)];
                FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(4,1)];  % automatic delta determination does not work if starting value is 0
               
            case 'Fit All 24 Magnets'
                fprintf('   40-63 SQSF (24)\n');
                fprintf('   64-87 SQSD (24)\n\n');

                % Skew quadrupoles are in the sextupoles
                SFI = findcells(RINGData.Lattice,'FamName','SF');
                SDI = findcells(RINGData.Lattice,'FamName','SD');

                for loop=1:24
                    if length(SFI) == 24
                        N = N + 1;
                        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI(loop),'s');
                    elseif length(SFI) == 48
                        % Split sextupoles
                        N1 = 2*loop-1;
                        N2 = 2*loop;
                        N = N + 1;
                        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI([N1 N2]),'s');
                    else
                        error('   Error setting the skew quadrupole parameter group.');
                    end
                end
                FitParameters.Values = [FitParameters.Values; zeros(24,1)];
                FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(24,1)];  % automatic delta determination does not work if starting value is 0

                for loop=1:24
                    if length(SDI) == 24
                        N = N + 1;
                        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI(loop),'s');
                    elseif length(SDI) == 48
                        % Split sextupoles
                        N1 = 2*loop-1;
                        N2 = 2*loop;
                        N = N + 1;
                        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI([N1 N2]),'s');
                    else
                        error('   Error setting the SQSD parameter group.');
                    end
                end
                FitParameters.Values = [FitParameters.Values; zeros(24,1)];
                FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(24,1)];  % automatic delta determination does not work if starting value is 0

            otherwise
                error('Skew quadrupole');
        end

        
    case 'Fit Individual Magnets'
             
        fprintf('\n   Parameter fits by magnet\n');
        fprintf('      1-24 Q1   (24)\n');
        fprintf('     25-48 Q2   (24)\n');
        fprintf('     49-72 Q3   (24)\n');
        fprintf('     73-96 Q4   (24)\n');
        fprintf('    97-120 Q5   (24)\n');
        fprintf('   121-144 Q6   (24)\n');

        N = 0;     
        
        % Q1 K-values
        QI = findcells(RINGData.Lattice,'FamName','Q1');
        for loop=1:length(QI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI(loop),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(loop));
            FitParameters.Deltas(N,1) = NaN;
        end

        % Q2 K-values
        QI = findcells(RINGData.Lattice,'FamName','Q2');
        for loop=1:length(QI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI(loop),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(loop));
            FitParameters.Deltas(N,1) = NaN;
        end
        
        % Q3 K-values
        QI = findcells(RINGData.Lattice,'FamName','Q3');
        for loop=1:length(QI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI(loop),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(loop));
            FitParameters.Deltas(N,1) = NaN;
        end

        % Q4 K-value
        QI = findcells(RINGData.Lattice,'FamName','Q4');
        for loop=1:length(QI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI(loop),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(loop));
            FitParameters.Deltas(N,1) = NaN;
        end

        % Q5 K-value
        QI = findcells(RINGData.Lattice,'FamName','Q5');
        for loop=1:length(QI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI(loop),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(loop));
            FitParameters.Deltas(N,1) = NaN;
        end

        % Q6 K-value
        QI = findcells(RINGData.Lattice,'FamName','Q6');
        for loop=1:length(QI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QI(loop),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',QI(loop));
            FitParameters.Deltas(N,1) = NaN;
        end

        Nfit_NoWithSkeqQuads = N;
        
        ButtonName = questdlg('Skew Quadrupole Fit?','SKEW QUADRUPOLE','Do Not Fit','Fit By Power Supply','Fit All 24 Magnets','Fit By Power Supply');
        switch ButtonName
            case 'Do Not Fit'
                fprintf('   Skewquad family not fit.\n\n');

            case 'Fit By Power Supply'
                fprintf(' 145-148 SkewQuad (4)\n');
                
                % Skew quadrupoles are in the sextupoles
                SFI = findcells(RINGData.Lattice,'FamName','SF');
                SDI = findcells(RINGData.Lattice,'FamName','SD');

                for Sector = [2 5 8 11]
                    % 4 Skew quad power supplies.  Each supply seried to all skews in that sector
                    if length(SFI) == 24
                        sflist = [2*(Sector-1)+1 2*(Sector-1)+2];
                        sdlist = [2*(Sector-1)+1 2*(Sector-1)+2];
                        N = N + 1;
                        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,[SFI(sflist) SDI(sdlist)],'s');
                    elseif length(SFI) == 48
                        % Split sextupoles
                        sflist = [4*(Sector-1)+1:4*(Sector-1)+4];
                        sdlist = [4*(Sector-1)+1:4*(Sector-1)+4];
                        N = N + 1;
                        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,[SFI(sflist) SDI(sdlist)],'s');
                    else
                        error('   Error setting the skew quadrupole parameter group.');
                    end
                end
                FitParameters.Values = [FitParameters.Values; zeros(4,1)];
                FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(4,1)];  % automatic delta determination does not work if starting value is 0
               
            case 'Fit All 24 Magnets'
                fprintf(' 145-168 SQSF (24)\n');
                fprintf(' 169-192 SQSD (24)\n\n');

                % Skew quadrupoles are in the sextupoles
                SFI = findcells(RINGData.Lattice,'FamName','SF');
                for loop=1:24
                    if length(SFI) == 24
                        N = N + 1;
                        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI(loop),'s');
                    elseif length(SFI) == 48
                        % Split sextupoles
                        N1 = 2*loop-1;
                        N2 = 2*loop;
                        N = N + 1;
                        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI([N1 N2]),'s');
                    else
                        error('   Error setting the skew quadrupole parameter group.');
                    end
                end
                FitParameters.Values = [FitParameters.Values; zeros(24,1)];
                FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(24,1)];  % automatic delta determination does not work if starting value is 0

                SDI = findcells(RINGData.Lattice,'FamName','SD');
                for loop=1:24
                    if length(SDI) == 24
                        N = N + 1;
                        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI(loop),'s');
                    elseif length(SDI) == 48
                        % Split sextupoles
                        N1 = 2*loop-1;
                        N2 = 2*loop;
                        N = N + 1;
                        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI([N1 N2]),'s');
                    else
                        error('   Error setting the SQSD parameter group.');
                    end
                end
                FitParameters.Values = [FitParameters.Values; zeros(24,1)];
                FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(24,1)];  % automatic delta determination does not work if starting value is 0

            otherwise
                error('Skew quadrupole');
        end
        
    otherwise
        FitParameters = [];
end




%%%%%%%%%%%%%%%%%%%%%
% Parameter Weights %
%%%%%%%%%%%%%%%%%%%%%

% For each cell of FitParameters.Weight.Value, a rows is added to the A matrix
% Index of the row of A:  FitParameters.Weight.Index{i}
% Value of the weight:    FitParameters.Weight.Value{i} / mean(Mstd)

ModeCell = {'No Parameter Weigths', 'Add Parameter Weights'};
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOFITPARAMETERS','PromptString','Weights?', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [200 100], 'InitialValue', 2);
drawnow;
if OKFlag ~= 1
    ButtonName = 2;  % Default
end
switch ButtonName
    case 1
        fprintf('   No weights\n');
        if isfield(FitParameters, 'Weight')
            FitParameters = rmfield(FitParameters, 'Weight');
        end
        if isfield(FitParameters, 'Cost')
            FitParameters = rmfield(FitParameters, 'Cost');
        end
    case 2
        fprintf('   Weights added to parameter fits\n');
        MeanMstd = mean(LocoMeasData.BPMSTD) / 1000;  % Since LOCO is meters internally
        for ii = 1:length(FitParameters.Values)
            FitParameters.Method.Cost.FitParameters(ii,1) = .01 / MeanMstd;
        end
end


fprintf('\n');


% Starting point for the deltas (automatic delta determination does not work if starting value is 0)
%FitParameters.Deltas = 0.0001 * ones(size(FitParameters.Values));


% RF parameter fit setup (There is a flag to actually do the fit)
if isempty(LocoMeasData.DeltaRF)
    FitParameters.DeltaRF = 500;  % It's good to have something here so that LOCO will compute a model dispersion
else
    FitParameters.DeltaRF = LocoMeasData.DeltaRF;
end


% File check
[BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});


% Save
save(FileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');


