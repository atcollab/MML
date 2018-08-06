function a = bpm_test_ptgains

Prefix = 'SR07C:BPM1';
a. Prefix = Prefix;


a.rfMagPV = [
    [Prefix,':ADC0:rfMag  ']
    [Prefix,':ADC1:rfMag  ']
    [Prefix,':ADC2:rfMag  ']
    [Prefix,':ADC3:rfMag  ']
];


a.ptHiMagPV = [
    [Prefix,':ADC0:ptHiMag']
    [Prefix,':ADC1:ptHiMag']
    [Prefix,':ADC2:ptHiMag']
    [Prefix,':ADC3:ptHiMag']
];

a.ptLoMagPV = [
    [Prefix,':ADC0:ptLoMag']
    [Prefix,':ADC1:ptLoMag']
    [Prefix,':ADC2:ptLoMag']
    [Prefix,':ADC3:ptLoMag']
];

a.GainFactorPV = [
    [Prefix,':ADC0:gainFactor']
    [Prefix,':ADC1:gainFactor']
    [Prefix,':ADC2:gainFactor']
    [Prefix,':ADC3:gainFactor']
];


a.rfMag = getpv(a.rfMagPV);
a.ptLoMag = getpv(a.ptLoMagPV);
a.ptHiMag = getpv(a.ptHiMagPV);
a.GainFactor = getpv(a.GainFactorPV);



