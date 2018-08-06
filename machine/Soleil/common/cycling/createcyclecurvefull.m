function createcylecurvefull(varargin);
% INPUTS
%1. Family

DisplayFlag = 1;

% Parse input options
InputFlags = {};
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end

%% Load Golden Magnet parameters

FileName = getfamilydata('OpsData', 'LatticeFile');
DirectoryName = getfamilydata('Directory', 'OpsData');
cnf=load([DirectoryName FileName]);
%% Setpoints values
Setpoint = cnf.ConfigSetpoint;

Family = varargin{1};

[FamilyIndex, AO] = isfamily(Family);
if isempty(FamilyIndex)
    error('Unknown Family');
end

% create cycling family name
CycleFamily = ['Cycle' Family];
[CycleIndex, CycleAO] = isfamily(CycleFamily);

%% Family switchyard
Inom = Setpoint.(Family).Data;
if (ismemberof(CycleFamily,'Cyclage'))
     for k = 1:tango_group_size(CycleAO.GroupId)
        %% PAS BEAU --  utiliser le mml pour etre sur de la correspondance
        CycleAO.Inom(k) = cnf.ConfigSetpoint.(Family).Data(k);
        %% create cycling curve
        curve = makecurve(CycleAO.Inom(k),CycleAO.Imax(k),Family)
        %% upload cycling curve
        if DisplayFlag
            fprintf(1,'device : Inom = %f Imax= %f \n', ...
                CycleAO.Inom(k), CycleAO.Imax(k));
            plotcyclecurve(curve);
        end
        reply = input('Apply to Dserver new cycling curve ? (y/n)','s');
        switch lower(reply)
            case {'Y','Yes'}
                setcyclecurve(CycleFamily,curve);
            otherwise
                disp('Parameter not set to dserver')
        end
    end
else
    error('Unknown Cycling Family')
end

end

function curve = makecurve(Inom,Imax,MagnetType)

switch MagnetType
    case {'BEND','QP','CH','CV'}
        curve = [[0 10]
            [Imax 180]
            [0.95*Inom 180]
            [1.05*Inom 180]
            [0.95*Inom 180]
            [1.05*Inom 180]
            [0.95*Inom 180]
            [Inom 180] ];
end
end

