function [Tune, tout, DataTime, ErrorFlag] = gettune_als(FamilyName, Field, DeviceList, t, Freq0)
%  ALS Storage Ring Tune Measurement
%
% | Higher Fractional Tune, usually Horizontal |
% |                                            | = gettune(Fundamental Frequency {1.53336 MHz});
% |  Lower Fractional Tune, usually Vertical   |
%
%
%  Fundamental = 1.523336 MHz (approximately) = 499.65415 MHz (from Stanford Timer)/328 bunchs
%  In the data base:     Tune X = (in database)
%                        Tune Y = (in database)        
%                        Tune H = (in database) = harmonic number = 95 (approximately)
%
%  Fractional Tune = (Tune X - harmonic number * Fundamental)/Fundamental
%

% Input scheme for a special function
% gettune(FamilyName, Field, DeviceList, t)   % Fundamental Frequency {1.53336 MHz});
%


tout = [];
DataTime = [];
ErrorFlag = 0;

if 0
    % Use spectrum analyzer & labview
    
    if nargin < 5
        Freq0 = [];
    end
    if nargin >= 1 && nargin < 5
        if isnumeric(FamilyName)
            Freq0 = FamilyName;
        end
    end
    
    if isempty(Freq0)
        % Freq0 = 1.53336e6;
        [RFsp, RFam] = getrf('Hardware');
        Freq0 = RFam / 328;
    end
    
    TuneX = getpv('SR01C___TUNE_X_AC00');
    TuneY = getpv('SR01C___TUNE_Y_AC00');
    TuneH = getpv('SR01C___TUNE_H_AC00');
    
    Tune = [TuneX/Freq0 - TuneH
            TuneY/Freq0 - TuneH];
else
    % The following channels are written by plot_injection_dd3_data and use
    % a libera BPM and the trasients due to the storage ring injection
    % bumps (the trigger is derived from the storage ring SEK, so both the
    % bump trigger and the SEK trigger need to be enabled).
    Tune(1,1) = getpv('Topoff_nux_AM')-floor(getpv('Topoff_nux_AM'));
    Tune(2,1) = getpv('Topoff_nuy_AM')-floor(getpv('Topoff_nuy_AM'));
end


