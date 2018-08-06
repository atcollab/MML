function MMLROOT = getmmlroot(varargin)
%GETMMLROOT - Returns root directory of the Matlab Middle Layer
%  MMLRootDirectory = getmmlroot

%  Written by Greg Portmann


if length(varargin) >= 1
    IgnorTheADFlag = varargin{1};
else
    IgnorTheADFlag = '';
end


MMLROOT = '';


% 1. If MMLROOT is set in the AD then use it.
if ~strcmpi(IgnorTheADFlag, 'IgnoreTheAD')
    MMLROOT = getfamilydata('MMLRoot');
end

if isempty(MMLROOT)
    % 2. Try some ENV variables
    MMLROOT = getenv('MMLROOT');

    if isempty(MMLROOT)
        % This is legacy
        MMLROOT = getenv('MLROOT');

        % 3. Base on the location of this file
        if isempty(MMLROOT)
            %if exist('getsp','file')
            %    % Base on getsp file
            %    [MMLROOT, FileName, ExtentionName] = fileparts(which('getsp'));
            %else
            % Base on the location of this file
            [MMLROOT, FileName, ExtentionName] = fileparts(mfilename('fullpath'));
            %end
            MMLROOT = [MMLROOT, filesep];

            % Make MMLROOT root 1 up from the MML directory
            i = findstr(MMLROOT, filesep);
            if length(i) < 2
                %MMLROOT = MMLROOT;
            else
                MMLROOT = MMLROOT(1:i(end-1));
            end
        end
    end
end


% End MMLROOT with a file separator
if ~strcmp(MMLROOT(end), filesep)
    MMLROOT = [MMLROOT, filesep];
end





