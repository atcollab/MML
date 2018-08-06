function varargout = meastune(varargin)
t0 = clock;

% if nargin == 1
    % Mexed version of the tune measurement interface
    
    tune(1) = getpv('CR01:GENERAL_ANALOG_02_MONITOR');
    tune(2) = getpv('CR01:GENERAL_ANALOG_03_MONITOR');
disp('Tunes from the kicker:')
disp(tune)
%  
%       printf ("rsib-spa test v2.01\n\n");
%       printf ("Master Oscillator Frequency = %e\n", Master_Oscillator_Frequency);
%       printf ("Centre Frequency = %e\n", Centre_Frequency);
%       printf ("XTune Guess = %e\n", X_Tune_Guess);
%       printf ("XTune Half Span = %e\n", X_Tune_Half_Span);
%       printf ("YTune Guess = %e\n", Y_Tune_Guess);
%       printf ("YTune Half Span = %e\n\n", Y_Tune_Half_Span);

   mo = getsp('RF');
   tune = sr11spa01_matlab(mo(1),29.1474444e6,0.29,0.04,0.22,0.04);
disp('Tunes from the SPA (returned by program):')
disp(tune')
%    tune = sr11spa01_matlab(mo(1),1.665566720000000e+07,0.3,0.04,0.22,0.04);
    
% else
    
%     directory = pwd;
% 
%     mo = getsp('SR00MOS01:FREQUENCY_MONITOR');
% 
%     cd /asp/usr/middleLayer/machine/asp/spa
% 
%     t0 = clock;
%     temp = ['sr11spa01 ' num2str(mo) ' ' num2str(5550000) ' ' num2str(0.28) ' ' num2str(0.03) ' ' num2str(0.23) ' ' num2str(0.03)];
% 
%     [a tune] = system(temp);
%     tune = str2num(tune);
%     
%     cd(directory);
% end

if nargout > 0
    varargout{1} = tune(:);
end
if nargout > 1
    % tout
    varargout{2} = clock;
end
if nargout > 2
    % Data time
    varargout{3} = t0;
end
if nargout > 3
    % Error flag
    varargout{4} = 0;
end



