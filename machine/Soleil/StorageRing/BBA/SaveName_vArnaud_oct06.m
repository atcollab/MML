function [numero,numText,Nametex]= SaveName(var)
%SAVENAME
% 
%  INPUTS
%  1. var - 0 Recherche du fichier du fichier le plus recent dans le repertoire de travail
%           1 creation d'un nouveau fichier de resultats du BBA 
%
%  OUPUTS
%  1. numero - numero du BBA
%  2. numText - numero du BBA au format texte
%  3. Nametex - nom du fichier en chaine de caracteres

ResList=cellstr('p');
%%%% DEBUT DE RECHERCHE DES RESULTATS ResBBA_*.mat
%Repert=pwd;
%Repert='/home/matlabML/measdata/Ringdata/BBA';
Repert= getfamilydata('Directory','BBA');
RepertRes=[Repert '/work3'];
%RepertRes=[Repert '/debug'];
Content=dir(RepertRes);

tail=size(Content);
i=0;
j=0;
while i< tail(1)
    i=i+1;
    nom=Content(i).name;
    Lnom0=size(nom);
    Lnom =Lnom0(2);
    if Lnom<15
        
    elseif strcmpi(nom(Lnom-2:Lnom),'mat') & strcmpi(nom(1:7),'ResBBA_')
    j=j+1;
    ResList(j,:)=cellstr(nom);
    numerList(j)=str2num(nom(8:11));
    end      
end

%ResList

if strcmpi(ResList(1),'p')
    numero=0+var;
    numText=['000' num2str(numero)];
    Nametex='ol';
else
    numero=max(numerList)+var;
    numText0=num2str(numero);
    varText='';
    if length(numText0)<4
        for i=1:4-length(numText0);
            varText=char([varText '0']);
        end
    end
    tailRes=size(ResList)
    numText=[varText numText0]
    Nametex=char(ResList(tailRes(1)))
end
