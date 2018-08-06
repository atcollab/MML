function pinhole_computation_dec06(varargin)
% mesure avec XC56 et doublet 50 + 200 mm
% INPUT
% 'ImageAnalyser'  on traite directement les rms donné par l'imageanalyser
% 'Analyse' on refait tou le traitement
%
% OUTPUT
% Courant dans le premier QT  emittance H (nm) et V (e-11m) Couplage

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
NBPIXEL = 1.7  ;               % nb de pixel résolution camera
NBCONVCRENEAU = sqrt(12) ;         %sqrt(12) % 3 ; % facteur de déconvolution du créneau (alternative : 3)
yp_siph =0.13e-3 ;          % emission de photon - energie 20 keV ? 0.13 mrad !
TV2 = 7.5e-6/2.60 ;            % TV2  en µm/pixel sur le plan convertisseur   7.5e-6/2.60
TH2 = 7.5e-6/2.60 ;             %TH2 = 11.4e-6 % 13.38e-6 ;  % Grandissement H camera 2
wV = 10e-6 ;                % taille pinhole Verticale
wH = 25e-6 ;                % taille pinhole Horizontale
d = 4.5 ;                   % distance source - pinhole
D = 5.5 ;                   % distance pinhole - convertisseur
offsetQT1 = -0.2;
offsetK = 0.55;
couleur = 'ro-';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%% test décembre 06
%S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_qt1_oA_2006-10-15_09-52-14.mat')

%%%%%%%%%%%%%% manip 2 décembre 2006
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_10-59-43_MISE_AU_POINT.mat')
% S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_11-39-16_MONTEE_COURANT.mat')
% S3 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_11-59-27.mat')
% S4 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-09-19.mat')

%%%%%%%%%%%%%%%% atténuateur
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-15-34_ATT_2.mat')
%  S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-15-52_ATT_3.mat')
%  S3 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-16-09_ATT_4.mat')
% S4 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-16-30_ATT_5.mat')
% S5 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-16-55_ATT_6.mat')
% S6 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-17-16_ATT_7.mat')
% S7 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-17-35_ATT_8.mat')
% S8 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-17-50_ATT_9.mat')
% S9 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-18-09_ATT_10.mat')
% S10 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-18-32_ATT_11.mat')
% S11 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-18-55_ATT_12.mat')
%  S12 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-19-13_ATT_13.mat')
% S13 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-19-29_ATT_14.mat')

%%%%%%%%%%%%%%%%%%%%%%%%% 
S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_10-59-43_MISE_AU_POINT.mat')
S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_11-39-16_MONTEE_COURANT.mat')

%         %%%%%%%%%%%% traitement image brute %%%%%%%%%%%%%%%%%%%%%%%%%%
%S = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_0_2006-10-15_09-51-35.mat');
%S = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_40mA_2006-10-15_11-18-46.mat');

%%%%%%%%%%%%%%%%%%%%%%%% fonction de l'intensit� du pixel max
% S1 =load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-6.99A_Imax_450_2006-10-15_10-18-24')
% S2 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-6.99A_Imax_560_2006-10-15_10-15-06')
% S3 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-6.99A_Imax_685_2006-10-15_10-10-20')
% S4 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-6.99A_2006-10-15_10-03-53')
% S5 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-6.99A_Imax_995_2006-10-15_10-06-51')

%%%%%%%%%%%%%%%%%%%%%%%%% fonction de la r�sonance de couplage
% S1 =load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_2006-10-15_29mA_0-25_0-25_ter.mat')
% S1 =load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_2006-10-15_29mA_0-2477_0-2547_ter.mat')

%%%%%%%%%%%%%%%%%%%%%%%%% images enregistr�es par JCD
%S1 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/20061013_1_62mA_Att7000_image.txt')

%%%%%%%%%%%%%%%%%%%%%%%%% image de la grille
%S1 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_CIBLE_2-5mm_2-5mm2006-10-17_16-00-23.mat')

%%%%%%%%%%%%%%%%%%%%%%%%% image des bandes blanches
%S1 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/WATEC/WATEC902H_QUADRILLAGE_2006-10-18_19-23-52.mat')

%%%%%%%%%%%%%%%%%%%%%%%%% carr�s Blanc Noir
% S1 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/WATEC/WATEC902H_carre_BN_2006-10-18_18-12-20.mat')

%%%%%%%%%%%%%%%%%%%%%%%%% maille chasman-green
% S1 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_2006-10-15_01-24-44.mat')
% S2 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_2006-10-15_01-24-54.mat')
% S3 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_2006-10-15_01-25-01.mat')

%%%%%%%%%%%%%%%%%%%%%%%%% fonction du couplage
% S1 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-6.99A_2006-10-15_10-03-53')
% S2 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-6A_2006-10-15_10-02-21.mat')
% S3 =load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-5A_2006-10-15_10-01-12.mat')
% S4 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-4A_2006-10-15_09-59-56.mat')
% S5 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-3A_2006-10-15_09-58-38.mat')
% S6 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-2A_2006-10-15_09-55-14.mat')
% S7 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-1_2006-10-15_09-53-50.mat')
% S8 =load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_0_2006-10-15_09-51-35.mat')
% S9 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_1A_2006-10-15_09-33-48.mat')
% S10 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_2A_2006-10-15_09-37-23.mat')
% S11 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_3A_2006-10-15_09-39-25.mat')
% S12 =load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_4A_2006-10-15_09-43-09.mat')
% S13 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_5A_2006-10-15_09-44-51.mat')
% S14 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole-qt1_6A_2006-10-15_09-47-44.mat')
% S15 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_7A_2006-10-15_09-49-06.mat')

sigma_fitapres = ones(15,2)*0; Max_image_brute = []
K_vect = [];IQT = [];eps_x_vect = [] ; SIGMA_Z = [] ; ATT = [];
%fprintf('---Idcct---EmitX(nm)---EmitZ 10-2nm----K(10-2)------PixMax \n ')
fprintf('---Attenuateur--Max Pixel---sigma x----sigma z (pixels) \n ')

% fprintf('Iqt1---EmitX(nm)---EmitZ 10-2nm----K(10-2)---SigX(µm) SigZ(µm) \n ')
for s = 1:2
    if s == 1
        S = S1 ; Iqt1 = -6.99;
    elseif s == 2
        S = S2; Iqt1 = -6.;
    elseif s == 3
        S = S3; Iqt1 = -5;
    elseif s == 4
        S = S4; Iqt1 = -4;
    elseif s == 5
        S = S5; Iqt1 = -3;
    elseif s == 6
        S = S6; Iqt1 = -2;
    elseif s == 7
        S = S7; Iqt1 = -1;
    elseif s == 8
        S = S8; Iqt1 = 0;
    elseif s == 9
        S = S9; Iqt1 = 1;
    elseif s == 10
        S = S10; Iqt1 = 2;
    elseif s == 11
        S = S11;Iqt1 = 3;
    elseif s == 12
        S = S12; Iqt1 = 4;
    elseif s == 13
        S = S13; Iqt1 = 5;
    elseif s == 14
        S = S14; Iqt1 = 6;
    elseif s == 15
        S = S15 ; Iqt1 = 7;
    end


    UserROIOriginX = 200  ;  %
    UserROIOriginY = 136;
    UserROIWidth = 170 ;  %
    UserROIHeight = 170 ;
    %image_matrice = S.toto.value; % cas des images JCD
    image_matrice = S.rep.image;
    figure(3)
    image(image_matrice,'CDataMapping','scaled','Parent',gca)
    image_ROI = image_matrice(UserROIOriginY:UserROIOriginY + UserROIHeight , UserROIOriginX:UserROIOriginX + UserROIWidth);
    %       figure(1);
    %        image(image_ROI,'CDataMapping','scaled','Parent',gca)
    image_ROI = double(image_ROI);
    Max_ROI = max(max(image_ROI));
    %%%%%%%%%%%%% projection image brute
    proj_x = sum(image_ROI(:,:));
    proj_z = sum(image_ROI(:,:)');
    %%%%%%%%%%%%%% traitement 1/gamma
    image_ROI_degammaise = image_ROI;
    %%% test
    %image_ROI_degammaise = (image_ROI + 150).^(1/gamma);
    figure(2);
    visu = int32(image_ROI_degammaise.*1000);
    image(visu,'CDataMapping','scaled','Parent',gca)
    %%%%%%%%%%%%%%% projection image degammaisée
    proj_x_degammaise = sum(visu(:,:));
    proj_z_degammaise = sum(visu(:,:)');
    %%%%%%%%%%%%%%% comparaison des sigmas
    figure(4) ; hold on
    plot(proj_x*max(proj_x_degammaise)/max(proj_x),'r-') ; hold on ;
    plot(proj_x_degammaise,'ko')
    Max_image_brute = [Max_image_brute Max_ROI];
    Idcct = S.rep.current;
    Att = S.rep.attenuateur;
    
    if Calcul == 0
        x0 = [8 35 max(proj_x_degammaise) max(proj_x_degammaise)/13 ]; % x0 = [sigma,centre,intensit�,constante];x0 = [40 600 50];
        xdata = 1:size(proj_x,2);
        res = proj_x*max(proj_x_degammaise)/max(proj_x);
        [ac] = lsqcurvefit(@myfun_gaussienne_offset,x0,xdata,res);
        sigma_fitavant = ac(1)*sqrt(gamma);
        %        xdatap = 1:0.1:size(proj_x,2);
        %        F=ac(4) + ac(3)*exp(-(xdatap-ac(2)).*(xdatap-ac(2))/(2*ac(1)*ac(1))); %
        %        hold on ; plot(xdatap,F,'r');
        %%%
        %x0 = [5 35 max(proj_x_degammaise) max(proj_x_degammaise)/100]; % x0 = [sigma,centre,intensit�,constante];x0 = [40 600 50];
        x0 = [6 35 max(proj_x_degammaise) proj_x_degammaise(5)];
        xdata = 1:size(proj_x_degammaise,2);
        res = proj_x_degammaise;
        [ac] = lsqcurvefit(@myfun_gaussienne_offset,x0,xdata,res);
        sigma_fitapres(s,1) = ac(1)
        sigma_x = sigma_fitapres(s,1);
        xdatap = 1:0.1:size(proj_x_degammaise,2);
        F=ac(4) + ac(3)*exp(-(xdatap-ac(2)).*(xdatap-ac(2))/(2*ac(1)*ac(1))); %
        hold on ; plot(xdatap,F,'k');
        %        xlabel('taille horizontale en pixels - Pinhole qt1 0 2006-10-15 09-51-35')
        %xlabel('taille horizontale en pixels - Pinhole 40mA 2006-10-15 11-18-46')
        %        legend('projection brute','projection d�gammais�e','fit brut - sigma*sqrt(gamma) = 5.83 pixels','fit  - sigma = 5.98 pixels')
        %legend('projection brute','projection d�gammais�e','fit brut - sigma*sqrt(gamma) = 5.55 pixels','fit  - sigma = 5.86 pixels')
        %        title('comparaison des fits gaussien avant et apr�s "degammaisation"')

        %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        figure(5) ; hold on
        plot(proj_z*max(proj_z_degammaise)/max(proj_z),'bo') ; hold on ;
        plot(proj_z_degammaise,'ko')

        x0 = [5 25 max(proj_z_degammaise) max(proj_z_degammaise)/13  ]; % x0 = [sigma,centre,intensit�,constante];x0 = [40 600 50];
        xdata = 1:size(proj_z,2);
        res = proj_z*max(proj_z_degammaise)/max(proj_z);
        [ac] = lsqcurvefit(@myfun_gaussienne_offset,x0,xdata,res);
        sigma_fitavant = ac(1)*sqrt(gamma);
        %%       xdatap = 1:0.1:size(proj_z,2);
        %%       F=ac(4) + ac(3)*exp(-(xdatap-ac(2)).*(xdatap-ac(2))/(2*ac(1)*ac(1))); %
        %%       hold on ; plot(xdatap,F,'b');
        %%%%
        x0 = [5 25 max(proj_z_degammaise) max(proj_z_degammaise)/73];% x0 = [sigma,centre,intensit�,constante];x0 = [40 600 50];
        x0 = [5 25 max(proj_z_degammaise) proj_z_degammaise(5)];
        xdata = 1:size(proj_z_degammaise,2);
        res = proj_z_degammaise;
        [ac] = lsqcurvefit(@myfun_gaussienne_offset,x0,xdata,res);
        sigma_fitapres(s,2) = ac(1)
        sigma_z = sigma_fitapres(s,2);
        xdatap = 1:0.1:size(proj_z_degammaise,2);
        F=ac(4) + ac(3)*exp(-(xdatap-ac(2)).*(xdatap-ac(2))/(2*ac(1)*ac(1))); %
        hold on ; plot(xdatap,F,'k');
        %         xlabel('taille verticale en pixels - Pinhole qt1 0 2006-10-15 09-51-35')
        %         %xlabel('taille verticale en pixels - Pinhole 40mA 2006-10-15 11-18-46')
        %         legend('projection brute','projection d�gammais�e','fit brut - sigma*sqrt(gamma) =3.22 pixels','fit-sigma =3.44 pixels')
        %         %legend('projection brute','projection d�gammais�e','fit brut - sigma*sqrt(gamma) =3.82 pixels','fit-sigma =3.67 pixels')
        %         title('comparaison des fits gaussien avant et apr�s "degammaisation"')



        % for i = 1:5
        %
        % %    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% % mesure du dimanche 15 octobre 2006
        % %     if i == 2
        % %         Iqt1 = -6.99;NbpixelsmesH = 7.71;NbpixelsmesV = 6.41;
        % %     elseif i == 3
        % %         Iqt1 = -6;NbpixelsmesH = 7.63;NbpixelsmesV = 5.97;
        % %     elseif i == 4
        % %          Iqt1 = -5;NbpixelsmesH = 7.65;NbpixelsmesV = 5.45;
        % %     elseif i == 5
        % %         Iqt1 = -4;NbpixelsmesH = 7.73;NbpixelsmesV = 5.22;
        % %     elseif i == 6
        % %         Iqt1 = -3;NbpixelsmesH = 7.77;NbpixelsmesV = 4.88;
        % %     elseif i == 7
        % %         Iqt1 = -2;NbpixelsmesH = 7.67;NbpixelsmesV = 4.63;
        % %     elseif i == 8
        % %         Iqt1 = -1;NbpixelsmesH = 7.75;NbpixelsmesV = 4.45;
        % %     elseif i == 9
        % %         Iqt1 = 0;NbpixelsmesH = 7.57;NbpixelsmesV = 4.46;
        % %     elseif i == 10
        % %         Iqt1 = 1;NbpixelsmesH = 7.46;NbpixelsmesV = 4.46;
        % %     elseif i == 11
        % %         Iqt1 = 2;NbpixelsmesH = 7.49;NbpixelsmesV = 4.55;
        % %     elseif i == 12
        % %         Iqt1 = 3;NbpixelsmesH = 7.43;NbpixelsmesV = 4.79;
        % %     elseif i == 13
        % %         Iqt1 = 4;NbpixelsmesH = 7.68;NbpixelsmesV = 5.28;
        % %     elseif i == 14
        % %        Iqt1 = 5;NbpixelsmesH = 7.58;NbpixelsmesV = 5.58;
        % %     elseif i == 15
        % %         Iqt1 = 6;NbpixelsmesH = 7.60;NbpixelsmesV = 6.13;
        % %     elseif i == 16
        % %         Iqt1 = 7;NbpixelsmesH = 7.45;NbpixelsmesV = 6.54;
        % %     end;
        %
        % % % %%%%%%%%%%%%%%%%%% mesure chasmann green dimanche 15 octobre 2006
        % %     if i == 1
        % %         Iqt1 = 0;NbpixelsmesH = 7.25 ;NbpixelsmesV = 18.98;
        % %     elseif i == 2
        % %         Iqt1 = 0;NbpixelsmesH = 7.65 ;NbpixelsmesV = 20.330;
        % %     elseif i == 3
        % %         Iqt1 = 0;NbpixelsmesH = 8.63  ;NbpixelsmesV = 5.83;
        % %     end
        %
        % % % %%%%%%%%%%%%%%%%%% mesure en fonction de l'atténuateur dimanche 15 octobre 2006
        % %     if i == 1
        % %         Iqt1 = 450;NbpixelsmesH = 6.65 ;NbpixelsmesV = 5.72;
        % %     elseif i == 2
        % %         Iqt1 = 560;NbpixelsmesH = 7.08 ;NbpixelsmesV = 5.92;
        % %     elseif i == 3
        % %         Iqt1 = 685;NbpixelsmesH = 7.50  ;NbpixelsmesV = 6.16;
        % %     elseif i == 4
        % %         Iqt1 = 995;NbpixelsmesH = 8.12  ;NbpixelsmesV = 6.77;
        % %     end
        % % % %%%%%%%%%%%%%%%%%% mesure en fonction du courant dans la machine
        %     if i == 1
        %         Iqt1 = 8.49;NbpixelsmesH = 7.56 ;NbpixelsmesV = 4.46;
        %     elseif i == 2
        %         Iqt1 = 20.87;NbpixelsmesH = 7.81 ;NbpixelsmesV = 4.75;
        %     elseif i == 3
        %         Iqt1 = 39.9;NbpixelsmesH = 7.73  ;NbpixelsmesV = 5.0;
        %     elseif i == 4
        %         Iqt1 = 62;NbpixelsmesH = 8.02  ;NbpixelsmesV = 5.52;
        %     elseif i == 5
        %         Iqt1 = 80.28;NbpixelsmesH = 7.87  ;NbpixelsmesV = 5.58;
        %     end
        %     % % %%%%%%%%%%%%%%%%%%
        %
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % plan vertical
    elseif Calcul == 1  % cas où on prend directement les résultats rms de l'image analyser
        if S.rep.gamma ~= 1
            disp('gamma caméra n''est pas à sa valeur correcte') % test sur la valeur de gamma
            return
        else
            sigma_x = S.rep.sigmaz ;   % échange des axes
            sigma_z = S.rep.sigmax;
        end
    end
    sigmae = 0 ;
    eta = 0 ;
    etap = 0 ;
    beta = 15.78 ;
    alpha = 0.88 ;
    gammaPM = (1 + alpha)/beta ;
    eps_z = fun(sigma_z,TV2,wV,yp_siph,d,D,NBPIXEL,NBCONVCRENEAU,NonLin,sigmae,eta,etap,beta,alpha,gammaPM);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plan horizontal
    sigmae = 1e-3 ;
    eta = 0.018 ;
    etap = -0.035 ;
    beta = 0.37 ;
    alpha = 0.038 ;
    gammaPM = (1 + alpha)/beta;
    eps_x = fun(sigma_x,TH2,wH,yp_siph,d,D,NBPIXEL,NBCONVCRENEAU,NonLin,sigmae,eta,etap,beta,alpha,gammaPM);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    K = eps_z / eps_x;
    eps_x_vect = [eps_x_vect eps_x];
    K_vect = [K_vect K];
    if Calcul==0
        
        IQT = [IQT Iqt1];
    else
        Iqt1 = S.rep.QT1;
        IQT = [IQT Iqt1];
    end
    %S = [150 100 50 29.7]
    %e = [1.0252e-09 4.3767e-10 1.0688e-10 3.7522e-11]
    % Couplage (%)---SigmaX source (µm) SigmaZ source (µm)
    %plot(S,e)

%     RES = [Idcct eps_x*1e9 eps_z*1e11 K*100 Max_ROI]; % RES = [Iqt1 eps_x*1e9 eps_z*1e11 K*100 SH*1e6 SV*1e6];
%     fprintf('%8.2f  %8.2f  %10.2f  %10.2f  %10.2f \n',RES ); %fprintf('%8.2f  %8.2f  %8.2f  %8.2f  %8.2f  %8.2f \n',RES );
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fit théorie / mesure
IQTtheorb = IQTtheor + offsetQT1 ;
Ktheorb = Ktheor + offsetK ;
hold on
plot(IQTtheorb,Ktheorb,'bo--')
title('Mesure du couplage en fonction de QT n�1')
legend('mesure / gamma = 0.62','th�orie / machine parfaite','d�calage th�orie')
xlabel('Courant dans QT n�1');ylabel('couplage en %')

disp('c''est fini')

function emittance = fun(Nbpixelsmes,T2,w,yp_siph,d,D,NBPIXEL,NBCONVCRENEAU,NonLin,sigmae,eta,etap,beta,alpha,gammaPM)
% calcul d'émittance
% INPUTS
% Nbpixelsmes = valeur rms du faisceau en nb pixels
% T2, etc .. voir plus haut
%
%
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
%%%%%% Smes = Smes/NonLin;                         % effet de la non-linéarité de la camera
%S = sqrt(Smes*Smes - Sresoution*Sresoution - Sdiffraction*Sdiffraction - Spinhole*Spinhole) ;% S electron en tenant compte des tous les effets
S = sqrt(Smes*Smes - Scamera*Scamera -  Spinhole*Spinhole) ;        % S electron sans diffraction

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
%         %NbpixelsmesV_nappe = 322 - 250;  % Largeur � mi-hauteur
%         NbpixelsmesV_nappe = 40;  % Largeur rms
%
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%         Sigma_nappe_mes = NbpixelsmesV_nappe * TV2
%         Sigma_nappe / Sigma_nappe_mes
