% set_magnet_strengths
if strcmpi(mode,'S10')
    if strcmpi(version,'01')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/s10/'));
        eval('s10_01');
        cd(cur);
    else
        error('version not implemented');
    end
elseif strcmpi(mode,'S05')
    if strcmpi(version,'01')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/s05/'));
        eval('s05_01');
        cd(cur);
    elseif strcmpi(version,'02')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/s05/'));
        eval('s05_02');
        cd(cur);
    elseif strcmpi(version,'03')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/s05/'));
        eval('s05_03');
        cd(cur);
    else
        error('version not implemented');
    end
else
    error('mode not implemented');
end

