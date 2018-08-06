function [dChi2_FitParameter, dChi2_FitParameterGroup, dChi2_BPMGroup, dChi2_CMGroup, Chi2_Nominal] = lococalcdeltachi2(varargin)
%LOCOCALCDeltaCHI2 - Calculate the contribution to chi2 of each fit parameter in LOCO
%
%  [dChi2_FitParameter, dChi2_FitParameterGroup, dChi2_BPMGroup, dChi2_CMGroup, Chi2_Nominal] = lococalcdeltachi2(LOCOFileName, Niter, ParameterCombination)
%  [dChi2_FitParameter, dChi2_FitParameterGroup, dChi2_BPMGroup, dChi2_CMGroup, Chi2_Nominal] = lococalcdeltachi2(LocoModel, LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData, Niter, ParameterCombination)
%      or
%  [DeltaChi2Structure] = lococalcdeltachi2
%
%   INPUTS
%   1. LOCOFileName - LOCO file name
%   2. Niter - LOCO iteration number (0,1, ...) {Default: last iteration}
%   Optional Inputs
%   3. ParameterCombination - Index of a particular combination of parameters to analyze
%                             Only a scale output will be given when using this input.
%                             {Default: Don't use this input.  Analyze all parameters individually.}
%   4. DisplayFlag - 'Display' or 'Plot'     - Plot the data {Default if no outputs exist}
%                    'NoDisplay' or 'NoPlot' - Output only   {Default if outputs exist}
%
%   OUTPUTS
%   1. dChi2_FitParameter      - change of chi^2 with each fit parameter set to initial value
%   2. dChi2_FitParameterGroup - chi^2 of iteration Niter with the fit parameters set to the first iteration
%   3. dChi2_BPMGroup          - chi^2 of iteration Niter with the BPMs fits set to the first iteration
%   4. dChi2_CMGroup           - chi^2 of iteration Niter with the CMs  fits set to the first iteration
%   5. Chi2_Nominal            - chi^2 of iteration Niter
%
%   NOTES
%   1. "fit parameters" refer to just what is in the FitParameter structure
%   2. For one output, a structure will be output
%
%   Chi^2 for all Fit Parameters = dChi2_FitParameterGroup + Chi2_Nominal  (not including BPMs or corrector magnets)
%   Chi^2 for all BPMs           = dChi2_BPMGroup + Chi2_Nominal
%   Chi^2 for all CMs            = dChi2_CMGroup  + Chi2_Nominal

%  Written by Xiaobiao Huang and Greg Portmann


% Parse input
LOCOFileName = '';
Niter = [];
DisplayFlag = '';

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
    end

    load(LOCOFileName);
end

if ~isempty(varargin)
    Niter = varargin{1};
    varargin(1) = [];
end
if ~isempty(varargin)
    ParameterCombination = varargin{1};
    varargin(1) = [];
else
    ParameterCombination = [];
end


% Display flag
if isempty(DisplayFlag)
    if nargout == 0
        DisplayFlag = 'Display';
    else
        DisplayFlag = 'NoDisplay';
    end
end


if strcmpi(DisplayFlag, 'Display') && isempty(ParameterCombination)
    d = .08;
    %h_fig = gcf;
    h_axes = gca;
    %clf reset;
    plot(h_axes, [0 1],[0 1],'w');
    set(h_axes,'XTick',[]);
    set(h_axes,'YTick',[]);
    cla;
    title(h_axes, ' ');
    xlabel(h_axes, ' ');
    ylabel(h_axes, ' ');
    set(h_axes,'box','on');
    text(.03,.6-0*d, sprintf('   Please wait ...'), 'FontSize', 12, 'Units','Normalized');
    text(.03,.6-1*d, sprintf('   Computing \\Delta \\chi^2 verses fit parameter'), 'FontSize', 12, 'Units','Normalized');
    drawnow;

    hbar = waitbar(0, sprintf('Computing \\Delta \\chi^2.  Close waitbar to stop calculation.'));
end


% Iterations
if isempty(Niter)
    Niter = length(FitParameters)-1;
end
if Niter<0 || Niter>(length(FitParameters)-1)
    error('Iteration number must be between 0 and %d', length(FitParameters)-1);
end


% Itererations for difference calculation?
i1 = Niter + 1;
if 1
    % Delta from 0
    i0 = 1;
else
    % Delta from previous iteration
    i0 = Niter-1;
    if i0 < 1
        i0 = 1;
    end
end



% Chi2_Nominal should equal LocoModel.ChiSquare & FitParameters.Chi2.Chi2
%Chi2_0                 = lococalcchi2(LocoModel(i0), LocoMeasData, BPMData(i0), CMData(i0), FitParameters(i0), LocoFlags(i0), RINGData);
Chi2_Nominal            = lococalcchi2(LocoModel(i1), LocoMeasData, BPMData(i1), CMData(i1), FitParameters(i1), LocoFlags(i1), RINGData);
dChi2_BPMGroup          = lococalcchi2(LocoModel(i1), LocoMeasData, BPMData(i0), CMData(i1), FitParameters(i1), LocoFlags(i1), RINGData) - Chi2_Nominal;
dChi2_CMGroup           = lococalcchi2(LocoModel(i1), LocoMeasData, BPMData(i1), CMData(i0), FitParameters(i1), LocoFlags(i1), RINGData) - Chi2_Nominal;
dChi2_FitParameterGroup = lococalcchi2(LocoModel(i1), LocoMeasData, BPMData(i1), CMData(i1), FitParameters(i0), LocoFlags(i1), RINGData) - Chi2_Nominal;


if isempty(ParameterCombination)
    % Compute all fit parameters
    for ii = 1:length(FitParameters(i1).Values)
        if i1 == 1
            dChi2_FitParameter(ii,1) = 0;
        else
            FitParameters_m = FitParameters(i1);
            FitParameters_m.Values(ii) = FitParameters(i0).Values(ii);
            chi2_qii = lococalcchi2(LocoModel(i1),LocoMeasData, BPMData(i1), CMData(i1), FitParameters_m, LocoFlags(i1), RINGData);
            dChi2_FitParameter(ii,1) = chi2_qii - Chi2_Nominal;
        end
        
        if strcmpi(DisplayFlag, 'Display')
            drawnow;
            try
                waitbar(ii/length(FitParameters(i1).Values), hbar);
            catch
                axes(h_axes);
                plot([0 1],[0 1],'w');
                set(gca,'XTick',[]);
                set(gca,'YTick',[]);
                text(.1,.6-1*d, sprintf('   \\Delta \\chi^2 computation stopped!'), 'FontSize', 12, 'Units','Normalized');
                %fprintf('   lococalcchi2 stopped\n');
                break;
                %return;
            end
        end
    end
else
    % Compute 1 delta chi^2 for a particular combination of fit parameters
    FitParameters_m = FitParameters(i1);

    for jj=1:length(ParameterCombination)
        ii = ParameterCombination(jj);
        if ii>0 && ii<=length(FitParameters(i0).Values)
            FitParameters_m.Values(ii) = FitParameters(i0).Values(ii);
        end
    end
    chi2_qii = lococalcchi2(LocoModel(i1),LocoMeasData, BPMData(i1), CMData(i1), FitParameters_m, LocoFlags(i1), RINGData);
    dChi2_FitParameter = chi2_qii - Chi2_Nominal;

    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Chi^2 at iteration %d = %f\n', Niter, Chi2_Nominal);
        fprintf('   Delta Chi^2 = %f\n', dChi2_FitParameter);
    end
end


if strcmpi(DisplayFlag, 'Display') && isempty(ParameterCombination)
    %disp(Chi2_0)
    %disp(['   final chi2 ' num2str(Chi2_Nominal)])
    %disp(['   contribution (all quads) ' num2str(dChi2_FitParameterGroup)])
    %disp(['   contribution (all bpms) ' num2str(dChi2_BPMGroup)])

    try
        close(hbar);
    catch
    end

    axes(h_axes);
    plot(h_axes, 1:length(dChi2_FitParameter), dChi2_FitParameter,'.-');
    %set(h_fig, 'linewidth',1)
    xlabel(h_axes, 'Fit Parameter Index', 'FontSize', 10);
    ylabel(h_axes, '\Delta \chi^2', 'FontSize', 14);
    title(h_axes, '\Delta \chi^2 vs Fit Parameter', 'FontSize', 10);
    %grid  on;
    axis tight;

    %text(.03,.9-0*d, sprintf('   \\chi^2 for iteration %d = %.1f', Niter, Chi2_Nominal),            'FontSize', 10, 'Units','Normalized');
    text(.03,.9-0*d, sprintf('\\Delta \\chi^2(All BPMs) = %.1f',          dChi2_BPMGroup)         , 'FontSize', 10, 'Units','Normalized');
    text(.03,.9-1*d, sprintf('\\Delta \\chi^2(All CMs)  = %.1f',          dChi2_CMGroup)          , 'FontSize', 10, 'Units','Normalized');
    text(.03,.9-2*d, sprintf('\\Delta \\chi^2(All FitParameters) = %.1f', dChi2_FitParameterGroup), 'FontSize', 10, 'Units','Normalized');

    %addlabel(0, 0, sprintf('\\chi^2(0) = %.1f   \\chi^2(%d) = %.1f', Chi2_0, i1, Chi2_Nominal), 10);
    %addlabel(1, 0, sprintf('\\Delta \\chi^2(BPM) = %.1f   \\Delta \\chi^2(FitParameters) = %.1f', dChi2_BPMGroup, dChi2_FitParameterGroup), 10);
end


% Structure outputs
if nargout == 1
    DeltaChi2.FitParameter      = dChi2_FitParameter;
    DeltaChi2.FitParameterGroup = dChi2_FitParameterGroup;
    DeltaChi2.BPMGroup          = dChi2_BPMGroup;
    DeltaChi2.CMGroup           = dChi2_CMGroup;
    %Chi2 = Chi2_Nominal;
    %Chi2_Iter0 = Chi2_0;
    
    clear dChi2_FitParameter
    dChi2_FitParameter = DeltaChi2;
end

