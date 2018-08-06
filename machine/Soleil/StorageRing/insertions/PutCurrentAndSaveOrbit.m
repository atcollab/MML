function PutCurrentAndSaveOrbit(IPS1_ref,IPS2_ref,IPS3_ref,IPS1,IPS2,IPS3,SESSION)
%
%Example
%PutCurrentAndSaveOrbit(0,0,0,1,2,3,'SESSION_06_10_06')
%

FileNameRefStart=['HU640_PS1_' Num2Str(IPS1_ref) '_PS2_' Num2Str(IPS2_ref) '_PS3_' Num2Str(IPS3_ref) '_' Num2Str(IPS1) '_' Num2Str(IPS2) '_' Num2Str(IPS3) '_Start']
FileName=['HU640_PS1_' Num2Str(IPS1) '_PS2_' Num2Str(IPS2) '_PS3_' Num2Str(IPS3)]
FileNameRefEnd=['HU640_PS1_' Num2Str(IPS1_ref) '_PS2_' Num2Str(IPS2_ref) '_PS3_' Num2Str(IPS3_ref) '_' Num2Str(IPS1) '_' Num2Str(IPS2) '_' Num2Str(IPS3) '_End']

PathAndFileNameRefStart=['/home/matlabML/measdata/Ringdata/insertions/HU640_DESIRS/' SESSION  '/DataInMatlabFormat/' FileNameRefStart];
PathAndFileNameRefEnd=['/home/matlabML/measdata/Ringdata/insertions/HU640_DESIRS/' SESSION  '/DataInMatlabFormat/' FileNameRefEnd];
PathAndFileName=['/home/matlabML/measdata/Ringdata/insertions/HU640_DESIRS/' SESSION  '/DataInMatlabFormat/' FileName];
idDevServMain01 = 'ans-c05/ei/l-hu640_ps1';
idDevServMain02 = 'ans-c05/ei/l-hu640_ps2';
idDevServMain03 = 'ans-c05/ei/l-hu640_ps3';

%Put the Start Reference Current and Save In Matlab Format
idSetCurrentSync(idDevServMain01, IPS1_ref, 0.1);
idSetCurrentSync(idDevServMain02, IPS2_ref, 0.1);
idSetCurrentSync(idDevServMain03, IPS3_ref, 0.1);

pause(20)

Orbit_RefStart=idMeasElecBeamUnd('HU640_DESIRS', 1, PathAndFileNameRefStart, 1);




%Put the Nominal Current and Save In Matlab Format
idSetCurrentSync(idDevServMain01, IPS1, 0.1);
idSetCurrentSync(idDevServMain02, IPS2, 0.1);
idSetCurrentSync(idDevServMain03, IPS3, 0.1);

pause(20)

Orbit=idMeasElecBeamUnd('HU640_DESIRS', 1, PathAndFileName, 1);


%Put the End Reference Current and Save In Matlab Format
idSetCurrentSync(idDevServMain01, IPS1_ref, 0.1);
idSetCurrentSync(idDevServMain02, IPS2_ref, 0.1);
idSetCurrentSync(idDevServMain03, IPS3_ref, 0.1);

pause(20)

Orbit_RefEnd=idMeasElecBeamUnd('HU640_DESIRS', 1, PathAndFileNameRefEnd, 1);

%Evaluation of the orbit Distortion
dOrbit_X=Orbit.X-0.5*(Orbit_RefStart.X+Orbit_RefEnd.X);
dOrbit_Z=Orbit.Z-0.5*(Orbit_RefStart.Z+Orbit_RefEnd.Z);

% Plot Orbit Distortion

BPMx.Position = getspos('BPMx');
xdata = BPMx.Position;


figure(10)
plot(xdata,(dOrbit_X),'r.-')
title('Déplacement relatif d''orbite horizontal')
xlabel('position des BPM (m)')

figure(11)  
plot(xdata,(dOrbit_Z),'b.-')
title('Déplacement relatif d''orbite verticale')
xlabel('position des BPM (m)')  

% Plot Orbit before and after nominal current change

figure(12)
plot(xdata,(Orbit_RefStart.X),'b-',xdata,(Orbit_RefEnd.X),'r-')
title('Déplacement relatif d''orbite horizontal')
legend('Before nominal current change','After nominal current change')
xlabel('position des BPM (m)')


figure(13)
plot(xdata,(Orbit_RefStart.Z),'b-',xdata,(Orbit_RefEnd.Z),'r-')
title('Déplacement relatif d''orbite verticale')
legend('Before nominal current change','After nominal current change')
xlabel('position des BPM (m)')
