function getmrsv(varargin)
%
%
%
% Written By Marie-Agnes. Tordeux

DisplayFlag = 1;
ArchiveFlag = 1;

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
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
    end
end

% Starting time
t0 = clock;
FileName = '';
dev = 'ANS-C01/DG/MRSV-VG';
devAna = 'ANS-C01/DG/MRSV-IMAGEANALYZER';
devDensityF = 'ANS-C01/DG/MRSV-M.DENSITEFIN'; % filtre
devDensityG = 'ANS-C01/DG/MRSV-M.DENSITEGROS'; % filtre
devFente =  'ANS-C01/DG/MRSV-M.FENTE';  % fente devant la lentille 3.2 m
devMiroirH =  'ANS-C01/DG/MRSV-M.MIROIRH';  % miroir V !
devMiroirV =  'ANS-C01/DG/MRSV-M.MIROIRV';  % miroir H !
devMiroirSurf = 'ANS-C01/DG/MRSV-M.SURF'; % miroir MRSV dans le faisceau


iteration = 1 ;% 5 iterations
for iteration = 1:1% 5 iterations
    temp=tango_read_attribute2(dev,'image');
    ImageMRSV = temp.value;
    rep.image = ImageMRSV;
    rep.current = getdcct;
    rep.intensite = readattribute([devAna '/MaxIntensity'])
    %rep.gamma = readattribute([devAna '/GammaCorrection']);
    rep.densiteF = readattribute([devDensityF '/AxisCurrentPosition'])
    rep.densiteG = readattribute([devDensityG '/AxisCurrentPosition'])
    rep.Fente = readattribute([devFente '/AxisCurrentPosition'])
    rep.MiroirH = readattribute([devMiroirH '/AxisCurrentPosition'])
    rep.MiroirV = readattribute([devMiroirV '/AxisCurrentPosition'])
    rep.MiroirSurf = readattribute([devMiroirSurf '/AxisCurrentPosition'])
    rep.sigmax = readattribute([devAna '/XProfileSigma']);
    rep.sigmaz = readattribute([devAna '/YProfileSigma']);


    if DisplayFlag

        %if iteration == 1 % 5 iterations
        figure;
        image(ImageMRSV,'CDataMapping','scaled','Parent',gca)
        %end % 5 iterations
    end

    if ArchiveFlag
        toto = 0;
        % if isempty(FileName)
        FileName = 'MRSV';
        FileName = appendtimestamp(FileName);
        DirectoryName = '/home/operateur/GrpDiagnostics/MRSV'
        %appendtimestamp(getfamilydata('Default', 'PINHOLEArchiveFile'));
        %DirectoryName = getfamilydata('Directory', 'PINHOLE');
        if isempty(DirectoryName)
            DirectoryName = '/home/operateur/GrpDiagnostics/MRSV'
            %[getfamilydata('Directory','DataRoot'), 'Response', filesep, 'BPM', filesep];
        else
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select a Quad File ("Save" starts measurement)', [DirectoryName FileName]);
        if FileName == 0
            ArchiveFlag = 0;
            disp('   Pinhole measurement canceled.');
            toto = 1;
            %return
        else
            FileName = [DirectoryName, FileName];
        end

        % elseif FileName == -1
        %             FileName = appendtimestamp(getfamilydata('Default', 'QUADArchiveFile'));
        %             DirectoryName = getfamilydata('Directory', 'QUAD');
        %             FileName = [DirectoryName, FileName];
        %end

    end
    rep.CreatedBy = 'getmrsv';
    rep.t         = t0;
    rep.tout      = etime(clock,t0);
    rep.TimeStamp = datestr(clock);
    if toto ==0
        save(FileName,'rep');
    end

    pause(1);   % 5 iterations
    iteration = iteration + 1  % 5 iterations
end  % 5 iterations
fprintf('Data save in filename %s \n', FileName);
fprintf('courant dcct %4.2f \n', rep.current);
%fprintf('courant QT1  \n');
%fprintf('sigmax %10.2f \n', rep.sigmax);
%fprintf('sigmaz %10.2f \n', rep.sigmaz);

%fprintf('intensité max pixel  \n');
%fprintf('chromaticité x  \n');
%fprintf('chromaticité z  \n');
fprintf('densité fin %6.1f \n',rep.densiteF);
fprintf('densité gros %6.1f \n',rep.densiteG);
fprintf('fente devant lentille %6.1f \n',rep.Fente);
fprintf('Miroir H (vertical) %6.1f \n',rep.MiroirH);
fprintf('Miroir V (horizontal) %6.1f \n',rep.MiroirV);
fprintf('Miroir Surf  %6.1f \n',rep.MiroirSurf);
fprintf('Max intensité de l''image  %6.1f \n',rep.intensite);

% densité  moyenne carre              size
%     0    763    H 280-340 V 300-360  61x61
%     0.2  583
%     0.4  419
%     0.6  321
%     0.8  207
%     1.0  118
%     1.2  73
%     1.4  40

%     Y = [40 73 118 207 321 419 583 763]
%     Z = ones(8,1)'*10
%     X = [ 1.4 1.2 1.0 0.8 0.6 0.4 0.2 0 ]
%     Xb = Z.^(-X)
%     figure(1)
%     plot(Xb,Y,'ro')
%     xlabel('Iinput')
%     ylabel('Nb counts')
%     title('gamma evaluation')

%%%%%%%%%%%%%%%%%%%%%% RESOLUTION
%     H carre BN line 296  H 360-752
%     H carre NB line 352  H 360-752
%     V carre BN line 432  H 360-752
%     V carre NB line 584  H 360-752

%%%%%%%%%%%%%%%%%%%%%% QUADRILLAGE
%V 664  (168-480)
%H 248 (408-767)

% %  figure(2) ;hold on;
% % Y = [40 73 118 207 321 419 583 763]
% % D = [ 1.41 1.2 1.0 0.86 0.61 0.41 0.2 0 ]
% % gamma = 0.62
% %
% % W = log10(Y)./gamma
% % W = W + D
% % plot(W,'ko') ; ylim([4.6 4.9])


% 8 mars 2007 analyse
S = [ 9 14 19.5 25.5 30 35.5 45.5 49 53.5 57 61.5 66.5 68.5 76 ];
sigmax = [24.74 23.29 22.49 22.21 22.17 21.97 21.33 21.37 21.49 21.69 21.52 21.92 22.13 22.51 ];
MaxPix = [ 754 610 701 733 845 918 864 936 958 979 642 658 663 661 ];
figure(1) ; plot(S,sigmax,'ro');hold on ; plot(S,MaxPix/20,'bo')
Att = [1.8 1.8 1.8 1.8 1.8 1.8 1.6 1.6 1.6 1.6 1.8 1.8 1.8 1.8]
hold on;plot(S,Att*20,'g*')