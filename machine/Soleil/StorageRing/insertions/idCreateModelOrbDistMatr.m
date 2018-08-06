%function outM = idCreateModelOrbDistMatr(x_or_z, ModelData, indUpstrBPM, sectLenBwBPMs, idCenPos, idLen, idKickOfst)
function outM = idCreateModelOrbDistMatr(x_or_z, ModelData, GeomParUnd)

% Creates orbit distortion matrix to simulate effect of an ID on e-beam
% transverse positions along the ring

indDownstrBPM = GeomParUnd.indUpstrBPM + 1; % To precise this
if indDownstrBPM == 121
    indDownstrBPM = 1;
end

ringCircum = ModelData.circ; %354; % [m]
alpMomCompact = ModelData.alp1; %0.0004; % Ask Laurent or Pascale

%numBPMsToSkip = length(arIndsBPMsToSkip);

%[Btx, Btz] = modelbeta(strBPM);
%[Alpx, Alpz] = modeltwiss('alpha', strBPM);
%[Etax, Etaz] = modeldisp(strBPM); % Ask Laurent or Pascale
%[Phx, Phz] = modelphase(strBPM);
%Nuxz = modeltune;

Bt = ModelData.Btx; Alp = ModelData.Alpx; Eta = ModelData.Etax; Ph = ModelData.Phx; Nu = ModelData.Nuxz(1);
if strcmp(x_or_z, 'z') ~= 0
	Bt = ModelData.Btz; Alp = ModelData.Alpz; Eta = ModelData.Etaz; Ph = ModelData.Phz; Nu = ModelData.Nuxz(2);
end

distUpstrBPM_Kick1 = GeomParUnd.idCenPos - 0.5*GeomParUnd.sectLenBwBPMs - 0.5*GeomParUnd.idLen + GeomParUnd.idKickOfst;
distUpstrBPM_Kick2 = GeomParUnd.idCenPos - 0.5*GeomParUnd.sectLenBwBPMs + 0.5*GeomParUnd.idLen - GeomParUnd.idKickOfst;
btUpstr = Bt(GeomParUnd.indUpstrBPM);
alpUpstr = Alp(GeomParUnd.indUpstrBPM);
etaUpstr = Eta(GeomParUnd.indUpstrBPM);
etaDownstr = Eta(indDownstrBPM);
phUpstr = Ph(GeomParUnd.indUpstrBPM);
%phDownstr = Ph(indDownstrBPM);

gamUpstr = (1 + alpUpstr*alpUpstr)/btUpstr;
twoAlpUpstr = 2*alpUpstr;
btKick1 = btUpstr - distUpstrBPM_Kick1*twoAlpUpstr + distUpstrBPM_Kick1*distUpstrBPM_Kick1*gamUpstr;
btKick2 = btUpstr - distUpstrBPM_Kick2*twoAlpUpstr + distUpstrBPM_Kick2*distUpstrBPM_Kick2*gamUpstr;

etaDifBwBPMs = etaDownstr - etaUpstr;
etaKick1 = etaUpstr + (distUpstrBPM_Kick1/GeomParUnd.sectLenBwBPMs)*etaDifBwBPMs; % Ask Laurent or Pascale
etaKick2 = etaUpstr + (distUpstrBPM_Kick2/GeomParUnd.sectLenBwBPMs)*etaDifBwBPMs;

%phDifBwBPMs = phDownstr - phUpstr;
%phKick1 = phUpstr + (distUpstrBPM_Kick1/GeomParUnd.sectLenBwBPMs)*phDifBwBPMs; % Ask Laurent or Pascale
%phKick2 = phUpstr + (distUpstrBPM_Kick2/GeomParUnd.sectLenBwBPMs)*phDifBwBPMs;
phKick1 = phUpstr + atan(alpUpstr) + atan(gamUpstr*distUpstrBPM_Kick1 - alpUpstr);
phKick2 = phUpstr + atan(alpUpstr) + atan(gamUpstr*distUpstrBPM_Kick2 - alpUpstr);

invTwoSinPiNu = 1./(2.*sin(pi*Nu));
invAlpCircum = 1./(alpMomCompact*ringCircum);
numBPMsAr = size(Bt);
numBPMs = numBPMsAr(1);
%outM = zeros(numBPMs - numBPMsToSkip, 2);
outM = zeros(numBPMs, 2);

%countBPM = 1;
for i = 1:numBPMs
    %if(numBPMsToSkip > 0)
    %    skipThisBPM = 0;
    %    for j = 1:numBPMsToSkip
    %        if(i == arIndsBPMsToSkip(j))
    %            skipThisBPM = 1;
    %            break;
    %    	end
    %    end
    %    if(skipThisBPM ~= 0)
    %        continue;
    %    end
    %end
    
    %outM(countBPM, 1) = invTwoSinPiNu*sqrt(Bt(i)*btKick1)*cos(abs(Ph(i) - phKick1) - pi*Nu) + invAlpCircum*Eta(i)*etaKick1;
    %outM(countBPM, 2) = invTwoSinPiNu*sqrt(Bt(i)*btKick2)*cos(abs(Ph(i) - phKick2) - pi*Nu) + invAlpCircum*Eta(i)*etaKick2;
    %countBPM = countBPM + 1; 
    
    outM(i, 1) = invTwoSinPiNu*sqrt(Bt(i)*btKick1)*cos(abs(Ph(i) - phKick1) - pi*Nu) + invAlpCircum*Eta(i)*etaKick1;
    outM(i, 2) = invTwoSinPiNu*sqrt(Bt(i)*btKick2)*cos(abs(Ph(i) - phKick2) - pi*Nu) + invAlpCircum*Eta(i)*etaKick2;
end
