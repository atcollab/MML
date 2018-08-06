function atpath_nocvs()
%ATPATH adds the AT directories to the MATLAB search path
    
ATROOT = fileparts(mfilename('fullpath'));
ATPATH = regexprep(genpath(ATROOT),...
    ['[^' pathsep ']*' filesep 'cvs' pathsep '?'],...
    '', 'ignorecase');
addpath(ATPATH);
