function pinhole_computation_dec06_vRdS_25x10(varargin)
% mesure avec XC56 et doublet 50 + 200 mm
% INPUT
% 'ImageAnalyser'  on traite directement les rms donnÃ© par l'imageanalyser
% 'Analyse' on refait tou le traitement
%
% OUTPUT
% Courant dans le premier QT  emittance H (nm) et V (e-11m) Couplage


% 4356 mm
% 5695 mm 
 


if nargin < 1
    error('pinhole computation input required');
    return
end

if strcmpi(varargin,'ImageAnalyser')
    Calcul = 1;
elseif strcmpi(varargin,'Analyse')
    Calcul = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gamma = 1  ;  NonLin = 1./sqrt(gamma) ;   % NonLin = 1./sqrt(0.45)   %  NonLin = 1. % Facteur gamma de la camera
NBPIXEL = 1.7  ;               % nb de pixel rÃ©solution camera
NBCONVCRENEAU = sqrt(12) ;         %sqrt(12) % 3 ; % facteur de dÃ©convolution du crÃ©neau (alternative : 3)
yp_siph =0.13e-3 ;          % emission de photon - energie 20 keV ? 0.13 mrad !
TV2 = 7.5e-6/2.60 ;            % TV2  en Âµm/pixel sur le plan convertisseur   7.5e-6/2.60
TH2 = 7.5e-6/2.60 ;             %TH2 = 11.4e-6 % 13.38e-6 ;  % Grandissement H camera 2
wV = 10e-6 ;                % taille pinhole Verticale
wH = 25e-6 ;                % taille pinhole Horizontale
d = 4.356 %4.5 ;                   % distance source - pinhole
D = 5.695%5.5 ;                   % distance pinhole - convertisseur
offsetQT1 = -0.2;
offsetK = 0.55;
couleur = 'ro-';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%% manip nuit du 6 décembre TROU 25 x 10 µm
% bumps H et V
S1 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_16-36-51_BUMP+100V.mat')
S2 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_16-36-19_BUMP+50V.mat')
S3 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_16-35-12_BUMP-100V.mat')
S4 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_16-34-25_BUMP-50V.mat')
S5 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_16-32-20_BUMP+100H.mat')
S6 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_16-31-40_BUMP+50H.mat')
S7 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_16-30-21_BUMP-100H.mat')
S8 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_16-29-15_BUMP-50H.mat')
S9 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_15-34-59.mat')

%
% S1 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_05-28-10trou25x10mic_att_5210_52_37mA.mat')
% S2 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_05-19-06-trou25x10mic_att_5190-30_50mA.mat')
% S3 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_04-36-30-trou50x25mic_att_5693-10_21mA-800pixmax.mat')
% S4 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_04-08-16_trou25_10mic_att_0_10_33mA-300pixmax.mat')
% S5 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/XC56_manip_2006_12_6/Pinhole_2006-12-06_02-32-39_10x25.mat')



sigma_x = ones(15,2)*0; sigma_z = ones(15,2)*0 ; Max_image_brute = []
K_vect = [];IQT = [];eps_x_vect = [] ; SIGMA_Z = [] ; ATT = [];
% fprintf('Iqt1---EmitX(nm)---EmitZ 10-2nm----K(10-2)---SigX(Âµm) SigZ(Âµm) \n ')
%fprintf('---Idcct---EmitX(nm)---EmitZ 10-2nm----K(10-2)------PixMax \n ')
fprintf('---Attenuateur--Max Pixel---sigma x----sigma z (pixels) \n ')
x = [5115 5178 5256 5880 6661 12903 20706]; % recherche de l'énergie pic en fonction de la valeur atténuateur
y = [24.55 28.5 31.5 45.9 54.1 80.7 95];
xx = 5000:1:21000;
yy = spline(x,y,xx);

for s = 9:9
    if s == 1 S = S1 ; elseif s == 2  S = S2; elseif s == 3 S = S3; elseif s == 4 S = S4; 
    elseif s == 5 S = S5; elseif s == 6 S = S6; elseif s == 7 S = S7; elseif s == 8 S = S8; 
    elseif s == 9 S = S9; elseif s == 10 S = S10; elseif s == 11 S = S11; elseif s == 12 S = S12; 
    elseif s == 13 S = S13; elseif s == 14 S = S14; elseif s == 15 S = S15 ; 
    end

    UserROIOriginX =  230%230  ;  %150 
    UserROIOriginY = 230%166;      %  150; % 
    UserROIWidth = 250%170 ;  %250; % 
    UserROIHeight = 170 ;  %300; % 
    %image_matrice = S.toto.value; % cas des images JCD
    image_matrice = S.rep.image;
    figure(3)
    image(image_matrice,'CDataMapping','scaled','Parent',gca)
    image_ROI = image_matrice(UserROIOriginY:UserROIOriginY + UserROIHeight , UserROIOriginX:UserROIOriginX + UserROIWidth);
          figure(1);
           image(image_ROI,'CDataMapping','scaled','Parent',gca)
    image_ROI = double(image_ROI);
    Max_ROI = max(max(image_ROI));
    %%%%%%%%%%%%% projection image brute
    proj_x = sum(image_ROI(:,:));
    proj_z = sum(image_ROI(:,:)');
    %%%%%%%%%%%%%%% comparaison des sigmas
    figure(4) ; hold on
    plot(proj_x,'r-') ; hold on ;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(5) ; hold on
    plot(proj_z,'b-') ; hold on ;
    
    Max_image_brute = [Max_image_brute Max_ROI];
    Idcct = S.rep.current;
    Att = S.rep.attenuateur;
    if Att>4999
        I = find(xx==Att);
        EkeV = yy(I)
    else
        EkeV = 20. % 20 keV sans Atténuateur
    end
    
    if Calcul == 0
        figure(4); hold on
        x0 = [8 80 max(proj_x) max(proj_x)/7 ]; %x0 = [8 200 max(proj_x) max(proj_x)/7 ]; % x0 = [sigma,centre,intensitï¿½,constante];x0 = [40 600 50];
        xdata = 1:size(proj_x,2);
        res = proj_x;
        [ac] = lsqcurvefit(@myfun_gaussienne_offset,x0,xdata,res);
        sigma_fit(s,1) = ac(1);
        sigma_z = sigma_fit(s,1);
        xdatap = 1:0.1:size(proj_x,2);
        F=ac(4) + ac(3)*exp(-(xdatap-ac(2)).*(xdatap-ac(2))/(2*ac(1)*ac(1))); %
        hold on ; plot(xdatap,F,'k');

        %%%
     
        x0 = [22 90 max(proj_z) max(proj_z)/6  ]; %x0 = [22 170 max(proj_z) max(proj_z)/6  ]; % x0 = [sigma,centre,intensitï¿½,constante];x0 = [40 600 50];
        xdata = 1:size(proj_z,2);
        res = proj_z;
        [ac] = lsqcurvefit(@myfun_gaussienne_offset,x0,xdata,res);
        sigma_fit(s,2) = ac(1);
        sigma_x = sigma_fit(s,2);
        xdatap = 1:0.1:size(proj_z,2);
        F=ac(4) + ac(3)*exp(-(xdatap-ac(2)).*(xdatap-ac(2))/(2*ac(1)*ac(1))); %
        figure(5)
        hold on ; plot(xdatap,F,'k');
        %%%%

    elseif Calcul == 1  % cas oÃ¹ on prend directement les rÃ©sultats rms de l'image analyser
        if S.rep.gamma ~= 1
            disp('gamma camÃ©ra n''est pas Ã  sa valeur correcte') % test sur la valeur de gamma
            return
        else
            sigma_x = S.rep.sigmaz ;   % Ã©change des axes
            sigma_z = S.rep.sigmax;
        end
    end
    sigmae = 0 ;
    eta = 0 ;
    etap = 0 ;
    beta = 15.78 ;
    alpha = 0.88 ;
    gammaPM = (1 + alpha)/beta ;
    eps_z = fun(EkeV,sigma_z,TV2,wV,yp_siph,d,D,NBPIXEL,NBCONVCRENEAU,NonLin,sigmae,eta,etap,beta,alpha,gammaPM);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plan horizontal
    sigmae = 1e-3 ;
    eta = 0.018 ;
    etap = -0.035 ;
    beta = 0.37 ;
    alpha = 0.038 ;
    gammaPM = (1 + alpha)/beta;
    eps_x = fun(EkeV,sigma_x,TH2,wH,yp_siph,d,D,NBPIXEL,NBCONVCRENEAU,NonLin,sigmae,eta,etap,beta,alpha,gammaPM);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    K = eps_z / eps_x;
    eps_x_vect = [eps_x_vect eps_x];
    K_vect = [K_vect K];
    %if Calcul==0
        
      %  IQT = [IQT Iqt1];
    %else
        Iqt1 = S.rep.QT1;
        IQT = [IQT Iqt1];
   % end
    %S = [150 100 50 29.7]
    %e = [1.0252e-09 4.3767e-10 1.0688e-10 3.7522e-11]
    % Couplage (%)---SigmaX source (Âµm) SigmaZ source (Âµm)
    %plot(S,e)

    RES = [Idcct eps_x*1e9 eps_z*1e11 K*100 Max_ROI]; % RES = [Iqt1 eps_x*1e9 eps_z*1e11 K*100 SH*1e6 SV*1e6];
    fprintf('%8.2f  %8.2f  %10.2f  %10.2f  %10.2f \n',RES ); %fprintf('%8.2f  %8.2f  %8.2f  %8.2f  %8.2f  %8.2f \n',RES );
    SIGMA_Z = [SIGMA_Z sigma_z];
    ATT = [ATT Att];
    RES = [Att Max_ROI sigma_x sigma_z];
    fprintf('%8.2f  %8.2f  %10.2f  %10.2f  \n',RES );
end

figure(9)
plot(ATT,SIGMA_Z)
xlabel('Position de l''atténuateur en nb pas')
ylabel('Sigma Z')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IQTtheor = [-7 -6 -3 0 3 6 7];
IQTtheor = -7:1:7;
Ktheor = [1.94 1.43 0.52 0 0.52 1.43 1.94 ];
Ktheor = [1.94 1.44 1.0 0.64 0.36 0.16 0.04 0 0.04 0.16 0.36 0.64 1.0 1.44 1.94];
figure(7);plot(IQT,K_vect*100,couleur)
hold on
plot(IQTtheor,Ktheor,'bo-')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fit thÃ©orie / mesure
IQTtheorb = IQTtheor + offsetQT1 ;
Ktheorb = Ktheor + offsetK ;
hold on
plot(IQTtheorb,Ktheorb,'bo--')
title('Mesure du couplage en fonction de QT nï¿½1')
legend('mesure / gamma = 0.62','thï¿½orie / machine parfaite','dï¿½calage thï¿½orie')
xlabel('Courant dans QT nï¿½1');ylabel('couplage en %')

disp('c''est fini')

function emittance = fun(EkeV,Nbpixelsmes,T2,w,yp_siph,d,D,NBPIXEL,NBCONVCRENEAU,NonLin,sigmae,eta,etap,beta,alpha,gammaPM)
% calcul d'émittance
% INPUTS
% Nbpixelsmes = valeur rms du faisceau en nb pixels
% T2, etc .. voir plus haut
%
%
% Smes = 24.3*(D/d)*1e-6 % test
%Smes = NbpixelsmesV * TV2/2.35 % taille sur le convertisseur - mesure à  partir de la largeur à mi-hauteur
Smes = Nbpixelsmes * T2 ;% taille sur le convertisseur - mesure à partir du rms
%Svrai = Smes / (D/d) % S electron si pinhole infiniment petite et pas dediffraction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EkeV = 25e3; % 25 keV
lambda = 1.24e-6*1/EkeV ;
Sdiffraction = sqrt(12) * lambda * D / (w * 4 * pi); % diffraction Fraunhofer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Scamera = NBPIXEL * T2;                    % résolution camera sur le convertisseur
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Spinhole = w * (D + d)/d / NBCONVCRENEAU ;  % effet gémetrique du trou pinhole sur convertisseur
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Smes = Smes/NonLin;                         % effet de la non-linÃ©aritÃ© de la camera
S = sqrt(Smes*Smes - Scamera*Scamera - Sdiffraction*Sdiffraction - Spinhole*Spinhole) ;% S electron en tenant compte des tous les effets
%S = sqrt(Smes*Smes - Scamera*Scamera -  Spinhole*Spinhole) ;        % S electron sans diffraction sur convertisseur

%S = S * ( d/D); % grandissement pinhole
SV = S * ( d/D);
a = sigmae*sigmae*(eta*eta*gammaPM + etap*etap*beta + 2*eta*etap*alpha) + beta * yp_siph*yp_siph;
b = sigmae*sigmae * eta*eta * yp_siph*yp_siph;
c = (S*S / (D*D)) * (beta + 2 * alpha * d + gammaPM * d *d);
e = (S*S / (D*D)) * ((eta - etap*d)*(eta - etap*d) * sigmae * sigmae + d*d * yp_siph*yp_siph);

emittance = (c - a + sqrt((c - a).*(c - a) - 4*(b - e)))/2;
%disp('hello');

%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % calcul de la nappe synchrotron
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Emax = 20e3 ; % 25 keV
%         lambda = 1.24e-6*1/Emax ; sigma_teta = 0.18e-3 *(8.5e3/Emax).^(1/3);
%         Sigma_nappe = (d + D) *sigma_teta% propagation d'un faisceau d'ouverture angulaire sigma_tata :
%         % taille sur le convertisseur en m
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % ENTREE MESURE EN VERTICAL camera 2
%
%         %NbpixelsmesV_nappe = 322 - 250;  % Largeur ï¿½ mi-hauteur
%         NbpixelsmesV_nappe = 40;  % Largeur rms
%
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%         Sigma_nappe_mes = NbpixelsmesV_nappe * TV2
%         Sigma_nappe / Sigma_nappe_mes
