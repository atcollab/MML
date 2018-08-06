function setPt = ticklecorr( corrName, amplitude, frequency )
% function setPt = ticklecorr( corrName, amplitude, frequency )
% ticklecorr generates a sinusoidal modulation of the desired
%  corrector with the desired amplitude and frequency
% since the modulation signal has 2000 points output at a 4kHz rate
%  the slowest sine wave achievable is 2 Hz
%  the modulation will always be periodic
%   the function will round the desired frequency to the next
%    slower periodic frequency
%    2,4,8,10,16,20,32,40,50,80,100,160,200,250,400,500,800,1000,2000
% 
% corrName    name of desired corrector
% amplitude   peak modulation amplitude
% frequency   desired modulation frequency
% setPt       starting setpoint to be used to restore the corrector
%              to its original state

fSample = 4e3;
nPoints = 2e3;
fAllowed = [
    2, 4, 8, 10, 16, ...
    20, 32, 40, 50, 80, ...
    100, 160, 200, 250, 400, ...
    500, 800, 1000, 2000
    ];

indF = find( fAllowed <= frequency );
if isempty(indF),
    error( 'frequency too low to achieve' );
end % if isempty(indF),
f = max(fAllowed(indF));

% read current set point
values = lcaGet({[corrName, ':CurrSetpt']; ...
    [corrName, ':ControlState']}, 0, 'double');
% generate waveform
setPt = values(1,1);
% halt machine if running
if (values(2,1) ~= 0),
    lcaPut([corrName, ':ControlState'], 0 );
end % if (values(2,1) ~= 0),
wave = setPt + amplitude*sin((2*pi*(1:nPoints)/nPoints)*f/2);
loopFlag = zeros(1,nPoints);
loopFlag(1) = 4;
loopFlag(2) = NaN;
lcaPut({[corrName, ':CurrSetpt'];[corrName, ':ControlState']}, ...
    [wave; loopFlag]);