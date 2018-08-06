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
% QMS.ExtraDelay              % Extra delay added before reading the BPMs


if nargin < 1
    FamilyList = getfamilylist;
    [tmp,i] = ismemberof(FamilyList,'QUAD');
    if ~isempty(i)
        FamilyList = FamilyList(i,:);
    end
    [i,ok] = listdlg('PromptString', 'Select a quadrupole family:', ...
        'SelectionMode', 'single', ...
        'ListString', FamilyList);
    drawnow;
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
    QuadDev = editlist(family2dev(QuadFamily),QuadFamily,zeros(length(family2dev(QuadFamily)),1));
end
if nargin < 3
    %QuadPlane = 1;  % Horizontal default
    ButtonNumber = menu('Which Plane?', 'Horizontal','Vertical','Cancel');  
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
QMS.QuadPlane = QuadPlane;
QMS.QuadFamily = QuadFamily;
QMS.QuadDev = QuadDev;
QMS.OutlierFactor = 6;     % BPM Outlier: abs(fit - measured data) > OutlierFactor * std(BPM) 
QMS.CorrectOrbit = 'No';  %'Yes';   % 'yes' or 'no';  % Only select 'yes' if the orbit is reasonably close to the offset orbit 
QMS.ExtraDelay = 1;        % Eddy current has been put in setquad so ExtraDelay is not needed
                           % I added 1 second just because I was getting some odd results on 2015-


% Note: DataDirectory must start with the root of the tree and end with filesep or be '.'
QMSDirectory = [getfamilydata('Directory','DataRoot') 'QMS', filesep];
if isempty(QMSDirectory)
    QMS.DataDirectory = '.';
else
    QMS.DataDirectory = QMSDirectory;
end


% The rest of the parameters depend on the magnet and the plane
if QMS.QuadPlane==1        
    %%%%%%%%%%%%%%
    % Horizontal %
    %%%%%%%%%%%%%%

    QMS.BPMFamily  = 'BPMx';
    QMS.CorrFamily = 'HCM';
    QMS.QuadraticFit = 1;       % 0 = linear fit, else quadratic fit
    
    % Use all BPMs in the minimization
    QMS.BPMDevList = family2dev(QMS.BPMFamily);

    % Find the BPM closest to the quadrupole
    [TmpFamily, QMS.BPMDev] = quad2bpm(QMS.QuadFamily, QMS.QuadDev);
    
    s = getspos('BPMx', QMS.BPMDev);
    %if s > 5 && s < 191.5
    %    CorrMethod = 'LocalBump';
    %else
    CorrMethod = 'MEC';
    %CorrMethod = 'Fixed';
    %end
 
    %CorrMethod = 'LocalBump';
    
    
    % Pick the quadrupole and corrector delta
    if strcmp(QMS.QuadFamily,'QF') == 1
        QMS.ModulationMethod = 'sweep';
        QMS.QuadDelta = 0.9;
        QMS.CorrDelta = 3.0;     % Was 1.5;  If using MEC, this will get overwritten by the MaxOrbit condition.
        MaxOrbit = .75;
        QMS.NumberOfPoints = 4;  
    elseif strcmp(QMS.QuadFamily,'QD') == 1
        % The max dQD should < 3.5 amps
        QMS.ModulationMethod = 'sweep';
        QMS.QuadDelta = 1.3;     % Was .9  .75
        QMS.CorrDelta = 3.5;     % If using MEC, this will get overwritten by the MaxOrbit condition.
        MaxOrbit = 1.;
        QMS.NumberOfPoints = 3;  % 5 points @.75 amps had problems with tune shift
    elseif strcmp(QMS.QuadFamily,'QDA') == 1
        QMS.ModulationMethod = 'sweep';
        QMS.QuadDelta = 1.5;     % Was 2.0
        QMS.CorrDelta = 3.5;     % If using MEC, this will get overwritten by the MaxOrbit condition.
        MaxOrbit = .75;          % Was 1.0, 1.5
        QMS.NumberOfPoints = 4;
    elseif strcmp(QMS.QuadFamily,'QFA') == 1
        % QuadDelta is for the model, in the machine a shunt is used
        QMS.ModulationMethod = 'sweep';
        if any(strcmpi(getfamilydata(QMS.QuadFamily, 'Setpoint', 'Mode', QMS.QuadDev), {'Simulator', 'Model'}))
            QMS.QuadDelta = 13.0;     % Simulator
        else
            QMS.QuadDelta = 1.0;      % QFA quad must be 1 if online (for the shunt)
        end
        QMS.CorrDelta = 5;       % If using MEC, this will get overwritten by the MaxOrbit condition.
        MaxOrbit = .5;
        QMS.NumberOfPoints = 2;
    else
        error('QuadFamily error.');
    end
    
    % Find corrector the bump the beam in the quadrupole
    switch CorrMethod
        case 'Fixed'
            % Old QMS method
            if strcmp(QMS.QuadFamily,'QF')==1 || strcmp(QMS.QuadFamily,'QD')==1
                if QMS.QuadDev(1,2) == 1,
                    QMS.CorrDevList = [QMS.QuadDev(1) 1];
                else
                    QMS.CorrDevList = [QMS.QuadDev(1) 8];
                end
                if (QMS.QuadDev(1,1)==1 && QMS.CorrDevList(1,2)==1)        % for sector1,  use HCM8 was HCM1
                    QMS.CorrDevList = [QMS.QuadDev(1) 2];
                elseif (QMS.QuadDev(1,1)==12 && QMS.CorrDevList(1,2)==8)   % for sector12, use HCM1 was HCM8
                    QMS.CorrDevList = [QMS.QuadDev(1) 7];
                end
            elseif strcmp(QMS.QuadFamily,'QDA')==1
                if QMS.QuadDev(1,2) == 1
                    QMS.CorrDevList = [QMS.QuadDev(1) 4];
                else
                    QMS.CorrDevList = [QMS.QuadDev(1) 5];
                end
            elseif strcmp(QMS.QuadFamily,'QFA')==1
                if QMS.QuadDev(1,2) == 1
                    QMS.CorrDevList = [QMS.QuadDev(1) 8];
                else
                    QMS.CorrDevList = [QMS.QuadDev(1) 1];
                end
                if (QMS.QuadDev(1,1)==1 && QMS.CorrDevList(1,2)==1)
                    QMS.CorrDevList = [QMS.QuadDev(1) 2];
                elseif (QMS.QuadDev(1,1)==12 && QMS.CorrDevList(1,2)==8)
                    QMS.CorrDevList = [QMS.QuadDev(1) 7];
                end
            end

        case 'MEC'
            % Pick the corrector based on the most effective corrector in the response matrix

            % Only use corrector 10's
            HCMlist = getcmlist('HCM','10');
            VCMlist = getcmlist('VCM','10');

            % Remove the CM next to the quad
            CMDevRemove = quad2cm(QMS);
            i = findrowindex(CMDevRemove, HCMlist);
            HCMlist(i,:) = [];
            i = findrowindex(CMDevRemove, VCMlist);
            VCMlist(i,:) = [];
            
            % Base MEC on the response matrix (use the model if there is a concern over the quality of the measured response matrix)
            R = measbpmresp('BPMx', [], 'BPMy', [], 'HCM', HCMlist, 'VCM', VCMlist, 'Model', 'Struct', 'Physics');
            %R = getbpmresp('BPMx', [], 'BPMy', [], 'HCM', HCMlist, 'VCM', VCMlist, 'Struct', 'Physics');
            %R = getbpmresp('Struct','Physics');
            
            [i, iNotFound] = findrowindex(QMS.BPMDev, R(1,1).Monitor.DeviceList);
            m = R(1,1).Data(i,:);
            [MaxValue10, j] = max(abs(m));
            CorrDevList10 = R(1,1).Actuator.DeviceList(j,:);
            
            
            % Use all 1278
            HCMlist = getcmlist('HCM','1 2 7 8');
            VCMlist = getcmlist('VCM','1 2 7 8');

            % Remove the CM next to the quad
            CMDevRemove = quad2cm(QMS);
            i = findrowindex(CMDevRemove, HCMlist);
            HCMlist(i,:) = [];
            i = findrowindex(CMDevRemove, VCMlist);
            VCMlist(i,:) = [];

            % Base MEC on the response matrix (use the model if there is a concern over the quality of the measured response matrix)
            R = measbpmresp('BPMx', [], 'BPMy', [], 'HCM', HCMlist, 'VCM', VCMlist, 'Model', 'Struct', 'Physics');
            %R = getbpmresp('BPMx', [], 'BPMy', [], 'HCM', HCMlist, 'VCM', VCMlist, 'Struct', 'Physics');
            %R = getbpmresp('Struct','Physics');

            [i, iNotFound] = findrowindex(QMS.BPMDev, R(1,1).Monitor.DeviceList);
            m = R(1,1).Data(i,:);
            [MaxValue, j] = max(abs(m));
            QMS.CorrDevList = R(1,1).Actuator.DeviceList(j,:);


            %if abs(MaxValue10) > .75 * abs(MaxValue)
            %    % Use the corrector at position 10 if it's a pretty good corrector
            %    QMS.CorrDelta = 5;
            %    QMS.CorrDevList = CorrDevList10;
            %end
            
            if 1
                % Corrector delta based on response matrix and desired change at the BPM
                %R = getrespmat('BPMx', QMS.BPMDev, 'HCM', QMS.CorrDevList, 'Hardware', 'Numeric');
                Rh = physics2hw(R);
                i = findrowindex(QMS.BPMDev, Rh(1,1).Monitor.DeviceList);
                j = findrowindex(QMS.CorrDevList, Rh(1,1).Actuator.DeviceList);
                R11 = Rh(1,1).Data(i,j);
                if any(R11==0)
                    fprintf('HCM(%d,%d) to BPMx(%d,%d) response is zero.\n', QMS.CorrDevList, QMS.BPMDev);
                    error('Response matrix lookup problem.');
                else
                    QMS.CorrDelta = MaxOrbit / R11;  % +/- mm
                end
            end
            
        case 'LocalBump'
            % Local bump corrector method
            if strcmp(QMS.QuadFamily,'QF') == 1
                if QMS.QuadDev(2) == 1
                    if all(QMS.QuadDev(1) == [1 1])
                        QMS.CorrDevList = [
                            12             7
                            QMS.QuadDev(1)     2
                            QMS.QuadDev(1)     3];
                        [OCS, OCS0, V, S, ErrorFlag] = setorbitbump('BPMx',QMS.BPMDev,.15,'HCM', QMS.CorrDevList, 5, 'Incremental');
                    else
                        % Try parallel with 4 correctors???
                        QMS.CorrDevList = [
                            QMS.QuadDev(1)-1    8
                            QMS.QuadDev(1)     1
                            QMS.QuadDev(1)     2
                            QMS.QuadDev(1)+1   3];
                        [OCS, OCS0, V, S, ErrorFlag] = setorbitbump('BPMx',[QMS.BPMDev] ,.15,'HCM', QMS.CorrDevList, 5, 'Incremental');
                    end
                    %[OCS, OCS0, V, S, ErrorFlag] = setorbitbump('BPMx',QMS.BPMDev,.25,'HCM',[-2 -1 1 3], 5, 'Incremental', 'NoSetSP');
                    QMS.CorrDelta = OCS.CM.Data - OCS0.CM.Data;
                    setpv(OCS0.CM);
                else
                    if all(QMS.QuadDev(1) == [12 2])
                        QMS.CorrDevList = [
                            QMS.QuadDev(1)     6
                            QMS.QuadDev(1)     7
                            1              2];
                        [OCS, OCS0, V, S, ErrorFlag] = setorbitbump('BPMx',QMS.BPMDev,.15,'HCM', QMS.CorrDevList, 5, 'Incremental');
                    else
                        QMS.CorrDevList = [
                            QMS.QuadDev(1)     6
                            QMS.QuadDev(1)     7
                            QMS.QuadDev(1)     8
                            QMS.QuadDev(1)+1   1];
                        [OCS, OCS0, V, S, ErrorFlag] = setorbitbump('BPMx',QMS.BPMDev,.15,'HCM', QMS.CorrDevList, 5, 'Incremental');
                    end
                    %[OCS, OCS0, V, S, ErrorFlag] = setorbitbump('BPMx',QMS.BPMDev,.25,'HCM',[-3 -1 1 2], 5, 'Incremental', 'NoSetSP');
                    QMS.CorrDelta = OCS.CM.Data - OCS0.CM.Data;
                    setpv(OCS0.CM);
                end
            else
                [OCS, OCS0, V, S, ErrorFlag] = setorbitbump('BPMx',QMS.BPMDev,.5,'HCM',[-3 -1 1 3], 'Incremental', 'NoSetSP');
                QMS.CorrDelta = OCS.CM.Data;
            end
            QMS.CorrDevList = OCS.CM.DeviceList;
            
        otherwise
            error('Corrector method unknown.');
    end

elseif QMS.QuadPlane == 2
    %%%%%%%%%%%%
    % Vertical %
    %%%%%%%%%%%%

    CorrMethod = 'MEC';
    %CorrMethod = 'LocalBump';
    %CorrMethod = 'Fixed';

    QMS.BPMFamily  = 'BPMy';
    QMS.CorrFamily = 'VCM';
    QMS.NumberOfPoints = 5;
    QMS.QuadraticFit = 0;       % 0 = linear fit, else quadratic fit

    % Use all BPMs in the minimization
    QMS.BPMDevList = family2dev(QMS.BPMFamily);

    % Find the BPM closest to the quadrupole
    [TmpFamily, QMS.BPMDev] = quad2bpm(QMS.QuadFamily, QMS.QuadDev);

    % Pick the quadrupole and corrector delta
    if strcmp(QMS.QuadFamily,'QF') == 1
        if 1
            % Bipolar method
            QMS.ModulationMethod = 'bipolar';
            QMS.QuadDelta = 1.0;  % was .75;
            QMS.CorrDelta = 3.0;  % was 0.75 1.0  If using MEC, this will get overwritten by the MaxOrbit condition.
            MaxOrbit = .5;
        else
            % Sweep method
            QMS.NumberOfPoints = 5;
            QMS.ModulationMethod = 'sweep';
            QMS.QuadDelta = .5;
            QMS.CorrDelta = 3;    %  If using MEC, this will get overwritten by the MaxOrbit condition.
            MaxOrbit = .5;
        end
    elseif strcmp(QMS.QuadFamily,'QD') == 1
        QMS.ModulationMethod = 'bipolar';
        QMS.QuadDelta = 1.;
        QMS.CorrDelta = 3;    %  If using MEC, this will get overwritten by the MaxOrbit condition.
        MaxOrbit = .5;
    elseif strcmp(QMS.QuadFamily,'QDA') == 1
        QMS.ModulationMethod = 'bipolar';
        QMS.QuadDelta = 2.5;  % was 2.0, 2.5
        QMS.CorrDelta = 2.0;  % 1.5, 0.75, 2.5
        MaxOrbit = .5;
    elseif strcmp(QMS.QuadFamily,'QFA') == 1
        % QuadDelta is for the model, in the machine a shunt is used
        QMS.ModulationMethod = 'unipolar';
        if any(strcmpi(getfamilydata(QMS.QuadFamily, 'Setpoint', 'Mode', QMS.QuadDev), {'Simulator', 'Model'}))
            QMS.QuadDelta = 13.0;     % Simulator  13 amp for 1 shunt, 26 amps for both
        else
            QMS.QuadDelta = 1.0;     % QFA quad must be 1 or 2 if online  (both shunts hits a resonance!!!)
        end
        QMS.CorrDelta = 4.0;
        MaxOrbit = 0.75;       % was 1.0
    else
        error('QuadFamily error.');
    end

    % Find corrector the bump the beam in the quadrupole
    switch CorrMethod
        case 'Fixed'
            % Old QMS method
            if strcmp(QMS.QuadFamily,'QF')==1 || strcmp(QMS.QuadFamily,'QD')==1
                if QMS.QuadDev(1,2) == 1
                    QMS.CorrDevList = [QMS.QuadDev(1) 2];
                else
                    QMS.CorrDevList = [QMS.QuadDev(1) 7];
                end
            elseif strcmp(QMS.QuadFamily,'QDA')==1
                if QMS.QuadDev(1,2) == 1
                    QMS.CorrDevList = [QMS.QuadDev(1) 4];
                else
                    QMS.CorrDevList = [QMS.QuadDev(1) 5];
                end
            elseif strcmp(QMS.QuadFamily,'QFA')==1
                if QMS.QuadDev(1,2) == 1
                    QMS.CorrDevList = [QMS.QuadDev(1) 2];
                else
                    QMS.CorrDevList = [QMS.QuadDev(1) 7];
                end
            end
            
        case 'MEC'
            % Pick the corrector based on the most effective corrector in the response matrix

            % Only use corrector 10's
            HCMlist = getcmlist('HCM','10');
            VCMlist = getcmlist('VCM','10');

            % Remove the CM next to the quad
            CMDevRemove = quad2cm(QMS);
            i = findrowindex(CMDevRemove, HCMlist);
            HCMlist(i,:) = [];
            i = findrowindex(CMDevRemove, VCMlist);
            VCMlist(i,:) = [];

            % Base MEC on the response matrix (use the model if there is a concern over the quality of the measured response matrix)
            R = measbpmresp('BPMx', [], 'BPMy', [], 'HCM', HCMlist, 'VCM', VCMlist, 'Model', 'Struct', 'Physics');
            %R = getbpmresp('BPMx', [], 'BPMy', [], 'HCM', HCMlist, 'VCM', VCMlist, 'Struct', 'Physics');
            %R = getbpmresp('Struct','Physics');

            [i, iNotFound] = findrowindex(QMS.BPMDev, R(2,2).Monitor.DeviceList);
            m = R(2,2).Data(i,:);
            [MaxValue10, j] = max(abs(m));
            CorrDevList10 = R(2,2).Actuator.DeviceList(j,:);


            % Use all 1278
            HCMlist = getcmlist('HCM','1 2 7 8');
            VCMlist = getcmlist('VCM','1 2 7 8');

            % Remove the CM next to the quad
            CMDevRemove = quad2cm(QMS);
            i = findrowindex(CMDevRemove, HCMlist);
            HCMlist(i,:) = [];
            i = findrowindex(CMDevRemove, VCMlist);
            VCMlist(i,:) = [];

            % Base MEC on the response matrix (use the model if there is a concern over the quality of the measured response matrix)
            R = measbpmresp('BPMx', [], 'BPMy', [], 'HCM', HCMlist, 'VCM', VCMlist, 'Model', 'Struct', 'Physics');
            %R = getbpmresp('BPMx', [], 'BPMy', [], 'HCM', HCMlist, 'VCM', VCMlist, 'Struct', 'Physics');
            %R = getbpmresp('Struct','Physics');

            [i, iNotFound] = findrowindex(QMS.BPMDev, R(2,2).Monitor.DeviceList);
            m = R(2,2).Data(i,:);
            [MaxValue, j] = max(abs(m));
            QMS.CorrDevList = R(2,2).Actuator.DeviceList(j,:);
            
            
            %if abs(MaxValue10) > .75 * abs(MaxValue)
            %    % Use the corrector at position 10 if it's a pretty good corrector
            %    QMS.CorrDelta = 10;
            %    QMS.CorrDevList = CorrDevList10;
            %end
            
            if 1
                % Corrector delta based on response matrix and desired change at the BPM
                %R = getrespmat('BPMy', QMS.BPMDev, 'VCM', QMS.CorrDevList, 'Hardware', 'Numeric');
                Rh = physics2hw(R);
                i = findrowindex(QMS.BPMDev, Rh(2,2).Monitor.DeviceList);
                j = findrowindex(QMS.CorrDevList, Rh(2,2).Actuator.DeviceList);
                R22 = Rh(2,2).Data(i,j);
                if any(R22==0)
                    fprintf('VCM(%d,%d) to BPMy(%d,%d) response is zero.\n', QMS.CorrDevList, QMS.BPMDev);
                    error('Response matrix lookup problem.');
                else
                    QMS.CorrDelta = MaxOrbit / R22;  % +/- mm
                end
            end

        case 'LocalBump'
            % Local bump corrector method
           %[OCS, OCS0, V, S, ErrorFlag] = setorbitbump('BPMy', QMS.BPMDev, .25, 'VCM', [-2 -1 1 2], 'Incremental', 'NoSetSP');
            [OCS, OCS0, V, S, ErrorFlag] = setorbitbump('BPMy',QMS.BPMDev,.25,'VCM',[-4 -3 -2 2 3 4], 'Incremental', 'NoSetSP');
            QMS.CorrDelta = OCS.CM.Data;
            %QMS.CorrDelta = OCS.CM.Data - OCS0.CM.Data;
            %[OCS, RF, OCS0] = setorbitbump('BPMy', QMS.BPMDev, .25, 'VCM', [-2 -1 1 2], 'Display');
            %setsp(OCS0.CM);
            %QMS.CorrDelta = OCS.CM.Data - OCS0.CM.Data;
            QMS.CorrDevList = OCS.CM.DeviceList;
            
        otherwise
            error('Corrector method unknown.');
    end

else
    error('QMS.QuadPlane must be 1 or 2');
end


QMS.CreatedBy = 'quadcenterinit';
QMS = orderfields(QMS);






function CorrDevList = quad2cm(QMS)
if strcmp(QMS.QuadFamily,'QF')==1 || strcmp(QMS.QuadFamily,'QD')==1
    if QMS.QuadDev(1,2) == 1
        CorrDevList = [QMS.QuadDev(1) 1; QMS.QuadDev(1) 2];
    else
        CorrDevList = [QMS.QuadDev(1) 7; QMS.QuadDev(1) 8];
    end
elseif strcmp(QMS.QuadFamily,'QDA')==1
    if QMS.QuadDev(1,2) == 1
        CorrDevList = [QMS.QuadDev(1) 4];
    else
        CorrDevList = [QMS.QuadDev(1) 5];
    end
elseif strcmp(QMS.QuadFamily,'QFA')==1
    if QMS.QuadDev(1,2) == 1
        CorrDevList = [QMS.QuadDev(1) 2];
    else
        CorrDevList = [QMS.QuadDev(1) 7];
    end
end
