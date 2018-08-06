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
QMS.NumberOfPoints = 4;  % 5
QMS.ModulationMethod = 'bipolar';
QMS.CorrectOrbit = 'no';    % 'yes' or 'no';  % Only do if the orbit is reasonably close to the offset orbit 


% Note: DataDirectory must start with the root of the tree and end with filesep or be '.'
QMSDirectory = [getfamilydata('Directory','DataRoot') 'QMS\'];
if isempty(QMSDirectory)
    QMS.DataDirectory = '.';
else
    QMS.DataDirectory = QMSDirectory;
end



% Default QMS structure
if QMS.QuadPlane==1        
    % Default families
    QMS.BPMFamily  = 'BPMx';
    QMS.CorrFamily = 'HCM';
    
    % Quad delta
    spmax = getsp(QMS.QuadFamily, QMS.QuadDev);
    QMS.QuadDelta = .02 * spmax;
    
    % BPM closest to the quad
    QMS.BPMDevList = getlist(QMS.BPMFamily);
    BPMspos  = getspos(QMS.BPMFamily);
    Quadspos = getspos(QMS.QuadFamily, QMS.QuadDev);
    i = find(abs(Quadspos-BPMspos)==min(abs(Quadspos-BPMspos)));
    QMS.BPMDev = QMS.BPMDevList(i,:);
    
    % Pick the corrector based on the response matrix
    R = getbpmresp('Struct','Physics');
    [i, iNotFound] = findrowindex(QMS.BPMDev, R(1,1).Monitor.DeviceList);
    m = R(1,1).Data(i,:);
    [MaxValue, j] = max(abs(m));
    QMS.CorrDevList = R(1,1).Actuator.DeviceList(j,:);
    
    % Corrector delta
    R = getbpmresp('Struct');
    m = R(1,1).Data(i,:);
    QMS.CorrDelta = abs((1/m(j)) * .3);  % .3 mm change
    
elseif QMS.QuadPlane==2       
    % Default families
    QMS.BPMFamily  = 'BPMy';
    QMS.CorrFamily = 'VCM';
    
    % Quad delta
    spmax = getsp(QMS.QuadFamily, QMS.QuadDev);
    QMS.QuadDelta = .02 * spmax;
    
    % BPM closest to the quad
    QMS.BPMDevList = getlist(QMS.BPMFamily);
    BPMspos  = getspos(QMS.BPMFamily);
    Quadspos = getspos(QMS.QuadFamily, QMS.QuadDev);
    i = find(abs(Quadspos-BPMspos)==min(abs(Quadspos-BPMspos)));
    QMS.BPMDev = QMS.BPMDevList(i,:);
    
    % Pick the corrector based on the response matrix
    R = getbpmresp('Struct','Physics');
    [i, iNotFound] = findrowindex(QMS.BPMDev, R(2,2).Monitor.DeviceList);
    m = R(2,2).Data(i,:);
    [MaxValue, j] = max(abs(m));
    QMS.CorrDevList = R(2,2).Actuator.DeviceList(j,:);
    
    % Corrector delta
    R = getbpmresp('Struct');
    m = R(2,2).Data(i,:);
    QMS.CorrDelta = abs((1/m(j)) * .3);  % .3 mm change
    
else
    error('QMS.QuadPlane must be 1 or 2');
end

QMS.CreatedBy = 'quadcenterinit';
QMS = orderfields(QMS);
