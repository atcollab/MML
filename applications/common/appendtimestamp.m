function FileName = appendtimestamp(FileName, TimeStamp)
%APPENDTIMESTAMP - Appends the time stamp to the file
%  FileName = appendtimestamp(FileName, TimeStamp)
%
%  INPUTS
%  1. FileName - Filename for appending timestamp
%  2. TimeStamp - TimeStamp string {Default: clock}
%
%  OUTPUTS
%  1. FileName - File name modified
%
%  NOTES
%  1. TimeStamp needs to be a vector as output by the Matlab clock function
%
%  See also prependtimestamp

%  Written by Greg Portmann


if nargin < 1
    error('At least 1 input required');
end
if nargin < 2
    TimeStamp = clock;
end

% Append date_Time to FileName
FileName = sprintf('%s_%s', FileName, datestr(TimeStamp,31));
FileName(end-8) = '_';
FileName(end-2) = '-';
FileName(end-5) = '-';
