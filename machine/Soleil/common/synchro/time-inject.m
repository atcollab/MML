
Ibc=0;
Id0=546.76;

for i = 10 : 1 : 25;
   t=i/1000;
   fq(i) = Id0*0.5*(1-cos(w*(t)));
end

fq
