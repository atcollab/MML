function Meffskewquad_CTCO = getrespCTCO(varargin)
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
   -1.7300   -2.0200    3.1500   -0.6100   -3.9200   -3.8300    1.9500   -1.8900    2.5400   -2.3900    1.0500   -0.3500   -1.6100   -3.3000    1.7100    0.6200    0.1500   -2.2500   -0.080    -0.080  -3.1900]
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

    if strcmpi(ModeFlag,'Model')
        waittime = -1;
        OutputFlag = 0;
    elseif strcmpi(ModeFlag,'Online')
        waittime = 18 ; % 5 secondes pour pb alim
    end

    Indexskewquad = family2atindex('QT');% Index of skew quadrupoles
    Meffskewquad_CTCO = zeros(120,56,32); % première matrice : efficacité vis à vis des orbites fermées croisées
    Etalonnage = zeros(2,56,32);
    DeviceNumber_HCOR = 0; DeviceNumber_QT = 0;

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

    DeviceList_QT = family2dev('QT');
    DeviceList_HCOR = family2dev('HCOR');


    for k2 = 1:length(DeviceList_HCOR),
    
        Xof0 = getx(ModeFlag); % orbite de réfernece en horizontal (pour tester l'amplitude induite)
        Zof0 = getz(ModeFlag); % orbite de réference en vertical
        if strcmpi(ModeFlag,'Online')
            Zof0 = Zof0 - Xof0.*CT';
        end
        
        DeviceNumber_HCOR = DeviceNumber_HCOR + 1;
        Ic_HCOR = getam('HCOR', DeviceList_HCOR(k2,:), ModeFlag);
        if OutputFlag
                    fprintf('Measuring %s [%d %d] actual current %f A : ... \n', ...
                        'HCOR', DeviceList_HCOR(k2,:),Ic_HCOR)  % pour suivi
        end
        
        DeltaI_HCOR = 0.6*1.; % 0.4 Amp A TESTER
        stepsp('HCOR', DeltaI_HCOR, DeviceList_HCOR(k2,:), ModeFlag); % Step value
        sleep(waittime) % wait for HCOR reaching new setpoint value
        
        Xof1 = getx(ModeFlag) ;
        Zof1 = getz(ModeFlag) ;
        if strcmpi(ModeFlag,'Online')
            Zof1 = Zof1 - Xof1.*CT';
        end
        DevMaxX = max(Xof0-Xof1);
        fprintf('-     Déviation maximale induite : %4.3f mm  \n',DevMaxX) % pour tester la validité de DeltaI
        DeviceNumber_QT = 0;
        
        for k4 = 1:length(DeviceList_QT),
        
                DeviceNumber_QT = DeviceNumber_QT + 1;
                Ic_QT = getam('QT', DeviceList_QT(k4,:), ModeFlag);
                %SkewK = hw2physics('QT', 'Setpoint', Ic, DeviceList(k2,:));
                if OutputFlag
                   fprintf('-     Measuring %s [%d %d] actual current %f A : ... \n', ...
                       'QT', DeviceList_QT(k4,:),Ic_QT)
                end
                DeltaI_QT = getfamilydata('QT','Setpoint','DeltaSkewK')*5.; % 5 Amp
                
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               if OutputFlag
                   fprintf('-     Current increment of %d A\n', DeltaI_QT)
               end           
                stepsp('QT', DeltaI_QT, DeviceList_QT(k4,:), ModeFlag); % Step value
                sleep(waittime) % wait for quad reaching new setpoint value                
%                 Ic_QT = getam('QT', DeviceList_QT(k4,:), ModeFlag);
%        fprintf('-     Measuring %s [%d %d] actual current %f A : ... \n', ...
%                       'QT', DeviceList_QT(k4,:),Ic_QT)
                Xof2 = getx(ModeFlag) ;
                Zof2 = getz(ModeFlag) ;
                if strcmpi(ModeFlag,'Online')
                    Zof2 = Zof2 - Xof2.*CT';
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if OutputFlag
                    fprintf('-     Current increment of %d A\n', -2*DeltaI_QT)
                end
                stepsp('QT', -2*DeltaI_QT, DeviceList_QT(k4,:), ModeFlag); % Step value
                sleep(waittime*2) % wait for quad reaching new setpoint value
                %                 Ic_QT = getam('QT', DeviceList_QT(k4,:), ModeFlag);
                %        fprintf('-     Measuring %s [%d %d] actual current %f A : ... \n', ...
                %                       'QT', DeviceList_QT(k4,:),Ic_QT)
                Xof3 = getx(ModeFlag) ;
                Zof3 = getz(ModeFlag) ;
                if strcmpi(ModeFlag,'Online')
                    Zof3 = Zof3 - Xof3.*CT';
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                if OutputFlag
                    fprintf('-     Current increment of %d A\n', DeltaI_QT)
                end

                stepsp('QT', DeltaI_QT, DeviceList_QT(k4,:), ModeFlag); % go back to initial values
                sleep(waittime) % wait for quad reaching new setpoint value

                %% computation part

                DeltaZof = Zof3-Zof2 ; % différence d'orbite induite par le QT
                figure(11) ; plot(getspos('BPMz'),DeltaZof)
                ylim([-0.10 0.10])
                DevMaxZ = max(DeltaZof);

                %Leff = getleff('QT', DeviceList_QT(k2,:)); % Get effective length

                %DeltaSkewKL =  2*DeltaI/Ic*SkewK*Leff; % étalonnage linéaire
                Meffskewquad_CTCO(:,DeviceNumber_HCOR,DeviceNumber_QT) = DeltaZof/DeltaI_HCOR/(-2*DeltaI_QT) ; % (mm/A2)
                Etalonnage(1,DeviceNumber_HCOR,DeviceNumber_QT) = DevMaxX;
                Etalonnage(2,DeviceNumber_HCOR,DeviceNumber_QT) = DevMaxZ;% test en simulator

        end
        stepsp('HCOR', -DeltaI_HCOR, DeviceList_HCOR(k2,:), ModeFlag); % go back to initial value
        sleep(waittime) % wait for HCOR reaching new setpoint value
        
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

%     if DisplayFlag
%         Meffskewquad_CTCO
%     end

    if ArchiveFlag
        % enregistrement
        %directory = '/home/matlabML/mmlcontrol/Ringspecific/quad/';
        directory_actuelle = pwd;
        cd(DirectoryName)
        save(FileName,'Meffskewquad_CTCO','Etalonnage','-mat');
        
        cd(directory_actuelle);
    end

    disp('c''est fini')
end