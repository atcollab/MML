%lcaDelay
%
%  Calling Sequence
%
%lcaDelay(timeout)
%
%  Description
%
%   Delay execution of scilab or matlab for the specified time to handle
%   channel access activity (monitors). Using this call is not needed under
%   EPICS-3.14 since monitors are transparently handled by separate
%   threads. These ``worker threads'' receive data from CA on monitored
%   channels ``in the background'' while scilab/matlab are processing
%   arbitrary calculations. You only need to either poll the library for
%   the data being ready using the [1]lcaNewMonitorValue()) routine or
%   block for data becoming available using [2]lcaNewMonitorWait.
%
%  Parameters
%
%   timeout
%          A timeout value in seconds.
%     __________________________________________________________________
%
%
%    till 2017-08-08
%
%References
%
%   lcaNewMonitorValue 1. lcaNewMonitorValue
%   lcaNewMonitorWait 2. lcaNewMonitorWait
