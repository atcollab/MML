function [logtime, names, data] = readhistplotfile( fileName )
% function [logtime, names, data] = readhistplotfile( fileName )
% readhistplotfile reads in data from the format output by the historyplot
%  routine of the spear database
% fileName    name of file created by historyplot
% logtime     vector of time information with m time elements
% names       cell of names of data in file (excluding logtime)
% data        m by n array of data with m rows of n elements
%
% logtime is separated out since it is always part of the output
% time is converted to matlab date time format
% restore to readable form, similar to logtime, with, for example,
%   datestr( logtime(ind), 0 )
% find index of column of DCCT data of interest with
%   find( strcmp( names, 'DCCT' ) )

% open file
fId = fopen( fileName );
if ( fId == -1 ),
	error( ['unable to open ', fileName] );
end % if ( fId == -1 )

% find number of lines of data in file
nLines = -1;
tLine = fgets( fId );
while ( tLine ~= -1 ),
	nLines = nLines + 1;
	tLine = fgets( fId );
end % while ( ( tLine
if nLines < 1,
	error( ['found no data lines in ', fileName] );
end % if nLines
frewind( fId );

% read in names
tLine = fgets( fId );
if tLine == -1,
	error( ['unable to read variable line of ', fileName] );
end % if tLine
% find number of names, excluding logtime
indComma = find( tLine == ',' );
nVars = length( indComma );
% create cell array with names
names = cell( 1, nVars );
% first nVars-1 names
for ind = 1:nVars,
	indStart = indComma( ind ) + 1;
	if ind == nVars,
		indStop = length( tLine );
	else
		indStop = indComma( ind + 1 ) - 1;
	end % if ind
	names{ 1, ind } = sscanf( tLine( indStart:indStop ), '%s' );
end % for ind
% last name
names{ 1, nVars } = sscanf( tLine( indStart:indStop ), '%s' );

% allocate memory for data
logtime = zeros( nLines, 1 );
data = zeros( nLines, nVars );
% read in data from file
lenDate = 20;
indDate = 1:lenDate;
for ind = 1:nLines,
	tLine = fgets( fId );
	if ( tLine == -1 ),
		error( ['cannot read data line ', int2str( ind ), ' of ', fileName ] );
	end % if ( tLine
	logtime( ind ) = datenum( tLine( indDate ) );
	data( ind, : ) = sscanf( tLine( (lenDate+1):length(tLine) ), ',%f', ...
		[ 1, nVars ] );
end % for ind
% close file
fclose( fId );

return
