function depouille_beta

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mesures tirées du model 

%% (Quadrupoles non coupés en 2 : 
% beta en entrée de quad - mais cohérent avec la matrice d'efficacité
% calculée)    ! ! regler nux et nuz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% switch2sim;
% betaX = [];betaZ = [];
% Indexquad = family2atindex({'Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10'});% Index of quadrupoles
% [BetaX, BetaZ] = modelbeta; % beta function everywhere
% for j = 1:1:10
%             bX = BetaX(Indexquad{j}); % measure H beta function in each quad
%             betaX = [betaX bX'];
%             bZ = BetaZ(Indexquad{j}); % measure V beta function in each quad
%             betaZ = [betaZ bZ'];
% end
% betaX
% %figure(12)
% %plotbeta
% %%%%%%%%%% verification du calcul parfait
% %deltabetameasX = betaX'/100 ; deltabetameasZ = betaZ'/100 ; 

%% beta calculés comme sur la machine
% avec les tunes - resultats enregistrés 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S = load('-mat','/home/matlabML/measdata/Ringdata/QUAD/Sauvegarde_beta_theorique_0_2_0_3.mat')
betaX = S.betatheorX ; betaZ = S.betatheorZ ;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% enregistrer les fonctions beta mesurées le 10 juin
% plan horizontal  nux = 0.4 nuz = 0.3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% methode copie colle..
% betaQ1 = [14.590 13.958 14.590 15.645 12.946 13.157 11.090 12.102]
% betaQ2 = [25.422 23.233 24.778 25.743 22.268 22.332 22.332 20.723]
% betaQ3 = [10.215 8.214 9.162 10.742 8.214 8.741 9.267 8.741]
% betaQ4 = [2.490 3.080 2.658 2.658 2.658 2.658 3.080 2.869 ...
%          2.447 2.658 2.658 2.447 2.236 2.447 2.869 2.658]
% betaQ5 = [12.815 13.239 13.451 13.649 14.144 14.321 14.144 14.321 ...
%           12.801 13.154 12.093 11.598 11.386 12.801 8.274 7.921]
% betaQ6 = [4.132 5.144 5.565 4.511 4.933 4.722 4.722 5.144 ...
%           4.722 4.933 5.144 5.354 4.511 4.511 4.722 4.933 ...
%           5.945 3.921 4.132 6.155 4.764 4.553 5.945 4.764]
% betaQ7 = [11.943 17.249 15.652 12.574 13.837 14.521 13.206 14.363 ...
%           13.100 14.626 14.626 13.337 13.600 14.889 12.337 15.784 ...
%           17.204 11.154 11.285 17.441 14.258 13.653 16.915 12.416]
% betaQ8 = [4.297 5.886 5.886 4.738 5.032 5.032 5.032 5.150 ...
%           5.179 5.179 5.179 4.738 4.738 5.179 4.738 5.591 ...
%           4.179 4.179 4.002 6.151 5.562 5.032 6.033 4.297]
% betaQ9 = [3.533 3.533 3.107 2.469 2.682 2.894 3.107 2.894 ...
%           2.682 3.107 3.320 3.107 3.107 3.959 3.533 3.107]
% betaQ10 = [18.026 18.281 15.560 14.497 14.115 14.922 17.218 17.218 ...
%            14.752 16.368 19.939 18.281 17.218 19.301 18.664 16.623]
%        
% betameasX = [betaQ1 betaQ2 betaQ3 betaQ4 betaQ5 betaQ6 betaQ7 betaQ8 betaQ9 betaQ10]' % size(betameas)
% deltabetameasX = betameasX - betaX'
% 
% betaQ1 = [10.458 11.512 11.301 11.934 10.922 11.934 10.078 12.524]
% betaQ2 = [5.664 6.629 6.629 6.951 5.664 7.916 6.629 7.208]
% betaQ3 = [10.847 11.900 11.900 12.321 11.374 11.900 11.374 12.848]
% betaQ4 = [16.035 17.892 18.314 16.879 15.866 17.512 18.736 17.934 ...
%           16.035 17.512 18.525 17.090 16.246 17.723 19.115 18.145 ]
% betaQ5 = [ 6.238 7.044 6.832 6.365 6.542 6.895 7.072 6.931 ...
%            6.223 5.870 6.860 6.506 5.870 7.214 4.455 4.880]
% betaQ6 = [ 14.377 13.407 13.196 10.287 13.997 14.377 14.208 12.943 ...
%           10.920 11.341 13.787 12.943 10.709 14.377 14.166 10.877 ...
%           13.576 14.798 14.377 12.732 10.287 10.709 14.630 15.009]
% betaQ7 = [ 4.893 3.833 3.604 3.735 4.235 4.867 4.735 4.235 ...
%            3.867 3.735 4.235 4.604 4.735 3.998 3.604 3.867 ...
%            4.367 4.761 4.998 3.709 3.735 3.735 4.367 4.656]
% betaQ8 = [ 6.886 5.739 5.179 5.179 5.768 6.592 6.886 5.444 ...
%            5.327 5.327 6.298 6.445 6.445 5.621 5.150 5.297 ...
%             6.592 6.592 6.592 5.327 4.797 5.474 6.298 6.739]
% betaQ9 = [ 17.026 12.685 12.897 17.622 16.813 14.132 13.919  17.239...
%            16.218 13.876 13.664 17.239 16.388 13.493 13.068 17.878]
% betaQ10 = [ 4.804 3.529 3.529 5.399 4.762 4.124 3.699 5.399 ...
%             4.974 3.741 3.741 4.804 4.804 3.529 3.741 5.399]
% betameasZ = [betaQ1 betaQ2 betaQ3 betaQ4 betaQ5 betaQ6 betaQ7 betaQ8 betaQ9 betaQ10]' % size(betameas)
% deltabetameasZ = betameasZ - betaZ'
% 
% deltabetameas = [deltabetameasX'  deltabetameasZ']'

% methode structure matlab
%%%%%%%%%%%%%%%%%% machine presque symetrique du mois de septembre
% NameQ1 = '/home/matlabML/measdata/Ringdata/QUAD/Q1Beta_2006-09-08_14-05-50.mat';
% NameQ2 = '/home/matlabML/measdata/Ringdata/QUAD/Q2Beta_2006-09-08_15-07-17.mat';
% NameQ3 = '/home/matlabML/measdata/Ringdata/QUAD/Q3Beta_2006-09-09_02-02-34.mat';
% NameQ4 = '/home/matlabML/measdata/Ringdata/QUAD/Q4Beta_2006-09-09_02-40-47.mat';
% NameQ5 = '/home/matlabML/measdata/Ringdata/QUAD/Q5Beta_2006-09-09_03-51-58.mat';
% NameQ6 = '/home/matlabML/measdata/Ringdata/QUAD/Q6Beta_2006-09-09_04-16-07.mat';
% NameQ7 = '/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_2006-09-09_19-09-36.mat';
% NameQ8 = '/home/matlabML/measdata/Ringdata/QUAD/Q8Beta_2006-09-09_19-41-28.mat';
% NameQ9 = '/home/matlabML/measdata/Ringdata/QUAD/Q9Beta_2006-09-09_20-05-50.mat';
% NameQ10 = '/home/matlabML/measdata/Ringdata/QUAD/Q10Beta_2006-09-09_21-28-26.mat';
%%%%%%%%%%%%%%%%%% machine assymetrique du mois de juin-juillet
NameQ1 = '/home/matlabML/measdata/Ringdata/QUAD/Q1Beta_2006-10-01_20-51-33.mat';
NameQ2 = '/home/matlabML/measdata/Ringdata/QUAD/Q2Beta_2006-10-01_20-59-24.mat';
NameQ3 = '/home/matlabML/measdata/Ringdata/QUAD/Q3Beta_2006-10-01_21-08-17.mat';
NameQ4 = '/home/matlabML/measdata/Ringdata/QUAD/Q4Beta_2006-10-01_21-14-55.mat';
NameQ5 = '/home/matlabML/measdata/Ringdata/QUAD/Q5Beta_2006-10-01_21-36-02.mat';
NameQ6 = '/home/matlabML/measdata/Ringdata/QUAD/Q6Beta_2006-10-01_21-46-20.mat';
%NameQ7 = '/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_2006-10-01_22-00-27.mat';
NameQ7 = '/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_2006-10-08_16-54-54.mat';
NameQ8 = '/home/matlabML/measdata/Ringdata/QUAD/Q8Beta_2006-10-01_22-18-11.mat';
NameQ9 = '/home/matlabML/measdata/Ringdata/QUAD/Q9Beta_2006-10-01_22-32-14.mat';
NameQ10 = '/home/matlabML/measdata/Ringdata/QUAD/Q10Beta_2006-10-01_22-43-12.mat';

betameasX = [];betameasZ = [];
for k = 1:10
    NameFile = strcat('NameQ',num2str(k));
    if k == 1 S = load('-mat',NameQ1);
    elseif k == 2 S = load('-mat',NameQ2);
    elseif k == 3 S = load('-mat',NameQ3);
    elseif k == 4 S = load('-mat',NameQ4);
    elseif k == 5 S = load('-mat',NameQ5);
    elseif k == 6 S = load('-mat',NameQ6);
    elseif k == 7 S = load('-mat',NameQ7);
    elseif k == 8 S = load('-mat',NameQ8);
    elseif k == 9 S = load('-mat',NameQ9);
    elseif k ==10 S = load('-mat',NameQ10);
    end               
    QX = strcat('Q',num2str(k));
    BETA = S.AO.FamilyName.(QX).beta
    betax = BETA(:,1)';betaz = BETA(:,2)';
    betameasX = [betameasX betax]
    betameasZ = [betameasZ betaz]
    DirStart = pwd;
    DirectoryName = '/home/matlabML/measdata/Ringdata/QUAD/';
    [DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);
    try
        Nomfichier = 'Sauvegarde_beta_sept06';
        save(Nomfichier,'betameasX','betameasZ');
    catch
        cd(DirStart);
        return
    end
    cd(DirStart);
    
end
% % graphe des beta theoriques / beta mesures
% figure(8);%plot(betaX,'r',betameasX,'k')
% plot(betaX); hold on ; plot(betameasX,'k')
% figure(9);%plot(betaX,'r',betameasX,'k')
% plot(betaZ); hold on ; plot(betameasZ,'k'); Ylim([0 30])

S = load('-mat','/home/matlabML/measdata/Ringdata/QUAD/Sauvegarde_beta_corr_2006_10_08.mat')
betameasX = S.betameasX_corr ; betameasZ = S.betameasZ_corr ;
deltabetameasX = betameasX' - betaX';  deltabetameasZ = betameasZ' - betaZ';
deltabetameas = [deltabetameasX'  deltabetameasZ']'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generer les fonctions beta dues à une modification d'1 ou plusieurs quad 
% dans le modele
% plan horizontal  nux = 0.4 nuz = 0.3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% betaX1 = [];betaZ1 = []; bX = []; bZ = [];
% %Ic = getam('Q1', [1 1],'Model');% get the actual current for quad Q1 [1 1]
% 
% DeltaI = 0.5; % change in amps
% stepsp('Q9', DeltaI, [6 1],'Model'); % Step value in Amps
% stepsp('Q10', DeltaI, [6 1],'Model'); % Step value in Amps
% stepsp('Q10', DeltaI, [6 2],'Model'); % Step value in Amps
% 
% %% méthode modelbeta
% % % [BetaX, BetaZ] = modelbeta; % beta function everywhere
% % % for j = 1:1:10
% % %     bX = BetaX(Indexquad{j}); % measure H beta function in each quad
% % %     betaX1 = [betaX1 bX'];
% % %     bZ = BetaZ(Indexquad{j}); % measure V beta function in each quad
% % %     betaZ1 = [betaZ1 bZ'];
% % % end
% 
% %% méthode comme sure la machine
% QuadFam = {'Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10'};
% beta_tune = mesure_beta(QuadFam)
% betaX1 = beta_tune(1,:);
% betaZ1 = beta_tune(2,:);
% 
% %%
% deltabetameasX = betaX1' - betaX'
% deltabetameasZ = betaZ1' - betaZ'
% 
% deltabetameas = [deltabetameasX'  deltabetameasZ']'
% stepsp('Q9', -DeltaI, [6 1],'Model'); % go back to initial values
% stepsp('Q10', -DeltaI, [6 1],'Model'); % go back to initial values
% stepsp('Q10', -DeltaI, [6 2],'Model'); % go back to initial values

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% valeurs nominales des courants  ! ! regler nux et nuz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% 1ère méthode : mesure sur la machine
IQnom = [];
for i = 1:10
    Name = strcat('Q',num2str(i));
    IQnom = [IQnom getam(Name)']
end
IQnom = IQnom';
   
DirStart = pwd;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sauvegarde
DirectoryName = '/home/matlabML/measdata/Ringdata/QUAD/';
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);
try
    Nomfichier = 'IQnom_machine_dissym_2006_10_08';
    save(Nomfichier,'IQnom');
catch
    cd(DirStart);
    return
end
cd(DirStart) ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% 2ème méthode : Iq sur fichier
S = load('-mat','/home/matlabML/measdata/Ringdata/QUAD/IQnom_machine_dissym_2006_10_08.mat'); % 
IQnom = S.IQnom  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chargement de la matrice efficacité des quad
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

directory = '/home/matlabML/mml/machine/Soleil/StorageRing/quad/';
%Name = 'Meffquad_Qnoncoupe_2_3';
%Name = 'Meffquad_Qnoncoupe_4_3_H_V';
%Name = 'Meffquad_Qnoncoupe_2_3_H_V';
Name = 'Meffquad_beta_tune_2_3_H_V';
filename = strcat(directory,Name);
S = load('-mat',filename);
Meffquad = S.Meffquad ; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calcul de la matrice efficacité
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cd mml/machine/Soleil/StorageRing/quad/  getrespquad('Archive')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calcul des variation de courants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Iquad = inv(Meffquad) * betameas
[U,S,V] = svd(Meffquad);
DiagS = diag(S)
% figure(17)
% semilogy(DiagS,'-sr'); grid on ; grid minor;
% xlabel('Eigenvalue number','FontSize',14) ;
% ylabel('eigenvalue value','FontSize',14) ; Ylim([0 25]);Xlim([0 160])
%% critère valeur propre n°1
liste = find(DiagS>max(DiagS)/100);
%nbvp = max(liste); 
nbvp = length(DiagS);
nbvp = 24 % nbvp de référence


    %% test des iterations
    % iteration n°1
Rmod1 = Meffquad * V(:,1:nbvp);
%B = Rmod\ (X );
B1 = Rmod1\ (deltabetameas); % 
%DeltaCM = V * B;
deltaIquad = V(:,1:nbvp) * B1 % delta in Amps
pourcIquad = deltaIquad./IQnom % delta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sauvegarde
DirStart = pwd;
DirectoryName = '/home/matlabML/measdata/Ringdata/QUAD/';
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);
try
    Nomfichier = 'solution_2006_10_08_nbvp24';
    save(Nomfichier,'deltaIquad');
catch
    cd(DirStart);
    return
end
cd(DirStart)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
bar(pourcIquad,'b') % bar graphe des quadrupoles par famille
% % xlabel('Quadrupole number presented by family') ;title(strcat('eigenvalue number =',num2str(nbvp')))
% % ylabel('delta IQ in pourcent')

% Indexlineaire = [Indexquad{1}(:)' Indexquad{2}(:)' Indexquad{3}(:)' Indexquad{4}(:)' ...
%     Indexquad{5}(:)' Indexquad{6}(:)' Indexquad{7}(:)' Indexquad{8}(:)' Indexquad{9}(:)'...
%     Indexquad{10}(:)'];
% Indexint = int16(Indexlineaire);
% [B, IX] = sort(Indexint); % IX numero dans le vecteur Indexquad
%pourcIquad_ordre_machine = pourcIquad(IX) 
%bar(pourcIquad_ordre_machine) % bar graphe des quadrupoles dans l'ordre de la machine
%xlabel('Quadrupole number in the machine order') ;title(strcat('eigenvalue number =',num2str(nbvp')))

% % SortbetameasX= betameasX(IX);
% % SortbetaX = betaX(IX);
% % figure(9);
% % grid on
% % plot(SortbetaX,'-ob'); hold on ; plot(SortbetameasX,'ok','MarkerFaceColor','k')

% %%%%%%%% critère valeur propre n°2
liste = find(DiagS>max(DiagS)/50);
liste = find(DiagS>max(DiagS)/4);
nbvp = max(liste);
nbvp = 23
%nbvp = 100;
Rmod1 = Meffquad * V(:,1:nbvp);
%B = Rmod\ (X );
B1 = Rmod1\ (deltabetameas); % 
%DeltaCM = V * B;
deltaIquad = V(:,1:nbvp) * B1 % delta in Amps
pourcIquad = deltaIquad./IQnom % delta in pourcent
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sauvegarde
% DirStart = pwd;
% DirectoryName = '/home/matlabML/measdata/Ringdata/QUAD/';
% [DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);
% try
%     Nomfichier = 'solution_2006_10_08_nbvp12';
%     save(Nomfichier,'deltaIquad');
% catch
%     cd(DirStart);
%     return
% end
% cd(DirStart)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold on %figure(5)
bar(pourcIquad,'r') ;
% % % xlabel('Quadrupole number presented by family'); ylabel('delta IQ /IQ')
% % % title(strcat('eigenvalue number =',num2str(nbvp')))
% 
% %pourcIquad_ordre_machine = pourcIquad(IX)
% %bar(pourcIquad_ordre_machine) ; xlabel('Quadrupole number in the machine order'); ylabel('delta IQ /IQ')
% %title(strcat('eigenvalue number =',num2str(nbvp'))) 
% 
% %% critère valeur propre n°3
liste = find(DiagS>max(DiagS)/10);
liste = find(DiagS>max(DiagS)/3);
nbvp = max(liste); 
nbvp = 22
%nbvp = 100;
Rmod1 = Meffquad * V(:,1:nbvp);
%B = Rmod\ (X );
B1 = Rmod1\ (deltabetameas); % 
%DeltaCM = V * B;
deltaIquad = V(:,1:nbvp) * B1 % delta in Amps
pourcIquad = deltaIquad./IQnom % delta in pourcent
hold on %figure(3)
bar(pourcIquad,'g') ; 
% % % xlabel('Quadrupole number presented by family') ; ylabel('delta IQ /IQ')
% % % title(strcat('eigenvalue number =',num2str(nbvp')))
% 
% %pourcIquad_ordre_machine = pourcIquad(IX)
% %bar(pourcIquad_ordre_machine) ; xlabel('Quadrupole number in the machine
% %title(strcat('eigenvalue number =',num2str(nbvp'))); ylabel('delta IQ /IQt')
% 
%%% critère valeur propre n°4
liste = find(DiagS>max(DiagS)/5);
liste = find(DiagS>max(DiagS)/2);
nbvp = max(liste); 
nbvp = 21
%nbvp = 100;
Rmod1 = Meffquad * V(:,1:nbvp);
%B = Rmod\ (X );
B1 = Rmod1\ (deltabetameas); % 
%DeltaCM = V * B;
deltaIquad = V(:,1:nbvp) * B1 % delta in Amps
pourcIquad = deltaIquad./IQnom % delta in pourcent
hold on %figure(4)
bar(pourcIquad,'k') ; xlabel('Quadrupole number presented by family','FontSize',14) ; ylabel('delta IQ /IQ','FontSize',14)
% %title(strcat('eigenvalue number =',num2str(nbvp')))
title('eigenvalue number = 25 (b); 24 (r); 23 (g); 22 (k)','FontSize',14)
%ylim([-0.007 0.004]);
% %pourcIquad_ordre_machine = pourcIquad(IX) 
% %bar(pourcIquad_ordre_machine) ; xlabel('Quadrupole number in the machine')
% %title(strcat('eigenvalue number =',num2str(nbvp'))) ; ylabel('delta IQ /IQ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% application à la machine (modele)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IQnom
 IQnomB = IQnom.*(1+pourcIquad);
IQnom1 = IQnomB(1:8);
IQnom2 = IQnomB(9:16);IQnom3 = IQnomB(17:24);
IQnom4 = IQnomB(25:40); % c'est moche je sais !!
IQnom5 = IQnomB(41:56) ; IQnom6 = IQnomB(57:80);IQnom7 = IQnomB(81:104);IQnom8 = IQnomB(105:128);
IQnom9 = IQnomB(129:144) ; IQnom10 = IQnomB(145:160);
disp('oulala')
% setsp('Q1',IQnom1,'Model');setsp('Q2',IQnom2,'Model');setsp('Q3',IQnom3,'Model');setsp('Q4',IQnom4,'Model');
% setsp('Q5',IQnom5,'Model');setsp('Q6',IQnom6,'Model');setsp('Q7',IQnom7,'Model');setsp('Q8',IQnom8,'Model');
% setsp('Q9',IQnom9,'Model');setsp('Q10',IQnom10,'Model');
% hold on %figure(12)
% plotbeta
% 
% switch2sim;
% betaX = [];betaZ = [];
% Indexquad = family2atindex({'Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10'});% Index of quadrupoles
% [BetaX, BetaZ] = modelbeta; % beta function everywhere
% for j = 1:1:10
%             bX = BetaX(Indexquad{j}); % measure H beta function in each quad
%             betaX = [betaX bX'];
%             bZ = BetaZ(Indexquad{j}); % measure V beta function in each quad
%             betaZ = [betaZ bZ'];
% end
% betaX


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% attention refaire soleilinit pour mettre les courants theoriques dans les
% QPoles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('eh oui')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mesure des betas dans les quadrupoles par la méthode des tune "comme sur
% la machine"
function beta_tune = mesure_beta(QuadFam)

Indexquad = family2atindex({'Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10'});% Index of quadrupoles
DeviceNumber = 0;
beta_tune = [] ; % Initialisation des vecteurs betas X (première ligne) 
                 % et Z (deuxième ligne) dans tous les quad (toutes les colonnes)
                 
for k1 = 1:length(QuadFam),
    
    if ~isfamily(QuadFam{k1})
        error('%s is not a valid Family \n', QuadFam{k1});
        return;
    end   
    DeviceList = family2dev(QuadFam{k1}); 
    
    % initialize data to zero
    tune1 = zeros(length(DeviceList),2);
    tune2 = zeros(length(DeviceList),2);
    dtune = zeros(length(DeviceList),2);
    beta =  zeros(length(DeviceList),2);
    k3 = 0;
    
    for k2 = 1:length(DeviceList),
        
        k3 = k3 +1;
        betaX0= [];betaZ0 = [];betaX1= [];betaZ1 = [];betaX2= [];betaZ2 = [];
        DeviceNumber = DeviceNumber + 1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% State before current change
        Ic = getam(QuadFam{k1}, DeviceList(k2,:)) ;% get the actual current
        K = hw2physics(QuadFam{k1}, 'Setpoint', Ic, DeviceList(k2,:)) ;% Calcul du gradient nominal
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% + deltaI
        DeltaI = getfamilydata(QuadFam{k1},'Setpoint','DeltaKBeta')*4; % Amp
        stepsp(QuadFam{k1}, DeltaI, DeviceList(k2,:),'Model'); % Step value in Amps
        tune1(k3,:) = gettune('Model'); % get new tunes

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -2 *deltaI
        stepsp(QuadFam{k1}, -2*DeltaI, DeviceList(k2,:),'Model'); % 
        tune2(k3,:) = gettune('Model') ;% get new tunes
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% go back to initial values
        stepsp(QuadFam{k1}, DeltaI, DeviceList(k2,:),'Model'); % go back to initial values
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        dtune(k3,:) = tune1(k3,:) - tune2(k3,:);
        Leff = getleff(QuadFam{k1}, DeviceList(k2,:)); % Get effective length
        DeltaKL =  2*DeltaI/Ic*K*Leff;
        beta(k3,:) = 4*pi*dtune(k3,:)./DeltaKL.*[1 -1]    ;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end
    beta0 = beta';
    beta_tune = [beta_tune beta0]; % beta en ligne mesurés par la méthode des tunes
    
end

% function sauvegarde(NameFic,NamePar1,FicPar1)
% %%%%%%%%%%%%%%%%%%%%%% sauvegarde
% DirStart = pwd;
% DirectoryName = '/home/matlabML/measdata/Ringdata/QUAD/';
% [DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);
% try
%     Nomfichier = NameFic;
%     save(Nomfichier,NamePar1);
% catch
%     cd(DirStart);
%     return
% end
% cd(DirStart);





































 






















 






















 




























 







 






 



 


 


 

