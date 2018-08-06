getpv('SR01C:BPM2:autotrim:status','char')
Disabled

getpv('SR01C:BPM2:autotrim:control','char')
Off

getpv(['SR01C:BPM2:ADC0:gainFactor'; 'SR01C:BPM2:ADC1:gainFactor'; 'SR01C:BPM2:ADC2:gainFactor'; 'SR01C:BPM3:ADC0:gainFactor'; ])
    0.8843
    0.8850
    1.0000
    0.9509

getpv('SR01C:BPM2:attenuation')
    13

setpv('SR01C:BPM2:attenuation',31);

getpv(['SR01C:BPM2:ADC0:gainFactor'; 'SR01C:BPM2:ADC1:gainFactor'; 'SR01C:BPM2:ADC2:gainFactor'; 'SR01C:BPM3:ADC0:gainFactor'; ])
    0.9757
    0.9763
    1.0000
    0.9517
    
    
    
    