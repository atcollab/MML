function [FamRes,DevRes,PosRes]=proche2(FamR,FamC,DevC,valdes,FamRloc);
% function [FamRes,DevRes,PosRes]=proche2(FamR,FamC,DevC,valdes,FamRloc);
%
% INPUTS                                                             -> VALUES
%
% 1. FamR: Family of the element looked for                          -> 'HCOR'
% 2. FamC: Family of the element studied                             -> 'BPMx'
% 3. DevC: [cell elt] of FamC                                        -> [2 3]
% 4. valdes: integer to choose the relative location of the element of FamR
%               valdes=-1 : FamR element located before  (FamC,DevC) -> -1
%               valdes= 1 : FamR element located after   (FamC,DevC) ->  1
%               valdes= 0 : closest element of FamR from (FamC,DevC) ->  0
% 5. FamRloc: [cell elt;cell elt; ...]                               -> [1 2;3 6;8 4;...]
%             optional input, used if it is necessary to reduce the FamR element list
%
%
% OUPUTS
%
% 1. FamRes: Family of the element found (FamRes=FamR)
%               generally FamRes=FamR
%               but if FamR='Q', FamRes='Q1' | 'Q2' | ... | 'Q10'
% 2. DevRes: [cell elt] of the element found
% 3. PosRes: "s" position of the element found
%

%NOTES 
%FamRes = Famr dans tout les cas sauf lorsque FamR='Q'
% <=> recherche du Qp le plus proche de FamC @DevC
% ATTENTION MAchine dependent
% Use getcircumference instead
% Use number of quad instead
% trick of 3 rings instead of one

% RECHERCHE DES POSITIONS DES BPMx
%FamRloc=getlist(FamR);
%dim=length(FamRloc);

%i=1:dim;
%pos=getspos(FamR,FamRloc(i,:));

% CREATION AUTOMATIQUE D'UN TABLEAU AVEC TOUTES LES FAMILLES DES QP
% <=>FamQp=['Q1' 'Q2' 'Q3' 'Q4' 'Q5' 'Q6' 'Q7' 'Q8' 'Q9' 'Q10' ]


for i=1:10
    FamQp(i)=cellstr(strcat('Q',num2str(i)));
end


% Traduction des variables d'entr�e
nameC=char(FamC);
cellule=DevC(1);
element=DevC(2);

% cell1 = cellules o� on trouve Q1,Q2,Q3,Q4,Q5
cell1=[1 4 5 8 9 12 13 16];
% cell2 = cellules o� on trouve Q9,Q10
cell2=[2 3 6 7 10 11 14 15];
% Q6,Q7,Q8 dans toutes les cellules : OK

longN=length(nameC);
%FamRloc=zeros()
nameC(1)=='Q'                          
       nameC(2)=='T'
if(FamR=='Q')   % Si la Famille d'entr�e est seulement 'Q' <=> on veut scruter tous les Qp
    init=0;
    FamR=FamQp; % FamR doit contenir toutes les Fammilles de QP
    for j=1:10
        
        FamRloc=getlist(char(FamR(j)));
        % FamRloc=[cell elt] de la Famille 'Qj'
       
        %listFamR
       
        
        lfQ=length(FamRloc); % length(FamRloc)=8 pour Q1,Q2,Q3| =16 pour Q4,Q5,Q9,Q10| =24 pour Q6,Q7,Q8
        for i=1:lfQ
            % FamQloc  =  [  'Q1'  ;  'Q1'  ;'Q1';...;'Q1';'Q2';...;'Q2';.......;'Q10' ]
            % FamRloc  =  [cell elt;cell elt;....;...;....;....;...;....;.......;....% ]
            % posQint  =  [  spos     spos   .... ... .... .... ... .... ....... ......]
            FamQloc(i+init,:)=FamR(j);
            FamRloc2(i+init,:)=FamRloc(i,:);
            posQint(i+init)=getspos(char(FamR(j)),FamRloc(i,:)); % posQint = position s de [cell elt] de 'Qj'
        end
        init=init+length(FamRloc);
    end
    
    posQ=getspos(char(nameC),DevC);     % posQ = position s de DevC=[cell elt] de de la Famille FamC=nameC
    for i=1:160
        if (abs(posQint(i)-posQ)>177 && posQint(i)-posQ>0) || (abs(posQint(i)-posQ)<177 && posQint(i)-posQ<0)
                            condit=-1;
        elseif (abs(posQint(i)-posQ)<177 && posQint(i)-posQ>0) || (abs(posQint(i)-posQ)>177 && posQint(i)-posQ<0)
                            condit=1;
        else 
            condit=0;
        end
        poscalc(i)=min([abs(posQint(i)-posQ) 354-abs(posQint(i)-posQ)]);
        poscalcBis(i,:)=[min([abs(posQint(i)-posQ) 354-abs(posQint(i)-posQ)]) condit];
        
    end
    %tri
    [posTri,indTri]=sort(poscalc,'ascend');
    FamQloc;
    FamRloc2;
    indNear=indTri(1);
    % OUTPUT
    FamRes=FamQloc(indNear,:);          % FamRes = Famille du Qp le plus proche
    DevRes=FamRloc2(indNear,:);          % DevRes = [cell elt] du Qp le plus proche
    PosRes=getspos(char(FamQloc(indNear,:)),FamRloc2(indNear,:));% PosRes = position s du Qp le plus proche

    cond=poscalcBis(indTri(1),2);

    %TRAITEMENT DES CONDITIONS AVANT / APRES : 1 0 -1
    if (valdes==0)
        FamRes=FamRes;          % FamRes = Famille du Qp le plus proche
        DevRes=DevRes;          % DevRes = [cell elt] du Qp le plus proche
        PosRes=PosRes;
    elseif(valdes==1)
        if(cond>0)
        FamRes=FamRes;
        DevRes=DevRes;
        PosRes=PosRes;
        elseif(cond<=0)
            i=1;
            while cond<=0
            indNear=indTri(i);
            cond=poscalcBis(indTri(i),2);
            FamRes=FamQloc(indNear,:);     
            DevRes=FamRloc2(indNear,:);          
            PosRes=getspos(char(FamQloc(indNear,:)),FamRloc2(indNear,:));
            i=i+1;
            end
        end
    elseif(valdes==-1)
        if(cond<0)
        FamRes=FamRes;
        DevRes=DevRes;
        PosRes=PosRes;
        elseif(cond>=0)
              i=1;
            while cond>=0
               
            indNear=indTri(i);
            cond=poscalcBis(indTri(i),2);
            FamRes=FamQloc(indNear,:);         
            DevRes=FamRloc2(indNear,:);       
            PosRes=getspos(cellstr(FamRes),DevRes);
            i=i+1;
            end
        end
    end
   
       
% si nameC=FamR = Qi, il se peut que DevC=[cell elt] n'existe pas!
    %CAS 1
elseif (nameC(2)~='T') && (nameC(1)=='Q') && (str2num(nameC(longN))< 6) &&  (str2num(nameC(longN))> 0) && isempty(find(cell1==cellule)) 
    disp('cas1');
    disp(nameC(1));
    disp(nameC(longN));
    FamRes='error';
    DevRes='error';
    PosRes='error';
    disp('la Famille existe pas dans la cellule demand�e')
    
    %CAS 2
elseif (nameC(2)~='T') && (nameC(1)=='Q') && ((str2num(nameC(longN)) > 8) | (str2num(nameC(longN)) < 1)) && isempty(find(cell2==cellule))
    disp('cas2');
    disp(nameC(1));
    disp(nameC(longN)+1);
    FamRes='error';
    DevRes='error';
    PosRes='error';
    disp('la Famille existe pas dans la cellule demand�e')
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

    %PAS DE PROBLEME !!!
else
    if nargin < 5 
        FamRloc=getlist(FamR);
    end
    
    dim=length(FamRloc);
    
    for i=1:dim
        pos(i)=getspos(FamR,FamRloc(i,:));
    end
    
    posC1=getspos(nameC,DevC); %Recheche position "s" de nameC
    %nearest=abs(pos-posC1);
    %indNear=find(nearest==min(nearest));
    %PosRes=getspos(FamR,FamRloc(indNear,:));
    
        %PosRes=PosRes;
        %DevRes=FamRloc(indNear,:);
        %FamRes=FamR;
       
        

    for i=1:dim
        if (abs(pos(i)-posC1)>177 && pos(i)-posC1>0) || (abs(pos(i)-posC1)<177 && pos(i)-posC1<0)
                            condit=-1;
        elseif (abs(pos(i)-posC1)<177 && pos(i)-posC1>0) || (abs(pos(i)-posC1)>177 && pos(i)-posC1<0)
                            condit=1;
        else 
            condit=0;
        end
        poscalc(i)=min([abs(pos(i)-posC1) 354-abs(pos(i)-posC1)]);
        poscalcBis(i,:)=[min([abs(pos(i)-posC1) 354-abs(pos(i)-posC1)]) condit];
    end
    %tri
    [posTri,indTri]=sort(abs(poscalc),'ascend');
    %nearest=abs(poscalc);
    indNear=indTri(1);
    % OUTPUT
    FamRes=FamR;                                    % FamRes = Famille du Qp le plus proche
    DevRes=FamRloc(indNear,:);                      % DevRes = [cell elt] du Qp le plus proche
    PosRes=getspos(char(FamR),FamRloc(indNear,:));  % PosRes = position s du Qp le plus proche
    
    cond=poscalcBis(indTri(1),2);
    
    %TRAITEMENT DES CONDITIONS AVANT / APRES : 1 0 -1
    if (valdes==0)
        FamRes=FamRes;          % FamRes = Famille du Qp le plus proche
        DevRes=DevRes;          % DevRes = [cell elt] du Qp le plus proche
        PosRes=PosRes;          % PosRes = position s du Qp le plus proche
    elseif(valdes==1)
        if(cond>0)
        FamRes=FamRes;
        DevRes=DevRes;
        PosRes=PosRes;
        elseif(cond<=0)
            i=1;
            while cond<=0 
            indNear=indTri(i);
            cond=poscalcBis(indTri(i),2);
            FamRes=FamR;          
            DevRes=FamRloc(indNear,:);          
            PosRes=getspos(char(FamR),FamRloc(indNear,:));
            i=i+1;
            end
        end
    elseif(valdes==-1)
        if(cond<0)
        FamRes=FamRes;
        DevRes=DevRes;
        PosRes=PosRes;
        elseif(cond>=0)
              i=1;
            while cond>=0
            indNear=indTri(i);
            cond=poscalcBis(indTri(i),2);
            FamRes=FamR;          
            DevRes=FamRloc(indNear,:);          
            PosRes=getspos(char(FamR),FamRloc(indNear,:));
            i=i+1;
            end
        end
    end
end
save('data.mat','poscalc','poscalcBis','PosRes','cond','posTri','indTri','FamRloc');

