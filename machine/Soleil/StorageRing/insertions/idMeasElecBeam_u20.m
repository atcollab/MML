function outStructElecBeam = idMeasElecBeam(inStructElecBeam, inclPerturbMeas, fileNameCore)

% Pause duration between eventual measurements of the dispersion functions and
% chromatisities:
pauseTime_s = 5;

% H orbit
inStructElecBeam.X = getx;
% V orbit
inStructElecBeam.Z = getz;
% Stored electron beam current
inStructElecBeam.current = getdcct;
% Tunes
inStructElecBeam.tune = gettune;

if inclPerturbMeas ~= 0
	% Measure dispersion functions. ATTENTION, it perturbes e-beam !
	[dx dz] = measdisp('Physics');
	inStructElecBeam.dx = dx;
	inStructElecBeam.dz = dz;
    inStructElecBeam,
    pause(pauseTime_s);

	% Measure chromaticities. ATTENTION, it perturbes e-beam !
	%inStructElecBeam.ksi = measchro('Physics');
end

inStructElecBeam.date = datestr(now); % convert date to string

outStructElecBeam = inStructElecBeam;

% Save the structure into a file, if necessary
%if saveRes ~= 0
if strcmp(fileNameCore, '') == 0
    %idSaveStruct(structNameToSave, fileNameCore, idName)
    %idSaveStruct(structNameToSave, 'HU80_TEMPO', 'HU80')
    
	FileName = appendtimestamp(fileNameCore);
	DirectoryName = getfamilydata('Directory','U20_PROXIMA1');
	DirStart = pwd;
	[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
	save(FileName,'-struct', 'outStructElecBeam');
    %save(FileName, inStructElecBeam);
	cd(DirStart);
end

%temp=tango_read_attribute2('ANS-C08/EI/M-HU80.2','gap');
%gap=temp.value(1)/1.e4;
gap=0;
Phase=0;
temp=tango_read_attribute2('ANS-C10/VI/PI.16','pressure');
pres=temp.value(1);
temp=tango_read_attribute2('ANS/DG/PUB-LifeTime','double_scalar');
tau=temp.value(1);
fprintf('GAP=%f\n',gap)
%fprintf('PHASE=%f\n',Phase)
fprintf('I=%f\n',inStructElecBeam.current)
fprintf('Tau=%f\n',tau)
fprintf('P=%d\n',pres)
fprintf('nux= %f\n',inStructElecBeam.tune(1))
fprintf('nuz= %f\n',inStructElecBeam.tune(2))
fprintf('ksix= %f\n',inStructElecBeam.ksi(1))
fprintf('ksiz= %f\n',inStructElecBeam.ksi(2))
fprintf('Sauvegarde  %s\n',FileName)


% Encoder #1
%inElecBeamStruct.encoder2= readattribute([devM, '/encoder2Position']);
