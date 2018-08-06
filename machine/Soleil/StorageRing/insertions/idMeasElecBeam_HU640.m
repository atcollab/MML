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
	inStructElecBeam.ksi = measchro('Physics');
end

inStructElecBeam.date = datestr(now); % convert date to string

outStructElecBeam = inStructElecBeam;

% Save the structure into a file, if necessary
%if saveRes ~= 0
if strcmp(fileNameCore, '') == 0
    %idSaveStruct(structNameToSave, fileNameCore, idName)
    %idSaveStruct(structNameToSave, 'HU80_TEMPO', 'HU80')
    
	FileName = appendtimestamp(fileNameCore);
	DirectoryName = getfamilydata('Directory','HU640/SESSION_01_10_06');
	DirStart = pwd;
	[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
	save(FileName,'-struct', 'outStructElecBeam');
    %save(FileName, inStructElecBeam);
	cd(DirStart);
end

%temp=tango_read_attribute2('ANS-C08/EI/M-HU80.2','gap');
%gap=temp.value(1)/1.e4;
IPS1=0;IPS2=0;IPS3=0;

%temp=tango_read_attribute2('TDL-I08-M/VI/JBA.1','pressure');
pres=temp.value(1);
temp=tango_read_attribute2('ANS/DG/PUB-LifeTime','double_scalar');
tau=temp.value(1);
fprintf('Courant PS1=%f\n','A %s\n')
fprintf('Courant PS2=%f\n','A %s\n')
fprintf('Courant PS3=%f\n','A %s\n')
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
