function QMS = quadcenterinit(QuadFamily, QuadDev, QuadPlane)
% QMS = quadcenterinit(Family, Device, QuadPlane)
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


% Change in quadrupole strength from it's present value
DeltaQuadFraction = .02;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input checking and defaults %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
QMS = [];
if nargin < 1
    FamilyList = getfamilylist;
    [tmp,i] = ismemberof(FamilyList,'QUAD');
    if ~isempty(i)
        FamilyList = FamilyList(i,:);
    end
    [i,ok] = listdlg('PromptString', 'Select a quadrupole family', ...
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
    if isempty(QuadDev)
        return
    end
end
if nargin < 3
    %QuadPlane = 1;  % Horizontal default
    ButtonNumber = menu('Which Plane?', 'Horizontal', 'Vertical', 'Cancel');
    drawnow;
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
QMS.QuadPlane  = QuadPlane;
QMS.QuadFamily = QuadFamily;
QMS.QuadDev    = QuadDev;


% If the orbit offset are reasonably close to the offset orbit 
QMS.CorrectOrbit = 'no';  % 'yes' or 'no';


% Note: DataDirectory must start with the root of the tree and end with filesep or be '.'
QMSDirectory = [getfamilydata('Directory','DataRoot') 'QMS'];
if isempty(QMSDirectory)
    QMS.DataDirectory = '.';
else
    QMS.DataDirectory = QMSDirectory;
end


% Default QMS structure
QMS.QuadraticFit = 0;       % 0 = linear fit, else quadratic fit
QMS.OutlierFactor = 1;      % BPM Outlier: abs(fit - measured data) > OutlierFactor * std(BPM) 
QMS.CreatedBy = 'quadcenterinit';
QMS.NumberOfPoints = 5;
QMS.ModulationMethod = 'bipolar';

if QMS.QuadPlane==1        
    % Default families
    QMS.BPMFamily  = 'BPMx';
    QMS.CorrFamily = 'HCM';
    
    % Quad delta
    %SPquad = maxsp(QMS.QuadFamily, QMS.QuadDev);
    SPquad = getsp(QMS.QuadFamily, QMS.QuadDev);
%     QMS.QuadDelta = DeltaQuadFraction * SPquad;
    QMS.QuadDelta = 5;

    % Use all BPMs in the minimization
    QMS.BPMDevList = family2dev(QMS.BPMFamily);

    % Find the BPM closest to the quadrupole
    [TmpFamily, QMS.BPMDev, SPosition, PhaseAdvance] = quad2bpm(QMS.QuadFamily, QMS.QuadDev);
    
    % Pick the corrector based on the response matrix
    R = getbpmresp('Struct','Physics');
    [i, iNotFound] = findrowindex(QMS.BPMDev, R(1,1).Monitor.DeviceList);
    m = R(1,1).Data(i,:);
    [MaxValue, j] = max(abs(m));
    QMS.CorrDevList = R(1,1).Actuator.DeviceList(j,:);
    
    % Corrector delta
    QMS.CorrDelta = (1/m(j)) * .5e-3;   % .5 mm change
    if strcmpi(getunits('HCM'), 'Hardware')
        QMS.CorrDelta = physics2hw('HCM', 'Setpoint', QMS.CorrDelta, QMS.CorrDevList);
    end
    

    % Check the phase advance between the BPM and Quad in the model
    PhaseAdvance = 360*PhaseAdvance/2/pi;
    if abs(PhaseAdvance) > 10
        fprintf('\n   Warning: Horizontal phase advance between %s(%d,%d) and %s(%d,%d) is %f degrees.\n', QMS.QuadFamily, QMS.QuadDev, QMS.BPMFamily, QMS.BPMDev, PhaseAdvance);
        fprintf('            This seems large for measuring the quadrupole center.\n\n');
    end

elseif QMS.QuadPlane==2       
    % Default families
    QMS.BPMFamily  = 'BPMy';
    QMS.CorrFamily = 'VCM';
    
    % Quad delta
    %SPquad = maxsp(QMS.QuadFamily, QMS.QuadDev);
    SPquad = getsp(QMS.QuadFamily, QMS.QuadDev);
%     QMS.QuadDelta = DeltaQuadFraction * SPquad;
    QMS.QuadDelta = 5;
    
    % Use all BPMs in the minimization
    QMS.BPMDevList = family2dev(QMS.BPMFamily);

    % Find the BPM closest to the quadrupole
    [TmpFamily, QMS.BPMDev, SPosition, PhaseAdvance] = quad2bpm(QMS.QuadFamily, QMS.QuadDev);
    
    % Pick the corrector based on the response matrix
    R = getbpmresp('Struct','Physics');
    [i, iNotFound] = findrowindex(QMS.BPMDev, R(2,2).Monitor.DeviceList);
    m = R(2,2).Data(i,:);
    [MaxValue, j] = max(abs(m));
    QMS.CorrDevList = R(2,2).Actuator.DeviceList(j,:);
    
    % Corrector delta
    QMS.CorrDelta = (1/m(j)) * .5e-3;  % .5 mm change
    if strcmpi(getunits('VCM'), 'Hardware')
        QMS.CorrDelta = physics2hw('VCM', 'Setpoint', QMS.CorrDelta, QMS.CorrDevList);
    end
    
    % Check the phase advance between the BPM and Quad in the model
    PhaseAdvance = 360*PhaseAdvance/2/pi;
    if abs(PhaseAdvance) > 10
        fprintf('\n   Warning: Vertical phase advance between %s(%d,%d) and %s(%d,%d) is %f degrees.\n', QMS.QuadFamily, QMS.QuadDev, QMS.BPMFamily, QMS.BPMDev, PhaseAdvance);
        fprintf('            This seems large for measuring the quadrupole center.\n\n');
    end

else
    error('QMS.QuadPlane must be 1 or 2');
end

QMS = orderfields(QMS);
