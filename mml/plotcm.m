function [DeltaRF, HCMEnergyChangeTotal, DeltaL] = plotcm(varargin)
%PLOTCM - Plots the horizontal and vertical corrector magnet families and
%         computes the energy change due to the horizontal correctors.
%
%  [DeltaRF, DeltaEnergy, DeltaL] = plotcm(DeviceList, ...)
%
%  INPUTS (optional)
%  1.  DeviceList
%  2. 'Position' {Default} or 'Phase' for the x-axis units 
%  3. 'Display' - Plot orbit information {Default}
%     'NoDisplay' - No plot
%  4. 'Online', 'Model', 'Manual', 'Hardware', 'Physics', etc. (the usual Units and Mode flags)
%  
%
%  OUTPUTS
%  1. DeltaRF - RF change that equates to the energy change
%  2. DeltaEnergy - Total energy change due to the horizontal correctors
%  3. DeltaL - Path length change that equates to changing the RF by DeltaRF
% 
%  See also findrf, findrf1, rmdisp

%  Written by Greg Portmann


DisplayFlag = 1;
XAxisFlag = 'Position';


% Input parsing
InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Position')
        XAxisFlag = 'Position';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Phase')
        XAxisFlag = 'Phase';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end


% Get the default corrector families
Family1 = gethcmfamily;
Family2 = getvcmfamily;


% SP or AM ???
x = getsp(Family1, 'Struct', varargin{:});
y = getsp(Family2, 'Struct', varargin{:});


% Compute the energy change due to the correctors
L = getfamilydata('Circumference');
HCM = hw2physics(x);
HCM = HCM.Data;


if strcmpi(getfamilydata('Machine'),'ALS')
    % For the ALS, either the HCMChicane magnets need to be included or
    % the chicane "part" of the HCMs needs to be removed
    Energy = getfamilydata('Energy');
    
    % Sector 6
    %                   Off    1.9 GeV   1.5 GeV
    % HCMCHICANEM(6,1)  80.0    18.0       ?
    % HCMCHICANEM(6,1)  80.0    20.0       ?
    % HCM(6,1)           0.0    18.8      18.8*1.5/1.9
    %ihcm = findrowindex([6 1], x.DeviceList);
    %if length(ihcm) == 1
    %    try
    %        if getsp('HCMCHICANEM',[6 1]) < 70
    %            % Assume sector 6 chicane is on
    %            if Energy == 1.9
    %                HCM(ihcm) = HCM(ihcm) + hw2physics(x.FamilyName, x.Field, -18.8, [6 1]);
    %                x.Data(ihcm) = x.Data(ihcm) - 18.8;
    %            else
    %                HCM(ihcm) = HCM(ihcm) + hw2physics(x.FamilyName, x.Field, -18.8*1.5/1.9, [6 1]);
    %                x.Data(ihcm) = x.Data(ihcm) - 18.8*1.5/1.9;
    %            end
    %        end
    %    catch
    %        fprintf('%s\n', lasterr);
    %        fprintf('Problem reading HCMCHICANEM(6,1).  The chicane "offset" on HCM(6,1) will not be removed.\n\n');
    %    end
    %end

    % Sector 11
    %                    Off    1.9 GeV   1.5 GeV
    % HCMCHICANEM(11,1)  80.0    40.5      52.0
    % HCMCHICANEM(11,1)  80.0    40.5      52.0
    % HCM(10,8)           0.0   -17.0     -14.0
    % HCM(11,1)           0.0   -17.0     -14.0
    ihcm = findrowindex([10 8], x.DeviceList);
    if length(ihcm) == 1
        try
            if getsp('HCMCHICANEM',[11 1]) < 60
                % Assume sector 11 chicane is on
                if Energy > 1.8
                    HCM(ihcm) = HCM(ihcm) + hw2physics(x.FamilyName, x.Field, 17, [10 8]);
                    x.Data(ihcm) = x.Data(ihcm) + 17;
                else
                    HCM(ihcm) = HCM(ihcm) + hw2physics(x.FamilyName, x.Field, 14, [10 8]);
                    x.Data(ihcm) = x.Data(ihcm) + 14;
                end
            end
        catch
            fprintf('%s\n', lasterr);
            fprintf('Due to an error, the chicane "offset" on HCM(10,8) will not be removed.n\n');
        end
    end
    ihcm = findrowindex([11 1], x.DeviceList);
    if length(ihcm) == 1
        try
            if getsp('HCMCHICANEM',[11 1]) < 60
                % Assume sector 11 chicane is on
                if Energy > 1.8
                    HCM(ihcm) = HCM(ihcm) + hw2physics(x.FamilyName, x.Field, 17, [11 1]);
                    x.Data(ihcm) = x.Data(ihcm) + 17;
                else
                    HCM(ihcm) = HCM(ihcm) + hw2physics(x.FamilyName, x.Field, 14, [11 1]);
                    x.Data(ihcm) = x.Data(ihcm) + 14;
                end
            end
        catch
            fprintf('%s\n', lasterr);
            fprintf('Due to an error, the chicane "offset" on HCM(11,1) will not be removed.n\n');
        end
    end
end


[DxHCM, DyHCM] = modeldisp([], x.FamilyName, x.DeviceList, 'Numeric', 'Physics');
HCMEnergyChange = -1 * HCM .* DxHCM / getmcf / L; 
HCMEnergyChangeTotal = sum(HCMEnergyChange);

% Delta RF to move the energy change due to the corrector to the RF frequency
DeltaRF = -1 * getrf * getmcf * HCMEnergyChangeTotal;                     % Default units of getrf/setrf
DeltaRFPhysics = -1 * getrf('Physics') * getmcf * HCMEnergyChangeTotal;   % Must be Hz

DeltaL = L * getmcf * HCMEnergyChangeTotal;


if DisplayFlag
    LeftGraphColor = 'b';
    RightGraphColor = 'r';

    [RFUnits, RFUnitsString] = getunits('RF');

    if strcmpi(XAxisFlag, 'Phase')
        [BPMxspos, BPMyspos, Sx, Sy, Tune] = modeltwiss('Phase', x.FamilyName, x.DeviceList, y.FamilyName, y.DeviceList);
        BPMxspos = BPMxspos/2/pi;
        BPMyspos = BPMyspos/2/pi;
        XLabel = 'Phase';
    else
        BPMxspos = getspos(x.FamilyName, x.DeviceList);
        BPMyspos = getspos(y.FamilyName, y.DeviceList);
        XLabel = 'Position [meters]';
    end


    hfig = gcf;
    clf reset
    %p = get(hfig, 'Position');
    %set(hfig, 'Position', [p(1) p(2)-.8*p(4) p(3) p(4)+.8*p(4)]);
    
    
    subplot(2,1,1);
    [ax, h1, h2] = plotyy(BPMxspos, x.Data, BPMxspos, -HCMEnergyChange);
    FontSize = get(ax(1), 'Fontsize');
    title(sprintf('%s (%g rms [%s]):  Energy Change  \\Delta p / p  = \\Sigma \\delta_{hcm} \\eta_{hcm} / (-\\alpha L) = %.3e', Family1, std(x.Data), x.UnitsString, HCMEnergyChangeTotal), 'Fontsize',FontSize);
    set(get(ax(1),'Ylabel'), 'String', sprintf('%s [%s]', Family1, x.UnitsString), 'Fontsize',FontSize);
    set(get(ax(2),'Ylabel'), 'String', '-\Delta p/p', 'Color', RightGraphColor, 'Fontsize',FontSize);
    set(h1, 'Marker','.');
    set(h2, 'Marker','.');
    %'\fontsize{14}\sigma_y \fontsize{10}BL 3.1 [\mum]'
    set(ax(2), 'YColor', RightGraphColor);
    set(h2, 'Color', RightGraphColor);
    grid on

    if ~strcmpi(XAxisFlag, 'Phase')
        axes(ax(1));
        aa = axis;
        aa(1) = 0;
        aa(2) = L;
        axis(aa);
        axes(ax(2));
        aa = axis;
        aa(1) = 0;
        aa(2) = L;
        axis(aa);
    end


    ax(3) = subplot(2,1,2);
    plot(BPMyspos, y.Data, '.-');
    title(sprintf('%s (%g rms [%s])', Family2, std(y.Data), y.UnitsString), 'Fontsize',FontSize);
    xlabel(XLabel, 'Fontsize',FontSize);
    ylabel(sprintf('%s [%s]',Family2, x.UnitsString), 'Color', LeftGraphColor, 'Fontsize',FontSize);
    set(gca,'YColor', LeftGraphColor);
    if ~strcmpi(XAxisFlag, 'Phase')
        xaxis([0 L]);
    end
    grid on;

    % Link the x-axes
    linkaxes(ax, 'x');

    addlabel(1, 0, datestr(clock,0), 7);
    addlabel(0, 0, sprintf('Equivalent energy change using the RF is  \\DeltaRF = %g [%s]  \\DeltaL = %g [m]', DeltaRF, RFUnitsString, DeltaL), 7);

    if strcmpi(getfamilydata('Machine'),'ALS')
        addlabel(1, .5, 'Nominal chicane setting may have been removed from the HCM family', 7);
    end
end


