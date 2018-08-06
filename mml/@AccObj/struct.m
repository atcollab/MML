function OutputStruct = struct(AccObj, Families, Field)
%STRUCT - Struct for AccObj class
%  OutputStruct = struct(AccObj, Family)
%
%  INPUTS
%  1. AccObj
%  2. Family - Family name or cell array of families
%
%  Written by Greg Portmann


OutputStruct = [];

%if isa(AccObj, 'AccObj')
    if nargin >= 2
        if ~iscell(Families)
            Families = {Families};
        end
        for i = 1:length(Families)
            if nargin >= 3
                OutputStruct.(Families{i}) = AccObj.(Families{i}).(Field);
            else
                OutputStruct.(Families{i}) = AccObj.(Families{i});
            end
        end
    else
        Families = fieldnames(AccObj);
        for i = 1:length(Families)
            % if ~isempty(AccObj.(Families{i}))
                 OutputStruct.(Families{i}) = AccObj.(Families{i});
            % end
        end
    end
%end

