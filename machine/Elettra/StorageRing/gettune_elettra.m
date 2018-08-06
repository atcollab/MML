function [Tune, tout, DataTime, ErrorFlag] = gettunes_pls(FamilyName, Field, DeviceList, t, Freq0)
%  PLS Storage Ring Tune Measurement
%
% | Higher Fractional Tune, usually Horizontal |
% |                                            | = gettune(Fundamental Frequency {1.0708e+06 MHz});
% |  Lower Fractional Tune, usually Vertical   |
%
%
%  Fundamental = 1.0708e+06 MHz (approximately) = 500.0845 MHz / 468 bunchs
%  In the data base:     Tune X = (in database)
%                        Tune Y = (in database)        
%                        Tune H = (in database) = harmonic number
%
%  Fractional Tune = (Tune X - harmonic number * Fundamental)/Fundamental
%

% Input scheme for a special function
% gettune(FamilyName, Field, DeviceList, t)
%


tout = [];
DataTime = [];
ErrorFlag = 0;


if nargin < 5
    Freq0 = [];
end
if nargin >= 1 & nargin < 5
    if isnumeric(FamilyName)
        Freq0 = FamilyName;
    end
end

if isempty(Freq0)
	% Freq0 = 1.0708e+06;
    RFam = getam('RF','Hardware');
    Freq0 = RFam / 468;
end


TuneX = getpv('TUNE_Y');
TuneY = getpv('TUNE_X');
TuneH = 0;


Tune = [TuneX/Freq0 - TuneH
        TuneY/Freq0 - TuneH];
