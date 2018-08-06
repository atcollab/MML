function modelkvalues(THERING)

indx=atindex(THERING);

%quads
families={'QF';'QD';'QFC';'QDX';'QFX';'QDY';'QFY';'QDZ';'QFZ';}; 
for j=1:length(families)
    disp(families{j})
for k=1:length(indx.(families{j})) 
    disp(num2str(THERING{indx.(families{j})(k)}.K)); 
end
end

%sextupoles
families={'SF';'SD';'SFM';'SDM';}; 
indx=atindex(THERING);

for j=1:length(families)
    disp(families{j})
for k=1:1 
    disp(num2str(THERING{indx.(families{j})(k)}.PolynomB(3))); 
end
end