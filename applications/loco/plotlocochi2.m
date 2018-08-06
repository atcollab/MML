function [dchi2quad, chi2_par, chi2_bpm, chi2_cm, chi2_min, chi2_0] = plotlocochi2(varargin)
%PLOTLOCOCHI2 - Calculate the contribution to chi2 of each fit parameter in LOCO
%
%  [dchi2quad, chi2_par, chi2_bpm, chi2_cm, chi2_min, chi2_0] = plotlocochi2(LOCOFileName, Niter, ParameterCombination)
%  [dchi2quad, chi2_par, chi2_bpm, chi2_cm, chi2_min, chi2_0] = plotlocochi2(BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData, Niter, ParameterCombination)
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
%   1. dchi2quad - change of chi^2 if each quadrupole is set to initial value
%   2. chi2_par  - chi^2 of the last  iteration with the fit parameters set to the first iteration
%   3. chi2_bpm  - chi^2 of the last  iteration with the BPMs fits set to the first iteration
%   4. chi2_cm   - chi^2 of the last  iteration with the CMs  fits set to the first iteration
%   5. chi2_min  - chi^2 of the last  iteration
%   6. chi2_0    - chi^2 of the first iteration
%
%   Note: "fit parameters" refer to just what is in the FitParameter structure
%   
%   dChi^2 for all Fit Parameters  = chi2_par - chi2_min  (not including BPMs or corrector magnets)
%   dChi^2 for all BPMs            = chi2_bpm - chi2_min
%   dChi^2 for all CMs             = chi2_cm  - chi2_min


% Start from itereration
i0 = 1;


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

if length(varargin) == 7 || length(varargin) == 8
    BPMData       = varargin{1};
    CMData        = varargin{2};
    LocoMeasData  = varargin{3};
    LocoModel     = varargin{4};
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
    plot([0 1],[0 1],'w'); 
    set(gca,'XTick',[]); 
    set(gca,'YTick',[]); 
    cla; 
    title(' '); xlabel(' '); ylabel(' ');
    set(gca,'box','on');
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

i1 = Niter + 1;


if nargout >= 6
chi2_0   = calclocochi2(LocoModel(i0), LocoMeasData, BPMData(i0), CMData(i0), FitParameters(i0), LocoFlags(i0), RINGData);
end
chi2_bpm = calclocochi2(LocoModel(i1), LocoMeasData, BPMData(i0), CMData(i1), FitParameters(i1), LocoFlags(i1), RINGData);
chi2_cm  = calclocochi2(LocoModel(i1), LocoMeasData, BPMData(i1), CMData(i0), FitParameters(i1), LocoFlags(i1), RINGData);
chi2_par = calclocochi2(LocoModel(i1), LocoMeasData, BPMData(i1), CMData(i1), FitParameters(i0), LocoFlags(i1), RINGData);
chi2_min = calclocochi2(LocoModel(i1), LocoMeasData, BPMData(i1), CMData(i1), FitParameters(i1), LocoFlags(i1), RINGData);


if isempty(ParameterCombination)
    
    % Compute all fit parameters
    for ii = 1:length(FitParameters(i1).Values)
        FitParameters_m = FitParameters(i1);
        FitParameters_m.Values(ii) = FitParameters(i0).Values(ii);
        chi2_qii = calclocochi2(LocoModel(i1),LocoMeasData, BPMData(i1), CMData(i1), FitParameters_m, LocoFlags(i1), RINGData);
        dchi2quad(ii,1) = chi2_qii - chi2_min;

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
                %fprintf('   calclocochi2 stopped\n');
                return;
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
    chi2_qii = calclocochi2(LocoModel(i1),LocoMeasData, BPMData(i1), CMData(i1), FitParameters_m, LocoFlags(i1), RINGData);
    dchi2quad = chi2_qii - chi2_min;

    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Chi^2 at iteration %d = %f\n', Niter, chi2_min);
        fprintf('   Delta Chi^2 = %f\n', dchi2quad);
    end
end


if strcmpi(DisplayFlag, 'Display') && isempty(ParameterCombination)
    %disp(chi2_0)
    %disp(['   final chi2 ' num2str(chi2_min)])
    %disp(['   contribution (all quads) ' num2str(chi2_par - chi2_min)])
    %disp(['   contribution (all bpms) ' num2str(chi2_bpm - chi2_min)])

    try
        close(hbar);
    catch
    end

    axes(h_axes);
    plot(1:length(dchi2quad), dchi2quad,'.-');
    %set(h_fig, 'linewidth',1)
    title('');
    xlabel('Fit Parameter Index', 'FontSize', 10);
    ylabel('\Delta \chi^2', 'FontSize', 14);
    title('\Delta \chi^2 vs Fit Parameter', 'FontSize', 10);
    %grid  on;    
    axis tight;
     
    %text(.03,.9-0*d, sprintf('   \\chi^2 for iteration %d = %.1f', Niter, chi2_min),            'FontSize', 10, 'Units','Normalized');
    text(.03,.9-0*d, sprintf('\\Delta \\chi^2(All BPMs) = %.1f',          chi2_bpm - chi2_min), 'FontSize', 10, 'Units','Normalized');
    text(.03,.9-1*d, sprintf('\\Delta \\chi^2(All CMs)  = %.1f',          chi2_cm  - chi2_min), 'FontSize', 10, 'Units','Normalized');
    text(.03,.9-2*d, sprintf('\\Delta \\chi^2(All FitParameters) = %.1f', chi2_par - chi2_min), 'FontSize', 10, 'Units','Normalized');
        
    %addlabel(0, 0, sprintf('\\chi^2(0) = %.1f   \\chi^2(%d) = %.1f', chi2_0, i1, chi2_min), 10);
    %addlabel(1, 0, sprintf('\\Delta \\chi^2(BPM) = %.1f   \\Delta \\chi^2(FitParameters) = %.1f', chi2_bpm - chi2_min, chi2_par - chi2_min), 10);    
end


