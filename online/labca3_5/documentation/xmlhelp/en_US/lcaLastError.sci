function lcaLastError
// This routine is a simple extension to scilab's lasterror which only    allows a single error to be reported.
//
//  Calling Sequence
//
//[err_status] = lcaLastError()
//
//  Description
//
//   This routine is a simple extension to scilab's lasterror which only
//   allows a single error to be reported. If labCA encounters an error of
//   general nature then lasterror is sufficient and lcaLastError() reports
//   redundant/identical information. However, if a labCA operation only
//   fails on a subset of a vector of PVs then lcaLastError() returns an
//   error code for each individual PV (as a m x 1 vector) so that failing
//   channels can be identified.
//
//   The error reported by lasterror corresponds to the first error found in
//   the err_status vector.
//
//   Note that (matching lasterror's semantics) the recorded errors are not
//   cleared by a successful labCA operation. Hence, the status returned by
//   lcaLastError() is only defined after an error occurred and the routine
//   is intended to be used from the catch section of a try - catch - end
//   construct.
//
//  Parameters
//
//   err_status
//          m x 1 column vector of [1]status codes for each PV of the last
//          failing labCA call or a scalar. Note that this routine can
//          return a scalar even if the last operation involved multiple PVs
//          if the error was of general nature (e.g., ``invalid argument'').
//          In this case the scalar is identical to the error reported by
//          scilab's lasterror.
//
//  Examples
//
//try
//  // lcaXXX command goes here
//catch
//  errors = lcaLastError()
//  // errors holds status vector or single status code
//  // depending on command, error cause and number of PVs.
//end
//     __________________________________________________________________
//
//
//    till 2017-08-08
//
//See also
//
//   Error 1. Error
endfunction
