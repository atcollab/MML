function mRes = idAuxMergeCorTableWithArg2D(vArg1, vArg2, mCor)

sizeArg1 = size(mCor, 1);
sizeArg2 = size(mCor, 2);

lenArg1 = length(vArg1);
lenArg2 = length(vArg2);

if((sizeArg1 ~= lenArg1) || (sizeArg2 ~= lenArg2))
    sprintf('Inconsistent lengths of the matrix and the argument vectors');
end

mRes = zeros(lenArg1 + 1, lenArg2 + 1);
mRes(1, 1) = 0;
for i = 1:lenArg1
    mRes(i + 1, 1) = vArg1(i);
end

for j = 1:lenArg2
    mRes(1, j + 1) = vArg2(j);
    for i = 1:lenArg1
        mRes(i + 1, j + 1) = mCor(i, j);
    end
end
