function mRes = idAuxCombMatrCols(m1, m2)

numCols_m1 = size(m1, 2);
numCols_m2 = size(m2, 2);
numColsRes = numCols_m1 + numCols_m2;

numRows_m1 = size(m1, 1);
numRows_m2 = size(m2, 1);
if(numRows_m1 ~= numRows_m2)
    sprintf('Inconsistent numbers of rows in the matrices');
    return;
end
numRowsRes = numRows_m1;

mRes = zeros(numRowsRes, numColsRes);

for i2 = 1:numCols_m1
    for i1 = 1:numRowsRes
        mRes(i1, i2) = m1(i1, i2);
    end
end
for i2 = 1:numCols_m2
    for i1 = 1:numRowsRes
        mRes(i1, numCols_m1 + i2) = m2(i1, i2);
    end
end
