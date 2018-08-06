function [keys,names,paths]=ml_arch_archives(url)
% [keys,names,paths]=ml_arch_archives(url)
%
% Get list of available archives from server,
% printing it unless return values are used.


[keys,names,paths]=ArchiveData(url, 'archives');
if nargout < 1
    for i=1:size(keys,1)
    end
end;
