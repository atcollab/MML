function [varargin, OutputFlag]=findkeyword2(varargin,keyword)
%FINDKEYWORD - Finds a keyword with a cell of strings
%
% INPUTS
% 1. varargin Cell of strings
% 2. keyword 
%
% OUTPUTS
% 1. varargin - cell of string without keyword
% 2. OutputFlag cell number if keywork found

% Adapted from findkeyword by Laurent S. Nadolski

OutputFlag = 0;
if ~isempty(varargin)
  for i = 1:length(varargin)
    if ischar(varargin{i})
        if strcmpi(varargin{i},keyword)
            OutputFlag = i;
            varargin(i) = [];
            break
        end
    end
  end
end

