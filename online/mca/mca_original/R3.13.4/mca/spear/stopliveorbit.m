%Clear the monitor 
mcaclearmon(OrbitCounterHandle);
%stop periodic Channel Access polling
timereval(5,PollTimerHandle);