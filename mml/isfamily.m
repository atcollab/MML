function  [FamilyFlag, AO] = isfamily(Family, Field)
%ISFAMILY - True for family names
%  [Flag, Structure] = isfamily(Family)
%
%  INPUTS
%  1. FamilyName or Data Structure 
%     (only the FamilyName field is used for Data Structure inputs)
%  2. Field - Middlelayer field name (optional)
%
%  OUTPUTS
%  1. Flag = 1 if FamilyName is a family
%            0 if no family name was found
%  2. Structure - the middle layer data structure for that family
%                 or the data structure for that field if Field is input.
%
%  NOTES
%  1. For string matrix inputs a column vector is returned.
%     However, the Structure output will be for the last row.
%  2. Family and Field names are case sensitive. 
%
%  See also getmemberof, findmemberof

%  Written by Greg Portmann


if nargin == 0,
    error('Must have at least one input (''Family'')!');
end                    

if isstruct(Family)
    
    if isfield(Family,'FamilyName') && isfield(Family, 'Field')
        % Data structure: find the AO
        [FamilyFlag, AO] = isfamily(Family.FamilyName);
    elseif isfield(Family,'FamilyName')
        % AO structure: use the same structure
        FamilyFlag = 1;
        AO = Family;
    else
        %error('Family input of unknown type');
        AO = [];
        FamilyFlag = 0;
    end
    
elseif isnumeric(Family)
    FamilyFlag = 0;
    AO = [];

elseif size(Family,1) > 1
    
    for i = 1:size(Family, 1)
        if nargin == 1
            [FamilyFlag(i,1), AO] = isfamily(Family(i,:));
        else
            if size(Family,1) == size(Field,1)
                [FamilyFlag(i,1), AO] = isfamily(Family(i,:), Field(i,:));
            elseif size(Field,1) == 1
                [FamilyFlag(i,1), AO] = isfamily(Family(i,:), Field);
            else
                error('Field must be 1 row or equal to the number of rows in Family');
            end
        end
    end
        
else
    
    AO = getao;
    if isempty(AO)
        fprintf('   ACCELERATOR_OBJECT is empty.  Initialization is needed (aoinit).\n');
        AO = [];
        FamilyFlag = 0;        
        return
    end
        
    if ~ischar(Family)
        error('Family input must be a string.');
    end
    Family = deblank(Family);
    
    if nargin > 1
        if ~ischar(Field)
            error('Field input must be a string.');
        end
        Field = deblank(Field);
    end

    if isfield(AO, Family)
        FamilyFlag = 1;
        AO = AO.(Family);

        if nargin > 1
            if ~isempty(Field)
                if isfield(AO, Field)
                    FamilyFlag = 1;
                    AO = AO.(Field);
                else
                    FamilyFlag = 0;
                    AO = [];
                end
            end
        end
    else
        FamilyFlag = 0;
        AO = [];
    end
end
