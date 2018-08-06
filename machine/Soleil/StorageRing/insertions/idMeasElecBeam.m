function outStructElecBeam = idMeasElecBeam(inStructElecBeam, inclPerturbMeas, dispData)

%On and Off e-beam size meas.:
inclSizeMeas = 1;

% Pause duration between eventual measurements of the dispersion functions and chromatisities:
pauseTime_s = 5;

% H orbit
inStructElecBeam.X = getx;
% V orbit
inStructElecBeam.Z = getz;
% Stored electron beam current
inStructElecBeam.current = getdcct;
% Tunes
inStructElecBeam.tune = gettune;
% Beam lifetime
%temp = tango_read_attribute2('ANS/DG/PUB-LifeTime','double_scalar');
%inStructElecBeam.tau = temp.value(1);

if inclPerturbMeas ~= 0
	% Measure dispersion functions. ATTENTION, it perturbes e-beam !
	[dx dz] = measdisp('Physics');
	inStructElecBeam.dx = dx;
	inStructElecBeam.dz = dz;
    %inStructElecBeam,
    pause(pauseTime_s);

	% Measure chromaticities. ATTENTION, it perturbes e-beam !
	inStructElecBeam.ksi = measchro('Physics');
else
	inStructElecBeam.dx = 0;
	inStructElecBeam.dz = 0;
    inStructElecBeam.ksi = [0, 0];
end

%E-Beam Size / Emittance measurements 
if inclSizeMeas ~= 0
    devemit = 'ANS-C02/DG/PHC-EMIT';

    numPinholeMeas = 20;
    pauseTimePinhole_s = 1;
    sumSigX = 0;
    sumSigZ = 0;
    sumEmitX = 0;
    sumEmitZ = 0;
    sumCoupling = 0;
    for j = 1:numPinholeMeas
    	sumSigX = sumSigX + readattribute([devemit '/SrcPointSigmaH']);
        sumSigZ = sumSigZ + readattribute([devemit '/SrcPointSigmaV']);
        sumEmitX = sumEmitX + readattribute([devemit '/EmittanceH']);
        sumEmitZ = sumEmitZ + readattribute([devemit '/EmittanceV']);
        sumCoupling = sumCoupling + readattribute([devemit '/Coupling']);
        pause(pauseTimePinhole_s);
    end
    inStructElecBeam.SigX = sumSigX/numPinholeMeas;
    inStructElecBeam.SigZ = sumSigZ/numPinholeMeas;
    inStructElecBeam.EmitX = sumEmitX/numPinholeMeas;
    inStructElecBeam.EmitZ = sumEmitZ/numPinholeMeas;
    inStructElecBeam.Coupling = sumCoupling/numPinholeMeas;
end

inStructElecBeam.date = datestr(now); % convert date to string
outStructElecBeam = inStructElecBeam;

if dispData ~= 0
	fprintf('I = %f\n', outStructElecBeam.current);
    %fprintf('Tau = %f\n', outStructElecBeam.tau);
    %fprintf('P=%d\n',pres)
    fprintf('nux = %f\n', outStructElecBeam.tune(1));
    fprintf('nuz = %f\n', outStructElecBeam.tune(2));
    fprintf('ksix = %f\n', outStructElecBeam.ksi(1));
    fprintf('ksiz = %f\n', outStructElecBeam.ksi(2));
    
    if inclSizeMeas ~= 0
    	fprintf('SigX = %f;  EmitX = %f\n', inStructElecBeam.SigX, inStructElecBeam.EmitX);
        fprintf('SigZ = %f;  EmitZ = %f\n', inStructElecBeam.SigZ, inStructElecBeam.EmitZ);
        fprintf('Coupling = %f\n', inStructElecBeam.Coupling);
    end
end

