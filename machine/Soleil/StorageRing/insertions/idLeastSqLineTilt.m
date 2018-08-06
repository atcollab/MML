function k = idLeastSqLineTilt(arArg, arFunc)

k = 0;
numArg = length(arArg);
numFunc = length(arFunc);

if (numArg ~= numFunc)
    sprintf('Inconsistent numbers of points in the argument and function values arrays');
    return;
end

s1 = 0;
s2 = 0;
for i = 1:numArg
    s1 = s1 + arArg(i)*arFunc(i);
    s2 = s2 + arArg(i)*arArg(i);
end
k = s1/s2;