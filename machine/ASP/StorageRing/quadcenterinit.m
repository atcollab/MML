function QMS = quadcenterinit(QuadFamily, QuadDev, QuadPlane, varargin)
% QMS = quadcenterinit(Family, Device, QuadPlane, [BPMdev])
%
% If BPMDev is not given the the closest BPM to the quadrupole is used.
%
% QuadFamily = Quadrupole family
% QuadDev    = Quadrupole device 
% QuadPlane  = Plane (1=horizontal {default}, 2=vertical)
%
% QMS structure contains fields:
% QMS.QuadFamily
% QMS.QuadDev
% QMS.QuadDelta
% QMS.QuadPlane
% QMS.BPMFamily
% QMS.BPMDev
% QMS.BPMDevList
% QMS.CorrFamily
% QMS.CorrDevList             % Often one magnet but bumps or anything else is fine
% QMS.CorrDelta               % Scale factor for each magnet in CorrDevList
% QMS.DataDirectory           % From AD or '.'
% QMS.QuadraticFit = 1;       % 1=quadratic fit, else linear fit
% QMS.OutlierFactor = 1;      % if abs(data - fit) > OutlierFactor * BPMstd, then remove that BPM [mm]
% QMS.NumberOfPoints = 3;
% QMS.ModulationMethod = 'bipolar'
% QMS.CorrectOrbit 'yes' or 'no'
% QMS.CreatedBy


if nargin < 1
    FamilyList = getfamilylist;
    [tmp,i] = ismemberof(FamilyList,'QUAD');
    if ~isempty(i)
        FamilyList = FamilyList(i,:);
    end
    [i,ok] = listdlg('PromptString', 'Select a quadrupole family:', ...
        'SelectionMode', 'single', ...
        'ListString', FamilyList);
    if ok == 0
        return
    else
        QuadFamily = deblank(FamilyList(i,:));
    end
end
if ~isfamily(QuadFamily)
    error(sprintf('Quadrupole family %s does not exist.  Make sure the middle layer had been initialized properly.',QuadFamily));
end
if nargin < 2
    QuadDev = editlist(getlist(QuadFamily),QuadFamily,zeros(length(getlist(QuadFamily)),1));
end
if nargin < 3
    %QuadPlane = 1;  % Horizontal default
    ButtonNumber = menu('Which Plane?', 'Horizontal','Vertical','Cancel');  
    switch ButtonNumber
        case 1
            QuadPlane = 1;
        case 2
            QuadPlane = 2;
        otherwise
            fprintf('   quadcenterinit cancelled');
            return
    end
end

% Initialize the QMS structure
QMS.QuadPlane = QuadPlane;
QMS.QuadFamily = QuadFamily;
QMS.QuadDev = QuadDev;
QMS.QuadraticFit = 0;       % 0 = linear fit, else quadratic fit
QMS.OutlierFactor = 6;      % BPM Outlier: abs(fit - measured data) > OutlierFactor * std(BPM) 
QMS.NumberOfPoints = 4;     % 5
QMS.ModulationMethod = 'bipolar';
QMS.CorrectOrbit = 'no';    % 'yes' or 'no';  % Only do if the orbit is reasonably close to the offset orbit 


% Note: DataDirectory must start with the root of the tree and end with filesep or be '.'
QMSDirectory = [getfamilydata('Directory','DataRoot') 'QMS' filesep];
if isempty(QMSDirectory)
    QMS.DataDirectory = '.';
else
    QMS.DataDirectory = QMSDirectory;
end

    
% Select whether to use the first or second bpm to measure the offset
% for the QFA magnets.
bpm_in_short_girder = 2; % first (1) or second (2)

% Default QMS structure
if QMS.QuadPlane==1        
    % Default families
    QMS.BPMFamily  = 'BPMx';
    QMS.CorrFamily = 'HCM';
    
    % Quad delta. Can actuate more than one quadrupole... so scale
    % the strength linearly with the number of quads to actuate.
    spmax = getsp(QMS.QuadFamily, QMS.QuadDev);
    switch QMS.QuadFamily
        case 'QFA'
            %QMS.QuadDelta = .05 * spmax; % in amps
            QMS.QuadDelta = 0.02*spmax/length(spmax);
        case 'QFB'
            %QMS.QuadDelta = .02 * spmax;
            QMS.QuadDelta = 0.01*spmax/length(spmax);
        case 'QDA'
            %QMS.QuadDelta = .02 * spmax;
            QMS.QuadDelta = 0.03*spmax/length(spmax);
        case 'SFA'
            %QMS.QuadDelta = .05 * spmax; % in amps
            QMS.QuadDelta = 20;
        case 'SDA'
            %QMS.QuadDelta = .02 * spmax;
            QMS.QuadDelta = 20;
        case 'SDB'
            %QMS.QuadDelta = .02 * spmax;
            QMS.QuadDelta = 20;
        case 'SFB'
            %QMS.QuadDelta = .02 * spmax;
            QMS.QuadDelta = 20;
    end
    
    if nargin < 4
        % BPM closest to the quad
        QMS.BPMDevList = getlist(QMS.BPMFamily);
        BPMspos  = getspos(QMS.BPMFamily);
        Quadspos = getspos(QMS.QuadFamily, QMS.QuadDev);
        i = find(abs(Quadspos-BPMspos)==min(abs(Quadspos-BPMspos)));
        QMS.BPMDev = QMS.BPMDevList(i,:);
        if strcmpi(QMS.QuadFamily,'QFA')
            QMS.BPMDev(2) = QMS.BPMDev(2) + (bpm_in_short_girder-1);
        end
    else
        QMS.BPMDevList = getlist(QMS.BPMFamily);
        QMS.BPMDev = varargin{1};
    end
        
    % Pick the corrector based on the response matrix to pick the most
    % effective corrector.
    R = getbpmresp('Struct','Hardware');
    [i, iNotFound] = findrowindex(QMS.BPMDev, R(1,1).Monitor.DeviceList);
%     [i, iNotFound] = findrowindex([3 3], R(1,1).Monitor.DeviceList);
    m = R(1,1).Data(i,:);
    [MaxValue, j] = max(abs(m));
    QMS.CorrDevList = R(1,1).Actuator.DeviceList(j,:);

    % Move beam closer to 0 if starting position is greater than +-2 mm.
%     currpos = getam(QMS.BPMFamily,QMS.BPMDev,'Hardware');
%     if abs(currpos) > 2
%         resp_val = m(j);
%         stepcorrval = -currpos./resp_val;
%         stepsp(QMS.CorrFamily,stepcorrval,QMS.CorrDevList);
%     end
        
    % Corrector delta in ampere. m(j) is the response of the bpm of interest due to
    % the corrector of interest and is in units of mm/ampere. Therefore the
    % number that we multiply against below are mm offsets that we want to
    % observe at the BPM.
    switch QMS.BPMDev(2)
        case {1 7}
            QMS.CorrDelta = 1; %2; %abs((1./m(j)) * 1);
        case {2 6}
            QMS.CorrDelta = 1; %2; %abs((1./m(j)) * 1);
        case {4}
            QMS.CorrDelta = 1; %2; %abs((1./m(j)) * 1);
        case {3 5}
            QMS.CorrDelta = 2; %3; %abs((1./m(j)) * 1);
    end
    if strcmpi(getunits(QMS.CorrFamily),'Physics')
        % Calculated values above are in HW units. If the default units are
        % in physics then we have to do a conversion into radians.
        QMS.CorrDelta = hw2physics(QMS.CorrFamily,'Setpoint',QMS.CorrDelta,QMS.CorrDevList);
    end
    
elseif QMS.QuadPlane==2       
    % Default families
    QMS.BPMFamily  = 'BPMy';
    QMS.CorrFamily = 'VCM';
    
    % Quad delta
    spmax = getsp(QMS.QuadFamily, QMS.QuadDev);
    switch QMS.QuadFamily
        case 'QFA'
            %QMS.QuadDelta = .05 * spmax; % in amps
            QMS.QuadDelta = 0.02*spmax/length(spmax);
        case 'QFB'
            %QMS.QuadDelta = .02 * spmax;
            QMS.QuadDelta = 0.01*spmax/length(spmax);
        case 'QDA'
            %QMS.QuadDelta = .02 * spmax;
            QMS.QuadDelta = 0.03*spmax/length(spmax);
        case 'SFA'
            %QMS.QuadDelta = .05 * spmax; % in amps
            QMS.QuadDelta = 40;
        case 'SDA'
            %QMS.QuadDelta = .02 * spmax;
            QMS.QuadDelta = 40;
        case 'SDB'
            %QMS.QuadDelta = .02 * spmax;
            QMS.QuadDelta = 40;
        case 'SFB'
            %QMS.QuadDelta = .02 * spmax;
            QMS.QuadDelta = 40;
    end
    
    if nargin < 4
        % BPM closest to the quad
        QMS.BPMDevList = getlist(QMS.BPMFamily);
        BPMspos  = getspos(QMS.BPMFamily);
        Quadspos = getspos(QMS.QuadFamily, QMS.QuadDev);
        i = find(abs(Quadspos-BPMspos)==min(abs(Quadspos-BPMspos)));
        QMS.BPMDev = QMS.BPMDevList(i,:);
        if strcmpi(QMS.QuadFamily,'QFA')
            QMS.BPMDev(2) = QMS.BPMDev(2) + (bpm_in_short_girder-1);
        end
    else
        QMS.BPMDevList = getlist(QMS.BPMFamily);
        QMS.BPMDev = varargin{1};
    end

    % Pick the corrector based on the response matrix
    R = getbpmresp('Struct','Hardware');
    [i, iNotFound] = findrowindex(QMS.BPMDev, R(2,2).Monitor.DeviceList);
%     [i, iNotFound] = findrowindex([3 3], R(2,2).Monitor.DeviceList);
    m = R(2,2).Data(i,:);
    [MaxValue, j] = max(abs(m));
    QMS.CorrDevList = R(2,2).Actuator.DeviceList(j,:);
    
    % Corrector delta in ampere. m(j) is the response of the bpm of interest due to
    % the corrector of interest and is in units of mm/ampere. Therefore the
    % number that we multiply against below are mm offsets that we want to
    % observe at the BPM.
    switch QMS.BPMDev(2)
        case {1 7}
            QMS.CorrDelta = 1; %-abs((1./m(j)) * 0.5);
        case {2 6}
            QMS.CorrDelta = 1; %-abs((1./m(j)) * 0.5);
        case {4}
            QMS.CorrDelta = 1; %-abs((1./m(j)) * 0.5);
        case {3 5}
            QMS.CorrDelta = 1; %-abs((1./m(j)) * 0.5);
    end
    if strcmpi(getunits(QMS.CorrFamily),'Physics')
        % Calculated values above are in HW units. If the default units are
        % in physics then we have to do a conversion into radians.
        QMS.CorrDelta = hw2physics(QMS.CorrFamily,'Setpoint',QMS.CorrDelta,QMS.CorrDevList);
    end
else
    error('QMS.QuadPlane must be 1 or 2');
end

QMS.CreatedBy = 'quadcenterinit';
QMS = orderfields(QMS);
