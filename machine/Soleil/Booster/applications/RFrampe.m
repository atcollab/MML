% affichage rampe RF

n=100;
V0=700;     % kV
V0=V0/100 ; % normalisé en V
f=50/17;
w=2*3.14159*f;


% rampe plus courte centrée
r=0.2;
t1=1/f*r/2;
t2=1/f*(1-r/2);
w=w/(1-r)

clear V

for i=1:n
    
    t=(i-1)/f/(n-1);
    if (t<t1)
       V(i) = 0;
    elseif (t>=t1) && (t<t2)
       V(i) = V0*0.5*(1.-cos(w*(t-t1)));
    else
        V(i) = 0;
    end
    
end 

plot(V)
devName='BOO/RF/SAO.1';
prop.name = 'Channel0WaveForm';
for k=1:100
            prop.value{k} = num2str(V(k));
end
tango_command_inout2(devName, 'Stop');
tango_put_properties2(devName,prop)
tango_command_inout2(devName, 'Init');
tango_command_inout2(devName, 'Start');

