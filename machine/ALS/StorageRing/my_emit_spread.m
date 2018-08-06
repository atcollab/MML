function [emittance, energyspread, Xrms31, my_Xrms72, Yrms31, my_Yrms72] = emit_spread(Xrms31raw, Xrms72averaw);

% [emittance, energyspread, Xrms31, Xrms72] = function emit_spread(Xrms31, Xrms72)
%
% This function calculates the natural emittance (epsilon_x) and energy spread (dp/p)
% of the ring from the horizontal beamsizes measured at BL3.1 and BL7.2 (in microns)
%
% The values for dispersion and beta at each beamline source point are
% taken from the ring technical specifications found at the ALS homepage

% 2004-08-24 T. Scarvie

Xrms31 = [];
Xrms72 = [];
Yrms31 = [];
Yrms72 = [];

emittance = [];
energyspread = [];
Nave = 20;

% The values as reported for the ALS technical specs are below,
% but don't give very meaningful results.
%betaX31 = 0.35;   % [m]
%betaX72 = 0.90;   % [m]
%etaX31  = 0.03;   % [m]
%etaX72  = 0.07;   % [m]
betaX31 = 0.35;   % [m]
betaX72 = 0.87;   % [m]
etaX31  = 0.02;   % [m]
etaX72  = 0.08;   % [m]

betaY31 = 22.5;   % [m]
betaY72 = 1.35;   % [m]
etaY31  = 0.0;    % [m]
etaY72  = 0.0;    % [m]



% Beamline resolutions in [m], as measured on 9/13/04 physics shift by F.Sannibale and T.Scarvie
res31   = 30.7/1e6;
res72   = 37.9/1e6;

if nargin > 2
	error('  emit_spread.m needs 0 or 2 input arguments!');
end

if nargin < 2
   disp(' ');
   fprintf('  Averaging BL 3.1 beamsize for %i seconds\n',Nave);
   fprintf('  Using BL 7.2 averaged beamsize channel\n');
   disp(' ');
   for loop = 1:Nave
      Xrms(loop) = getspiricon('Xrms')/1e6;
      Yrms(loop) = getspiricon('Yrms')/1e6;
      pause(1)
   end
	Xrms31raw    = mean(Xrms);                %[m]
	Xrms72raw    = getam('bl72:XRMSNow')/1e6; %[m]
	Xrms72averaw = getam('bl72:XRMSAve')/1e6; %[m]
	Yrms31raw    = mean(Yrms);                %[m]
	Yrms72raw    = getam('bl72:YRMSNow')/1e6; %[m]
	Yrms72averaw = getam('bl72:YRMSAve')/1e6; %[m]
   
end

if nargin == 2
   Xrms72averaw = Xrms72averaw/1e6;
   Xrms31raw    = Xrms31raw/1e6;
end

% adjust measured beamsize for resolution of beamlines
Xrms31ave    = sqrt(Xrms31raw^2 - res31^2);
Yrms31ave    = sqrt(Yrms31raw^2 - res31^2);

%Xrms72    = sqrt(Xrms72raw^2 - res72^2);
Xrms72ave = sqrt(Xrms72averaw^2 - res72^2);
Yrms72ave = sqrt(Yrms72averaw^2 - res72^2);

Xrms31 = Xrms31ave*1e6; %[microns]
Xrms72 = Xrms72ave*1e6; %[microns]

Yrms31 = Yrms31ave*1e6; %[microns]
Yrms72 = Yrms72ave*1e6; %[microns]


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

my_Xrms72=Xrms72averaw*1e6;
my_Yrms72=Yrms72averaw*1e6;

if nargout == 0
   fprintf('  Natural emittance = %.2f [nm]\n', emittance*1e9);
   fprintf('  Energy spread     = %.3f %%\n', energyspread*100);
   fprintf('  BL31 Xrms         = %.2f [microns]\n', Xrms31);
   fprintf('  BL72 Xrms         = %.2f [microns]\n', my_Xrms72);
   fprintf('  BL31 Yrms         = %.2f [microns]\n', Yrms31);
   fprintf('  BL72 Yrms         = %.2f [microns]\n', my_Yrms72);  
   fprintf('\n');
end
