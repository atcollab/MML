
%i0=176; j=17;
%stMeasBkgExtraII{i0+1} = {stListG15_5.filelist{j}, stListG15_5.filelist{18}};
%stMeasBkgExtraII{i0+2} = {stListG16.filelist{j}, stListG16.filelist{18}};
%stMeasBkgExtraII{i0+3} = {stListG18.filelist{j}, stListG18.filelist{18}};
%stMeasBkgExtraII{i0+4} = {stListG20.filelist{j}, stListG20.filelist{18}};
%stMeasBkgExtraII{i0+5} = {stListG22_5.filelist{j}, stListG22_5.filelist{18}};
%stMeasBkgExtraII{i0+6} = {stListG25.filelist{j}, stListG25.filelist{18}};
%stMeasBkgExtraII{i0+7} = {stListG27_5.filelist{j}, stListG27_5.filelist{18}};
%stMeasBkgExtraII{i0+8} = {stListG30.filelist{j}, stListG30.filelist{18}};
%stMeasBkgExtraII{i0+9} = {stListG35.filelist{j}, stListG35.filelist{18}};
%stMeasBkgExtraII{i0+10} = {stListG40.filelist{j}, stListG40.filelist{18}};
%stMeasBkgExtraII{i0+11} = {stListG50.filelist{j}, stListG50.filelist{18}};


lineToStartCopy = 1;
lineToEndCopy = 11;

%colToStartCop
numCols = 17;
for i = lineToStartCopy:lineToEndCopy
    for j = 1:numCols
        mCHE_new_parts(i, j) = mCHE_ext(i, j);
        mCHS_new_parts(i, j) = mCHS_ext(i, j);
        mCVE_new_parts(i, j) = mCVE_ext(i, j);
        mCVS_new_parts(i, j) = mCVS_ext(i, j);
    end
end


