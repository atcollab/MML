function [delai, eff]=plateau_kicker

% Mesure plateau kicker inj booster


kmax=500/5.8;
temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigStepDelay');delais0=temp.value(1);

eff=[0];
delai=[0];
for k=0:87
   ddelai=-k;
   tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigStepDelay',(delais0+ddelai)); pause(0);
   tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
   pause(2)
   [q1,q2,n]=getcharge(0,0,1);
   r=q2/q1; eff=[eff r];
   dt=ddelai*5.8; delai=[delai dt];
   fprintf('ddelai eff = %g  %g\n',dt,r)
end

tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigStepDelay',(delais0))