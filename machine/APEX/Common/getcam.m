function [Cam, CamImage] = getcam(CamName, NumberOfAverages, NumberOfImages, PlotFlag)
%GETCAM - Get camera image
%
% [Cam, CamImage] = getcam(CamName, NumberOfAverages, NumberOfImages, PlotFlag)
%
% To plot:
% ImageData = reshape(Cam.Data(1,:), Cam.Cols, Cam.Rows)';
% imagesc(ImageData, 2^14);
%
% See also beamviewer

% Monitors?
% lcaSetMonitor('LCam1:image1:ArrayData')
% lcaNewMonitorValue('LCam1:image1:ArrayData')
% tic;d = lcaGet(['LCam1:image1:ArrayData'],1392640); toc
% Elapsed time is 0.065527 seconds.


% Written by Greg Portmann


FrameTimeOut = 5;

if nargin < 1 || isempty(CamName)
    if strcmpi(getmachinename, 'APEX')
        %Cam.Name = 'LCam1';
        Cam.Name = 'SCam1';
    elseif strcmpi(getmachinename, 'ALS')
        Cam.Name = 'LTB1';
    else
    end
elseif ischar(CamName) 
    Cam.Name = CamName;
%else isstruct(CamName) 
%else
end

if nargin < 2 || isempty(NumberOfAverages)
    Cam.NumberOfAverages = 1;
else
    Cam.NumberOfAverages = NumberOfAverages;
end

if nargin < 3 || isempty(NumberOfImages)
    Cam.NumberOfImages = 1;
else
    Cam.NumberOfImages = NumberOfImages;
end

if nargin < 4
    PlotFlag = 0;
end


% % Camera's can use huge network bandwidth
% % * If the trigger is fast (MHz at APEX), Single shot mode is best
% % * The 1.4 seconds ALS injection trigger can use Sync1
% setpvonline([Cam.Name, ':cam1:ImageMode'],   'Single');
% setpvonline([Cam.Name, ':cam1:NumImages'],   1);   % One image per start
% setpvonline([Cam.Name, ':cam1:TriggerMode'], 'Free Run');  % Sync1 (ALS), Sync2 (APEX)
% 
% % Starting image number
% %[ImageNumber0, t0, ImageTime0] = getpv([Cam.Name, ':cam1:ArrayCounter_RBV']);
% %linktime2datenum(); % If not using getpv
% %datestr(ImageTime0)
% 
% % Is the camera disabled?
% Test = getpvonline([Cam.Name, ':image1:EnableCallbacks_RBV'], 'double');
% if Test == 0
%     % Enable (0->Disable)
%     setpv('GTB:image1:EnableCallbacks', 1);
% end
% 
% % Are arrary callback enabled?
% Test = getpvonline([Cam.Name, ':cam1:ArrayCallbacks_RBV'], 'double');
% if Test == 0
%     % Enable (0->Disable)
%     setpv('GTB:cam1:ArrayCallbacks', 1);
% end
% 
% Is the camera acquiring?
% IsAcquire = getpv([Cam.Name, ':cam1:Acquire']);
% if IsAcquire == 0
%     setpvonline([Cam.Name, ':cam1:Acquire'], 1, 'native', 1);
%     pause(.1);
% end


%ImageMode = getpv([Cam.Name, ':cam1:ImageMode']);
% if ImageMode == 0
%     setpvonline([Cam.Name, ':cam1:Acquire'], 1);
%     pause(.1);
% elseif ImageMode == 1
%     fprintf('   Not sure what to do in Multiple mode  -- yet!\n');
%     return
% end


% Setup Cam structure
Cam.Data = [];    % Placeholder
Cam.Cols = [];    % Placeholder
Cam.Rows = [];    % Placeholder
%Cam.ImageNumber   = ImageNumber0; % getpvonline([Cam.Name, ':cam1:ArrayCounter_RBV']);
%Cam. = getpvonline([Cam.Name, ':cam1:']);


%if Cam.ImageNumber == 0
%    error(sprintf('No image on CCD %s', Cam.Name));
%    return
%end


% Get images
if Cam.NumberOfAverages == 0
    i = 1; j = 1;
    Cam.Cols = getpv([Cam.Name, ':cam1:ArraySizeX_RBV']);  % or cam1:SizeX_RBV
    Cam.Rows = getpv([Cam.Name, ':cam1:ArraySizeY_RBV']);  % or cam1:SizeY_RBV
    Cam.ColOffset = getpv([Cam.Name, ':cam1:MinX_RBV']) - 1;
    Cam.RowOffset = getpv([Cam.Name, ':cam1:MinY_RBV']) - 1;
    Cam.ImageNumber(i,j) = getpv([Cam.Name, ':cam1:ArrayCounter_RBV']);
    [Data(j,:), tout, DataTime] = getpvonline([Cam.Name, ':image1:ArrayData'],'native',Cam.Rows*Cam.Cols);
    Cam.ImageNumber(i,j) = getpv([Cam.Name, ':cam1:ArrayCounter_RBV']);
    
    Cam.DataTime(i,j) = labca2datenum(DataTime);
    
    if PlotFlag > 0
        figure(PlotFlag);
        imagesc(reshape(Data(j,:), Cam.Cols, Cam.Rows)', [0 2^12-1]);
        colormap(jet);
        axis image
        title(sprintf('Camera %s, Image number %d', Cam.Name, Cam.ImageNumber(i,j)));
        drawnow;
    end
    
    % Compute average (camera data can be uint8 or uint16)
    Cam.Data(i,:) = uint16(mean(Data,1));
else
    for i = 1:Cam.NumberOfImages
        for j = 1:Cam.NumberOfAverages
            Cam.ImageNumber(i,j) = getpv([Cam.Name, ':cam1:ArrayCounter_RBV']);
            %fprintf('ImageNumber0 = %d\n',Cam.ImageNumber(i,j));
            
            % Force 1 acquire
            % setpvonline([Cam.Name, ':cam1:Acquire'], 'Acquire', 'char', 1);
            
            % Wait for the next image
            %if i < Cam.NumberOfImages && j < Cam.NumberOfAverages
            t0 = gettime;
            
            ImageNumber = getpv([Cam.Name, ':cam1:ArrayCounter_RBV']);
            %fprintf('ImageNumber  = %d\n',ImageNumber);
            while (ImageNumber <= Cam.ImageNumber(i,j)) && ((gettime-t0) < FrameTimeOut)
                %pause(.1);
                ImageNumber = getpv([Cam.Name, ':cam1:ArrayCounter_RBV']);
                %fprintf('ImageNumber  = %d\n',ImageNumber);
                
                if (gettime-t0) > 1
                    % Force 1 acquire
                    %setpvonline([Cam.Name, ':cam1:Acquire'], 'Acquire', 'char', 1);
                end
            end
            if ImageNumber <= Cam.ImageNumber(i,j)
                Cam
                Cam.ImageNumber
                error(sprintf('Timed-out (%.1f seconds) waiting for a new image', gettime-t0));
            end
            %end
            
            %pause(0);  % was .1???
            
            if i==1 && j==1
                Cam.Cols = getpv([Cam.Name, ':cam1:ArraySizeX_RBV']);  % or cam1:SizeX_RBV
                Cam.Rows = getpv([Cam.Name, ':cam1:ArraySizeY_RBV']);  % or cam1:SizeY_RBV
                
                Cam.ColOffset = getpv([Cam.Name, ':cam1:MinX_RBV']) - 1;
                Cam.RowOffset = getpv([Cam.Name, ':cam1:MinY_RBV']) - 1;
            else
                % Check that nothing changed???
            end
            
            [Data(j,:), tout, DataTime] = getpvonline([Cam.Name, ':image1:ArrayData'],'native',Cam.Rows*Cam.Cols);
            Cam.ImageNumber(i,j) = getpv([Cam.Name, ':cam1:ArrayCounter_RBV']);
            
            Cam.DataTime(i,j) = labca2datenum(DataTime);
            
            if PlotFlag > 0
                figure(PlotFlag);
                imagesc(reshape(Data(j,:), Cam.Cols, Cam.Rows)', [0 2^12-1]);
                colormap(jet);
                axis image
                title(sprintf('Camera %s, Image number %d', Cam.Name, Cam.ImageNumber(i,j)));
                drawnow;
            end
        end
        
        % Compute average (camera data can be uint8 or uint16)
        Cam.Data(i,:) = uint16(mean(Data,1));
    end
end

% Setup info
Cam.Gain          = getpvonline([Cam.Name, ':cam1:Gain_RBV']);
Cam.AcquireTime   = getpvonline([Cam.Name, ':cam1:AcquireTime_RBV']);
Cam.AcquirePeriod = getpvonline([Cam.Name, ':cam1:AcquirePeriod_RBV']);
Cam.Trigger       = getpvonline([Cam.Name, ':cam1:TriggerMode_RBV']);
Cam.DataType      = getpvonline([Cam.Name, ':cam1:DataType_RBV'],'char');
%Cam. = getpvonline([Cam.Name, ':cam1:']);


% For Testing
%[xx,yy] = meshgrid(((0:(Cam.Cols-1))/Cam.Cols)+.5, ((0:(Cam.Rows-1))/Cam.Rows+.5));
%Cam.Data = 100000*(sinc(3*xx) + sinc(5*yy))';
%Cam.Data = Cam.Data(:)';

if nargout == 0
    if strcmpi(Cam.DataType, 'UInt8')
        %imagesc(Cam.Data(1,:), [0 2^14-1]);
        imagesc(reshape(Cam.Data(1,:), Cam.Cols, Cam.Rows)', [0 2^8]);
    else
        % UInt16
        imagesc(reshape(Cam.Data(1,:), Cam.Cols, Cam.Rows)', [0 2^12]);
    end
    colormap(gray);
    axis image
    title(sprintf('Image Number %d',Cam.ImageNumber));
elseif nargout >= 2
    CamImage = reshape(Cam.Data, Cam.Cols, Cam.Rows)';
end

