function sirius_set_sextupole_fields
%2015-10-22 Luana

global THERING;

Data = sirius_si_family_data(THERING);

SXFamilies = findmemberof('SEXT');
CHFamilies = findmemberof('HCM');
CVFamilies = findmemberof('VCM');
QSFamilies = findmemberof('SkewQuad');

AllSXIndices = [];
for i=1:size(SXFamilies,1)
    SXFamily = deblank(SXFamilies{i});
    SXIndex = Data.(SXFamily).ATIndex;
    AllSXIndices = [AllSXIndices, SXIndex(:).'];
end

AllCHIndices = [];
for i=1:size(CHFamilies,1)
    CHFamily = deblank(CHFamilies{i});
    CHIndex = Data.(CHFamily).ATIndex;
    AllCHIndices = [AllCHIndices, CHIndex(:).'];
end

for i=1:size(CVFamilies,1)
    CVFamily = deblank(CVFamilies{i});
    CVIndex = Data.(CVFamily).ATIndex;
    CVIndex = CVIndex(:).';
    for j=1:length(CVIndex)
        if find(AllSXIndices == CVIndex(j))
            THERING{CVIndex(j)}.CV = THERING{CVIndex(j)}.PolynomA(1);
            THERING{CVIndex(j)}.SX = THERING{CVIndex(j)}.PolynomB(3);
        elseif find(AllCHIndices == CVIndex(j))
            THERING{CVIndex(j)}.CV = THERING{CVIndex(j)}.PolynomA(1);
            THERING{CVIndex(j)}.CH = THERING{CVIndex(j)}.PolynomB(1);
        end
    end   
end

for j=1:length(AllCHIndices)
    if find(AllSXIndices == AllCHIndices(j))
        THERING{AllCHIndices(j)}.CH = THERING{AllCHIndices(j)}.PolynomB(1);
        THERING{AllCHIndices(j)}.SX = THERING{AllCHIndices(j)}.PolynomB(3);
    end
end    

for i=1:size(QSFamilies,1)
    QSFamily = deblank(QSFamilies{i});
    QSIndex = Data.(QSFamily).ATIndex;
    QSIndex = QSIndex(:).';
    for j=1:length(QSIndex)
        if find(AllSXIndices == QSIndex(j))
            THERING{QSIndex(j)}.QS = THERING{QSIndex(j)}.PolynomA(2);
            THERING{QSIndex(j)}.SX = THERING{QSIndex(j)}.PolynomB(3);
        end
    end       
end


end