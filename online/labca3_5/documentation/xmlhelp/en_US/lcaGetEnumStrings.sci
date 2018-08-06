function lcaGetEnumStrings
// Retrieve the symbolic values of all ENUM states of a number of PVs.
//
//  Calling Sequence
//
//enum_states = lcaGetEnumStrings(pvs)
//
//  Description
//
//   Retrieve the symbolic values of all ENUM states of a number of PVs.
//   Some PVs represent a selection of a particular value from a small (up
//   to 16) set of possible values or states and the IOC designer may
//   associate symbolic names with the permissible states. This call lets
//   the user retrieve the symbolic names of all these states.
//
//  Parameters
//
//   pvs
//          Column vector (in matlab: m x 1 cell- matrix) of m strings.
//
//   enum_states
//          m x n (with n=16) matrix (on matlab: cell- matrix) of strings
//          holding the ENUM states defined for the PVs.
//
//          Unused/undefined states -- this covers also the case when the PV
//          does not support ENUM states -- are set to the empty string.
//     __________________________________________________________________
//
//
//    till 2017-08-08
endfunction
