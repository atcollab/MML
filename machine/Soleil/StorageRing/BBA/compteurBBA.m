function compteurBBA(varargin)
% analyse results of BBA from a file of type : ResBBA_numero_Date.mat
% INPUT
%  'Yes' if you want to write the specific file for offset application on
%  file tableBBAH.mat and tableBBAV.mat
%  'No' if you just want to evaluate results on file result.txt
% OUTPUTS
%   if 'yes' tableBBAH.mat and tableBBAV.mat
%   if 'no' result.txt
%

if nargin < 1
    error('compteurBBA input required');
    return
end

if strcmpi(varargin,'Yes')
    Application = 1;
elseif strcmpi(varargin,'No')
    Application = 0;
end


Rep = getfamilydata('Directory','BBA');
WorkingDirectory = uigetdir(Rep);               % Working directory for BBA data
cd(WorkingDirectory)
disp('  ****************************************************************************');
disp('  **                             WARNING                                    **');
disp('  **    Choose the last BBA file for offset application                     **');
disp('  **                                                                        **');
disp('  ****************************************************************************');
[FileName,PathName] = uigetfile('*.mat','Select the M-file') % please choose the last file
load(FileName)                                  % Load data file


%%
l = 0;
m = 0;
famQ=fieldnames(BBA);                           % Get quad familynames
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
                %%       if strcmpi(tabda(4:6),'Sep')
                l = l+1;
                tabdateH(l) = cellstr(tabda); % date
                tabfamQH(l) = famQ(ik); % Quad family
                tabdevQH(l) = devQ(j);  % Quad deviceliste
                tabplaneQH(l) = planeQ(k); % utility ?
                taboffsetH(l,1)=taboff; %% BBA BPM offset
                taboffsetH(l,2)=getspos('BPMx',tabDevBpm); % BPM s-position
                tabDevBH(l,:)=tabDevBpm; % BPM devicelist
                %%      end

            elseif strcmpi(planeQ{k}, 'VPlane') % V-plane

                %search since a given date
                % TO BE IMPROVED
                %%      if strcmpi(tabda(4:6),'Sep')
                m=m+1;
                tabdateV(m)=cellstr(tabda);
                tabfamQV(m)=famQ(ik);
                tabdevQV(m)=devQ(j);
                tabplaneQV(m)=planeQ(k);
                taboffsetV(m,1)=taboff;
                taboffsetV(m,2)=getspos('BPMz',tabDevBpm);
                tabDevBV(m,:)=tabDevBpm;

                %%     end

            end

        end
    end
end

%cd '/home/matlabML/measdata/Ringdata/BBA/debug'
%save('donne.mat','tabdateH','tabfamQH','tabdevQH','tabplaneQH','tabdateV','tabfamQV','tabdevQV','tabplaneQV')


% Redundant to be compressed and improved
testV = exist('tabfamQV') ; testH = exist('tabfamQH') ;
if testV~=0
    for i = 1:length(tabfamQV),
        recaV(i,1)=tabfamQV(i);
        recaV(i,2)=tabdevQV(i);
        recaV(i,3)=cellstr(num2str(tabDevBV(i,:)));
        recaV(i,4)=cellstr(num2str(taboffsetV(i,1)));
        sortieV(i,1)=dev2tangodev('BPMz',tabDevBV(i,:));
        sortieV(i,2)=cellstr(num2str(taboffsetV(i,1)));
    end
end
if testH~=0
    for i=1:length(tabfamQH)
        recaH(i,1)=tabfamQH(i);
        recaH(i,2)=tabdevQH(i);
        recaH(i,3)=cellstr(num2str(tabDevBH(i,:)));
        recaH(i,4)=cellstr(num2str(taboffsetH(i,1)));
        sortieH(i,1)=dev2tangodev('BPMx',tabDevBH(i,:));
        sortieH(i,2)=cellstr(num2str(taboffsetH(i,1)));
    end
end

%%
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù')
disp('VPLANE')
% TO DO in an external file


if testV~=0
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
    figure(2)

    plot(resV(:,1),ordonneV,'marker','o')
    xlabel('s [m]')
    ylabel('Zoffset (mm)')
    grid on
    fprintf('Nombre de BBA: %d\n', length(tabfamQV))
    fprintf('ecart type: %4.1f um rms\n', std(ordonneV)*1e3)
    fprintf('moyenne: %4.1f um \n\n', mean(ordonneV)*1e3)

    figure(3)
    hist(ordonneV,20)
    xlabel('Zoffset [mm]');
    ylabel('Nb de BPM');
end
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('HPLANE')
disp(recaH);

if testH~=0
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

    figure(4)
    plot(resH(:,1),ordonneH,'marker','o')
    xlabel('s [m]')
    ylabel('Xoffset (mm)')
    grid on

    fprintf('Nombre de BBA: %d\n', length(tabfamQH))
    fprintf('ecart type: %4.1f um rms\n', std(ordonneH)*1e3)
    fprintf('moyenne: %4.1f um \n\n', mean(ordonneH)*1e3)

    figure(5)
    hist(ordonneH)
    xlabel('Xoffset [mm]');
    ylabel('Nb de BPM');
end
%cd '/home/matlabML/mml/machine/Soleil/StorageRing/quad//fonction_test/'%Sauvegarde_beta_sept06 (betameasX,betameasZ)
%%
% Load betafunctions given by MAT
% TO BE IMPROVED for a bit wrong and not generic
cd(getfamilydata('Directory','QUAD'));
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
%%%cd('/home/matlabML/measdata/Ringdata/BBA/debug');
%save('tabBe.mat','tabBetaX','SortH')
%load('tabBe.mat')
tabBetaX;

l=1;
i=1;

if testH~=0
    % plan H
    size(SortH,1);
    %compute final offset with weigthed avarage when several quads for same BPM
    % TO BE IMPROVE
    while i < size(SortH,1)+1                    % attention à ne pas utiliser length lorsque nbacquisition < nbre paramètres = 5
        l;
        i;
        if i < size(SortH,1) && strcmpi(char(SortH(i,1)),char(SortH(i+1,1))) ; %si j'ai deux meme BPM

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
    tableBBAH = offH
end

%plan V
if testV~=0
    size(SortV,1);
    l=1;
    i=1;
    while i<size(SortV,1)+1

        l;
        i;
        if i<size(SortV,1) && strcmpi(char(SortV(i,1)),char(SortV(i+1,1))) ; %si j'ai deux meme BPM

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
    tableBBAV=offV
end


figure(9)
hist(str2num(char(tableBBAV{:,2})),30)
drawnow
pause(1)
xlabel('computed Zoffset [mm]');
ylabel('Nb BPM');
for k = 1:length(resV(:,1))-1
    toto(k) = resV(k,1)-resV(k+1,1);
end
[I J] = find(toto);
if toto(end)~=0
    J = [J length(resV(:,1)) ];
end
for h=1:length(J)
    abscissez(h) = resV(J(h),1);
end
figure(10)
plot(abscissez,str2num(char(tableBBAV{:,2})),'bo-')
drawnow
xlabel('s (m)');
ylabel('computed Zoffset [mm]');

figure(11)
hist(str2num(char(tableBBAH{:,2})),30)
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r','EdgeColor','w')
xlabel('computed Xoffset [mm]');
ylabel('Nb BPM');
for k = 1:length(resH(:,1))-1
    tata(k) = resH(k,1)-resH(k+1,1);
end
[I J] = find(tata);
if tata(end)~=0
    J = [J length(resH(:,1)) ];
end
for h=1:length(J)
    abscissex(h) = resH(J(h),1);
end
figure(12)
plot(abscissex,str2num(char(tableBBAH{:,2})),'ro-')
xlabel('s (m)');
ylabel('computed Xoffset [mm]');


cd(WorkingDirectory)

%% sauvegarde des offsets dans la directory de travail

% affichage des résultats dans un fichier "lisible"
fid = fopen('resultat.txt', 'wt');
fprintf(fid, '%s  \n',      '*************************************************');
fprintf(fid, '%s  \n', '** resultats traites a partir du fichier BBA : **');
fprintf(fid, '%s %s %s \n', '**      ',FileName,'           **');
fprintf(fid, '%s %s %s \n', '** jour du traitement :  ', datestr(now) ,'**');
fprintf(fid, '%s  \n',      '*************************************************');
fprintf(fid, '%s \n', ' ');
fprintf(fid, '%s \n', '*************** offsets horizontaux ********************');
if testH~=0
    for ih = 1:size(tableBBAH,1)
        fprintf(fid, '%s %s %s  \n', tableBBAH{ih,1},' #   ',tableBBAH{ih,2});
    end
end
if testV~=0
    fprintf(fid, '%s \n', ' ');
    fprintf(fid, '%s \n', '*************** offsets verticaux  *********************');
    for iv = 1:size(tableBBAV,1)
        fprintf(fid, '%s %s %s  \n', tableBBAV{iv,1},' #   ',tableBBAV{iv,2});
    end
end
fclose(fid);

if Application == 1
    % test si le tableau résultat existe déjà (c'est qu'on a peut-etre déjà
    % appliqué les offsets sur la machine ATTENTION !!!)
    fidH = fopen('tableBBAH.mat') ; fidV = fopen('tableBBAV.mat');
    if fidH~=(-1) | fidV ~= (-1)    % un des fichiers existe !!
        tmp2 = questdlg('Do you want to overwrite BBA results !?','BBA results already exists !!!','Yes','No','No');
        if strcmpi(tmp2,'Yes')                          % overwrite
            if testH~=0
                save('tableBBAH.mat','tableBBAH') %
            end
            if testV~=0
                save('tableBBAV.mat','tableBBAV')
            end
        else
            disp('BBA treatment cancelled')
            return
        end
    else
        if testH~=0
            save('tableBBAH.mat','tableBBAH') %
        end
        if testV~=0
            save('tableBBAV.mat','tableBBAV')
        end
    end
end
