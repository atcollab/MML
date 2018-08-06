function [CorFamRes,CorDevRes,CorElemRes,MaxEffRes,BpmFamRes,BpmDevRes]= mec3(QuadFamily,QuadDev,Plane,CorBpmResp,CorNumb)
% MEC
% function [CorFam,CorDev,MaxEff]= mec(QuadFamily,QuadDev,Plane,CorBpmResp)
%
% INPUTS                                                             -> VALUES
%
% 1. QuadFamily: Family of the quadrupole studied                    -> 'Q2'
% 2. QuadDev:    [cell elt] of the quadrupole studied                -> [1 1]
% 3. Plane:      Plane=1 horizontal only
%                     =2 vertical only          
% 4. CorBpmResp: Response matrix of correctors obtained from "respcor(plane)"
%
%
% OUPUTS
%
% 1. CorFamRes: Family of the Most Effective Corrector found 
% 2. CorDevRes: [cell elt] of the MEC found
% 3. CorElemRes : numero element du correcteur (equivalent à getlist)
% 4. MaxEffRes: Efficiency of the MEC in mm/A
% 5. BpmFamRes : Famille du bpm choisi
% 6. BpmDevRes : nomenclature [cell element] du bpm choisi

if ~iscellstr(QuadFamily)
 error('la famille entree n est pas au format cell')
end

tailleQDev=size(QuadDev(1,:));
tailleCorBpm=size(CorBpmResp);

if isempty(QuadDev)
    error('Veuillez entrer le device du quadripole à étudier au format QuadDev=[cell elt]')
elseif tailleQDev(2)~=2
    error('Trop d''elements pour 1 device de QP:  QuadDev=[cell elt]')
end

if Plane<0 || Plane>2
    error('Veuillez entrer le plan étudié: Horizontal: Plane=1 ; Vertical:Plane=2 ; Both:Plane=0')
end

if tailleCorBpm(1)~=56 & tailleCorBpm(2)~=120
  error('Veuillez vérifier la matrice réponse correcteurs/BPM')
end





%load('respcor.mat')  

if    Plane==1 
        BpmFam='BPMx';
        CorFam='HCOR';
        %CorBpmResp=efficacy.HPLane; %effic(Cor,Bpm)
elseif Plane==2
        BpmFam='BPMz';
        CorFam='VCOR';
        %CorBpmResp=efficacy.VPlane;
else
    error('input must "1" for horizontal plane or "2" for vertical plane');
end
    
% debugage des BPM non pris en compte! pour Q10.1, Q10.2 et Q5.1 dans cell 4, 8, 12, 16

if strcmpi(char(QuadFamily),'Q5') && (QuadDev(1,1)==4 || QuadDev(1,1)==8 || QuadDev(1,1)==12 || QuadDev(1,1)==16)
    %Q5.1 dans cell 4, 8, 12, 16
    [BpmFam2,BpmDev,BpmPos]=proche2(BpmFam,QuadFamily,QuadDev,1);
elseif strcmpi(char(QuadFamily),'Q10') && (QuadDev(1,1)==2 || QuadDev(1,1)==6 || QuadDev(1,1)==10 || QuadDev(1,1)==14 ||...
        QuadDev(1,1)==3 || QuadDev(1,1)==7 || QuadDev(1,1)==11 || QuadDev(1,1)==15)
    if QuadDev(1,2)==1
        %Q10.1
        [BpmFam2,BpmDev,BpmPos]=proche2(BpmFam,QuadFamily,QuadDev,1);
    elseif  QuadDev(1,2)==2
        %Q10.2
        [BpmFam2,BpmDev,BpmPos]=proche2(BpmFam,QuadFamily,QuadDev,-1);
    end
else % calcul normal!
    

    %BPM le plus proche du Qp (QuadFamily,[QuadDev]);
    [BpmFam2,BpmDev,BpmPos]=proche2(BpmFam,QuadFamily,QuadDev,0);
end
indBpm=dev2elem(BpmFam,BpmDev);
% Faire un tri sur EffCor de manière � pouvoir choisir par exemple le 2ème correcteurs le plus
% efficace si le premier ne convient pas...  
EffCor=CorBpmResp(:,indBpm);        % vecteur colonne de longueur nb HCOR ou nb VCOR
[posEff,indEff]=sort(abs(EffCor),'descend');

%MaxEff=max(abs(EffCor));            % extraction de l'efficacité max
MaxEff=posEff(CorNumb);
%indCor=find(abs(EffCor)==MaxEff);   % recherche de l'indice de l'efficacité max dans "EffCor"
indCor=indEff(CorNumb);
CorDevList=getlist(CorFam);

%R�sultats
CorFamRes=CorFam;
CorDevRes=CorDevList(indCor,:); 
CorElemRes=indCor; % Recherche du correcteur d�livrant l'efficacit� pr�c�dente
MaxEffRes=MaxEff;
BpmFamRes=BpmFam;
BpmDevRes=BpmDev;




%**************************************************************************


