function lcaSetMonitor
// Set a ``monitor'' on a set of PVs.
//
//  Calling Sequence
//
//lcaSetMonitor(pvs, nmax, type)
//
//  Description
//
//   Set a ``monitor'' on a set of PVs. Monitored PVs are automatically
//   retrieved every time their value or status changes. Monitors are
//   especially useful under EPICS-3.14 which supports multiple threads.
//   EPICS-3.14 transparently reads monitored PVs as needed. Older, single
//   threaded versions of EPICS require periodic calls to labCA e.g., to
//   [1]lcaDelay, in order to allow labCA to handle monitors.
//
//   Use the [2]lcaNewMonitorValue call to check monitor status (local flag)
//   or [3]lcaNewMonitorWait to wait for new data to become available (since
//   last lcaGet or lcaSetMonitor). If new data are available, they are
//   retrieved using the ordinary [4]lcaGet call.
//
//   Note the difference between polling and monitoring a PV in combination
//   with polling the local monitor status flag ([5]lcaNewMonitorValue). In
//   the first case, remote data are fetched on every polling cycle whereas
//   in the second case, data are transferred only when they change. Also,
//   in the monitored case, lcaGet reads from a local buffer rather than
//   from the network. It is most convenient however to wait for monitored
//   data to arrive using [6]lcaNewMonitorWait rather than polling.
//
//   There is currently no possibility to selectively remove a monitor. Use
//   the [7]lcaClear call to disconnect a channel and as a side-effect,
//   remove all monitors on that channel. Future access to a cleared channel
//   simply reestablishes a connection (but no monitors).
//
//  Parameters
//
//   pvs
//          Column vector (in matlab: m x 1 cell- matrix) of m strings.
//
//   nmax
//          (optional argument) Maximum number of elements (per PV) to
//          monitor/retrieve. If set to 0 (default), all elements are
//          fetched. See [8]here for more information.
//
//          Note that a subsequent [9]lcaGet must specify a nmax argument
//          equal or less than the number given to lcaSetMonitor --
//          otherwise the lcaGet operation results in fetching a new set of
//          data from the server because the lcaGet request cannot be
//          satisfied using the copy locally cached by the monitor-thread.
//
//   type
//          (optional argument) A string specifying the data type to be used
//          for the channel access data transfer. The native type is used by
//          default. See [10]here for more information.
//
//          The type specified for the subsequent lcaGet for retrieving the
//          data should match the monitor's data type. Otherwise, lcaGet
//          will fetch a new copy from the server instead of using the data
//          that was already transferred as a result of the monitoring.
//
//  Examples
//
//lcaSetMonitor('PV')
//// monitor 'PV'. Reduce network traffic by just have the
//// library retrieve the first 20 elements. Use DBR_SHORT
//// for transfer.
//lcaSetMonitor('PV', 20, 's')
//     __________________________________________________________________
//
//
//    till 2017-08-08
//
//See also
//
//   lcaDelay 1. lcaDelay
//   lcaNewMonitorValue 2. lcaNewMonitorValue
//   lcaNewMonitorWait 3. lcaNewMonitorWait
//   lcaGet 4. lcaGet
//   lcaNewMonitorValue 5. lcaNewMonitorValue
//   lcaNewMonitorWait 6. lcaNewMonitorWait
//   lcaClear 7. lcaClear
//   lcaGet 8. lcaGet
//   lcaGet 9. lcaGet
//  lcaGet 10. lcaGet
endfunction
