function [Tilt, Eta, EpsX, EpsY, Ratio, ENV, DP, DL, sigmas] = calccoupling
%CALCCOUPLING - Calculates the coupling and tilt of the AT model
%  [Tilt, Eta, EpsX, EpsY, EmittanceRatio, ENV, DP, DL, BeamSize] = calccoupling
%
%  OUTPUTS
%  1. Tilt - Tilts of the emittance ellipse [radian]
%  2. Eta - Dispersion
%  3. EpsX - Horzontal emittance
%  4. EpsY - Vertical  emittance
%  5. EmittanceRatio - median(EpsX) / median(EpsX)
%  6-8. ENV, DP, DL - Output of ohmienvelope
%
%  NOTES
%  1. If there are no outputs, the coupling information will be plotted.
%  2. It can be helpful the draw the lattice on top of a plot (hold on; drawlattice(Offset, Height);)
%  3. Whenever using the MML and AT together the AT indexes must be matched to what
%     is in the MML.  Whenever changing THERING use updateatindex to sync the MML.

%  Written by James Safranek


global THERING


C0 = 299792458;      % Speed of light [m/s]

ati = atindex(THERING);
L0 = findspos(THERING, length(THERING)+1);

% HarmNumber = 936;
% THERING{ati.RF}.Frequency = HarmNumber*C0/L0;
% THERING{ati.RF}.PassMethod = 'CavityPass';
% for i = ati.RF
%     THERING{i}.Frequency = THERING{i}.HarmNumber*C0/L0;
%     THERING{i}.PassMethod = 'CavityPass';
% end


[PassMethod, ATIndex, FamName, PassMethodOld, ATIndexOld, FamNameOld] = setradiation('On');

CavityState = getcavity;
setcavity('On');


% Get all the AT elements that add radiation
BendCell = findmemberof('BEND');
iBend = family2atindex(BendCell);
for ii = 1:length(iBend)
    if size(iBend{ii},2) > 1
        iBend{ii} = sort(iBend{ii}(:));
        nanindx = find(isnan(iBend{ii}));
        iBend{ii}(nanindx) = [];
    end
end
iBend = cell2mat(iBend(:));


QuadCell = findmemberof('QUAD');
iQuad = family2atindex(QuadCell);
for ii = 1:length(iQuad)
    if size(iQuad{ii},2) > 1
        iQuad{ii} = sort(iQuad{ii}(:));
        nanindx = find(isnan(iQuad{ii}));
        iQuad{ii}(nanindx) = [];
    end
end
iQuad = cell2mat(iQuad(:));


SextCell = findmemberof('SEXT');
iSext = family2atindex(SextCell);
for ii = 1:length(iSext)
    if size(iSext{ii},2) > 1
        iSext{ii} = sort(iSext{ii}(:));
        nanindx = find(isnan(iSext{ii}));
        iSext{ii}(nanindx) = [];
    end
end
iSext = cell2mat(iSext(:));


RadiationElemIndex = sort([iBend(:); iQuad(:); iSext(:)]');
%RadiationElemIndex(find(isnan(RadiationElemIndex))) = [];

[ENV, DP, DL] = ohmienvelope(THERING, RadiationElemIndex, 1:length(THERING)+1);

sigmas = cat(2, ENV.Sigma);
Tilt = cat(2, ENV.Tilt);
spos = findspos(THERING, 1:length(THERING)+1);

[TwissData, tune, chrom]  = twissring(THERING, 0, 1:length(THERING)+1, 'chrom');


% The the passmethods back
setpassmethod(ATIndexOld, PassMethodOld);
setcavity(CavityState);


% Calculate tilts
Beta = cat(1,TwissData.beta);
spos = cat(1,TwissData.SPos);

Eta = cat(2,TwissData.Dispersion);
EpsX = (sigmas(1,:).^2-Eta(1,:).^2*DP^2)./Beta(:,1)';
EpsY = (sigmas(2,:).^2-Eta(3,:).^2*DP^2)./Beta(:,2)';

% RMS tilt
TiltRMS = norm(Tilt)/sqrt(length(Tilt));
EtaY = Eta(3,:);

EpsX0 = mean(EpsX);
EpsY0 = mean(EpsY);
%EpsX0 = median(EpsX);
%EpsY0 = median(EpsY);
Ratio = EpsY0 / EpsX0;


% Fix imaginary data
% ohmienvelope seems to return complex when very close to zero
if ~isreal(sigmas(1,:))
    % Sigma is positive so this should be ok
    sigmas(1,:) = abs(sigmas(1,:));
end
if ~isreal(sigmas(2,:))
    % Sigma is positive so this should be ok
    sigmas(2,:) = abs(sigmas(2,:));
end
    

if nargout == 0
    fprintf('   RMS Tilt = %f [degrees]\n', (180/pi) * TiltRMS);
    fprintf('   RMS Vertical Dispersion = %f [m]\n', norm(EtaY)/sqrt(length(EtaY)));
    fprintf('   Mean Horizontal Emittance = %f [nm rad]\n', 1e9*EpsX0);
    fprintf('   Mean Vertical   Emittance = %f [nm rad]\n', 1e9*EpsY0);
    fprintf('   Emittance Ratio = %f%% \n', 100*Ratio);
    
    %figure(1);
    gcf;
    clf reset;
    subplot(2,2,1);
    plot(spos, Tilt*180/pi, '-')
    set(gca,'XLim',[0 spos(end)])
    ylabel('Tilt [degrees]');
    title(sprintf('Rotation Angle of the Beam Ellipse  (RMS = %f)', (180/pi) * TiltRMS));
    xlabel('s - Position [m]');

    %figure(2);
    subplot(2,2,3);
    [AX, H1, H2] = plotyy(spos, 1e6*sigmas(1,:), spos, 1e6*sigmas(2,:));

    %set(H1,'Marker','.')
    set(AX(1),'XLim',[0 spos(end)]);
    %set(H2,'Marker','.')
    set(AX(2),'XLim',[0 spos(end)]);
    title('Principal Axis of the Beam Ellipse');
    set(get(AX(1),'Ylabel'), 'String', 'Horizontal [\mum]'); 
    set(get(AX(2),'Ylabel'), 'String', 'Vertical [\mum]'); 
    xlabel('s - Position [m]');
    
    FontSize = get(get(AX(1),'Ylabel'),'FontSize');

    %figure(3);
    subplot(2,2,2);    
    plot(spos, 1e9 * EpsX);
    title('Horizontal Emittance');
    ylabel(sprintf('\\fontsize{16}\\epsilon_x  \\fontsize{%d}[nm rad]', FontSize));
    xlabel('s - Position [m]');
    xaxis([0 L0]);
    
    %figure(4);
    subplot(2,2,4);
    plot(spos, 1e9 * EpsY);
    title('Vertical Emittance');
    ylabel(sprintf('\\fontsize{16}\\epsilon_y  \\fontsize{%d}[nm rad]', FontSize));
    xlabel('s - Position [m]');
    xaxis([0 L0]);
   
    h = addlabel(.75, 0, sprintf('     Emittance Ratio = %f%% ', 100*Ratio), 10);
    set(h,'HorizontalAlignment','Center');
    
    orient landscape;
end

