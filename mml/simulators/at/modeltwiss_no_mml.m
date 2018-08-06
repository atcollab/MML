function [TwissX, TwissY, Sx, Sy, Tune, Chrom, h] = modeltwiss(varargin)
%MODELTWISS - Returns a twiss function of the model
%  [TwissX, TwissY, Sx, Sy, Tune] = modeltwiss(TwissData {opt.}, TwissString, Family1, DeviceList1, Family2, DeviceList2)
%  [TwissX, TwissY, Sx, Sy, Tune] = modeltwiss(TwissData {opt.}, TwissString, Family1, Family2)
%  [TwissX, TwissY, Sx, Sy, Tune] = modeltwiss(TwissData {opt.}, TwissString, Family1, DeviceList1)
%  [TwissX, TwissY, Sx, Sy, Tune] = modeltwiss(TwissData {opt.}, TwissString)
%
%  INPUTS
%  1. TwissData - Structure with the twiss parameters {Default: get from THERING{1}.TwissData}
%  2. TwissString - 'beta'           for beta function [meters]
%                   'mu' or 'Phase'  for betatron phase advance (NOT 2*PI normalized)
%                   'alpha'          Derivative of the beta function
%                   'Orbit', 'ClosedOrbit' or 'x'             ('y' reverses output  [ y,  x, Sy, Sx, Tune] = modeltwiss('y')) 
%                   'OrbitPrime', 'ClosedOrbitPrime' or 'Px' ('Py' reverses output  [Py, Px, Sy, Sx, Tune] = modeltwiss('Py')) (momentum, NOT angle)
%                   'Eta' for dispersion
%                   'EtaPrime' for the derivative of dispersion
%  3. Family1 and Family2 are the family names for where to measure the horizontal/vertical twiss parameter.
%     A family name can be a middlelayer family or an AT family (FamName). 
%     'All' returns the value at every element in the model plus the end of the ring.
%     {Default or []: 'All'}
%  4. DeviceList1 and DeviceList2 are the device list corresponding to Family1 and Family2.
%     {Default or []: the entire list}
%  5. Optional flags:
%     'Display'   - Plot the dispersion {Default if no outputs exist}
%     'NoDisplay' - Dispersion will not be plotted {Default if outputs exist}
%     'DrawLattice' -  Include the lattice drawing on the plot
%     'NoDrawLattice' or 'NoLattice' - Don't include the lattice on the plot {Default}
%     'Hold On'  - Hold the present plot
%     'Hold Off' - Reset the plot {Default}
%
%  OUTPUTS
%  1. TwissX and TwissY - Horizontal and vertical twiss parameter
%  2. Sx and Sy are longitudinal locations in the ring [meters]
%  3. Tune - Fractional tune
%
%  NOTES
%  1. This function use twissline which uses the linear model.  See twissline 
%     for all the assumption that it uses.
%  2. This function uses the model coordinate system in physics units. 
%     Ie., no BPM or CM gain or rolls errors are applied.
%  3. Family1 and DeviceList1 can be any family.  For instance, if Family1='VCM'
%     and DeviceList1=[], then TwissX is the horizontal beta function at the 
%     vertical corrector magnets (similarly for Family2 and DeviceList2).
%  4. If no output exists, the function will be plotted to the screen.
%  5. Phase is in radians.
%  6. Whenever using the MML and AT together the AT indexes must be matched to what
%     is in the MML.  Whenever changing THERING use updateatindex to sync the MML.
%
%  See also modelbeta, modeltune, modelchro, modeldisp, getpvmodel, setpvmodel

%  Written by Greg Portmann


global THERING
if isempty(THERING)
    error('Simulator variable is not setup properly.');
end

% Default parameters if not overwritten
MachineType = 'StorageRing';
TwissString = 'Beta';
Family1 = 'ALL';
Family2 = 'ALL';
%Family1 = 'BPMx';
%Family2 = 'BPMy';
DeviceList1 = [];   
DeviceList2 = [];   
if nargout == 0
    DisplayFlag = 1;
else
    DisplayFlag = 0;
end
DrawLatticeFlag = 1;
HoldFlag = 0;
Chrom = [];
LineColor = '';

% Look for flags
for i = length(varargin):-1:1
    if ischar(varargin{i})
        if any(strcmpi(varargin{i}, {'DrawLattice','Draw Lattice','Lattice'}))
            DrawLatticeFlag = 1;
            varargin(i) = [];
        elseif any(strcmpi(varargin{i}, {'NoDrawLattice','No Draw Lattice', 'NoLattice', 'No Lattice'}))
            DrawLatticeFlag = 0;
            varargin(i) = [];
        %elseif strcmpi(varargin{i},'MachineType')
        %    MachineType = varargin{i};
        %    varargin(i+1) = [];
        %    varargin(i) = [];
        elseif any(strcmpi(varargin{i}, {'StorageRing','Storage Ring'}))
            MachineType = 'StorageRing';
            varargin(i) = [];
        elseif any(strcmpi(varargin{i}, {'Transport','Transportline','Linac'}))
            MachineType = 'Transport';
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Display')
            DisplayFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'NoDisplay')
            DisplayFlag = 0;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'hold on')
            HoldFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'hold off')
            HoldFlag = 0;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'color')
            LineColor = varargin{i+1};
            varargin(i+1) = [];
            varargin(i)   = [];
        end
    end
end

%if HoldFlag == 1
%    DrawLatticeFlag = 0;
%end

SPositions = findspos(THERING, 1:length(THERING)+1);
L = SPositions(end);


% Look for TwissString
if length(varargin) >= 1
    if ischar(varargin{1})
        TwissString = varargin{1};
        varargin(1) = [];
    end
end

% Look for BPMx family info
if length(varargin) >= 1
    if ischar(varargin{1})
        Family1 = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                DeviceList1 = varargin{1};
                varargin(1) = [];
            end
        end
    else
        if isnumeric(varargin{1})
            DeviceList1 = varargin{1};
            varargin(1) = [];
        end
    end
end

% Look for BPMy family info
if length(varargin) >= 1
    if ischar(varargin{1})
        Family2 = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                DeviceList2 = varargin{1};
                varargin(1) = [];
            end
        end
    else
        if isnumeric(varargin{1})
            DeviceList2 = varargin{1};
            varargin(1) = [];
        end
    end
else
    Family2 = Family1;
    DeviceList2 = DeviceList1;
end


% Horizontal plane
if strcmpi(Family1,'All') 
    Index1 = 1:length(THERING)+1;
elseif isfamily(Family1)
    Index1 = family2atindex(Family1, DeviceList1);
else
    Index1 = findcells(THERING, 'FamName', Family1);
end
if isempty(Index1)
    error('Family1 could not be found in the AO or AT deck');
else
    Index1 = Index1(:)';    % Row vector
end

% Vertical plane
if strcmpi(Family2,'All') 
    Index2 = 1:length(THERING)+1;
elseif isfamily(Family2)
    Index2 = family2atindex(Family2, DeviceList2);
else
    Index2 = findcells(THERING, 'FamName', Family2);
end
if isempty(Index2)
    error('Family2 could not be found in the AO or AT deck');
else
    Index2 = Index2(:)';    % Row vector
end

if any(strcmpi(MachineType, {'Transport','Transportline','Linac'}))
    % Transport line

    % Look for TWISSDATAIN
    TWISSDATAIN = [];
    if length(varargin) >= 1
        if isstruct(varargin{1})
            TWISSDATAIN = varargin{1};
            varargin(1) = [];
        end
    end
    if isempty(TWISSDATAIN)
        if isfield(THERING{1}, 'TwissData')
            TWISSDATAIN = THERING{1}.TwissData;
        else
            TWISSDATAIN = getfamilydata('TwissData');
            if isempty(TWISSDATAIN)
                error('TWISSDATAIN must be an input, located in THERING{1}.TwissData, or accessible to getfamilydata.');
            end
        end
    end

    if strcmpi(TwissString, 'Eta') || strcmpi(TwissString, 'Dispersion')  || strcmpi(TwissString, 'Disp')
        TD = twissline(THERING, 0, TWISSDATAIN, 1:(length(THERING)+1), 'Chrom');
    elseif strcmpi(TwissString, 'etaprime')
        TD = twissline(THERING, 0, TWISSDATAIN, 1:(length(THERING)+1), 'Chrom');
    else
        TD = twissline(THERING, 0, TWISSDATAIN, 1:(length(THERING)+1));
    end
    
    % Tune
    Tune = TD(end).mu/2/pi;
    Tune = Tune(:);
    
else
    % Storage ring
    if nargout >= 6 || any(strcmpi(TwissString, {'Eta','Dispersion','etaprime'}))
        [TD, Tune, Chrom] = twissring(THERING, 0, 1:(length(THERING)+1), 'Chrom');
    else
        [TD, Tune]        = twissring(THERING, 0, 1:(length(THERING)+1));
    end
%     if any(strcmpi(TwissString, {'Eta','Dispersion','etaprime'}))
%         % if nargout == 0
%         %     % To get the default plot
%         %     modeldisp(Family1, DeviceList1, Family2, DeviceList2, 'Physics');
%         % else
%         %     [TwissX, TwissY, Sx, Sy] = modeldisp(Family1, DeviceList1, Family2, DeviceList2, 'Physics');
%         % end
%         % if nargout >= 5
%         %     Tune = modeltune;
%         % end
%         % return;
%         [TD, Tune, Chrom] = twissring(THERING, 0, 1:(length(THERING)+1), 'Chrom');
%     else
%         [TD, Tune]        = twissring(THERING, 0, 1:(length(THERING)+1));
%     end
    
    Tune = Tune(:);
end


if strcmpi(TwissString, 'Phase')
    TwissString = 'mu';
end


if strcmpi(TwissString, 'beta')
    Twiss = cat(1,TD.beta);
    TwissXAll = Twiss(:,1);
    TwissYAll = Twiss(:,2);
    TwissX = Twiss(Index1,1);
    TwissY = Twiss(Index2,2);

    % Average of beginning and end of magnet
    %TwissXAll = [(Twiss(1:end-1,1)+Twiss(2:end,1))/2; Twiss(end,1)];
    %TwissYAll = [(Twiss(1:end-1,2)+Twiss(2:end,2))/2; Twiss(end,2)];
    %TwissX = (Twiss(Index1,1)+Twiss(Index1+1,1))/2;
    %TwissY = (Twiss(Index2,2)+Twiss(Index2+1,2))/2;

    YLabel1 = sprintf('\\beta_x [meters]');
    YLabel2 = sprintf('\\beta_y [meters]');
    
    if HoldFlag
        Title1 = sprintf('\\beta-function');
    else
        Title1 = sprintf('\\beta-function (Tune = %.3f / %.3f)', Tune);
    end
elseif strcmpi(TwissString, 'mu')
    Twiss = cat(1,TD.mu);
    TwissXAll = Twiss(:,1);
    TwissYAll = Twiss(:,2);
    TwissX = Twiss(Index1,1);
    TwissY = Twiss(Index2,2);

    %TwissXAll = [(Twiss(1:end-1,1)+Twiss(2:end,1))/2; Twiss(end,1)];
    %TwissYAll = [(Twiss(1:end-1,2)+Twiss(2:end,2))/2; Twiss(end,2)];
    %TwissX = (Twiss(Index1,1)+Twiss(Index1+1,1))/2;
    %TwissY = (Twiss(Index2,2)+Twiss(Index2+1,2))/2;

    YLabel1 = sprintf('\\%s_x [radians]', 'phi');
    YLabel2 = sprintf('\\%s_y [radians]', 'phi');
    
    if HoldFlag
        Title1  = sprintf('Phase Advance');
    else
        Title1  = sprintf('Phase Advance (Tune = %.3f / %.3f)', Tune);
    end
elseif strcmpi(TwissString, 'dispersion') || strcmpi(TwissString, 'disp') || strcmpi(TwissString, 'eta')
    %error('Use modeldisp');
    Twiss = cat(2,TD.Dispersion)';
    TwissXAll = Twiss(:,1);
    TwissYAll = Twiss(:,3);
    TwissX = Twiss(Index1,1);
    TwissY = Twiss(Index2,3);
    YLabel1 = sprintf('\\eta_x [m/(dp/p)]');
    YLabel2 = sprintf('\\eta_y [m/(dp/p)]');
    Title1  = sprintf('Dispersion');
elseif strcmpi(TwissString, 'etaprime')
    Twiss = cat(2,TD.Dispersion)';
    TwissXAll = Twiss(:,2);
    TwissYAll = Twiss(:,4);
    TwissX = Twiss(Index1,2);
    TwissY = Twiss(Index2,4);
    YLabel1 = '\partial\eta_x / \partial \its';
    YLabel2 = '\partial\eta_y / \partial \its';
    Title1  = sprintf('Derivative of the Dispersion');
elseif any(strcmpi(TwissString, {'Orbit','ClosedOrbit','x'}))
    iCavity = findcells(THERING,'Frequency');
             
    if isempty(iCavity)  %no cavity in AT model
        Twiss = cat(2,TD.ClosedOrbit)';
        %Twiss = findsyncorbit(THERING, 0, ATIndexList);
    else
        % Cavity in AT model
        PassMethod = THERING{iCavity(1)}.PassMethod;
        for kk = 1:length(iCavity)
            THERING{iCavity(kk)}.PassMethod = 'IdentityPass';    % Off
        end               
        
        C = 2.99792458e8;
        CavityFrequency  = THERING{iCavity(1)}.Frequency;
        CavityHarmNumber = THERING{iCavity(1)}.HarmNumber;
        L = findspos(THERING,length(THERING)+1); 
        f0 = C * CavityHarmNumber / L;
        DeltaRF = CavityFrequency - f0;   % Hz
        Twiss = findsyncorbit(THERING, -C*DeltaRF*CavityHarmNumber/CavityFrequency^2, 1:length(THERING)+1);
                
        % Reset PassMethod
        for kk = 1:length(iCavity)
            %THERING{iCavity(kk)}.PassMethod = 'ThinCavityPass';  % On
            THERING{iCavity(kk)}.PassMethod = PassMethod;
        end

        Twiss = Twiss';
    end
    TwissXAll = Twiss(:,1);
    TwissYAll = Twiss(:,3);
    TwissX = Twiss(Index1, 1);
    TwissY = Twiss(Index2, 3);
    YLabel1 = sprintf('x [meter]');
    YLabel2 = sprintf('y [meter]');
    Title1  = sprintf('Closed Orbit');
elseif any(strcmpi(TwissString, {'y','z'}))
    iCavity = findcells(THERING,'Frequency');
    if isempty(iCavity)  %no cavity in AT model
        Twiss = cat(2,TD.ClosedOrbit)';
        %Twiss = findsyncorbit(THERING, 0, ATIndexList);
    else
        % Cavity in AT model
        PassMethod = THERING{iCavity}.PassMethod;
        THERING{iCavity}.PassMethod = 'IdentityPass';    % Off
        
        C = 2.99792458e8;
        CavityFrequency  = THERING{iCavity}.Frequency;
        CavityHarmNumber = THERING{iCavity}.HarmNumber;
        L = findspos(THERING,length(THERING)+1); 
        f0 = C * CavityHarmNumber / L;
        DeltaRF = CavityFrequency - f0;   % Hz
        Twiss = findsyncorbit(THERING, -C*DeltaRF*CavityHarmNumber/CavityFrequency^2, 1:length(THERING)+1);
        
        % Reset PassMethod
        %THERING{iCavity}.PassMethod = 'ThinCavityPass';  % On
        THERING{iCavity}.PassMethod = PassMethod;

        Twiss = Twiss';
    end 
    TwissXAll = Twiss(:,3);
    TwissYAll = Twiss(:,1);
    TwissX = Twiss(Index1, 3);
    TwissY = Twiss(Index2, 1);
    YLabel1 = sprintf('y [meter]');
    YLabel2 = sprintf('x [meter]');
    Title1  = sprintf('Closed Orbit');
elseif any(strcmpi(TwissString, {'OrbitPrime','ClosedOrbitPrime','Px'}))
    Twiss = cat(2,TD.ClosedOrbit)';
    TwissXAll = Twiss(:,2);
    TwissYAll = Twiss(:,4);
    TwissX = Twiss(Index1, 2);
    TwissY = Twiss(Index2, 4);
    YLabel1 = 'P_x';
    YLabel2 = 'P_y';
    Title1  = 'Derivative of the Closed Orbit';
elseif strcmpi(TwissString, 'Py')
    Twiss = cat(2,TD.ClosedOrbit)';
    TwissXAll = Twiss(:,4);
    TwissYAll = Twiss(:,2);
    TwissX = Twiss(Index1, 4);
    TwissY = Twiss(Index2, 2);
    YLabel1 = 'P_y';
    YLabel2 = 'P_x';
    Title1  = 'Derivative of the Closed Orbit';
else
    Twiss = cat(1,TD.(TwissString));
    TwissXAll = Twiss(:,1);
    TwissYAll = Twiss(:,2);
    TwissX = Twiss(Index1, 1);
    TwissY = Twiss(Index2, 2);
    YLabel1 = sprintf('\\%s_x', TwissString);
    YLabel2 = sprintf('\\%s_y', TwissString);
    Title1  = sprintf('\\%s-functions', TwissString);
end


% Longitudinal position
SAll = cat(1,TD.SPos);
Sx = SAll(Index1);
Sy = SAll(Index2);

Sx = Sx(:);
Sy = Sy(:);
SAll = SAll(:);

% Twiss = Twiss;
% TwissX = TwissX;
% TwissY = TwissY;
% TwissXAll = TwissXAll;
% TwissYAll = TwissYAll;


% Output
if DisplayFlag
    % Plot
    if HoldFlag
        if isempty(LineColor)
            LineColor = nxtcolor;
        end
    else
        if isempty(LineColor)
            LineColor = 'b';
        end
        clf reset
        %set(gcf,'NumberTitle','On','Name',TwissString);
    end
    LineType = '-';

    
    if strcmpi(TwissString, 'mu')
        % Keep phase plot between -pi and pi
        xall = [];
        sxall= [];
        for i = 1:length(TwissXAll)
            if TwissXAll(i) > 2*pi
                TwissXAll(i:end) = TwissXAll(i:end) - 2*pi;
                xall = [xall; 2*pi; 0];    
                sxall = [sxall; mean(SAll(i-1:i)); mean(SAll(i-1:i))];
                xall = [xall; TwissXAll(i)];
                sxall = [sxall; SAll(i)];
            else
                xall = [xall; TwissXAll(i)];
                sxall = [sxall; SAll(i)];
            end
        end
        TwissX = rem(TwissX,2*pi);
        
        yall = [];
        syall= [];
        for i = 1:length(TwissYAll)
            if TwissYAll(i) > 2*pi
                TwissYAll(i:end) = TwissYAll(i:end) - 2*pi;
                yall = [yall; 2*pi; 0];    
                syall = [syall; mean(SAll(i-1:i)); mean(SAll(i-1:i))];
                yall = [yall; TwissYAll(i)];
                syall = [syall; SAll(i)];
            else
                yall = [yall; TwissYAll(i)];
                syall = [syall; SAll(i)];
            end
        end
        TwissY = rem(TwissY,2*pi);
                
        h(1,1) = subplot(2,1,1);
        %h(1,1) = subplot(5,1,[1 2]);
        if HoldFlag
            hold on;
        end
        plot(sxall, xall, LineType, 'Color', LineColor);
        if strcmpi(Family1,'All')
            %xlabel('Position [meters]');
        else
            hold on;
            plot(Sx, TwissX, '.b');
            hold off;
            if ~strcmpi(Family1, Family2)
                xlabel(sprintf('%s Position [meters]', Family1));
            end
        end
        ylabel(YLabel1);
        title(Title1, 'Fontsize', 12);
        a = axis;
        axis([a(1:2) 0 2*pi]);
        grid on;
        hold off;
        
        % plot lattice
        %h(3,1) = subplot(5,1,3);
        %drawlattice;

        h(2,1) = subplot(2,1,2);
        %h(2,1) = subplot(5,1,[4 5]);
        if HoldFlag
            hold on;
        end
        plot(syall, yall, LineType, 'Color', LineColor);
        if strcmpi(Family2,'All')
            xlabel('Position [meters]');
        else
            hold on;
            plot(Sy, TwissY, '.b');
            hold off;
            xlabel(sprintf('%s Position [meters]', Family2));
        end
        ylabel(YLabel2);
        a = axis;
        axis([a(1:2) 0 2*pi]);
        grid on;
        hold off;
    else        
        h(1,1) = subplot(2,1,1);
        %h(1,1) = subplot(5,1,[1 2]);
        if HoldFlag
            hold on;
        end
        plot(SAll, TwissXAll, LineType, 'Color', LineColor);
        if strcmpi(Family1,'All')
            %xlabel('Position [meters]');
        else
            hold on;
            plot(Sx, TwissX, '.b');
            hold off;
            if ~strcmpi(Family1, Family2)
                xlabel(sprintf('%s Position [meters]', Family1));
            end
        end
        ylabel(YLabel1);
        title(Title1, 'Fontsize', 12);
        grid on;
        hold off;
        
        % plot lattice
        %h(3,1) = subplot(5,1,3);
        %drawlattice;

        h(2,1) = subplot(2,1,2);
        %h(2,1) = subplot(5,1,[4 5]);
        if HoldFlag
            hold on;
        end
        plot(SAll, TwissYAll, LineType, 'Color', LineColor);
        if strcmpi(Family2,'All')
            xlabel('Position [meters]');
        else
            hold on;
            plot(Sy, TwissY, '.b');
            hold off;
            xlabel(sprintf('%s Position [meters]', Family2));
        end
        ylabel(YLabel2);
        grid on;
        hold off;
    end
    
    % Scale the x-axis to the length of the lattice
    if ~isempty(L)
        subplot(2,1,1);
        a = axis;
        axis([0 L a(3:4)]);
        subplot(2,1,2);
        a = axis;
        axis([0 L a(3:4)]);
    end
    
    if DrawLatticeFlag
        % Reduce the axes height a little but keep the axis
        a1 = axis(h(1));
        a2 = axis(h(2));
        %yaxesposition(.95);
        axis(h(1), a1);
        axis(h(2), a2);
        
        h(3) = subplot(9,1,5);
        drawlattice(0,1);
        set(h(3),'YTick',[]);
        set(h(3),'XTickLabel','');
        set(h(3),'YTickLabel','');
        set(h(3),'Visible','Off');
        a = axis;
        axis([a(1:2) -1.25 1.75]);
     
        %hold((h(1)),'on');
        %a = axis(h(1));
        %drawlattice(a(4)-.08*(a(4)-a(3)),.05*(a(4)-a(3)),h(1));
        %axis(h(1), a);
        %hold((h(1)),'off');
        %
        %hold((h(2)),'on');
        %a = axis(h(2));
        %drawlattice(a(4)-.08*(a(4)-a(3)),.05*(a(4)-a(3)),h(2));
        %axis(h(2), a);
        %hold((h(2)),'off');
       
        % h = subplot(17,1,9);
        % drawlattice(0, 1, h);
        % %set(h,'Visible','Off');
        % set(h,'Color','None');
        % set(h,'XMinorTick','Off');
        % set(h,'XMinorGrid','Off');
        % set(h,'YMinorTick','Off');
        % set(h,'YMinorGrid','Off');
        % set(h,'XTickLabel',[]);
        % set(h,'YTickLabel',[]);
        % set(h,'XLim', [0 L]);
        % set(h,'YLim', [-1.5 1.5]);
    end

    % Link the x-axes
    linkaxes(h, 'x');
    
    orient tall
end
