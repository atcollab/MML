function t = mcademosrv(varargin);

if strcmpi(nargin{1},'init')
    persistent RN RW SP AM C LIFETIME_s Current0 CurrentNoise MonitorTrackingFraction RandomNoiseSigma
    [RN, RW, SP, AM, C] = mcacheckopen('mcademo:RandomNumber','mcademo:RandomWaveform','mcademo:Setpoint',...
        'mcademo:Monitor', 'mcademo:Current');
    
    LIFETIME_s = 3600;
    Current0 = 100;
    CurrentNoise = 0.1;

    MonitorTrackingFraction = 0.1; % Must be between 0 and 1

    RandomNoiseSigma = 1;
    t = timer('ExecutionMode', 'fixedDelay','TimerFcn','atmsdemosrv','Name', 'ATMSDEMO',...
        ,'period',1)
    start(t);
    
else % timer callback
    disp(datestr(now))
    
end




