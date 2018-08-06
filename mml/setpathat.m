function [ATPATHDirectory, ATVersion] = setpathat(varargin)
%SETPATHAT - Sets the AT Toolbox path
%  [ATPATHDirectory, ATVersion] = setpathat(ATROOT) 
%  [ATPATHDirectory, ATVersion] = setpathat(ATVersion)
%  [ATPATHDirectory, ATVersion] = setpathat
%
%  ATROOT is where atpath is found
%  ATVersion = 1.3, 1.4, or 2.0
%
%  Note: the default comes from gotoat
%
% See also gotoat setpathmml


% Save the starting directory
olddir = pwd;

[ATPATHDirectory, ATVersion] = gotoat(varargin{:});

try
    fprintf('   Setting AT path to %s\n', ATPATHDirectory);
    cd(ATPATHDirectory);
    atpath;
    cd(olddir);
catch
    cd(olddir);
    fprinf('  Error setting the AT path.\n');
    rethrow(lasterror);
    return
end

try
    if isempty(ATVersion)
        ATVersion = str2num(atversion);
    end
catch
end

        
