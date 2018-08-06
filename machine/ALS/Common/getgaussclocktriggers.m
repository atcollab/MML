function d = getgaussclocktriggers(N)

% Example
% N   = 25;
% Bg  = linspace(.53, .538, 30);
% Ext = linspace(29400, 29500, 30);
% [X, Y] = meshgrid(Bg, Inj);
% 
% for i = 1:length(Bg)
%     for j = 1:length(Ext)
%         d = getgaussclocktriggers(N);
%         InjMesh(i,j)  = mean(d.InjTrigger);
%         BumpMesh(i,j) = mean(d.BumpTrigger);
%         ExtMesh(i,j)  = mean(d.ExtTrigger);
%     end
% end
% 
% surf(X, Y, ExtMesh);


if nargin < 1
    N = 1;
end

HorzPoints = 200000;

WaveCounterLast = getpvonline('ztec16:Inp1WaveCount');

for i = 1:N
    
    WaveCounter = getpvonline('ztec16:Inp1WaveCount');
    
    fprintf('  Waiting for trigger %d\n', i);
    while WaveCounter==0 || WaveCounter == WaveCounterLast
        WaveCounter = getpvonline('ztec16:Inp1WaveCount');
        pause(.1);
    end
    
    WaveCounterLast = WaveCounter;
    
    d.Counter(i,1) = WaveCounter;
    
    t = getpvonline('ztec16:InpScaledTime', 'double',  HorzPoints);
    
    InjTrigger  = NaN;
    ExtTrigger  = NaN;
    BumpTrigger = NaN;
    
    % Injection
    [Data, ~, DataTime] = getpvonline('ztec16:Inp1ScaledWave', 'double', HorzPoints);
    [Tmp,iTrigger] = find(Data > 1);
    if ~isempty(iTrigger)
        InjDelay = .4645;  % DG654 delay [Seconds]
        InjTrigger = t(min(iTrigger)) - InjDelay;
        fprintf('  Injection Trigger  = %13.9f milliseconds from the waveform trigger\n', 1000*InjTrigger);
    end
    
    % Bump
    Data = getpvonline('ztec16:Inp2ScaledWave', 'double', HorzPoints);
    [Tmp,iTrigger] = find(Data > 1);
    if ~isempty(iTrigger)
        BumpDelay = .0054;  % DG654 delay [Seconds]
        BumpTrigger = t(min(iTrigger)) - BumpDelay;
        fprintf('  Bump Trigger       = %13.9f milliseconds from the waveform trigger\n', 1000*BumpTrigger);
    end
    
    % Extraction
    Data = getpvonline('ztec16:Inp3ScaledWave', 'double', HorzPoints);
    [Tmp,iTrigger] = find(Data > 1);
    if ~isempty(iTrigger)
        ExtTrigger = t(min(iTrigger));
        fprintf('  Extraction Trigger = %13.9f milliseconds from the waveform trigger\n\n', 1000*ExtTrigger);
    end
    
    d.Time(i,1)        = linktime2datenum(DataTime);
    d.InjTrigger(i,1)  = InjTrigger;
    d.ExtTrigger(i,1)  = ExtTrigger;
    d.BumpTrigger(i,1) = BumpTrigger;
    d.BucketNumber(i,1)       = getpv('SR01C___TIMING_AC08');
    d.InjTriggerControl(i,1)  = getpv('BR1_____TIMING_AM00');
    d.BumpTriggerControl(i,1) = getpv('BR1_____TIMING_AM01');
    d.ExtTriggerControl(i,1)  = getpv('BR1_____TIMING_AM04');
    d.BendGainControl(i,1)    = getpv('BR1_____B__PSGNAC00');
    d.BendOffsetControl(i,1)  = getpv('BR1_____B__PSOFAC00');
    d.BendGain(i,1)           = getpv('BR1_____B__PSGNAM00');
    d.BendOffset(i,1)         = getpv('BR1_____B__PSOFAM00');    
end
