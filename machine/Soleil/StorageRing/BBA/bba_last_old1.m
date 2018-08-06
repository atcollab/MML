
function [merit,CorConsEye,BpmRes,offs,OffsCor,center,ze,ord1,ord2,BpmEyeRes,CorDevListRes,iniCor,rmsFit,NameFile,NameFilePNG]=bba_last(QuadFam,QuadDev,Plane,Method,nbDeltaCor,DeltaCor,offsetCor,retard,DeltaQp0,CorNumber)
%% INPUTS
%QuadFam = famille du quadrupole,
%QuadDev = [cell element] qu quadrupole
%Plane = 1 ou 2 ; horizontal ou vertical
%Method = MEC (Most Effective Corrector) ou BMP4CM (Bump 4 cor),
%nbDeltaCor = nb de pas du correcteur,
%DeltaCor = Delta I d'un pas de correcteur,
%offsetCor = offset en courant du correcteur pour recentrer la "parabole",
%retard = délai en secondes pemettant d'attendre la fin de la montée en courant du correcteurs ou du quadrupole,
%DeltaQp0 = Delta I pour un pas de quadrupole,
%CorNumber = classement du correcteur en fonction de son efficacité (1=le plus efficace)

%% EXEMPLE pour BBA M.E.C.
% nbDeltaCor=13;
% DeltaCor=0.1;% amps
% offsetCor=0.7; %amps
% retard=4;%20; sec
% DeltaQp0=1.75;

%% OUTPUTS
% merit = tableau de 2 colonnes: colonne 1 -> courants dans le correcteur
%                                colonne 2 -> valeur de la fonction de mérite
%CorConsEye = relevé des valeur des consignes dans le correcteur -> dimension 1*nbDeltaCor
%BpmRes = Valeur dans le BPM choisi (le plus proche)
%OffsCor = offset à appliquer dans le correcteur pour centrer la parabole calculée
%center = courant dans le correcteur pour lequel la parabole est minimale,
%ze = abscisses calculées pour les fit (parabole et droite, 40 points),
%ord1= ordonnées de la parabole évaluée en ze(i),
%ord2= ordonnées de la droite évaluée en ze(i) -> pour le BPM choisi,
%BpmEyeRes = [cell, element] du BPM choisi voir fonction "mec3",
%CorDevListRes =  [cell, element] Correcteur choisi voir fonction "mec3",
%iniCor = valeur initiale du correcteur
%OffsetBpm = offset BPM en mm
%rmsFit = variable permettant de qualifier le fit de la parabole: écart-type des distances entre le fit et les points mesurés
%NameFile = nom du fichier dans lequel sont stockées toutes les données
%NameFilePNG = nom du du fichier .PNG de la copie d'écran de l'interface graphique

%BMP4COR
DeltaPosMax=1;   %mm for BMP4CM Method


condTune=0;      % permet la correction du point de fonctionnement QP pour revenir au nombre d'onde initial apres le BBA
condQp=0;        % calcul automatique du DeltaQ -> 1 ou non -> 0 % pas disponible
condBPMsigma=0;  % prise en compte ou non du sigma des Bpm -> 1 ou 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%switch2sim

%setsp('HCOR',0)
%setsp('VCOR',0)


%Dx(s)=(-Dk(sQp) x(sQp))*[1/{1-k(sQp)*l Bet(sQp)/(2 tan(Pi nux))}]*
%[rac(Bet(sBpm))*rac(Bet(sQp))]/(2 sin(pi nux))*
%cos(fix(sBpm)-fix(sQp)-pi nux)
% clear
% famQ='Q1';
% locQ=[4 1];
% famB='BPMx';
%
% %position longitudinale du quadrupole considéré
% sQp=getspos(famQ,locQ);
% [famresB,locB,sBpm]=proche(famB,famQ,locQ);
%
% %extration du nombre d'onde
% tune=gettune;
% nux=tune(1);
% nuz=tune(2);
%
% %extraction des fonctions b�ta au Qp considéré:
% [bxQ,bzQ]=modelbeta(famQ,locQ);
% %extraction des fonctions b�ta au BPM considéré:
% [bxB,bzB]=modelbeta(famB,locB);
%
% %extraction des phases au Qp considéré:
% [fixQ,fizQ]=modelphase(famQ,locQ);
% %extraction des phases au BPM considéré:
% [fixB,fizB]=modelphase(famB,locB);
%% %%%%%%

%switch2sim

%setsp('HCOR',0)
%setsp('VCOR',0)

%% TEST DES VARIABLES D'ENTREES
if ~iscellstr(QuadFam)
    error('la famille entree n''est pas au format cell')
end

tailleQDev=size(QuadDev(1,:))

if isempty(QuadDev)
    error('Veuillez entrer le device du quadripole à étudier au format QuadDev=[cell elt]')
elseif tailleQDev(2)~=2
    error('Trop d''elements pour 1 device de QP:  QuadDev=[cell elt]')
end

if Plane<1 || Plane>2
    error('Veuillez entrer le plan étudié: Horizontal: Plane=1 ; Vertical:Plane=2')
end

%ne fonctionne pas
if ~ischar(Method)
    error('Methodes disponibles au format string: ''MEC''')
end
%


%% Mémorisation du répertoire de travail
Rep    = getfamilydata('Directory','BBA');

Annuncment = strcat('  ***         Registration Directory                             ***');
disp('  ****************************************************************************');
disp(Annuncment);
disp('  **                                                                        **');
disp('  ****************************************************************************');
disp(' ')
disp('  ****************************************************************************');
disp('  **                             WARNING                                    **');
disp('  **    New directory has to be defined after an offset application         **');
disp('  **                                                                        **');
disp('  ****************************************************************************');

button = questdlg('Is the Registration Directory already existing ?','Registration Directory','yes','no','yes') ;
if isequal(button,'yes')                            % la directory existe déjà
    RepRes = uigetdir(Rep);                         % choix de la directory
else
    tmp2 = questdlg('Create directory ?','BBA','Yes','No','Yes');
    if strcmpi(tmp2,'Yes')                          % create a new directory
        prompt = {'Enter new directory name:'};
        dlg_title = 'Input for Directory Name';
        num_lines = 1;
        def = {'work_december06'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        RepRes = answer{1};
        cd(Rep)                                    % on se place dans la directory amont /BBA
        mkdir(RepRes)
        RepRes = [Rep RepRes]                      % Nom complet de la directory
    else                                           % alors on ne sait pas ce qu'on veut ??
        disp('**  BBA cancelled  **')
        return
    end
end
disp('  ** BBA starting **') 

varfig=10; % utilité ??????
tic;

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%

QuadFamilyList=QuadFam;
QuadDevList=QuadDev;

% Results are stored in a "dynamic' structure called BBA:
% level1: BBA.(QuadFam)

% Rappel du dernier fichier résultats de BBA
[BBAnumb0, BBAnumbText0, NomText0]=SaveName(RepRes,0);


%Chargement des fichiers nécessaire
% A MODIFIER pour etre plus generique et prendre toujours la bonne matrice
% reponse.
load('respcor.mat') %réponse des correcteurs
danow= datestr(now);
texdat=danow(1:11)


if BBAnumb0>0
    %NameFile=[RepRes '/ResBBA_' BBAnumbText0 '.mat'];
    NameFile=[RepRes '/' NomText0];  % dernier fichier BBA
    %NameFile=[RepRes '/ResBBA_' BBAnumbText0 '_' texdat '.mat'];
    load(NameFile);
end
%BBA;
%définition du nom du nouveau fichier résultat BBA
[BBAnumb1,BBAnumbText1,NomText1] = SaveName(RepRes,1);  %NomText1 n'est pas utulisé dans ce cas
%NameFile=[RepRes '/ResBBA_' BBAnumbText1 '.mat'];
NameFile=[RepRes '/ResBBA_' BBAnumbText1 '_' texdat '.mat'];  % nom du nouveau fichier BBA
NameFilePNG=[RepRes '/SnapBBA_' BBAnumbText1 '_' texdat '.png'];
%BBAnumb=BBAnumb+1;


%[Reper '/DirBBA/resBBA_' BBAnumb '.mat']


% recherche du tableau contenant l'écart type des BPM
%rep='/home/matlabML/measdata/Ringdata/BPM'

% NON UTILISE POUR L'INSTANT
% rep = getfamilydata('Directory','BPMData')
% col=dir(rep)
% 
% for i=1:length(col)
%     nom  = col(i).name;
%     Lnom0= size(nom);
%     Lnom = Lnom0(2);
%     if  Lnom>30 & strcmpi(nom(Lnom-2:Lnom),'mat') & strcmpi(nom(1:7),'BPMData')
%         nom2 = nom;
%     end
% 
% end
% repBPM=char([rep '/' nom2]);
% BPMdata=load(repBPM);
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%



%Plane=1;NameFilePNG
%if      Plane==0
%    loop=2;
%    Plane=1;
%else
%    loop=1;
%end
%%
%$$$$$$$$$$$
%for m=1:loop
%$$$$$$$$$$$



if     Plane==1
    BpmFam='BPMx';
    CorFam='HCOR';
    NamePlane='HPlane';
    CorBpmResp=efficacy.HPlane; % matrice d'efficacité correcteur/BPM
    %BpmMax=37; %non utilisé
%    BpmSigma1=BPMdata.BPMxData.Sigma;
elseif Plane==2
    BpmFam='BPMz';
    CorFam='VCOR';
    NamePlane='VPlane';
    CorBpmResp=efficacy.VPlane;
    %BpmMax=4.5; %non utilisé
   % BpmSigma1=BPMdata.BPMyData.Sigma;
else
    error('input must "1" for horizontal plane or "2" for vertical plane');
end

%if Method=='MEC'
%% UTILISATION du MEC:
%
%mec(QuadFamilyList,QuadDev,Plane,CorBpmResp)
%Demander si le fichier respcor.m convient
%sinon [effic]=respcor(Plane)
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%
% PREPARATION DES LISTES DE DEVICES %
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%

BpmDevList = getlist(BpmFam);
CorDevList = getlist(CorFam);

for i=1:length(CorDevList)
    CorDevListCell(i)=mat2cell(CorDevList(i,:),1,2);
end



%disp('poc');
%getam('BPMx',[1 2])

%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%
% MEMORISATION DES VALEURS INITIALES %
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%

for i=1:length(BpmDevList) % voir peut �tre seulement Bpm Dispo???
    BpmDevList(i,:);
    InitValBpm(i)=getam(BpmFam,BpmDevList(i,:)); % A modifier: pas très performant
    BpmSigma0(i)=1;
end

if condBPMsigma==0
    BpmSigma=BpmSigma0;
else
    BpmSigma=BpmSigma1;  % attention à définir
end

BpmSigma;
InitValBpm;

for i=1:length(CorDevList) % voir peut �tre seulement COR Dispo???
    InitValCor(i)=getsp(CorFam,CorDevList(i,:)); % A modifier: pas très performant
end


% MODIFIER LA GESTION DES ERREURS: STATUS
BPMStatus =family2status(BpmFam);
CorStatus =family2status(CorFam);
BpmFam;
CorFam;

if sum(BPMStatus)~=120
    disp('Il y a des BPM qui ont un mauvais status')
end

if sum(CorStatus)~=56
    disp('Il y a des COR qui ont un mauvais status')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




taille=size(QuadFamilyList);

disp('$$$$$$$$$$$$$$$$$$$$$$$$')
for j=1:taille(1)

    %% Choix de la variation minimale du courant dans le correcteur requise pour obtenir un bon BBA
    QuadStatus=family2status(char(QuadFamilyList(j)),QuadDevList(j,:));

    if QuadStatus~=1
        disp('BBA impossible mauvais statut du QP')
    end
    InitValQp =getsp(char(QuadFamilyList(j)),QuadDevList(j,:));
    %RECHERCHE DES ELEMENTS POUR LE BBA: BPM, CORRECTEURS
    if strcmpi(Method,'MEC')
        %CorNumb=1;
        [CorFamRes,CorDevListRes,CorElemRes,EffRes,BpmFamRes,BpmEyeRes]=mec3(QuadFamilyList(j),QuadDevList(j,:),Plane,CorBpmResp,CorNumber);
        CorStatus1 =family2status(CorFam,CorDevListRes);
        BPMStatus1 =family2status(BpmFam,BpmEyeRes);

        if CorStatus1~=1
            disp('BBA impossible mauvais statut du COR')
        end

        if BPMStatus1~=1
            disp('BBA impossible mauvais statut du BPM')
        end
    elseif strcmpi(Method,'BMP4CM')
        [CorFamRes,CorDevListRes,BpmFamRes,BpmDevListRes,BpmEyeRes,ConsRes]=bmp4Cor(QuadFamilyList(j),QuadDevList(j,:),Plane);
        tailleBp=size(BpmDevListRes);
    end

    tailleCor=size(CorDevListRes);
    CorDevListRes;
    for b=1:tailleCor(1)
        InitValcorUsed(b)=getsp(CorFam,CorDevListRes(b,:)); % a modifier: peu performant
    end
    %%
    %DETERMINATION DES TABLES DE VALEURS POUR LES COR,QP...
    % deltaCor à ressortir de CorCurRange.m (pas encore programmé)
    % nombre de deltaCor aussi à connaitre
    clear CorCons CorSp BpmRes BpmVal QpCons QpSp
    %nbDeltaCor=7;
    %DeltaCor=0.75;%amps for MEC Method
    % DeltaPosMax=1; %mm for BMP4CM Method
    %retard=20;
    var=0;
    %stepsp(CorFam ,-nbDeltaCor*DeltaCor/2,CorDevListRes);
    %stepsp(QuadFam,-nbDeltaQp*DeltaQp/4  ,QuadDev);
    if strcmpi(Method,'MEC')
        iniCor=InitValCor(CorElemRes);
    elseif strcmpi(Method,'BMP4CM')
        for i=1:4
            inicorrect(i)=getam(CorFam,CorDevListRes(i,:));
        end
    end

    for nbc=1:nbDeltaCor
        if strcmpi(Method,'MEC')
            CorTab(nbc)=InitValCor(CorElemRes)-((nbDeltaCor-1)*DeltaCor)/2+(nbc-1)*DeltaCor+offsetCor; %amps tableau ayant nbDeltaCor colonnes
            % peut etre amélioré (sans boucle)
        elseif strcmpi(Method,'BMP4CM')
            %CorTab(nbc)=-DeltaPosMax/2+(nbc-1)*DeltaPosMax/(nbDeltaCor-1);

            DeltaPos=DeltaPosMax/(nbDeltaCor-1);
            CorTab(1)=-DeltaPosMax/2+offsetCor;
            for valC=1:nbDeltaCor-1
                CorTab(valC+1)=CorTab(1)+valC*DeltaPos;
            end
            %CorTab(3)=0.1;
            % CorTab(4)=0.1;
            %CorTab(5)=0.1;
        end%mm   BMP4CM
    end
    CorTab;
    % Calcul du deltaK pour obtenir une variation de DeltaPos
    %DeltaQp=2;
    nbDeltaQp=2;
    % DeltaPos=1.5e-3; % A revoir
    % DeltaQp=CalcDK(char(QuadFamilyList(j)),QuadDevList(j,:),BpmFamRes,BpmEyeRes,DeltaPos,Plane)*InitValQp

    %% Choix du Delta I en fonction du DeltaNu MAX et du Delta I/I Max
%     DeltaNu=0.01;BpmEyeRes
%     DeltaI_I=0.01;
% 
%     TuneTot=[-3.7e-3  9.37e-3 -2.33e-3   -8e-4  3.13e-3 -1.18e-3  6.75e-3 -1.88e-3 -7.95e-4  3.74e-3; ...
%         2.91e-3 -2.74e-3  2.91e-3 3.74e-3   -1.68e-3  3.14e-3 -2.07e-3  2.14e-3  3.98e-3 -1.18e-3];
% 
%     current=[125.72 161.32 75.63 147.71 202.58 118.45 213 180.55 179.35 210.48]*0.04;
%     %[DK]=CalcDK(char(QuadFamilyList(j)),QuadDevList(j,:),BpmFamRes,BpmEyeRes,Plane)
% 
%     for o=1:2
%         for p=1:10
%             TuneTot1(o,p)=DeltaNu/TuneTot(o,p);
%             Dcourant(o,p)=min([abs(TuneTot1(o,p)) abs(current(p))]);
%         end
%     end
% 
% 
%     numFamQ=char(QuadFamilyList(j));
%     numQ=str2num(numFamQ(2:length(numFamQ)));
%     DeltaQp=Dcourant(Plane,numQ);
%     %DeltaQp=0.75;
%     if condQp==1
%         [DK]=CalcDK(char(QuadFamilyList(j)),QuadDevList(j,:),BpmFamRes,BpmEyeRes,Plane);
%         DeltaQp=getsp(char(QuadFamilyList(j)),QuadDevList(j,:))*abs(DK);
%     else
        DeltaQp=DeltaQp0;
%     end
    %%

    % Création des tableau de consignes pour les quadrupoles
    % idée: toujours commencer "en haut" du cycle d'hystérésis
    if InitValQp>0
        QpTab(1)=InitValQp-DeltaQp;
        QpTab(2)=InitValQp+DeltaQp;
    elseif InitValQp<0
        QpTab(1)=InitValQp+DeltaQp;
        QpTab(2)=InitValQp-DeltaQp;
    else
        error('il y a un problème pour le calcul du DeltaK')
    end
  
    %%
    %

    %sauvegarde des valeurs
    NameQuadDev=char(['dev' num2str(QuadDevList(j,1)) '_'  num2str(QuadDevList(j,2))]);
    
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).CorDev=CorDevListRes;
    if strcmpi(Method,'MEC')
        BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Eff   =EffRes;
    end
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).BpmDev=BpmEyeRes;
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Date  =datestr(now);


    %sauvegarde des valeurs initiales
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Init.Qp =InitValQp;
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Init.Cor=InitValCor;
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Init.Bpm=InitValBpm;

    save(NameFile,'BBA');
    load(NameFile);
    %init=init+length(listfamQ);

    toc;

%% $$  Début du BBA   $$ %%
    if strcmpi(Method,'MEC')

        %%           DEBUT: boucle sur Qp (excursion +/- Dk)
        vartext=0;
        for v=1:nbDeltaQp
            disp('Qp');
            tuneNumber(v,:)=gettune;
            current(v)=getdcct;
            setsp(QuadFam,QpTab(v),QuadDev,-2);
            pause(6);
            %%   Debut: boucle sur COR (excursions nbDeltaCor)
            clear CorCons CorSp
            for u=1:nbDeltaCor
                vartext=vartext+1;
                %setsp(char(QuadFamilyList(j)),InitValQp,QuadDevList(j,:));
                texto=char([num2str(vartext) '/' num2str(2*nbDeltaCor)]);
                disp(texto);
                drawnow;

                setsp(CorFam,CorTab(u),CorDevListRes,-2);
                pause(retard); % valeur définie par le programme en mode auto : valeur par défaut=2.5 sec
                                                                %en mode manuel:valeur par défaut 4 sec
                if u==1
                    pause(9); % défini par l'expérience
                end
                CorCons(u)=getsp(CorFam,CorDevListRes);
                CorConsEye(u)=CorCons(u);
                %CorSp(u)  =getsp(CorFam,CorDevListRes);

                if v==1
                    BpmRes(u)=getam(BpmFam,BpmEyeRes); %Mermorisation du BPM Eye
                end

                QpCons(u,v)=getsp(char(QuadFamilyList(j)),QuadDevList(j,:));
                %QpSp(u,v)  =getsp(char(QuadFamilyList(j)),QuadDevList(j,:));
                %tempo

                
                %Modifier, boucle inutile !!!
                for w=1:length(BpmDevList)
                    BpmVal(w,v,u)=getam(BpmFam,BpmDevList(w,:)); %BpmVal(Bpm,Quad,Cor)
                end

            end
            %%              FIN:boucle sur COR (excursions nbDeltaCor)
            CorCons;
            BpmRes;
            QpCons;
            %QpSp;
            length(BpmVal);
        end


        %%

    elseif strcmpi(Method,'BMP4CM')
        iniCor=getam(BpmFam,BpmEyeRes);
        %test du bump proposé
        ocsi=setorbitbump(BpmFam,BpmDevListRes,ConsRes*CorTab(1),CorFam,[-2 -1 1 2],'Incremental','NoSetSP');
        indCorRes=ocsi.CM.DeviceList; %doit etre le meme que CorDevListRes
        test=sum(indCorRes-CorDevListRes)
        if abs(test)~=0
            error('bump impossible')
        else
            for u2=1:nbDeltaCor
                ocsi=setorbitbump(BpmFam,BpmDevListRes,ConsRes*CorTab(u2),CorFam,[-2 -1 1 2],'Incremental','NoSetSP');
                CorVal(:,u2)=ocsi.CM.Delta
            end
        end

    vartext=0;
        for v=1:nbDeltaQp
            setsp(QuadFam,QpTab(v),QuadDev,-2);
            tuneNumber(v,:)=gettune
            current(v)=getdcct
            pause(6);
            disp('Qp');
            %setsp(QuadFam,QpTab(v),QuadDev);
            %%        Debut: boucle sur COR (excursions nbDeltaCor)
            for u=1:nbDeltaCor
                vartext=vartext+1;
                texto=char([num2str(vartext) '/' num2str(2*nbDeltaCor)]);
                disp(texto)
                %setsp(char(QuadFamilyList(j)),InitValQp,QuadDevList(j,:));
                for u1=1:4
                    setsp(char(CorFam),CorVal(u1,u),CorDevListRes(u1,:),-2);
                end
                if u==1
                    pause(6)
                end
                pause(retard);
                
                getsp('HCOR');

                drawnow;
                clear CorCons CorSp
                %ocsi=setorbitbump(BpmFam,BpmDevListRes,ConsRes*CorTab(u),CorFam,[-2 -1 1 2],'Incremental','NoSetSP');
                %indCorRes=ocsi.CM.DeviceList; %doit etre le meme que CorDevListRes
                %test=sum(indCorRes-CorDevLisRes)
                if abs(test)~=0
                    error('bump impossible')
                end
                tailleCorRes=size(indCorRes);
                for c=1:tailleCorRes(1)
                    CorCons(u,c)=getsp(CorFam,indCorRes(c,:));
                    %CorSp(u,c)  =getsp(CorFam,indCorRes(c,:));
                end
                if v==1
                    BpmRes(u)=getam(BpmFam,BpmEyeRes); %Mermorisation du BPM Eye
                end
                QpCons(u,v)=getsp(char(QuadFamilyList(j)),QuadDevList(j,:));
                %QpSp(u,v)  =getsp(char(QuadFamilyList(j)),QuadDevList(j,:));
                %tempo

                CorConsEye(u)=BpmRes(u);
                tailleBList=size(BpmDevListRes);
                ind1=dev2elem(BpmFam,BpmDevListRes(1,:));
                ind2=dev2elem(BpmFam,tailleBList(1));
                for w=1:ind1-1
                    BpmVal(w,v,u)=getam(BpmFam,BpmDevList(w,:)); %BpmVal(Bpm,Quad,Cor)
                end
                for w=ind2+1:120
                    BpmVal(w-tailleBList(1),v,u)=getam(BpmFam,BpmDevList(w,:));
                end
                %tempo
            end
        end
    end



    %%      Sauvegarde
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.BpmData =BpmVal;
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.BpmRes  =BpmRes;
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.QuadCons=QpCons;
    %BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.QuadSetp=QpSp;
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.CorCons =CorCons;
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.CorCons =CorCons;
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.Current =current;
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.Tune =tuneNumber;
    %BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.CorSetp =CorSp;
    save(NameFile,'BBA');
    %%
    %%      Retour aux Valeurs initiales Qp et COR
    setsp(char(QuadFamilyList(j)),InitValQp,QuadDevList(j,:),-2); % Init Qp
    for b=1:tailleCor(1)
        setsp(CorFam,InitValcorUsed(b),CorDevListRes(b,:),-2);   % Init Cor
    end
    pause(retard);
    tuneNumber(3,:)=gettune;
    %%          Fin:boucle sur Qp (excursion +/- Dk)
    if Plane==1
        tuneWatch=tuneNumber(1,1);
        tuneEnd  =tuneNumber(3,1);
    elseif Plane==2
        tuneWatch=tuneNumber(1,2);
        tuneEnd  =tuneNumber(3,2);
    end

    %% boucle de correction du nombre d'onde
    %Dnu0=tuneWatch-tuneEnd;
    tuneEnd=gettune

    
    % par défaut non utilisé: condTune=0
    % revoir pause
    % revoir Delta I quad 
    if condTune==1
        stepQp=signDQ*0.0005;
        signDQ=sign(QpCons(1,1));
        while abs(tuneWatch-tuneEnd)>1e-5
            stepsp(char(QuadFamilyList(j)),stepQp,QuadDevList(j,:));
            pause(0.5);
            tuneEnd1=gettune;

            if Plane==1
                tuneEnd=tuneEnd1(1);
            elseif Plane==2
                tuneEnd=tuneEnd1(2);
            end

        end
    end
    disp('ole')

    %%
    %%      Recherche du minimum de la fonction de mérite
    %load('resBBA.mat')
    %data=BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).MEC.Results.BpmData;
    data=BpmVal;
    datSize=size(data);
    BpmSigma;

    for r=1:datSize(3)     %itération sur les valeurs de correcteurs
        point=0;
        for t=1:datSize(1) %itération sur les valeurs des BPMs

            point=point+1*((data(t,1,r)-data(t,2,r))/BpmSigma(t))^2;
        end

        merit(r,1)=CorConsEye(r);
        merit(r,2)=1/datSize(1)*point;
    end
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.FitData =merit;
    save(NameFile,'BBA');

    %coef=polyfit(merit(:,1), merit(:,2),2); % calcul des coef de la parabole de la fonction de m�rite
    droite=polyfit(CorConsEye,BpmRes,1);        % calcul des coef de la droite du Bpm observé


    %% Verif

    %init:Moindres carrés
 %%% A ALLEGER !!!!
 
    VectB=merit(:,2);
    for q=1:length(merit)
        MatFunc(q,1)=merit(q,1)^2;  MatFunc(q,2)=merit(q,1); MatFunc(q,3)=1;
        M1(1,q)=MatFunc(q,1);% M1(1,2)=1; M1(1,3)=1;
        M2(1,q)=MatFunc(q,2);%; M2(2,q)=1; M2(3,q)=0;
        M3(1,q)=MatFunc(q,3);%; M3(2,q)=0; M3(3,q)=1;
    end
    M1;
    ResVect(1,1)=M1*VectB;ResVect(2,1)=M2*VectB;ResVect(3,1)=M3*VectB;
    ResMat(1,1)=M1*MatFunc*[1;0;0];ResMat(1,2)=M1*MatFunc*[0;1;0];ResMat(1,3)=M1*MatFunc*[0;0;1];
    ResMat(2,1)=M2*MatFunc*[1;0;0];ResMat(2,2)=M2*MatFunc*[0;1;0];ResMat(2,3)=M2*MatFunc*[0;0;1];
    ResMat(3,1)=M3*MatFunc*[1;0;0];ResMat(3,2)=M3*MatFunc*[0;1;0];ResMat(3,3)=M3*MatFunc*[0;0;1];
    ResMat;
    coef=inv(ResMat)*ResVect;

    %%

    center=-coef(2)/(2*coef(1));             % abscisse de l'offset BBA (amps)
    offs=droite(1)*center+droite(2);         % ordonn�e de l'offset BBA (mm)
    %%      Fin de Recherche du minimum

    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.OffsetBpm =offs;
    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.CorCenter =center;

    save(NameFile,'BBA');



    for e=1:41
        %ze(e)=min(BpmRes)+(e-1)*(max(BpmRes)-min(BpmRes))/40;
        ze(e)=CorTab(1)+(e-1)*(CorTab(nbDeltaCor)-CorTab(1))/40;
        %ze(e)=-2.5+(e-1)*5/40;
        ord1(e)=parabole(ze(e),coef);
        %ordco(e)=parabole(ze(e),valco);
        ord2(e)=ligne(ze(e),droite);
    end
    toc;

    for varTest=1:nbDeltaCor
        ecart(varTest)=merit(varTest,2)-parabole(CorTab(varTest),coef);
    end
    rmsFit=qualFit(merit(:,1),merit(:,2),coef); % valeur affichée

    BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.EcartFit =ecart;

end




%
%Plane=2; % For running the prog on both Plane
%%    %$$$$$$$$$$$$$$$
%end
NameFile;
BpmRes;
CorCons;
%droite=polyfit(CorCons,BpmRes,1)
iniCor;
offs;

ecart;
CorDevListRes;
if strcmpi(Method,'MEC')
CorElemRes;
EffRes;
end
disp('OffsCor');
OffsCor=center-iniCor;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Verif moindres carrés
% xi=merit(:,1)
% yi=merit(:,2)
% xi0=0;
% xi2=0;
% xi3=0;
% xi4=0;
% mesur1=0;
% mesur2=0;
% mesur3=0;
% for i=1:length(CorCons)
%    xi4=xi4+xi(i)^4;
%    xi3=xi3+xi(i)^3;
%    xi2=xi2+xi(i)^2;
%    xi0=xi0+1;
%    mesur1=mesur1+yi(i)*xi(i)^2;
%    mesur2=mesur2+yi(i)*xi(i);
%    mesur3=mesur3+yi(i);
% end
%
% mato(1,1)=  sum(xi4); mato(1,2)=sum(xi3);    mato(1,3)=  sum(xi2);
% mato(2,1)=  sum(xi3); mato(2,2)=sum(xi2);    mato(2,3)=  sum(xi);
% mato(3,1)=  sum(xi2); mato(3,2)=sum(xi);     mato(3,3)=  sum(xi0);
%
% mesur=[mesur1;mesur2;mesur3]/6
%
% mato=mato/6
% valco=inv(mato)*mesur
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%
% for e=1:41
%     ze(e)=CorTab(1)+(e-1)*(CorTab(nbDeltaCor)-CorTab(1))/40;
%     %ze(e)=-2.5+(e-1)*5/40;
%     ord1(e)=parabole(ze(e),coef);
%     ordco(e)=parabole(ze(e),valco);
%     ord2(e)=ligne(ze(e),droite);
% end
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% y1=[min(BpmRes)-0.5 max(BpmRes)+0.5];
% y2=[min(merit(:,2))-0.01 max(merit(:,2))+0.01];
%
% figure(1)
% hold all
% [Bx1,Hb1,Hb2]=plotyy(ze,ord2,ze,ord1,'plot')
% %,'LineStyle','-.')
% %textval=char([offs ' mm']);
% %text(center,offs,textval,'HorizontalAlignment','left')
% set(Hb1,'Color','black','LineStyle','-.');%,'LineStyle','--')
% set(Hb2,'Color','black','LineStyle','-.');
%
%
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %figure(2)
%
% [Ax1,Ha1,Ha2]=plotyy(CorCons,BpmRes,merit(:,1),merit(:,2) ,'plot');%,'Marker','x','Color','red')
%
% set(Ha1,'Marker','x','Color','blue');%,'LineStyle','--')
% set(Ha2,'Marker','x','Color','red');
%
% x1=get(Ax1(1),'XLim')
% set(Ax1,'Visible','off')
% set(Ax1(1),'YLim',y1)
% set(Ax1(2),'YLim',y2)
%
% pl1=plot([center center],[y1(1) offs])
%
% pl2=plot([x1(1) center],[offs offs])
% pl3=plot(center,offs,'Marker','o','Color','black')%,text(center,offs,'\leftarrow ',...
%      %'HorizontalAlignment','left'))
%
% set([pl1 pl2],'Color','black','LineStyle','-.');
%
%
% set(Bx1,'Visible','on')
% set(Bx1(1),'YLim',y1,'YColor','blue')
% set(Bx1(2),'YLim',y2,'YColor','red')
% xlabel('COR Value (amps)')
% ylabel(Bx1(1),'(mm)')
% ylabel(Bx1(2),'(merit)')
%



save('resu.mat','merit','ze','ord1','ord2','droite','coef','CorCons','BpmRes','coef','center','offs')

%% Tout est enregistré dans une structure
% BBA.(QuadFam).(['dev' QuadDev]).(Plane).(Method).CorDev
%                                                 .eff
%                                                 .BpmDev
%                                                 .Date
%                                                 .Results
%...

%example:
% >> BBA.Q1.dev1_1.HPlane.MEC.CordeV
% ans =
% >> 5    1