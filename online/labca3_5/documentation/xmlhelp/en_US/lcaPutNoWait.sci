function lcaPutNoWait
// lcaPutNoWait is a variant of lcaPut that does not wait for the channel    access put request to complete on the server prior to returning control    to the command line.
//
//  Calling Sequence
//
//lcaPutNoWait(pvs, value, type)
//
//  Description
//
//   lcaPutNoWait is a variant of lcaPut that does not wait for the channel
//   access put request to complete on the server prior to returning control
//   to the command line. This call can be useful to set PVs that are known
//   to take a long or indefinite time to complete processing, e.g., arming
//   a waveform record which is triggered by a hardware event in the future
//   or starting a stepper motor.
//
//  Parameters
//
//   See lcaPut.
//     __________________________________________________________________
//
//
//    till 2017-08-08
endfunction
