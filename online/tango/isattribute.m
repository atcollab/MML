function Flag = isattribute(attributename)
% ISTANGO - Checks whether input looks like a attribute name
% flag = isattribute(attributename)
%
%  INPUTS
%  1. attributename - Attribute name

%  OUTPUTS
%  1. Flag - 1 if true
%             2 if wrong
%
%  NOTES
%  No check is done with the static tango database
%  Just look if of the form: ENSEMBLE/DOMAINE/EQUIPEMENT/ATTRIBUTE
%   
%  See Also isfamily

Flag = 1;

if length(regexp(attributename,'/')) ~= 3
    Flag = 0;
end


