%lcaGetTimeout, lcaSetTimeout
%
%  Calling Sequence
%
%currentTimeout = lcaGetTimeout()
%lcaSetTimeout(newTimeout)
%
%  Description
%
%   Retrieve / set the ezca library timeout parameter (consult the ezca
%   documentation for more information). Note that the semantics of the
%   timeout parameter has changed with labCA version 3. The library no
%   longer pends for CA activity in multiples of this timeout value but
%   returns control to scilab as soon as the underlying CA request
%   completes.
%
%   However, labCA checks for ``Ctrl-C'' key events every time (and only
%   when) the timeout expires. Hence, it is convenient to choose a value
%   $<1$ s.
%
%   The maximal time spent waiting for connections and/or data equals the
%   timeout multiplied by the [1]retry count.
%     __________________________________________________________________
%
%
%    till 2012-01-13
%
%References
%
%   1. lcaGetRetryCount.html#retrycnt
