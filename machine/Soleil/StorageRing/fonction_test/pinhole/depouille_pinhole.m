
% S = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-05_08-14-22_1-4mA.mat');
% Zp = S.rep.Z.value;
% figure(2) ; hold on ; plot(X,(Zp(52:131)-min(Zp)*1.02)/(max(Zp)-min(Zp)*1.02),'r')
% S = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-05_06-49-48_210mA.mat');
% Zp = S.rep.Z.value;
% figure(2) ; hold on ; plot((Zp-min(Zp))/(max(Zp)-min(Zp)))

S1 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_18-57-16_V_-280.mat');
S2 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_18-58-53_V_-380.mat');
S3 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-00-45_V_-480.mat');
S4 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-02-00_V_-580.mat');
S5 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-05-55_V_-180.mat');
S6 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-06-53_V_-80.mat');
S7 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-07-42_V_20.mat');
S8 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-08-35_V_120.mat');
 S9 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-10-26_V_120.mat');
S10 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-11-47_V_220.mat');
 S11 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-13-41_V_320.mat');
S12 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-14-56_V_420.mat');
S13 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-14-56_V_420_bis.mat');
S14 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-17-52_V_-680.mat');
S15 = load('-mat','/home/matlabML/measdata/Ringdata/PINHOLE/Pinhole_2007-02-03_19-18-53_V_-780.mat');


for s = 8:1:8
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if s == 1 S = S1 ; elseif s == 2  S = S2; elseif s == 3 S = S3; elseif s == 4 S = S4; 
    elseif s == 5 S = S5; elseif s == 6 S = S6; elseif s == 7 S = S7; elseif s == 8 S = S8; 
    elseif s == 9 S = S9; elseif s == 10 S = S10; elseif s == 11 S = S11; elseif s == 12 S = S12; 
    elseif s == 13 S = S13; elseif s == 14 S = S14; elseif s == 15 S = S15 ; 
   end
   
   %%% calcul de l'énergie transmise
    x = [5115 5178 5256 5880 6661 12903 20706]; % recherche de l'énergie pic en fonction de la valeur atténuateur
    y = 1e3*[24.55 28.5 31.5 45.9 54.1 80.7 95];
    xx = 5000:1:21000;
    yy = spline(x,y,xx);
    Att = S.rep.attenuateur;
    if Att>5077
        I = find(xx==Att);
        EkeV = yy(I);
    else
        EkeV = 21.e3;         % 21 keV sans Atténuateur
    end
    EkeV
    lambda = 1.24e-6*1/EkeV ;
    w = 10e-6 ;
    d =  4.346;                               % distance source - pinhole 4.356
    D =  5.721 ;
    NBPIXEL = 1.7  ;                          % nb de pixel résolution camera
    NBCONVCRENEAU = sqrt(12) ;                %sqrt(12) % 3 ; % facteur de déconvolution du créneau (alternative : 3)
    T2 = 7.4e-6/2.60 ;
    Sdiffraction = sqrt(12) * lambda * D / (w * 4 * pi)
    Scamera = NBPIXEL * T2;                    % résolution camera
    Spinhole = w * (D + d)/d / NBCONVCRENEAU ;
    Nbpixelsmes = S.rep.sigmaz/S.rep.pixelsize ;
    Smes = Nbpixelsmes * T2 
    Si = sqrt(Smes*Smes - Scamera*Scamera - Sdiffraction*Sdiffraction - Spinhole*Spinhole) % taille rms déconvoluée du faisceau sur le convertisseur
    sigmae = 0 ;
    eta = 0 ;
    etap = 0 ;
    beta = 15.78 ;
    alpha = 0.88 ;
    gammaPM = (1 + alpha)/beta ;
    yp_siph = 0.5e-3 ;
SV = Si * ( d/D); % taille rms au point source dans le dipole
a = sigmae*sigmae*(eta*eta*gammaPM + etap*etap*beta + 2*eta*etap*alpha) + beta * yp_siph*yp_siph;
b = sigmae*sigmae * eta*eta * yp_siph*yp_siph;
c = (Si*Si / (D*D)) * (beta + 2 * alpha * d + gammaPM * d *d);
e = (Si*Si / (D*D)) * ((eta - etap*d)*(eta - etap*d) * sigmae * sigmae + d*d * yp_siph*yp_siph);

emittance = (c - a + sqrt((c - a).*(c - a) - 4*(b - e)))/2
disp('hello');
    %    figure(4) ; hold on
    %    Zp = S.rep.fitZ.value;
%    I = find(Zp == max(Zp)) 
%    plot((Zp(I-70 : I+70)-min(Zp))/(max(Zp)-min(Zp)),'k')
end