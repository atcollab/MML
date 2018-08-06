% chro avec tous les sextupoles

cx0=0.6  ;  cz0=0.6;

% + 1% sur foc
cx1=1.7   ;  cz1=0.32;

% + 1% sur defoc
cx2=0.21   ;  cz2=1.14;

M=1*[(cx1-cx0) (cx2-cx0)  ; (cz1-cz0) (cz2-cz0)];
inv(M)

