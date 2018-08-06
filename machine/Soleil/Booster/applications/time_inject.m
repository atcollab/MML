
% calcul du temp d'injection 


Id_inj=21.3;

Idc=0.;
Id0=546.76;
w=2*3.14159*(50./17.);

t_inj=real(acos( 1-2*(Id_inj-Idc)/Id0 ) / w);


sprintf(' Dt  / déclanchement alim dipole injection : %g  ms avant canon/kicker', t_inj)
sprintf(' Delai carte CPT alim dipole injection     : %g ', (0.33 + 7.83e-05 - t_inj))
 


Gr = 0.0435 ;           % gradient remanent  T/m 
a  = 0.0517 ;           % G/I   T/m/A
Br = 0.0006 ;           % Champ remanent T
b  = 0.00135416 ;       % B/I  T/A


Iqf0 = 198.38 ;
Iqd0 = 157.28 ;
Iqfc = 7.16 ;             % Offset QPF
Iqdc = 5.55 ; 

Iqpf_inj=Iqfc + 0.5*Iqf0*(1-cos(w*t_inj));
Iqpd_inj=Iqdc + 0.5*Iqd0*(1-cos(w*t_inj));
sprintf(' injection  Iqf= %g   et Iqd= %g  A',Iqpf_inj , Iqpd_inj)



B_inj  = Br + b*(Idc + 0.5*Id0*(1-cos(w*t_inj))); 
sprintf(' B dipole injection : %g   T', B_inj)
t=t_inj+1e-06 ;
B      = Br + b*(Idc + 0.5*Id0*(1-cos(w*t)));
sprintf(' Variation relative avec dt= 1*µs  : %g ', (B_inj-B)/B_inj )