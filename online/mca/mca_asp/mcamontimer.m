function varargout = mcamontimer(varargin)
%MCAMONTIMER - Controls the initialisation and termination of the MATLAB
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
%     no limit to the size of the queue.
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
    
% Note that different timer mechanisms are used on Windows and elsewhere.
% On Windows, the MATLAB timer is blocked when a figure window is dragged
% or any modal dialog is opened (such as a uigetdir dialog).  This does not
% happen on Unix.  In orde to get around this on Windows, I have used the
% timereval function instead of the MATLAB timer.
%
elseif (nargin == 1)
    switch varargin{1}
        
        case 'start'
            if (TimerStarted)
                error('MCA monitor polling is already started.');
            end
            mlock;
            if (ispc)
                mcaTimer = timereval(2, 100, 'mca(600)');
            else
                mcaTimer = timer('TimerFcn', 'mca(600)', 'Period', 0.1, 'ExecutionMode', 'fixedSpacing');
                start (mcaTimer);
            end
            TimerStarted = 1;
            
        case 'stop'
            if (TimerStarted)
                munlock;
                if (ispc)
                    timereval(5, mcaTimer);
                else
                    stop (mcaTimer);
                    clear mcaTimer;
                end
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
