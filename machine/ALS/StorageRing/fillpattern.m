function [AllBuckets, LowCurrentBuckets, CamBuckets] = fillpattern(Mode)
% [AllBuckets, LowCurrentBuckets, CamBuckets] = fillpattern(Mode)
%
%     Dual-Cam
%    1:128     128
%      150       1
%  159:302     144
%      318       1
%             ====
%              274 out of 328
%  Note: Cam-buckets are not symmetric
%
%     Single-Cam
%    1:276     276 ???
%      318       1
%             ====
%              278 out of 328
%
%     Two-Bunch (symmetric)
%      154
%      318
%  Note: Cam-buckets are symmetric
%        Just offset 10 from halfway (164) and the end (328)


if nargin < 1
    Mode = 'Dual Cam';
end

if any(strcmpi(Mode,{'Dual Cam','Dual-Cam','DualCam'}))
    % Dual-Cam
    AllBuckets = zeros(1,328);
    AllBuckets([1:128 150 159:302 318]) = 1;
    LowCurrentBuckets = [1:128 159:302];
    CamBuckets = [150 318];
    
elseif any(strcmpi(Mode,{'PseudoSingleBunch','Pseudo Single Bunch'}))
    % 
    NShift = 26;  % was 15
    AllBuckets = zeros(1,328);
    AllBuckets([(1:276)+NShift 318]) = 1;
    LowCurrentBuckets = (1:276)+NShift;  % 276 or 276+8???
    CamBuckets = 318;
    
%     FP0 = [ ...
%         9:16:(272-12) 10:16:(272-12) 11:16:(272-12) 12:16:(272-12) ...
%         1:16:(272-12)  2:16:(272-12)  3:16:(272-12)  4:16:(272-12)];     % 272 bunch, 4 gun bunches, MB fill pattern
%     FP0 = FP0 + 15;
%     FP = sort([FP0 FP0+4 FP0+8 FP0+12]);

elseif any(strcmpi(Mode,{'Single Cam','Single-Cam','SingleCam'}))
    % Single-Cam
    AllBuckets = zeros(1,328);
    AllBuckets([1:276 318]) = 1;
    LowCurrentBuckets = 1:276;  % 276 or 276+8???
    CamBuckets = 318;
    
elseif any(strcmpi(Mode,{'Two Bunch','Two-Bunch','Two-Bunch'}))
    % Two-Bunch
    AllBuckets = zeros(1,328);
    AllBuckets([154 318]) = 1;
    LowCurrentBuckets = [];
    CamBuckets = [154 318];
end




if 0
    subplot(2,1,2);
    CurrCam = 5.5;
    CurrLow = (500-length(CamBuckets)*CurrCam)/length(LowCurrentBuckets);
    plot(LowCurrentBuckets,CurrLow,'.b','markersize',14);
    hold on
    plot(CamBuckets,CurrCam,'.b','markersize',20);
    hold off
    axis([1 328 -.5 6]);
    xlabel('Bunch Number');
    ylabel('Current [mAmps]');
    %title('Pseudo Single Bunch');
    title('Single Cam Fill Pattern');
    %title('Dual Cam Fill Pattern');
end

