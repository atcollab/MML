function list = suite(filename)
% Run through the test file and return the subfunction/test names 
% in string form
% All subfunction names begin with PREFIX, and are expected to have
% the signature 'function PREFIX'.
% filename - file containing the subfunctions
% list - list of the subfunction/test names
%
% Timothy Wall
% Oculus Technologies Corporation
% Copyright (c) 2005 Timothy Wall
%------------------------------------------------------------------------

fid = fopen(filename);
PREFIX = 'test';
TAG = ['function ' PREFIX];
list = {}; % List of the subfunctions in string form
nsubs = 1; % Number of subfunctions
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    i = strfind(tline, TAG); %Find index of the test name prefix
    if (i)
        tempName = PREFIX;
        n = i + length(TAG); 
        len = length(tline); % Length of the subfunction name   
        while (n <= len & tline(n) ~= ' ')
            % Copy the subfunction name
            tempName = [tempName tline(n)];
            n = n + 1; 
        end
        list(nsubs) = {tempName};
        nsubs = nsubs + 1;
    end
end
fclose(fid);
list = cellstr(list);
