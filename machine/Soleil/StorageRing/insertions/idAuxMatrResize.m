function mRes = idAuxMatrResize(m, newSizeDim1, newSizeDim2)

sizeDim1 = size(m, 1);
sizeDim2 = size(m, 2);

sizeDim1_min = sizeDim1;
sizeDim2_min = sizeDim2;

if(sizeDim1_min > newSizeDim1)
	sizeDim1_min = newSizeDim1;
end
if(sizeDim2_min > newSizeDim2)
	sizeDim2_min = newSizeDim2;
end

mRes = zeros(newSizeDim1, newSizeDim2);
for i1 = 1:sizeDim1_min
    for i2 = 1:sizeDim2_min
        mRes(i1, i2) = m(i1, i2);
    end
end
