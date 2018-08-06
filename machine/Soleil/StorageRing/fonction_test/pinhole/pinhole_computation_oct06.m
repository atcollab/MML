function pinhole_computation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gamma = 0.49  ;  NonLin = 1./sqrt(gamma) ;   %  0.5225 NonLin = 1./sqrt(0.45)   %  NonLin = 1. % Facteur gamma de la camera
NBPIXEL = 2  ;               % nb de pixel résolution camera
NBCONVCRENEAU = 3 ;         %sqrt(12) % 3 ; % facteur de déconvolution du créneau (alternative : 3)
yp_siph =0.13e-3 ;          % emission de photon - energie 20 keV ? 0.13 mrad !
TV2 = 11.36e-6 ;            % TV2 = 11.07e-6 % 12.6e-6 ; % Grandissement V camera 2
TH2 = 11.86e-6 ;             %TH2 = 11.4e-6 % 13.38e-6 ;  % Grandissement H camera 2
wV = 25e-6 ;                % taille pinhole Verticale
wH = 50e-6 ;                % taille pinhole Horizontale
d = 4.5 ;                   % distance source - pinhole
D = 5.5 ;                   % distance pinhole - convertisseur
offsetQT1 = -0.2;
offsetK = 0.55;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%         %%%%%%%%%%%% traitement image brute %%%%%%%%%%%%%%%%%%%%%%%%%%
%         UserROIOriginX = 496 ;
%         UserROIOriginY = 233 ;
%         UserROIWidth = 72 ;
%         UserROIHeight = 52 ;
%         S = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_qt1_0_2006-10-15_09-51-35.mat');
%         image_matrice = S.rep.image;
%         figure(3)
%         image(image_matrice,'CDataMapping','scaled','Parent',gca)
%         image_ROI = image_matrice(UserROIOriginY:UserROIOriginY + UserROIHeight , UserROIOriginX:UserROIOriginX + UserROIWidth);
%         figure(1);
%         image(image_ROI,'CDataMapping','scaled','Parent',gca)
%         image_ROI = double(image_ROI)
%         %%%%%%%%%%%%% projection image brute
%         proj_x = sum(image_ROI(:,:))
%         proj_z = sum(image_ROI(:,:)')
%         %%%%%%%%%%%%%% traitement 1/gamma
%         image_ROI_degammaise = image_ROI.^(1/gamma);
%         figure(2);
%         visu = int32(image_ROI_degammaise.*1000)
%         image(visu,'CDataMapping','scaled','Parent',gca)
%         %%%%%%%%%%%%%%% projection image degammaisée
%         proj_x_degammaise = sum(visu(:,:))
%         proj_z_degammaise = sum(visu(:,:)')
%         %%%%%%%%%%%%%%% comparaison des sigmas
%         figure(4) ; plot(proj_x*max(proj_x_degammaise)/max(proj_x),'r') ; hold on ; plot(proj_x_degammaise,'b')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K_vect = [];IQT = [];
fprintf('Iqt1---EmitX(nm)---EmitZ 10-2nm----K(10-2) \n ') % fprintf('Iqt1---EmitX(nm)---EmitZ 10-2nm----K(10-2)---SigX(µm) SigZ(µm) \n ')
for i = 2:16

%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% % mesure du dimanche 15 octobre 2006
    if i == 2
        Iqt1 = -6.99;NbpixelsmesH = 7.71;NbpixelsmesV = 6.41;        
    elseif i == 3
        Iqt1 = -6;NbpixelsmesH = 7.63;NbpixelsmesV = 5.97;        
    elseif i == 4
         Iqt1 = -5;NbpixelsmesH = 7.65;NbpixelsmesV = 5.45;        
    elseif i == 5
        Iqt1 = -4;NbpixelsmesH = 7.73;NbpixelsmesV = 5.22;        
    elseif i == 6
        Iqt1 = -3;NbpixelsmesH = 7.77;NbpixelsmesV = 4.88;        
    elseif i == 7
        Iqt1 = -2;NbpixelsmesH = 7.67;NbpixelsmesV = 4.63;    
    elseif i == 8
        Iqt1 = -1;NbpixelsmesH = 7.75;NbpixelsmesV = 4.45;        
    elseif i == 9
        Iqt1 = 0;NbpixelsmesH = 7.57;NbpixelsmesV = 4.46;       
    elseif i == 10
        Iqt1 = 1;NbpixelsmesH = 7.46;NbpixelsmesV = 4.46;       
    elseif i == 11
        Iqt1 = 2;NbpixelsmesH = 7.49;NbpixelsmesV = 4.55;       
    elseif i == 12
        Iqt1 = 3;NbpixelsmesH = 7.43;NbpixelsmesV = 4.79;      
    elseif i == 13
        Iqt1 = 4;NbpixelsmesH = 7.68;NbpixelsmesV = 5.28;
    elseif i == 14
       Iqt1 = 5;NbpixelsmesH = 7.58;NbpixelsmesV = 5.58;
    elseif i == 15
        Iqt1 = 6;NbpixelsmesH = 7.60;NbpixelsmesV = 6.13;
    elseif i == 16
        Iqt1 = 7;NbpixelsmesH = 7.45;NbpixelsmesV = 6.54;
    end;

% % %%%%%%%%%%%%%%%%%% mesure chasmann green dimanche 15 octobre 2006
%     if i == 1
%         Iqt1 = 0;NbpixelsmesH = 7.25 ;NbpixelsmesV = 18.98;
%     elseif i == 2
%         Iqt1 = 0;NbpixelsmesH = 7.65 ;NbpixelsmesV = 20.330;
%     elseif i == 3
%         Iqt1 = 0;NbpixelsmesH = 8.63  ;NbpixelsmesV = 5.83;
%     end

% % %%%%%%%%%%%%%%%%%% mesure en fonction de l'atténuateur dimanche 15 octobre 2006
%     if i == 1
%         Iqt1 = 450;NbpixelsmesH = 6.65 ;NbpixelsmesV = 5.72;
%     elseif i == 2
%         Iqt1 = 560;NbpixelsmesH = 7.08 ;NbpixelsmesV = 5.92;
%     elseif i == 3
%         Iqt1 = 685;NbpixelsmesH = 7.50  ;NbpixelsmesV = 6.16;
%     elseif i == 4
%         Iqt1 = 995;NbpixelsmesH = 8.12  ;NbpixelsmesV = 6.77;
%     end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plan vertical

    sigmae = 0 ;
    eta = 0 ;
    etap = 0 ;
    beta = 15.78 ;
    alpha = 0.88 ;
    gamma = (1 + alpha)/beta ;
    eps_z = fun(NbpixelsmesV,TV2,wV,yp_siph,d,D,NBPIXEL,NBCONVCRENEAU,NonLin,sigmae,eta,etap,beta,alpha,gamma);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plan horizontal
    sigmae = 1e-3 ;
    eta = 0.018 ;
    etap = -0.035 ;
    beta = 0.37 ;
    alpha = 0.038 ;
    gamma = (1 + alpha)/beta;
    eps_x = fun(NbpixelsmesH,TH2,wH,yp_siph,d,D,NBPIXEL,NBCONVCRENEAU,NonLin,sigmae,eta,etap,beta,alpha,gamma);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    K = eps_z / eps_x;
    K_vect = [K_vect K];
    IQT = [IQT Iqt1];

    %S = [150 100 50 29.7]
    %e = [1.0252e-09 4.3767e-10 1.0688e-10 3.7522e-11]
    % Couplage (%)---SigmaX source (µm) SigmaZ source (µm)
    %plot(S,e)

    RES = [Iqt1 eps_x*1e9 eps_z*1e11 K*100 ]; % RES = [Iqt1 eps_x*1e9 eps_z*1e11 K*100 SH*1e6 SV*1e6];
    fprintf('%8.2f  %8.2f  %8.2f  %8.2f   \n',RES ); %fprintf('%8.2f  %8.2f  %8.2f  %8.2f  %8.2f  %8.2f \n',RES );
end

IQTtheor = [-7 -6 -3 0 3 6 7];
IQTtheor = -7:1:7;
Ktheor = [1.94 1.43 0.52 0 0.52 1.43 1.94 ];
Ktheor = [1.94 1.44 1.0 0.64 0.36 0.16 0.04 0 0.04 0.16 0.36 0.64 1.0 1.44 1.94];
figure(4);plot(IQT,K_vect*100,'ro-')
hold on
plot(IQTtheor,Ktheor,'bo-')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fit théorie / mesure
IQTtheorb = IQTtheor + offsetQT1 ;
Ktheorb = Ktheor + offsetK ;
hold on
%plot(IQTtheorb,Ktheorb,'bo--')
title('Mesure du couplage en fonction de QT n°1')
legend('mesure / gamma = 0.52','théorie / machine parfaite','décalage théorie')
xlabel('Courant dans QT n°1');ylabel('couplage en %')

function emittance = fun(Nbpixelsmes,T2,w,yp_siph,d,D,NBPIXEL,NBCONVCRENEAU,NonLin,sigmae,eta,etap,beta,alpha,gamma)

% Smes = 24.3*(D/d)*1e-6 % test
%Smes = NbpixelsmesV * TV2/2.35 % mesure à partir de la largeur à mi-hauteur
Smes = Nbpixelsmes * T2 ;% mesure à partir du rms
%Svrai = Smes / (D/d) % S electron si pinhole infiniment petite et pas dediffraction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Emax = 25e3; % 25 keV
lambda = 1.24e-6*1/Emax ;
%Sdiffraction = sqrt(12) * lambda * D / (w * 4 * pi); % diffraction Fraunhofer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Scamera = NBPIXEL * T2;                    % résolution camera
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Spinhole = w * (D + d)/d / NBCONVCRENEAU ;  % effet géometrique du trou pinhole A DISCUTER !
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Smes = Smes/NonLin;                         % effet de la non-linéarité de la camera
%S = sqrt(Smes*Smes - Sresoution*Sresoution - Sdiffraction*Sdiffraction - Spinhole*Spinhole) ;% S electron en tenant compte des tous les effets
S = sqrt(Smes*Smes - Scamera*Scamera -  Spinhole*Spinhole) ;        % S electron sans diffraction

%S = S * ( d/D); % grandissement pinhole

SV = S * ( d/D);
a = sigmae*sigmae*(eta*eta*gamma + etap*etap*beta + 2*eta*etap*alpha) + beta * yp_siph*yp_siph;
b = sigmae*sigmae * eta*eta * yp_siph*yp_siph;
c = (S*S / (D*D)) * (beta + 2 * alpha * d + gamma * d *d);
e = (S*S / (D*D)) * ((eta - etap*d)*(eta - etap*d) * sigmae * sigmae + d*d * yp_siph*yp_siph);

emittance = (c - a + sqrt((c - a).*(c - a) - 4*(b - e)))/2;


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
%         %NbpixelsmesV_nappe = 322 - 250;  % Largeur � mi-hauteur
%         NbpixelsmesV_nappe = 40;  % Largeur rms
%
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%         Sigma_nappe_mes = NbpixelsmesV_nappe * TV2
%         Sigma_nappe / Sigma_nappe_mes