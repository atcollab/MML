function [FinalDir, ErrorFlag] = gotodirectory(GotoDir)
%GOTODIRECTORY - Goto a directory creating the path if necessary
%  [FinalDir, ErrorFlag] = gotodirectory(DirName)
%
%  Go to directory DirName.  Creates all the necessary directories along the way. 
%  DirName must start from the root of the tree or the present directory.  '.' does nothing.

%  Written by Greg Portmann


ErrorFlag = 0;

if nargin == 0
    FinalDir = [pwd filesep];
    return
elseif isempty(GotoDir)
    FinalDir = [pwd filesep];
    return
elseif strcmp(GotoDir,'.')
    FinalDir = [pwd filesep];
    return
end


%%%%%%%%%%%%%%%%%%%
% Go to directory %
%%%%%%%%%%%%%%%%%%%

% Find the file separators
k = findstr(GotoDir, filesep);

if isempty(k)
    % Add a filesep to the end
    GotoDir(end+1) = filesep;
    k(1) = length(GotoDir);
else
    % If k starts with a filesep, then remove the index to it
    if k(1) == 1
        k(1) = [];
    end
    % Try again
    if length(k) >= 1
        if k(1) == 2
            k(1) = [];
            if ispc && length(k) >= 1
                k(1) = [];
            end
        end
    end
    % And again
    if length(k) >= 1
        if k(1) == 3
            k(1) = [];
        end
    end
end

% If doesnot end with a filesep, then add one
if ~strcmp(GotoDir(end), filesep)
    GotoDir(end+1) = filesep; 
    k(end+1) = length(GotoDir);
end


% Try to cd as far as possible
j = 1;
for i = 1:length(k)
    %GotoDir(j:k(i))
    try
        cd(GotoDir(j:k(i)));
    catch
        % Create that directory
        [Success, msg] = mkdir(GotoDir(j:k(i)));
        if Success
            cd(GotoDir(j:k(i)));
        else
            if ispc
                ErrorFlag = 1;
                fprintf('   Problem creating directory: %s\n', msg);
                break
            else
                % I'm getting a tcsh error that's not really can error so I have a test another way
                try
                    cd(GotoDir(j:k(i)));
                catch
                    ErrorFlag = 1;
                    fprintf('   Problem creating directory: %s\n', msg);
                    break
                end
            end
        end
    end
    j = k(i) + 1;
end


% Return 
FinalDir = pwd;
FinalDir = [FinalDir filesep];

