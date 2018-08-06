function [varargin, OutputFlag] = findkeyword(varargin, keyword)
%FINDKEYWORD - Find a keyword in a varargin input cell
%
%  [VarArgOut, OutputFlag] = findkeyword(varargin, keyword)
%
%  INPUTS
%  1. varargin cell array of strings
%  2. keyword 
%
%  OUTPUTS
%  1. VarArgOut - cell array of string without keyword
%  2. OutputFlag - Input number for the keyword if found, else []
%
%  Written by Jeff Corbett


OutputFlag = [];
if ~isempty(varargin)
  for i = length(varargin):-1:1
    if ischar(varargin{i})
        if any(strcmpi(varargin{i}, keyword))
            OutputFlag = length(varargin) - i + 1;
            varargin(i) = [];
            break
        end
    end
  end
end

