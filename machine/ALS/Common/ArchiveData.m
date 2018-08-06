% ArchiveData(URL, CMD, ...) interfaces to the Network Data Server
% of the Channel Archiver.
% 
% The two required arguments are:
%    URL of the data server, example:
%       'http://localhost/cgi-bin/xmlrpc/ArchiveDataServer.cgi'
%    CMD specifies the command.
% The remaining arguments depend on the command, see following examples.
% 
% Instead of calling ArchiveData directly, one might also use
% the ml_arch_... routines from the ChannelArchiver/Matlab/util
% directory.
%   
% [ver, desc, hows] = ArchiveData(URL, 'info')
%    Gets version number and description string from data server.   
%    The cell array hows contains the string descriptions
%    for the supported request methods, see 'values' call below.
% 
% [keys, names, paths] = ArchiveData(URL, 'archives')
%    Lists available archives by key, name and path.
% 
% [names,starts,ends] = ArchiveData(URL, 'names', KEY [, PATTERN])
%    Lists available channels for archive with given KEY.
%    Optional PATTERN is a regular expression.
%    Returns list of names, start and end times.
% 
%    Times: All times are in the format of Matlab
%           serial date numbers.
%           Octave needs to use Matlab-compatibility routines
%           datenum, datevec, ...
% 
% data = ArchiveData(URL, 'values', KEY, NAME, START, END [, COUNT[, HOW]])
%    Gets values from archive with given key.
%    NAME can either be a single name 'fred' or a cell array 
%    of names: { 'fred';'janet' }.
%    START and END are serial date numbers.
%    COUNT specifies the number of samples or bins,
%          the exact meaning depends on HOW.
%    HOW   specifies the request method.
% 
%    The resulting DATA is a 3-by-N matrix of N samples.
%    Row 1 gives the date numbers of the samples (suitable for e.g. datestr()),
%    row 2 gives the nanoseconds of the time stamps (in case you care),
%    row 3 gives the values in case the samples are scalars.
%    rows 3, 4, 5, .... give the elements of the sample in case the
%          channel is an array.
% 
%    If you provide a cell array with more than one name for NAME,
%    the result is not a single DATA matrix but a list of matrices:
%    [ DATA, DATA, DATA, ... ].
% 
%    Matlab can plot the data over time, see datetick().
%    Octave has problems with this. Via gset & gplot, the usual
%    gnuplot timefmt should work, but I couldn't pass the necessary
%    'using' directive from Octave on to gnuplot.
% 
% kasemir@lanl.gov
% 
