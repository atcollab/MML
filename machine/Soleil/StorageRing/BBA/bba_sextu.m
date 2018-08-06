
function [merit,CorConsEye,BpmDevRes,offs,OffsCor,center,ze,ord1,ord2,BpmResEye,iniCor,rmsFit]=bba_sextu(QTFam,Plane,Method,nbDeltaCor,DeltaCor,offsetCor,retard,DeltaQp0)


QTDev=[2 1]

cd '/home/matlabML/measdata/Ringdata/BBA/debug'
Namefile='SEXTU_001_230906.mat'

% PARAMETRES PERMETTANT DE REGLER LE BBA M.E.C.
% nbDeltaCor=13;
% DeltaCor=0.1;% amps
% offsetCor=0.7; %amps
% retard=4;%20; sec
% DeltaQp0=1.75;

condTune=0;      % permet la correction du point de fonctionnement QP pour revenir au nombre d'onde initial apres le BBA
condQp=0;        %calcul automatique du DeltaQ -> 1 ou non -> 0 % pas disponible
condBPMsigma=0;  %prise en compte ou non du sigma des Bpm -> 0 ou 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%switch2sim


if     Plane==1
    BpmFam='BPMx';
    BpmFamF='BPMx';
    CorFam='QT';
    NamePlane='HPlane';
    %CorBpmResp=efficacy.HPlane; %effic(Cor,Bpm)
    %BpmMax=37;
    %BpmSigma1=BPMdata.BPMxData.Sigma;
elseif Plane==2
    BpmFam='BPMz';
    BpmFamF='BPMx';
    CorFam='QT';
    NamePlane='VPlane';
    %CorBpmResp=efficacy.VPlane;
    %BpmMax=4.5;
    %BpmSigma1=BPMdata.BPMyData.Sigma;
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

BpmDevList=getlist(BpmFam);


%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%
% MEMORISATION DES VALEURS INITIALES %
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%

for i=1:length(BpmDevList) % voir peut �tre seulement Bpm Dispo???
    InitValBpm(i)=getam(BpmFamF,BpmDevList(i,:));
end

InitValBpm;


BPMStatus =family2status(BpmFam);


if sum(BPMStatus)~=120
    disp('Il y a des BPM qui ont un mauvais status')
end






disp('$$$$$$$$$$$$$$$$$$$$$$$$')


%Method,'MEC'
CorNumb=1;
%[CorFamRes,CorDevListRes,CorElemRes,EffRes,BpmFamRes,BpmEyeRes]=mec(QuadFamilyList(j),QuadDevList(j,:),Plane,CorBpmResp,CorNumb);
[BpmRes,BpmDevRes,BpmPosRes]=proche2(BpmFam,'QT',QTDev,0);



%DETERMINATION DES TABLES DE VALEURS POUR LES COR,QP...
% deltaCor à ressortir de CorCurRange.m (pas encore programmé)
% nombre de deltaCor aussi à connaitre
clear CorCons CorSp BpmRes BpmVal QpCons QpSp
%nbDeltaCor=7;
%DeltaCor=0.75;%amps for MEC Method
DeltaPosMax=1; %mm for BMP4CM Method
%retard=20;
var=0;
%stepsp(CorFam ,-nbDeltaCor*DeltaCor/2,CorDevListRes);
%stepsp(QuadFam,-nbDeltaQp*DeltaQp/4  ,QuadDev);

iniCor=0%getam('QT',QTDev)
for nbc=1:nbDeltaCor
    CorTab(nbc)=-((nbDeltaCor-1)*DeltaCor)/2+(nbc-1)*DeltaCor+offsetCor; %amps MEC
end
CorTab

BpmResEyeIni=getam(BpmFam,BpmDevRes); %Mermorisation du BPM Eye
%sauvegarde des valeurs
%%
%% $$  Début du BBA   $$ %%
%%           DEBUT: boucle sur Qp (excursion +/- Dk)
vartext=0;
%%   Debut: boucle sur COR (excursions nbDeltaCor)
clear CorCons CorSp
for u=1:nbDeltaCor
    vartext=vartext+1
    %setsp(char(QuadFamilyList(j)),InitValQp,QuadDevList(j,:));

    drawnow;

    setsp(CorFam,CorTab(u),QTDev,-2);
    if u==1
        pause(16);
    end
    
    
    pause(retard);
    
    CorCons(u)=getsp('QT',QTDev);
    CorConsEye(u)=CorCons(u);
    %CorSp(u)  =getsp(CorFam,CorDevListRes);


    BpmResEye(u)=getam(BpmFam,BpmDevRes); %Mermorisation du BPM Eye


    for w=1:length(BpmDevList)
        BpmVal(w,u)=getam(BpmFamF,BpmDevList(w,:)); %BpmVal(Bpm,Quad,Cor)
    end

end
%%              FIN:boucle sur COR (excursions nbDeltaCor)
CorCons;
BpmDevRes;
%QpCons;
%QpSp;
length(BpmVal);


%%







%%      Sauvegarde
%BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.BpmData =BpmVal;
%BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.BpmRes  =BpmRes;
%BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.QuadCons=QpCons;
%BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.QuadSetp=QpSp;
%BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.CorCons =CorCons;
%BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.CorCons =CorCons;
%BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.Current =current;
%BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.Tune =tuneNumber;
%BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).(Method).Results.CorSetp =CorSp;
%save(NameFile,'BBA');
%%
%%      Retour aux Valeurs initiales Qp et COR


setsp('QT',iniCor,QTDev);   % Init Cor

pause(retard);




%%      Recherche du minimum de la fonction de mérite
%load('resBBA.mat')
%data=BBA.(char(QuadFamilyList(j))).(NameQuadDev).(char(NamePlane)).MEC.Results.BpmData;
data=BpmVal;
datSize=size(data);


for r=1:datSize(2)     %itération sur les valeurs de correcteurs
    point=0;
    for t=1:datSize(1) %itération sur les valeurs des BPMs

        point=point+10*((data(t,r)-InitValBpm(t)))^2;
    end

    merit(r,1)=CorConsEye(r);
    merit(r,2)=1/datSize(1)*point;
end


droite=polyfit(CorConsEye,BpmResEye,1)        % calcul des coef de la droite du Bpm observé

BpmResEyeIni
BpmResEye
%% Verif
merit
%init:Moindres carrés

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

for e=1:41
    %ze(e)=min(BpmRes)+(e-1)*(max(BpmRes)-min(BpmRes))/40;
    ze(e)=CorTab(1)+(e-1)*(CorTab(nbDeltaCor)-CorTab(1))/40;
    %ze(e)=-2.5+(e-1)*5/40;
    ord1(e)=parabole(ze(e),coef);
    %ordco(e)=parabole(ze(e),valco);
    ord2(e)=ligne(ze(e),droite);
end
%toc;

for varTest=1:nbDeltaCor
    ecart(varTest)=merit(varTest,2)-parabole(CorTab(varTest),coef);
end

rmsFit=qualFit(merit(:,1),merit(:,2),coef);


% 
BBASext.Bpmres=BpmResEye

%BBASext.BpmresFam=BpmRes
BBASext.BpmresDev=BpmDevRes
BBASext.Init.BPmVal=BpmResEyeIni
BBASext.Init.AllBpm=InitValBpm
BBASext.Init.Cor=iniCor
BBASext.Cons.Cor=CorConsEye
BBASext.Cons.Cortab=CorTab
BBASext.Cons.Corcons=CorCons
BBASext.Results.merit=merit
BBASext.Results.offset=offs
BBASext.Results.centre=center
BBASext.Results.OffCor=center-iniCor
save(NameFile,'BBASext')

%
%Plane=2; % For running the prog on both Plane
%%    %$$$$$$$$$$$$$$$
%end
%NameFile
%BpmRes
CorCons
%droite=polyfit(CorCons,BpmRes,1)
iniCor
offs
center
ecart;
%CorDevListRes
%CorElemRes
%EffRes
disp('OffsCor')
OffsCor=center-iniCor


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



%save('resu.mat','merit','ze','ord1','ord2','droite','coef','CorCons','BpmRes','coef','center','offs')

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