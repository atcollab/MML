global THERING
ati=atindex(THERING);
bmi=ati.BEND;
kref=THERING{bmi(i)}.PolynomB(2)
shift=1.001;
for i=1:32,
    THERING{bmi(i)}.PolynomB(2)=shift*kref;
end