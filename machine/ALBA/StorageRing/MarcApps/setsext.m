function [output]=setsext(family, value)
elements=family2atindex(family);
global THERING;
for loop=1:length(elements),
    THERING{elements(loop)}.PolynomB(3)=value;
end