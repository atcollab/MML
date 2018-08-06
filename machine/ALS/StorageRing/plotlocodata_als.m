function plotlocodata_als(varargin)

FileName1 = '';
FileName2 = '';


%FileName1 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-09-18', filesep, 'Nominal',  filesep, 'BPMRespMat.mat'];
%FileName2 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-09-18', filesep, 'QF', filesep, 'BPMRespMat.mat'];

%FileName1 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-10-10', filesep, 'Nominal',  filesep, 'LOCO_72SkewQuads.mat'];
%%FileName2 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-10-10', filesep, 'QF1', filesep, 'LOCO_72SkewQuads.mat'];
%FileName2 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-10-10', filesep, 'QF2', filesep, 'LOCO_72SkewQuads.mat'];

%FileName1 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-10-10', filesep, 'Nominal',  filesep, 'LOCO_72SkewQuadsFitRF.mat'];
%FileName2 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-10-10', filesep, 'QF1', filesep, 'LOCO_72SkewQuadsFitRF.mat'];
%FileName2 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-10-10', filesep, 'QF2', filesep, 'LOCO_72SkewQuadsFitRF.mat'];

%FileName1 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-05-14', filesep, 'Post_CorrectCoupling',  filesep, 'LocoData_PostCorrectCoupling_48SkewQuads.mat'];
%FileName2 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-05-14', filesep, 'Post_EtaWave', filesep, 'LocoData_PostEtaWave_48SkewQuads.mat'];

%%FileName1 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-10-16', filesep, 'Nominal1', filesep, 'LOCO_72SkewQuads.mat'];
%FileName1 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-10-16', filesep, 'Nominal2', filesep, 'LOCO_72SkewQuads.mat'];
%FileName2 = [getfamilydata('Directory','DataRoot'), 'LOCO', filesep, '2005-10-16', filesep, 'QF71', filesep, 'LOCO_72SkewQuads.mat'];


% LOCO file #1
if nargin >= 1
    FileName1 = varargin{1};
end
if isempty(FileName1)
    [FileName1, PathName] = uigetfile('*.mat', 'Select Response Matrix File #1', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
    drawnow;
    if ~isstr(FileName1)
        XOffset = [];
        YOffset = [];
        return
    else
        FileName1 = [PathName, FileName1];
    end
end

% LOCO file #2
if isempty(FileName2)
    [FileName2, PathName] = uigetfile('*.mat', 'Select Response Matrix File #2', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
    drawnow;
    if ~isstr(FileName2)
        XOffset = [];
        YOffset = [];
        return
    else
        FileName2 = [PathName, FileName2];
    end
end


load(FileName1);
Config1 = LocoMeasData.MachineConfig;
BPMData1 = BPMData;
CMData1 = CMData;
FitParameters1 = FitParameters;
LocoFlags1 = LocoFlags;
LocoMeasData1 = LocoMeasData;
LocoMeasData1 = LocoMeasData; 
LocoModel1 = LocoModel; 
RINGData1 = RINGData;


load(FileName2);
Config2 = LocoMeasData.MachineConfig;
BPMData2 = BPMData;
CMData2 = CMData;
FitParameters2 = FitParameters;
LocoFlags2 = LocoFlags;
LocoMeasData2 = LocoMeasData;
LocoMeasData2 = LocoMeasData; 
LocoModel2 = LocoModel; 
RINGData2 = RINGData;


% Shorten the filenames
i = findstr(FileName1, filesep);
if length(FileName1) > 1
    FileName1(1:i(end-1)) = [];
end
i = findstr(FileName2, filesep);
if length(FileName2) > 1
    FileName2(1:i(end-1)) = [];
end



% Iteration number to plot
i1 = length(CMData1);
i2 = length(CMData2);

nFig = 1; %gcf;
figure(nFig);
clf reset

x1 = 1:length(CMData1(i1).HCMKicks);
x2 = 1:length(CMData1(i2).HCMKicks);

y1 = 1:length(CMData1(i1).VCMKicks);
y2 = 1:length(CMData1(i2).VCMKicks);

subplot(2,2,1);
if isempty(CMData1(i1).HCMKicksSTD)
    plot(x1(CMData1(i1).HCMGoodDataIndex), CMData1(i1).HCMKicks(CMData1(i1).HCMGoodDataIndex), '.-b');
    hold on
    plot(x2(CMData1(i2).HCMGoodDataIndex), CMData2(i2).HCMKicks(CMData2(i2).HCMGoodDataIndex), '.-r');
else
    errorbar(x1(CMData1(i1).HCMGoodDataIndex), CMData1(i1).HCMKicks(CMData1(i1).HCMGoodDataIndex), CMData1(i1).HCMKicksSTD(CMData1(i1).HCMGoodDataIndex), '.-b');
    hold on
    errorbar(x2(CMData1(i2).HCMGoodDataIndex), CMData2(i2).HCMKicks(CMData2(i2).HCMGoodDataIndex), CMData2(i2).HCMKicksSTD(CMData2(i2).HCMGoodDataIndex), '.-r');
end
hold off
title(sprintf('Horizontal Corrector Magnet Fits'));
ylabel('Horizontal Kick [mrad]');
%xlabel('Horizontal Corrector Number');
axis tight


subplot(2,2,2);
if isempty(CMData1(i1).VCMKicksSTD)
    plot(y1(CMData1(i1).VCMGoodDataIndex), CMData1(i1).VCMKicks(CMData1(i1).VCMGoodDataIndex), '.-b');
    hold on
    plot(y2(CMData1(i2).VCMGoodDataIndex), CMData2(i2).VCMKicks(CMData2(i2).VCMGoodDataIndex), '.-r');
else
    errorbar(y1(CMData1(i1).VCMGoodDataIndex), CMData1(i1).VCMKicks(CMData1(i1).VCMGoodDataIndex), CMData1(i1).VCMKicksSTD(CMData1(i1).VCMGoodDataIndex), '.-b');
    hold on
    errorbar(y2(CMData1(i2).VCMGoodDataIndex), CMData2(i2).VCMKicks(CMData2(i2).VCMGoodDataIndex), CMData2(i2).VCMKicksSTD(CMData2(i2).VCMGoodDataIndex), '.-r');
end
hold off
title(sprintf('Vertical Corrector Magnet Fits'));
ylabel('Vertical Kick [mrad]');
%xlabel('Vertical Corrector Number');
axis tight;


subplot(2,2,3);
if isempty(CMData1(i1).HCMKicksSTD)
    plot(x1(CMData1(i1).HCMGoodDataIndex), CMData1(i1).HCMCoupling(CMData1(i1).HCMGoodDataIndex), '.-b');
    hold on
    plot(x2(CMData1(i2).HCMGoodDataIndex), CMData2(i2).HCMCoupling(CMData2(i2).HCMGoodDataIndex), '.-r');
else
    errorbar(x1(CMData1(i1).HCMGoodDataIndex), CMData1(i1).HCMCoupling(CMData1(i1).HCMGoodDataIndex), CMData1(i1).HCMCouplingSTD(CMData1(i1).HCMGoodDataIndex), '.-b');
    hold on
    errorbar(x2(CMData1(i2).HCMGoodDataIndex), CMData2(i2).HCMCoupling(CMData2(i2).HCMGoodDataIndex), CMData2(i2).HCMCouplingSTD(CMData2(i2).HCMGoodDataIndex), '.-r');
end
hold off
%title(sprintf('Horizontal Corrector Magnet Fits'));
ylabel('Horizontal Coupling');
xlabel('Horizontal Corrector Number');
axis tight


subplot(2,2,4);
if isempty(CMData1(i1).VCMCouplingSTD)
    plot(y1(CMData1(i1).VCMGoodDataIndex), CMData1(i1).VCMCoupling(CMData1(i1).VCMGoodDataIndex), '.-b');
    hold on
    plot(y2(CMData1(i2).VCMGoodDataIndex), CMData2(i2).VCMCoupling(CMData2(i2).VCMGoodDataIndex), '.-r');
else
    errorbar(y1(CMData1(i1).VCMGoodDataIndex), CMData1(i1).VCMCoupling(CMData1(i1).VCMGoodDataIndex), CMData1(i1).VCMCouplingSTD(CMData1(i1).VCMGoodDataIndex), '.-b');
    hold on
    errorbar(y2(CMData1(i2).VCMGoodDataIndex), CMData2(i2).VCMCoupling(CMData2(i2).VCMGoodDataIndex), CMData2(i2).VCMCouplingSTD(CMData2(i2).VCMGoodDataIndex), '.-r');
end
hold off
%title(sprintf('Vertical Corrector Magnet Fits'));
ylabel('Vertical Coupling');
xlabel('Vertical Corrector Number');
axis tight;

H = addlabel(0,0,sprintf('Blue-%s   Red-%s', FileName1, FileName2));
set(H, 'Interpreter','None');

orient landscape




nFig = nFig + 1;
figure(nFig);
clf reset

x1 = 1:length(BPMData1(i1).HBPMGain);
x2 = 1:length(BPMData1(i2).HBPMGain);

y1 = 1:length(BPMData1(i1).HBPMGain);
y2 = 1:length(BPMData1(i2).VBPMGain);

subplot(2,2,1);
if isempty(BPMData1(i1).HBPMGainSTD)
    plot(x1(BPMData1(i1).HBPMGoodDataIndex), BPMData1(i1).HBPMGain(BPMData1(i1).HBPMGoodDataIndex), '.-b');
    hold on
    plot(x2(BPMData1(i2).HBPMGoodDataIndex), BPMData2(i2).HBPMGain(BPMData2(i2).HBPMGoodDataIndex), '.-r');
else
    errorbar(x1(BPMData1(i1).HBPMGoodDataIndex), BPMData1(i1).HBPMGain(BPMData1(i1).HBPMGoodDataIndex), BPMData1(i1).HBPMGainSTD(BPMData1(i1).HBPMGoodDataIndex), '.-b');
    hold on
    errorbar(x2(BPMData1(i2).HBPMGoodDataIndex), BPMData2(i2).HBPMGain(BPMData2(i2).HBPMGoodDataIndex), BPMData2(i2).HBPMGainSTD(BPMData2(i2).HBPMGoodDataIndex), '.-r');
end
hold off
title(sprintf('Horizontal BPM Fits'));
ylabel('Horizontal Gain');
axis tight


subplot(2,2,2);
if isempty(BPMData1(i1).VBPMGainSTD)
    plot(y1(BPMData1(i1).VBPMGoodDataIndex), BPMData1(i1).VBPMGain(BPMData1(i1).VBPMGoodDataIndex), '.-b');
    hold on
    plot(y2(BPMData1(i2).VBPMGoodDataIndex), BPMData2(i2).VBPMGain(BPMData2(i2).VBPMGoodDataIndex), '.-r');
else
    errorbar(y1(BPMData1(i1).VBPMGoodDataIndex), BPMData1(i1).VBPMGain(BPMData1(i1).VBPMGoodDataIndex), BPMData1(i1).VBPMGainSTD(BPMData1(i1).VBPMGoodDataIndex), '.-b');
    hold on
    errorbar(y2(BPMData1(i2).VBPMGoodDataIndex), BPMData2(i2).VBPMGain(BPMData2(i2).VBPMGoodDataIndex), BPMData2(i2).VBPMGainSTD(BPMData2(i2).VBPMGoodDataIndex), '.-r');
end
hold off
title(sprintf('Vertical BPM Fits'));
ylabel('Vertical Gain');
axis tight;


subplot(2,2,3);
if isempty(BPMData1(i1).HBPMGainSTD)
    plot(x1(BPMData1(i1).HBPMGoodDataIndex), BPMData1(i1).HBPMCoupling(BPMData1(i1).HBPMGoodDataIndex), '.-b');
    hold on
    plot(x2(BPMData1(i2).HBPMGoodDataIndex), BPMData2(i2).HBPMCoupling(BPMData2(i2).HBPMGoodDataIndex), '.-r');
else
    errorbar(x1(BPMData1(i1).HBPMGoodDataIndex), BPMData1(i1).HBPMCoupling(BPMData1(i1).HBPMGoodDataIndex), BPMData1(i1).HBPMCouplingSTD(BPMData1(i1).HBPMGoodDataIndex), '.-b');
    hold on
    errorbar(x2(BPMData1(i2).HBPMGoodDataIndex), BPMData2(i2).HBPMCoupling(BPMData2(i2).HBPMGoodDataIndex), BPMData2(i2).HBPMCouplingSTD(BPMData2(i2).HBPMGoodDataIndex), '.-r');
end
hold off
%title(sprintf('Horizontal Corrector Magnet Fits'));
ylabel('Horizontal Coupling');
xlabel('Horizontal BPM Number');
axis tight


subplot(2,2,4);
if isempty(BPMData1(i1).VBPMCouplingSTD)
    plot(y1(BPMData1(i1).VBPMGoodDataIndex), BPMData1(i1).VBPMCoupling(BPMData1(i1).VBPMGoodDataIndex), '.-b');
    hold on
    plot(y2(BPMData1(i2).VBPMGoodDataIndex), BPMData2(i2).VBPMCoupling(BPMData2(i2).VBPMGoodDataIndex), '.-r');
else
    errorbar(y1(BPMData1(i1).VBPMGoodDataIndex), BPMData1(i1).VBPMCoupling(BPMData1(i1).VBPMGoodDataIndex), BPMData1(i1).VBPMCouplingSTD(BPMData1(i1).VBPMGoodDataIndex), '.-b');
    hold on
    errorbar(y2(BPMData1(i2).VBPMGoodDataIndex), BPMData2(i2).VBPMCoupling(BPMData2(i2).VBPMGoodDataIndex), BPMData2(i2).VBPMCouplingSTD(BPMData2(i2).VBPMGoodDataIndex), '.-r');
end
hold off
ylabel('Vertical Coupling');
xlabel('Vertical BPM Number');
axis tight;

H = addlabel(0,0,sprintf('Blue - %s    Red - %s', FileName1, FileName2));
set(H, 'Interpreter','None');

orient landscape



nFig = nFig + 1;
figure(nFig);
clf reset

x1 = 1:24;
x2 = 1:24;

subplot(2,1,1);
errorbar(x1, FitParameters1(i1).Values(1:24), FitParameters1(i1).ValuesSTD(1:24), '.-b');
hold on
errorbar(x2, FitParameters2(i2).Values(1:24), FitParameters2(i2).ValuesSTD(1:24), '.-r');
hold off
title(sprintf('Quadrupole Fits'));
ylabel('QF');
axis tight


subplot(2,1,2);
errorbar(x1, FitParameters1(i1).Values(25:48), FitParameters1(i1).ValuesSTD(25:48), '.-b');
hold on
errorbar(x2, FitParameters2(i2).Values(25:48), FitParameters2(i2).ValuesSTD(25:48), '.-r');
hold off
ylabel('QD');
axis tight

a = axis;
text(a(1)+.02*(a(2)-a(1)), a(3)+.8*(a(4)-a(3)), sprintf('QFA(1) =  %.4f  %.4f',FitParameters1(i1).Values(49), FitParameters2(i2).Values(49)));
text(a(1)+.02*(a(2)-a(1)), a(3)+.7*(a(4)-a(3)), sprintf('QFA(2) =  %.4f  %.4f',FitParameters1(i1).Values(50), FitParameters2(i2).Values(50)));
text(a(1)+.02*(a(2)-a(1)), a(3)+.6*(a(4)-a(3)), sprintf('QFA(3) =  %.4f  %.4f',FitParameters1(i1).Values(51), FitParameters2(i2).Values(51)));
text(a(1)+.02*(a(2)-a(1)), a(3)+.5*(a(4)-a(3)), sprintf('QFA(4) =  %.4f  %.4f',FitParameters1(i1).Values(52), FitParameters2(i2).Values(52)));

text(a(1)+.35*(a(2)-a(1)), a(3)+.8*(a(4)-a(3)), sprintf('QDA(1) =  %.4f  %.4f',FitParameters1(i1).Values(53), FitParameters2(i2).Values(53)));
text(a(1)+.35*(a(2)-a(1)), a(3)+.7*(a(4)-a(3)), sprintf('QDA(2) =  %.4f  %.4f',FitParameters1(i1).Values(54), FitParameters2(i2).Values(54)));
text(a(1)+.35*(a(2)-a(1)), a(3)+.6*(a(4)-a(3)), sprintf('QDA(3) =  %.4f  %.4f',FitParameters1(i1).Values(55), FitParameters2(i2).Values(55)));
text(a(1)+.35*(a(2)-a(1)), a(3)+.5*(a(4)-a(3)), sprintf('QDA(4) =  %.4f  %.4f',FitParameters1(i1).Values(56), FitParameters2(i2).Values(56)));
text(a(1)+.35*(a(2)-a(1)), a(3)+.4*(a(4)-a(3)), sprintf('QDA(5) =  %.4f  %.4f',FitParameters1(i1).Values(57), FitParameters2(i2).Values(57)));
text(a(1)+.35*(a(2)-a(1)), a(3)+.3*(a(4)-a(3)), sprintf('QDA(6) =  %.4f  %.4f',FitParameters1(i1).Values(58), FitParameters2(i2).Values(58)));

text(a(1)+.7*(a(2)-a(1)), a(3)+.8*(a(4)-a(3)), sprintf('BEND =  %.4f  %.4f',FitParameters1(i1).Values(59), FitParameters2(i2).Values(59)));


H = addlabel(0,0,sprintf('Blue - %s    Red - %s', FileName1, FileName2));
set(H, 'Interpreter','None');

orient tall




nFig = nFig + 1;
figure(nFig);
clf reset

x1 = 1:24;
x2 = 1:24;

subplot(3,1,1);
errorbar(x1, FitParameters1(i1).Values(60:83), FitParameters1(i1).ValuesSTD(60:83), '.-b');
hold on
errorbar(x2, FitParameters2(i2).Values(60:83), FitParameters2(i2).ValuesSTD(60:83), '.-r');
hold off
title(sprintf('Skew Quadrupole Fits'));
ylabel('SQSF');
axis tight


subplot(3,1,2);
errorbar(x1, FitParameters1(i1).Values(84:107), FitParameters1(i1).ValuesSTD(84:107), '.-b');
hold on
errorbar(x2, FitParameters2(i2).Values(84:107), FitParameters2(i2).ValuesSTD(84:107), '.-r');
hold off
ylabel('SQSD');
axis tight


subplot(3,1,3);
errorbar(x1, FitParameters1(i1).Values(108:131), FitParameters1(i1).ValuesSTD(108:131), '.-b');
hold on
errorbar(x2, FitParameters2(i2).Values(108:131), FitParameters2(i2).ValuesSTD(108:131), '.-r');
hold off
ylabel('SQQF');
axis tight


H = addlabel(0,0,sprintf('Blue - %s    Red - %s', FileName1, FileName2));
set(H, 'Interpreter','None');

orient tall


