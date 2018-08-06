function [DeltaRF, EnergyChange, meanHCM3456] = analcm(HCMspIn, VCMspIn)
%ANALCM - Compute the mean of the arc sector correctors and an estimated
%         RF frequency change to bring the mean to zero after the next
%         global orbit correction.
%
%  [DeltaRF, EnergyChange, meanHCM3456] = analcm(HCMsp {getsp('HCM')}, VCMsp {getsp('VCM')})
%
%  RF Freq / mean(arc HCMs) =  -.0012 MHz / amps for 1.9 GeV
%  RF Freq / mean(arc HCMs) =  -.0015 MHz / amps for 1.5 GeV
%
%  meanHCM3456 is the average value of arc-section HCMs, and is used by findrf2 to choose an appropriate RF frequency
%
%  For a "good" corrector magnet pattern:
%		The horizontal correctors are below +/- 2A
%		The straight section vertical correctors are below +/- 2A
%		The arc section vertical correctors are below +/- 5A
%		There are no obvious local distortions around the ring
%  Also, remember that the VCSFs and VCMs have opposite polarity,
%		and that two of the horizontal correctors are used for a chicane bump in SR11
%
%  Note: Skew quadrupole power supplies have been scaled by .4
%
%  Also see findrf, findrf2, rmdisp, plotcm


if nargin < 1
    HCMsp = getam('HCM', getcmlist('HCM','1 2 3 4 5 6 7 8'));
    VCMsp = getam('VCM', getcmlist('VCM','1 2 3 4 5 6 7 8'));
    CreatedDateStr = datestr(clock,0);
else
    if isstr(HCMspIn)
        HCMsp = getdata('HCM', getcmlist('HCM','1 2 3 4 5 6 7 8'), 'Field', 'Monitor', 'Struct');
        VCMsp = getdata('VCM', getcmlist('VCM','1 2 3 4 5 6 7 8'), 'Field', 'Monitor', 'Struct');
        CreatedDateStr =  datestr(HCMsp.TimeStamp,0);
        HCMsp = HCMsp.Data;
        VCMsp = VCMsp.Data;
    else
        HCMsp = HCMspIn;
        if nargin == 2
            VCMsp = VCMspIn;
        else
            VCMsp = getam('VCM', getcmlist('VCM','1 2 3 4 5 6 7 8'));
        end
    end
end


GeV = getenergy;

CMList = family2dev('HCM',0);
i = findrowindex(getcmlist('HCM','9 10'), CMList);
CMList(i,:) = [];
CMListTotal = [1 1;CMList; 12 8];
iHCM12345678 = findrowindex(getcmlist('HCM','1 2 3 4 5 6 7 8'), CMListTotal);
iHCM3456     = findrowindex(getcmlist('HCM','3 4 5 6'), CMListTotal);
iHCM1278     = findrowindex(getcmlist('HCM','1 2 7 8'), CMListTotal);

iVCM124578   = findrowindex(getcmlist('VCM','1 2 3 4 5 6 7 8'), CMListTotal);
iVCM45       = findrowindex(getcmlist('VCM','4 5'), CMListTotal);
iVCM1278     = findrowindex(getcmlist('VCM','1 2 7 8'), CMListTotal);

HCMspTotal = zeros(96,1);
VCMspTotal = zeros(96,1);

HCMspTotal(iHCM12345678) = HCMsp;
VCMspTotal(iVCM124578)   = VCMsp;


% HCM [5 3;5 5;5 6;7 4] are weaker (produce about 40% of original strength
% for same current, since they use skew quadrupole coils instead of corrector coils in
% those sextupoles).
% In the old ML there are numbered [4*8+3;4*8+5;4*8+6;6*8+4]
iSkew = findrowindex([5 3;5 5;5 6;7 4], CMListTotal);
HCMspTotal(iSkew)   = 0.4 * HCMspTotal(iSkew);

meanHCM3456 = mean(HCMspTotal(iHCM3456));


% Compute the energy change due to the correctors  (Note: the sign convention of a corrector is reverse to the bend)
HCMall = getsp('HCM', getcmlist('HCM','1 2 3 4 5 6 7 8'), 'Physics');
[DxHCM, DyHCM] = modeldisp([], 'HCM', getcmlist('HCM','1 2 3 4 5 6 7 8'), 'Physics');
EnergyChange = -1 *sum(HCMall.*DxHCM) / getmcf / getfamilydata('Circumference');


% Delta RF to move the energy change due to the corrector to the RF frequency
DeltaRF = -1 * getrf * getmcf * EnergyChange;                     % Default units of getrf/setrf
DeltaRFPhysics = -1 * getrf('Physics') * getmcf * EnergyChange;   % Must be Hz



figure
clf reset
subplot(2,1,1);
bar(HCMspTotal,'b');
hold on;
HCMspTotal(iHCM1278) = 0;
h=bar(HCMspTotal);
set(h,'FaceColor','r');
ylabel('Hortizontal [Amps]');
title(sprintf('Corrector Magnet Monitors: Mean(HCM(Arc)) = %.3f [Amps]   Energy Change = \\Sigma \\delta_{hcm} \\eta_{hcm} / (-\\alpha L) = %.3e   \\Delta RF = %.4g [Hz]', meanHCM3456, EnergyChange, DeltaRFPhysics));
axis tight
%yaxis([-3 3]);
%text(82,-2.7,'SR11 chicane bump');
hold off

subplot(2,1,2);
bar(1:96, VCMspTotal,'b');
hold on;
VCMspTotal(iVCM1278) = 0;
h = bar(1:96, VCMspTotal);
set(h,'FaceColor','r');
axis tight
xlabel('Corrector Magnet Number')
ylabel('Vertical [Amps]');
title('Red=Arc CMs, Blue=Straight CMs')
hold off

addlabel(1, 0, sprintf('%.1f GeV, %s', GeV, CreatedDateStr), 10);
addlabel(0, 0, '\eta_{hcm} and \alpha come from the model', 10);

orient tall

