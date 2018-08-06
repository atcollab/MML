function [Family] = tango2family(TangoNames);
%  TANGO2FAMILY - Convert TANGO name to Family name
%  [Family] = tango2family(TangoNames)
% 
%  INPUTS 
%  1. TangoNames = List of Tango names (string, matrix, or cell array)
%
%  OUTPUTS
%  1. Family = Family name corresponding to the channel name
%     If the Tango name cannot be found an empty strings 
%     (or a blank string for matrix inputs) is returned
%     ErrorFlag = number of errors found
%
%  EXAMPLES
%  1. tango2family('ANS-C01/DGsim/BPM.1/X')

%
%  Written by Laurent S. Nadolski, SOLEIL

%
%  6/12/05 'row' option commented for intersect command
%         avoid message Warning: 'rows' flag is ignored for cell arrays  

if nargin < 1
    error('Must have 1 input (''TangoNames'')');
end

% Cell inputs
if iscell(TangoNames)
    for i = 1:length(TangoNames)
        [Family{i}, ErrorFlag{i}] = tango2family(TangoNames{i});
    end
    return    
end
% End cell input

Family = [];
FamilyList = getfamilylist;

for i = 1:size(TangoNames,1)
    if length(findstr(TangoNames(i,:),'/')) ~= 3
        error('%s is not an attribute', TangoNames(i,:))
    end
    Found = 0;
    for l = 1:size(FamilyList, 1)
        
        FamilyTest = deblank(FamilyList(l,:));
        
        Fields = fieldnames(getfamilydata(FamilyTest));
        for m = 1:length(Fields)
            TangoNamesTotal = getfamilydata(FamilyTest, Fields{m}, 'TangoNames');
            
            if ~isempty(TangoNamesTotal)
                Name = deblank(TangoNames(i,:));
                [name,j,k] = intersect(Name, TangoNamesTotal);
%                [name,j,k] = intersect(Name, TangoNamesTotal, 'rows');
                
                if isempty(name) & length(Name)~=size(TangoNamesTotal)
                    Name = [repmat(' ',size(Name,1),size(TangoNamesTotal,2)-size(Name,2)) Name];
                    [name,j,k] = intersect(Name, TangoNamesTotal);
%                     [name,j,k] = intersect(Name, TangoNamesTotal, 'rows');
                end
                
                if isempty(name)
                    Name = deblank(TangoNames(i,:));
                    if length(Name)~=size(TangoNamesTotal)
                        Name = [Name repmat(' ',size(Name,1),size(TangoNamesTotal,2)-size(Name,2))];
                        [name,j,k] = intersect(Name, TangoNamesTotal);
%                         [name,j,k] = intersect(Name, TangoNamesTotal, 'rows');
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
        FamilyTest = FamilyTest;
    else
        FamilyTest = ' ';
    end
    Family = strvcat(Family, FamilyTest);
end
Family = deblank(Family);
% End all family search



