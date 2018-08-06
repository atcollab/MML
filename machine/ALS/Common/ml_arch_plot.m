function [times,values]=ml_arch_plot(url, key, name, t0, t1, how, count)
% [times,values]=ml_arch_plot(url, key, name, t0, t1, how, count)
%
% Plot archive data in Matlab.
%
% Calls ml_arch_get, check there for more info.
%
% See also ml_arch_get

if (nargin < 7)
   count = 100;
end

if (nargin < 6)
   how = 3;
end

[times,micros,values]=ml_arch_get(url, key, name, t0, t1, how, count);

%global is_matlab
%if is_matlab==1
    if length(values) < 100
       plot(times, values, 'ro-');
    else
       plot(times, values, 'r-');
    end
    datetick('x', 0);
    legend(strrep(name,'_','\_'));
%else
%    [Y,M,D,h,m,s] = datevec(times(1));
%    day=floor(times(1));
%    xlabel(sprintf('Time on %02d/%02d/%04d [24h]', M, D, Y))
%    if length(values) < 100 
%        plot(times-day, values, sprintf('-@;%s;', name))
%    else
%        plot(times-day, values, sprintf('-;%s;', name))
%    end
%end
