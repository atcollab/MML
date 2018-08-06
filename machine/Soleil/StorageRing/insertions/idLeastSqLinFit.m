function resV = idLeastSqLinFit(M, V, arIndsBPMsToSkip)

numBPMs = length(V);
numBPMsToSkip = length(arIndsBPMsToSkip);
actNumBPMs = numBPMs - numBPMsToSkip;
if(numBPMsToSkip <= 0)
    workM = M;
    workV = V;
else
    workM = zeros(actNumBPMs, 2);
    workV = zeros(actNumBPMs, 1);
    countBPM = 1;
    for i = 1:numBPMs
        skipThisBPM = 0;
        for j = 1:numBPMsToSkip
            if(i == arIndsBPMsToSkip(j))
                skipThisBPM = 1;
                break;
        	end
        end
        if(skipThisBPM ~= 0)
            continue;
        end
        
        workV(countBPM) = V(i);
        workM(countBPM, 1) = M(i, 1);
        workM(countBPM, 2) = M(i, 2);
        countBPM = countBPM + 1; 
    end
end

transpM = workM';
squareM = transpM*workM;
invSquareM = inv(squareM);
finM = invSquareM*transpM;
resV = finM*workV;
