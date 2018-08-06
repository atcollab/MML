%%
r=measbpmresp('Model');
S=inv(r);
%%
setpv('HCM',0)
setpv('VCM',0)
%%
seterror(15E-6, 15E-6)
%%
x=getx;
y=gety;
orbit=[x',y']';
disp 'Orbit before correction'
fprintf (1,'Horizontal= %f um\n', std(getx)*1E6)
fprintf (1,'Vertical= %f um\n\n', std(gety)*1E6)
CorrectorShift=S*orbit;
cv=-CorrectorShift(89:176)+getpv('VCM');
ch=-CorrectorShift(1:88)+getpv('HCM');
setpv('VCM', cv);
setpv('HCM', ch);
disp 'Orbit after correction'
fprintf (1,'Horizontal= %f um\n', std(getx)*1E6)
fprintf (1,'Vertical= %f um\n\n', std(gety)*1E6)
disp 'rms values of the correctors'
fprintf (1,'Horizontal= %f urad\n', std(getpv('HCM'))*1E6)
fprintf (1,'Vertical= %f urad\n\n', std(getpv('VCM'))*1E6)
%%
rx=r(1:88,1:88);
ry=r(89:176, 89:176);
Sx=inv(rx);
Sy=inv(ry);
%%
disp 'Orbit before correction'
fprintf (1,'Horizontal= %f um\n', std(getx)*1E6)
fprintf (1,'Vertical= %f um\n\n', std(gety)*1E6)
for i=1:5,
    x=getx;
    y=gety;
    CorrectorShiftV=Sy*y;
    CorrectorShiftH=Sy*x;
    cv=-CorrectorShiftV(89:176)+getpv('VCM');
    ch=-CorrectorShiftH(1:88)+getpv('HCM');
    setpv('VCM', cv);
    setpv('HCM', ch);
    fprintf(1, 'Orbit after step %ld\n',i)
    fprintf (1,'Horizontal= %f um\n', std(getx)*1E6)
    fprintf (1,'Vertical= %f um\n\n', std(gety)*1E6)
    disp 'rms values of the correctors'
    fprintf (1,'Horizontal= %f urad\n', std(getpv('HCM'))*1E6)
    fprintf (1,'Vertical= %f urad\n\n', std(getpv('VCM'))*1E6)
end