function [Chro, Tune] = modelchro(varargin)
%MODELCHRO - Returns the AT model chromaticity
%  [Chromaticity, Tune] = modelchro(DeltaRF)
%
%  INPUTS
%  1. DeltaRF - Change in RF used to compute the chromaticity [Hz]  {Default: .1 Hz}
%  2. 'Hardware' returns chromaticity in hardware units (Tune/MHz (usually))
%     'Physics'  returns chromaticity in physics  units (Tune/(dp/p))
%
%  OUTPUTS
%  1. Chromaticity vector (2x1)
%  1. Tune vector (2x1)
%
%  NOTES
%  1. This function is orbit dependent (unlike modeltwiss)
%
%  See also getnusympmat, modelbeta, modeltune, modeldisp, modeltwiss

%  Written by Greg Portmann


UnitsFlag = 'Physics';
MCF = [];

% Look if 'struct' or 'numeric' in on the input line
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Physics')
        UnitsFlag = 'Physics';
        varargin(i) = [];
        %if length(varargin) >= i
        %    if isnumeric(varargin{i})
        %        MCF = varargin{i};
        %        varargin(i) = [];
        %    end
        %end
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlag = 'Hardware';
        varargin(i) = [];
        %if length(varargin) >= i
        %    if isnumeric(varargin{i})
        %        MCF = varargin{i};
        %        varargin(i) = [];
        %    end
        %end
    end
end


DeltaRF = [];
if length(varargin) >= 1
    if isnumeric(varargin{1})
        DeltaRF = varargin{1};  % Hz
    end
end
if  isempty(DeltaRF)
    DeltaRF = 1;  % Hz
end


global THERING
if isempty(THERING)
    error('Simulator variable is not setup properly.');
end


[CavityState, PassMethod, iCavity] = getcavity;

if isempty(CavityState)
    % No cavity

    % tunechrom does not take into account the present RF frequency
    [Tune, Chro] = tunechrom(THERING, 0, 'chrom');
    Tune = Tune(:);
    Chro = Chro(:);
    UnitsFlag = 'Physics';
    if strcmpi(UnitsFlag,'Hardware')
        fprintf('   Chromaticity units changed to physics\n');
    end
    return
    %error('The model does not have a cavity, hence the chromaticity cannot be determined.');
else
    % Cavity
    if any(strcmpi(CavityState(1,:),'Off'))
        % Turn on the cavities
        setcavity('On');
    end

    % If the integer tune is needed
    %[TD, Tune] = twissring(THERING,0,1:length(THERING)+1);
    %IntTune = fix(Tune(:));

    % Get tune (Johan's method)
    M66 = findm66(THERING);
    FracTune0 = getnusympmat(M66);
    %Tune = fix(IntTune) + FracTune0;

    % Small change in the RF and remeasure the tune
    RF0 = THERING{iCavity(1)}.Frequency;
    for i = 1:length(iCavity)
        THERING{iCavity(i)}.Frequency = RF0 + DeltaRF;
    end

    % Get tune (Johan's method)
    M66 = findm66(THERING);
    FracTune1 = getnusympmat(M66);

    % Reset the RF
    for i = 1:length(iCavity)
        THERING{iCavity(i)}.Frequency = RF0;
    end

    % Chromaticity in hardware units (DeltaTune / DeltaRF)
    DeltaRF = physics2hw('RF', 'Setpoint', DeltaRF, [1 1], 'Model');
    Chro = (FracTune1 - FracTune0) / DeltaRF;

    if strcmpi(UnitsFlag, 'Physics')
        % Change to Physics units
        MCF = mcf(THERING);
        RF0 = RF0 *1e-6;  % MHz
        Chro = (-MCF * RF0) * Chro;
    end

    % if strcmpi(UnitsFlag,'Hardware')
    %     % Change to Hardware units
    %     MCF = mcf(THERING);
    %     CavityFrequency  = THERING{iCavity(1)}.Frequency;
    %     Chro = Chro / (-MCF * RF0);
    % end

    % Reset cavity PassMethod
    setcavity(PassMethod);
end

