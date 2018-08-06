function Meffskewquad = getrespdisp(varargin)
% getrespdisp - Measure efficency of skew quad towards dispersion function in vertical (IN PROGRESS)
%
%  INPUT
%  Optional
%  'Archive', 'Display'
%  Optional override of the mode:
%     'Online'    - Set/Get data online
%     'Model'     - Get the model chromaticity directly from AT (uses modelchro, DeltaRF is ignored)
%     'Simulator' - Set/Get data on the simulated accelerator using AT (ie, same commands as 'Online')
%
%  OUPUTS
%
%
%  ALGORITHM

%
%  See Also

%
%  Written by

DisplayFlag = 1;
ArchiveFlag = 1;
FileName = '';
ModeFlag = 'Model';  % model, online, manual, 'Model' for default mode
waittime = 0.5; %seconds taken into account for simulator and Online
OutputFlag = 1;
CorrectionFlag = 0 ; % Si à zéro pas de correction de la dispersion

%%%%%%%%%%%%%%% en attendant de mettre ces données dans un fichier !
CT = 0.01* [    -0.7000   -3.1700   -2.6800   -3.0200   -0.1500   -3.2000   -4.0300    2.7100   -3.3500   -0.6200   -2.4000    1.0000   -2.4000   -1.1600   -2.4100    0.8100   -1.4600   -2.8500   -4.2300...
    0.9200   -0.9600   -3.4100    0.3100    1.4600   -4.9700   -3.1100   -1.5700   -3.3600   -5.6000   -4.7800    3.2300   -4.9300   -4.2700   -3.5100   -6.6700   -2.3700   -3.2000   -0.3800   -3.5000...
   -3.8600   -4.0300    0.0800   -2.9000   -5.0300   -3.0300    1.5300   -6.5200   -4.3900   -1.7500    1.0700   -5.1400   -3.1300   -4.5200   -1.4500   -1.9800    3.4100    0.9100   -2.3100   -0.0800...
   -0.5400    1.2200   -3.3600   -2.9100   -3.5900   -3.6500   -4.5700   -2.5200    2.2800   -2.4200   -1.1400   -4.4900    2.2900   -5.9800   -4.2700   -3.1300   -0.1500   -4.5700   -4.8700   -2.9700...
    1.1400    0.9100   -2.2000   -0.3800   -2.9600   -1.2900   -0.3800   -0.2300   -0.3800   -0.4900   -3.5700   -0.3500   -1.4700   -1.4800   -1.6800   -3.5300   -0.6300   -4.1500    1.5400   -2.3200...
   -1.7300   -2.0200    3.1500   -0.6100   -3.9200   -3.8300    1.9500   -1.8900    2.5400   -2.3900    1.0500   -0.3500   -1.6100   -3.3000    1.7100    0.6200    0.1500   -2.2500   -0.080    -0.080  -3.1900];
% crosstalk mesuré par groupe diag avril 2007
% attention premier BPM mml = [1 2] d'ou  la permutation du premier crosstalk (-3.19%)
%%%%%%%%%%%%%%

if CorrectionFlag ==0
    for i = length(varargin):-1:1
        if isstruct(varargin{i})
            % Ignore structures
        elseif iscell(varargin{i})
            % Ignore cells
        elseif strcmpi(varargin{i},'Display')
            DisplayFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'NoDisplay')
            DisplayFlag = O;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'NoArchive')
            ArchiveFlag = 0;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Archive')
            ArchiveFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Simulator') || strcmpi(varargin{i},'Model') ...
                || strcmpi(varargin{i},'Online') || strcmpi(varargin{i},'Manual')
            ModeFlag = varargin{i};
            varargin(i) = [];
        end
    end

    % if isempty(varargin)
    %     SkewFam = findmemberof('QT');
    % end

    if strcmpi(ModeFlag,'Model')
        waittime = -1;
        OutputFlag = 0;
    elseif strcmpi(ModeFlag,'Online')
        waittime = 10 ;
    end

    Indexskewquad = family2atindex('QT');% Index of skew quadrupoles
    Meffskewquad_D = zeros(120,32); % première matrice : efficacité vis à vis de la dispersion
    DeviceNumber = 0;

    if ArchiveFlag  % enregistrement de la matrice reponse dispersion
        if isempty(FileName)
            FileName = appendtimestamp(getfamilydata('Default', 'SkewRespFile'));
            DirectoryName = getfamilydata('Directory', 'SkewResponse');
            if isempty(DirectoryName)
                %             DirectoryName = [getfamilydata('Directory','DataRoot'), 'Response', filesep, 'BPM', filesep];
            else
                % Make sure default directory exists
                DirStart = pwd;
                [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
                cd(DirStart);
            end
            [FileName, DirectoryName] = uiputfile('*.mat', 'Select a Skew File ("Save" starts measurement)', [DirectoryName FileName]);
            if FileName == 0
                ArchiveFlag = 0;
                disp('   Skew efficiency measurement canceled.');
                return
            end
            FileName = [DirectoryName, FileName];
        elseif FileName == -1
            FileName = appendtimestamp(getfamilydata('Default', 'SkewArchiveFile'));
            DirectoryName = getfamilydata('Directory', 'SkewResponse');
            FileName = [DirectoryName, FileName];
        end
    end

    % Starting time
    t0 = clock;

    %for k1 = 1:length(QuadFam),

    if ~isfamily('QT')
        error('%s is not a valid Family \n', 'QT');
        return;
    end

    DeviceList = family2dev('QT');

    % initialize data to zeros
    %     beta = zeros(length(DeviceList),2);
    %     beta_vrai = beta;
    %     tune0 = beta;
    %     tune1 = beta;
    %     tune2 = beta;
    %     dtune = beta;

    %k3 = 0;

    for k2 = 1:length(DeviceList),

        DeviceNumber = DeviceNumber + 1;
        Ic = getam('QT', DeviceList(k2,:), ModeFlag);
        SkewK = hw2physics('QT', 'Setpoint', Ic, DeviceList(k2,:));

        if OutputFlag
            fprintf('Measuring QT %s [%d %d] actual current %f A : ... \n', ...
                'QT', DeviceList(k2,:),Ic)
        end

        %k3 = k3 + 1;
        %tune0(k3,:) = gettune(ModeFlag); % Starting time
        [Dx0,Dy0] = measdisp('Physics',ModeFlag);
        if strcmpi(ModeFlag,'Online')
            Dy0 = Dy0 - Dx0.*CT';
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        DeltaI = getfamilydata('QT','Setpoint','DeltaSkewK')*1; % Amp
        %DeltaI = 0;

        if OutputFlag
            fprintf('Current increment of %d A\n', DeltaI)
        end

        stepsp('QT', DeltaI, DeviceList(k2,:), ModeFlag); % Step value
        sleep(waittime) % wait for quad reaching new setpoint value

        [Dx1,Dy1] = measdisp('Physics',ModeFlag); % get new dispersion
        if strcmpi(ModeFlag,'Online')
            Dy1 = Dy1 - Dx1.*CT';
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if OutputFlag
            fprintf('Current increment of %d A\n', -2*DeltaI)
        end

        stepsp('QT', -2*DeltaI, DeviceList(k2,:), ModeFlag); %
        sleep(waittime) % wait for quad reaching new setpoint value

        [Dx2,Dy2] = measdisp('Physics',ModeFlag); % get new dispersion
        if strcmpi(ModeFlag,'Online')
            Dy2 = Dy2 - Dx2.*CT';
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if OutputFlag
            fprintf('Current increment of %d A\n', DeltaI)
        end

        stepsp('QT', DeltaI, DeviceList(k2,:), ModeFlag); % go back to initial values
        sleep(waittime) % wait for quad reaching new setpoint value

        %% computation part

        Deltay = Dy1 - Dy2 ; %dispersion verticale induite par le QT
        figure(11) ; plot(getspos('BPMz'),Deltay)

        Leff = getleff('QT', DeviceList(k2,:)); % Get effective length

        %DeltaSkewKL =  2*DeltaI/Ic*SkewK*Leff; % étalonnage linéaire
        Meffskewquad_D(:,DeviceNumber) = Deltay / 2/DeltaI ;

        %         if OutputFlag
        %             dtune
        %             beta
        %             beta_vrai
        %         end
    end

    %     % structure to be saved
    %     AO.FamilyName.(QuadFam{k1}).beta = beta;
    %     AO.FamilyName.(QuadFam{k1}).beta_vrai = beta_vrai;
    %     AO.FamilyName.(QuadFam{k1}).dtune = dtune;
    %     AO.FamilyName.(QuadFam{k1}).tune0 = tune0;
    %     AO.FamilyName.(QuadFam{k1}).tune1 = tune1;
    %     AO.FamilyName.(QuadFam{k1}).tune2 = tune2;
    %     AO.FamilyName.(QuadFam{k1}).deltaI = DeltaI;
    %     AO.FamilyName.(QuadFam{k1}).DeviceList = DeviceList;
    %     %AO.FamilyName.(QuadFam{k1}).Position = getspos(QuadFam{k1},DeviceList);
    %end

    if DisplayFlag
        Meffskewquad_D
    end

    if ArchiveFlag
        % enregistrement
        %directory = '/home/matlabML/mmlcontrol/Ringspecific/quad/';
        directory_actuelle = pwd;
        cd(DirectoryName)
        save(FileName,'Meffskewquad_D','-mat');
        cd(directory_actuelle);
    end

    disp('c''est fini')
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % correction de la dispersion
% 
% if CorrectionFlag
%     %ModeFlag = 'Model';
%     ModeFlag = 'Online';
%     % mesure de la dispersion
%     [Dx,Dy] = measdisp('Physics',ModeFlag);
%     sleep(waittime)
%     pourcentage = 100 ; % 100% de la correction proposée sera appliquée
%     % chargement de la matrice efficacité
%     S2 = load('-mat','/home/matlabML/measdata/Ringdata/Response/Skew/SkewRespMat_2007-03-09_16-46-16_deuxieme_test.mat')
%     Meffskewquad_D = S2.Meffskewquad_D;
%     Meffskewquad_D = [Meffskewquad_D(:,1:23) Meffskewquad_D(:,25:32)]
% 
%     % correction
%     [U,S,V] = svd(Meffskewquad_D);
%     DiagS = diag(S);
%     nbvp = 10 %length(DiagS);
%     Rmod1 = Meffskewquad_D * V(:,1:nbvp);
%     B1 = Rmod1\ (Dy ); % Dy en m
%     Deltaskewquad = V(:,1:nbvp) * B1;
%     consigne = getsp('QT',ModeFlag);
%     consigne = [consigne(1:23)' consigne(25:32)']'
% 
% 
%     val_max = 7 ; val_min = -7 ;
%     if all((consigne + 2*Deltaskewquad* pourcentage*0.01)<val_max)*all((consigne+ 2*Deltaskewquad* pourcentage*0.01)>val_min);
%         Deltaskewquad = [Deltaskewquad(1:23)' 0 Deltaskewquad(24:31)']'
% 
%         stepsp('QT',2*Deltaskewquad* pourcentage*0.01,ModeFlag); % controle et non pas correction
%         correction = getam('QT',ModeFlag)
%         [Dxapres,Dyapres] = measdisp('Physics',ModeFlag)
%         figure(4) ; plot(getspos('BPMz'),Dy,'ro-') ; hold on ; plot(getspos('BPMz'),Dyapres,'bo-');legend('Dispersion V avant correction','apres correction')
%         disp('eh oui')
%     else
%         consigne-Deltaskewquad
%         errordlg('un QT  au moins dépasse les valeurs admises !','Attention');
%         return
%     end
% end