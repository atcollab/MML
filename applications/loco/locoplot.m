function ElementsInput = locoplot(FileName, IterationNumber, PlotString, PlaneString, ElementsInput)
%LOCOPLOT - Subroutines for plotting LOCO output
%  locoplot(FileName, IterationNumber, PlotString, PlaneString, Elements)
%  locoplot({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}, IterationNumber, PlotString, PlaneString, Elements)
%
%  INPUTS
%  1. FileName = data file name
%  2. IterationNumber = 0, 1, 2, etc
%       or
%  1. BPMData
%  2. CMData
%  3. LocoMeasData
%  4. LocoModel
%  5. FitParameters
%  6. LocoFlags
%  7. RINGData
%
%  What data to plot:
%     PlotString = 'Model', 'Measured', 'Model-Measured', , 'Model-Measured+EnergyShifts'
%
%  For 3-D surf plots of the entire response matrix:
%     PlaneString = 'XX', 'YY', 'XY', 'YX', 'All' 
%
%  For 2-D row (BPM) or column (CM) plots:
%     PlaneString = 'HBPM', 'VBPM', 'HCM', 'VCM'
%     Elements = element number within the response matrix (based on HBPMIndex,VBPMIndex,HCMIndex,VCMIndex) 
%
%  Written by Greg Portmann

if ~nargin == 5
    error('Requires 5 inputs (see help locoplot).');
end

if isempty(FileName)
    return;
end

if iscell(FileName)
    BPMData       = FileName{1};
    CMData        = FileName{2};
    LocoMeasData  = FileName{3};
    LocoModel     = FileName{4};
    FitParameters = FileName{5};
    LocoFlags     = FileName{6};
    RINGData      = FileName{7};
elseif isstr(FileName)    
    try
        load(FileName);
    catch
        fprintf('   LOCOPLOT:  File does not exist or is not a *.mat file type.\n'); return;
    end    
else
    error('Input problem');
end

legend off

if length(BPMData) > 1
    IterationNumber = IterationNumber + 1;
    if IterationNumber > length(BPMData)
        fprintf('   LOCOPLOT:  The data file only has %d iterations.  Hence, the input InterationNumber cannot be %d.\n', length(BPMData)-1, IterationNumber-1);
        return
    end
    
    BPMData = BPMData(IterationNumber);
    CMData = CMData(IterationNumber);
    LocoModel = LocoModel(IterationNumber);
    FitParameters = FitParameters(IterationNumber);
    LocoFlags = LocoFlags(IterationNumber);
end

% if isempty(LocoModel.M)
%     fprintf('   LOCOPLOT:  Model data is empty.\n'); 
%     return;
% end
if isempty(LocoMeasData.M)
    fprintf('   LOCOPLOT:  Measured data is empty. \n'); 
    return;
end

Mmodel = LocoModel.M;

Outliers = LocoModel.OutlierIndex;

Mmeas = LocoMeasData.M;
Mmeas = Mmeas([BPMData.HBPMGoodDataIndex(:)' length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex(:)'], [CMData.HCMGoodDataIndex(:)' length(CMData.HCMIndex)+CMData.VCMGoodDataIndex(:)']); 

NHBPM = length(BPMData.HBPMGoodDataIndex);
NVBPM = length(BPMData.VBPMGoodDataIndex);
NBPM  = NHBPM + NVBPM;
NHCM = length(CMData.HCMGoodDataIndex);
NVCM = length(CMData.VCMGoodDataIndex);

% Mark the outliers with NaN
if isempty(Mmodel)
    Mmodel = NaN * Mmeas;
else
    Mmodel = Mmodel(:);
    Mmodel(Outliers) = NaN; 
    Mmodel = reshape(Mmodel,  NBPM, NHCM+NVCM);
end

if strcmp(lower(PlotString),'model')
    data = Mmodel;
elseif strcmp(lower(PlotString),'measured')
    data = Mmeas;
elseif strcmp(lower(PlotString),'model-measured')
    data = Mmodel-Mmeas;
elseif strcmp(lower(PlotString),'model-measured+energyshifts')
    %[Model, Meas] = locodata(FileName, IterationNumber-1, 'ResponseMatrix', 'Model+EnergyShift', 'ResponseMatrix', 'Meas');
    
    % Add the dispersion term (measured) to the model response matrix
    HCMEnergyShift = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
    VCMEnergyShift = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);
    
    % Set the lattice model
    for j = 1:length(FitParameters.Params)
        RINGData = locosetlatticeparam(RINGData, FitParameters.Params{j}, FitParameters.Values(j));
    end
    AlphaMCF = locomcf(RINGData);
    EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    
    for i = 1:length(HCMEnergyShift)
        Mmodel(:,i) = Mmodel(:,i) + HCMEnergyShift(i) * [EtaXmcf; EtaYmcf];
    end
    
    for i = 1:length(VCMEnergyShift)
        Mmodel(:,NHCM+i) = Mmodel(:,NHCM+i) + VCMEnergyShift(i) * [EtaXmcf; EtaYmcf];
    end
    data = Mmodel-Mmeas;
else
    error('   PlotString unknown type.');
end

PlaneString = upper(PlaneString);

if strcmp(PlaneString,'XX') | strcmp(PlaneString,'YY') | strcmp(PlaneString,'YX') | strcmp(PlaneString,'XY') | strcmp(PlaneString,'ALL')
    % 3-D Plots    
    if strcmp(PlaneString,'XX')
        % XX
        [X,Y] = meshgrid(BPMData.HBPMGoodDataIndex, CMData.HCMGoodDataIndex);
        surf(X, Y, data(1:NHBPM,1:NHCM)');
        ylabel('HCM #');
        xlabel('HBPM #');
        
    elseif strcmp(PlaneString,'YY')
        % YY
        [X,Y] = meshgrid(BPMData.VBPMGoodDataIndex, CMData.VCMGoodDataIndex);
        surf(X, Y, data(NHBPM+1:NHBPM+NVBPM,NHCM+1:NHCM+NVCM)');
        ylabel('VCM #');
        xlabel('VBPM #');
    elseif strcmp(PlaneString,'XY')
        % XY
        [X,Y] = meshgrid(BPMData.HBPMGoodDataIndex, CMData.VCMGoodDataIndex);
        surf(X, Y, data(1:NHBPM,NHCM+1:NHCM+NVCM)');
        ylabel('VCM #');
        xlabel('HBPM #');
        
    elseif strcmp(PlaneString,'YX')
        % YX
        [X,Y] = meshgrid(BPMData.VBPMGoodDataIndex, CMData.HCMGoodDataIndex);
        surf(X, Y, data(NHBPM+1:NHBPM+NVBPM,1:NHCM)');
        ylabel('HCM #');
        xlabel('VBPM #');
    elseif strcmp(PlaneString,'ALL')
        % All
        surf(data');
        %ylabel('CM''s');
        %xlabel('BPM''s');
        
        % Change label to BPM numbers
        [Ny,Nx] = size(data');
        Ticks = 1:ceil(Nx/10):Nx;
        set(gca, 'XTick', Ticks);      
        TickNumber = [BPMData.HBPMGoodDataIndex(:)' BPMData.VBPMGoodDataIndex(:)'];
        TickNumber = TickNumber(Ticks);
        set(gca, 'XTickLabel', num2cell(TickNumber));         
        xlabel('HBPM# and VBPM#');

        % Change label to HCM and VCM numbers
        Ticks = 1:ceil(Ny/10):Ny;
        set(gca, 'YTick', Ticks);      
        TickNumber = [CMData.HCMGoodDataIndex(:)' CMData.VCMGoodDataIndex(:)'];
        TickNumber = TickNumber(Ticks);
        set(gca, 'YTickLabel', num2cell(TickNumber));         
        ylabel('HCM# and VCM#');
    else
        fprintf('   LOCOPLOT:  PlaneString unknown. \n'); 
        return;        
    end
    
    
    if strcmp(lower(PlotString),'model')
        title('Model Response Matrix');
        zlabel('[mm]');
    elseif strcmp(lower(PlotString),'measured')
        title('Measured Response Matrix');
        zlabel('[mm]');
    elseif strcmp(lower(PlotString),'model-measured')
        title('Model - Measured Response Matrix');
        zlabel('Error [mm]');
    elseif strcmp(lower(PlotString),'model-measured+energyshifts')
        title('Model-Measured+EnergyShifts Response Matrix');
        zlabel('Error [mm]');
    end
    
    % For some reason axis tight has a problem with 3-D plots with only NaN's
    if ~all(isnan(data))
        axis tight
    end
end


% 2-D plots

if strcmp(PlaneString,'HBPM')
    BPMData.BPMIndex = BPMData.BPMIndex(:);
    if ~exist('ElementsInput','var')
        ElementsInput = locoeditlist([BPMData.HBPMGoodDataIndex(:) BPMData.BPMIndex(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex))], PlaneString, zeros(length(BPMData.HBPMGoodDataIndex),1));
        if isempty(ElementsInput)
            return
        end
        ElementsInput = ElementsInput(:,1)';
    end
    if isempty(ElementsInput)
        ElementsInput = locoeditlist([BPMData.HBPMGoodDataIndex(:) BPMData.BPMIndex(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex))], PlaneString, zeros(length(BPMData.HBPMGoodDataIndex),1));
        if isempty(ElementsInput)
            return
        end
        ElementsInput = ElementsInput(:,1)';
    end
    
    % Convert to elements in the HBPMGoodDataIndex vector
    [tmp1, tmp2, Elements] = intersect(ElementsInput, BPMData.HBPMGoodDataIndex);
    
    if ~isempty(Elements)
        plot(data(Elements,:)');
        
        % Change label to HCM and VCM numbers
        N = NHCM + NVCM;
        Ticks = 1:ceil(N/10):N;
        set(gca, 'XTick', Ticks);      
        TickNumber = [CMData.HCMGoodDataIndex(:)' CMData.VCMGoodDataIndex(:)'];
        TickNumber = TickNumber(Ticks);
        set(gca, 'XTickLabel', num2cell(TickNumber));         
        xlabel('Horizontal and Vertical Corrector Magnets');
        
        if strcmp(lower(PlotString),'model')
            title('Model Response Matrix');
            if length(Elements) == 1
                ylabel(sprintf('Horizontal BPM(%d) [mm]', BPMData.HBPMGoodDataIndex(Elements)));
            else
                ylabel('Horizontal BPM [mm]');
            end
        elseif strcmp(lower(PlotString),'measured')
            title('Measured Response Matrix');
            if length(Elements) == 1
                ylabel(sprintf('Horizontal BPM(%d) [mm]', BPMData.HBPMGoodDataIndex(Elements)));
            else
                ylabel('Horizontal BPM [mm]');
            end
        elseif strcmp(lower(PlotString),'model-measured')
            title('Model - Measured Response Matrix');
            if length(Elements) == 1
                ylabel(sprintf('Horizontal Error BPM(%d) [mm]', BPMData.HBPMGoodDataIndex(Elements)));
            else
                ylabel('Horizontal BPM Error [mm]');
            end
        elseif strcmp(lower(PlotString),'model-measured+energyshifts')
            title('Model-Measured+EnergyShifts Response Matrix');
            if length(Elements) == 1
                ylabel(sprintf('Horizontal Error BPM(%d) [mm]', BPMData.HBPMGoodDataIndex(Elements)));
            else
                ylabel('Horizontal BPM Error [mm]');
            end
        end
        
        % Only put a legend up to size 10
        if length(Elements)>1 & length(Elements)<=10
            for i = 1:length(Elements)
                legendstr{i} = sprintf('BPM(%d)',BPMData.HBPMGoodDataIndex(Elements(i)));
            end
            legend(legendstr,0);
        end
        axis tight
    end
end


if strcmp(PlaneString,'VBPM')
    BPMData.BPMIndex = BPMData.BPMIndex(:);
    if ~exist('ElementsInput','var')
        ElementsInput = locoeditlist([BPMData.VBPMGoodDataIndex(:) BPMData.BPMIndex(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex))], PlaneString, zeros(length(BPMData.VBPMGoodDataIndex),1));
        if isempty(ElementsInput)
            return
        end
        ElementsInput = ElementsInput(:,1)';
    end
    if isempty(ElementsInput)
        ElementsInput = locoeditlist([BPMData.VBPMGoodDataIndex(:) BPMData.BPMIndex(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex))], PlaneString, zeros(length(BPMData.VBPMGoodDataIndex),1));
        if isempty(ElementsInput)
            return
        end
        ElementsInput = ElementsInput(:,1)';
    end
    
    % Convert to elements in the HBPMGoodDataIndex vector
    [tmp1, tmp2, Elements] = intersect(ElementsInput, BPMData.VBPMGoodDataIndex);
    
    if ~isempty(Elements)
        plot(data(NHBPM+Elements,:)');
        
        % Change label to HCM and VCM numbers
        N = NHCM + NVCM;
        Ticks = 1:ceil(N/10):N;
        set(gca, 'XTick', Ticks);      
        TickNumber = [CMData.HCMGoodDataIndex(:)' CMData.VCMGoodDataIndex(:)'];
        TickNumber = TickNumber(Ticks);
        set(gca, 'XTickLabel', num2cell(TickNumber));         
        xlabel('Horizontal and Vertical Corrector Magnets');
        
        if strcmp(lower(PlotString),'model')
            title('Model Response Matrix');
            if length(Elements) == 1
                ylabel(sprintf('Vertical BPM(%d) [mm]', BPMData.VBPMGoodDataIndex(Elements)));
            else
                ylabel('Vertical BPM [mm]');
            end
        elseif strcmp(lower(PlotString),'measured')
            title('Measured Response Matrix');
            if length(Elements) == 1
                ylabel(sprintf('Vertical BPM(%d) [mm]', BPMData.VBPMGoodDataIndex(Elements)));
            else
                ylabel('Vertical BPM [mm]');
            end
        elseif strcmp(lower(PlotString),'model-measured')
            title('Model - Measured Response Matrix');
            if length(Elements) == 1
                ylabel(sprintf('Vertical Error BPM(%d) [mm]', BPMData.VBPMGoodDataIndex(Elements)));
            else
                ylabel('Vertical BPM Error [mm]');
            end
        elseif strcmp(lower(PlotString),'model-measured+energyshifts')
            title('Model-Measured+EnergyShifts Response Matrix');
            if length(Elements) == 1
                ylabel(sprintf('Vertical Error BPM(%d) [mm]', BPMData.VBPMGoodDataIndex(Elements)));
            else
                ylabel('Vertical BPM Error [mm]');
            end
        end
        
        % Only put a legend up to size 10
        if length(Elements)>1 & length(Elements)<=10
            for i = 1:length(Elements)
                legendstr{i} = sprintf('BPM(%d)',BPMData.VBPMGoodDataIndex(Elements(i)));
            end
            legend(legendstr,0);
        end
        axis tight
    end
end


if strcmp(PlaneString,'HCM')   
    CMData.HCMGoodDataIndex = CMData.HCMGoodDataIndex(:)';
    CMData.HCMIndex = CMData.HCMIndex(:);
    if ~exist('ElementsInput','var')
        ElementsInput = locoeditlist([CMData.HCMGoodDataIndex(:) CMData.HCMIndex(CMData.HCMGoodDataIndex)], PlaneString, zeros(length(CMData.HCMGoodDataIndex),1));
        if isempty(ElementsInput)
            return
        end
        ElementsInput = ElementsInput(:,1)';
    end
    if isempty(ElementsInput)
        ElementsInput = locoeditlist([CMData.HCMGoodDataIndex(:) CMData.HCMIndex(CMData.HCMGoodDataIndex)], PlaneString, zeros(length(CMData.HCMGoodDataIndex),1));
        if isempty(ElementsInput)
            return
        end
        ElementsInput = ElementsInput(:,1)';
    end

    % Convert to elements in the HCMGoodDataIndex vector
    [tmp1, tmp2, Elements] = intersect(ElementsInput, CMData.HCMGoodDataIndex);
    
    if ~isempty(Elements)
        plot(data(:,Elements));

        % Change label to BPM numbers
        N = NBPM;
        Ticks = 1:ceil(N/10):N;
        set(gca, 'XTick', Ticks);      
        TickNumber = [BPMData.HBPMGoodDataIndex(:)' BPMData.VBPMGoodDataIndex(:)'];
        TickNumber = TickNumber(Ticks);
        set(gca, 'XTickLabel', num2cell(TickNumber));         
        xlabel('Horizontal and Vertical BPM Numbers');
                
        if strcmp(lower(PlotString),'model')
            title('Model Response Matrix');
            if length(ElementsInput) == 1
                ylabel(sprintf('HCM(%d) [mm]', ElementsInput));
            else
                ylabel('HCM [mm]');
            end
        elseif strcmp(lower(PlotString),'measured')
            title('Measured Response Matrix');
            if length(ElementsInput) == 1
                ylabel(sprintf('HCM(%d) [mm]', ElementsInput));
            else
                ylabel('HCM [mm]');
            end
        elseif strcmp(lower(PlotString),'model-measured')
            title('Model - Measured Response Matrix');
            if length(ElementsInput) == 1
                ylabel(sprintf('HCM(%d) Error [mm]', ElementsInput));
            else
                ylabel('HCM Error [mm]');
            end
        elseif strcmp(lower(PlotString),'model-measured+energyshifts')
            title('Model-Measured+EnergyShifts Response Matrix');
            if length(ElementsInput) == 1
                ylabel(sprintf('HCM(%d) Error [mm]', ElementsInput));
            else
                ylabel('HCM Error [mm]');
            end
        end
        
        % Only put a legend up to size 10
        if length(ElementsInput)>1 & length(ElementsInput)<=10
            for i = 1:length(ElementsInput)
                legendstr{i} = sprintf('HCM(%d)',ElementsInput(i));
            end
            legend(legendstr,0);
        end
        axis tight
    end
end



if strcmp(PlaneString,'VCM')
    CMData.VCMGoodDataIndex = CMData.VCMGoodDataIndex(:)';
    CMData.VCMIndex = CMData.VCMIndex(:);
    if ~exist('ElementsInput','var')
        ElementsInput = locoeditlist([CMData.VCMGoodDataIndex(:) CMData.VCMIndex(CMData.VCMGoodDataIndex)], PlaneString, zeros(length(CMData.VCMGoodDataIndex),1));
        if isempty(ElementsInput)
            return
        end
        ElementsInput = ElementsInput(:,1)';
    end
    if isempty(ElementsInput)
        ElementsInput = locoeditlist([CMData.VCMGoodDataIndex(:) CMData.VCMIndex(CMData.VCMGoodDataIndex)], PlaneString, zeros(length(CMData.VCMGoodDataIndex),1));
        if isempty(ElementsInput)
            return
        end
        ElementsInput = ElementsInput(:,1)';
    end
            
    % Convert to elements in the VCMGoodDataIndex vector
    [tmp1, tmp2, Elements] = intersect(ElementsInput, CMData.VCMGoodDataIndex);
    
    if ~isempty(Elements)
        plot(data(:,NHCM+Elements));
        
        % Change label to BPM numbers
        N = NBPM;
        Ticks = 1:ceil(N/10):N;
        set(gca, 'XTick', Ticks);      
        TickNumber = [BPMData.HBPMGoodDataIndex(:)' BPMData.VBPMGoodDataIndex(:)'];
        TickNumber = TickNumber(Ticks);
        set(gca, 'XTickLabel', num2cell(TickNumber));         
        xlabel('Horizontal and Vertical BPM Numbers');
                
        if strcmp(lower(PlotString),'model')
            title('Model Response Matrix');
            if length(Elements) == 1
                ylabel(sprintf('VCM(%d) [mm]', CMData.VCMGoodDataIndex(Elements)));
            else
                ylabel('VCM [mm]');
            end
        elseif strcmp(lower(PlotString),'measured')
            title('Measured Response Matrix');
            if length(Elements) == 1
                ylabel(sprintf('VCM(%d) [mm]', CMData.VCMGoodDataIndex(Elements)));
            else
                ylabel('VCM [mm]');
            end
        elseif strcmp(lower(PlotString),'model-measured')
            title('Model - Measured Response Matrix');
            if length(Elements) == 1
                ylabel(sprintf('VCM(%d) Error [mm]', CMData.VCMGoodDataIndex(Elements)));
            else
                ylabel('VCM Error [mm]');
            end
        elseif strcmp(lower(PlotString),'model-measured+energyshifts')
            title('Model-Measured+EnergyShifts Response Matrix');
            if length(Elements) == 1
                ylabel(sprintf('VCM(%d) Error [mm]', CMData.VCMGoodDataIndex(Elements)));
            else
                ylabel('VCM Error [mm]');
            end
        end
        
        % Only put a legend up to size 10
        if length(Elements)>1 & length(Elements)<=10
            for i = 1:length(Elements)
                legendstr{i} = sprintf('VCM(%d)',CMData.VCMGoodDataIndex(Elements(i)));
            end
            legend(legendstr,0);
        end
        axis tight
    end
end

if ~exist('ElementsInput','var') & nargout > 0
    ElementsInput = [];
end
