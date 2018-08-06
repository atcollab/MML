function hwinit(varargin)
%HWINIT - Hardware initialization script


DisplayFlag = 1;
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end

if nargin < 1
    DisplayFlag = 1;
end

if DisplayFlag
    %fprintf('   Hardware initialization complete\n');
end

