% set 66 MeV

E1=110;
kicker=6686;
sept  =193.2;
load 'corrHV.mat'
cv2=0.088;
cv3=-0.34;




E2=110;
r=E2/E1
kicker=5686 *r;
sept  =193.2*r;
HCOR=HCOR*r;
VCOR=VCOR*r;
cv2=cv2*r;
cv3=cv3*r;

writeattribute('BOO-C01/EP/AL_K.Inj/voltage',kicker);
writeattribute('BOO-C22/EP/AL_SEP_P.Inj/voltage',sept);
setam('HCOR', HCOR*1.);
setam('VCOR', VCOR*1.);


tango_write_attribute('LT1/AE/CV.2', 'current',  cv2 );
tango_write_attribute('LT1/AE/CV.3', 'current',  cv3 );