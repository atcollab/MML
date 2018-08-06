function pinhole_computation_dec06_10_25(varargin)
% mesure avec XC56 et doublet 50 + 200 mm
% INPUT
% 'ImageAnalyser'  on traite directement les rms donnÃ© par l'imageanalyser
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
NBPIXEL = 1.7  ;               % nb de pixel rÃ©solution camera
NBCONVCRENEAU = sqrt(12) ;         %sqrt(12) % 3 ; % facteur de dÃ©convolution du crÃ©neau (alternative : 3)
yp_siph_ref = 0.18e-3 ;%0.13e-3 ;          % emission de photon - energie 20 keV ? 0.13 mrad !
EkeV_ref = 8.5e3;
TV2 = 7.4e-6/3.75 ;            %  3.75 2.60   TV2  en Âµm/pixel sur le plan convertisseur   7.5e-6/2.60
TH2 = 7.4e-6/3.75 ;             %  2.60  TH2 = 11.4e-6 % 13.38e-6 ;  % Grandissement H camera 2
wV = 10e-6 ;                % taille pinhole Verticale
wH = 25e-6 ;                % taille pinhole Horizontale
d =  4.346; %4.5;                   % distance source - pinhole 4.356
D =  5.721 ; %5.5;                   % distance pinhole - convertisseur  5.695
offsetQT1 = -0.2;
offsetK = 0.55;
couleur = 'ro-';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 5 juin emittance H dissymétrique
S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-06-05_09-30-08.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 26 mars
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-26_16-39-50_PS2_-100.mat')
% S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-26_16-40-06_idem.mat')
% S3 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-26_16-40-14_idem.mat')
% S4 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-26_16-40-22_idem.mat')
% S5 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-26_16-40-30_idem.mat')

%%%%%%%%%%%%%%%%%%%%%%%% 20 mars variation goniometre
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-25-22_Gonio-20_aileduncote.mat')
% S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-26-13_Gonio+20_aileautrecote.mat')
% S3 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-26-54_Gonio_0_aileaucentre.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%% idem emittance Z symetrique
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-21-12_5microns_Gonio+18_79mA.mat')
% S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-21-54_5microns_Gonio_-20_75mA.mat')


% %S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-12-42_5microns_-21Gonio_100mA.mat')
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-16-57_5microns_Gonio-21_92mA-21.mat')
% %S3 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-18-21_5microns_Gonio+21_89mA.mat')
% S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-19-25_5microns_Gonio+19_86mA.mat')
% % S5 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-21-12_5microns_Gonio+18_79mA.mat')
% % S6 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-21-54_5microns_Gonio_-20_75mA.mat')
% % S7 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-25-22_Gonio-20_aileduncote.mat')
% % S8 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-26-13_Gonio+20_aileautrecote.mat')
% % S9 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_15-26-54_Gonio_0_aileaucentre.mat')


%%%%%%%%%%%%%%%%%%%%%%%%  20 mars 2007 variation attÃ©nuateur
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_12-47-35_Att5600.mat')
% S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_12-46-33_att5600.mat')
% S3 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_12-46-57_Att5700.mat')
% S4 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_12-50-01_Att5800.mat')
% S5 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_12-50-23_Att5900.mat')
% S6 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_12-50-37_Att6000.mat')
% S7 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_12-50-54_Att6100.mat')
% S8 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_12-51-11_Att6200.mat')

%%%%%%%%%%%%%%%%%%%%%% trou 25 Âµm x 25 Âµm
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_12-54-16_trou25microns_21mA.mat')
% S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-03-20_13-00-47_25microns_4mA_sansAtt.mat')


%%%%%%%%%%%%%%%%%Ã¹ 12 fÃ©vrier 2007 interferomÃ©trie
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-13_05-27-05.mat')
% 
% %%%%%%%%%%%%%%%%%% comparaison 2 courants
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-05_06-49-48_210mA.mat')
% S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-05_08-14-22_1-4mA.mat')


%%%%%%%%%%%%%%% run 21 dÃ©cembre fonction de QP10 
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-58-11_QT1_0.mat')
% S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_12-00-58_QP10_-1pc.mat')
% %S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_12-02-56_QP10_-1-5pc.mat')
% S3 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_12-04-19_QP10_-2pc.mat')
% %S4 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_12-05-04_QP10_-2-5pc.mat')
% S4 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_12-05-45_QP10_-3pc.mat')
%S6 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_12-06-43_QP10_-3-5pc.mat')
%S7 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_12-08-41_QP10_-4pc.mat')
%S8 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_12-09-20_QP10_-4-5pc.mat')
% S5 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_12-10-34_QP10_5pc.mat')


%%%%%%%%%%%%% run 21 dÃ©cembre 2006 fonction du couplage
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-57-27_QT1_-7.mat')
% S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-56-44_QT1_-6.mat')
% S3 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-56-19_QT1_-5.mat')
% S4 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-55-54_QT1_-4.mat')
% S5 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-55-32_QT1_-3.mat')
% S6 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-55-08_QT1_-2.mat')
% S7 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-54-44_QT1_-1.mat')
% S8 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-46-48_QT1_0.mat')
% S9 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-47-15_QT1_1.mat')
% S10 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-47-39_QT1_2.mat')
% S11 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-48-08_QT1_3.mat')
% S12 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-52-15_QT1_4.mat')
% S13 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-52-44_QT1_5.mat')
% S14 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-53-10_QT1_6.mat')
% S15 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-21_11-53-36_QT1_7.mat')


%%%%%%%%%%%%% test dÃ©cembre 06
%S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_qt1_oA_2006-10-15_09-52-14.mat')

%%%%%%%%%%%%%% manip 2 dÃ©cembre 2006
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_10-59-43_MISE_AU_POINT.mat')
% S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_11-39-16_MONTEE_COURANT.mat')
% S3 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_11-59-27.mat')
% S4 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-09-19.mat')

%%%%%%%%%%%%%%%% attÃ©nuateur
% S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-15-34_ATT_2.mat')
%  S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-15-52_ATT_3.mat')
%  S3 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-16-09_ATT_4.mat')
% S4 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-16-30_ATT_5.mat')
% S5 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-16-55_ATT_6.mat')
% S6 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-17-16_ATT_7.mat')
% S7 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-17-35_ATT_8.mat')
% S8 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-17-50_ATT_9.mat')
% S9 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-18-09_ATT_10.mat')
% S10 = load('-mat','/home/matlab1ML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-18-32_ATT_11.mat')
% S11 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-18-55_ATT_12.mat')
%  S12 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-19-13_ATT_13.mat')
% S13 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_12-19-29_ATT_14.mat')

%%%%%%%%%%%%%%%%%%%%%%%%% 
%S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_10-59-43_MISE_AU_POINT.mat')
%S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-02_11-39-16_MONTEE_COURANT.mat')

%%%%%%%%%%%%%%%%%%%%%%%%% 8 dÃ©cembre run insertion
%S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2006-12-08_17-30-52_REGLAGEOK_bis.mat');


%         %%%%%%%%%%%% traitement image brute %%%%%%%%%%%%%%%%%%%%%%%%%%
%S = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_0_2006-10-15_09-51-35.mat');
%S = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_40mA_2006-10-15_11-18-46.mat');

%%%%%%%%%%%%%%%%%%%%%%%% fonction de l'intensitï¿½ du pixel max
% S1 =load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-6.99A_Imax_450_2006-10-15_10-18-24')
% S2 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-6.99A_Imax_560_2006-10-15_10-15-06')
% S3 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-6.99A_Imax_685_2006-10-15_10-10-20')
% S4 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-6.99A_2006-10-15_10-03-53')
% S5 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_qt1_-6.99A_Imax_995_2006-10-15_10-06-51')

%%%%%%%%%%%%%%%%%%%%%%%%% fonction 1de la rï¿½sonance de couplage
% S1 =load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_2006-10-15_29mA_0-25_0-25_ter.mat')
% S1 =load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_2006-10-15_29mA_0-2477_0-2547_ter.mat')

%%%%%%%%%%%%%%%%%%%%%%%%% images enregistrï¿½es par JCD
%S1 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/20061013_1_62mA_Att7000_image.txt')

%%%%%%%%%%%%%%%%%%%%%%%%% image de la grille
%S1 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/PINHOLE/Pinhole_CIBLE_2-5mm_2-5mm2006-10-17_16-00-23.mat')

%%%%%%%%%%%%%%%%%%%%%%%%% image des bandes blanches
%S1 = load('-mat','/home/PM/tordeux/matlab_test/Fresnel_diffraction/WATEC/WATEC902H_QUADRILLAGE_2006-10-18_19-23-52.mat')

%%%%%%%%%%%%%%%%%%%%%%%%% carrï¿½s Blanc Noir
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

sigma_fitapres = ones(15,2)*0; Max_image_brute = [];
K_vect = [];IQT = [];eps_x_vect = [] ; eps_z_vect = [] ; sigma_z_vect = [] ; sigma_x_vect = [] ;ATT = []; Gonio_vect = [];
fprintf('---Idcct---EmitX (nm)---EmitZ (pm)-----K(10-2)------PixMax-----Epeack(keV)--AttÃ©n.---Gonio   \n ')
% fprintf('Iqt1---EmitX(nm)---EmitZ 10-2nm----K(10-2)---SigX(Âµm) SigZ(Âµm)\n ')
% fprintf('---Attenuateur--Max Pixel---sigma x----sigma z (pixels) \n ')
x = [5115 5178 5256 5880 6661 12903 20706]; % recherche de l'ï¿½nergie pic en fonction de la valeur attï¿½nuateur
y = 1e3*[24.55 28.5 31.5 45.9 54.1 80.7 95];
xx = 5000:1:21000;
yy = spline(x,y,xx);

for s = 1:1:1
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if s == 1 S = S1 ; elseif s == 2  S = S2; elseif s == 3 S = S3; elseif s == 4 S = S4; 
    elseif s == 5 S = S5; elseif s == 6 S = S6; elseif s == 7 S = S7; elseif s == 8 S = S8; 
    elseif s == 9 S = S9; elseif s == 10 S = S10; elseif s == 11 S = S11; elseif s == 12 S = S12; 
    elseif s == 13 S = S13; elseif s == 14 S = S14; elseif s == 15 S = S15 ; 
   end

  %%%%%%%%%%%%%%%%% cas oÃ¹ les fonctions de twiss Ã©voluent
%   if s == 1 S = S1 ; % QP 10  0%
%     etax = 0.0171 ;
%     etapx = -0.0323 ;
%     betax = 0.3677 ;
%     alphax = 0.0825 ;
%   elseif s == 2 S = S2 ; % QP 10  -1%
%     etax = 0.02000 ;
%     etapx = -0.0387 ;
%     betax = 0.3745 ;
%     alphax = 0.1398 ;
%   elseif s == 3  S = S3; % QP 10  -2 % 
%     etax = 0.02336 ;
%     etapx = -0.0463 ;
%     betax = 0.3830 ;
%     alphax = 0.2001 ;
%   elseif s == 4 S = S4;  % QP 10  -3 %
%     etax = 0.02736 ;
%     etapx = -0.0553 ;
%     betax = 0.3934 ;
%     alphax = 0.2644 ;
%   elseif s == 5 S = S5; % QP 10  -5 %
%     etax = 0.03830 ;
%     etapx = -0.07989 ;
%     betax = 0.4223 ;
%     alphax = 0.4108 ;
%     elseif s == 5 S = S5; elseif s == 6 S = S6; elseif s == 7 S = S7; elseif s == 8 S = S8; 
%     elseif s == 9 S = S9; elseif s == 10 S = S10; elseif s == 11 S = S11; elseif s == 12 S = S12; 
%     elseif s == 13 S = S13; elseif s == 14 S = S14; elseif s == 15 S = S15 ; 
%    end

   image_matrice = S.rep.image;
   figure(3)
   tata = image_matrice;
   image(tata,'CDataMapping','scaled','Parent',gca)

   Idcct = S.rep.current;
   Att = S.rep.attenuateur;
   ATT = [ATT Att];
   if Att>5077
        I = find(xx==Att);
        EkeV = yy(I);
    else
        EkeV = 21.e3;         % 20 keV sans AttÃ©nuateur
    end

    if Calcul == 0          % on recalcule un ROI et les fits gaussiens

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        UserROIOriginX = 200  ;  %
        UserROIOriginY = 136;
        UserROIWidth = 170 ;  %
        UserROIHeight = 170 ;
        %image_matrice = S.toto.value; % cas des images JCD
        
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
        Max_image_brute = [Max_image_brute Max_ROI];5


        figure(4); 
        %hold on
        x0 = [8 35 max(proj_x) max(proj_x)/13 ]; % x0 = [sigma,centre,intensitï¿½,constante];x0 = [40 600 50];
        xdata = 1:size(proj_x,2);
        res = proj_x;
        [ac] = lsqcurvefit(@myfun_gaussienne_offset,x0,xdata,res);
        sigma_fit(s,1) = ac(1);
        sigma_z = sigma_fit(s,1);
        xdatap = 1:0.1:size(proj_x,2);
        F=ac(4) + ac(3)*exp(-(xdatap-ac(2)).*(xdatap-ac(2))/(2*ac(1)*ac(1))); %
        hold on ; plot(xdatap,F,'k');5
        hold off

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        figure(5) ; 
        %hold on
        x0 = [5 25 max(proj_z) max(proj_z)/13  ]; % x0 = [sigma,centre,intensitï¿½,constante];x0 = [40 600 50];
        xdata = 1:size(proj_z,2);
        res = proj_z;
        [ac] = lsqcurvefit(@myfun_gaussienne_offset,x0,xdata,res);
        sigma_fit(s,2) = ac(1);
        sigma_x = sigma_fit(s,2);
        xdatap = 1:0.1:size(proj_z,2);
        F=ac(4) + ac(3)*exp(-(xdatap-ac(2)).*(xdatap-ac(2))/(2*ac(1)*ac(1))); %
        hold on ; plot(xdatap,F,'k');
        hold off

    elseif Calcul == 1                  % cas oÃ¹ on prend directement les rÃ©sultats rms de l'image analyser
        if S.rep.gamma ~= 1
            disp('gamma camÃ©ra n''est pas Ã  sa valeur correcte') % test sur la valeur de gamma
            return
        else
            Max_ROI = max(max(image_matrice)); % abus de language..
            sigma_z = S.rep.sigmaz ;   % Ã©change des axes ?
            sigma_x = S.rep.sigmax;
            figure(4);
            plot(S.rep.fitX.value,'k') ; 
            hold on ; plot(S.rep.X.value,'r') ;
            xlabel('numero de pixel'); legend('fit H de l''ImageAnalyser','DonnÃ©es brutes H');
            %hold off
            figure(10)
            plot(S.rep.fitZ.value,'k') ;
            hold on ; plot(S.rep.Z.value,'b') ; legend('fit V de l''ImageAnalyser','DonnÃ©es brutes V')
            xlabel('numero de pixel');
            %hold off
        end
    end
    %%%%%%%%%%%%%%%wV = 10e-6 ; %%%%%%%%%%%%%%%%%%%%%%% !!!
    sigmae = 0 ;
    etaz = 0 ;
    etapz = 0 ;
    betaz = 15.78 ;
    alphaz = 0.88 ;
    gammaPMz = (1 + alphaz)/betaz ;
    eps_z = fun(EkeV,sigma_z,TV2,wV,yp_siph_ref,EkeV_ref,d,D,NBPIXEL,NBCONVCRENEAU,NonLin,sigmae,etaz,etapz,betaz,alphaz,gammaPMz);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plan horizontal
%     sigmae = 1e-3 ;
%     eta = 0.018 ;
%     etap = -0.035 ;
%     beta = 0.37 ;
%     alpha = 0.038 ;
    sigmae = 1.016e-3 ;
    etax = 0.0171 ;
    etapx = -0.0323 ;
    betax = 0.3677 ;
    alphax = 0.0825 ;
    gammaPMx = (1 + alphax)/betax;
    eps_x = fun(EkeV,sigma_x,TH2,wH,yp_siph_ref,EkeV_ref,d,D,NBPIXEL,NBCONVCRENEAU,NonLin,sigmae,etax,etapx,betax,alphax,gammaPMx);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    K = eps_z / eps_x;
    eps_x_vect = [eps_x_vect eps_x];
    eps_z_vect = [eps_z_vect eps_z];
    sigma_z_vect = [sigma_z_vect sigma_z];
    sigma_x_vect = [sigma_x_vect sigma_x];
    Gonio_vect = [Gonio_vect S.rep.pos_gonio_pinhole];
    K_vect = [K_vect K];
    if Calcul==0
        RES = [Idcct eps_x*1e9 eps_z*1e12 K*100 double(Max_ROI)]; % RES = [Iqt1 eps_x*1e9 eps_z*1e11 K*100 SH*1e6 SV*1e6];
        fprintf('%8.2f  %8.2f  %10.2f  %10.2f  %10.2f \n',RES )
        IQT = [IQT Iqt1];
    else
        RES = [Idcct eps_x*1e9 eps_z*1e12 K*100 double(Max_ROI) double(EkeV/1000) Att S.rep.pos_gonio_pinhole]; % RES = [Iqt1 eps_x*1e9 eps_z*1e11 K*100 SH*1e6 SV*1e6];
        fprintf('%8.2f  %8.2f  %10.2f  %12.2f %12.2f  %10.1f  %8.0f  %6.0f \n',RES )
        
%        Iqt1 = S.rep.QT1;
 %       IQT = [IQT Iqt1];
    end
    %S = [150 100 50 29.7]
    %e = [1.0252e-09 4.3767e-10 1.0688e-10 3.7522e-11]
    % Couplage (%)---SigmaX source (Âµm) SigmaZ source (Âµm)
    %plot(S,e)

    ; %fprintf('%8.2f  %8.2f  %8.2f  %8.2f  %8.2f  %8.2f \n',RES );
%     ATT = [ATT Att];
%     RES = [Att Max_ROI sigma_x sigma_z];
%     fprintf('%8.2f  %8.2f  %10.2f  %10.2f  \n',RES );
end

figure(9)
plot(ATT,sigma_z_vect,'bo-')
xlabel('Position de l''attÃ©nuateur en nb pas')
ylabel('Sigma Z [nb pixels]')
figure(11)
plot(ATT,sigma_x_vect,'ro-')
xlabel('Position de l''attÃ©nuateur en nb pas')
ylabel('Sigma X [nb pixels]')
figure(12)
plot(ATT,eps_x_vect*1e9,'ro-');
xlabel('Position de l''attÃ©nuateur en nb pas')
ylabel('Emittance X [nmrad]')
figure(13) ; hold on ; plot(ATT,eps_z_vect*1e12,'bo-')
xlabel('Position de l''attÃ©nuateur en nb pas')
ylabel('Emittance Z [pmrad]')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IQTtheor = [-7 -6 -3 0 3 6 7];
% IQTtheor = -7:1:7;
% Ktheor = [1.94 1.43 0.52 0 0.52 1.43 1.94 ];
% Ktheor = [1.94 1.44 1.0 0.64 0.36 0.16 0.04 0 0.04 0.16 0.36 0.64 1.0 1.44 1.94];
% figure(7);plot(IQT,K_vect*100,couleur)
% hold on
% plot(IQTtheor,Ktheor,'bo-')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fit thÃ©orie / mesure
% IQTtheorb = IQTtheor + offsetQT1 ;
% Ktheorb = Ktheor + offsetK ;
% hold on
% plot(IQTtheorb,Ktheorb,'bo--')
% title('Mesure du couplage en fonction de QT nï¿½1')
% legend('mesure / gamma = 0.62','thï¿½orie / machine parfaite','dï¿½calage thï¿½orie')
% xlabel('Courant dans QT nï¿½1');ylabel('couplage en %')

disp('c''est fini')

function emittance = fun(EkeV,Nbpixelsmes,T2,w,yp_siph_ref,EkeV_ref,d,D,NBPIXEL,NBCONVCRENEAU,NonLin,sigmae,eta,etap,beta,alpha,gammaPM)
% calcul d'Ã©mittance
% INPUTS
% Nbpixelsmes = valeur rms du faisceau en nb pixels
% T2, etc .. voir plus haut
%
%
% Smes = 24.3*(D/d)*1e-6 % test
%Smes = NbpixelsmesV * TV2/2.35 % mesure Ã  partir de la largeur Ã  mi-hauteur
Smes = Nbpixelsmes * T2 ;% mesure Ã  partir du rms
%Svrai = Smes / (D/d) % S electron si pinhole infiniment petite et pas dediffraction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Emax = 25e3; % 25 keV
lambda = 1.24e-6*1/EkeV ;
Sdiffraction = sqrt(12) * lambda * D / (w * 4 * pi); % diffraction Fraunhofer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Scamera = NBPIXEL * T2;                    % rÃ©solution camera
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Spinhole = w * (D + d)/d / NBCONVCRENEAU ;  % effet gÃ©ometrique du trou pinhole A DISCUTER !
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Smes = Smes/NonLin;                         % effet de la non-linÃ©aritÃ© de la camera
S = sqrt(Smes*Smes - Scamera*Scamera - Sdiffraction*Sdiffraction - Spinhole*Spinhole) ;% S electron en tenant compte des tous les effets
%S = sqrt(Smes*Smes - Scamera*Scamera -  Spinhole*Spinhole) ;        % S electron sans diffraction

%S = S * ( d/D); % grandissement pinhole

%yp_siph = 1/(2.750e3/0.511)*(EkeV_ref / EkeV )^(1/2);
yp_siph = 0.5e-3 ;
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
