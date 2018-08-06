function AccObj = uminus(AccObj)
%UMINUS - uminus (-A) for AccObj class
%
%  Written by Greg Portmann


Families = fieldnames(AccObj);

for i = 1:length(Families)
    AccObj.(Families{i}).Data = -AccObj.(Families{i}).Data;
end


