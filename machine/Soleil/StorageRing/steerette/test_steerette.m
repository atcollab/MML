
global THERING
% index des BPM
index_BPM = family2atindex('BPMx');
%index_premier_element = family2atindex('K4');
index_premier_element = family2atindex('PtINJ');

setsp('HCOR',0,'model');

jBPMmax = 10;
for jBPM = 1:jBPMmax
    M66 = eye(6);
    for i = index_premier_element:index_BPM(jBPM)
        elem = THERING{i};
        Melem66 = findelemm66(elem,elem.PassMethod,[0 0 0 0 0 0]');
        M66 = Melem66 * M66;
    end
%     R11(jBPM) = M66(1,1);
%     R12(jBPM) = M66(1,2);
    R15ssacor(jBPM) = M66(1,5);
    R16sscor(jBPM,:) = M66(:,6);
end

getam('HCOR','model')
setsp('HCOR',8,'model');

for jBPM = 1:jBPMmax
    M66 = eye(6);
    for i = index_premier_element:index_BPM(jBPM)
        elem = THERING{i};
        Melem66 = findelemm66(elem,elem.PassMethod,[0 0 0 0 0 0]');
        M66 = Melem66 * M66;
    end
%     R11(jBPM) = M66(1,1);
%     R12(jBPM) = M66(1,2);
   R15avecacor(jBPM) = M66(1,5);
    R16aveccor(jBPM,:) = M66(:,6);
end

R15sscor
R15aveccor
R16sscor
R16aveccor
diff = R16aveccor - R16sscor
setsp('HCOR',0,'model');