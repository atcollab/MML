function Fs = getfs(InfoFlag)
% synchrotron tune = getfs(InfoFlag)
%
%   InfoFlag = 0    -> do not print status information, 
%              else -> print status information
%
%   If NaN is returned, than something is wrong with the tune measurement system. 
%

if nargin < 1
   InfoFlag = 0;
end

Tune = gettune;

Fs = abs(Tune(1) - Tune(2));

if InfoFlag
   fprintf('  Synchrotron Tune = %f\n', Fs);
end