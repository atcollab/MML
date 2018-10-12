function [QMS1, QMS2] = quadcenter(QuadFamily, QuadDev, XYPlane, BPMDev, FigureHandle)
%QUADCENTER - Measure the magnet center of a quadrupole magnet
%  [QMS1, QMS2] = quadcenter(QuadFamily, QuadDev, XYPlane, BPMDev, FigureHandle)
%                     or
%  [QMS1, QMS2] = quadcenter(QMSstructure, FigureHandle)
%
%  Finds the center of an individual quadrupole magnet.
%  The data is automatically appended to quadcenter.log and 
%  saved to an individual mat file named by family, sector, and element number
%
%  INPUTS 
%  1. QuadFamily  = Family name
%  2. QuadDev     = Device list for quadrupole family
%  3. XYPlane     = 0 -> both horizontal and vertical {default}
%                   1 -> horizontal only
%                   2 -> vertical only 
%  4. BPMDev      = Device list for BPM family (defined in quadcenterinit)
%  5. FigureHandle can be a figure handle, a vector of 4 axes handles 
%                 (used by quadplot), or zero for no plots
%
%  The QuadFamily and QuadDev input get converted to a QMSstructure using quadcenterinit.  
%  One can also directly input this data structure.
%  QMSstructure = 
%         QuadFamily: Quadrupole family name, like 'QF'
%            QuadDev: Quadrupole device, like [7 1]
%          QuadDelta: Modulation amplitude in the quadrupole, like 1
%          QuadPlane: Horizontal (1) or vertical (2) plane
%         CorrFamily: Corrector magnet family, like 'HCM'
%        CorrDevList: Corrector magnet(s) using to vary the orbit in the quadrupole, like [7 1]
%          CorrDelta: Maximum change in the corrector(s), like 0.5000
%          BPMFamily: BPM family name, like 'BPMx'
%             BPMDev: BPM device next to the quadrupole, like [7 1]
%         BPMDevList: BPM device list used calculate the center and for orbit correction ([nx2 array])
%   ModulationMethod: Method for changing the quadrupole
%                         'bipolar' changes the quadrupole by +/- QuadDelta on each step
%                         'unipolar' changes the quadrupole from 0 to QuadDelta on each step
%                         'sweep' moves the quadrupole by QuadDelta at each step.  This allows for
%                                 staying on a given hysteresis branch.
%     NumberOfPoints: Number of points, like 3
%      DataDirectory: Directory to store the results.  Leave this field out or '.' will put the data
%                         in the present directory.
%       QuadraticFit: 0 = linear fit, else quadratic fit  (used by quadplot)
%      OutlierFactor: if abs(data - fit) > OutlierFactor, then remove that BPM from the center calculation [mm] (used by quadplot)
%         ExtraDelay: Extra delay added before reading the BPMs [seconds] {optional}
%
%  OUTPUTS
%  The QMSstructure input structure will get the following output fields appended to it.  
%  This structure will be output as well as saved to a file which is named based on the 
%  sector, quadrupole family name, and device number.  A log file will also be updated.
%  QMSstructure = 
%          OldCenter: Old quadrupole center (from getoffsetorbit)
%                 x1: horizonal data at quadrupole value #1
%                 x2: horizonal data at quadrupole value #2
%                 y1: vertical data at quadrupole value #1
%                 y2: vertical data at quadrupole value #2
%               Xerr: Horizonal BPM starting error
%               Yerr: Vertical  BPM starting error
%          TimeStamp: Time stamp as output by clock (6 element vector)
%          CreatedBy: 'quadcenter'
%      QMS.BPMStatus: Status of the BPMs
%         QMS.BPMSTD: Standard deviation of the BPMs (from getsigma)
%             Center: Mean of the BPM center calculations
%          CenterSTD: Standard deviation of the BPM center calculations 
%  For two planes, QMS1 is the horizontal and QMS2 is the vertical.  When only finding
%  one plane, only the first output is used.  For multiple magnets, the output is a column
%  vector containing the quadrupole center. 
%
%  NOTE
%  1. It is a good idea to have the global orbit reasonable well corrected at the start
%  2. If the quadrupole modulation system is not a simple device with one family name then
%     edit the setquad function (machine specific).
%  3. For the new BPM offsets to take effect, they must be loaded into the main AO data structure. 
%  4. This program changes the MML warning level to -2 -> Dialog Box
%     That way the measurement can be salvaged if something goes wrong
%
%  Machine specific setup:
%  1. setquad and getquad must exist for setting and getting the quadrupole current.
%     These function are often machine dependent.
%
%  Written by Greg Portmann
%   30/03/2007 modified Eugene to add BPMDev 



% Extra delay can be written over by the QMS.ExtraDelay field.  If this
% does not exist, then the value below is used.
ExtraDelay = 0; 


% Set the waitflag on power supply setpoints to wait for fresh data from the BPMs
WaitFlag = -2; 


% Record the tune at each point.
% In simulate mode the tunes are always saved unless the TUNE family does not exist.
GetTuneFlag = 0;


% Inputs
QMS1 = [];
QMS2 = [];
if nargin < 1
    FamilyList = getfamilylist;
    [tmp,i] = ismemberof(FamilyList,'QUAD');
    if ~isempty(i)
        FamilyList = FamilyList(i,:);
    end
    if size(FamilyList,1) == 1
        QuadFamily = deblank(FamilyList);
    else
        [i,ok] = listdlg('PromptString', 'Select a quadrupole family:', ...
            'SelectionMode', 'single', ...
            'ListString', FamilyList);
        if ok == 0
            return
        else
            QuadFamily = deblank(FamilyList(i,:));
        end
    end
end

if isstruct(QuadFamily)
    QMS = QuadFamily;
    XYPlane = QMS.QuadPlane;
    if QMS.QuadPlane == 1
        QMS_Horizontal = QMS;
        QMS_Vertical   = quadcenterinit(QMS.QuadFamily, QMS.QuadDev, 2, QMS.BPMDev);
        QMS_Vertical.CorrectOrbit = QMS.CorrectOrbit;
    elseif QMS.QuadPlane == 2
        QMS_Horizontal = quadcenterinit(QMS.QuadFamily, QMS.QuadDev, 1, QMS.BPMDev);
        QMS_Horizontal.CorrectOrbit = QMS.CorrectOrbit;
        QMS_Vertical = QMS;
    else
        error('QMS.QuadPlane must be 1 or 2 when using a QMS structure input');
    end
    if nargin >= 2 
        FigureHandle = QuadDev;
    else
        FigureHandle = [];
    end
    QuadFamily = QMS.QuadFamily;
    QuadDev    = QMS.QuadDev;
else
    if ~isfamily(QuadFamily)
        error(sprintf('Quadrupole family %s does not exist.  Make sure the middle layer had been initialized properly.',QuadFamily));
    end
    if nargin < 2
        QuadDev = editlist(getlist(QuadFamily),QuadFamily,zeros(length(getlist(QuadFamily)),1));
    end
    if nargin < 3
        ButtonNumber = menu('Which Plane?', 'Both','Horizontal Only','Vertical Only','Cancel');  
        drawnow;
        switch ButtonNumber
            case 1
                XYPlane = 0;
            case 2
                XYPlane = 1;
            case 3
                XYPlane = 2;
            otherwise
                fprintf('   quadcenter cancelled\n');
                return
        end
    end
    if nargin < 5 
        FigureHandle = [];
    end
    
    % If QuadDev is a vector
%     if size(QuadDev,1) > 1
%         for i = 1:size(QuadDev,1)
%             if XYPlane == 0
%                 [Q1, Q2] = quadcenter(QuadFamily, QuadDev(i,:), XYPlane, BPMDev(i,:), FigureHandle);
%                 QMS1(i,1) = Q1.Center;
%                 QMS2(i,1) = Q2.Center;
%             else
%                 [Q1] = quadcenter(QuadFamily, QuadDev(i,:), XYPlane, BPMDev(i,:), FigureHandle);
%                 QMS1(i,1) = Q1.Center;
%             end
%         end
%         return
%     end
    
    
    % Get QMS structure
    QMS_Horizontal = quadcenterinit(QuadFamily, QuadDev, 1, BPMDev);
    QMS_Vertical   = quadcenterinit(QuadFamily, QuadDev, 2, BPMDev);
end


% Change the MML warning level to -2 -> Dialog Box
% That way the measurement can be salvaged if something goes wrong
ErrorWarningLevel = getfamilydata('ErrorWarningLevel');
setfamilydata(-2, 'ErrorWarningLevel');


% Initialize variables
HCMFamily  = QMS_Horizontal.CorrFamily;
HCMDev     = QMS_Horizontal.CorrDevList;
DelHCM     = QMS_Horizontal.CorrDelta;
BPMxFamily = QMS_Horizontal.BPMFamily;
BPMxDev    = QMS_Horizontal.BPMDev;
BPMxDevList= QMS_Horizontal.BPMDevList;

VCMFamily  = QMS_Vertical.CorrFamily;
VCMDev     = QMS_Vertical.CorrDevList;
DelVCM     = QMS_Vertical.CorrDelta;
BPMyFamily = QMS_Vertical.BPMFamily;
BPMyDev    = QMS_Vertical.BPMDev;
BPMyDevList= QMS_Vertical.BPMDevList;

Xcenter = NaN;
Ycenter = NaN;


% Check status for BPMs next to the quadrupole and correctors used in orbit correction
HCMStatus = family2status(HCMFamily, HCMDev);

if ~any(isnan(HCMStatus)) && any(HCMStatus==0) 
    error(sprintf('A %s corrector used in finding the center has a bad status', HCMFamily));
end
VCMStatus = family2status(VCMFamily, VCMDev);
if ~any(isnan(VCMStatus)) && any(VCMStatus==0) 
    error(sprintf('A %s corrector used in finding the center has a bad status', VCMFamily));
end
BPMxStatus = family2status(BPMxFamily, BPMxDev);
if ~any(isnan(BPMxStatus)) && any(BPMxStatus==0)
    error(sprintf('The %s monitor next to the quadrupole has bad status', BPMxFamily));
end
BPMyStatus = family2status(BPMxFamily, BPMxDev);
if ~any(isnan(BPMyStatus)) && any(BPMyStatus==0) 
    error(sprintf('The %s monitor next to the quadrupole has bad status', BPMxFamily));
end

    
% Record start directory
DirStart = pwd;


% Get the current offset orbit
Xoffset = getoffset(BPMxFamily, BPMxDev);
Yoffset = getoffset(BPMyFamily, BPMyDev);
XoffsetOld = Xoffset;
YoffsetOld = Yoffset;

% Starting correctors
HCM00 = getsp(HCMFamily, HCMDev);
VCM00 = getsp(VCMFamily, VCMDev);


% % Global orbit correction
% CM = getsp('HCM','struct');
% BPM = getx('struct');
% BPMWeight = ones(size(BPM.DeviceList,1),1);
% i = findrowindex(BPMxDev, BPM.DeviceList);
% 
% x = getoffset('BPMx');
% x = .1 * BPMWeight;
% %x(i) = -.2;
% BPMWeight(i) = 100;
% 
% setorbit(x, BPM, CM, 3, 20, BPMWeight, 'Display');


% Correct orbit to the old offsets first
if strcmpi(QMS_Horizontal.CorrectOrbit, 'yes')
    fprintf('   Correcting the orbit to the old horizontal center of %s(%d,%d)\n', QuadFamily, QuadDev); pause(0);
    if ~isnan(Xoffset)
        OrbitCorrection(Xoffset, BPMxFamily, BPMxDev, HCMFamily, HCMDev, 4);
    end
end
if strcmpi(QMS_Vertical.CorrectOrbit, 'yes')
    fprintf('   Correcting the orbit to the old vertical center of %s(%d,%d)\n', QuadFamily, QuadDev); pause(0);
    if ~isnan(Yoffset)
        OrbitCorrection(Yoffset, BPMyFamily, BPMyDev, VCMFamily, VCMDev, 4);
    end
end

%OrbitCorrection(Xoffset, BPMxFamily, BPMxDev, HCMFamily, HCMDev);
%OrbitCorrection(Yoffset, BPMyFamily, BPMyDev, VCMFamily, VCMDev);



% Algorithm
% 1.  Change the horzontal orbit in the quad
% 2.  Correct the vertical orbit
% 3.  Record the orbit
% 4.  Step the quad
% 5.  Record the orbit


% FIND HORIZONTAL OFFSET
if XYPlane==0 || XYPlane==1    
    FigureHandle = 1;
        
    % BPM processor delay
    if isfield(QMS_Horizontal, 'ExtraDelay') 
        ExtraDelay = QMS_Horizontal.ExtraDelay;
    end

    % Get mode
    Mode = getmode(QMS_Horizontal.QuadFamily);
    
    % Record starting point
    QUAD0 = getquad(QMS_Horizontal);
    HCM0 = getsp(HCMFamily, HCMDev);
    VCM0 = getsp(VCMFamily, VCMDev);
    Xerr = getam(BPMxFamily, BPMxDev) - Xoffset;
    Yerr = getam(BPMyFamily, BPMyDev) - Yoffset;
    xstart = getam(BPMxFamily, BPMxDevList);
    ystart = getam(BPMyFamily, BPMyDevList);

    QMS_Horizontal.Orbit0 = getam(BPMxFamily, BPMxDevList, 'Struct');
    
    [tmp, iNotFound] = findrowindex(BPMxDev, BPMxDevList);
    if ~isempty(iNotFound)
        setsp(HCMFamily, HCM00, HCMDev, 0);
        setsp(VCMFamily, VCM00, VCMDev, 0);
        error('BPM at the quadrupole not found in the BPM device list');
    end
      
    DelQuad = QMS_Horizontal.QuadDelta;
    N = abs(round(QMS_Horizontal.NumberOfPoints));
    if N < 1
        error('The number of points must be 2 or more.');
    end
    
   
    fprintf('   Finding horizontal center of %s(%d,%d)\n', QuadFamily, QuadDev);
    fprintf('   Starting orbit error: %s(%d,%d)=%f , %s(%d,%d)=%f %s\n', BPMxFamily, BPMxDev, Xerr, BPMyFamily, BPMyDev, Yerr, QMS_Horizontal.Orbit0.UnitsString);
    if strcmpi(QMS_Horizontal.ModulationMethod, 'bipolar')
        fprintf('   Quadrupole starting current = %.3f, modulate by +/- %.3f\n', getquad(QMS_Horizontal), DelQuad);
    elseif strcmpi(QMS_Horizontal.ModulationMethod, 'unipolar')
        fprintf('   Quadrupole starting current = %.3f, modulate by 0 to %.3f\n', getquad(QMS_Horizontal), DelQuad);
    elseif strcmpi(QMS_Horizontal.ModulationMethod, 'sweep')
        fprintf('   Quadrupole starting current = %.3f, sweep by %.3f on each step\n', getquad(QMS_Horizontal), DelQuad);        
    else
        % Reset or error
        setsp(HCMFamily, HCM00, HCMDev, 0);
        setsp(VCMFamily, VCM00, VCMDev, 0);
        setquad(QMS_Horizontal, QUAD0, 0);
        cd(DirStart);
        error('Unknown ModulationMethod in the QMS input structure (likely a problem with quadcenterinit)');
    end
    pause(0);
    
    % Establish a hysteresis loop
    if strcmpi(QMS_Horizontal.ModulationMethod, 'bipolar')
        fprintf('   Establishing a hysteresis loop on the quadrupole (bi-polar case)\n'); pause(0);
        setquad(QMS_Horizontal, DelQuad+QUAD0, -1);
        setquad(QMS_Horizontal,-DelQuad+QUAD0, -1);
        setquad(QMS_Horizontal, DelQuad+QUAD0, -1);
        setquad(QMS_Horizontal,-DelQuad+QUAD0, -1);
        setquad(QMS_Horizontal,         QUAD0, -1);
    elseif strcmpi(QMS_Horizontal.ModulationMethod, 'unipolar')
        fprintf('   Establishing a hysteresis loop on the quadrupole (uni-polar case)\n'); pause(0);
        setquad(QMS_Horizontal, DelQuad+QUAD0, -1);
        setquad(QMS_Horizontal,         QUAD0, -1);
        setquad(QMS_Horizontal, DelQuad+QUAD0, -1);
        setquad(QMS_Horizontal,         QUAD0, -1);
    end
    
    
    % Corrector step size
    CorrStep = 2 * DelHCM / (N-1);

    
    % Start the corrector a little lower first for hysteresis reasons 
    %stepsp(HCMFamily, -1.0*DelHCM, HCMDev, -1);
    stepsp(HCMFamily, -1.2*DelHCM, HCMDev, -1);
    stepsp(HCMFamily,   .2*DelHCM, HCMDev, WaitFlag); 

    
    % Main horizontal data loop
    clear DCCT
    for i = 1:N
        % Step the horizontal orbit
        if i ~= 1
            stepsp(HCMFamily, CorrStep, HCMDev, WaitFlag);
        end
        
        fprintf('   %d. %s(%d,%d) sp/am = %+.4f/%+.4f, %s(%d,%d) = %+.5f %s\n', i, HCMFamily, HCMDev(1,:), getsp(HCMFamily, HCMDev(1,:)), getam(HCMFamily, HCMDev(1,:)),  BPMxFamily, BPMxDev, getam(BPMxFamily, BPMxDev), QMS_Horizontal.Orbit0.UnitsString); pause(0);  
        
        % If correcting the orbit, then recorrect the vertical center now
        if strcmpi(QMS_Horizontal.CorrectOrbit, 'yes')
           % Correct the vertical orbit
           OrbitCorrection(Yoffset, BPMyFamily, BPMyDev, VCMFamily, VCMDev, 4);
        end
        
        if strcmpi(QMS_Horizontal.ModulationMethod, 'sweep')
            % One directional sweep of the quadrupole
            sleep(ExtraDelay);
            x1(:,i) = getam(BPMxFamily, BPMxDevList);
            y1(:,i) = getam(BPMyFamily, BPMyDevList);
            x0(:,i) = x1(:,i);
            y0(:,i) = y1(:,i);
           
            if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
                QMS_Horizontal.Tune1(:,i) = gettune;
            end

            setquad(QMS_Horizontal, i*DelQuad+QUAD0, WaitFlag);
            sleep(ExtraDelay);

            % If correcting the orbit, then recorrect the horizontal center now
            if strcmpi(QMS_Horizontal.CorrectOrbit, 'yes')
                % Correct the vertical orbit
                OrbitCorrection(Yoffset, BPMyFamily, BPMyDev, VCMFamily, VCMDev, 4);
                sleep(ExtraDelay);
            end

            x2(:,i) = getam(BPMxFamily, BPMxDevList);
            y2(:,i) = getam(BPMyFamily, BPMyDevList);
            
            if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
                QMS_Horizontal.Tune2(:,i) = gettune;
            end
   
        elseif strcmpi(QMS_Horizontal.ModulationMethod, 'bipolar')
            % Modulate the quadrupole
            sleep(ExtraDelay);
            x0(:,i) = getam(BPMxFamily, BPMxDevList);
            y0(:,i) = getam(BPMyFamily, BPMyDevList);
            setquad(QMS_Horizontal, DelQuad+QUAD0, WaitFlag);
            sleep(ExtraDelay);

            % If correcting the orbit, then recorrect the horizontal center now
            if strcmpi(QMS_Horizontal.CorrectOrbit, 'yes')
                % Correct the vertical orbit
                OrbitCorrection(Yoffset, BPMyFamily, BPMyDev, VCMFamily, VCMDev, 4);
                sleep(ExtraDelay);
            end

            x1(:,i) = getam(BPMxFamily, BPMxDevList);
            y1(:,i) = getam(BPMyFamily, BPMyDevList);
            
            if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
                QMS_Horizontal.Tune1(:,i) = gettune;
            end

            setquad(QMS_Horizontal,-DelQuad+QUAD0, WaitFlag);
            sleep(ExtraDelay);

            % If correcting the orbit, then recorrect the horizontal center now
            if strcmpi(QMS_Horizontal.CorrectOrbit, 'yes')
                % Correct the vertical orbit
                OrbitCorrection(Yoffset, BPMyFamily, BPMyDev, VCMFamily, VCMDev, 4);
                sleep(ExtraDelay);
            end

            x2(:,i) = getam(BPMxFamily, BPMxDevList);
            y2(:,i) = getam(BPMyFamily, BPMyDevList);
            
            if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
                QMS_Horizontal.Tune2(:,i) = gettune;
            end

            setquad(QMS_Horizontal, QUAD0, WaitFlag);
        
        elseif strcmpi(QMS_Horizontal.ModulationMethod, 'unipolar')
            % Modulate the quadrupole
            sleep(ExtraDelay);
            x1(:,i) = getam(BPMxFamily, BPMxDevList);
            y1(:,i) = getam(BPMyFamily, BPMyDevList);
            x0(:,i) = x1(:,i);
            y0(:,i) = y1(:,i);
            
            if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
                QMS_Horizontal.Tune1(:,i) = gettune;
            end

            setquad(QMS_Horizontal, DelQuad+QUAD0, WaitFlag);
            sleep(ExtraDelay);

            % If correcting the orbit, then recorrect the horizontal center now
            if strcmpi(QMS_Horizontal.CorrectOrbit, 'yes')
                % Correct the vertical orbit
                OrbitCorrection(Yoffset, BPMyFamily, BPMyDev, VCMFamily, VCMDev, 4);
                sleep(ExtraDelay);
            end

            x2(:,i) = getam(BPMxFamily, BPMxDevList);
            y2(:,i) = getam(BPMyFamily, BPMyDevList);
            
            if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
                QMS_Horizontal.Tune2(:,i) = gettune;
            end

            setquad(QMS_Horizontal, QUAD0, WaitFlag);
        end

        DCCT(i) = getdcct;
    end

    % Get the horizontal data filename and save the data
    % Append data and time
    FileName = ['s', num2str(QuadDev(1,1)), QuadFamily, num2str(QuadDev(1,2)), 'h1'];
    FileName = appendtimestamp(FileName, clock);

    % Use a version number
    %i=1;
    %FileName = ['s', num2str(QuadDev(1,1)), QuadFamily, num2str(QuadDev(1,2)), 'h', num2str(i)];
    %while exist([FileName,'.mat'], 'file')
    %    i = i + 1;
    %    FileName = ['s', num2str(QuadDev(1,1)), QuadFamily, num2str(QuadDev(1,2)), 'h', num2str(i)];
    %end
    
    QMS = QMS_Horizontal;
    QMS.QuadPlane = 1;
    
    QMS.OldCenter = Xoffset;
    QMS.XOffsetOld = XoffsetOld;
    QMS.YOffsetOld = YoffsetOld;
    
    QMS.xstart = xstart;
    QMS.ystart = ystart;
    
    QMS.x0 = x0;
    QMS.x1 = x1;
    QMS.x2 = x2;
    QMS.y0 = y0;
    QMS.y1 = y1;
    QMS.y2 = y2;
    QMS.Xerr = Xerr;
    QMS.Yerr = Yerr;
    QMS.TimeStamp = clock;
    QMS.DCCT = DCCT;
    QMS.DataDescriptor = 'Quadrupole Center';
    QMS.CreatedBy = 'quadcenter';
    
    % Get and store the BPM status and standard deviation (to be used by the center calculation routine)
    QMS.BPMStatus = family2status(BPMxFamily, BPMxDevList);
    N = getbpmaverages(BPMxDevList);
    QMS.BPMSTD = getsigma(BPMxFamily, BPMxDevList, N);

    % Set up figures, plot and find horizontal center
    try
        if isempty(FigureHandle)
            QMS = quadplot(QMS);
        else
            QMS = quadplot(QMS, FigureHandle);
        end
        drawnow;
    catch
        fprintf('\n%s\n', lasterr);
    end
    QMS1 = QMS;

    % Save the horizontal data
    if isfield(QMS_Horizontal, 'DataDirectory')
        [FinalDir, ErrorFlag] = gotodirectory(QMS_Horizontal.DataDirectory);
    end
    QMS.DataDirectory = pwd;
    save(FileName, 'QMS');
    fprintf('   Data saved to file %s in directory %s\n\n', FileName, QMS.DataDirectory);

    % Output data to file
    fid1 = fopen('quadcenter.log','at');
    time=clock;
    fprintf(fid1, '%s   %d:%d:%2.0f \n', date, time(4),time(5),time(6));
    fprintf(fid1, 'Data saved to file %s (%s)\n', FileName, QMS.DataDirectory);
    fprintf(fid1, '%s(%d,%d) %s(%d,%d) = %f (+/- %f) [%s]\n\n', QuadFamily, QuadDev, BPMxFamily, BPMxDev, QMS.Center, QMS.CenterSTD, QMS_Horizontal.Orbit0.UnitsString);
    fclose(fid1);
    cd(DirStart);

    % Change the offset orbit to the new center so that the vertical plane uses it
    Xoffset = QMS.Center;
    
    % Restore magnets their starting points (correctors to values after orbit correction)
    setsp(HCMFamily, HCM0, HCMDev, WaitFlag);
    setsp(VCMFamily, VCM0, VCMDev, WaitFlag);
    setquad(QMS_Horizontal, QUAD0, WaitFlag);
    
    if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
        % Print the tune information
        fprintf('   Tune and tune difference for the 1st points in the merit function (QMS.Tune1): \n');
        fprintf('   %8.5f', QMS.Tune1(1,:));
        fprintf('  Horizontal\n');
        fprintf('   %8.5f', QMS.Tune1(2,:));
        fprintf('  Vertical\n');
        fprintf('   ===================================================\n');
        fprintf('   %8.5f', diff(QMS.Tune1));
        fprintf('  Difference \n\n');
        
        fprintf('   Tune and tune difference for the 2nd points in the merit function (QMS.Tune2): \n');
        fprintf('   %8.5f', QMS.Tune2(1,:));
        fprintf('  Horizontal\n');
        fprintf('   %8.5f', QMS.Tune2(2,:));
        fprintf('  Vertical\n');
        fprintf('   ===================================================\n');
        fprintf('   %8.5f', diff(QMS.Tune2));
        fprintf('  Difference\n\n');

        dTune1 = diff(QMS.Tune1);
        dTune2 = diff(QMS.Tune2);
        
        if any(sign(dTune1/dTune1(1))==-1)
            fprintf('   Tune change sign!!!\n');            
        end
        
        if any(abs(dTune1) < .025) || any(abs(dTune2) < .025)
            fprintf('   Horizontal and vertical tunes seem too close.\n');
        end
    end    
end



% FIND VERTICAL OFFSET
if XYPlane==0 || XYPlane==2    
    FigureHandle = 1;

    % BPM processor delay
    if isfield(QMS_Vertical, 'ExtraDelay')
        ExtraDelay = QMS_Vertical.ExtraDelay;
    end

    % Get mode
    Mode = getmode(QMS_Horizontal.QuadFamily);
    
    % Record starting point
    QUAD0 = getquad(QMS_Vertical);
    HCM0 = getsp(HCMFamily, HCMDev);
    VCM0 = getsp(VCMFamily, VCMDev);
    Xerr = getam(BPMxFamily, BPMxDev) - Xoffset;
    Yerr = getam(BPMyFamily, BPMyDev) - Yoffset;
    xstart = getam(BPMxFamily, BPMxDevList);
    ystart = getam(BPMyFamily, BPMyDevList);
    
    QMS_Vertical.Orbit0 = getam(BPMxFamily, BPMxDevList, 'Struct');

    [tmp, iNotFound] = findrowindex(BPMyDev, BPMyDevList);
    if ~isempty(iNotFound)
        setsp(HCMFamily, HCM00, HCMDev, 0);
        setsp(VCMFamily, VCM00, VCMDev, 0);
        error('BPM at the quadrupole not found in the BPM device list');
    end

    DelQuad = QMS_Vertical.QuadDelta;
    N = abs(round(QMS_Vertical.NumberOfPoints));
    if N < 1
        error('The number of points must be 2 or more.');
    end

    fprintf('   Finding vertical center of %s(%d,%d)\n', QuadFamily, QuadDev);
    fprintf('   Starting orbit error: %s(%d,%d)=%f , %s(%d,%d)=%f %s\n', BPMxFamily, BPMxDev, Xerr, BPMyFamily, BPMyDev, Yerr, QMS_Vertical.Orbit0.UnitsString);
    if strcmpi(QMS_Vertical.ModulationMethod, 'bipolar')
        fprintf('   Quadrupole starting current = %.3f, modulate by +/- %.3f\n', getquad(QMS_Vertical), DelQuad);
    elseif strcmpi(QMS_Vertical.ModulationMethod, 'unipolar')
        fprintf('   Quadrupole starting current = %.3f, modulate by 0 to %.3f\n', getquad(QMS_Vertical), DelQuad);
    elseif strcmpi(QMS_Vertical.ModulationMethod, 'sweep')
        fprintf('   Quadrupole starting current = %.3f, sweep by %.3f on each step\n', getquad(QMS_Vertical), DelQuad);
    else
        setsp(HCMFamily, HCM00, HCMDev, 0);
        setsp(VCMFamily, VCM00, VCMDev, 0);
        setquad(QMS_Vertical, QUAD0, 0);
        cd(DirStart);
        error('Unknown ModulationMethod in the QMS input structure (likely a problem with quadcenterinit)');
    end
    pause(0);
    
    
    % Establish a hysteresis loop (if not already done, or if the horizontal plane was sweep)
    if XYPlane == 2 || strcmpi(QMS_Horizontal.ModulationMethod, 'sweep')
        if strcmpi(QMS_Vertical.ModulationMethod, 'bipolar')
            fprintf('   Establishing a hysteresis loop on the quadrupole (bi-polar case)\n'); pause(0);
            setquad(QMS_Vertical, DelQuad+QUAD0, -1);
            setquad(QMS_Vertical,-DelQuad+QUAD0, -1);
            setquad(QMS_Vertical, DelQuad+QUAD0, -1);
            setquad(QMS_Vertical,-DelQuad+QUAD0, -1);
            setquad(QMS_Vertical,         QUAD0, -1);
        elseif strcmpi(QMS_Vertical.ModulationMethod, 'unipolar')
            fprintf('   Establishing a hysteresis loop on the quadrupole (uni-polar case)\n'); pause(0);
            setquad(QMS_Vertical, DelQuad+QUAD0, -1);
            setquad(QMS_Vertical,         QUAD0, -1);
            setquad(QMS_Vertical, DelQuad+QUAD0, -1);
            setquad(QMS_Vertical,         QUAD0, -1);
        end
    end
    

    % Corrector step size
    CorrStep = 2 * DelVCM / (N-1);

    
    % Start the corrector a little lower first for hysteresis reasons 
    stepsp(VCMFamily, -1.2*DelVCM, VCMDev, -1);
    stepsp(VCMFamily,   .2*DelVCM, VCMDev, WaitFlag);


%     Debug
%     setquad(QMS_Vertical, DelQuad+QUAD0, WaitFlag);
%     QUAD0 = getquad(QMS_Vertical);
%     Xstart = getam(BPMxFamily, BPMxDev)
    

    clear DCCT
    for i = 1:N

        % Step the vertical orbit
        if i ~= 1
            stepsp(VCMFamily, CorrStep, VCMDev, WaitFlag);
        end

        fprintf('   %d. %s(%d,%d) sp/am = %+.4f/%+.4f, %s(%d,%d) = %+.5f %s\n', i, VCMFamily, VCMDev(1,:), getsp(VCMFamily, VCMDev(1,:)), getam(VCMFamily, VCMDev(1,:)),  BPMyFamily, BPMyDev, getam(BPMyFamily, BPMyDev), QMS_Vertical.Orbit0.UnitsString); pause(0);
        
        
        % If correcting the orbit, then recorrect the horizontal center now
        if strcmpi(QMS_Vertical.CorrectOrbit, 'yes')
           % Correct the horizontal orbit
           OrbitCorrection(Xoffset, BPMxFamily, BPMxDev, HCMFamily, HCMDev, 4);
        end

               
        if strcmpi(QMS_Vertical.ModulationMethod, 'sweep')
            % One dimensional sweep of the quadrupole
            sleep(ExtraDelay);
            x1(:,i) = getam(BPMxFamily, BPMxDevList);
            y1(:,i) = getam(BPMyFamily, BPMyDevList);
            x0(:,i) = x1(:,i);
            y0(:,i) = y1(:,i);
            
            if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
                QMS_Vertical.Tune1(:,i) = gettune;
            end

            setquad(QMS_Vertical, i*DelQuad+QUAD0, WaitFlag);
            sleep(ExtraDelay);

            % If correcting the orbit, then recorrect the horizontal center now
            if strcmpi(QMS_Vertical.CorrectOrbit, 'yes')
                % Correct the horizontal orbit
                OrbitCorrection(Xoffset, BPMxFamily, BPMxDev, HCMFamily, HCMDev, 4);
                sleep(ExtraDelay);
            end

            x2(:,i) = getam(BPMxFamily, BPMxDevList);
            y2(:,i) = getam(BPMyFamily, BPMyDevList);
            
            if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
                QMS_Vertical.Tune2(:,i) = gettune;
            end

        elseif strcmpi(QMS_Vertical.ModulationMethod, 'bipolar')
            % Modulate the quadrupole
            sleep(ExtraDelay);
            x0(:,i) = getam(BPMxFamily, BPMxDevList);
            y0(:,i) = getam(BPMyFamily, BPMyDevList);
            setquad(QMS_Vertical, DelQuad+QUAD0, WaitFlag);
            sleep(ExtraDelay);

            % If correcting the orbit, then recorrect the horizontal center now
            if strcmpi(QMS_Vertical.CorrectOrbit, 'yes')
                % Correct the horizontal orbit
                OrbitCorrection(Xoffset, BPMxFamily, BPMxDev, HCMFamily, HCMDev, 4);
                sleep(ExtraDelay);
            end

            x1(:,i) = getam(BPMxFamily, BPMxDevList);
            y1(:,i) = getam(BPMyFamily, BPMyDevList);
            
            if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
                QMS_Vertical.Tune1(:,i) = gettune;
            end

            setquad(QMS_Vertical,-DelQuad+QUAD0, WaitFlag);
            sleep(ExtraDelay);

            % If correcting the orbit, then recorrect the horizontal center now
            if strcmpi(QMS_Vertical.CorrectOrbit, 'yes')
                % Correct the horizontal orbit
                OrbitCorrection(Xoffset, BPMxFamily, BPMxDev, HCMFamily, HCMDev, 4);
                sleep(ExtraDelay);
            end

            x2(:,i) = getam(BPMxFamily, BPMxDevList);
            y2(:,i) = getam(BPMyFamily, BPMyDevList);
            
            if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
                QMS_Vertical.Tune2(:,i) = gettune;
            end

            setquad(QMS_Vertical, QUAD0, WaitFlag);
            
        elseif strcmpi(QMS_Vertical.ModulationMethod, 'unipolar')
            % Modulate the quadrupole
            sleep(ExtraDelay);
            x1(:,i) = getam(BPMxFamily, BPMxDevList);
            y1(:,i) = getam(BPMyFamily, BPMyDevList);
            x0(:,i) = x1(:,i);
            y0(:,i) = y1(:,i);
            
            if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
                QMS_Vertical.Tune1(:,i) = gettune;
            end

            setquad(QMS_Vertical, DelQuad+QUAD0, WaitFlag);
            sleep(ExtraDelay);

            % If correcting the orbit, then recorrect the horizontal center now
            if strcmpi(QMS_Vertical.CorrectOrbit, 'yes')
                % Correct the horizontal orbit
                OrbitCorrection(Xoffset, BPMxFamily, BPMxDev, HCMFamily, HCMDev, 4);
                sleep(ExtraDelay);
            end

            x2(:,i) = getam(BPMxFamily, BPMxDevList);
            y2(:,i) = getam(BPMyFamily, BPMyDevList);
            
            if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
                QMS_Vertical.Tune2(:,i) = gettune;
            end

            setquad(QMS_Vertical, QUAD0, WaitFlag);
        end
        
        DCCT(i) = getdcct;
    end

    setsp(VCMFamily, VCM0, VCMDev, -1);

    
    % Get the vertical data filename and save the data
    % Append data and time
    FileName = ['s', num2str(QuadDev(1,1)), QuadFamily, num2str(QuadDev(1,2)), 'v1'];
    FileName = appendtimestamp(FileName, clock);

    %% Append version number
    %i=1;
    %FileName = ['s', num2str(QuadDev(1,1)), QuadFamily, num2str(QuadDev(1,2)), 'v', num2str(i)];
    %while exist([FileName,'.mat'], 'file')
    %    i = i + 1;
    %    FileName = ['s', num2str(QuadDev(1,1)), QuadFamily, num2str(QuadDev(1,2)), 'v', num2str(i)];
    %end

    QMS = QMS_Vertical;
    QMS.QuadPlane = 2;

    QMS.OldCenter = Yoffset;
    QMS.XOffsetOld = XoffsetOld;
    QMS.YOffsetOld = YoffsetOld;
    
    QMS.xstart = xstart;
    QMS.ystart = ystart;
    QMS.x0 = x0;
    QMS.x1 = x1;
    QMS.x2 = x2;
    QMS.y0 = y0;
    QMS.y1 = y1;
    QMS.y2 = y2;
    QMS.Xerr = Xerr;
    QMS.Yerr = Yerr;
    QMS.TimeStamp = clock;
    QMS.DCCT = DCCT;
    QMS.DataDescriptor = 'Quadrupole Center';
    QMS.CreatedBy = 'quadcenter';

    % Get and store the BPM status and standard deviation (to be used by the center calculation routine)
    QMS.BPMStatus = family2status(BPMyFamily, BPMyDevList);
    N = getbpmaverages(BPMyDevList);
    QMS.BPMSTD = getsigma(BPMyFamily, BPMyDevList, N);

    
    % Set up figures, plot and find vertical center
    if isempty(FigureHandle)
        QMS = quadplot(QMS);
    else
        QMS = quadplot(QMS, FigureHandle);
    end
    drawnow;

    if XYPlane==0
        QMS2 = QMS;
    else
        QMS1 = QMS;
    end
    
    
    % Save the vertical data 
    if isfield(QMS_Vertical,'DataDirectory')  
        [FinalDir, ErrorFlag] = gotodirectory(QMS_Vertical.DataDirectory);
    end
    QMS.DataDirectory = pwd;    
    save(FileName, 'QMS');
    fprintf('   Data saved to file %s in directory %s\n\n', FileName, QMS.DataDirectory);
    
    % Output data to log file
    fid1 = fopen('quadcenter.log','at');
    time=clock;
    fprintf(fid1, '%s   %d:%d:%2.0f \n', date, time(4),time(5),time(6));
    fprintf(fid1, 'Data saved to file %s (%s)\n', FileName, QMS.DataDirectory);
    fprintf(fid1, '%s(%d,%d) %s(%d,%d) = %f (+/- %f) [%s]\n\n', QuadFamily, QuadDev, BPMyFamily, BPMyDev, QMS.Center, QMS.CenterSTD);
    fclose(fid1);
    cd(DirStart);

    if (GetTuneFlag || strcmpi(Mode, 'Simulator')) && isfamily('TUNE')
        % Print the tune information
        fprintf('   Tune and tune difference for the 1st points in the merit function (QMS.Tune1): \n');
        fprintf('   %8.5f', QMS.Tune1(1,:));
        fprintf('  Horizontal\n');
        fprintf('   %8.5f', QMS.Tune1(2,:));
        fprintf('  Vertical\n');
        fprintf('   ===================================================\n');
        fprintf('   %8.5f', diff(QMS.Tune1));
        fprintf('  Difference \n\n');
        
        fprintf('   Tune and tune difference for the 2nd points in the merit function (QMS.Tune2): \n');
        fprintf('   %8.5f', QMS.Tune2(1,:));
        fprintf('  Horizontal\n');
        fprintf('   %8.5f', QMS.Tune2(2,:));
        fprintf('  Vertical\n');
        fprintf('   ===================================================\n');
        fprintf('   %8.5f', diff(QMS.Tune2));
        fprintf('  Difference\n\n');

        dTune1 = diff(QMS.Tune1);
        dTune2 = diff(QMS.Tune2);
        
        if any(sign(dTune1/dTune1(1))==-1)
            fprintf('   Tune change sign!!!\n');            
        end
        
        if any(abs(dTune1) < .025) || any(abs(dTune2) < .025)
            fprintf('   Horizontal and vertical tunes seem too close.\n');
        end
    end
end


% Restore magnets their starting points
setsp(HCMFamily, HCM00, HCMDev, 0);
setsp(VCMFamily, VCM00, VCMDev, 0);
setquad(QMS_Horizontal, QUAD0, 0);


% Restore the MML error warning level
setfamilydata(ErrorWarningLevel, 'ErrorWarningLevel');


%%%%%%%%%%%%%%%%%%%%%
% End Main Function %
%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%
% Sub-Functions %
%%%%%%%%%%%%%%%%%

function OrbitCorrection(GoalOrbit, BPMFamily, BPMDevList, CMFamily, CMDevList, Iter)

WaitFlag = -2;

if nargin < 6
    Iter = 3;
end

if size(CMDevList,1) > 1
    % Pick the corrector based on the most effective corrector in the response matrix
    % This routine does not handle local bumps at the moment
    R = getrespmat(BPMFamily, BPMDevList, CMFamily, [], 'Struct', 'Physics');
    [i, iNotFound] = findrowindex(BPMDevList, R.Monitor.DeviceList);
    m = R.Data(i,:);
    [MaxValue, j] = max(abs(m));
    CMDevList = R.Actuator.DeviceList(j,:);
end

s = getrespmat(BPMFamily, BPMDevList, CMFamily, CMDevList);
if any(any(isnan(s)))
    error('Response matrix has a NaN');
end


for i = 1:Iter
    x = getam(BPMFamily, BPMDevList) - GoalOrbit;
    
    CorrectorSP = -(x./s);
    CorrectorSP = CorrectorSP(:);
    
    % Check limits
    MinSP = minsp(CMFamily, CMDevList);
    MaxSP = maxsp(CMFamily, CMDevList);
    if any(getsp(CMFamily,CMDevList)+CorrectorSP > MaxSP-5) 
        fprintf('   Orbit not corrected because a maximum power supply limit would have been exceeded!\n');
        return;
    end
    if any(getsp(CMFamily,CMDevList)+CorrectorSP < MinSP+5) 
        fprintf('   Orbit not corrected because a minimum power supply limit would have been exceeded!\n');
        return;
    end
    
    stepsp(CMFamily, CorrectorSP, CMDevList, WaitFlag);
    
    %x = getam(BPMFamily, BPMDevList) - GoalOrbit
end




% function AM = getquad(QMS)
% % AM = getquad(QMS)
% 
% QuadFamily = QMS.QuadFamily;
% QuadDev = QMS.QuadDev;
% 
% % Check operational mode
% %mode = getfamilydata(QuadFamily, 'Setpoint', 'Mode', QuadDev);
% 
% AM = getam(QuadFamily, QuadDev);


% function setquad(QMS, QuadSetpoint, WaitFlag)
% % setquad(QMS, QuadSetpoint, WaitFlag)
%     
% if nargin < 3
%     WaitFlag = -2;
% end
% 
% QuadFamily = QMS.QuadFamily;
% QuadDev = QMS.QuadDev;
% 
% setsp(QuadFamily, QuadSetpoint, QuadDev, WaitFlag); 



