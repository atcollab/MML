function setskewcorrection(varargin)
% setskewcorrection - coupling correction with CTCO  method
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

MeasurementFlag = 0 ; % 
CorrectionFlag = 1 ; % Si à zéro pas de correction de la dispersion

lim = 0.1; % en mm, valeur max estimée des CTCO pour graphe

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
    waittime = 5;  % 5 secondes car pb alim correcteurs
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% en attente de mettre dans un fichier
CT = 0.01* [    -0.7000   -3.1700   -2.6800   -3.0200   -0.1500   -3.2000   -4.0300    2.7100   -3.3500   -0.6200   -2.4000    1.0000   -2.4000   -1.1600   -2.4100    0.8100   -1.4600   -2.8500   -4.2300...
    0.9200   -0.9600   -3.4100    0.3100    1.4600   -4.9700   -3.1100   -1.5700   -3.3600   -5.6000   -4.7800    3.2300   -4.9300   -4.2700   -3.5100   -6.6700   -2.3700   -3.2000   -0.3800   -3.5000...
   -3.8600   -4.0300    0.0800   -2.9000   -5.0300   -3.0300    1.5300   -6.5200   -4.3900   -1.7500    1.0700   -5.1400   -3.1300   -4.5200   -1.4500   -1.9800    3.4100    0.9100   -2.3100   -0.0800...
   -0.5400    1.2200   -3.3600   -2.9100   -3.5900   -3.6500   -4.5700   -2.5200    2.2800   -2.4200   -1.1400   -4.4900    2.2900   -5.9800   -4.2700   -3.1300   -0.1500   -4.5700   -4.8700   -2.9700...
    1.1400    0.9100   -2.2000   -0.3800   -2.9600   -1.2900   -0.3800   -0.2300   -0.3800   -0.4900   -3.5700   -0.3500   -1.4700   -1.4800   -1.6800   -3.5300   -0.6300   -4.1500    1.5400   -2.3200...
   -1.7300   -2.0200    3.1500   -0.6100   -3.9200   -3.8300    1.9500   -1.8900    2.5400   -2.3900    1.0500   -0.3500   -1.6100   -3.3000    1.7100    0.6200    0.1500   -2.2500   -0.080    -0.080  -3.1900];
% crosstalk mesuré par groupe diag avril 2007
% attention premier BPM mml = [1 2] d'ou  la permutation du premier crosstalk (-3.19%)



if MeasurementFlag
    %Indexskewquad = family2atindex('QT');% Index of skew quadrupoles
    %Meffskewquad_CTO = zeros(120,120,32); % première matrice : efficacité vis à vis des orbites fermées croisées
    %Etalonnage = zeros(2,120,32);
    DeviceNumber_HCOR = 0;

    if ArchiveFlag  % enregistrement de la matrice reponse dispersion
        if isempty(FileName)
            FileName = appendtimestamp('SkewMeasurement');
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

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CrossTalk closed orbit measurement
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    for k2 = 1:length(DeviceList_HCOR),

        Xof0 = getx(ModeFlag); % Horizontal reference orbit
        Zof0 = getz(ModeFlag); % Vertical reference orbit
        if strcmpi(ModeFlag,'Online')
            Zof0 = Zof0 - Xof0.*CT';
        end

        DeviceNumber_HCOR = DeviceNumber_HCOR + 1;
        Ic_HCOR = getam('HCOR', DeviceList_HCOR(k2,:), ModeFlag);
        if OutputFlag
                    fprintf('Measuring %s [%d %d] actual current %f A : ... \n', ...
                        'HCOR', DeviceList_HCOR(k2,:),Ic_HCOR)  % pour suivi
        end

        DeltaI_HCOR = 0.6*1.; % 0.6 Amp : choix d'une orbite inférieure à 1 mm
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        stepsp('HCOR', DeltaI_HCOR, DeviceList_HCOR(k2,:), ModeFlag); % Step value
        sleep(waittime) % wait for HCOR reaching new setpoint value

        Xof1 = getx(ModeFlag) ;
        Zof1 = getz(ModeFlag) ;
        if strcmpi(ModeFlag,'Online')
            Zof1 = Zof1 - Xof1.*CT';
        end
        DevMaxX = max(Xof0-Xof1);
        fprintf('-     Déviation maximale induite : %4.3f mm  \n',DevMaxX) % pour tester la validité de DeltaI

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        stepsp('HCOR', -2*DeltaI_HCOR, DeviceList_HCOR(k2,:), ModeFlag); % Step value
        sleep(waittime) % wait for HCOR reaching new setpoint value

        Xof2 = getx(ModeFlag) ;
        Zof2 = getz(ModeFlag) ;
        if strcmpi(ModeFlag,'Online')
            Zof2 = Zof2 - Xof2.*CT';
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        stepsp('HCOR', DeltaI_HCOR, DeviceList_HCOR(k2,:), ModeFlag); % Initial value
        sleep(waittime) % wait for HCOR reaching new setpoint value

        
        %% computation part

        DeltaZof = Zof2-Zof1 ; % HCOR induced Orbit shift 
        figure(13) ; plot(getspos('BPMz'),DeltaZof)
        ylim([-0.03 0.03])
        DevMaxZ = max(DeltaZof);

        CTCO_Meas(:,DeviceNumber_HCOR) = DeltaZof/(-2*DeltaI_HCOR) ; % mm/A
        CTCO_Etalonnage(1,DeviceNumber_HCOR) = DevMaxX;
        CTCO_Etalonnage(2,DeviceNumber_HCOR) = DevMaxZ ; % Amplitude test

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % dispersion measurement
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [Dx_Meas,Dy_Meas] = measdisp('Physics',ModeFlag);
    sleep(waittime*2)

    %     if DisplayFlag
    %        
    %     end

    if ArchiveFlag
        directory_actuelle = pwd;
        cd(DirectoryName)
        save(FileName,'CTCO_Meas','CTCO_Etalonnage','Dx_Meas','Dy_Meas','-mat');
        cd(directory_actuelle);
    end

    disp('Registration ended')

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coupling correction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if CorrectionFlag
    if ~MeasurementFlag
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Measurement loading
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%% model
        %S = load('-mat','/home/matlabML/measdata/Ringdata/Response/Skew/SkewRespMat_2007-06-05_19-33-04.mat')
%         S = load('-mat','/home/matlabML/measdata/Ringdata/Response/Skew/SkewMeasurement_2007-06-07_15-22-51.mat') % défauts = QT=[1 -1 1 -1,etc..
        %S = load('-mat','/home/matlabML/measdata/Ringdata/Response/Skew/SkewMeasurement_2007-06-08_11-27-15_tirage_defauts.mat') % tirage défauts 
        S = load('-mat','/home/matlabML/measdata/Ringdata/Response/Skew/SkewMeasurement_2007-06-18_15-40-27_graine_n9.mat')
        Dy_Meas = S.Dy_Meas;
        CTCO_Meas = S.CTCO_Meas;
        
        %%%%%%%%%%%%%%%%%%%%%%%%% online
%         S1 = load('-mat','/home/matlabML/measdata/Ringdata/Response/Skew/SkewMeasurement_2007-06-11_12-53-30.mat') % mesure sur machine du lundi 11 juin
%         Dy_Meas = S1.Dy_Meas;
%         S2 = load('-mat','/home/matlabML/measdata/Ringdata/Response/Skew/SkewMeasurement_2007-06-11_12-25-27.mat') % mesure sur machine du lundi 11 juin
%         CTCO_Meas = S2.CTCO_Meas;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Efficiency Matrix loading
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %pourcentage = 100 ; % 100% de la correction proposée sera appliquée
    S_D = load('-mat','/home/matlabML/measdata/Ringdata/Response/Skew/SkewRespMat_2007-03-09_16-46-16_deuxieme_test.mat')
    Meffskewquad_D = S_D.Meffskewquad_D;
    %Meffskewquad_D = [Meffskewquad_D(:,1:23) Meffskewquad_D(:,25:32)] % exclure le Skew monté en Quad
    S_CTCO = load('-mat','/home/matlabML/measdata/Ringdata/Response/Skew/SkewRespMat_2007-06-03_23-13-56_CTCO_theorique.mat')
    Meffskewquad_CTCO = S_CTCO.Meffskewquad_CTCO;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Coupling Matrix construction (depending on Relative Dispersion correction weigth)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    PoidsDz = 1e3*ones(1,120); %  Relative Dispersion correction weigth

    DeviceList_QT = family2dev('QT');
    DeviceList_HCOR = family2dev('HCOR');
    DeviceList_BPMz = family2dev('BPMz');

    for l = 1:length(DeviceList_QT)
        for k = 1:length(DeviceList_QT)
            A_Dz(l,k) = sum(PoidsDz'.*Meffskewquad_D(:,l).*Meffskewquad_D(:,k)); % Vérifier dimension de PoidsDz
        end
    end
    for l = 1:length(DeviceList_QT)
        for k = 1:length(DeviceList_QT)
            for j = 1:length(DeviceList_HCOR)
                T(j) = sum(Meffskewquad_CTCO(:,j,l).*Meffskewquad_CTCO(:,j,k));
            end
            A_CTCO(l,k) = sum(T(:));
        end
    end
    MeffSkewQuad =   A_Dz +   A_CTCO;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Second member vector evaluation ( also depending on Relative Dispersion correction weigth !!)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for l = 1:length(DeviceList_QT)
        B_Dz(l) = sum(PoidsDz'.*Meffskewquad_D(:,l).*Dy_Meas(:)); % Vérifier dimension de PoidsDz
    end
    for l = 1:length(DeviceList_QT)

        for j = 1:length(DeviceList_HCOR)
            T(j) = sum(Meffskewquad_CTCO(:,j,l).*CTCO_Meas(:,j));
        end
        B_CTCO(l) = sum(T(:));

    end
    coeff_Dz = -1; coeff_CTCO = 0 ; 
    SecondMember =   + coeff_Dz * B_Dz + coeff_CTCO *  B_CTCO;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Correction ( also depending on Relative Dispersion correction weigth !!)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    couleur = 'r' % changer la couleur pour chaque valeur de nbvp (sauf blue)
    [U,S,V] = svd(MeffSkewQuad);
    figure(4) ; semilogy(diag(S));title('MeffSkewQuad  -  PoidsDz = 0');xlabel('No EigenValue');
    DiagS = diag(S);
    nbvp = 32  %  length(DiagS);
    Rmod1 = MeffSkewQuad * V(:,1:nbvp);
    B1 = Rmod1\ (SecondMember' ); % SeconMember en ?
    Deltaskewquad = V(:,1:nbvp) * B1;
    figure(20) ; hold on ; plot(Deltaskewquad,couleur) ; title('Valeur des QT en A')
    consigne = getsp('QT',ModeFlag);
    %consigne = [consigne(1:23)' consigne(25:32)']'

    pourcentage = 100;
    val_max = 7 ; val_min = -7 ;
    if all((consigne + Deltaskewquad* pourcentage*0.01)<val_max)*all((consigne +Deltaskewquad* pourcentage*0.01)>val_min);
        %Deltaskewquad = [Deltaskewquad(1:23)' 0 Deltaskewquad(24:31)']'

        stepsp('QT',Deltaskewquad* pourcentage*0.01,ModeFlag); %
        correction = getam('QT',ModeFlag)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%% mesure sur la machine après correction
        [Dxapres,Dyapres] = measdisp('Physics',ModeFlag)
        if strcmpi(ModeFlag,'Online')
            Dyapres = Dyapres - Dxapres.*CT';
        end
        sleep(waittime)
        figure(25) ; hold on ; plot(getspos('BPMz'),Dy_Meas,'bo-') ;
        hold on ; plot(getspos('BPMz'),Dyapres,couleur );legend('Dispersion V avant correction','apres correction')

        DeviceNumber_HCOR = 0;
        for k2 =1:3
            DeviceNumber_HCOR = DeviceNumber_HCOR + 1;
            Ic_HCOR = getam('HCOR', DeviceList_HCOR(k2,:), ModeFlag);
            if OutputFlag
                fprintf('Measuring %s [%d %d] actual current %f A : ... \n', ...
                    'HCOR', DeviceList_HCOR(k2,:),Ic_HCOR)  % pour suivi
            end

            DeltaI_HCOR = 0.6*1.; % 0.6 Amp : choix d'une orbite inférieure à 1 mm
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            stepsp('HCOR', DeltaI_HCOR, DeviceList_HCOR(k2,:), ModeFlag); % Step value
            sleep(waittime) % wait for HCOR reaching new setpoint value

            Xof1 = getx(ModeFlag) ;
            Zof1 = getz(ModeFlag) ;
            if strcmpi(ModeFlag,'Online')
                Zof1 = Zof1 - Xof1.*CT';
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            stepsp('HCOR', -2*DeltaI_HCOR, DeviceList_HCOR(k2,:), ModeFlag); % Step value
            sleep(waittime) % wait for HCOR reaching new setpoint value

            Xof2 = getx(ModeFlag) ;
            Zof2 = getz(ModeFlag) ;
            if strcmpi(ModeFlag,'Online')
                Zof2 = Zof2 - Xof2.*CT';
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            stepsp('HCOR', DeltaI_HCOR, DeviceList_HCOR(k2,:), ModeFlag); % Initial value
            sleep(waittime) % wait for HCOR reaching new setpoint value

            %% computation part

            DeltaZof = Zof2-Zof1 ; % HCOR induced Orbit shift
            
            if k2 == 1
                figure(21) ; hold on ; plot(getspos('BPMz'),DeltaZof,couleur) ; ylim([-lim lim]) ; % CTCO après correction
                hold on ; plot(getspos('BPMz'),-CTCO_Meas(:,1)*2*DeltaI_HCOR,'bo-') % réference avant correction
                title('HCOR [1 1]') ; legend('CTCO après correction','CTCO avant correction')
            elseif k2 == 2
                figure(22) ; hold on ; plot(getspos('BPMz'),DeltaZof,couleur) ; ylim([-lim lim]) ; % CTCO après correction
                hold on ; plot(getspos('BPMz'),-CTCO_Meas(:,2)*2*DeltaI_HCOR,'bo-') % réference avant correction
                title('HCOR [1 4]') ; legend('CTCO après correction','CTCO avant correction')
            elseif k2 == 3
                figure(23) ; hold on ; plot(getspos('BPMz'),DeltaZof,couleur) ; ylim([-lim lim]) ; % CTCO après correction
                hold on ; plot(getspos('BPMz'),-CTCO_Meas(:,3)*2*DeltaI_HCOR,'bo-') % réference avant correction
                title('HCOR [1 7]') ; legend('CTCO après correction','CTCO avant correction')
            end
        end
        
        if ~strcmpi(ModeFlag,'Online')
               E = modelemit;
               fprintf('EmittanceX =  %4.2f nm , EmittanceZ = %4.2f pm \n',E(1),E(2)*1e3 )
               setsp('QT',consigne,ModeFlag);
        else
            % prendre mesure pinhole
            emit = tango_read_attributes('ANS-C02/DG/PHC-EMIT',{'EmittanceH','EmittanceV'});
            fprintf('EmittanceX =  %4.2f nm , EmittanceZ = %4.2f pm \n',emit(1).value,emit(2).value )
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        disp('eh oui')
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% à faire à la main sur demande : setsp('QT',consigne,'Model') % go back to initial value for QT
    else
        consigne-Deltaskewquad
        errordlg('un QT  au moins dépasse les valeurs admises !','Attention');
        return
    end
end