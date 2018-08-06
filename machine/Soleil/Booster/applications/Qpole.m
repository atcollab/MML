% Courant Qpole


Brho = 0.3686;  % 110 MeV
Gbrf = 1.157;
Gbrd = 1.131;

Iqf = (Gbrf*Brho-0.0435)/0.0517;
Iqd = (Gbrd*Brho-0.0435)/0.0517;

sprintf(' Iqf : %g   Iqd : %g', Iqf , Iqd)