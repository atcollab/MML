function resFileNames = idAuxPrepFileNameListMeasAndBkg(origFileNameList, perMeasWithoutBkg)

numCycles = floor(length(origFileNameList)/(perMeasWithoutBkg + 1));

i0 = 0;
i0r = 0;
for i = 1:numCycles
    iBkg = i0 + (perMeasWithoutBkg + 1);
    for j = 1:perMeasWithoutBkg
        resFileNames{i0r + j} = {origFileNameList{i0 + j}, origFileNameList{iBkg}};
    end
    i0r = i0r + perMeasWithoutBkg;
    i0 = i0 + (perMeasWithoutBkg + 1);
end
