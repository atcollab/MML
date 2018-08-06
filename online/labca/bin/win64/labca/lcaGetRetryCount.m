%lcaGetRetryCount, lcaSetRetryCount
%
%  Calling Sequence
%
%currentRetryCount = lcaGetRetryCount()
%lcaSetRetryCount(newRetryCount)
%
%  Description
%
%   Retrieve / set the ezca library retryCount parameter (consult the ezca
%   documentation for more information). The retry count multiplied by the
%   [1]timeout parameter determines the maximum time the interface waits
%   for connections and data transfers, respectively.
%     __________________________________________________________________
%
%
%    till 2012-01-13
%
%References
%
%   1. lcaGetTimeout.html#timeout
