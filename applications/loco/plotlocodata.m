function FileName = plotlocodata(varargin)
%PLOTLOCODATA - Plots for comparing LOCO runs
%  plotlocodata(FileName)
%
%  INPUTS
%  1. FileName - LOCO data file name or leave blank for an inputdlg
%
%  Written by Greg Portmann


FileName1 = '';


% LOCO file #1
if nargin >= 1
    FileName1 = varargin{1};
    N = 1;
else
    N = inf;
    FileName1 = '';
end


if nargin < 2
    LineType = '.-b';
else
    LineType = varargin{2};
end

LineType = '.-';


figure(1);
clf reset

figure(2);
clf reset

figure(3);
clf reset

for iFile = 1:N
    
    if isempty(FileName1)
        [FileName1, PathName] = uigetfile('*.mat', 'Select A LOCO File (cancel to stop)', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        drawnow;
        if ~ischar(FileName1)
            if iFile == 1
                return;
            else
                break
            end
        else
            FileName1 = [PathName, FileName1];
        end
    end

    load(FileName1);
    BPMData1 = BPMData;
    CMData1 = CMData;
    FitParameters1 = FitParameters;
    LocoFlags1 = LocoFlags;
    LocoMeasData1 = LocoMeasData;
    LocoMeasData1 = LocoMeasData;
    LocoModel1 = LocoModel;
    RINGData1 = RINGData;


    % Shorten the filenames
    i = findstr(FileName1, filesep);
    if length(FileName1) > 1
        FileName1(1:i(end)) = [];
    end


    % Iteration number to plot
    i1 = length(CMData1);

    nFig = 1; %gcf;
    figure(nFig);
    %clf reset
    
    ColorOrder = get(gca,'ColorOrder');
    
    x1 = 1:length(CMData1(i1).HCMKicks);
    y1 = 1:length(CMData1(i1).VCMKicks);

    subplot(2,2,1);
    if 1 % isempty(CMData1(i1).HCMKicksSTD)
        plot(x1(CMData1(i1).HCMGoodDataIndex), CMData1(i1).HCMKicks(CMData1(i1).HCMGoodDataIndex), LineType, 'Color', ColorOrder(mod(iFile-1,size(ColorOrder,1))+1,:));
        hold on
    else
        errorbar(x1(CMData1(i1).HCMGoodDataIndex), CMData1(i1).HCMKicks(CMData1(i1).HCMGoodDataIndex), CMData1(i1).HCMKicksSTD(CMData1(i1).HCMGoodDataIndex), LineType)
        hold on
    end
    title(sprintf('Horizontal Corrector Magnet Fits'));
    ylabel('Horizontal Kick [mrad]');
    %xlabel('Horizontal Corrector Number');
    axis tight


    subplot(2,2,2);
    if 1 % isempty(CMData1(i1).VCMKicksSTD)
        plot(y1(CMData1(i1).VCMGoodDataIndex), CMData1(i1).VCMKicks(CMData1(i1).VCMGoodDataIndex), LineType, 'Color', ColorOrder(mod(iFile-1,size(ColorOrder,1))+1,:));
        hold on
    else
        errorbar(y1(CMData1(i1).VCMGoodDataIndex), CMData1(i1).VCMKicks(CMData1(i1).VCMGoodDataIndex), CMData1(i1).VCMKicksSTD(CMData1(i1).VCMGoodDataIndex), LineType);
        hold on
    end
    title(sprintf('Vertical Corrector Magnet Fits'));
    ylabel('Vertical Kick [mrad]');
    %xlabel('Vertical Corrector Number');
    axis tight;


    subplot(2,2,3);
    if 1 % isempty(CMData1(i1).HCMKicksSTD)
        plot(x1(CMData1(i1).HCMGoodDataIndex), CMData1(i1).HCMCoupling(CMData1(i1).HCMGoodDataIndex), LineType, 'Color', ColorOrder(mod(iFile-1,size(ColorOrder,1))+1,:));
        hold on
    else
        errorbar(x1(CMData1(i1).HCMGoodDataIndex), CMData1(i1).HCMCoupling(CMData1(i1).HCMGoodDataIndex), CMData1(i1).HCMCouplingSTD(CMData1(i1).HCMGoodDataIndex), LineType);
        hold on
    end
    %title(sprintf('Horizontal Corrector Magnet Fits'));
    ylabel('Horizontal Coupling');
    xlabel('Horizontal Corrector Number');
    axis tight


    subplot(2,2,4);
    if 1 % isempty(CMData1(i1).VCMCouplingSTD)
        plot(y1(CMData1(i1).VCMGoodDataIndex), CMData1(i1).VCMCoupling(CMData1(i1).VCMGoodDataIndex), LineType, 'Color', ColorOrder(mod(iFile-1,size(ColorOrder,1))+1,:));
        hold on
    else
        errorbar(y1(CMData1(i1).VCMGoodDataIndex), CMData1(i1).VCMCoupling(CMData1(i1).VCMGoodDataIndex), CMData1(i1).VCMCouplingSTD(CMData1(i1).VCMGoodDataIndex), LineType);
        hold on
    end
    %title(sprintf('Vertical Corrector Magnet Fits'));
    ylabel('Vertical Coupling');
    xlabel('Vertical Corrector Number');
    axis tight;

    % H = addlabel(0,0,sprintf('Blue-%s   Red-%s', FileName1, FileName2));
    % set(H, 'Interpreter','None');

    orient landscape




    nFig = nFig + 1;
    figure(nFig);
    %clf reset

    x1 = 1:length(BPMData1(i1).HBPMGain);
    y1 = 1:length(BPMData1(i1).VBPMGain);

    subplot(2,2,1);
    if 1 % isempty(BPMData1(i1).HBPMGainSTD)
        plot(x1(BPMData1(i1).HBPMGoodDataIndex), BPMData1(i1).HBPMGain(BPMData1(i1).HBPMGoodDataIndex), LineType, 'Color', ColorOrder(mod(iFile-1,size(ColorOrder,1))+1,:));
        hold on
    else
        errorbar(x1(BPMData1(i1).HBPMGoodDataIndex), BPMData1(i1).HBPMGain(BPMData1(i1).HBPMGoodDataIndex), BPMData1(i1).HBPMGainSTD(BPMData1(i1).HBPMGoodDataIndex), LineType);
        hold on
    end
    title(sprintf('Horizontal BPM Fits'));
    ylabel('Horizontal Gain');
    axis tight


    subplot(2,2,2);
    if 1 % isempty(BPMData1(i1).VBPMGainSTD)
        plot(y1(BPMData1(i1).VBPMGoodDataIndex), BPMData1(i1).VBPMGain(BPMData1(i1).VBPMGoodDataIndex), LineType, 'Color', ColorOrder(mod(iFile-1,size(ColorOrder,1))+1,:));
        hold on
    else
        errorbar(y1(BPMData1(i1).VBPMGoodDataIndex), BPMData1(i1).VBPMGain(BPMData1(i1).VBPMGoodDataIndex), BPMData1(i1).VBPMGainSTD(BPMData1(i1).VBPMGoodDataIndex), LineType);
        hold on
    end
    title(sprintf('Vertical BPM Fits'));
    ylabel('Vertical Gain');
    axis tight;


    subplot(2,2,3);
    if 1 % isempty(BPMData1(i1).HBPMGainSTD)
        plot(x1(BPMData1(i1).HBPMGoodDataIndex), BPMData1(i1).HBPMCoupling(BPMData1(i1).HBPMGoodDataIndex), LineType, 'Color', ColorOrder(mod(iFile-1,size(ColorOrder,1))+1,:));
        hold on
    else
        errorbar(x1(BPMData1(i1).HBPMGoodDataIndex), BPMData1(i1).HBPMCoupling(BPMData1(i1).HBPMGoodDataIndex), BPMData1(i1).HBPMCouplingSTD(BPMData1(i1).HBPMGoodDataIndex), LineType);
        hold on
    end
    %title(sprintf('Horizontal Corrector Magnet Fits'));
    ylabel('Horizontal Coupling');
    xlabel('Horizontal BPM Number');
    axis tight


    subplot(2,2,4);
    if 1 % isempty(BPMData1(i1).VBPMCouplingSTD)
        plot(y1(BPMData1(i1).VBPMGoodDataIndex), BPMData1(i1).VBPMCoupling(BPMData1(i1).VBPMGoodDataIndex), LineType, 'Color', ColorOrder(mod(iFile-1,size(ColorOrder,1))+1,:));
        hold on
    else
        errorbar(y1(BPMData1(i1).VBPMGoodDataIndex), BPMData1(i1).VBPMCoupling(BPMData1(i1).VBPMGoodDataIndex), BPMData1(i1).VBPMCouplingSTD(BPMData1(i1).VBPMGoodDataIndex), LineType);
        hold on
    end
    ylabel('Vertical Coupling');
    xlabel('Vertical BPM Number');
    axis tight;

    % H = addlabel(0,0,sprintf('Blue - %s    Red - %s', FileName1, FileName2));
    % set(H, 'Interpreter','None');

    orient landscape



    nFig = nFig + 1;
    figure(nFig);
    %clf reset

    ifit = 1:length(FitParameters1(i1).Values);
    x1 = 1:length(FitParameters1(i1).Values);
    
    %subplot(2,1,1);
    if 1 % isempty(FitParameters1(i1).ValuesSTD)
        plot(x1, FitParameters1(i1).Values(ifit), LineType, 'Color', ColorOrder(mod(iFile-1,size(ColorOrder,1))+1,:));
        hold on
    else
        errorbar(x1, FitParameters1(i1).Values(ifit), FitParameters1(i1).ValuesSTD(ifit), LineType);
    end
    hold on
    title(sprintf('Other Parameter Fit Values'));
    ylabel('Fit Values');
    xlabel('Fit Parameter Number');
    axis tight


%     ifit = 23:44;
% 
%     subplot(2,1,2);
%     if 1 % isempty(FitParameters1(i1).ValuesSTD)
%         plot(x1, FitParameters1(i1).Values(ifit), LineType, 'Color', ColorOrder(mod(iFile-1,size(ColorOrder,1))+1,:));
%         hold on
%     else
%         errorbar(x1, FitParameters1(i1).Values(ifit), FitParameters1(i1).ValuesSTD(ifit), LineType);
%     end
%     hold on
%     ylabel('QD [K]');
%     axis tight


    % H = addlabel(0,0,sprintf('Blue - %s    Red - %s', FileName1, FileName2));
    % set(H, 'Interpreter','None');

    orient tall

    
    FileName{iFile} = FileName1;
    FileName1 = '';
    
    clear FitParameters
end


figure(1);
subplot(2,2,1);
h = legend(FileName);
set(h,'Interpreter','none');
hold off;
subplot(2,2,2);
hold off;
subplot(2,2,3);
hold off;
subplot(2,2,4);
hold off;


figure(2);
subplot(2,2,1);
h = legend(FileName);
set(h,'Interpreter','none');
hold off;
subplot(2,2,2);
hold off;
subplot(2,2,3);
hold off;
subplot(2,2,4);
hold off;

figure(3);
%subplot(2,1,1);
h = legend(FileName);
set(h,'Interpreter','none');
hold off;
%subplot(2,1,2);
%hold off;
