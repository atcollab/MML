function varargout = mcamontimer(varargin)
%MCAMONTIMER  - Controls the initialisation and termination of the MATLAB
%              timer used to poll the MCA monitor command queue.
%
% Started = mcamontimer - returns 1 if monitor polling has been started
%                         returns 0 if monitor polling has not been started
%
% mcamontimer('start') - starts the timer polling every 0.1 seconds
% mcamontimer('stop')  - stops the timer
%
% Notes: 
% (1) If monitors are installed using mcamon but mcaTimer has not been
%     started, the monitor events will queue up indefinitely.  There is
%     no limit to the size of the queue, so eventually you will
%     run out of memory and crash.
% (2) A polling period of 0.1 seconds is used.  This may be varied if
%     desired by modifying the 'Period' argument in the definition of
%     mcaTimer.
% (3) Call mcamontimer('start') once.
%
% See also MCAMON, MCAMONEVENTS, MCACACHE, MCACLEARMON
%
persistent mcaTimer TimerStarted;

if (nargin == 0)
    if (TimerStarted)
        varargout{1} = 1;
    else
        varargout{1} = 0;
    end
elseif (nargin == 1)
    switch varargin{1}
        case 'start'
            if (TimerStarted)
                error('MCA monitor polling is already started.');
            end
            mlock;
            mcaTimer = timer('TimerFcn', 'mca(600)', 'Period', 0.1, 'ExecutionMode', 'fixedSpacing');
            start (mcaTimer);
            TimerStarted = 1;
        case 'stop'
            if (TimerStarted)
                munlock;
                stop (mcaTimer);
                clear mcaTimer;
                TimerStarted = 0;
            else
                error('MCA monitor polling has not been started.');
            end            
        otherwise
            error('Invalid parameter specified for mcamontimer.  Use ''start'' or ''stop''.')
    end
else
    error('Invalid number of arguments in mcamontimer.')
end
