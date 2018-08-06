function [DeltaRF, RFnew, frf] = findrf1(DeltaRF, BPMFamily, BPMList, FileName)
%FINDRF1 - Finds the RF frequency that minimizes the horizonal dispersion
%  [DeltaRF, RFnew, frf] = findrf1(DeltaRFvec, BPMFamily, BPMList, FileName)
%
%  INPUTS
%  1. DeltaRFvec - Vector of RF changes {Default or empty: [-.2% -.1% 0% .1% .2%] energy change}
%  2. BPMFamily - Family name {Default or empty: 'BPMx'}
%  3. BPMList - Device or element list of BPMs  {Default or empty: all}
%  4. FileName to save data (data in structure 'frf') {Default or empty: don't save data}
%
%  OUTPUTS
%  1. DeltaRF - Change in RF
%  2. RFnew - Zero crossing of the fit
%  3. frf - RF structure containing all the measurement data
%
%  NOTES
%  1. The RF frequency that minimized the dispersion maybe not be the
%     optimal RF frequency.  The ALS found that choosing an RF frequency which
%     minimizes the energy shift due to the horizontal corrector magnets
%     to be a more robust and repeatable solution.
%  2. This function measures the dispersion, hence changes the RF frequency!
%     rmdisp will basically do the same thing as findrf1 without changing the 
%     RF frequency.  However, findrf1 gives more control over the fit range for
%     the RF change and allows for more noise reduction in the fit.  That said,
%     rmdisp is usually just fine to use.
%  3. Beware of the magnitude of DeltaRFvec for nonlinear accelerators.
%
%  See also findrf, rmdisp, plotcm

%  Written by Greg Portmann


ChangeRFFlag = 1;
DisplayFlag = 1;


% Starting Point
RF0 = getrf('Struct');


if nargin < 1
    DeltaRF = [];
end
if isempty(DeltaRF)
    %DeltaRF = getfamilydata('DeltaRFChro');
    if isempty(DeltaRF)
        DeltaRF = getrf * getmcf * [-.002 -.001 0 .001 .002];  % .2% energy change
        %DeltaRF = getrf * getmcf * [-.006 -.003 0 .003 .006];  % .6% energy change
        %DeltaRF = [-400 -200 0 200 400];  % Hz
        %if strcmpi(RF0.UnitsString, 'Hz')
        %elseif strcmpi(RF0.UnitsString, 'MHz')
        %    DeltaRF = DeltaRF * 1e-6;  % MHz
        %else
        %    error('RF units unknown, hence default input frequency cannot be choosen.');
        %end
    end
end
if nargin < 2
    BPMFamily = '';
end
if isempty(BPMFamily)
    BPMFamily = 'BPMx';
end
if nargin < 3
    BPMList = family2dev(BPMFamily);
end
if isempty(BPMList)
    BPMList = family2dev(BPMFamily);
end
if nargin < 4
    FileName = [];
end


BPMDelay = getfamilydata('BPMDelay');
if isempty(BPMDelay)
    BPMDelay = 0;
end


Xoffset = getoffset(BPMFamily, BPMList);
Xgolden = getgolden(BPMFamily, BPMList);


% Get Dispersion
Dx = measdisp([], BPMFamily, BPMList);


for i = 1:length(DeltaRF)
    fprintf('   %d. Setting RF to %f [%s] \n', i, RF0.Data + DeltaRF(i), RF0.UnitsString);
    setrf(RF0.Data + DeltaRF(i));
    sleep(BPMDelay);
    x(:,i) = getam(BPMFamily, BPMList) - Xoffset;
    rf(1,i) = getrf;
end


% Set RF back to starting point
setrf(RF0);


% Find LS fit to the line
y = x' * Dx;           % Dot product of Dx and the X orbit
X = [ones(max(size(rf)),1) rf'];
%b = inv(X'*X)*X'*y;
b = X \ y;
RFnew = -b(1) / b(2);


rf1 = linspace(rf(1),rf(max(size(rf))),100);
yfit = b(1) + b(2)*rf1;

DeltaRF = RFnew - RF0.Data;


%figure
clf reset
plot(rf1,yfit, 'b', rf,y,'og', RFnew,0,'xr'); 
grid on
xlabel('RF Frequency [MHz]');
ylabel('Dot product of Dx and Hor. Orbit');
title(sprintf('FIT: %g + %g * RF,  \\DeltaRF = %g', b(1), b(2), DeltaRF));



% Set the RF frequency
if ChangeRFFlag
    % fprintf('\n               Starting RF = %f [%s]\n', RF0.Data, RF0.UnitsString);
    % fprintf('   Zero crossing of the RF = %f  Delta RF = %g [%s]\n', RFnew, DeltaRF, RF0.UnitsString);
    % answer = input('   Do you want to set the RF frequence now (n/y)? ','s');
    % if strcmp(answer, 'y') == 1
    %     setrf(RFnew);
    %     fprintf('   New RF frequency = %f [%s]\n', getrf, RF0.UnitsString);
    %     fprintf('   Measurement complete.\n');
    % else
    %     fprintf('   Measurement complete.  No change to the RF frequency.\n');
    % end
    if ~isempty(DeltaRF)
        if DisplayFlag
            answer = inputdlg({strvcat(strvcat(strvcat(sprintf('Recommend new RF Freqenecy is %g %s', RFnew, RF0.UnitsString), sprintf('Delta RF is %g %s', DeltaRF, RF0.UnitsString)), '  '),'Change the RF frequency?')},'FINDFR1',1,{sprintf('%g',DeltaRF)});
            if isempty(answer)
                fprintf('   No change was made to the RF frequency.\n');
                return
            end
            DeltaRF = str2num(answer{1});
        end
        steprf(DeltaRF);
        if DisplayFlag
            fprintf('   RF frequency change by %f %s.\n', DeltaRF, RFUnitsString);
        end
    else
        error('RF frequency not changed because of a calculation problem.');
    end
end


if ~isempty(FileName)         %save file
    frf.TimeStamp = clock;
    frf.CreatedBy = 'findrf';
    frf.FileName  = FileName;
    frf.x         = x;
    frf.rf        = rf;
    frf.Dx        = Dx;
    frf.RF0       = RF0;
    frf.RFnew     = RFnew;
    frf.DeltaRF   = DeltaRF;
    frf.BPMFamily = BPMFamily;
    frf.BPMList   = BPMList;
    frf.Xgolden   = Xgolden;
    frf.Xoffset   = Xoffset;
    save(FileName, 'frf');
    fprintf('   Data saved to %s.mat in directory %s.\n', FileName, pwd);
end



