%lcaClear
%
%  Calling Sequence
%
%lcaClear(pvs)
%
%  Description
%
%   Clear / release (disconnect) channels. This is particularly useful with
%   EPICS 3.14 to clean up invalid PVs (e.g., due to typos). Nonexisting
%   PVs are continuously searched for by a CA background task which may
%   result in cluttered IOC consoles and resource consumption. All monitors
%   on the target channel(s) are cancelled/released as a consequence of
%   this call.
%
%  Parameters
%
%   pvs
%          Column vector (in matlab: m x 1 cell- matrix) of m strings.
%          Alternatively, lcaClear may be called with no rhs argument thus
%          clearing all channels (and monitors).
%
%  Examples
%
%\\ clear a number of channels
%  lcaClear( ['aUseless_PV'; 'misTyppedPV' ] )
%\\ purge all channels (dont use parenthesis in matlab)
%  lcaClear()
%     __________________________________________________________________
%
%
%    till 2017-08-08
