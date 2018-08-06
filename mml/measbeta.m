function AO = measbeta(varargin)
%MEASBETA - Measure the betatron functions 
%
%  INPUTS
%  1. Quadrupole family name {Default : All}
%  Optional
%  'Archive', 'Display'
%  Optional override of the mode:
%     'Online'    - Set/Get data online  
%     'Model'     - Get the model chromaticity directly from AT (uses modelchro, DeltaRF is ignored)
%     'Simulator' - Set/Get data on the simulated accelerator using AT (ie, same commands as 'Online')
%
%  OUPUTS
%  1. betax - Horizontal beta functions
%  2. betaz - Vertical beta functions
%
%  ALGORITHM
%  betax =  4*pi*Dtunex/D(KL)
%  betaz = -4*pi*Dtunez/D(KL)
%
%  See also plotmeasbeta, plotbeta


%  Written by Laurent S. Nadolski


DisplayFlag = 1;
ArchiveFlag = 1;
FileName = '';
ModeFlag = '';  % model, online, manual, or '' for default mode
waittime = 10; %seconds taken into account for simulator and Online
OutputFlag = 1;

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
    elseif any(strcmpi(varargin{i},{'Simulator','Model','Online','Manual'}))
        ModeFlag = varargin{i};
        varargin(i) = [];
    end
end

if strcmpi(ModeFlag,'Model')
    waittime = -1;
    OutputFlag = 0;
end


% Input parsing
if isempty(varargin)
    QuadFam = findmemberof('QUAD');
elseif ischar(varargin{1})  
    QuadFam = {varargin{:}};
else
    QuadFam = varargin{:}
end

if ArchiveFlag
    if isempty(FileName)
        FileName = appendtimestamp(getfamilydata('Default', 'QUADArchiveFile'));
        DirectoryName = getfamilydata('Directory', 'QUAD');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot'), 'Response', filesep, 'BPM', filesep];
        else
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select a Quad File ("Save" starts measurement)', [DirectoryName FileName]);
        if FileName == 0 
            ArchiveFlag = 0;
            disp('   Quadrupole betatron measurement canceled.');
            return
        end
        FileName = [DirectoryName, FileName];
    elseif FileName == -1
        FileName = appendtimestamp(getfamilydata('Default', 'QUADArchiveFile'));
        DirectoryName = getfamilydata('Directory', 'QUAD');
        FileName = [DirectoryName, FileName];
    end    
end

% Starting time
t0 = clock;

nu_start = gettune(ModeFlag);

for k1 = 1:length(QuadFam),
    
    if ~isfamily(QuadFam{k1})
        error('%s is not a valid Family \n', QuadFam{k1});
        return;
    end
        
    DeviceList = family2dev(QuadFam{k1});
    
    % initialize data to zeros
    beta = zeros(length(DeviceList),2);
    beta_vrai = beta;
    tune0 = beta;
    tune1 = beta;
    tune2 = beta;
    dtune = beta;
    
    k3 = 0;
    
    for k2 = 1:length(DeviceList),
        Ic = getam(QuadFam{k1}, DeviceList(k2,:), ModeFlag);
        K = hw2physics(QuadFam{k1}, 'Setpoint', Ic, DeviceList(k2,:));

        if OutputFlag
            fprintf('Measuring Family %s [%d %d] actual current %f A : ... \n', ...
                QuadFam{k1}, DeviceList(k2,:),Ic)
        end
        
        k3 = k3 + 1;
        tune0(k3,:) = gettune(ModeFlag); % Starting time
        
        DeltaI = getfamilydata(QuadFam{k1},'Setpoint','DeltaKBeta')*1.; % Amp

        if OutputFlag
            fprintf('Current increment of %d A\n', DeltaI)
        end
        
        stepsp(QuadFam{k1}, DeltaI, DeviceList(k2,:), ModeFlag); % Step value
        sleep(waittime) % wait for quad reaching new setpoint value
 
        tune1(k3,:) = gettune(ModeFlag); % get new tunes

        if OutputFlag
            tune1
            fprintf('Current increment of %d A\n', -2*DeltaI)
        end

        stepsp(QuadFam{k1}, -2*DeltaI, DeviceList(k2,:), ModeFlag); % go back to initial values
        sleep(waittime) % wait for quad reaching new setpoint value
        
        tune2(k3,:) = gettune(ModeFlag); % get new tunes

        if OutputFlag
            tune2
        end

        if OutputFlag
            fprintf('Current increment of %d A\n', DeltaI)
        end

        stepsp(QuadFam{k1}, DeltaI, DeviceList(k2,:), ModeFlag); % go back to initial values
        sleep(waittime) % wait for quad reaching new setpoint value

        %% computation part
        
        dtune(k3,:) = tune1(k3,:) - tune2(k3,:);
        
        Leff = getleff(QuadFam{k1}, DeviceList(k2,:)); % Get effective length
        %KL   = hw2physics(QuadFam{k1}, 'Setpoint', DeltaK, DeviceList(k2,:))*Leff;
        DeltaKL =  2*DeltaI/Ic*K*Leff;

        K1 = hw2physics(QuadFam{k1}, 'Setpoint', Ic+DeltaI, DeviceList(k2,:));
        K2 = hw2physics(QuadFam{k1}, 'Setpoint', Ic-DeltaI, DeviceList(k2,:));
        DeltaKL_vrai =  (K1-K2)*Leff;
        
        beta(k3,:) = 4*pi*dtune(k3,:)./DeltaKL.*[1 -1];
        beta_vrai(k3,:) = 4*pi*dtune(k3,:)./DeltaKL_vrai.*[1 -1];

        if OutputFlag
            dtune
            beta
            beta_vrai
        end
    end
    
    % structure to be saved
    AO.FamilyName.(QuadFam{k1}).beta = beta;
    AO.FamilyName.(QuadFam{k1}).beta_vrai = beta_vrai;
    AO.FamilyName.(QuadFam{k1}).dtune = dtune;
    AO.FamilyName.(QuadFam{k1}).tune0 = tune0;
    AO.FamilyName.(QuadFam{k1}).tune1 = tune1;
    AO.FamilyName.(QuadFam{k1}).tune2 = tune2;
    AO.FamilyName.(QuadFam{k1}).deltaI = DeltaI;
    AO.FamilyName.(QuadFam{k1}).DeviceList = DeviceList;
    %AO.FamilyName.(QuadFam{k1}).Position = getspos(QuadFam{k1},DeviceList);
end

AO.CreatedBy = 'measbeta';
AO.GeV       = getenergy;
AO.t         = t0;
AO.tout      = etime(clock,t0);
AO.TimeStamp = datestr(clock);

if ArchiveFlag
    save(FileName,'AO');
    fprintf('Data save in filename %s \n', FileName);
end

%% tune variation during measurement
nu_end = gettune(ModeFlag);

fprintf('Tunes before mesurement nux = %4.4f nuz = %4.4f \n', nu_start);
fprintf('Tunes after  mesurement nux = %4.4f nuz = %4.4f \n', nu_end);

%% raw statistics on beta measurement
dbxobx = (max(beta_vrai(:,1)-min(beta_vrai(:,1))))./min(beta_vrai(:,1))*100;
dbzobz = (max(beta_vrai(:,2)-min(beta_vrai(:,2))))./min(beta_vrai(:,2))*100;
fprintf('maximum betabeat dbxobx = %4.1f %% dbzobz = %4.1f %% \n', dbxobx, dbzobz);

rmsbx = std((beta_vrai(:,1)-mean(beta_vrai(:,1)))./mean(beta_vrai(:,1)))*100;
rmsbz = std((beta_vrai(:,2)-mean(beta_vrai(:,2)))./mean(beta_vrai(:,2)))*100;
fprintf('rms betabeat bx = %4.1f %% rms bz = %4.1f %% rms \n', rmsbx, rmsbz);

if DisplayFlag
    plotmeasbeta(AO);
end
