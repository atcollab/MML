function FileName = prependtimestamp(FileName, TimeStamp)
%PREPENDTIMESTAMP - Prepends the time stamp to a file
%  FileName = prependtimestamp(FileName, TimeStamp)
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
%  See also appendtimestamp

%  Written by Greg Portmann


if nargin < 1
    error('At least 1 input required');
end
if nargin < 2
    TimeStamp = clock;
end

% Append date_Time to FileName
FileName = sprintf('%s_%s', datestr(TimeStamp,31), FileName);
FileName(11) = '_';
FileName(14) = '-';
FileName(17) = '-';
