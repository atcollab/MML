function lcaNewMonitorWait
// Similar to [1]lcaNewMonitorValue but instead of returning the status of    monitored PVs this routine blocks until all PVs have fresh data    available (e.
//
//  Calling Sequence
//
//lcaNewMonitorValue(pvs, type)
//
//  Description
//
//   Similar to [1]lcaNewMonitorValue but instead of returning the status of
//   monitored PVs this routine blocks until all PVs have fresh data
//   available (e.g., due to initial connection or changes in value and/or
//   severity status). Reading the actual data must be done using [2]lcaGet.
//
//  Parameters
//
//   pvs
//          Column vector (in matlab: m x 1 cell- matrix) of m strings.
//
//   type
//          (optional argument) A string specifying the data type to be used
//          for the channel access data transfer. The native type is used by
//          default. See [3]here for more information.
//
//          Note that monitors are specific to a particular data type and
//          therefore lcaNewMonitorWait will only report the status for a
//          monitor that had been established (by [4]lcaSetMonitor) with a
//          matching type. Using the ``native'' type, which is the default,
//          for both calls satisfies this condition.
//
//  Examples
//
//try lcaNewMonitorWait(pvs)
//        vals = lcaGet(pvs)
//catch
//        errs = lcaLastError()
//        handleErrors(errs)
//end
//     __________________________________________________________________
//
//
//    till 2017-08-08
//
//See also
//
//   lcaNewMonitorValue 1. lcaNewMonitorValue
//   lcaGet 2. lcaGet
//   lcaGet 3. lcaGet
//   lcaSetMonitor 4. lcaSetMonitor
endfunction
