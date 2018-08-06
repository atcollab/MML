% optimum trou 50x25 = nbH = 15 pixels nbV = 9 pixels resolution 1pixel H =
% 1nm et 1 pixel V = 0.5 % couplage

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTREE HORIZONTALE EN NOMBRE DE PIXELS
%NbpixelsmesH = 19; % largeur � mi-hauteur
NbpixelsmesH = 7; % largeur rms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTREE VERTICALE EN NOMBRE DE PIXELS
%NbpixelsmesV = 15;  % largeur � mi-hauteur
NbpixelsmesV = 4.5;  % largeur rms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


d = 4.5 % distance source - pinhole
D = 5.5 % distance pinhole - convertisseur

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plan vertical
sigmae = 0 ;
eta = 0 ;
etap = 0 ;
beta = 15.78 ; 
alpha = 0.88 ;
gamma = (1 + alpha)/beta ;

% emission de photon - energie 20 keV ? 0.13 mrad !
yp_siph =0.13e-3 ;
%yp_siph =0
% Grandissement camera 2
TV2 = 12.6e-6 ;

%Smes = 24.3*(D/d)*1e-6
%Smes = NbpixelsmesV * TV2/2.35 % mesure à partir de la largeur à mi-hauteur
Smes = NbpixelsmesV * TV2 % mesure à partir du rms
%Svrai = Smes / (D/d) % S electron si pinhole infiniment petite et pas de
%diffraction
% w = 25e-6 ;% taille pinhole
% Emax = 25e3; % 25 keV
% lambda = 1.24e-6*1/Emax ;
% G = 8.3/12.6 ; Sresoution = 2 * TV2 % camera1 G = 0.6 et 2 pixels de r�solution camera + convertisseur
% Sdiffraction = sqrt(12) * lambda * D / (w * 4 * pi) % diffraction Fraunhofer
% Spinhole = w * (D + d)/d / sqrt(12) % effet g�om�trique du trou pinhole A DISCUTER !
%S = sqrt(Smes*Smes - Sresoution*Sresoution - Sdiffraction*Sdiffraction - Spinhole*Spinhole) ;% S electron en tenant compte des (tous ?) les effets
%S = sqrt(Smes*Smes - Sresoution*Sresoution -  Spinhole*Spinhole) ;% S electron sans diffraction

S = S * ( d/D); % grandissement pinhole
SV = S
S = 24.3e-6*D/d;
a = sigmae*sigmae*(eta*eta*gamma + etap*etap*beta + 2*eta*etap*alpha) + beta * yp_siph*yp_siph;
b = sigmae*sigmae * eta*eta * yp_siph*yp_siph;
c = (S*S / (D*D)) * (beta + 2 * alpha * d + gamma * d *d);
e = (S*S / (D*D)) * ((eta - etap*d)*(eta - etap*d) * sigmae * sigmae + d*d * yp_siph*yp_siph);

eps_z = (c - a + sqrt((c - a).*(c - a) - 4*(b - e)))/2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plan horizontal
sigmae = 1e-3 ;
eta = 0.018 ;
etap = -0.035 ;
beta = 0.37 ;
alpha = 0.038 ;
gamma = (1 + alpha)/beta;

% emission de photon - energie 20 keV ? 0.13 mrad !
yp_siph =0.13e-3 ;
%yp_siph =0
% Grandissement camera 2
TH2 = 11.4e-6 ;

% %Smes = NbpixelsmesH * TH2/2.35 % mesure de largeur à mi-hauteur
% Smes = NbpixelsmesH * TH2 % mesure rms
% %Smes = 24.3*(D/d)*1e-6
% %S = 25e-6
% %Svrai = Smes / (D/d) % S electron si pinhole infiniment petite et pas de %diffraction
% % hypoth�se : 
% w = 50e-6 ;% taille pinhole
% Emax = 25e3 ;% 25 keV
% lambda = 1.24e-6*1/Emax ;
% G = 8.3/12.6 ; Sresoution = 2 * TH2 % camera1 G = 0.6 et 2 pixels de r�solution camera + convertisseur
% %Sdiffraction = sqrt(12) * lambda * D / (w * 4 * pi) % diffraction Fraunhofer
% Spinhole = w * (D + d)/d / sqrt(12) % effet g�om�trique du trou pinhole A DISCUTER !

%S = sqrt(Smes*Smes - Sresoution*Sresoution - Sdiffraction*Sdiffraction - Spinhole*Spinhole) ;% S electron en tenant compte des (tous ?) les effets
%S = sqrt(Smes*Smes - Sresoution*Sresoution - Spinhole*Spinhole) ;
S = 49e-6;
%S = S * ( d/D); % grandissement pinhole
%S = S / 1.5 % effet de la non-linéarité
SH = S
S = 41.4e-6*D/d;
a = sigmae*sigmae*(eta*eta*gamma + etap*etap*beta + 2*eta*etap*alpha) + beta * yp_siph*yp_siph;
b = sigmae*sigmae * eta*eta * yp_siph*yp_siph;
c = (S*S / (D*D)) * (beta + 2 * alpha * d + gamma * d *d);
e = (S*S / (D*D)) * ((eta - etap*d)*(eta - etap*d) * sigmae * sigmae + d*d * yp_siph*yp_siph);

eps_x = (c - a + sqrt((c - a).*(c - a) - 4*(b - e)))/2

K = eps_z / eps_x
%S = [150 100 50 29.7]
%e = [1.0252e-09 4.3767e-10 1.0688e-10 3.7522e-11]

%plot(S,e)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calcul de la nappe synchrotron
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Emax = 55e3 ; % 25 keV
lambda = 1.24e-6*1/Emax ; sigma_teta = 0.18e-3 *(8.5e3/Emax).^(1/3);
Sigma_nappe = (d + D) *sigma_teta; % propagation d'un faisceau d'ouverture angulaire sigma_tata : 
% taille sur le convertisseur en mm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTREE MESURE EN VERTICAL camera 2

NbpixelsmesV_nappe = 322 - 250;  % Largeur � mi-hauteur

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Sigma_nappe_mes = NbpixelsmesV_nappe * TV2/2.35;
Sigma_nappe / Sigma_nappe_mes;