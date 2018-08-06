function ErrorFlag = switch2online(Family, DisplayFlag)
%SWITCH2ONLINE - Switch family to online mode
%                If a SpecialFunction exist, then the mode is set to special.
%                If the family is in manual, then the mode is not changed.
%
%  ErrorFlag = switch2online(Family)
%
%  INPUTS 
%  1. Family - Family name string  {Default: All families}
%              Matrix of family name strings
%              Cell array of family name strings
%
%  OUTPUTS
%  1. ErrorFlag - Number of errors that occurred
%
%  See also switch2sim, switch2manual

%  Written by Greg Portmann


ErrorFlag = 0;
SpecialCount = 0;
ManualCount = 0;

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
    ManualFlag = 0;
    SpecialFlag = 0;
    try
        AllFields = fieldnames(AOFamily);
        for j = 1:length(AllFields)
            if isfield(AOFamily.(AllFields{j}),'Mode')
                if isfield(AOFamily.(AllFields{j}), 'SpecialFunction') % | isfield(AOFamily.(AllFields{j}), 'SpecialFunctionGet') | isfield(AOFamily.(AllFields{j}), 'SpecialFunctionSet')
                    setfamilydata('Special', AOFamily.FamilyName, AllFields{j}, 'Mode');
                    SpecialFlag = SpecialFlag + 1;
                elseif strcmpi(AOFamily.(AllFields{j}).Mode,'Manual')
                    % No change
                    ManualFlag = ManualFlag + 1;
                else
                    setfamilydata('Online', AOFamily.FamilyName, AllFields{j}, 'Mode');
                end
            end
        end
    catch
        ErrorFlag = ErrorFlag + 1;
        fprintf('   Error switching %s family to online mode, hence ignored (switch2online)\n', FamilyNameCell{i});        
    end
    if SpecialFlag
        SpecialCount = SpecialCount + 1;
    end
    if ManualFlag
        ManualCount = ManualCount + 1;
    end
end


if ~ErrorFlag
    if length(FamilyNameCell)==1 && ManualCount==0 && SpecialCount==0
        if DisplayFlag
            fprintf('   Switched %s family to online mode (%s)\n', FamilyNameCell{1}, datestr(clock,0));
        end
    else
        if DisplayFlag
            fprintf('   Switched %d families to online mode (%s)\n', length(FamilyNameCell)-ErrorFlag-ManualCount-SpecialCount, datestr(clock,0));
        end
        if SpecialCount == 1
            if DisplayFlag
                fprintf('   Switched %d family to special mode (%s)\n', SpecialCount, datestr(clock,0));
            end
        elseif SpecialCount > 1
            if DisplayFlag
                fprintf('   Switched %d families to special mode (%s)\n', SpecialCount, datestr(clock,0));
            end
        end
        if ManualCount == 1
            if DisplayFlag
                fprintf('   %d family stayed in manual mode (%s)\n', ManualCount, datestr(clock,0));
            end
        elseif ManualCount > 1
            if DisplayFlag
                fprintf('   %d families stayed in manual mode (%s)\n', ManualCount, datestr(clock,0));
            end
        end
    end
end


