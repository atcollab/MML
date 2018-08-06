function res = idSetCorCurSync(idName, curToSetCHE, curToSetCVE, curToSetCHS, curToSetCVS, curAbsTol)

res = 0;
idDevServCor01 = '';
idDevServCor02 = '';
idDevServCor03 = '';
idDevServCor04 = '';
curCh01 = 0;
curCh02 = 0;
curCh03 = 0;
curCh04 = 0;

if strcmp(idName, 'HU80_TEMPO')
    
%First call after turning on the correctors should be: idSetCorCurSync('HU80_TEMPO', 0., 0.1, 0, 0.1, 0.001)

	idDevServCor01 = 'ans-c08/ei/m-hu80.2_chan1';
	idDevServCor02 = 'ans-c08/ei/m-hu80.2_chan2';
	idDevServCor03 = 'ans-c08/ei/m-hu80.2_chan3';
	idDevServCor04 = 'ans-c08/ei/m-hu80.2_chan4';
    
	%curCh01 = 0.5*(curToSetCHE + curToSetCVE);
	%curCh02 = 0.5*(curToSetCHE - curToSetCVE);
	%curCh03 = 0.5*(curToSetCHS + curToSetCVS);
	%curCh04 = 0.5*(curToSetCHS - curToSetCVS);
    
	curCh01 = 0.5*(-curToSetCVE - curToSetCHE);
	curCh02 = 0.5*(-curToSetCVE + curToSetCHE);
	curCh03 = 0.5*(-curToSetCVS - curToSetCHS);
	curCh04 = 0.5*(-curToSetCVS + curToSetCHS);

end

res = idSetCurrentSync(idDevServCor01, curCh01, curAbsTol);
if res ~= 0
    return;
end
res = idSetCurrentSync(idDevServCor02, curCh02, curAbsTol);
if res ~= 0
    return;
end
res = idSetCurrentSync(idDevServCor03, curCh03, curAbsTol);
if res ~= 0
    return;
end
res = idSetCurrentSync(idDevServCor04, curCh04, curAbsTol);
if res ~= 0
    return;
end

