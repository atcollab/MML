
% Working directory for BBA data
cd('/home/matlabML/measdata/Ringdata/BBA/work2')
%/home/diag/diag/Matlab/DserverBPM/Set_BBA_Offsets_planH.m

% Load Last data file
%load('ResBBA_0826_07-Sep-2006.mat')
%load('ResBBA_1505_25-Sep-2006.mat')
load('ResBBA_1535_11-Oct-2006.mat')
%FileName = uigetfile('*.mat')
%load(FileName);
%load('ResBBA_1505_25-Sep-2006.mat')

%%
l = 0;
m = 0;


% Get quad familynames
famQ=fieldnames(BBA);
%famQ=cellstr('Q10')

lfamQ = size(famQ,1);

for ik = 1:lfamQ, % loop on families
    
    famQ{ik};

    devQ = fieldnames(BBA.(famQ{ik}));
    ldevQ = size(devQ,1);

    for j = 1:ldevQ, % loop on quads
        
        planeQ  = fieldnames(BBA.(famQ{ik}).(devQ{j}));
        lplaneQ = size(planeQ);

        for k = 1:lplaneQ, % loop on planes
            famQ{ik};
            devQ{j};

            tabpla = planeQ(k); %plane
            tabda  = BBA.(famQ{ik}).(devQ{j}).(planeQ{k}).MEC.Date; %date of measure
            taboff = BBA.(famQ{ik}).(devQ{j}).(planeQ{k}).MEC.Results.OffsetBpm; %BBA offset
            tabDevBpm=BBA.(famQ{ik}).(devQ{j}).(planeQ{k}).MEC.BpmDev; % BPM deviceliste

            %switchyard on plane
            if strcmpi(planeQ{k}, 'HPlane') % H-plane
                
                %search since a given date and store in arrays
                % TO BE IMPROVED
                if strcmpi(tabda(4:6),'Sep')
                    l = l+1;
                    tabdateH(l) = cellstr(tabda); % date
                    tabfamQH(l) = famQ(ik); % Quad family
                    tabdevQH(l) = devQ(j);  % Quad deviceliste  
                    tabplaneQH(l) = planeQ(k); % utility ?
                    taboffsetH(l,1)=taboff; %% BBA BPM offset
                    taboffsetH(l,2)=getspos('BPMx',tabDevBpm); % BPM s-position
                    tabDevBH(l,:)=tabDevBpm; % BPM devicelist
                end
                
            elseif strcmpi(planeQ{k}, 'VPlane') % V-plane

                %search since a given date 
                % TO BE IMPROVED
                if strcmpi(tabda(4:6),'Sep')
                    m=m+1;
                    tabdateV(m)=cellstr(tabda);
                    tabfamQV(m)=famQ(ik);
                    tabdevQV(m)=devQ(j);
                    tabplaneQV(m)=planeQ(k);
                    taboffsetV(m,1)=taboff;
                    taboffsetV(m,2)=getspos('BPMz',tabDevBpm);
                    tabDevBV(m,:)=tabDevBpm;

                end

            end

        end
    end
end

%cd '/home/matlabML/measdata/Ringdata/BBA/debug'
%save('donne.mat','tabdateH','tabfamQH','tabdevQH','tabplaneQH','tabdateV','tabfamQV','tabdevQV','tabplaneQV')


% Redundant to be compressed and improved
for i = 1:length(tabfamQV),
    recaV(i,1)=tabfamQV(i);
    recaV(i,2)=tabdevQV(i);
    recaV(i,3)=cellstr(num2str(tabDevBV(i,:)));
    recaV(i,4)=cellstr(num2str(taboffsetV(i,1)));
    sortieV(i,1)=dev2tangodev('BPMz',tabDevBV(i,:));
    sortieV(i,2)=cellstr(num2str(taboffsetV(i,1)));
end

for i=1:length(tabfamQH)

    recaH(i,1)=tabfamQH(i);
    recaH(i,2)=tabdevQH(i);
    recaH(i,3)=cellstr(num2str(tabDevBH(i,:)));
    recaH(i,4)=cellstr(num2str(taboffsetH(i,1)));
    
    sortieH(i,1)=dev2tangodev('BPMx',tabDevBH(i,:));
    sortieH(i,2)=cellstr(num2str(taboffsetH(i,1)));
end

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù')
disp('VPLANE')
% TO DO in an external file
disp(recaV);

% sorting on BPM s-position
[resV, indV] = sort(taboffsetV(:,2),1,'ascend');

% resort everything along the ring position
for i = 1:length(resV),
    ordonneV(i)=taboffsetV(indV(i));
    SortV(i,1)=sortieV(indV(i),1); % BPM devicelist
    SortV(i,2)=sortieV(indV(i),2); % BPM offset
    SortV(i,3)=tabfamQV(indV(i));  % quad family
    SortV(i,4)=tabdevQV(indV(i));  % quad deviceliste
    nom=char(tabdevQV(indV(i)));
    in2=findstr(nom,'_');
    in1=findstr(nom,'v');
    SortV(i,5) = cellstr(dev2tango(char(tabfamQV(indV(i))),[str2num(nom(in1:in2-1)) str2num(nom(in2+1:length(nom)))]));
end

% V-plane
figure(1)

plot(resV(:,1),ordonneV,'marker','o')
xlabel('s [m]')
ylabel('Zoffset (mm)')
grid on
fprintf('Nombre de BBA: %d\n', length(tabfamQV))
fprintf('ecart type: %4.1f um rms\n', std(ordonneV)*1e3)
fprintf('moyenne: %4.1f um \n\n', mean(ordonneV)*1e3)

figure(2)
hist(ordonneV,20)
xlabel('Zoffset [mm]');
ylabel('Nb de BPM');

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('HPLANE')
disp(recaH);

taboffsetH;
% sorting on BPM s-position
[resH,indH] = sort(taboffsetH(:,2),1,'ascend');

%disp(recaH(:,4));
% resort everything along the ring position
for i=1:length(resH),
    ordonneH(i)=taboffsetH(indH(i));
    SortH(i,1)=sortieH(indH(i),1);
    SortH(i,2)=sortieH(indH(i),2);
    SortH(i,3)=tabfamQH(indH(i));
    SortH(i,4)=tabdevQH(indH(i));
    nom=char(tabdevQH(indH(i)));
    in2=findstr(nom,'_');
    in1=findstr(nom,'v');
    SortH(i,5)=cellstr(dev2tango(char(tabfamQH(indH(i))),[str2num(nom(in1:in2-1)) str2num(nom(in2+1:length(nom)))]));
end

figure(3)
plot(resH(:,1),ordonneH,'marker','o')
xlabel('s [m]')
ylabel('Xoffset (mm)')
grid on

fprintf('Nombre de BBA: %d\n', length(tabfamQH))
fprintf('ecart type: %4.1f um rms\n', std(ordonneH)*1e3)
fprintf('moyenne: %4.1f um \n\n', mean(ordonneH)*1e3)

figure(4)
hist(ordonneH)
xlabel('Xoffset [mm]');
ylabel('Nb de BPM');

%cd '/home/matlabML/mmlcontrol/Ringspecific/fonction_test/'%Sauvegarde_beta_sept06 (betameasX,betameasZ)

% Load betafunctions given by MAT
% TO BE IMPROVED for a bit wrong and not generic
cd('/home/matlabML/measdata/Ringdata/QUAD');
load('Sauvegarde_beta_sept06')
betameasX;
betameasZ;

% Build up quad list
for i=1:10,
    FamQpTri{i} = ['Q' num2str(i)];
end


k=0;
for i=1:10, % loop on family
    devtri = getlist(FamQpTri{i}); % Get devicelist for vali QUAD
    for j=1:length(devtri) % loop on devices
        k=k+1;
        FamTriTot(k) =  FamQpTri(i);
        devTriQp(k,:) = devtri(j,:);
    end
end


for i=1:length(FamTriTot),
    tabBetaX(i,1)=FamTriTot(i); % Family
    tabBetaX(i,2)=cellstr(num2str(devTriQp(i,:))); %Device
    tabBetaX(i,3)=cellstr(dev2tango(char(FamTriTot(i)),devTriQp(i,:))); % Tango names
    tabBetaX(i,4)=cellstr(num2str(betameasX(i))); % betafunction
    tabBetaZ(i,1)=FamTriTot(i);
    tabBetaZ(i,2)=cellstr(num2str(devTriQp(i,:)));
    tabBetaZ(i,3)=cellstr(dev2tango(char(FamTriTot(i)),devTriQp(i,:)));
    tabBetaZ(i,4)=cellstr(num2str(betameasZ(i)));
    %tabBetaZ(i,5)=cellstr(num2str(betameasX(i)));
end

%%
cd('/home/matlabML/measdata/Ringdata/BBA/debug');
%save('tabBe.mat','tabBetaX','SortH')
%load('tabBe.mat')
tabBetaX;

l=1;
i=1;

% plan H
length(SortH);
%compute final offset with weigthed avarage when several quads for same BPM
% TO BE IMPROVE
while i < length(SortH)+1
    l;
    i;
    if i < length(SortH) && strcmpi(char(SortH(i,1)),char(SortH(i+1,1))) ; %si j'ai deux meme BPM

        for j = 1:length(tabBetaX),
            
            if strcmpi(char(SortH(i,5)),char(tabBetaX(j,3))), %je resort le premier quad correspondant
                l;
               
                %disp('first')
                char(SortH(i,3));
                betaQ1 = str2double(char(tabBetaX(j,4)));
                kQ1    = getkleff(char(SortH(i,3)),1); % BEWARE !! Theory only and depend on lattice
                oQ1    = str2double(char(SortH(i,2))); % Offset BPM
            end

            if strcmpi(char(SortH(i+1,5)),char(tabBetaX(j,3)))      %et le deuxième
                %disp('second');
                char(SortH(i+1,3));
                betaQ2=str2double(char(tabBetaX(j,4)));
                kQ2=getkleff(char(SortH(i+1,3)),1);
                oQ2=str2double(char(SortH(i+1,2)));
            end
        end
        
        %je calcule l'offset
         l;
        char(SortH(i+1,3));
        char(SortH(i,3));
        oQ1;
        kQ1;
        betaQ1;
        oQ2;
        kQ2;
        betaQ2;
        % weighted avarage using betafunction and K values
        newoff = (sqrt(betaQ1)*abs(kQ1)*oQ1 + sqrt(betaQ2)*abs(kQ2)*oQ2)/(sqrt(betaQ1)*abs(kQ1)+sqrt(betaQ2)*abs(kQ2));

        offH(l,1) = SortH(i,1); %devBPM
        offH(l,2) = cellstr(num2str(newoff));
        l = l+1;
        i = i+2;
        % elseif i>1 && strcmpi(char(SortH(i,1)),char(SortH(i-1,1)))
        %     disp('ola2')
        %     i=i+1;
    else % if unique, just keep value given by BBA measurement programme

        offH(l,1)=SortH(i,1);
        offH(l,2)=SortH(i,2);
        l=l+1;
        i=i+1;
    end
end

% final results
tableBBAH = offH;


%plan V
length(SortV);
l=1;
i=1;
while i<length(SortV)+1

    l;
    i;
    if i<length(SortV) && strcmpi(char(SortV(i,1)),char(SortV(i+1,1))) ; %si j'ai deux meme BPM

        for j=1:length(tabBetaZ)
            if strcmpi(char(SortV(i,5)),char(tabBetaZ(j,3))) %je resort le premier quad correspondant
                betaQ1=str2num(char(tabBetaZ(j,4)));
                kQ1=getkleff(char(SortV(i,3)));
                kQ1=kQ1(1);
                oQ1=str2num(char(SortV(i,2)));
            end

            if strcmpi(char(SortV(i+1,5)),char(tabBetaZ(j,3)))      %et le deuxième
                betaQ2=str2num(char(tabBetaZ(j,4)));
                kQ2=getkleff(char(SortV(i+1,3)));
                kQ2=kQ2(1);
                oQ2=str2num(char(SortV(i+1,2)));
            end
        end
        %je calcule l'offset
        l;
        oQ1;
        kQ1;
        betaQ1;
        oQ2;
        kQ2;
        betaQ2;

        newoff=(sqrt(betaQ1)*abs(kQ1)*oQ1 + sqrt(betaQ2)*abs(kQ2)*oQ2)/(sqrt(betaQ1)*abs(kQ1)+sqrt(betaQ2)*abs(kQ2));
        offV(l,1)=SortV(i,1); %devBPM
        offV(l,2)=cellstr(num2str(newoff));
        l=l+1;
        i=i+2;
        % elseif i>1 && strcmpi(char(SortV(i,1)),char(SortV(i-1,1)))
        %     disp('ola2')
        %     i=i+1;
    else

        offV(l,1)=SortV(i,1);
        offV(l,2)=SortV(i,2);
        l=l+1;
        i=i+1;
    end
end

%final results
tableBBAV=offV;



cd '/home/matlabML/measdata/Ringdata/BBA/work2'

% Save everything for diags
% Be carefull if files already exist !!!!
%save('tableBBAH.mat','tableBBAH') %dans work 2, tableBBA
%save('tableBBAV.mat','tableBBAV')

%offH
