function [HarmonicNumber, RF] = getharmonicnumber
%GETHARMONICNUMBER - Returns the harmonic number from the AT model
%  [HarmonicNumber, RF] = getharmonicnumber
%
%  If there is not a cavity in the model, getharmonicnumber returns
%  HarmonicNumber = getfamilydata('HarmonicNumber')
%  If that is isempty it goes to a table lookup (below).
%  RF frequencies are not exact.
%
%                      HarmonicNumber
%  Machine    Energy      SR /  BR     RF Freq [MHz]
%   ALS        1.9       328 / 125     499.640349
%   ALBA       3.0       448           499.653487
%   ASP        3.0       360 / 217     499.666695
%   Bessy II   1.7       400           499.65
%   CAMD       3.0        92           499.6541
%   CLS        3.0       285           500.004977
%   Diamond    3.0       936           499.654097
%   DSR        0.274      64           178.55
%   ELSA       2.3       274           499.6658
%   Indus2     2.5       191           505.808
%   MLS        0.105      80           499.65
%   LNLS VUV   1.37      148           476.004
%   NSLS II    3.0      1320           499.68
%   TLS        1.5       200           499.65
%   TPS              
%   PLS        2.5       468           500.0008
%   SESAME     2.5       222 /  64      499.654
%   SNS        1.78        1           1.098
%   Spear3     3.0       372           476.300006
%   Soleil     2.7391    416 / 184     352.2
%   SPS        1.2        32           118.0006
%   SSRF       3.5       720           499.650967
%   VUV        0.808       9            52.88
%   X-Ray Ring 2.8        30            52.88
%
%  See also getcavity

%  Written by Greg Portmann

global THERING

ATCavityIndex = findcells(THERING, 'Frequency');

HarmonicNumber = [];
RF = [];

if ~isempty(ATCavityIndex) && isfield(THERING{ATCavityIndex(1)}, 'HarmonicNumber') && isfield(THERING{ATCavityIndex(1)}, 'Frequency')
    HarmonicNumber = THERING{ATCavityIndex(1)}.HarmonicNumber;
    RF = THERING{ATCavityIndex(1)}.Frequency;
else
    MachineName = getfamilydata('Machine');
    if strcmpi(MachineName, 'ALS')
        if isstoragering
            HarmonicNumber = 328;
        else
            HarmonicNumber = 125;
        end
        RF = 499.6403489;
    elseif strcmpi(MachineName, 'ALBA')
        HarmonicNumber = 448;
        RF = 499.653487;
    elseif strcmpi(MachineName, 'ASP')
        if isstoragering
            HarmonicNumber = 360;
        else
            HarmonicNumber = 217;
        end
        RF = 499.666694585;
    elseif strcmpi(MachineName, 'CAMD')
        HarmonicNumber = 92;
        RF = 499.6541;
    elseif strcmpi(MachineName, 'CLS')
        HarmonicNumber = 285;
        RF = 500.004977352;
    elseif strcmpi(MachineName, 'Diamond')
        HarmonicNumber = 936;
        RF = 499.6540967;
    elseif strcmpi(MachineName, 'DSR')
        HarmonicNumber = 72;
        RF = 178.55;
    elseif strcmpi(MachineName, 'ELSA')
        HarmonicNumber = 274;
        RF = 499.6658;
    elseif strcmpi(MachineName, 'Indus2')
        HarmonicNumber = 291;
        RF = 505.808;
    elseif strcmpi(MachineName, 'LNLS')
        HarmonicNumber = 148;
        RF = 476.004;
    elseif strcmpi(MachineName, 'MLS')
        HarmonicNumber = 80;
        RF = 499.65;
    elseif strcmpi(MachineName, 'NSLS2')
        HarmonicNumber = 1320;
        RF = 499.68;
    elseif strcmpi(MachineName, 'TLS')
        HarmonicNumber = 200;
        RF = 499.65;
    elseif strcmpi(MachineName, 'TPS')
        HarmonicNumber = [];
        RF = [];
    elseif strcmpi(MachineName, 'PLS')
        HarmonicNumber = 468;
        RF = 500.0008;
    elseif strcmpi(MachineName, 'SESAME')
        if isstoragering
            HarmonicNumber = 222;
        else
            HarmonicNumber = 64;
        end
        RF = 499.654;
    elseif strcmpi(MachineName, 'SNS')
        HarmonicNumber = 1;
        RF = 1.098;
        %GeV = 1.783272; % GeV
    elseif strcmpi(MachineName, 'Spear3')
        HarmonicNumber = 372;
        RF = 476.300005749;
    elseif strcmpi(MachineName, 'Soleil')
        if isstoragering
            HarmonicNumber = 416;
        else
            HarmonicNumber = 184;
        end
        RF = 352.2;
    elseif strcmpi(MachineName, 'SPS')
        HarmonicNumber = 32;
        RF = 118.0006;
    elseif strcmpi(MachineName, 'SSRF')
        HarmonicNumber = 720;
        RF = 499.650966666;
    elseif strcmpi(MachineName, 'VUV')
        HarmonicNumber = 9;
        RF = 52.88;
    elseif strcmpi(MachineName, 'XRAY')
        HarmonicNumber = 30;
        RF = 52.88;
    end

    % Use the AD harmonic number over this number
    HarmonicNumberAD = getfamilydata('HarmonicNumber');
    if ~isempty(HarmonicNumberAD)
        HarmonicNumber = HarmonicNumberAD;
    end
end

if isempty(HarmonicNumber)
    error('Harmonic number unknown.  Either add an RF cavity to the AT model or add AD.HarmonicNumber to the Middle Layer.');
end


