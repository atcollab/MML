%lcaPut
%
%  Calling Sequence
%
%lcaPut(pvs, value, type)
%
%  Description
%
%   Write to a number of PVs which may be scalars or arrays of different
%   dimensions. It is possible to write the same value to a collection of
%   PVs.
%
%  Parameters
%
%   pvs
%          Column vector (in matlab: m x 1 cell- matrix) of m strings.
%
%   value
%          m x n matrix or 1 x n row vector of values to be written to the
%          PVs. If there is only a single row in value it is written to all
%          m PVs. value may be a matrix of ``double'' precision numbers or
%          a (matlab: cell-) matrix of strings (in which case the values
%          are transferred as strings and converted by the CA server to the
%          native type -- this is particularly useful for DBF_ENUM /
%          ``menu'' type PVs).
%
%          It is possible to write less than n elements -- labCA scans all
%          rows for NaN values and only transfers up to the last non-NaN
%          element in each row.
%
%   type
%          (optional argument) A string specifying the data type to be used
%          for the channel access data transfer. Note that labCA always
%          converts numerical data from ``double'' locally.
%
%          It can be desirable, to use a different data type for the
%          transfer because by default CA transfers are limited to ~ 16kB.
%          Legal values for type are byte, short, long, float, double, char
%          or native. There should rarely be a need for using anything
%          other than native, the default, which directs CA to use the same
%          type for transfer as the data are stored on the server. If value
%          is a string matrix, type is automatically set to char.
%
%          Note that while native might result in different types being
%          used for different PVs, it is currently not possible to
%          explicitly request different types for individual PVs (i.e. type
%          cannot be a vector).
%
%  Examples
%
%// write a PV
%    lcaPut( 'thepv', 1.234 )
%// write as a string (server converts)
%    lcaPut( 'thepv', '1.234' )
%// write/transfer as a short integer (server converts)
%    lcaPut( 'thepv', 12, 'short' )
%// write multiple PVs (use { } on matlab)
%    lcaPut( [ 'pvA'; 'pvB' ], [ 'a'; 'b' ] );
%// write array PV
%    lcaPut( 'thepv' , [ 1, 2, 3, 4 ] )
%// write same value to a group of PVs (string
%// concatenation differs on matlab)
%    lcaPut( [ 'pvA'; 'pvB' ] + '.SCAN', '1 second' )
%// write array and scalar PV (using NaN as a delimiter)
%    tab = [ 1, 2, 3, 4 ;   5, %nan, 0, 0 ]
%        lcaPut( [ 'arrayPV'; 'scalarPV' ], tab )
%     __________________________________________________________________
%
%
%    till 2017-08-08
