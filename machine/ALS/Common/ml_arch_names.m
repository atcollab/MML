function [names, starts, ends]=ml_arch_names(url, key, pattern)
% [names, starts, ends]=ml_arch_names(url, key, pattern)
%
% Get list of channels that match an (optional) patthern,
% printing it unless return values are used.

if (nargin < 3)
    pattern='';
end

%global is_matlab;
[names, starts, ends]=ArchiveData(url, 'names', key, pattern);
if nargout < 1
    for i=1:size(names, 1)
        %if is_matlab==1
            disp(sprintf('%-40s %s - %s', ...
                         names{i}, datestr(starts(i)), datestr(ends(i))));
        %else
        %    disp(sprintf('%-40s %s - %s', ...
        %                 names(i,:), datestr(starts(i)), datestr(ends(i))));
        %end
    end
end

