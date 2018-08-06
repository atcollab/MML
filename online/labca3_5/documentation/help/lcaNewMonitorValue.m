%lcaNewMonitorValue
%
%  Calling Sequence
%
%[flags] = lcaNewMonitorValue(pvs, type)
%
%  Description
%
%   Check if monitored PVs need to be read, i.e, if fresh data are
%   available (e.g., due to initial connection or changes in value and/or
%   severity status). Reading the actual data must be done using [1]lcaGet.
%
%  Parameters
%
%   pvs
%          Column vector (in matlab: m x 1 cell- matrix) of m strings.
%
%   type
%          (optional argument) A string specifying the data type to be used
%          for the channel access data transfer. The native type is used by
%          default. See [2]here for more information.
%
%          Note that monitors are specific to a particular data type and
%          therefore lcaNewMonitorValue will only report the status for a
%          monitor that had been established (by [3]lcaSetMonitor) with a
%          matching type. Using the ``native'' type, which is the default,
%          for both calls satisfies this condition.
%
%   flags
%          Column vector of flag values. A value of zero indicates that no
%          new data are available - the monitored PV has not changed since
%          it was last read (the data, that is, not the flag). A value of
%          one indicates that new data are available for reading (lcaGet).
%
%          NOTE: As of labCA version 3 the flags no longer report error
%          conditions. Errors are now reported in the [4]standard way,
%          i.e., by aborting the labCA call. Errors can be caught by the
%          standard scilab try-catch-end construct. The [5]lcaLastError
%          routine can be used to obtain status information for individual
%          channels if lcaNewMonitorValue fails on a vector of PVs.
%
%          See also [6]lcaNewMonitorWait.
%
%  Examples
%
%try and(lcaNewMonitorValue(pvvec))
%        vals = lcaGet(pvvec)
%catch
%    errs = lcaLastError()
%        handleErrs(errs)
%end
%     __________________________________________________________________
%
%
%    till 2017-08-08
%
%References
%
%   lcaGet 1. lcaGet
%   lcaGet 2. lcaGet
%   lcaSetMonitor 3. lcaSetMonitor
%   Error 4. Error
%   lcaLastError 5. lcaLastError
%   lcaNewMonitorWait 6. lcaNewMonitorWait
