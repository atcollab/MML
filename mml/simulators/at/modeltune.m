function [FractionalTune, IntegerTune] = modeltune
%MODELTUNE - Returns the model tune (2x1 vector)
%  [FractionalTune, IntegerTune] = modeltune
%
%  See also modelbeta, modeltune, modeldisp, modeltwiss

%  Written by Greg Portmann


global THERING
if isempty(THERING)
    error('Simulator variable is not setup properly.');
end


% Fractional tune (Johan's method)
% NOTE: 1. TUNECHROM takes dp as an arguement and computes optics with findorbit44, m44
%          In order to compute off-frequency tune, use m66 eigenvalue technique
%          Cavity must be on.
%        2. TUNECHROM folds tunes above the .5 integer back to 0-.5, twissring and getnusympmat do not

[CavityState, PassMethod, iCavity] = getcavity;

try
    if ~isempty(CavityState)
        setcavity On;
        m66 = findm66(THERING);

        % Restore the cavity state
        setcavity(PassMethod);

        % Johan's method to resolve above or below half integer
        FractionalTune = getnusympmat(m66);

        %tunex = angle(eig(m66(1:2,1:2)))/(2*pi);
        %tuney = angle(eig(m66(3:4,3:4)))/(2*pi);
        %tunes = angle(eig(m66(5:6,5:6)))/(2*pi);
        %FractionalTune = [tunex(1); tuney(1); tunes(1)];
        %FractionalTune = FractionalTune(DeviceIndex);
    else
        FractionalTune = [NaN;NaN];
    end
catch
    FractionalTune = [NaN;NaN];

    % Restore the cavity state
    setcavity(PassMethod);
end


if any(isnan(FractionalTune))
    %fprintf('   RF cavity missing or findm66 failed, trying findm44 (via twissring).\n');
    [TD, Tune1] = twissring(THERING,0,1:length(THERING)+1);
    FractionalTune = Tune1';
    FractionalTune = rem(FractionalTune,1);
end


% Integer part
if nargout >= 2
    [TD, Tune] = twissring(THERING,0,1:length(THERING)+1);
    Tune = Tune(:);
    IntegerTune = fix(Tune);
end

