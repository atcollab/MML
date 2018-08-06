function [QMS, WarningString] = quadplot(Input1, FigureHandle, sigmaBPM)
%QUADPLOT - Plots quadrupole centering data
%  [QMS, WarningString] = quadplot(Input1, Handle, sigmaBPM)
%
%  INPUTS
%  1. Input1 can be a filename for the data or a QMS structure (see help quadcenter for details).
%     If empty or zero inputs, then a dialog box will be provided to select a file.
%  2. Handle can be a figure handle or a vector of 4 axes handles 
%     If Handle=0, no results are plotted
%  3. Standard deviation of the BPMs (scalar if all BPMs are the same) 
%     These should be in the data file, but this provides an override if not
%     found then the default is inf (ie, not used).
%
%  OUTPUTS
%  1. For details of the QMS data structure see help quadcenter
%     This function added:
%     QMS.Offset - Offset computed at each BPM
%     QMS.FitParameters - Fit parameter at each BPM
%     QMS.FitParametersStd - Sigma of the fit parameter at each BPM
%     QMS.BPMStd - BPM sigma at each BPM
%     QMS.OffsetSTDMontiCarlo - Monti Carlo estimate of the sigma of the offset (optional)
%
%  2. WarningString = string with warning message if you occurred

%  Written by Greg Portmann


% To Do:
% 1. It wouldn't be to difficult to added a LS weight based on slope or even the ideal weighting of std(center).
%    I haven't done it yet because the BPM errors are usually roughly equal at most accelerators.


% Remove BPM gain and roll before finding the center
ModelCoordinates = 0;

% Figure setup
Buffer = .03;
HeightBuffer = .08;


% Remove BPM if it's slope less than MinSlopeFraction * (the maximum slope)
MinSlopeFraction = .25;

% # of STD of the center calculation allowed
CenterOutlierFactor = 1;


QMS = [];
WarningString = '';


% Inputs
try
    if nargin == 0
        [FileName, PathName] = uigetfile('*.mat', 'Select a Quadrupole Center File', [getfamilydata('Directory','DataRoot'), 'QMS', filesep]);
        if ~isstr(FileName)
            return
        else
            load([PathName,FileName]);
        end
    else
        if isempty(Input1) || (ischar(Input1) && strcmp(Input1, '.'))
            [FileName, PathName] = uigetfile('*.mat', 'Select a Quadrupole Center File');
            %[FileName, PathName] = uigetfile('*.mat', 'Select a Quadrupole Center File', [getfamilydata('Directory','DataRoot'), 'QMS', filesep]);
            if ~isstr(FileName)
                return
            else
                load([PathName,FileName]);
            end
        elseif isstr(Input1)
            FileName = Input1;
            load(FileName);
        else
            QMS = Input1;
            FileName = [];
        end
    end
catch
    error('Problem getting input data');
end
if nargin < 2
    FigureHandle = [];
end

[BPMelem1, iNotFound] = findrowindex(QMS.BPMDev, QMS.BPMDevList);
if ~isempty(iNotFound)
    error('BPM at the quadrupole not found in the BPM device list');
end

QuadraticFit = QMS.QuadraticFit;       % 0 = linear fit, else quadratic fit
OutlierFactor = QMS.OutlierFactor;     % if abs(data - fit) > OutlierFactor, then remove that BPM


% Get BPM standard deviation
if nargin < 3
    % Get from the data file
    if isfield(QMS, 'BPMSTD')
        sigmaBPM = QMS.BPMSTD;
    else
        sigmaBPM = inf;
    end
end
if isempty(sigmaBPM)
    sigmaBPM = inf;
end
if any(isnan(sigmaBPM)) || any(isinf(sigmaBPM))
    sigmaBPM = inf;
    fprintf('   WARNING: BPM standard deviation is unknown, hence there is no BPM outlier condition.\n');
end
sigmaBPM = sigmaBPM(:);
QMS.BPMSTD = sigmaBPM;


% Get figure handle
if all(FigureHandle ~= 0) 
    if isempty(FigureHandle)
        FigureHandle = figure;
        clf reset
        AxesHandles(1) = subplot(4,1,1);
        AxesHandles(2) = subplot(4,1,2);
        AxesHandles(3) = subplot(4,1,3);
        AxesHandles(4) = subplot(4,1,4);    
    else
        if length(FigureHandle) == 1
            FigureHandle = figure(FigureHandle);
            clf reset
            AxesHandles(1) = subplot(4,1,1);
            AxesHandles(2) = subplot(4,1,2);
            AxesHandles(3) = subplot(4,1,3);
            AxesHandles(4) = subplot(4,1,4);    
        elseif length(FigureHandle) == 4
            FigureHandle = figure;
            clf reset
            AxesHandles = FigureHandle;
        else
            error('Improper size of input FigureHandle');
        end
    end
end



% Change the coordinates to model X & Y
if ModelCoordinates
    fprintf('   Changing to model coordinates (the final center should be "rotated" back to the raw BPM coordinates).\n');
    Gx  = getgain('BPMx', QMS.BPMDevList);   % Unfortunately I don't have both families in the QMS structure???
    Gy  = getgain('BPMy', QMS.BPMDevList);
    Crunch = getcrunch(QMS.BPMFamily, QMS.BPMDevList);
    Roll   = getroll(QMS.BPMFamily, QMS.BPMDevList);
    
    for i = 1:length(Gx)
        M = gcr2loco(Gx(i), Gy(i), Crunch(i), Roll(i));
        invM = inv(M);
        
        tmp = invM * [QMS.x0(i,:); QMS.y0(i,:)];
        QMS.x0(i,:) = tmp(1,:);
        QMS.y0(i,:) = tmp(2,:);
        
        tmp = invM * [QMS.x1(i,:); QMS.y1(i,:)];
        QMS.x1(i,:) = tmp(1,:);
        QMS.y1(i,:) = tmp(2,:);
        
        tmp = invM * [QMS.x2(i,:); QMS.y2(i,:)];
        QMS.x2(i,:) = tmp(1,:);
        QMS.y2(i,:) = tmp(2,:);
        
        tmp = invM * [QMS.xstart(i,:); QMS.ystart(i,:)];
        QMS.xstart(i,:) = tmp(1,:);
        QMS.ystart(i,:) = tmp(2,:);
    end
end


% Select the x or y plane
if QMS.QuadPlane == 1    
    x0 = QMS.x0;
    x1 = QMS.x1;
    x2 = QMS.x2;

    % Plot setup
 %   if all(FigureHandle ~= 0) 
 %       set(FigureHandle,'units','normal','position',[Buffer .25+Buffer .5-Buffer-.003 .75-1.2*Buffer-HeightBuffer]);
 %   end
else
    x0 = QMS.y0;
    x1 = QMS.y1;
    x2 = QMS.y2;
        
    % Plot setup
 %   if all(FigureHandle ~= 0) 
 %       set(FigureHandle,'units','normal','position',[.503 .25+Buffer .5-Buffer-.003 .75-1.2*Buffer-HeightBuffer]);
 %   end
end


% % Change the number of points
% if strcmpi(QMS.ModulationMethod, 'Sweep')
%     %Ndiv2 = floor(size(x1,2)/2);
%     %Npoint1 = Ndiv2;
%     %Npoint2 = Ndiv2+2;
%     %x1 = x1(:,Npoint1:Npoint2);
%     %x2 = x2(:,Npoint1:Npoint2);
%     %y1 = y1(:,Npoint1:Npoint2);
%     %y2 = y2(:,Npoint1:Npoint2);
%     %N = size(x1,2);
%     %Ndiv2 = floor(size(x1,2)/2);
%     
%     Npoint1 = 2;
%     Npoint2 = size(QMS.x1, 2);
%     x0 = x0(:,Npoint1:Npoint2);
%     x1 = x1(:,Npoint1:Npoint2);
%     x2 = x2(:,Npoint1:Npoint2);
%     fprintf('  Using %d points (%d to %d, total %d) (%s method).', Npoint2-Npoint1+1, Npoint1, Npoint2, size(QMS.x1,2), QMS.ModulationMethod) ;  
% end


% Expand sigmaBPM is necessary
if length(sigmaBPM) == 1
    sigmaBPM = ones(size(x1,1),1) * sigmaBPM;
end

N = size(x1,2);


% 
% QUAD0 = getquad(QMS, 'Model');
% CM0 = getsp(QMS.CorrFamily, QMS.CorrDevList, 'Model');
% 
% 
% % Start the corrector a little lower first for hysteresis reasons
% CorrStep = 2 * QMS.CorrDelta / (N-1);
% stepsp(QMS.CorrFamily, -QMS.CorrDelta, QMS.CorrDevList, -1, 'Model');
%   
% %XstartModel = getam(BPMxFamily, BPMxDev)
% for i = 1:N
%     % Step the vertical orbit
%     if i ~= 1
%         stepsp(QMS.CorrFamily, CorrStep, QMS.CorrDevList, -1, 'Model');
%     end
% 
% %    fprintf('   %d. %s(%d,%d) = %+5.2f, %s(%d,%d) = %+.5f %s\n', i, QMS.CorrFamily, QMS.CorrDevList(1,:), getsp(QMS.CorrFamily, QMS.CorrDevList(1,:),'Model'),  BPMyFamily, BPMyDev, getam(BPMyFamily, BPMyDev,'Model'), QMS_Vertical.Orbit0.UnitsString); pause(0);
% 
%     %OrbitCorrection(XstartModel, BPMxFamily, BPMxDev, HCMFamily, HCMDev, 2, 'Model');
% 
%     if strcmpi(lower(QMS.ModulationMethod), 'sweep')
%         % One dimensional sweep of the quadrupole
%         xm1(:,i) = getam(QMS.BPMFamily, QMS.BPMDev, 'Model');
%         xm0(:,i) = xm1(:,i);
%         setquad(QMS, i*QMS.QuadDelta+QUAD0, -1, 'Model');
%         xm2(:,i) = getam(QMS.BPMFamily, QMS.BPMDevList, 'Model');
%     elseif strcmpi(lower(QMS.ModulationMethod), 'bipolar')
%         % Modulate the quadrupole
%         xm0(:,i) = getam(QMS.BPMFamily, QMS.BPMDev, 'Model');
%         [xq0(:,i), yq0(:,i)] = modeltwiss('x', QMS.QuadFamily, QMS.QuadDev);
%         
%         setquad(QMS, QMS.QuadDelta+QUAD0, -1, 'Model');
%         xm1(:,i) = getam(QMS.BPMFamily, QMS.BPMDev, 'Model');
%         [xq1(:,i), yq1(:,i)] = modeltwiss('x', QMS.QuadFamily, QMS.QuadDev);
% 
%         
%         setquad(QMS,-QMS.QuadDelta+QUAD0, -1, 'Model');
%         xm2(:,i) = getam(QMS.BPMFamily, QMS.BPMDev, 'Model');
%         [xq2(:,i), yq2(:,i)] = modeltwiss('x', QMS.QuadFamily, QMS.QuadDev);
% 
%         setquad(QMS, QUAD0, -1, 'Model');
%     elseif strcmpi(lower(QMS.ModulationMethod), 'unipolar')
%         % Modulate the quadrupole
%         xm1(:,i) = getam(QMS.BPMFamily, QMS.BPMDev, 'Model');
%         xm0(:,i) = x1(:,i);
%         setquad(QMS, QMS.QuadDelta+QUAD0, -1, 'Model');
%         xm2(:,i) = getam(QMS.BPMFamily, QMS.BPMDev, 'Model');
%         setquad(QMS, QUAD0, -1, 'Model');
%     end
% end
% 
% setquad(QMS, QUAD0, -1, 'Model');
% setsp(QMS.CorrFamily, CM0, QMS.CorrDevList, -1, 'Model');
% 
% xq0 = 1000*xq0;
% xq1 = 1000*xq1;
% xq2 = 1000*xq2;
%         
% yq0 = 1000*yq0;
% yq1 = 1000*yq1;
% yq2 = 1000*yq2;



% Fit verses the position at the BPM next to the quadrupole
if strcmpi(QMS.ModulationMethod, 'sweep')
    % One dimensional sweep of the quadrupole
    %x = x1(BPMelem1,:)';   
    x = (x1(BPMelem1,:)' + x2(BPMelem1,:)')/2;     
elseif strcmpi(QMS.ModulationMethod, 'bipolar')
    % Modulation of the quadrupole
    x = (x1(BPMelem1,:)' + x2(BPMelem1,:)')/2;     
elseif strcmpi(QMS.ModulationMethod, 'unipolar')
    % Unipolar modulation of the quadrupole
    %x = x1(BPMelem1,:)';   
    x = (x1(BPMelem1,:)' + x2(BPMelem1,:)')/2;     
end


% x = xm0 + yq0-(xm0-xm0(3));
% x = xm0(3) + yq0-yq0(3);
% x = x';

% Check for x reversal
dx = diff(x/(x(end)-x(1)));
if any(dx<0)
    i = find(dx < 0);
    if length(i)==1
        if i == 1
            x(1) = x(2) - mean(diff(x(2:end)));
        elseif i == length(x)-1
            x(end) = x(end-1) + mean(diff(x(1:end-1)));
        end
    end
end

if isfield(QMS, 'Orbit0')
    BPMUnitsString = QMS.Orbit0.UnitsString;
else
    BPMUnitsString = 'mm';
end

% Figure #1
if all(FigureHandle ~= 0) 
    
    xx = (QMS.x2(BPMelem1,:)+QMS.x1(BPMelem1,:))/2;

%    %KeepList = getbpmlist('Bergoz');
%     KeepList = getbpmlist('nonBergoz');
%     i = findrowindex(KeepList, QMS.BPMDevList);
%     QMS.x0 = QMS.x0(i,:);
%     QMS.x1 = QMS.x1(i,:);
%     QMS.x2 = QMS.x2(i,:);
%     QMS.y0 = QMS.y0(i,:);
%     QMS.y1 = QMS.y1(i,:);
%     QMS.y2 = QMS.y2(i,:);
  
% Plot only nonBergoz
%d = getbpmlist('nonBergoz');
%iNewBPMs = findrowindex(d, QMS.BPMDevList);

    % Plot horizontal raw data
    axes(AxesHandles(1));
    plot(xx, (QMS.x2-QMS.x1), '-x');
%    plot(xx, (QMS.x2(iNewBPMs,:)-QMS.x1(iNewBPMs,:)), '-x');
    hold on;
    plot(xx(:,1), (QMS.x2(:,1)-QMS.x1(:,1)), 'xb');
%    plot(xx(:,1), (QMS.x2(iNewBPMs,1)-QMS.x1(iNewBPMs,1)), 'xb');
    hold off;
    xlabel(sprintf('%s(%d,%d), raw values [%s]', 'BPMx', QMS.BPMDev(1), QMS.BPMDev(2), BPMUnitsString));
    ylabel({sprintf('\\Delta %s [%s]', 'BPMx', BPMUnitsString),'(raw data)'});
    if isempty(FileName)
        title(sprintf('Center for %s(%d,%d) %s(%d,%d)', QMS.BPMFamily, QMS.BPMDev(1), QMS.BPMDev(2), QMS.QuadFamily, QMS.QuadDev), 'interpreter', 'none');
    else
        title(sprintf('Center for %s(%d,%d) %s(%d,%d) (%s)', QMS.BPMFamily, QMS.BPMDev(1), QMS.BPMDev(2), QMS.QuadFamily, QMS.QuadDev, FileName), 'interpreter', 'none');
    end
    grid on
    axis tight

    if QMS.QuadPlane == 1
        Axes2Axis = axis;
    end

    % Plot vertical raw data
    axes(AxesHandles(2));
    plot((QMS.y2(BPMelem1,:)+QMS.y1(BPMelem1,:))/2, (QMS.y2-QMS.y1), '-x');
%    plot((QMS.y2(BPMelem1,:)+QMS.y1(BPMelem1,:))/2, (QMS.y2(iNewBPMs,:)-QMS.y1(iNewBPMs,:)), '-x');
    hold on;
    plot((QMS.y2(BPMelem1,1)+QMS.y1(BPMelem1,1))/2, (QMS.y2(:,1)-QMS.y1(:,1)), 'xb');
%    plot((QMS.y2(BPMelem1,1)+QMS.y1(BPMelem1,1))/2, (QMS.y2(iNewBPMs,1)-QMS.y1(iNewBPMs,1)), 'xb');
    hold off;
    %plot(x, x2-x1, '-x');
    %plot(linspace(-DelHCM,DelHCM,3), x2-x1);
    xlabel(sprintf('%s(%d,%d), raw values [%s]', 'BPMy', QMS.BPMDev(1), QMS.BPMDev(2), BPMUnitsString));
    ylabel({sprintf('\\Delta %s [%s]', 'BPMy', BPMUnitsString),'(raw data)'});
    grid on
    axis tight

    if QMS.QuadPlane == 2
        Axes2Axis = axis;
    end
end


if isempty(FileName)
    fprintf('   Calculating the center of %s(%d,%d) using %s(%d,%d)\n', QMS.QuadFamily, QMS.QuadDev, QMS.BPMFamily, QMS.BPMDev);
else
    fprintf('   Calculating the center of %s(%d,%d) using %s(%d,%d) (Data file: %s)\n', QMS.QuadFamily, QMS.QuadDev, QMS.BPMFamily, QMS.BPMDev, FileName);
end
fprintf('   Quadrupole modulation delta = %.3f amps, %s(%d,%d) max step = %.3f amps  (%s)\n', QMS.QuadDelta, QMS.CorrFamily, QMS.CorrDevList(1,:), QMS.CorrDelta, QMS.ModulationMethod);


        
% Least squares fit
merit = x2 - x1;
if QuadraticFit
    X = [ones(size(x)) x x.^2];
    fprintf('   %d point parabolic least squares fit\n', N);
else
    X = [ones(size(x)) x];
    fprintf('   %d point linear least squares fit\n', N);
end


% Axes #3
if all(FigureHandle ~= 0) 
    axes(AxesHandles(3));
    xx = linspace(x(1), x(end), 200);
end

iBPMOutlier = [];
invXX   = inv(X'*X);
invXX_X = invXX * X';

for i = 1:size(x1,1)
    % least-square fit: m = slope and b = Y-intercept
    b = invXX_X * merit(i,:)';
    bhat(i,:) = b';
    
    % Should equal
    %b = X \merit(i,:)';
    %bhat1(i,:) = b';
    
    % Standard deviation
    bstd = sigmaBPM(i) * invXX; 
    bhatstd(i,:) = diag(bstd)';  % hopefully cross-correlation terms are small
    
    if all(FigureHandle ~= 0)   
        if QuadraticFit
            y = b(3)*xx.^2 + b(2)*xx + b(1);
        else
            y = b(2)*xx + b(1);
        end
%        plot(xx, y); hold on  
    end
    
    % Outlier condition: remove if the error between the fit and the data is greater than OutlierFactor
    if QuadraticFit
        y = b(3)*x.^2 + b(2)*x + b(1);
    else
        y = b(2)*x + b(1);
    end
  %  if i == 50
  %      aaaadf=0;
  %  end
    if max(abs(y - merit(i,:)')) > OutlierFactor * sigmaBPM(i)    % OutlierFactor was absolute max(abs(y - merit(i,:)')) > OutlierFactor
        iBPMOutlier = [iBPMOutlier;i];
    end
    
    if QuadraticFit
        % Quadratic fit
        if b(2) > 0
            offset(i,1) = (-b(2) + sqrt(b(2)^2 - 4*b(3)*b(1))) / (2*b(3));
        else
            offset(i,1) = (-b(2) - sqrt(b(2)^2 - 4*b(3)*b(1))) / (2*b(3));
        end
        if ~isreal(offset(i,1))
            % (b^2-4ac) can be negative but it will only happen if the slope is very small.  The offset 
            % should just get thrown out later as an outlier but change the solution to the minimum of the parabola.
            offset(i,1) = -b(2) / b(1) / 2;
        end
    else
        % Linear fit
        offset(i,1) = -b(1)/b(2); 
    end
end

QMS.Offset = offset;
QMS.FitParameters = bhat;
QMS.FitParametersStd = bhatstd;
QMS.BPMStd = sigmaBPM;


% % Label axes #2
% if all(FigureHandle ~= 0) 
%     xlabel(sprintf('%s(%d,%d), raw values [%s]', QMS.BPMFamily, QMS.BPMDev(1), QMS.BPMDev(2), BPMUnitsString));
%     ylabel(sprintf('BPM LS Fit [%s]', BPMUnitsString));
%     grid on
%     axis tight
% end


% Compute offset for different conditions
fprintf('   %d total BPMs\n', length(offset));
fprintf('   BPMs are removed for 1. Bad Status, 2. BPM Outlier, 3. Small Slope, or 4. Center Outlier\n');
%m1 = mean(offset);
%s1 = std(offset);
%fprintf('   0. Mean = %.5f %s, STD = %.5f %s, all %d BPMs\n', m1, BPMUnitsString, s1, BPMUnitsString, length(offset));


% Remove bad Status BPMs
iStatus = find(QMS.BPMStatus==0);
iBad = iStatus;
if length(iBad) == length(offset)
    error('All the BPMs have bad status');
end
offset1 = offset;
offset1(iBad) = [];
m2 = mean(offset1);
s2 = std(offset1);
fprintf('   1. Mean = %+.5f %s, STD = %.5f %s, %2d points with bad status\n', m2, BPMUnitsString, s2, BPMUnitsString, length(iBad));

% Remove bad Status + Outliers
iBad = unique([iStatus; iBPMOutlier]);
if length(iBad) == length(offset)
    error('All BPMs either have bad status or failed the BPM outlier condition');
end
offset1 = offset;
offset1(iBad) = [];
m2 = mean(offset1);
s2 = std(offset1);
fprintf('   2. Mean = %+.5f %s, STD = %.5f %s, %2d points with condition 1 and abs(fit - measured data) > %.2f std(BPM) (BPM outlier)\n', m2, BPMUnitsString, s2, BPMUnitsString, length(iBad), OutlierFactor);


% Remove bad Status + Small slopes
%iSlope = find(abs(bhat(:,2)) < max(abs(bhat(:,2)))*MinSlopeFraction);

% Look for slope outliers
Slopes = abs(bhat(:,2));
[Slopes, i] = sort(Slopes);
Slopes = Slopes(round(end/2):end);  % remove the first half
if length(Slopes) > 5
    SlopesMax = Slopes(end-4); 
else
    SlopesMax = Slopes(end); 
end
%i = find(abs(Slopes-mean(Slopes)) > 2 * std(Slopes));
%Slopes(i) = [];

iSlope = find(abs(bhat(:,2)) < SlopesMax * MinSlopeFraction);
iBad = unique([iStatus; iBPMOutlier; iSlope]);
if length(iBad) == length(offset)
    error('All BPMs either have bad status, failed the BPM outlier condition, or failed the slope condition');
end
offset1 = offset;
offset1(iBad) = [];
m2 = mean(offset1);
s2 = std(offset1);
fprintf('   3. Mean = %+.5f %s, STD = %.5f %s, %2d points with condition 1, 2, and slope < %.2f max(slope)\n', m2, BPMUnitsString, s2, BPMUnitsString, length(iBad), MinSlopeFraction);


% Offset outlier offsets-mean(offsets) greater than 1 std
itotal = (1:length(offset))';
iok = itotal;

offset1 = offset;
offset1(iBad) = [];
iok(iBad) = [];

i = find(abs(offset1-mean(offset1)) > CenterOutlierFactor * std(offset1));
iCenterOutlier = iok(i);
iBad = unique([iBad; iCenterOutlier]);
if length(iBad) == length(offset)
    error('All BPMs either have bad status, failed the BPM outlier condition, or failed the slope condition, , or failed the center outlier condition');
end
offset1(i) = [];
iok(i) = [];

m2 = mean(offset1);
s2 = std(offset1);
QMS.GoodIndex = iok;
fprintf('   4. Mean = %+.5f %s, STD = %.5f %s, %2d points with condition 1, 2, 3, and abs(center-mean(center)) > %.2f std(center) (Center outlier)\n', m2, BPMUnitsString, s2, BPMUnitsString, length(iBad), CenterOutlierFactor);


NN = length(offset);

% Axes #4
if all(FigureHandle ~= 0) 
    axes(AxesHandles(4));
    [xx1,yy1]=stairs(1:NN,offset);
    offset1 = offset;
    offset1(iBad) = NaN*ones(length(iBad),1);
    [xx2, yy2] = stairs(1:NN, offset1);
    plot(xx1,yy1,'r', xx2,yy2,'b');
    xlabel('BPM Number');
    ylabel(sprintf('%s Center [%s]', QMS.BPMFamily, BPMUnitsString));
    grid on
    axis tight
    %xaxis([0 NN+1]);
    axis([0 NN+1 min(offset1)-.1e-3 max(offset1)+.1e-3]);
end


% Axes #3

if all(FigureHandle ~= 0) 
    if 0
        % Plot red line over the bad lines
        axes(AxesHandles(3));
        for j = 1:length(iBad)
            i = iBad(j);
            if QuadraticFit
                y = bhat(i,3)*xx.^2 + bhat(i,2)*xx + bhat(i,1);
            else
                y = bhat(i,2)*xx + bhat(i,1);
            end
            plot(xx, y,'r'); 
        end
        hold off
        axis tight
    else
        % Only plot the good data
        axes(AxesHandles(3));
        yy = [];
        for i = 1:size(x1,1)
            if ~any(i == iBad)
                if QuadraticFit
                    y = bhat(i,3)*xx.^2 + bhat(i,2)*xx + bhat(i,1);
                else
                    y = bhat(i,2)*xx + bhat(i,1);
                end
                yy = [yy;y];
            end
        end
        plot(xx, yy); 
        hold off
        grid on
        axis tight
    end
    xlabel(sprintf('%s(%d,%d), raw values [%s]', QMS.BPMFamily, QMS.BPMDev(1), QMS.BPMDev(2), BPMUnitsString));
    ylabel({sprintf('\\Delta %s [%s]', QMS.BPMFamily, BPMUnitsString),'(LS fit)'});
    grid on
    axis tight
    
    xaxis(Axes2Axis(1:2));
    
    % Make y-axis3 the same as yaxis2 for comparison
    if QMS.QuadPlane == 1
        Axes3Axis = axis(AxesHandles(3));
        yaxis(Axes3Axis(3:4), AxesHandles(1));
    else
        Axes3Axis = axis(AxesHandles(3));
        yaxis(Axes3Axis(3:4), AxesHandles(2));
    end
end



if ~isempty(iStatus)
    if ~isempty(find(iStatus==BPMelem1))
        fprintf('   WARNING: BPM(%d,%d) has a bad status\n', QMS.BPMDev(1), QMS.BPMDev(2));
        WarningString = sprintf('BPM(%d,%d) has a bad status', QMS.BPMDev(1), QMS.BPMDev(2));
    end
end
if ~isempty(iBPMOutlier)
    if ~isempty(find(iBPMOutlier==BPMelem1))
        fprintf('   WARNING: BPM(%d,%d) removed due to outlier (based on std(BPM))\n', QMS.BPMDev(1), QMS.BPMDev(2));
        WarningString = sprintf('BPM(%d,%d) removed due to outlier (based on std(BPM))', QMS.BPMDev(1), QMS.BPMDev(2));
    end
end
if ~isempty(iSlope)
    if ~isempty(find(iSlope==BPMelem1))
        fprintf('   WARNING: BPM(%d,%d) slope is too small\n', QMS.BPMDev(1), QMS.BPMDev(2));
        WarningString = sprintf('BPM(%d,%d) slope is too small', QMS.BPMDev(1), QMS.BPMDev(2));
    end
end
if ~isempty(iCenterOutlier)
    if ~isempty(find(iCenterOutlier==BPMelem1))
        fprintf('   WARNING: BPM(%d,%d) removed due to outlier (based on all the centers)\n', QMS.BPMDev(1), QMS.BPMDev(2));
        WarningString = sprintf('BPM(%d,%d) ', QMS.BPMDev(1), QMS.BPMDev(2));
    end
end


% % Axes #3
% if all(FigureHandle ~= 0) 
%     axes(AxesHandles(4));
%     iii=1:NN;
%     iii(iBad)=[];
%     for j = 1:length(iii)
%         i = iii(j);
%         
%         if 1
%             % Plot fit
%             if QuadraticFit
%                 y = bhat(i,3)*xx.^2 + bhat(i,2)*xx + bhat(i,1);
%             else
%                 y = bhat(i,2)*xx + bhat(i,1);
%             end
%             if all(FigureHandle ~= 0) 
%                 plot(xx, y,'b'); hold on 
%             end
%         else
%             % Plot error in fit
%             if QuadraticFit
%                 y = bhat(i,3)*x.^2 + bhat(i,2)*x + bhat(i,1);
%             else
%                 y = bhat(i,2)*x + bhat(i,1);
%             end
%             plot(x, y - merit(i,:)','b'); hold on 
%         end
%     end
%     hold off
%     xlabel(sprintf('%s(%d,%d), raw values [%s]', QMS.BPMFamily, QMS.BPMDev(1), QMS.BPMDev(2), BPMUnitsString));
%     ylabel(sprintf('Final %s Merit Fun [%s]', QMS.BPMFamily, BPMUnitsString));
%     grid on
%     axis tight
%     orient tall
% end


if ~isempty(QMS.OldCenter)
    fprintf('   Starting Offset %s(%d,%d) = %+f [%s]\n', QMS.BPMFamily, QMS.BPMDev, QMS.OldCenter, BPMUnitsString);
end
fprintf('   New Offset      %s(%d,%d) = %+f [%s]\n', QMS.BPMFamily, QMS.BPMDev, m2, BPMUnitsString);

try
fprintf('   Present Golden  %s(%d,%d) = %+f [%s]\n', QMS.BPMFamily, QMS.BPMDev, getgolden(QMS.BPMFamily, QMS.BPMDev), BPMUnitsString);
catch
end

QMS.Center = m2;
QMS.CenterSTD = s2;


if all(FigureHandle ~= 0)
    addlabel(1, 0, datestr(QMS.TimeStamp));
    addlabel(0, 0, sprintf('Offset %s(%d,%d)=%f, {\\Delta}%s(%d,%d)=%f, {\\Delta}%s(%d,%d)=%f', QMS.BPMFamily, QMS.BPMDev, QMS.Center, QMS.QuadFamily, QMS.QuadDev, QMS.QuadDelta, QMS.CorrFamily, QMS.CorrDevList(1,:), QMS.CorrDelta(1)));
end

fprintf('\n');


% Plot errors and/or add the errors to the QMS structure
if length(FigureHandle)==1 && isobject(FigureHandle)
    QMS = quaderrors(QMS, FigureHandle.Number + 1);
elseif length(FigureHandle)==1 && FigureHandle==0
    QMS = quaderrors(QMS, 0);
elseif length(FigureHandle)==1
    QMS = quaderrors(QMS, FigureHandle + 1);
else
    QMS = quaderrors(QMS, 0);
end


% To find greater than release 2013a
% if datenum(version('-date')) > datenum(2014,6,1)

% figure(gcf+1);
% clf reset;
% subplot(2,1,1);
% plot(QMS.x2-QMS.x1);
% ylabel('Difference Orbits');
% title('Horizontal');
% subplot(2,1,2);
% plot(QMS.x1, 'b');
% hold on
% plot(QMS.x2, 'r');
% ylabel('Absolute Orbits');
%     
% figure(gcf+1);
% clf reset;
% subplot(2,1,1);
% plot(QMS.y2-QMS.y1);
% ylabel('Difference Orbits');
% title('Vertical');
% subplot(2,1,2);
% plot(QMS.y1, 'b');
% hold on
% plot(QMS.y2, 'r');
% ylabel('Absolute Orbits');
%     






%QMS = orderfields(QMS);
