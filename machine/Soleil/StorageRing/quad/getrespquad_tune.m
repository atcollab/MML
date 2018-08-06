function Meffquad = getrespquad_tune(varargin)
% getrespquad - Calculates from the model the response matrix of quadrupole relatively to the
% beta function in every other quadrupole
% 

%  INPUTS
%  1. Quadrupole family name {Default : All}
%  Optional
%  'Archive', 'Display'
%
%  OUPUTS
%  Meffquad
%
%  ALGORITHM
%  Meffquad( i , j ) = delta beta dans quadrupole n° i / delta courant dans
%  quadrupole j

%
%  Written by Mat husalem

%%%%%%%%%%%%%%%%%%%%%%%
switch2sim
%%%%%%%%%%%%%%%%%%%%%%%

DisplayFlag = 1;
ArchiveFlag = 0;
% % % FileName = '';


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
        ArchiveFlag = O;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Archive')
        ArchiveFlag = 1;
        varargin(i) = [];
    end
end

% Input parsing
if isempty(varargin)
    QuadFam = findmemberof('QUAD');
elseif ischar(varargin{1})  
    QuadFam = {varargin{:}};
else
    QuadFam = varargin{:}
end


Indexquad = family2atindex({'Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10'});% Index of quadrupoles
Meffquad = zeros(160,160);
DeviceNumber = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mesure de beta comme sur la machine theorique
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% beta_tune = mesure_beta(QuadFam);
% betatheorX = beta_tune(1,:);
% betatheorZ = beta_tune(2,:);
% DirStart = pwd;
% DirectoryName = '/home/matlabML/measdata/Ringdata/QUAD/';
% [DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);
% try
%     Nomfichier = 'Sauvegarde_beta_theorique_0_2_0_3';
%     save(Nomfichier,'betatheorX','betatheorZ');
% catch
%     cd(DirStart);
%     return
% end
% cd(DirStart);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mesure de la matrice d'effcicaité par rapport aux nombre d'onde comme sur la machine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k1 = 1:length(QuadFam),
    numero_famille_en_cours = k1 % affichage ecran
    if ~isfamily(QuadFam{k1})
        error('%s is not a valid Family \n', QuadFam{k1});
        return;
    end   
    DeviceList = family2dev(QuadFam{k1});  
    for k2 = 1:length(DeviceList),
        
        
        %betaX0= [];betaZ0 = [];betaX1= [];betaZ1 = [];betaX2= [];betaZ2 = [];
        DeviceNumber = DeviceNumber + 1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% State before current change
        Ic = getam(QuadFam{k1}, DeviceList(k2,:)) ;% get the actual current
        %K0 = hw2physics(QuadFam{k1}, 'Setpoint', Ic, DeviceList(k2,:));

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% + deltaI
        DeltaI = getfamilydata(QuadFam{k1},'Setpoint','DeltaKBeta')*2; % Amp
        %fprintf('Current increment of %d A\n', DeltaI);
        stepsp(QuadFam{k1}, DeltaI, DeviceList(k2,:),'Model'); % Step value in Amps
  
        % mesure de tune comme sur la machine delta I 
        tune1 = gettune('Model')
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -2 *deltaI
        %fprintf('Current increment of %d A\n', -2*DeltaI);
        stepsp(QuadFam{k1}, -2*DeltaI, DeviceList(k2,:),'Model'); % 


        % mesure de tune comme sur la machine delta I 
        tune2 = gettune('Model')
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% go back to initial values
        %fprintf('Current increment of %d A\n', DeltaI);
        stepsp(QuadFam{k1}, DeltaI, DeviceList(k2,:),'Model'); % go back to initial values
        
        gettune('Model') % vérification que la machine est bien "revenue"
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         MeffquadH(:,DeviceNumber) = (betaX2 - betaX1)'/(-2*DeltaI) ;% coefficient deltabeta / deltaI in each quad
%         MeffquadV(:,DeviceNumber) = (betaZ2 - betaZ1)'/(-2*DeltaI) ;
%         Meffquad = [MeffquadH ; MeffquadV];
        %betaX1
        %betaX2
        %Meffquad(:,DeviceNumber)
        Meffquad_tune(:,DeviceNumber) = (tune2-tune1)./(-2*DeltaI)
        
    end
    disp('he oui')
    
end

if ArchiveFlag
% enregistrement    
    directory = /home/matlabML/mml/machine/Soleil/StorageRing/quad/;
    directory_actuelle = pwd;
    cd(directory)
    %Name = 'Meffquad_Qnoncoupe_4_3_H_V';
    %Name = 'Meffquad_Qnoncoupe_2_3_H_V';
%     Name = 'Meffquad_beta_tune_2_3_H_V';
    Name = 'Meffquad_beta_tune-tune_2_3_H_V';
    save(Name,'Meffquad_tune','-mat');
    cd(directory_actuelle);
end

if DisplayFlag
    Meffquad
end
disp('c''est fini')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function beta_tune = mesure_beta(QuadFam)

Indexquad = family2atindex({'Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10'});% Index of quadrupoles
DeviceNumber = 0;
beta_tune = [] ; % Initialisation des vecteurs betas X (première ligne) 
                 % et Z (deuxième ligne) dans tous les quad (toutes les colonnes)
                 
for k1 = 1:length(QuadFam),
    
    if ~isfamily(QuadFam{k1})
        error('%s is not a valid Family \n', QuadFam{k1});
        return;
    end   
    DeviceList = family2dev(QuadFam{k1}); 
    
    % initialize data to zero
    tune1 = zeros(length(DeviceList),2);
    tune2 = zeros(length(DeviceList),2);
    dtune = zeros(length(DeviceList),2);
    beta =  zeros(length(DeviceList),2);
    k3 = 0;
    
    for k2 = 1:length(DeviceList),
        
        k3 = k3 +1;
        betaX0= [];betaZ0 = [];betaX1= [];betaZ1 = [];betaX2= [];betaZ2 = [];
        DeviceNumber = DeviceNumber + 1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% State before current change
        Ic = getam(QuadFam{k1}, DeviceList(k2,:)) ;% get the actual current
        K = hw2physics(QuadFam{k1}, 'Setpoint', Ic, DeviceList(k2,:)) ;% Calcul du gradient nominal
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% + deltaI
        DeltaI = getfamilydata(QuadFam{k1},'Setpoint','DeltaKBeta')*4; % Amp
        stepsp(QuadFam{k1}, DeltaI, DeviceList(k2,:),'Model'); % Step value in Amps
        tune1(k3,:) = gettune('Model'); % get new tunes

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -2 *deltaI
        stepsp(QuadFam{k1}, -2*DeltaI, DeviceList(k2,:),'Model'); % 
        tune2(k3,:) = gettune('Model') ;% get new tunes
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% go back to initial values
        stepsp(QuadFam{k1}, DeltaI, DeviceList(k2,:),'Model'); % go back to initial values
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        dtune(k3,:) = tune1(k3,:) - tune2(k3,:);
        Leff = getleff(QuadFam{k1}, DeviceList(k2,:)); % Get effective length
        DeltaKL =  2*DeltaI/Ic*K*Leff;
        beta(k3,:) = 4*pi*dtune(k3,:)./DeltaKL.*[1 -1]    ;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end
    beta0 = beta';
    beta_tune = [beta_tune beta0]; % beta en ligne mesurés par la méthode des tunes
    
end
