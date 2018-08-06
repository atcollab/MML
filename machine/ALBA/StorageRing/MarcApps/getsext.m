function [value]=setsext(family)
elements=family2atindex(family);
value=zeros(length(elements),1);
global THERING
for loop=1:length(elements),
    value(loop)=THERING{elements(loop)}.PolynomB(3);
end