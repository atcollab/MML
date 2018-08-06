function [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocoinput(FileName)
%BUILDLOCOFITPARAMETERS - ALS LOCO fit parameters
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

RemoveHBPMDeviceList = [];
RemoveVBPMDeviceList = [];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function only works on the first iteration %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        if all(LocoMeasData.MachineConfig.SF.Setpoint.Data == 0)
            fprintf('   Turning SF family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SFF')';
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end
        if all(LocoMeasData.MachineConfig.SD.Setpoint.Data == 0)
            fprintf('   Turning SD family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SDD')';
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end


        % Skew quadrupoles
        if all(LocoMeasData.MachineConfig.SQSF.Setpoint.Data == 0)
            fprintf('   SQSF family was at zero when the response matrix was taken.\n');
        end
        if all(LocoMeasData.MachineConfig.SQSD.Setpoint.Data == 0)
            fprintf('   SQSD family was at zero when the response matrix was taken.\n');
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
% LocoFlags.Coupling = 'No';
% LocoFlags.Dispersion = 'No';
% LocoFlags.Normalize = 'Yes';
% LocoFlags.ResponseMatrixCalculatorFlag1 = 'Linear';
% LocoFlags.ResponseMatrixCalculatorFlag2 = 'FixedPathLength';
% LocoFlags.CalculateSigma = 'No';
% LocoFlags.SinglePrecision = 'Yes';

% CMData.FitKicks    = 'Yes';
% CMData.FitCoupling = 'No';
% 
% BPMData.FitGains    = 'Yes';
% BPMData.FitCoupling = 'No';


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

ModeCell = {'Fit magnets by power supply','Fit QF, QD, QFA, QDA by magnet & the BEND by power supply','Fit by magnet','No parameter setup'};
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Fit Parameter Selection:','(Not including skew quadrupoles)'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [435 110], 'InitialValue', 1);
drawnow;
if OKFlag ~= 1
    ButtonName = 1;
end

N = 0;
switch ButtonName
    case 1 %'Fit by Power Supply'

        % 59 Quads (48 actual quadrupoles + dipole gradient family)
        fprintf('\n   Parameter fits\n');
        fprintf('    1 -  24 QF   (24)\n');
        fprintf('   25 -  48 QD   (24)\n');
        fprintf('   49 -  52 QFA   (4)\n');
        fprintf('   53 -  58 QDA   (6)\n');
        fprintf('         59 BEND  (1)\n');        
        
        % 24 QF K-values
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFI(loop),'K');
        end
        FitParameters.Values = getcellstruct(RINGData.Lattice,'K',QFI);
        FitParameters.Deltas = NaN * ones(length(QFI),1);

        
        % 24 QD K-values
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QDI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QDI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QDI),1)];

        
        % 4 QFA K-values
        QFAI = findcells(RINGData.Lattice,'FamName','QFA');
        FitParameters.Params{N+1} = mkparamgroup(RINGData.Lattice,QFAI([1:6 9:14 17:22]),'K');
        FitParameters.Params{N+2} = mkparamgroup(RINGData.Lattice,QFAI([7:8]),'K');
        FitParameters.Params{N+3} = mkparamgroup(RINGData.Lattice,QFAI([15:16]),'K');
        FitParameters.Params{N+4} = mkparamgroup(RINGData.Lattice,QFAI([23:24]),'K');
        N = N + 4;
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QFAI([1 7 15 23]))];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(4,1)];

        
        % 6 QDA K-values
        QDAI = findcells(RINGData.Lattice,'FamName','QDA');        
        for loop=1:length(QDAI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QDAI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QDAI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QDAI),1)];
        

        % 33 normal bend magnet K-values fit as a group
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,BENDI,'K');
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',BENDI(1))];
        FitParameters.Deltas = [FitParameters.Deltas; NaN];

        
    case 2 % Fit QF, QD, QFA, QDA by magnet & the BEND by power supply
        
        fprintf('\n   Parameter fits\n');
        fprintf('    1 -  24 QF   (24)\n');
        fprintf('   25 -  48 QD   (24)\n');
        fprintf('   49 -  72 QFA  (24)\n');
        fprintf('   73 -  78 QDA   (6)\n');
        fprintf('         79 BEND  (1)\n');
        
        
        % 24 QF K-values
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFI(loop),'K');
        end
        FitParameters.Values = getcellstruct(RINGData.Lattice,'K',QFI);
        FitParameters.Deltas = NaN * ones(length(QFI),1);

        
        % 24 QD K-values
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QDI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QDI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QDI),1)];

        
        % 24 QFA K-values
        QFAI = findcells(RINGData.Lattice,'FamName','QFA');
        for loop=1:length(QFAI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFAI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QFAI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QFAI),1)];

        
        % 6 QDA K-values
        QDAI = findcells(RINGData.Lattice,'FamName','QDA');        
        for loop=1:length(QDAI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QDAI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QDAI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QDAI),1)];
        

        % 33 normal bend magnet K-values fit as a group
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,BENDI,'K');
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',BENDI(1))];
        FitParameters.Deltas = [FitParameters.Deltas; NaN];

        
    case 3 %'Fit by Magnet'
        
        fprintf('\n   Parameter fits\n');
        fprintf('   1 -  24 QF   (24)\n');
        fprintf('  25 -  48 QD   (24)\n');
        fprintf('  49 -  72 QFA  (24)\n');
        fprintf('  73 -  78 QDA   (6)\n');
        fprintf('  79 - 111 BEND (33)\n');
       
        % 24 QF K-values
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFI(loop),'K');
        end
        FitParameters.Values = getcellstruct(RINGData.Lattice,'K',QFI);
        FitParameters.Deltas = NaN * ones(length(QFI),1);
        
        % 24 QD K-values
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QDI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QDI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QDI),1)];
        
        % 24 QFA K-values
        QFAI = findcells(RINGData.Lattice,'FamName','QFA');
        for loop=1:length(QFAI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFAI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QFAI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QFAI),1)];

        % 6 QDA K-values
        QDAI = findcells(RINGData.Lattice,'FamName','QDA');        
        for loop=1:length(QDAI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QDAI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QDAI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QDAI),1)];
        
        % 33 normal bend magnet K-values
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');        
        for loop=1:length(BENDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,BENDI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',BENDI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(BENDI),1)];
end


% Coupling & skew quadrupole fits
%if N
ModeCell = {'Fit By Power Supply', 'Fit All SQSF & SQSD Magnets (48)', 'Fit All QF, SQSF, & SQSD Magnets (72)', 'Fit Rolls at Quadrupoles & BEND; and Skews & K at Sextupoles', 'Do Not Fit Coupling Terms'};
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Skew Quadrupole Fits?','Fit Parameter Selection:'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [350 125], 'InitialValue', 1);
if OKFlag ~= 1
    ButtonName = 1;  % Default
end
%ButtonName = questdlg('Skew Quadrupole Fit?','SKEW QUADRUPOLE','Fit By Power Supply','Fit All SQSF & SQSD Magnets (48)','Fit All QF, SQSF, & SQSD Magnets (72)','Do Not Fit','Fit By Power Supply');
switch ButtonName
    case 1 % 'Fit By Power Supply'
        FitSkewQuad = 1;

        % Skew quadrupoles are in the sextupoles
        SFI = findcells(RINGData.Lattice,'FamName','SFF');
        SDI = findcells(RINGData.Lattice,'FamName','SDD');

        % Skew quad power supply locations (Post 5-12-2005)
        sflist = [1 5 6 9 10 11 12 13 14 17 21];
        sdlist = [3 5 6 7  9 10 11 12 13 14 15 19 23];

        fprintf('  %3d - %3d SQSF (11)\n', N+1, N+length(sflist));
        fprintf('  %3d - %3d SQSD (13)\n', N+1+length(sflist), N+length(sflist)+length(sdlist));

        for loop=1:length(sflist)
            if length(SFI) == 24
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI(sflist(loop)),'s');
            elseif length(SFI) == 48
                % Split sextupoles
                N1 = 2*sflist(loop)-1;
                N2 = 2*sflist(loop);
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI([N1 N2]),'s');
            else
                error('   Error setting the SQSF parameter group.');
            end
        end
        %        FitParameters.Values = [FitParameters.Values; zeros(length(sflist),1)];
        if length(SFI)==24
            FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'PolynomA',SFI(sflist),2)];
        else
            FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'PolynomA',SFI(2*sflist),2)];
        end
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(length(sflist),1)];  % automatic delta determination does not work if starting value is 0

        for loop=1:length(sdlist)
            if length(SDI) == 24
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI(sdlist(loop)),'s');
            elseif length(SDI) == 48
                % Split sextupoles
                N1 = 2*sdlist(loop)-1;
                N2 = 2*sdlist(loop);
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI([N1 N2]),'s');
            else
                error('   Error setting the SQSD parameter group.');
            end
        end
        % FitParameters.Values = [FitParameters.Values; zeros(length(sdlist),1)];
        if length(SDI)==24
            FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'PolynomA',SDI(sdlist),2)];
        else
            FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'PolynomA',SDI(2*sdlist),2)];
        end
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(length(sdlist),1)];  % automatic delta determination does not work if starting value is 0

    case 2 % 'Fit All SQSF & SQSD Magnets (48)'
        fprintf('  %3d - %3d SQSF (24)\n', N+1, N+24);
        fprintf('  %3d - %3d SQSD (24)\n', N+1+24, N+24+24);

        FitSkewQuad = 1;

        % Skew quadrupoles are in the sextupoles
        SFI = findcells(RINGData.Lattice,'FamName','SFF');
        SDI = findcells(RINGData.Lattice,'FamName','SDD');

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
                error('   Error setting the SQSF parameter group.');
            end
        end
        FitParameters.Values = [FitParameters.Values; zeros(24,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(24,1)];  % automatic delta determination does not work if starting value is 0

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
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(24,1)];  % automatic delta determination does not work if starting value is 0

    case 3 % 'Fit All QF, SQSF, & SQSD Magnets (72)'
        fprintf('  %3d - %3d SQSF (24)\n', N+1, N+24);
        fprintf('  %3d - %3d SQSD (24)\n', N+1+24, N+24+24);
        fprintf('  %3d - %3d SQQF (24)\n', N+1+48, N+48+24);
        
        FitSkewQuad = 1;

        % Skew quadrupoles are in the sextupoles
        SFI = findcells(RINGData.Lattice,'FamName','SFF');
        SDI = findcells(RINGData.Lattice,'FamName','SDD');
        QFI = findcells(RINGData.Lattice,'FamName','QF');

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
                error('   Error setting the SQSF parameter group.');
            end
        end
        FitParameters.Values = [FitParameters.Values; zeros(24,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(24,1)];  % automatic delta determination does not work if starting value is 0

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
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(24,1)];  % automatic delta determination does not work if starting value is 0
    
        for loop=1:24
            if length(QFI) == 24
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFI(loop),'s');
            elseif length(QFI) == 48
                % Split Quadrupole
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFI([N1 N2]),'s');
            else
                error('   Error setting the SQQF parameter group.');
            end
        end
        FitParameters.Values = [FitParameters.Values; zeros(24,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(24,1)];  % automatic delta determination does not work if starting value is 0
        
    case 4 % Fit rolls at Quads & BEND; K & Skew at SF & SD (Super bends are a separate question)
        FitSkewQuad = 1;
        
        % 'Fit SF & SD Magnets with K (48)'
        fprintf('  %3d - %3d SF K (24)\n', N+1, N+24);
        fprintf('  %3d - %3d SD K (24)\n', N+1+24, N+24+24);
        
        SFI = findcells(RINGData.Lattice,'FamName','SFF');
        SDI = findcells(RINGData.Lattice,'FamName','SDD');
        for loop=1:24
            if length(SFI) == 24
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI(loop),'K');
            elseif length(SFI) == 48
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI([N1 N2]),'K');
            else
                error('   Error setting the SQSF parameter group.');
            end
        end
        FitParameters.Values = [FitParameters.Values; zeros(24,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-3*ones(24,1)];  % automatic delta determination does not work if starting value is 0

        for loop=1:24
            if length(SDI) == 24
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI(loop),'K');
            elseif length(SDI) == 48
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI([N1 N2]),'K');
            else
                error('   Error setting the SQSD parameter group.');
            end
        end
        FitParameters.Values = [FitParameters.Values; zeros(24,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-3*ones(24,1)];  % automatic delta determination does not work if starting value is 0


        % Fit SF & SD Magnets with K (48)
        fprintf('  %3d - %3d SF "KS1" (24)\n', N+1, N+24);
        fprintf('  %3d - %3d SD "KS1" (24)\n', N+1+24, N+24+24);

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
                error('   Error setting the SQSF parameter group.');
            end
        end
        FitParameters.Values = [FitParameters.Values; zeros(24,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(24,1)];  % automatic delta determination does not work if starting value is 0

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
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(24,1)];  % automatic delta determination does not work if starting value is 0

        
        % 24 QF Rolls
        fprintf('  %3d - %3d QF Roll (24)\n', N+1, N+24);
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QFI),1);];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QFI),1)];
        
        % 24 QD K-values
        fprintf('  %3d - %3d QD Roll (24)\n', N+1, N+24);        
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QDI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QDI),1)];

        
        % 24 QFA K-values
        fprintf('  %3d - %3d QFA Roll (24)\n', N+1, N+24);
        QFAI = findcells(RINGData.Lattice,'FamName','QFA');
        for loop=1:length(QFAI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFAI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QFAI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QFAI),1)];

        
        % 6 QDA K-values
        fprintf('  %3d - %3d QFA Roll (24)\n', N+1, N+6);
        QDAI = findcells(RINGData.Lattice,'FamName','QDA');        
        for loop=1:length(QDAI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QDAI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QDAI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QDAI),1)];
        

        % 33 normal bend magnet K-values
        fprintf('  %3d - %3d BEND Roll (33)\n', N+1, N+33);
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');        
        for loop=1:length(BENDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,BENDI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(BENDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(BENDI),1)];
    
    case 5 %'Do Not Fit'
        fprintf('   No coupling fits.\n\n');
        FitSkewQuad = 0;

    otherwise
        fprintf('   No coupling fits.\n\n');
        FitSkewQuad = 0;
end


% Superbend quadrupole fit 
ButtonName = questdlg('Superbend Quad. & Skew Quad. Fit?','SUPERBEND','Fit Quadrupoles at the SuperBends','Do Not Fit','Do Not Fit');
switch ButtonName
    case 'Do Not Fit'
        %fprintf('   Superbend not fit.\n');

    case 'Fit Quadrupoles at the SuperBends'
        
        % Superbend
        BSI = findcells(RINGData.Lattice,'FamName','BS');

        % K - Quadrupole Fit
        fprintf('  %3d - %3d SuperBend Quad Fit (3)\n', N+1, N+3);
        for loop=1:length(BSI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,BSI(loop),'K');
            FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',BSI(loop))];
        end
        FitParameters.Deltas = [FitParameters.Deltas; .05 * ones(length(BSI),1)];  % automatic delta determination does not work if starting value is 0

        % Skew Quadrupole Fit
        fprintf('  %3d - %3d SuperBend Skew Fit (3)\n', N+1, N+3);
        for loop=1:length(BSI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,BSI(loop),'s');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(BSI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(length(BSI),1)];  % automatic delta determination does not work if starting value is 0
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


