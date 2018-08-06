function [eps_x eps_z rms_x_source rms_z_source] = getpinhole(varargin)
% GETPINHOLE enregistre les images de la caméra pinhole avec les paramètres
% environnants.
% ATTENTION les devices emittance et Image Analyser doivent etre opérationnels
% et la "Region Of Interest" de l'image analyser optimisée
% INPUTS
% 'Display' affiche l'image enregistrée (par défaut)
% 'NoDisplay' le contraire..
% 'Archive' sauvegarde la structure matlab (par défaut)
% 'NoArchive' le contraire..
%
%  OUTPUTS
%  1. eps_x - Horizontal emittance
%  2. eps_z - Vertical emittance
%  3. rms_x_source - Horizontal beam size at the source point
%  4. rms_z_source - Horizontal beam size at the source point

%
% Written By Marie-Agnes Tordeux and Laurent S. Nadolski
% Modification Laurent S. Nadolski, May 25th, 2007
%   output variable to be used in scripts with no graphical interface.
%   Update new Tango interface for PHC-IMAGEANALYZER

DisplayFlag = 1;
ScriptFlag  = 0; % no message to be used within script

ArchiveFlag = 1;

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoArchive')
        ArchiveFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Script')
        ScriptFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoScript')
        ScriptFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Archive')
        ArchiveFlag = 1;
        varargin(i) = [];
    end
end

% Starting time
t0 = clock;
FileName = '';
dev = 'ANS-C02/DG/PHC-VG';
devAna = 'ANS-C02/DG/PHC-IMAGEANALYZER';
devatt = 'ANS-C02/DG/PHC-M.ATT';
devpoint = 'ANS-C02/DG/PHC-M.CAM1.VERT';
devposH     = 'ANS-C02/DG/PHC-M.CAM2_HORZ';
devposV     = 'ANS-C02/DG/PHC-M.CAM2_HORZ2';
devpinholeH = 'ANS-C02/DG/PHC-M.PH_HORZ';
devpinholeV = 'ANS-C02/DG/PHC-M.PH_VERT';
devpinholegonio = 'ANS-C02/DG/PHC-M.PH_GONIO';
devpinholerot = 'ANS-C02/DG/PHC-M.PH_ROT';
devemit = 'ANS-C02/DG/PHC-EMIT';

temp=tango_read_attribute2(dev,'image');
ImagePHC = temp.value';
rep.image = ImagePHC;
rep.current = getdcct;
%rep.pixelsize = readattribute([devAna '/PixelSize']);
rep.growth = readattribute([devAna '/OpticalMagnification']);
rep.pixelsizex = readattribute([devAna '/PixelSizeX']);
rep.pixelsizez = readattribute([devAna '/PixelSizeY']);
rep.gamma = readattribute([devAna '/GammaCorrection']);
rep.sigmax = readattribute([devAna '/XProfileSigma']);
rep.magnitudex = readattribute([devAna '/XProfileMag']);
rep.sigmaz = readattribute([devAna '/YProfileSigma']);
rep.magnitudez = readattribute([devAna '/YProfileMag']);
rep.attenuateur = readattribute([devatt '/AxisCurrentPosition']);
rep.pos_H_pinhole =  readattribute([devpinholeH '/AxisCurrentPosition']); % position H de la pinhole
rep.pos_V_pinhole =  readattribute([devpinholeV '/AxisCurrentPosition']); % position V de la pinhole
rep.pos_gonio_pinhole = readattribute([devpinholegonio '/AxisCurrentPosition']); % position gonio de la pinhole
rep.pos_rot_pinhole = readattribute([devpinholerot '/AxisCurrentPosition']); % position rotation de la pinhole
%rep.point = readattribute([devpoint '/AxisCurrentPosition']); % mise au point camera 2
rep.posH = readattribute([devposH '/AxisCurrentPosition']); % position horizontale camera 2
rep.posV = readattribute([devposV '/AxisCurrentPosition']); % position verticale (vis à vis du convertisseur) camera 2
rep.X = tango_read_attribute2(devAna,'XProfile');
rep.Z = tango_read_attribute2(devAna,'YProfile');
rep.fitX = tango_read_attribute2(devAna,'XProfileFitted');
rep.fitZ = tango_read_attribute2(devAna,'YProfileFitted');
rep.GaussianFitTilt = readattribute([devAna '/GaussianFitTilt']);
rep.pinholesizeV = readattribute([devemit '/PinholeSizeV']);
rep.pinholesizeH = readattribute([devemit '/PinholeSizeH']);
%rep.QT1 = getam('QT', [1 1])

if DisplayFlag
    %figure(101);
    figure
    image(ImagePHC,'CDataMapping','scaled','Parent',gca)
    %figure(105);
    figure
    plot(rep.fitX.value,'k') ; hold on ; plot(rep.X.value,'r') ;
    xlabel('numero de pixel')
    plot(rep.fitZ.value,'p') ; hold on ; plot(rep.Z.value,'b') ; legend('fit H de l''ImageAnalyser','Données brutes H','fit V de l''ImageAnalyser','Données brutes V')
    xlabel('numero de pixel')
    title('Profils H et V projetés dans la région d''interet (ROI)');
    hold off
    %%%%%%%%%%%%%%% WARNING

end

%%% test du gamma
if rep.gamma ~= 1
    disp('gamma caméra n''est pas à sa valeur correcte') % test sur la valeur de gamma
    return
end

%%% pixel intensité max
Max_image_brute = max(max(ImagePHC));
warning_intensite = 0;
if Max_image_brute>890
    disp('l''image est saturée - modifier l''atténuateur') % test sur la saturation de l'image
    RES = [double(Max_image_brute)];
    fprintf('max pixel =  %13.2f \n',RES )
    %return
elseif Max_image_brute<300
    warning_intensite = 1;
end

%%%%%%%%%%%%%%% calcul d'émittance

%%% calcul de l'énergie transmise
x = [5115 5178 5256 5880 6661 12903 20706]; % recherche de l'énergie pic en fonction de la valeur atténuateur
y = 1e3*[24.55 28.5 31.5 45.9 54.1 80.7 95];

%x = [4954 5015 5089 5686 6433 12403 19867];


xx = 4900:1:21000;
yy = spline(x,y,xx);
Att = rep.attenuateur;
if Att> 4980               % 5077 anciennement
    I = find(xx==Att);
    EkeV = yy(I);
else
    EkeV = 21.e3;         % 21 keV sans Atténuateur
end

%%% données
%gamma = 1  ;  NonLin = 1./sqrt(gamma) ;   % NonLin = 1./sqrt(0.45)   %  NonLin = 1. % Facteur gamma de la camera
NBPIXEL = 1.7  ;                          % nb de pixel résolution camera
NBCONVCRENEAU = sqrt(12) ;                %sqrt(12) % 3 ; % facteur de déconvolution du créneau (alternative : 3)
yp_siph_ref = 1/(2.75e3/0.511) ;          % emission de photon - energie 20 keV ? 0.13 mrad !
EkeV_ref = 8.5e3;
TV2 = rep.pixelsizex*1e-6/rep.growth ;    % 2.60 TV2  en µm/pixel sur le plan convertisseur   7.5e-6/2.60
TH2 = rep.pixelsizez*1e-6/rep.growth;     %2.60 TH2 = 11.4e-6 % 13.38e-6 ;  % Grandissement H camera 2
wV = rep.pinholesizeV*1e-6 ;              % taille pinhole Verticale
wH = rep.pinholesizeH*1e-6 ;              % taille pinhole Horizontale
d =  4.346;                               % distance source - pinhole 4.356
D =  5.721 ;                              % distance pinhole - convertisseur  5.695

%%% profils -

%sigma_x = rep.sigmax / rep.pixelsize ;   % rms du fit gaussien de l'ImageAnalyser exprimé en nombre de pixels, sur la CCD
%sigma_z = rep.sigmaz / rep.pixelsize ;

sigma_x = rep.sigmax / (rep.pixelsizex/rep.growth) ;   % rms du fit gaussien de l'ImageAnalyser exprimé en nombre de pixels, sur la CCD
sigma_z = rep.sigmaz / (rep.pixelsizez/rep.growth) ;


sigmae = 0 ;
eta = 0 ;
etap = 0 ;
beta = 15.78 ;
alpha = 0.88 ;
gammaPM = (1 + alpha)/beta ;
[eps_z rms_z_conv rms_z_source rms_z_convavantdec] = fun(EkeV,sigma_z,TV2,wV,yp_siph_ref,EkeV_ref,d,D,NBPIXEL,NBCONVCRENEAU,sigmae,eta,etap,beta,alpha,gammaPM);

sigmae = 1.016e-3 ;
eta = 0.0171 ;
etap = -0.0323 ;
beta = 0.3677 ;
alpha = 0.0825 ;
gammaPM = (1 + alpha)/beta;
[eps_x rms_x_conv rms_x_source rms_x_convavantdec] = fun(EkeV,sigma_x,TH2,wH,yp_siph_ref,EkeV_ref,d,D,NBPIXEL,NBCONVCRENEAU,sigmae,eta,etap,beta,alpha,gammaPM);

K = eps_z / eps_x;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ArchiveFlag
    toto = 0;
    if isempty(FileName)
        FileName = appendtimestamp(getfamilydata('Default', 'PINHOLEArchiveFile'));
        DirectoryName = getfamilydata('Directory', 'PINHOLE');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot'), 'Response', filesep, 'BPM', filesep];
        else
            % Make sure default directory e('l''image est saturée - modifier l''atténuateur')xists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select a Pinhole File ("Save" starts measurement)', [DirectoryName FileName]);
        if FileName == 0
            ArchiveFlag = 0;
            disp('   Pinhole registration canceled.');
            toto = 1;
            %return
        else
            FileName = [DirectoryName, FileName];
        end

    elseif FileName == -1
        FileName = appendtimestamp(getfamilydata('Default', 'QUADArchiveFile'));
        DirectoryName = getfamilydata('Directory', 'QUAD');
        FileName = [DirectoryName, FileName];
    end

    rep.CreatedBy = 'getpinhole';
    rep.t         = t0;
    rep.tout      = etime(clock,t0);
    rep.TimeStamp = datestr(clock);
    if toto == 0
        save(FileName,'rep');
    end
    fprintf('Data save in filename %s \n', FileName);
    %fprintf('***************************************************************** \n');

end

if ~ScriptFlag

fprintf('*********** paramètres instrumentation pinhole **************** \n');
fprintf('atténuateur (nb pas) %22.2f \n',rep.attenuateur);
fprintf('position H de la pinhole %18.2f \n',rep.pos_H_pinhole);
fprintf('position V de la pinhole %18.2f \n',rep.pos_V_pinhole);
fprintf('position gonio de la pinhole %14.2f \n',rep.pos_gonio_pinhole);
fprintf('position rotation de la pinhole %11.2f \n',rep.pos_rot_pinhole);
fprintf('position H de la camera du bas %12.2f \n',rep.posH);
fprintf('position V de la camera du bas %12.2f \n',rep.posV);
fprintf('Grandissement de la partie visible %12.2f \n',rep.growth);
fprintf('Taille des pinholes en microns: %12.2f  H et %5.2f V\n',rep.pinholesizeH,rep.pinholesizeV);
%fprintf('mise au point de la camera du bas %9.2f \n',rep.point);
fprintf('*********** paramètres faisceau généraux ********************** \n');
fprintf('courant dcct %20.2f \n', rep.current);
fprintf('chromaticité x  \n');
fprintf('chromaticité z  \n');
% fprintf('courant QT1  %4.2f \n', rep.QT1);
fprintf('***** paramètres faisceau Visible sur la CCD ****************** \n');
fprintf('sigmax sur la CCD en nb pixels %11.2f \n', sigma_x);
%fprintf('intensité max x %10.2f \n', rep.magnitudex);
fprintf('sigmaz sur la CCD en nb pixels %10.2f \n', sigma_z);
fprintf('intensité du pixel max %17.2f \n',Max_image_brute);
fprintf('***** paramètres faisceau sur convertisseur X-> visible ******* \n');
fprintf('sigmax au convertisseur avant déconvolution en µm %14.2f \n',rms_x_convavantdec*1e6);
fprintf('sigmaz au convertisseur avant déconvolution en µm %14.2f \n',rms_z_convavantdec*1e6);
fprintf('sigmax au convertisseur après déconvolution en µm %14.2f \n', rms_x_conv*1e6);
%fprintf('intensité max x %10.2f \n', rep.magnitudex);
fprintf('sigmaz au convertisseur après déconvolution en µm %14.2f \n', rms_z_conv*1e6);
fprintf('Energie pic des photons X (keV)  %21.2f \n',EkeV*1e-3);
fprintf('********* paramètres faisceau au point source ***************** \n');
fprintf('sigmax en µm %25.2f \n', rms_x_source*1e6);
%fprintf('intensité max x %10.2f \n', rep.magnitudex);
fprintf('sigmaz en µm %25.2f \n', rms_z_source*1e6);
%fprintf('intensité max pixel  %4.2f \n',Max_image_brute);
fprintf('tilt de l''ellipse en degré %15.2f \n', rep.GaussianFitTilt*1000/17);


fprintf('******************************************************************************************************* \n');
fprintf('---I dcct (mA)-----Emittance X(nm)---Emittance Z(pm)----Couplage (10-2) \n')
RES = [rep.current eps_x*1e9 eps_z*1e12 K*100];
fprintf('%8.2f  %16.2f  %18.2f  %18.2f  \n',RES)
fprintf('******************************************************************************************************* \n');

end

if warning_intensite == 1
        disp('   Attention l''illumination de la camera est faible ');
        disp('   veillez à recommencer en diminuant l''atténuateur ');
end


function [emittance S SV Smes] = fun(EkeV,Nbpixelsmes,T2,w,yp_siph_ref,EkeV_ref,d,D,NBPIXEL,NBCONVCRENEAU,sigmae,eta,etap,beta,alpha,gammaPM)
% calcul d'émittance

% Smes = 24.3*(D/d)*1e-6 % test
%Smes = NbpixelsmesV * TV2/2.35 % mesure à partir de la largeur à mi-hauteur
Smes = Nbpixelsmes * T2 ;% taille rms brute du faisceau sur le convertisseur
%Svrai = Smes / (D/d) % S electron si pinhole infiniment petite et pas dediffraction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambda = 1.24e-6*1/EkeV ;
Sdiffraction = sqrt(12) * lambda * D / (w * 4 * pi); % diffraction Fraunhofer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Scamera = NBPIXEL * T2;                    % résolution camera
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Spinhole = w * (D + d)/d / NBCONVCRENEAU ;  % effet géometrique du trou pinhole A DISCUTER !
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S = sqrt(Smes*Smes - Scamera*Scamera - Sdiffraction*Sdiffraction - Spinhole*Spinhole) ;% taille rms déconvoluée du faisceau sur le convertisseur
%S = sqrt(Smes*Smes - Scamera*Scamera -  Spinhole*Spinhole) ;        % idem sans diffraction

%S = S * ( d/D); % grandissement pinhole

%yp_siph = yp_siph_ref *(EkeV_ref / EkeV )^(1/2);
yp_siph = 0.5e-3 ;
SV = S * ( d/D); % taille rms au point source dans le dipole
a = sigmae*sigmae*(eta*eta*gammaPM + etap*etap*beta + 2*eta*etap*alpha) + beta * yp_siph*yp_siph;
b = sigmae*sigmae * eta*eta * yp_siph*yp_siph;
c = (S*S / (D*D)) * (beta + 2 * alpha * d + gammaPM * d *d);
e = (S*S / (D*D)) * ((eta - etap*d)*(eta - etap*d) * sigmae * sigmae + d*d * yp_siph*yp_siph);

emittance = (c - a + sqrt((c - a).*(c - a) - 4*(b - e)))/2;
%disp('hello');


% S = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-05_08-14-22_1-4mA.mat');
% Zp = S.rep.Z.value;
% figure(2) ; hold on ; plot(X,(Zp(52:131)-min(Zp)*1.02)/(max(Zp)-min(Zp)*1.02),'r')
% S = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-05_06-49-48_210mA.mat');
% Zp = S.rep.Z.value;
% figure(2) ; hold on ; plot((Zp-min(Zp))/(max(Zp)-min(Zp)))