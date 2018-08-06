function MemoryData = getsystemmemory
% Memory = getsystemmemory

%  Written by Greg Portmann

switch computer
    case {'GLNX86', 'GLNXA64','SOL2', 'SOL64'}
        [status, R] = system('ps -a -o fname,rss | grep MATLAB');
        R(1:7) = [];
        MemoryData = str2double(R);
    otherwise
        error('Not sure how to get system memory for %d', computer);
end

