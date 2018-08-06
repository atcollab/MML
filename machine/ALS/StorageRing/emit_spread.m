function [emittance, energyspread, Xrms31, Xrms72] = emit_spread(Xrms31raw, Xrms72averaw);

% [emittance, energyspread, Xrms31, Xrms72] = function emit_spread(Xrms31, Xrms72)
%
% This function calculates the natural emittance (epsilon_x) and energy spread (dp/p)
% of the ring from the horizontal beamsizes measured at BL3.1 and BL7.2 (in microns)
%
% The values for dispersion and beta at each beamline source point are
% taken from the ring technical specifications found at the ALS homepage

% 2004-08-24 T. Scarvie

Xrms = [];
Xrms31 = [];
Xrms72 = [];
emittance = [];
energyspread = [];
Nave = 20;

% The values as reported for the ALS technical specs are below,
% but don't give very meaningful results.
%betaX31 = 0.35;   % [m]
%betaX72 = 0.90;   % [m]
%etaX31  = 0.03;   % [m]
%etaX72  = 0.07;   % [m]
% The values as discovered via s-matrix (measured 2005-02-08) analysis using diagnostic beamline beam positions as BPMs
betaX31 = 0.3534;   % [m]
betaX72 = 0.8763;   % [m]
etaX31  = 0.0302;   % [m]
etaX72  = 0.0700;   % [m]

% Beamline resolutions in [m], as measured on 9/13/04 physics shift by F.Sannibale and T.Scarvie
res31   = 30.7/1e6;
%res72   = 37.9/1e6;
res72   = 26/1e6; %resolution of 7.2 seems better now that the BPM/pinhole has been moved (10-11-05)

if nargin > 2
	error('  emit_spread.m needs 0 or 2 input arguments!');
end

if nargin < 2
   disp(' ');
%   fprintf('  Averaging BL 3.1 beamsize for %i seconds\n',Nave);
   fprintf('  Using BL 3.1 averaged beamsize channel (not spiricon)\n');
   fprintf('  Using BL 7.2 averaged beamsize channel\n');
   disp(' ');
%   for loop = 1:Nave
%      Xrms(loop) = getspiricon('Xrms')/1e6;
%      pause(1)
%   end
%  Xrms31raw    = mean(Xrms);                %[m]
	Xrms31averaw = getam('bl31:XRMSAve')/1e6; %[m]
	Xrms72raw    = getam('bl72:XRMSNow')/1e6; %[m]
	Xrms72averaw = getam('bl72:XRMSAve')/1e6; %[m]
end

if nargin == 2
   Xrms72averaw = Xrms72averaw/1e6;
   Xrms31raw    = Xrms31raw/1e6;
end

% adjust measured beamsize for resolution of beamlines
%Xrms31ave    = sqrt(Xrms31averaw^2 - res31^2);
Xrms31ave    = Xrms31averaw;
%Xrms72ave = sqrt(Xrms72averaw^2 - res72^2);
Xrms72ave = Xrms72averaw;

Xrms31 = Xrms31ave*1e6; %[microns]
Xrms72 = Xrms72ave*1e6; %[microns]

% Fernando's formula below
emittance = ((Xrms31ave^2 * etaX72^2) - (Xrms72ave^2 * etaX31^2)) / ((betaX31 * etaX72^2) - (betaX72 * etaX31^2));

% Christoph's formula below (gives same result as Fernando's)
%emittance = ((Xrms31ave^2)/betaX31 - ((etaX31^2)/(etaX72^2))*(Xrms72ave^2)/betaX31)/(1-((etaX31^2)/(etaX72^2))*betaX72/betaX31);

% energy spread calculation using averaged beamsizes
energyspread = sqrt(((Xrms72ave^2 * betaX31) - (Xrms31ave^2 * betaX72)) / ((betaX31 * etaX72^2) - (betaX72 * etaX31^2)));

% energy spread calculation using instantaneous beamsizes
%energyspread = sqrt(((Xrms72^2 * betaX31) - (Xrms31ave^2 * betaX72)) / ((betaX31 * etaX72^2) - (betaX72 * etaX31^2)));

% Christoph's formula below (same result as Fernando's)
%energyspread = sqrt(Xrms72ave^2-betaX72*emittance)/etaX72;

if nargout == 0
   fprintf('  Natural emittance = %.2f [nm]\n', emittance*1e9);
   fprintf('  Energy spread     = %.3f %%\n', energyspread*100);
   fprintf('  BL31 Xrms         = %.2f [microns]\n', Xrms31);
   fprintf('  BL72 Xrms         = %.2f [microns]\n', Xrms72);
   fprintf('\n');
end
