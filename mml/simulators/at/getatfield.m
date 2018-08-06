function [FieldValue, ATIndexList] = getatfield(Family, Field, varargin)
%GETATFIELD - Returns the contents of an AT model field
%  [FieldValue, ATIndex] = getatfield(Family, Field, DeviceList, RowSubIndex, ColSubIndex)
%
%  INPUTS
%  1. Family - Family Name 
%              Accelerator Object
%              AT FamName
%  2. Field - AT field name
%  3. DeviceList - [Sector Device #] or [element #] list {Default: whole family}
%                  Note: if using an AT family name, then DeviceList is an index
%                        within the AT family.
%  4. RowSubIndex - Row element index within the AT field {Default: the entire field}
%  5. ColSubIndex - Column element index within the AT field {Default: the entire field}
% 
%  OUTPUTS
%  1. FieldValue - Value of the AT field
%  2. ATIndex - AT index

%  Written by Greg Portmann


global THERING

if nargin < 2
    error('Must have at least Family and Field inputs.');
end

if length(varargin) >= 1
    ATIndexList = family2atindex(Family, varargin{1});
else
    ATIndexList = family2atindex(Family);
end

if isempty(ATIndexList)
    % Try an AT family
    ATIndexList = findcells(THERING, 'FamName', Family);
    ATIndexList = ATIndexList(:);
    if length(varargin) >= 1
        ATIndexList = ATIndexList(varargin{1});
    end
end

if length(ATIndexList) == 1
    if isfield(THERING{ATIndexList}, Field)
        if length(varargin) == 2
            FieldValue = THERING{ATIndexList}.(Field)(varargin{2},:);
        elseif length(varargin) >= 3
            FieldValue = THERING{ATIndexList}.(Field)(varargin{2},varargin{3});
        else
            FieldValue = THERING{ATIndexList}.(Field);
        end
    else
        FieldValue = NaN;
    end
else
    for i = 1:size(ATIndexList,1)
        if isfield(THERING{ATIndexList(i)}, Field)
            if length(varargin) == 2
                FieldValue(i,:) = THERING{ATIndexList(i)}.(Field)(varargin{2},:);
            elseif length(varargin) >= 3
                FieldValue(i,:) = THERING{ATIndexList(i)}.(Field)(varargin{2},varargin{3});
            else
                FieldValue(i,:) = THERING{ATIndexList(i)}.(Field);
            end
        else
            if length(varargin) >= 2
                FieldValue(i,:) = NaN * ones(1,length(varargin{2}));
            else
                FieldValue(i,:) = NaN;
            end
        end
    end
end

