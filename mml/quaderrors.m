function QMS = quaderrors(Input1, FigureHandle, MontiCarloFlag)
%QUADERRORS - Computes the error bars for quadrupole center measurement
%  QMS = quaderrors(FileName, FigureHandle, MontiCarloFlag)

% Written by Greg Portmann


Buffer = .03;
HeightBuffer = .08;

    
% Don't do the monticarlo plot if being called from quadplot
MontiCarloFlag = 1;
[ST,I] = dbstack;
for i = 1:length(ST)
    if strcmpi(ST(i).file,'quadplot.m')
        MontiCarloFlag = 0;
    end
end


% Inputs
try
    WarningString = [];
    if nargin == 0
        [FileName, PathName] = uigetfile('*.mat', 'Input Quadrupole Center file.');
        if ~isstr(FileName)
            return
        else
            eval(['load ',PathName,FileName]);
        end
    else
        if isstr(Input1)
            FileName = Input1;
            eval(['load ', FileName]);
        elseif isempty(Input1)
            [FileName, PathName] = uigetfile('*.mat', 'Input Quadrupole Center file.');
            if ~isstr(FileName)
                return
            else
                eval(['load ',PathName,FileName]);
            end
        else
            QMS = Input1;
            FileName = [];
        end
    end
catch
    error('Problem getting input data');
end

%QMS = quadplot(QMS);

if nargin < 2
    FigureHandle = gcf;
else
    if all(FigureHandle ~= 0)
        figure(FigureHandle);
    end
end

if all(FigureHandle ~= 0)
    clf reset
    if MontiCarloFlag
        AxesHandles(1) = subplot(3,1,1);
        AxesHandles(2) = subplot(3,1,2);
        AxesHandles(3) = subplot(3,1,3);
    else
        AxesHandles(1) = subplot(2,1,1);
        AxesHandles(2) = subplot(2,1,2);
    end

    if QMS.QuadPlane ~= 1
        %set(FigureHandle,'units','normal','position',[Buffer .25+Buffer .5-Buffer-.003 .75-1.2*Buffer-HeightBuffer]);
        %%set(FigureHandle,'units','normal','position',[0+Buffer .09+Buffer .5-2*Buffer .9-2*Buffer-HeightBuffer]);
    else
        %set(FigureHandle,'units','normal','position',[.5+.003 .25+Buffer .5-Buffer-.003 .75-1.2*Buffer-HeightBuffer]);
        %%set(FigureHandle,'units','normal','position',[.5+Buffer .09+Buffer .5-2*Buffer .9-2*Buffer-HeightBuffer]);
    end

    %subplot(3,2,1);
    axes(AxesHandles(1));
    if any(isinf(QMS.FitParametersStd(:,1)))
        plot(1:length(QMS.FitParameters(:,1)), QMS.FitParameters(:,1),'b');
        hold on;
        plot(1:length(QMS.FitParameters(:,1)), QMS.FitParameters(:,1), '.r');
        plot(QMS.GoodIndex, QMS.FitParameters(QMS.GoodIndex,1), '.b');
    else
        %  User error bars
        errorbar(1:length(QMS.FitParameters(:,1)), QMS.FitParameters(:,1), QMS.FitParametersStd(:,1),'b');
        hold on;
        errorbar(1:length(QMS.FitParameters(:,1)), QMS.FitParameters(:,1), QMS.FitParametersStd(:,1),'.r');
        errorbar(QMS.GoodIndex, QMS.FitParameters(QMS.GoodIndex,1), QMS.FitParametersStd(QMS.GoodIndex,1),'.b');
    end
    hold off
    title('Linear Fit');
    ylabel('Y-Intercept');
    %xlabel('BPM Number');
    grid
    xaxis([0 length(QMS.FitParameters(:,1))+1]);
    
    
    %subplot(3,1,2);
    axes(AxesHandles(2));
    if any(isinf(QMS.FitParametersStd(:,2)))
        plot(1:length(QMS.FitParameters(:,1)), QMS.FitParameters(:,2),'b');
        hold on;
        plot(1:length(QMS.FitParameters(:,1)), QMS.FitParameters(:,2), '.r');
        plot(QMS.GoodIndex, QMS.FitParameters(QMS.GoodIndex,2), '.b');
        hold off
    else
        %  User error bars
        errorbar(1:length(QMS.FitParameters(:,1)), QMS.FitParameters(:,2), QMS.FitParametersStd(:,2),'b');
        hold on
        errorbar(1:length(QMS.FitParameters(:,1)), QMS.FitParameters(:,2), QMS.FitParametersStd(:,2),'.r');
        errorbar(QMS.GoodIndex, QMS.FitParameters(QMS.GoodIndex,2), QMS.FitParametersStd(QMS.GoodIndex,2),'.b');
    end
    hold off
    xlabel('BPM Number');
    ylabel('Slope');
    %xlabel('BPM Number');
    grid
    xaxis([0 length(QMS.FitParameters(:,1))+1]);
end


if MontiCarloFlag
    % Monte Carlo the mean and standard deviation of all the good offsets
    N = 20000;
    QMS.OffsetMean = NaN*ones(length(QMS.FitParameters(:,2)),1);
    QMS.OffsetStd  = NaN*ones(length(QMS.FitParameters(:,2)),1);

    OffsetMean1 = QMS.OffsetMean;
    OffsetStd1  = QMS.OffsetStd;
    NormalRV1 = randn(N,1);
    NormalRV2 = randn(N,1);
    if QMS.QuadraticFit == 1
        NormalRV3 = randn(N,1);
    end
    for i = QMS.GoodIndex(:)'   % 1:length(QMS.Offset)
        rvinter = QMS.FitParameters(i,1) + QMS.FitParametersStd(i,1)*NormalRV1;
        rvslope = QMS.FitParameters(i,2) + QMS.FitParametersStd(i,2)*NormalRV2;
        if QMS.QuadraticFit == 1
            rvquadradic = QMS.FitParameters(i,3) + QMS.FitParametersStd(i,3)*NormalRV3;
            x = (-rvslope + sqrt(rvslope.^2 - 4*rvquadradic.*rvinter)) ./ (2*rvquadradic);
        else
            x = -rvinter ./ rvslope;
        end
        OffsetMean1(i) = mean(x);
        OffsetStd1(i)  = std(x);
    end

    OffsetMean2 = QMS.OffsetMean;
    OffsetStd2  = QMS.OffsetStd;
    NormalRV1 = randn(N,1);
    NormalRV2 = randn(N,1);
    if QMS.QuadraticFit == 1
        NormalRV3 = randn(N,1);
    end
    for i = QMS.GoodIndex(:)'   % 1:length(QMS.Offset)
        rvinter = QMS.FitParameters(i,1) + QMS.FitParametersStd(i,1)*NormalRV1;
        rvslope = QMS.FitParameters(i,2) + QMS.FitParametersStd(i,2)*NormalRV2;
        if QMS.QuadraticFit == 1
            rvquadradic = QMS.FitParameters(i,3) + QMS.FitParametersStd(i,3)*NormalRV3;
            x = (-rvslope + sqrt(rvslope.^2 - 4*rvquadradic.*rvinter)) ./ (2*rvquadradic);
        else
            x = -rvinter ./ rvslope;
        end
        OffsetMean2(i) = mean(x);
        OffsetStd2(i)  = std(x);
    end

    QMS.OffsetMean(:,1) = [OffsetMean1 + OffsetMean2] / 2;
    QMS.OffsetStd(:,1)  = [OffsetStd1  + OffsetStd2]  / 2;


    if all(FigureHandle ~= 0)

        % plot([OffsetStd1  OffsetStd2  OffsetStd3],'x')

        %subplot(3,1,3);
        axes(AxesHandles(3));
        %errorbar(1:length(QMS.Offset), QMS.Offset, QMS.OffsetStd,'.r');
        %hold on
        errorbar(QMS.GoodIndex, QMS.Offset(QMS.GoodIndex), QMS.OffsetStd(QMS.GoodIndex),'.b');


        % errorbar(1:length(QMS.Offset), QMS.Offset, QMS.OffsetStd,'.b');
        % hold on
        % errorbar(1:length(QMS.Offset), QMS.Offset, OffsetStd1,'.r');
        % errorbar(1:length(QMS.Offset), QMS.Offset, OffsetStd2,'.g');
        % errorbar(1:length(QMS.Offset), QMS.Offset, OffsetStd3,'.k');

        % errorbar(QMS.GoodIndex, QMS.Offset(QMS.GoodIndex), QMS.OffsetStd(QMS.GoodIndex),'.b');
        % hold on
        % errorbar(QMS.GoodIndex, QMS.Offset(QMS.GoodIndex), OffsetStd1(QMS.GoodIndex),'.r');
        % errorbar(QMS.GoodIndex, QMS.Offset(QMS.GoodIndex), OffsetStd2(QMS.GoodIndex),'.g');
        % errorbar(QMS.GoodIndex, QMS.Offset(QMS.GoodIndex), OffsetStd3(QMS.GoodIndex),'.k');

        hold off
        ylabel('X-Intercept = - (Y-Intercept)/Slope');
        ylabel('Monte Carlo');
        xlabel('BPM Number');
        grid
        xaxis([0 length(QMS.Offset)+1]);
        %yaxis([-.025 .025]+QMS.Center);
    end

    QMS.OffsetSTDMontiCarlo = sqrt((sum(QMS.OffsetStd(QMS.GoodIndex).^2))/length(QMS.GoodIndex));
end
