function [QMS, WarningString] = quadplotphysics(Input1, FigureHandle, sigmaBPM)
%QUADPLOTPHYSICS - Plots quadrupole centering data in physics units
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
        if isempty(Input1)
            [FileName, PathName] = uigetfile('*.mat', 'Select a Quadrupole Center File', [getfamilydata('Directory','DataRoot'), 'QMS', filesep]);
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


 QMS.QuadraticFit = 0;
 
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
if isnan(sigmaBPM) | isinf(sigmaBPM)
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
        AxesHandles(1) = subplot(3,1,1);
        AxesHandles(2) = subplot(3,1,2);
        AxesHandles(3) = subplot(3,1,3);
        %AxesHandles(4) = subplot(4,1,4);    
    else
        if length(FigureHandle) == 1
            FigureHandle = figure(FigureHandle);
            clf reset
            AxesHandles(1) = subplot(3,1,1);
            AxesHandles(2) = subplot(3,1,2);
            AxesHandles(3) = subplot(3,1,3);
            %AxesHandles(4) = subplot(4,1,4);    
        elseif length(FigureHandle) == 4
            FigureHandle = figure;
            clf reset
            AxesHandles = FigureHandle;
        else
            error('Improper size of input FigureHandle');
        end
    end
end

Buffer = .01;
HeightBuffer = .08;
if QMS.QuadPlane == 1    
    x1 = QMS.x1;
    x2 = QMS.x2;
    
    % Plot setup
    if all(FigureHandle ~= 0) 
        set(FigureHandle,'units','normal','position',[.0+Buffer .27+Buffer .5-2*Buffer .72-2*Buffer-HeightBuffer]);
    end
else
    x1 = QMS.y1;
    x2 = QMS.y2;
    
    % Plot setup
    if all(FigureHandle ~= 0) 
        set(FigureHandle,'units','normal','position',[.5+Buffer .27+Buffer .5-2*Buffer .72-2*Buffer-HeightBuffer]);
    end
end


[BPMelem1, iNotFound] = findrowindex(QMS.BPMDev, QMS.BPMDevList);
if ~isempty(iNotFound)
    error('BPM at the quadrupole not found in the BPM device list');
end

% Expand sigmaBPM is necessary
if length(sigmaBPM) == 1
    sigmaBPM = ones(size(x1,1),1) * sigmaBPM;
end

N = size(x1,2);

% Change the number of points
% if 0
%     Ndiv2 = floor(size(x1,2)/2);
%     Npoint1 = Ndiv2;
%     Npoint2 = Ndiv2+2;
%     fprintf('  Using %d points (%d to %d, total %d).', Npoint2-Npoint1+1, Npoint1, Npoint2, N)   
%     x1 = x1(:,Npoint1:Npoint2);
%     x2 = x2(:,Npoint1:Npoint2);
%     y1 = y1(:,Npoint1:Npoint2);
%     y2 = y2(:,Npoint1:Npoint2);
%     N = size(x1,2);
%     Ndiv2 = floor(size(x1,2)/2);
% end




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
%
% x = xm0 + yq0-(xm0-xm0(3));
% x = xm0(3) + yq0-yq0(3);
% x = x';


% Convert to physics units
%x0 = hw2physics('BPMx', 'Monitor', x0, QMS.BPMDevList);
%x1 = hw2physics('BPMx', 'Monitor', x1, QMS.BPMDevList);
%x2 = hw2physics('BPMx', 'Monitor', x2, QMS.BPMDevList);


Gx = getgain('BPMx', QMS.BPMDevList);
Gy = getgain('BPMy', QMS.BPMDevList);
C = getcrunch('BPMx', QMS.BPMDevList);
R = getroll('BPMx', QMS.BPMDevList);

for i = 1:length(Gx)
    m = [cos(R(i)) -sin(R(i)); sin(R(i)) cos(R(i))] * [1 C(i); C(i) 1] * [Gx(i) 0;0 Gy(i)] / sqrt(1-C(i)^2);

    for j = 1:size(QMS.x1,2)
        if j == 1
            if isfield(QMS, 'x0')
                a = m * [QMS.x0(i,j); QMS.y0(i,j)];
                QMS.x0(i,j) = a(1);
                QMS.y0(i,j) = a(2);
            end
        end

        a = m * [QMS.x1(i,j); QMS.y1(i,j)];
        QMS.x1(i,j) = a(1);
        QMS.y1(i,j) = a(2);
        
        a = m * [QMS.x2(i,j); QMS.y2(i,j)];
        QMS.x2(i,j) = a(1);
        QMS.y2(i,j) = a(2);
    end
end

x1 = QMS.y1;
x2 = QMS.y2; 



if isfield(QMS, 'OldCenter')
 %   QMS.OldCenter = hw2physics(QMS.BPMFamily, 'Monitor', QMS.OldCenter, QMS.BPMDev);
end

if isfield(QMS, 'Orbit0')
  %  QMS.Orbit0 = hw2physics(QMS.Orbit0);
    BPMUnitsString = QMS.Orbit0.UnitsString;
else
    BPMUnitsString = 'mm';
end


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


% Figure #1
if all(FigureHandle ~= 0) 
    axes(AxesHandles(1));
    %plot(linspace(-DelHCM,DelHCM,3), x2-x1);
    plot(x, x2-x1, '-x');
    xlabel(sprintf('%s(%d,%d), raw values [%s]', QMS.BPMFamily, QMS.BPMDev(1), QMS.BPMDev(2), BPMUnitsString));
    ylabel(sprintf('%s [%s]', QMS.BPMFamily, BPMUnitsString));
    %plot(1000*x, 1000*(x2-x1), '-x');
    %xlabel(sprintf('%s(%d,%d), raw values [mm]', QMS.BPMFamily, QMS.BPMDev(1), QMS.BPMDev(2)));
    %ylabel(sprintf('%s [mm]', QMS.BPMFamily));
    if isempty(FileName)
        title(sprintf('Center for %s(%d,%d) %s(%d,%d)', QMS.BPMFamily, QMS.BPMDev(1), QMS.BPMDev(2), QMS.QuadFamily, QMS.QuadDev), 'interpreter', 'none');
    else
        title(sprintf('Center for %s(%d,%d) %s(%d,%d) (%s)', QMS.BPMFamily, QMS.BPMDev(1), QMS.BPMDev(2), QMS.QuadFamily, QMS.QuadDev, FileName), 'interpreter', 'none');
    end
    grid on
    axis tight
end

if isempty(FileName)
    fprintf('   Calculating the center of %s(%d,%d) using %s(%d,%d)\n', QMS.QuadFamily, QMS.QuadDev, QMS.BPMFamily, QMS.BPMDev);
else
    fprintf('   Calculating the center of %s(%d,%d) using %s(%d,%d) (Data file: %s)\n', QMS.QuadFamily, QMS.QuadDev, QMS.BPMFamily, QMS.BPMDev, FileName);
end
fprintf('   Quadrupole modulation delta = %.3f amps, max. corrector step = %.3f amps\n', QMS.QuadDelta, QMS.CorrDelta);


% Least squares fit
merit = x2 - x1;
if QuadraticFit
    X = [ones(size(x)) x x.^2];
    fprintf('   %d point parabolic least squares fit\n', N);
else
    X = [ones(size(x)) x];
    fprintf('   %d point linear least squares fit\n', N);
end


% Axes #2
if all(FigureHandle ~= 0) 
    axes(AxesHandles(2));
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
    axes(AxesHandles(3));
    [xx1,yy1]=stairs(1:NN,offset);
    offset1 = offset;
    offset1(iBad) = NaN*ones(length(iBad),1);
    [xx2, yy2] = stairs(1:NN, offset1);
    plot(xx1,yy1,'r', xx2,yy2,'b');
    ylabel(sprintf('BPM Center [%s]', BPMUnitsString));
    %plot(xx1,1000*yy1,'r', xx2,1000*yy2,'b');
    %ylabel(sprintf('BPM Center [mm]'));
    xlabel('BPM Number');
    grid on
    axis tight
    %xaxis([1 NN+1]);
    %axis([1 NN+1 min(offset1)-.1e-6 max(offset1)+.1e-6]);
    %axis([1 NN+1 1000*[min(offset1)-.1e-6 max(offset1)+.1e-6]]);
    axis([1 NN+1 min(offset1)-.1 max(offset1)+.1]);
end


% Axes #2

if all(FigureHandle ~= 0) 
    if 0
        % Plot red line over the bad lines
        axes(AxesHandles(2));
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
        axes(AxesHandles(2));
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
        %plot(xx, yy); 
        plot(1000*xx, 1000*yy); 
        hold off
        grid on
        axis tight
    end
    xlabel(sprintf('%s(%d,%d), raw values [%s]', QMS.BPMFamily, QMS.BPMDev(1), QMS.BPMDev(2), BPMUnitsString));
    ylabel(sprintf('BPM LS Fit [%s]', BPMUnitsString));
    %xlabel(sprintf('%s(%d,%d), raw values [mm]', QMS.BPMFamily, QMS.BPMDev(1), QMS.BPMDev(2)));
    %ylabel(sprintf('BPM LS Fit [mm]'));
    grid on
    axis tight
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
%     axes(AxesHandles(3));
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

QMS.Center = m2;
QMS.CenterSTD = s2;


if all(FigureHandle ~= 0)
    addlabel(1, 0, datestr(QMS.TimeStamp));
    addlabel(0, 0, sprintf('Offset %s(%d,%d)=%f, {\\Delta}%s(%d,%d)=%f, {\\Delta}%s(%d,%d)=%f', QMS.BPMFamily, QMS.BPMDev, QMS.Center, QMS.QuadFamily, QMS.QuadDev, QMS.QuadDelta, QMS.CorrFamily, QMS.CorrDevList(1,:), QMS.CorrDelta(1)));
end

fprintf('\n');


% Get and plot errors
if all(FigureHandle ~= 0)
    QMS = quaderrors(QMS, gcf+1);
else
    % This is a cluge for now
    QMS = quaderrors(QMS, 0);
end


%QMS = orderfields(QMS);
