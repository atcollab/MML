function locoinitals_83knobs_epu42(FileName)
% function locoinitals_83knobs_epu42(FileName)
%
% This routine sets up all data structures and options for the Matlab version
% of LOCO. It also loads a response matrix (including dispersion and BPM noise
% measurements). Finally it save this data to a .mat file, which can be
% subsequently by locogui. The routine is set up for the ALS and uses 83 fit
% parameters (ALS lattice with Superbends and distributed dispersion). 59 fit
% parameters are gradients (associated with the ALS quadrupole/gradient dipole
% power supplies), 24 are skew gradients (for the 24 skew quadrupoles with
% individual power supplies). I.e. the routine uses an effective model to fit
% the error distribution to allow for an effective correction of lattice errors.
%
% C. Steier, February 2002
%
% Updated May 2003.


% Get an input file name if one does not exist
if nargin < 1
    [FileName, PathName] = uiputfile('*.mat', 'Loco data file name');
    if isempty(FileName) | FileName==0
        return
    end
    FileName = [PathName,FileName];
end



% LOCO INPUTS VARIABLES (for an AT model)


% 1. AT MODEL
% An AT model of the accelerator must be available as THERING

als_loco_3sb_disp_epuskews_epu42

global THERING          % THERING is a global variable created in the lattice file

cavityoff               % Cavity must to off for dispersion function to work properly (and so GLOBVAL is not used).
radiationoff            % speed reasons (maybe also necessary ?)

RINGData.Lattice = THERING;
RINGData.CavityFrequency = 499.64035e+006;
RINGData.CavityHarmNumber = 328;
LocoMeasData.RF = RINGData.CavityFrequency;



% 2. MEASURED DATA STRUCTURE
% LocoMeasData.M          [mm]
% LocoMeasData.BPMSTD     [mm]
% LocoMeasData.DeltaAmps  [Amps] (Optional)
% LocoMeasData.Eta        [mm] 
% LocoMeasData.RF         [Hz]   (Optional)
% LocoMeasData.DeltaRF    [Hz]

olddir = pwd;

if isunix==1
    cd '/home/als/physdata/matlab/srdata/smatrix'
else
    cd '\\Als-filer\physdata\matlab\srdata\smatrix'
end

[SmatFileName, SmatPathName] = uigetfile('*.mat', 'Smatrix data file name');
if isempty(SmatFileName) | SmatFileName==0
    error('You have to select a valid response matrix data file');
end

SmatFileName = [SmatPathName,SmatFileName];

cd(SmatPathName);

load(SmatFileName);

LocoMeasData.M = [Rhplus-Rhminus,Rvplus-Rvminus];                                     % [mm]

if exist('./bpmdata.mat','file')==2
    load 'bpmdata.mat'
    fprintf('Loaded measured BPM noise in %s%s \n',SmatPathName,'bpmdata.mat');
else
    error('BPM noise data file (bpmdata.mat) does not exist on the selected path');
end

LocoMeasData.BPMSTD =  ([std(diff(BPMx')),std(diff(BPMy'))])' % [mm]  

if exist('./smatrfnew.mat','file')==2
    load 'smatrfnew.mat'
    LocoMeasData.DeltaRF = -2*DeltaRFMO*2.3661e3;
    LocoMeasData.Eta = -(Rhplus-Rhminus)*DeltaRFMO;                                % [mm]    
    fprintf('Loaded measured dispersion in %s%s \n',SmatPathName,'smatrfnew.mat');
elseif exist('./etadata','file')==2
    etafile = fopen('etadata','r');
    for loop=1:193
        instr=fgets(etafile);
        if loop == 1
            LocoMeasData.DeltaRF = sscanf(instr,'%g');
        else
            xpos(:,loop-1) = sscanf(instr,'%g %g');
        end    
    end
    fclose(etafile);
    LocoMeasData.Eta = (xpos(2,:)-xpos(1,:))';                                % [mm]
    fprintf('Loaded measured dispersion in %s%s \n',SmatPathName,'etadata');    
else
    error('Dispersion data file (smatrfnew.mat or etadata) does not exist on the selected path');
end

cd(olddir);


% 3. BPM AND CORRECTOR MAGNET STRUCTURES
% FamName and BPMIndex tells the findorbitrespm function which BPMs are needed in the response matrix 
% HBPMIndex/VBPMIndex is the sub-index of BPMIndex which correspond to the measured response matrix
% BPMData.HBPMGain = starting value for the horizontal BPM gains (default: ones)
% BPMData.VBPMGain = starting value for the vertical   BPM gains (default: ones)
% BPMData.BPMCoupling = starting value for the horizontal BPM coupling (default: zeros)
% BPMData.BPMCoupling = starting value for the vertical   BPM coupling (default: zeros)
% BPMData.FitGains    = 'Yes'/'No' to fitting the BPM gain     (set in locogui)
% BPMData.FitCoupling = 'Yes'/'No' to fitting the BPM coupling (set in locogui)
% Note that gains and coupling are used all the time (fit or not!)

BPMData.FitGains    = 'Yes';
BPMData.FitCoupling = 'Yes';

BPMData.FamName = 'BPM';
BPMData.BPMIndex = findcells(THERING, 'FamName', BPMData.FamName);
BPMData.HBPMIndex = 1:1:length(BPMData.BPMIndex);          % Must match the response matrix
BPMData.VBPMIndex = 1:1:length(BPMData.BPMIndex);          % Must match the response matrix
%BPMData.HBPMGoodDataIndex = 1:9:length(BPMData.HBPMIndex);  % Referenced to HBPMIndex 
%BPMData.VBPMGoodDataIndex = 1:9:length(BPMData.VBPMIndex);  % Referenced to VBPMIndex 

BPMData.HBPMGain = 0.9 * ones(size(BPMData.HBPMIndex)); % starting value for the horizontal BPM gains (default: ones)
BPMData.VBPMGain = 0.9 * ones(size(BPMData.VBPMIndex)); % starting value for the vertical   BPM gains (default: ones)

% FamName and HCMIndex/VCMIndex tells the findorbitrespm function which corrector magnets are in the response matrix
% HCMFit/VCMFit is the fit paramater string = "No Fit" -> don't fit this corrector magnet
% CMData.FitKicks = 'Yes'/'No' to fitting the corrector magnet gain (set in locogui)
% CMData.FitCoupling = 'Yes'/'No' to fitting the corrector magnet coupling (set in locogui)
% CMData.HCMKicks = starting value for the horizontal kicks in milliradian
% CMData.VCMKicks = starting value for the vertical   kicks in milliradian
% CMData.HCMCoupling = starting value for the horizontal coupling (default: zeros)
% CMData.VCMCoupling = starting value for the vertical   coupling (default: zeros)
% Note:  The kick strength should match the measured response matrix as best as possible
% Note:  The kicks and Coupling are used all the time (fit or not!)

CMData.FitKicks = 'Yes';
CMData.FitCoupling = 'Yes';
CMData.FitHCMEnergyShift = 'No';
CMData.FitVCMEnergyShift = 'No';

% find all corrector magnets
CMData.FamName  = 'COR';
CMData.HCMIndex = findcells(THERING, 'FamName', CMData.FamName);  % Must match the response matrix

% there are no VCSDs in the ALS
CMData.VCMIndex = findcells(THERING, 'FamName', CMData.FamName);  
CMData.VCMIndex = CMData.VCMIndex([1 3:4 6:9 11:12 14:17 19:20 22:25 27:28 30:33 35:36 ...
        38:41 43:44 46:49 51:52 54:57 59:60 62:65 67:68 70:73 75:76 78:81 ...
        83:84 86:89 91:92 94]);                                    % Must match the response matrix

% approximate horizontal kick strength used
tmp1 = 0.13*ones(length(CMData.HCMIndex),1);            % Must match the response matrix [milliradian] 
tmp1([2 3 4 5 10 11 12 13 18 19 20 21 26 27 28 29 34 35 36 37 42 43 44 45 50 51 52 53 58 59 60 61 ...
        66 67 68 69 74 75 76 77 82 83 84 85 90 91 92 93])=...
    (1.8)*tmp1([2 3 4 5 10 11 12 13 18 19 20 21 26 27 28 29 34 35 36 37 42 43 44 45 50 51 52 53 58 59 60 61 ...
        66 67 68 69 74 75 76 77 82 83 84 85 90 91 92 93]);
CMData.HCMKicks = tmp1; 

% vertically the VCSFs have the opposite polarity sign compared to the VCMs
tmp2 = 0.05*ones(length(CMData.VCMIndex),1);            % Must match the response matrix [milliradian]
tmp2([2 3 8 9 14 15 20 21 26 27 32 33 38 39 44 45 50 51 56 57 62 63 68 69])=...
    (-5.5)*tmp2([2 3 8 9 14 15 20 21 26 27 32 33 38 39 44 45 50 51 56 57 62 63 68 69]);
CMData.VCMKicks = tmp2;            % Must match the response matrix [milliradian]

%CMData.HCMGoodDataIndex = 1:3:length(CMData.HCMIndex);    % Referenced to HCMIndex
%CMData.VCMGoodDataIndex = 1:5:length(CMData.VCMIndex);    % Referenced to VCMIndex



% 4. LOCO DATA (INPUT AND OUTPUT)
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
%       FitParameters.DeltaRF=LocoMeasData.DeltaRF as a starting point for the RF frequency.
    
    
    % 59 quadrupole/dipole gradients
    
    QFI = findcells(THERING,'FamName','QF');
    
    for loop=1:length(QFI)
        FitParameters.Params{loop} = mkparamgroup(THERING,QFI(loop),'K');
    end
    
    offset=length(QFI);
    
    QDI = findcells(THERING,'FamName','QD');
    
    for loop=1:length(QDI)
        FitParameters.Params{loop+offset} = mkparamgroup(THERING,QDI(loop),'K');
    end
 
    offset2=offset+length(QDI);

    QFAI = findcells(THERING,'FamName','QFA');
    
    FitParameters.Params{offset2+1} = mkparamgroup(THERING,QFAI([1:6 9:14 17:22]),'K');
    FitParameters.Params{offset2+2} = mkparamgroup(THERING,QFAI([7:8]),'K');
    FitParameters.Params{offset2+3} = mkparamgroup(THERING,QFAI([15:16]),'K');
    FitParameters.Params{offset2+4} = mkparamgroup(THERING,QFAI([23:24]),'K');
 
    offset3=offset2+4;

    QDAI = findcells(THERING,'FamName','QDA');
    
    for loop=1:length(QDAI)
        FitParameters.Params{loop+offset3} = mkparamgroup(THERING,QDAI(loop),'K');
    end
    
    offset4=offset3+6;

    BENDI = findcells(THERING,'FamName','BEND');
    
    FitParameters.Params{offset4+1} = mkparamgroup(THERING,BENDI,'K');

    offset5 = offset4+1;

    % 24 skew gradients
    
    SFI = findcells(THERING,'FamName','SFF');
    SDI = findcells(THERING,'FamName','SDD');
    
    sflist = [1 3 4 5 6 9 10 11 12 13 17 21];
    sdlist = [3 4 5 6 7 9 10 11 12 15 19 23];
    
    for loop=1:length(sflist)
        FitParameters.Params{offset5+loop} = ...
            mkparamgroup(THERING,SFI((2*sflist(loop)-1):(2*sflist(loop))),'KS1');
    end
    
    for loop=(length(sflist)+1):(length(sflist)+length(sdlist))
        FitParameters.Params{offset5+loop} = ...
            mkparamgroup(THERING,SDI((2*sdlist(loop-length(sflist))-1):(2*sdlist(loop-length(sflist)))),'KS1');
    end
    
    offset6 = offset5+length(sflist)+length(sdlist);
    
    % Get LOCO start values from lattice file
    
    FitParameters.Values(1:offset) = getcellstruct(THERING,'K',QFI);
    FitParameters.Values((offset+1):offset2) = getcellstruct(THERING,'K',QDI);
    FitParameters.Values((offset2+1):(offset2+4)) = ...
	    getcellstruct(THERING,'K',QFAI([1 7 15 23]));
    FitParameters.Values((offset3+1):(offset3+6)) = ...
	    getcellstruct(THERING,'K',QDAI);
    FitParameters.Values(offset4+1) = ...
	    getcellstruct(THERING,'K',BENDI(1));
    
    % Start from 0 skew gradients
    
    FitParameters.Values((offset5+1):offset6) = 0;
    
    % find delta for gradients automatically
    
    FitParameters.Deltas(1:offset5) = NaN; 
    
    % automatic delta determination does not work if starting value is 0
    
    FitParameters.Deltas((offset5+1):offset6) = 0.5e-2; 

    % RF frequency change is known
    
    FitParameters.DeltaRF = LocoMeasData.DeltaRF;     % Starting point for RF frequency
    


% 5. BOOKKEEPING VARIABLES
% There are a number of flags when running loco.  These flags are set in the menu of locogui.
% Here is an explaination of what they do.
%
% A.  Auto-Correct Deltas (LocoFlags.AutoCorrectDelta=('Yes'/'No'))
% Automatical adjust the delta used to compute the response matrix 
% If AutoCorrectDeltaFlag = 'Yes', then the parameter deltas are adjusted to keep 
% the RMS change in the response matrix change equal to 1 micron.  If the rms is within
% a factor of ten, then the delta is corrected but the response matrix is not recomputed.
% Note: if FitParameters.Deltas = NaN and Autocorrect is off, then delta will still be autocorrected once.

    LocoFlags.AutoCorrectDelta='Yes';

% B. OPTIONS FOR CHOOSING SINGULAR VALUES (LocoFlags.SVmethod = 'Rank' or [] or threshold value or index vector)
% if SVmethod is a scalar, then all singular values will be greater than Smax * SVmethod (threshold)
% if SVmethod is empty, then singular values will be choosen manually (graphically)
% if SVmethod is a vector, then that vector corresponds to the index of singular values to use
% if SVmethod is 'Rank', then singular values are removed if a matlab warning for rank tolerance is exceeded

     LocoFlags.SVmethod = 1.0e-6;
    
    % C. Include dispersion as a column of the response matrix (LocoFlags.Dispersion=('Yes'/'No'))
    
    LocoFlags.Dispersion = 'Yes';
    LocoFlags.HorizontalDispersionWeight = 12.5;
    LocoFlags.VerticalDispersionWeight = 12.5;
    
    % D. Use the fully coupled response matrix (LocoFlags.Coupling=('Yes'/'No'))
    
    LocoFlags.Coupling = 'Yes';
    
    % E. Normalize the parameter fit response matrix to the same rms as the model response matrix (LocoFlags.Normalize=('Yes'/'No'))
    %    Note: if the RF frequency is fit, it is always normalized.
    
    LocoFlags.Normalize = 'Yes';
    
    % F. Use linear response matrix calculator (LocoFlags.Linear=('Yes'/'No'))
    
    LocoFlags.Linear = 'Yes';
    LocoFlags.ResponseMatrixCalculatorFlag1 = 'Linear';
    LocoFlags.ResponseMatrixCalculatorFlag2 = 'FixedPathLength';
    
    LocoFlags.SVDDataFileName = [];

    LocoFlags.OutlierFactor = 10;
    

% Save data file here to be used with locogui
feval('save', FileName, 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags'); 
    