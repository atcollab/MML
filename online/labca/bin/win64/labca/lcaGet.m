%lcaGet
%
%  Calling Sequence
%
%[value, timestamp] = lcaGet(pvs, nmax, type)
%
%  Description
%
%   Read a number of m PVs, which may be scalars or arrays of different
%   dimensions. The result is converted into a m x n matrix. The number of
%   columns, n, is automatically assigned to fit the largest array among
%   the m PVs. PVs with less than n elements have their excess elements in
%   the result matrix filled with NaN.
%
%   If all PVs are of native type DBF_STRING or DBF_ENUM, the values are
%   returned as character strings; otherwise, all values are converted into
%   double precision numbers. Explicit type conversion into strings can be
%   enforced by submitting the `type' argument described below.
%
%  Parameters
%
%   pvs
%          Column vector (in matlab: m x 1 cell- matrix) of m strings.
%
%   nmax
%          (optional argument) Maximum number of elements (per PV) to
%          retrieve (i.e. limit the number of columns of value to nmax). If
%          set to 0 (default), all elements are fetched and the number of
%          columns, n, in the result matrix is set to the maximum number of
%          elements among the PVs. The option is useful to limit the
%          transfer time of large waveforms (unfortunately, CA does not
%          return the valid elements (``NORD'') of an array only -- it
%          always ships all elements).
%
%   type
%          (optional argument) A string specifying the data type to be used
%          for the channel access data transfer. Note that unless the PVs
%          are of native ``string'' type or conversion to ``string'' is
%          enforced explicitly (type = char), labCA always converts the
%          data to ``double'' locally.
%
%          It can be desirable, however, to use a different data type for
%          the transfer because by default CA transfers are limited to ~
%          16kB. Legal values for type are byte, short, long, float,
%          double, native or char (strings). There should rarely be a need
%          for using anything other than native, the default, which directs
%          CA to use the same type for transfer as the data are stored on
%          the server.
%
%          Occasionally, conversion to char can be useful: retrieve a
%          number of PVs as strings, i.e. let the CA server convert them to
%          strings (if the PVs are not native strings already) and transfer
%          them.
%
%          If multiple PVs are requested, either none or all must be of
%          native DBF_STRING or DBF_ENUM type unless explicit conversion to
%          char is enforced by specifying this argument.
%
%          Note that while native might result in different types being
%          used for different PVs, it is currently not possible to
%          explicitly request different types for individual PVs (i.e. type
%          can't be a vector).
%
%   value
%          The m x n result matrix. n is automatically assigned to
%          accomodate the PV with the most elements. If the nmax argument
%          is given and is nonzero but less than the automatically
%          determined n, then n is clipped to nmax. Excess elements of PVs
%          with less than n elements are filled with NaN values.
%
%          The result is either a `double' or a (matlab: cell-) `string'
%          matrix (if all PVs are of native string type or explicit
%          conversion was requested by setting the `type' argument to
%          `char').
%
%          labCA checks the channel access severity of the retrieved PVs
%          and fills the rows corresponding to INVALID PVs with NaN[1]^8.
%          In addition, warning messages are printed to the console if a
%          PV's alarm status exceeds a [2]configurable threshold. The
%          refusal to read PVs with INVALID severity can be tuned using the
%          lcaSetSeverityWarnLevel call as well.
%
%   timestamp
%          (optional result) A m x 1 column vector of complex numbers
%          holding the CA timestamps of the requested PVs. The timestamps
%          count the number of seconds (real part) and fractional
%          nanoseconds (imaginary part) elapsed since 00:00:00 UTC, Jan. 1,
%          1970.
%
%  Examples
%
%// read a PV
%    lcaGet( 'thepv' )
%// read multiple PVs along with their EPICS timestamps
%    [ vals, tstamps] = lcaGet( [ 'aPV' ; 'anotherPV' ] )
%// read an 'ENUM/STRING'
%    lcaGet( 'thepv.SCAN' )
%// read an 'ENUM/STRING' as a number (server converts)
%    lcaGet( 'thepv.SCAN', 0, 'float' )
%// enforce reading all PVs as strings (server converts)
%// NOTE: necessary if native num/nonnum types are mixed
%    lcaGet( [ 'apv.SCAN'; 'numericalPV' ] , 0, 'char' )
%// limit reading a waveform to its NORD elements
%    nord = lcaGet( 'waveform.NORD' )
%        if nord > 0 then
%      lcaGet( 'waveform', nord )
%        end
%     __________________________________________________________________
%
%    Footnotes
%
%   ...NaN[3]^8
%          Actually, all fields of an EPICS database record share a common
%          severity, (which itself is a field/PV -- the .SEVR field).
%          However, the INVALID status actually only applies to the .VAL
%          field of a record -- other fields (e.g. .EGU) may still hold
%          meaningful data. Consequently, INVALID PVs are returned as NaN
%          only if they refer to a record's .VAL field.
%     __________________________________________________________________
%
%
%    till 2012-01-13
%
%References
%
%   1. lcaGet.html#foot836
%   2. lcaSetSeverityWarnLevel.html#swarnlevel
%   3. lcaGet.html#tex2html9
