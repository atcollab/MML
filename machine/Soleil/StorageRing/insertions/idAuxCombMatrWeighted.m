function mRes = idAuxCombMatrWeighted(m1, w1, m2, w2, startInd1, endInd1, startInd2, endInd2)

wNormInv = 1./sqrt(w1*w1 + w2*w2);
w1 = w1*wNormInv;
w2 = w2*wNormInv;

sizeDim1 = size(m1, 1);
sizeDim2 = size(m1, 2);
sizeDim1_m2 = size(m2, 1);
sizeDim2_m2 = size(m2, 2);

if(sizeDim1 > sizeDim1_m2)
	sizeDim1 = sizeDim1_m2;
end
if(sizeDim2 > sizeDim2_m2)
	sizeDim2 = sizeDim2_m2;
end

mRes = m1;
if(startInd1 <= 0)
    startInd1 = 1;
end
if(endInd1 <= 0)
    endInd1 = sizeDim1;
end
if(startInd2 <= 0)
    startInd2 = 1;
end
if(endInd2 <= 0)
    endInd2 = sizeDim2;
end

if(startInd1 > sizeDim1)
    sprintf('Inconsistent start value of Index 1');
    return;
end
if(startInd2 > sizeDim2)
    sprintf('Inconsistent start value of Index 2');
    return;
end
if(endInd1 > sizeDim1)
    sprintf('Inconsistent end value of Index 1');
    endInd1 = sizeDim1;
end
if(endInd2 > sizeDim2)
    sprintf('Inconsistent end value of Index 2');
    endInd2 = sizeDim2;
end

for i1 = startInd1:endInd1
    for i2 = startInd2:endInd2
        mRes(i1, i2) = w1*m1(i1, i2) + w2*m2(i1, i2);
    end
end
