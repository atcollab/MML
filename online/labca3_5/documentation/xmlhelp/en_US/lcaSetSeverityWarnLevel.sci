function lcaSetSeverityWarnLevel
// Set the warning threshold for lcaGet() operations.
//
//  Calling Sequence
//
//lcaSetSeverityWarnLevel(newlevel)
//
//  Description
//
//   Set the warning threshold for lcaGet() operations. A warning message is
//   printed when retrieving a PV with a severity bigger or equal to the
//   warning level. Supported values are 0..3 (No alarm, minor alarm, major
//   alarm, invalid alarm). The initial/default value is 3.
//
//   If a value $>=10$ is passed, the threshold for refusing to read the
//   .VAL field of PVs with an INVALID severity can be changed. The
//   rejection can be switched off completely by passing 14 ( $= 10 +
//   INVALID\_ALARM + 1$ ) or made more sensitive by passing a value of less
//   than 13 ( $=10 + INVALID\_ALARM$ ), the default.
//     __________________________________________________________________
//
//
//    till 2017-08-08
endfunction
