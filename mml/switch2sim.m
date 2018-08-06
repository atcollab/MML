function ErrorFlag = switch2sim(Family, DisplayFlag)
%SWITCH2SIM - Switch family to simulator mode if the family is in online mode.
%             If the family is in manual or special mode no change is made.
%
%  ErrorFlag = switch2sim(Family)
%
%  INPUTS 
%  1. Family - Family name string  {Default: All families}
%              Matrix of family name strings
%              Cell array of family name strings
%
%  OUTPUTS
%  1. ErrorFlag - Number of errors that occurred
%
%  See also switch2online, switch2manual

%  Written by Greg Portmann


ErrorFlag = 0;

if nargin == 0
    Family = '';
end
if isempty(Family)
    Family = getfamilylist;
end
if nargin < 2
    DisplayFlag = 1;
end


if ischar(Family)
    for i = 1:size(Family,1)
        FamilyNameCell(i) = {deblank(Family(i,:))};
    end
elseif iscell(Family)
    FamilyNameCell = Family;
else
    error('Familyname input must be empty, a string matrix, or a cell array of strings');
end


for i = 1:length(FamilyNameCell)
    AOFamily = getfamilydata(FamilyNameCell{i});
    try
        AllFields = fieldnames(AOFamily);
        for j = 1:length(AllFields)
            if isfield(AOFamily.(AllFields{j}),'Mode')
                %if strcmpi(AOFamily.(AllFields{j}).Mode,'Online') | strcmpi(AOFamily.(AllFields{j}).Mode,'Special')
                setfamilydata('Simulator', AOFamily.FamilyName, AllFields{j}, 'Mode');
                %end
            end
        end
    catch
        ErrorFlag = ErrorFlag + 1;
        fprintf('   Error switching %s family to simulator, hence ignored (switch2sim)\n', FamilyNameCell{i});        
    end
end


if ~ErrorFlag
    if length(FamilyNameCell) == 1
        if DisplayFlag
            fprintf('   Switched %s family to simulator mode (%s)\n', FamilyNameCell{1}, datestr(clock,0));
        end
    else
        if DisplayFlag
            fprintf('   Switched %d families to simulator mode (%s)\n', length(FamilyNameCell)-ErrorFlag, datestr(clock,0));
        end
    end
end

