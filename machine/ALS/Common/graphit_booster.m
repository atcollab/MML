function [GR, Main] = graphit_booster(varargin)
%GRAPHIT_BOOSTER - Build the structures used by graphit
%
%  How to use
%  1.  Set the axes properties
%      GR = graphit_setup;
%      for i = 1:size(GR,1);
%          for j = 1:size(GR,2)
%              Fields = fieldnames(GR{i,j}.Axes);
%              for k = 1:length(Fields);
%                  if strcmpi(Fields{k}, 'YLabel')
%                      h = get(gca, 'YLabel');
%                      set(h, 'String', GR{i,j}.Axes.(Fields{k}));
%                  else
%                      Fields{k}
%                      set(gca, Fields{k}, GR{i,j}.Axes.(Fields{k}));
%                  end
%             end
%          end
%      end
%
%   2. Similar for the line properties

%

Main.Title = 'Booster General Info';
% TODO:what is this for?
Main.DropDataAfter = 24; % hours
Main.Units = 'Inches';
if ispc
    Main.Position = [2 2 8 11];
else
    Main.Position = [2 2 8+1.5 11+2];
end

% Define here Full path to directory for WEB Page
if ispc
    Main.Image.Filename =  '\\Als-filer\alswebdata\cr\Graphit_BR';
else
    Main.Image.Filename =  '/home/als2/www/htdoc/dynamic_pages/incoming/cr/Graphit_BR';
end

Main.Image.Write = 'Off'; % On  {Off being the default}


GraphNumber = 0;

% DCCT
GraphNumber = GraphNumber + 1;
ChannelNames = {'BR1_____QF_PSOFAC00';'BR1_____QD_PSOFAC00'};
GR{GraphNumber} = getdefaultaxes(ChannelNames);
GR{GraphNumber}.Data.Gain{1} = 1;
GR{GraphNumber}.Data.DisplayString = {'BR QF Offset (BR1_____QF_PSOFAC00)';'BR QD Offset (BR1_____QD_PSOFAC00)'};
GR{GraphNumber}.Axes.Position = [.125 .81 .75 .16];
GR{GraphNumber}.Axes.YLabel.String = {'\fontsize{12}QF and QD Offset'};
%GR{GraphNumber}.Axes.YLimMode = 'Manual';
%GR{GraphNumber}.Axes.YLim = [497 502];
GR{GraphNumber}.Axes.XTickLabel = '';


% QD, QF Gain
GraphNumber = GraphNumber + 1;
ChannelNames = {'BR1_____QD_PSGNAC00';'BR1_____QF_PSGNAC00';'BR1_____B_IE_GNAC00'};
GR{GraphNumber} = getdefaultaxes(ChannelNames);
GR{GraphNumber}.Data.Gain{1} = 1; 
GR{GraphNumber}.Data.DisplayString = {'QD Gain (BR1_____QD_PSGNAC00)';'QF Gain (BR1_____QF_PSGNAC00)';'B Gain (BR1_____B_IE_GNAC00)'};
GR{GraphNumber}.Axes.Position = [.125 .61 .75 .16];
GR{GraphNumber}.Axes.YLabel.String = {'\fontsize{12}QD, QF and B Gain'};
%GR{GraphNumber}.Axes.YLimMode = 'Manual';
%GR{GraphNumber}.Axes.YLim = [497 502];
GR{GraphNumber}.Axes.XTickLabel = '';




%GR{GraphNumber}.AssociateWith = GraphNumber+1;
%GR{GraphNumber}.Line.Marker{1,1} = 'square';


% GraphNumber = GraphNumber + 1;
% ChannelNames = {'Cam1_current';'Cam2_current'};
% GR{GraphNumber} = getdefaultaxes(ChannelNames);
% GR{GraphNumber}.Line.Color{1,1} = [0 .5 0];
% GR{GraphNumber}.Line.Color{2,1} = [0 .5 0];
% GR{GraphNumber}.Line.LineWidth{1,1} = 2;
% %GR{GraphNumber}.Line.LineStyle{2,1} = '--';
% GR{GraphNumber}.Data.DisplayString = {'Camshaft Bunch #1 (Cam1_current)';'Camshaft Bunch #2 (Cam2_current)'};
% GR{GraphNumber}.Axes.Position = GR{GraphNumber-1}.Axes.Position;
% %GR{GraphNumber}.Axes.YLabel.String = {'Cam Bucket #1 (Grn) [mA]','Cam Bucket #2 (red) [mA]'};
% GR{GraphNumber}.Axes.YLabel.String = {'\fontsize{12}Cam Bucket [mA]'};
% GR{GraphNumber}.Axes.YLabel.Color = [0 .5 0];
% GR{GraphNumber}.Axes.YLim = [0 10];
% %GR{GraphNumber}.Axes.XTickLabel = '';
% GR{GraphNumber}.Axes.YAxisLocation = 'Right';
% GR{GraphNumber}.AssociateWith = GraphNumber-1;
% GR{GraphNumber}.Axes.Color = 'None'; % Top axes color must be none
% 
% 
% % Lifetime
% GraphNumber = GraphNumber + 1;
% ChannelNames = {'Topoff_lifetime_AM'};
% GR{GraphNumber} = getdefaultaxes(ChannelNames);
% GR{GraphNumber}.Data.DisplayString = {'SR Lifetime (Topoff_lifetime_AM)'};
% GR{GraphNumber}.Axes.Position = [.125 .62 .75 .16];
% GR{GraphNumber}.Axes.YLabel.String = {'\fontsize{18}{\tau\fontsize{10}_{total}}  \fontsize{12}[Hours]'};
% GR{GraphNumber}.Axes.YLim = [2 9];
% %GR{GraphNumber}.Axes.XTickLabel = '';
% GR{GraphNumber}.AssociateWith = GraphNumber+1;
% 
% GraphNumber = GraphNumber + 1;
% GR{GraphNumber}.ChannelNames = {'Topoff_cam_lifetime_AM'};
% GR{GraphNumber} = getdefaultaxes(GR{GraphNumber}.ChannelNames);
% GR{GraphNumber}.Line.Color{1,1} = [0 .5 0];
% GR{GraphNumber}.Data.DisplayString = {'SR Cam Bunch Lifetime (Topoff_cam_lifetime_AM)'};
% GR{GraphNumber}.Axes.Position = GR{GraphNumber-1}.Axes.Position;
% GR{GraphNumber}.Axes.YLabel.String = {'\fontsize{18}{\tau\fontsize{10}_{cam}}  \fontsize{12}[Hours]'};
% GR{GraphNumber}.Axes.YLabel.Color = [0 .5 0];
% GR{GraphNumber}.Axes.YLim = [2 9];
% %GR{GraphNumber}.Axes.XTickLabel = '';
% GR{GraphNumber}.Axes.YAxisLocation = 'Right';
% GR{GraphNumber}.AssociateWith = GraphNumber-1;
% GR{GraphNumber}.Axes.Color = 'None'; % Top axes color must be none
% 
% % Beamsize
% GraphNumber = GraphNumber + 1;
% ChannelNames = {'beamline31:XRMSAve';'beamline31:YRMSAve'};
% GR{GraphNumber} = getdefaultaxes(ChannelNames);
% GR{GraphNumber}.Line.Color{1,1} = [0 0 1];
% GR{GraphNumber}.Line.Color{2,1} = [0 0 .5];
% GR{GraphNumber}.Line.LineWidth{1,1} = 2;
% GR{GraphNumber}.Data.DisplayString = {'Horizontal beam size at BL 3.1'; 'Vertical beam size at BL 3.1'};
% GR{GraphNumber}.Axes.Position = [.125 .43 .75 .16];
% GR{GraphNumber}.Axes.YLabel.String = {'\fontsize{12}BL 3.1    \fontsize{16}\sigma_x \sigma_y  \fontsize{12}[\mum]'};
% GR{GraphNumber}.Axes.YLim = [25 75];
% %GR{GraphNumber}.Axes.XTickLabel = '';
% GR{GraphNumber}.AssociateWith = GraphNumber+1;
% 
% GraphNumber = GraphNumber + 1;
% ChannelNames = {'bl72:XRMSAve';'bl72:YRMSAve'};
% GR{GraphNumber} = getdefaultaxes(ChannelNames);
% GR{GraphNumber}.Line.Color{1,1} = [0 1 0];
% GR{GraphNumber}.Line.Color{2,1} = [0 .5 0];
% GR{GraphNumber}.Line.LineWidth{1,1} = 2;
% GR{GraphNumber}.Data.DisplayString = {'Horizontal beam size at BL 7.2'; 'Vertical beam size at BL 7.2'};
% GR{GraphNumber}.Axes.Position = GR{GraphNumber-1}.Axes.Position;
% GR{GraphNumber}.Axes.YLabel.String = {'\fontsize{12}BL 7.2    \fontsize{16}\sigma_x \sigma_y  \fontsize{12}[\mum]'};
% GR{GraphNumber}.Axes.YLabel.Color = [0 .5 0];
% GR{GraphNumber}.Axes.YLabel.Color = [0 .5 0];
% GR{GraphNumber}.Axes.YLim = [2 9];
% %GR{GraphNumber}.Data.Gain = {1,.5};
% %GR{GraphNumber}.Axes.XTickLabel = '';
% GR{GraphNumber}.Axes.YAxisLocation = 'Right';
% GR{GraphNumber}.AssociateWith = GraphNumber-1;
% GR{GraphNumber}.Axes.Color = 'None'; % Top axes color must be none
% 
% % Beam quality factor and tune shift with ID gap
% GraphNumber = GraphNumber + 1;
% ChannelNames = {'SR05S___DCCTLP_AM01'; 'Topoff_lifetime_AM'; 'beamline31:XRMSAve';'beamline31:YRMSAve'};
% GR{GraphNumber} = getdefaultaxes(ChannelNames);
% GR{GraphNumber}.Data.Function = @beamqualityfactor;
% GR{GraphNumber}.Data.DisplayString = {'SR Beam Quality Factor'};
% GR{GraphNumber}.Axes.Position = [.125 .24 .75 .16];
% GR{GraphNumber}.Axes.YLabel.String = {'\fontsize{14}I \tau / (\sigma_x \sigma_y )'};
% GR{GraphNumber}.Axes.YLim = [.75 1.25];
% %GR{GraphNumber}.Axes.XTickLabel = '';
% 
% % Add the tune shift later
% % i = GraphNumber;
% % j = 2;
% % ChannelNames = {};
% % GR{GraphNumber} = getdefaultaxes(ChannelNames);
% % GR{GraphNumber}.Data.DisplayString = {'TuneShift(Gap)'};
% % GR{GraphNumber}.Axes.YLabel.String = {'\fontsize{10}\Delta \nu_y (Gap)^1'};
% % GR{GraphNumber}.Axes.YLim = [0 .05];
% 
% 
% % Insertion devices
% GraphNumber = GraphNumber + 1;
% clear ChannelNames
% IDGapName  = family2channel('ID', 'Monitor');
% for i = 1:size(IDGapName,1)
%     ChannelNames{i,1} = deblank(IDGapName(i,:));
% end
% EPUGapName  = family2channel('EPU', 'Monitor');
% for i = 1:size(EPUGapName,1)
%     ChannelNames{i+size(IDGapName,1),1} = deblank(EPUGapName(i,:));
% end
% 
% GR{GraphNumber} = getdefaultaxes(ChannelNames);
% 
% IDGapCommon = family2common('ID', 'Monitor');
% for i = 1:size(IDGapCommon,1)
%     GR{GraphNumber}.Data.DisplayString{i,1} = sprintf('%s (%s)',deblank(IDGapCommon(i,:)), deblank(IDGapName(i,:)));
% end
% EPUGapCommon = family2common('EPU', 'Monitor');
% for i = 1:size(EPUGapCommon,1)
%     GR{GraphNumber}.Data.DisplayString{i,1} = sprintf('%s (%s)',deblank(EPUGapCommon(i,:)), deblank(EPUGapName(i,:)));
% end
% GR{GraphNumber}.Axes.Position = [.125 .05 .75 .16];
% GR{GraphNumber}.Axes.YLabel.String = {'\fontsize{11}Insertion Devices [mm]'};
% %GR{GraphNumber}.Axes.YLabel.FontUnits = 'Normalized';  % Normalized, Points, etc  ->  Had no effect
% GR{GraphNumber}.Axes.YLim = [-25 60];
% %GR{GraphNumber}.Axes.XTickLabel = 'Auto';



function [t, tau] = beamqualityfactor(tDCCT, tLifetime, tSigX, tSigY, DCCT, Lifetime, SigX, SigY)


%
% Error in ==> graphit_setup>beamqualityfactor at 175
% if size(tDCCT)<2 || size(tLifetime)<2 || size(tSigX)<2 || size(tSigY)<2


% There should be at least two data points.
% if size(tDCCT)<2 || size(tLifetime)<2 || size(tSigX)<2 || size(tSigY)<2
% ??? Operands to the || and && operators must be convertible to logical
% scalar values.
if length(tDCCT)<2 || length(tLifetime)<2 || length(tSigX)<2 || length(tSigY)<2
    t = {tDCCT};% need a cell array here
    %tau = NaN * t; % multiply for a cellarray here!!
    tau ={NaN * tDCCT};
    return;
end

% NaN is not an appropriate value for X or Y

%Error in Function Too many output arguments.

iNaN = find(isnan(DCCT));
tDCCT(iNaN) = [];
DCCT(iNaN) = [];
iNaN = find(isnan(Lifetime));
tLifetime(iNaN) = [];
Lifetime(iNaN) = [];
iNaN = find(isnan(SigX));
tSigX(iNaN) = [];
SigX(iNaN) = [];
iNaN = find(isnan(SigY));
tSigY(iNaN) = [];
SigY(iNaN) = [];


i = find(diff(tDCCT)==0);
tDCCT(i) = [];
DCCT(i) = [];
i = find(diff(tLifetime)==0);
tLifetime(i) = [];
Lifetime(i) = [];
i = find(diff(tSigY)==0);
tSigY(i) = [];
SigY(i) = [];
i = find(diff(tSigX)==0);
tSigX(i) = [];
SigX(i) = [];
i = find(diff(tSigY)==0);
tSigY(i) = [];
SigY(i) = [];

i = find(diff(DCCT)==0);
tDCCT(i) = [];
DCCT(i) = [];
i = find(diff(Lifetime)==0);
tLifetime(i) = [];
Lifetime(i) = [];
i = find(diff(SigY)==0);
tSigY(i) = [];
SigY(i) = [];
i = find(diff(SigX)==0);
tSigX(i) = [];
SigX(i) = [];
i = find(diff(SigY)==0);
tSigY(i) = [];
SigY(i) = [];


if length(tDCCT)<2 || length(tLifetime)<2 || length(tSigX)<2 || length(tSigY)<2
    t = {tDCCT};% need a cell array here
    %tau = NaN * t; % multiply for a cellarray here!!
    tau ={NaN * tDCCT};
    return;
end


% Base the time on tSigX;
t{1} = tSigX;

% Linear interpolate to line up all the time vectors
DCCT     = interp1(tDCCT, DCCT, t{1}, 'linear', 'extrap');
Lifetime = interp1(tLifetime, Lifetime, t{1}, 'linear', 'extrap');
SigY     = interp1(tSigY, SigY, t{1}, 'linear', 'extrap');

tau{1} = 100*DCCT .* Lifetime ./ SigX ./ SigY;



function GR = getdefaultaxes(ChannelNameCell)

colorOrder = [
    0            0            .5      %  1 BLUE
    0            1            0       %  2 GREEN (pale)
    1            0            0       %  3 RED
    0            1            1       %  4 CYAN
    1            0            1       %  5 MAGENTA (pale)
    1            1            0       %  6 YELLOW (pale)
    0            0            0       %  7 BLACK
    0            0.75         0.75    %  8 TURQUOISE
    0            0.5          0       %  9 GREEN (dark)
    0.75         0.75         0       % 10 YELLOW (dark)
    1            0.50         0.25    % 11 ORANGE
    0.75         0            0.75    % 12 MAGENTA (dark)
    0.7          0.7          0.7     % 13 GREY
    0.8          0.7          0.6     % 14 BROWN (pale)
    0.6          0.5          0.4 ];  % 15 BROWN (dark)

%StyleOrder = {'-','-.','--',':'};

for i = 1:size(ChannelNameCell,1)
    GR.Style = 'axes';
    GR.Data.ChannelNames{i,1} = ChannelNameCell{i};
    GR.Data.DisplayString{i,1} = deblank(ChannelNameCell{i,1});
    GR.Data.Gain{i,1} = 1;
    GR.Data.Offset{i,1} = 0;
    
    GR.Line.Color{i,1} = colorOrder(rem(i-1,15)+1,:);
    GR.Line.LineStyle{i,1} = '-';
    GR.Line.LineWidth{i,1} = 1.5;  % .5 is matlab default
    GR.Line.Marker{i,1} = 'None';
end

GR.Axes.Units = 'Normalized';
%GR.Axes.XTickLabel = [];
GR.Axes.XGrid = 'Off';
GR.Axes.YGrid = 'Off';
GR.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
GR.Axes.YLabel.String = '';
GR.Axes.YLabel.Color = [0 0 1];
GR.AssociateWith =[];
GR.Axes.TickDir = 'In';  % In or Out
