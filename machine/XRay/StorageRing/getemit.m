function gemit
%
% INPUTS
% 1. RING = e.g. THERING, or RINGData.Lattice from LOCO file.

%GLOBVAL.E0 = 2.80e9;

global THERING;

THERING1 = THERING;

%Change the integration method for Ohmi calculation
BENDINDEX = findcells(THERING1, 'PassMethod', 'BendLinearPass');
for i = BENDINDEX
    THERING1{i}.PassMethod = 'BndMPoleSymplectic4RadPass';
    THERING1{i}.NumIntSteps = 30;
    if THERING1{i}.K ~= THERING1{i}.PolynomB(2)
       THERING1{i}.K = THERING1{i}.PolynomB(2); 
    end
end

QUADINDEX = findcells(THERING1, 'PassMethod', 'QuadLinearPass');
for i = QUADINDEX
    THERING1{i}.PassMethod = 'StrMPoleSymplectic4RadPass';
    THERING1{i}.NumIntSteps = 30;
    if THERING1{i}.K ~= THERING1{i}.PolynomB(2)
        THERING1{i}.PolynomB(2)= THERING1{i}.K;
    end
end

SEXTINDEX = findcells(THERING1,'PassMethod', 'StrMPoleSymplectic4Pass');
for i = SEXTINDEX
    THERING1{i}.PassMethod = 'StrMPoleSymplectic4RadPass';
end

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
end
epsx = (sigmas(1,:).^2 - sigP^2.*etax.^2)./betax;
figure(3);
plot(spos, epsx);
title('Horizontal Emittance vs. s')

clear THERING1;