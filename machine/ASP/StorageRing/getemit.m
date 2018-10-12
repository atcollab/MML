function gemit
%
% INPUTS
% 1. RING = e.g. THERING, or RINGData.Lattice from LOCO file.

%GLOBVAL.E0 = 2.80e9;

global THERING;

THERING1 = THERING;

%Change the integration method for Ohmi calculation
% BENDINDEX = findcells(THERING1, 'PassMethod', 'BendLinearPass');
% for i = BENDINDEX
%     THERING1{i}.PassMethod = 'BndMPoleSymplectic4RadPass';
%     THERING1{i}.NumIntSteps = 30;
%     if THERING1{i}.K ~= THERING1{i}.PolynomB(2)
%        THERING1{i}.K = THERING1{i}.PolynomB(2); 
%     end
% end
% 
% QUADINDEX = findcells(THERING1, 'PassMethod', 'QuadLinearPass');
% for i = QUADINDEX
%     THERING1{i}.PassMethod = 'StrMPoleSymplectic4RadPass';
%     THERING1{i}.NumIntSteps = 30;
%     if THERING1{i}.K ~= THERING1{i}.PolynomB(2)
%         THERING1{i}.PolynomB(2)= THERING1{i}.K;
%     end
% end
% 
% SEXTINDEX = findcells(THERING1,'PassMethod', 'StrMPoleSymplectic4Pass');
% for i = SEXTINDEX
%     THERING1{i}.PassMethod = 'StrMPoleSymplectic4RadPass';
% end

BENDINDEX = findcells(THERING1, 'PassMethod', 'BndMPoleSymplectic4Pass');
THERING1 = setcellstruct(THERING1,'PassMethod',BENDINDEX, 'BndMPoleSymplectic4RadPass');
THERING1 = setcellstruct(THERING1,'Energy',BENDINDEX, 3e9);

QUADINDEX = findcells(THERING1, 'PassMethod', 'QuadLinearPass');
THERING1 = setcellstruct(THERING1,'PassMethod',QUADINDEX, 'StrMPoleSymplectic4RadPass');
THERING1 = setcellstruct(THERING1,'Energy',QUADINDEX, 3e9);

SEXTINDEX = findcells(THERING1,'PassMethod', 'StrMPoleSymplectic4Pass');
THERING1 = setcellstruct(THERING1,'PassMethod',SEXTINDEX, 'StrMPoleSymplectic4RadPass');
THERING1 = setcellstruct(THERING1,'Energy',SEXTINDEX, 3e9);

RADELEMINDEX = sort([BENDINDEX QUADINDEX SEXTINDEX]);

[ENV, sigP, DL] = ohmienvelope(THERING1, RADELEMINDEX, 1:length(THERING1)+1)
sigmas = cat(2, ENV.Sigma); tilt = cat(2, ENV.Tilt);
spos = findspos(THERING1, 1:length(THERING1)+1);

figure(1);
plot(spos, tilt*180/pi, '.-');
title('Beam Ellipse Rotation Angle [degrees]');
set(gca, 'XLim', [0 spos(end)]);
xlabel('s-position [m]');

figure(2);
plot(spos, sigmas(1, :));
title('Beam Ellipse Principal Axis [m]');
xlabel('s-position [m]'); ylabel('Beam Size [m]');

% Get emittance from sigmax
refpts = 1:length(THERING1)+1;
[TwissData, tune, chrom]  = twissring(THERING1, 0, refpts, 'chrom');
for i = 1:length(refpts)
    betax(i) = TwissData(i).beta(1); etax(i) = TwissData(i).Dispersion(1);
    betay(i) = TwissData(i).beta(2); etay(i) = TwissData(i).Dispersion(2);
end
epsx = (sigmas(1,:).^2 - sigP^2.*etax.^2)./betax;
epsy = (sigmas(2,:).^2 - sigP^2.*etay.^2)./betay;
figure(3);
plot(spos, epsx);
title('Horizontal Emittance vs. s')

figure(4);
plot(spos, epsy);
title('Vertical Emittance vs. s')

clear THERING1;