function [CommonNames, ErrorFlag] = tango2common(TangoNames, Field, Family);
%TANGO2COMMON - Converts TANGO name to common name
% [CommonNames, ErrorFlag] = tango2common(TangoNames, Field, Family)
%
%  INPUTS
%  1. TangoNames = List of Tango names (string, matrix, cell array)
%  2. Field = Accelerator Object field name ('Monitor', 'Setpoint', etc) {'Monitor'}
%  3. Family = Family Name
%              Accelerator Object
%              Cell Array of Accelerator Objects or Family Names
%              [] search all families {default}
%
%  OUPUTS
%  1. CommonNames = Common names corresponding to the Tango name
%                   If the common name cannot be found an empty strings
%                   (or a blank string for matrix inputs) is returned
%  2. ErrorFlag = Number of errors found
%
%  NOTES
%  1. TangoNames can be a cell array when Field and Family are not
%  2. For DataType='vector' only the first common names is returned (DeviceList would be needed as an input)
%
%  EXAMPLES
%  1. tango2common('ANS-C01/DGsim/BPM.1/X')
%
% See Also tango2dev, tango2family, common2family

%
% Written by Laurent Nadolski
% Revision 26 feb 2005: row feature turned off for cells

if nargin < 1
    error('Must have at least 1 input (''TangoNames'')');
end
if nargin < 2
    Field = 'Monitor';
end
if isempty(Field)
    Field = 'Monitor';
end
if nargin < 3
    Family = [];
end

%% Cell inputs
if iscell(TangoNames)
    if iscell(Family)
        if length(Family) ~= length(TangoNames)
            error('Family and TangoNames must be the same size cell arrays.');
        end
    end
    if iscell(Field)
        if length(Field) ~= length(TangoNames)
            error('Field and TangoNames must be the same size cell arrays.');
        end
    end

    for i = 1:length(TangoNames)
        if iscell(Family)
            if iscell(Field)
                [CommonNames{i}, ErrorFlag{i}] = tango2common(TangoNames{i}, Field{i}, Family{i});
            else
                [CommonNames{i}, ErrorFlag{i}] = tango2common(TangoNames{i}, Field, Family{i});
            end
        else
            if iscell(Field)
                [CommonNames{i}, ErrorFlag{i}] = tango2common(TangoNames{i}, Field{i}, Family);
            else
                [CommonNames{i}, ErrorFlag{i}] = tango2common(TangoNames{i}, Field, Family);
            end
        end
    end
    return
end
% End cell input

%% Search all families
if isempty(Family)
    CommonNames = [];
    ErrorFlag = 0;
    FamilyList = getfamilylist;

    for i = 1:size(TangoNames,1)
        Name = deblank(TangoNames(i,:));
        Found = 0;
        for j = 1:size(FamilyList, 1)            
            CommonName = tango2common(Name, Field, deblank(FamilyList(j,:)));
            if ~isempty(CommonName)
                Found = 1;
                break
            end
        end
        if Found
            NewCommonName = CommonName;
        else
            NewCommonName = ' ';
            ErrorFlag = ErrorFlag + 1;
        end
        CommonNames = strvcat(CommonNames, NewCommonName);
    end
    CommonNames = deblank(CommonNames);
    return
end


%% CommonNames can be a matrix
CommonNames = [];
ErrorFlag = 0;
for i = 1:size(TangoNames,1)
    Name = deblank(TangoNames(i,:));

    TangoNamesTotal = getfamilydata(Family, Field, 'TangoNames');
    
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
        CommonNamesTotal = getfamilydata(Family, 'CommonNames');

        if isempty(CommonNamesTotal)
            NewCommonName = ' ';
            ErrorFlag = ErrorFlag + 1;
        else
            NewCommonName = CommonNamesTotal(k,:);
        end
    else
        NewCommonName = ' ';
        ErrorFlag = ErrorFlag + 1;
    end
    CommonNames = strvcat(CommonNames, NewCommonName);
end

CommonNames = deblank(CommonNames);
