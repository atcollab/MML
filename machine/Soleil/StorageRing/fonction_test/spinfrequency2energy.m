function energy = spinfrequency2energy(fdepo)

a = 0.00115965;
E0 = .51099906e-3;
frev = getrf('Physics')/416;

energy = E0/a*(fdepo/frev+6);
