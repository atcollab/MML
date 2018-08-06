%  plot energie


w=2*3.14159*50/17;
t=(1:170)/1000;
Ener=2750/2*(1-cos(w*t));
plot (t,Ener)