function modelsextu_on
% MODELSEXTU_ON - Turns on sextupoles in the AT model
%
% See also modelsextu_off

%
% Written By Laurent S. Nadolski

global THERING

list = getfamilylist;

idx = [];

for jk = 1:length(list)
    fam = deblank(list(jk,:));
    if ismemberof(fam,'SEXT')
        idx = [idx ; family2atindex(fam)];
    end
end

for jk = 1:length(idx)        
    THERING{idx(jk)}.PassMethod = 'StrMPoleSymplectic4Pass';
end        

disp('** Sextupoles turned on in the model **');
