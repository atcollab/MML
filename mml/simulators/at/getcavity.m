function [CavityState, PassMethod, ATCavityIndex, RF, HarmonicNumber] = getcavity(THERING)
%GETCAVITY - Returns the RF cavity state ('On' / 'Off')
%  [CavityState, PassMethod, ATCavityIndex, RF, HarmonicNumber] = getcavity(THERING)
%
%  OUTPUTS
%  1. CavityState
%  2. PassMethod
%  3. ATCavityIndex - AT Index of the RF cavities
%  4. RF - RF frequency [Hz]
%  5. HarmonicNumber - Harmonic number
%
%  See also setcavity, setradiation

%  Written by Greg Portmann

if nargin < 1
    global THERING
end

ATCavityIndex = findcells(THERING, 'Frequency');

CavityState = '';
PassMethod = '';
RF = [];

if isempty(ATCavityIndex)
    %disp('   No cavities were found in the lattice');
    if nargout >= 4
        % This is a MML function
        try
            [HarmonicNumber, RF] = getharmonicnumber;
        catch
            HarmonicNumber = [];
            RF = [];
        end
    end
    return
end

ATCavityIndex =ATCavityIndex(:)';
for ii = ATCavityIndex(:)'
    if strcmpi(THERING{ii}.PassMethod, 'DriftPass') || strcmpi(THERING{ii}.PassMethod, 'IdentityPass')
        CavityState = strvcat(CavityState,'Off');
    else
        CavityState = strvcat(CavityState,'On');
    end
    PassMethod = strvcat(PassMethod, THERING{ii}.PassMethod);
    RF =  [RF; THERING{ii}.Frequency];
end

ATCavityIndex = ATCavityIndex(:);

if nargout >= 5
    if isfield(THERING{ATCavityIndex(1)}, 'HarmonicNumber')
        HarmonicNumber = THERING{ATCavityIndex(1)}.HarmNumber;
    else
        HarmonicNumber = [];
    end
end


