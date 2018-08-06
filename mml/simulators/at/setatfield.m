function ATIndexList = setatfield(Family, Field, Value, varargin)
%SETATFIELD - Returns the contents of an AT model field
%  ATIndex = setatfield(Family, Field, Value, DeviceList, RowSubIndex, ColSubIndex)
%
%  INPUTS
%  1. Family - Family Name 
%              Accelerator Object
%              AT FamName
%  2. Field - AT field name
%  3. Value - New AT value
%  4. DeviceList - [Sector Device #] or [element #] list {Default: whole family}
%                  Note: if using an AT family name, then DeviceList is an index
%                        within the AT family.
%  5. RowSubIndex - Row element index within the AT field {Default: the entire field}
%  6. ColSubIndex - Column element index within the AT field {Default: the entire field}
% 
%  OUTPUTS
%  1. ATIndex - AT index

%  Written by Greg Portmann


global THERING

if nargin < 3
    error('Must have at least Family, Field, and Value inputs.');
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


% Check the size of Value input
if size(Value,1) ~= size(ATIndexList,1)
    if size(Value,1) == 1
        % Expand Value to as many rows as is in ATIndexList
        Value = ones(size(ATIndexList,1),1) * Value;
    else
        error('Value input have the same number of rows as devices (split magnets are one device).');
    end
end


if length(ATIndexList) == 1
    %if isfield(THERING{ATIndexList}, Field)        
        if length(varargin) == 2
            THERING{ATIndexList}.(Field)(varargin{2},:) = Value;
        elseif length(varargin) >= 3
            THERING{ATIndexList}.(Field)(varargin{2},varargin{3}) = Value;
        else
            THERING{ATIndexList}.(Field) = Value;
        end
    %else
    %    THERING{ATIndexList}.(Field) = Value;
    %end
else
    for i = 1:size(ATIndexList,1)
        for j = 1:size(ATIndexList,2)
            if ~isnan(ATIndexList(i,j))
                if length(varargin) == 2
                    if size(Value,1) == 1
                        THERING{ATIndexList(i,j)}.(Field)(varargin{2},:) = Value;
                    else
                        THERING{ATIndexList(i,j)}.(Field)(varargin{2},:) = Value(i,:);
                    end
                elseif length(varargin) >= 3
                    if size(Value,1) == 1
                        THERING{ATIndexList(i,j)}.(Field)(varargin{2},varargin{3}) = Value;
                    else
                        THERING{ATIndexList(i,j)}.(Field)(varargin{2},varargin{3}) = Value(i,:);
                    end
                else
                    if size(Value,1) == 1
                        THERING{ATIndexList(i,j)}.(Field) = Value;
                    else
                        THERING{ATIndexList(i,j)}.(Field) = Value(i,:);
                    end
                end
            end
        end
    end
end

