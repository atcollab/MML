function [DeviceList, ErrorFlag] = tango2dev(TangoNames, FamilyList)
%TANGO2DEV - Convert TANGO name to device liste name
%  [DeviceList, ErrorFlag] = tango2dev(TangoName, Family)
%
%  INPUTS
%  1. TangoNames = List of Tango names (string, matrix, or cell array)
%  2. Family = optional input to limit the search (string, matrix, structure, or cell array)
%
%  OUTPUTS
%  1. DeviceList = DeviceList name corresponding to the channel name
%                 If the TangoNames cannot be found an empty matrix
%                 (or a [NaN NaN] for matrix inputs) is returned
%  2. ErrorFlag = Number of errors found
%
%  EXAMPLES
%  1. tango2dev('ANS-C01/DGsim/BPM.1/X')
%  2. tango2dev({'ANS-C01/DGsim/BPM.1/X'; 'ANS-C01/DGsim/BPM.2/X'})
%
%  See Also tango2family, dev2tango, tango2common

%
% Written by Laurent S. Nadolski
% Revision 26 feb 2005: row feature turned off for cells

if nargin < 1
    error('Must have 1 input (''TangoNames'')');
end
if nargin < 2
    FamilyList = [];
end

% Cell inputs
if iscell(TangoNames)
    if iscell(FamilyList)
        if length(FamilyList) ~= length(TangoNames)
            error('Family and TangoNames must be the same size cell arrays.');
        end
    end

    for i = 1:length(TangoNames)
        if iscell(FamilyList)
            [DeviceList{i}, ErrorFlag{i}] = tango2dev(TangoNames{i}, FamilyList{i});
        else
            [DeviceList{i}, ErrorFlag{i}] = tango2dev(TangoNames{i}, FamilyList);
        end
    end
    return;
end
% End cell input

ErrorFlag = 0;
DeviceList = [];

%% Set FamilyList
if isempty(FamilyList)
    FamilyList = getfamilylist;
elseif isstruct(FamilyList)
    % Structures are ok
    FamilyList = FamilyList.FamilyName;
end

for i = 1:size(TangoNames,1)
    Found = 0;
    for l = 1:size(FamilyList, 1)
        FamilyTest = deblank(FamilyList(l,:));
        Fields = fieldnames(getfamilydata(FamilyTest));

        for m = 1:length(Fields)
            TangoNamesTotal = getfamilydata(FamilyTest, Fields{m}, 'TangoNames');
            if ~isempty(TangoNamesTotal)
                Name = deblank(TangoNames(i,:));
                if iscell(TangoNamesTotal)
                    [name,j,k] = intersect(Name, TangoNamesTotal);
                else
                    [name,j,k] = intersect(Name, TangoNamesTotal, 'rows');
                end
                if isempty(name) & length(Name) ~= size(TangoNamesTotal)
                    Name = [repmat(' ',size(Name,1),size(TangoNamesTotal,2)-size(Name,2)) Name];
                    if iscell(TangoNamesTotal)
                        [name,j,k] = intersect(Name, TangoNamesTotal);
                    else
                        [name,j,k] = intersect(Name, TangoNamesTotal, 'rows');
                    end
                end
                if isempty(name)
                    Name = deblank(TangoNames(i,:));
                    if length(Name)~=size(TangoNamesTotal)
                        Name = [Name repmat(' ',size(Name,1),size(TangoNamesTotal,2)-size(Name,2))];
                        if iscell(TangoNamesTotal)
                            [name,j,k] = intersect(Name, TangoNamesTotal);
                        else
                            [name,j,k] = intersect(Name, TangoNamesTotal, 'rows');
                        end
                    end
                end
                if ~isempty(k)
                    Found = 1;
                    break
                end
            end
            if Found
                break
            end
        end
        if Found
            break
        end
    end
    if Found
        DeviceListTotal = getfamilydata(FamilyTest,'DeviceList');
        Dev = DeviceListTotal(k,:);
    else
        Dev = [NaN NaN];
        ErrorFlag = ErrorFlag + 1;
    end

    DeviceList = [DeviceList; Dev];
end

if all(isnan(DeviceList))
    DeviceList = [];
end
% End all family search
