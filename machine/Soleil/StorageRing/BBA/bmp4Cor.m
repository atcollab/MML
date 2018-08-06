function [CorFamRes,CorDevListRes,BpmFamRes,BpmDevListRes,BpmEyeRes,ConsRes]=bmp4Cor(QuadFamilyList,QuadDevList,Plane)
%clear
%load('HrzCOR.mat');
%Donn�es stock�e dans HrzCOR.mat � partir du prog eff2.m
%save('HrzCOR.mat','listHCOR','listBPMx','repInit','rep','effic','famQp','famQtot','listfamQtot','famBp','indBp','posBp','amplEff','HCORtrouv','famQtrouv','indQtrouv','nbH','indnbH','nbHCOR');

if     Plane==1 
            BpmFam='BPMx';
            CorFam='HCOR';
            NamePlane='HPlane';
            %CorBpmResp=efficacy.HPlane; %effic(Cor,Bpm)
            BpmMax=37;
    elseif Plane==2
            BpmFam='BPMz';
            CorFam='VCOR';
            NamePlane='VPlane';
            %CorBpmResp=efficacy.VPlane;
            BpmMax=4.5;
    else
        error('input must "1" for horizontal plane or "2" for vertical plane');
    
end

% OPTION ALL Qp
%for i=1:160 %length(famQtot) % <=> famQtot = vecteur de longueur 160 contenant toutes les familles Qp: 'Q1','Q1'...
    disp('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$')
    %tailleQp=size(QuadFamilyList);
    
    for i=1:length(QuadFamilyList)
        
    
    %listfamQtot(i,:);
    %indBp(i,:);
    if Plane==1
    [famCb1,indCb1,posHb1]=proche2(CorFam,char(QuadFamilyList(i)),QuadDevList(i,:),-1);      % Hb1= first  HCOR before Qp [cell elt]
    [famCa1,indCa1,posHa1]=proche2(CorFam,char(QuadFamilyList(i)),QuadDevList(i,:),1);       % Ha1= first  HCOR after  Qp [cell elt]
    [famCb2,indCb2,posHb2]=proche2(CorFam,CorFam,indCb1,-1);                % Hb2= second HCOR before Qp [cell elt]
    [famCa2,indCa2,posHa2]=proche2(CorFam,CorFam,indCa1,1);                 % Ha2= second HCOR after  Qp [cell elt]
    
    % Hb2 Hb1 Qp Ha1 Ha2
    
   % [famBa1,indBa1,posBb1]=proche2(BpmFam,CorFam,indCb1,1)           % Bb1 = first  BPM after  HCOR "Hb1"
   % [famBa2,indBa2,posBb2]=proche2(BpmFam,BpmFam,indBa1,1)          % Bb2 = second BPM after  HCOR "Hb1"
   % 
   % [famBb1,indBb1,posBa1]=proche2(BpmFam,CorFam,indCa1,-1)         % Ba1 = first  BPM before HCOR "Ha1"
   % [famBb2,indBb2,posBa2]=proche2(BpmFam,CorFam,indBb1,-1)
    
    
    %[famBqb1,indBqb1,posBqb1]=proche2('BPMx',char(famQtot(i)),listfamQtot(i,:),-1);    % Bqb1 = first   BPM before Qp [cell elt]
    %[famBqa1,indBqa1,posBqa1]=proche2('BPMx',char(famQtot(i)),listfamQtot(i,:),1);     % Bqa1 = first   BPM after  Qp [cell elt]
    
     %Il y a soit 2 BPM soit 3 BPM entre deux HCOR 
    
         %if (sum(indBb1-indBa1)==0) | (sum(indBb1-indBa2)==0)
         %    vecBp=[indBa1;indBa2];
         %    cons=[1;1];
         %else
         %    vecBp=[indBa1;indBa2;indBb1];
         %    cons=[1;1;1]
         %end
     elseif Plane==2
         [famB0,indB0,posB0]=proche2(BpmFam,QuadFamilyList(i),QuadDevList(i,:),0);
         [famBb1,indBb1,posb1]=proche2(BpmFam,QuadFamilyList(i),QuadDevList(i,:),-1);
         [famBa1,indBa1,posa1]=proche2(BpmFam,QuadFamilyList(i),QuadDevList(i,:),1 );
         testVecBp=[indBb1;indBa1]-[indB0;indB0];
         testVec1(1)=sum(testVecBp(1,:));
         testVec1(2)=sum(testVecBp(2,:));
         
         if testVec1(1)==0
             %les cor avant Qp seront recherchés à partir de indB0
             %les cor après Qp seront recherché à partir de Qp
             [famCb1,indCb1,posCb1]=proche2(CorFam,BpmFam,indB0,-1);
             [famCb2,indCb2,posCb2]=proche2(CorFam,famCb1,indCb1,-1)
             
             [famCa1,indCa1,posCa1]=proche2(CorFam,QuadFamilyList(i),QuadDevList(i,:),1);
             [famCa2,indCa2,posCa2]=proche2(CorFam,famCa1,indCa1,1);
             
             %quels sont les bpm compris entre Cb1 et Ca1
             %comparer tous les Bpm après le premier correcteur avant (Cb1) avec le premier avant 
             
            
             
             
             
         elseif testVec1(2)==0
             %les cor avant Qp seront recherché à partir de Qp
             %les cor après Qp seront recherché à partir de indB0
             
             [famCb1,indCb1,posb1]=proche2(CorFam,QuadFamilyList(i),QuadDevList(i,:),-1);
             [famCb2,indCb2,posb2]=proche2(CorFam,famCb1,indCb1,-1);
             
             [famCa1,indCa1,posa1]=proche2(CorFam,BpmFam,indB0,1);
             [famCa2,indCa2,posa2]=proche2(CorFam,famCa1,indCa1,1);
             
                      
            
             
         end
          
    end
     [famBt0,indBt0,post0]=proche2(BpmFam,famCa1,indCa1,-1); % first BPM before Ca1
             
             var=0;
             condi=10;
             famBt1=famCb1;
             indBt1=indCb1;
             while abs(condi)>0
                 var=var+1;
                 [famBt1,indBt1,posBt1]=proche2(BpmFam,famBt1,indBt1,1);
                 famBtSol(var)=cellstr(famBt1);
                 indBtSol(var,:)=indBt1;
                 posBtSol(var)=posBt1;
                 condi=indBtSol(var,:)-indBt0;
                 condi=sum(condi);
                 %disp(condi);
                 %disp(var);
             end
         for j=1:var
             vecBp(j,:)=indBtSol(j,:);
             cons(j)=1;
         end
    
    [famYQp,indYQp,posYQp]=proche2(BpmFam,char(QuadFamilyList(i)),QuadDevList(i,:),0,vecBp);
    
    CorFamRes=CorFam;
    CorDevListRes=[indCb2; indCb1; indCa1; indCa2];
    BpmFamRes=BpmFam;
    BpmDevListRes=vecBp;
    BpmEyeRes=indYQp;
    ConsRes=cons;
   
end

%save('bmp4.mat','indC','valH','famQtot','listfamQtot')