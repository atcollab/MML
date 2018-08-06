function [times,micros,values]=ml_arch_get(url, key, name, t0, t1, how, count)
% [times,micros,values]=ml_arch_get(url, key, name, t0, t1, how, count)
%
% Get data for given channel name, start and end time into Matlab.
% TIMES  - Array of date numbers.
% MICROS - Microseconds of the time stamps
% VALUES - Da Data with NaN indicating non-values (disconnected, ...)
%
% The underlying XML-RPC protocol and the raw ArchiveData call support
% retrieval of more than one channel at once.
% Use that directly for better performance. 


if (nargin < 7)
   count = 100;
end

if (nargin < 6)
    how = 1;
end

data=ArchiveData(url, 'values', key, name, t0, t1, count, how);

times=data(1,:);
micros=round(data(2,:)*1e6);
values=data(3:size(data,1),:)';
if nargout < 1
    for i=1:size(data,2)
        fprintf('%s%s', ...
            sprintf('%s.%06d',datestr(times(i)), micros(i)), ...
            sprintf(' %g', values(i,:)));
    end
end
