function [CorFamRes,CorDevRes,CorElemRes,MaxEffRes,BpmFamRes,BpmDevRes]= mec(QuadFamily,QuadDev,Plane,CorBpmResp,CorNumb)
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
% 3. MaxEffRes: Efficacity of the MEC in mm/A
%

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





load('respcor.mat')

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
    


%Most Effective Corrector

%BPM le plus proche du Qp (QuadFamily,[QuadDev]);
[BpmFam2,BpmDev,BpmPos]=proche2(BpmFam,QuadFamily,QuadDev,0);

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


