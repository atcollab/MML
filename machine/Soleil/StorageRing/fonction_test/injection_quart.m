function injection_quart(m)
n=1    ;
load('injection_quart', 'quart')

%m=3;   % 1 2 3 ou 4

quadrant=quart(m,:);


clk=quadrant(1);
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigStepDelay',clk);

clk=quadrant(2);
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigStepDelay',clk);

clk=quadrant(3);
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigStepDelay',clk);

clk=quadrant(4);
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigStepDelay',clk);

clk=quadrant(5);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',clk);

clk=quadrant(6);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',clk);

clk=quadrant(7);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',clk);

clk=quadrant(8);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',clk);

clk=quadrant(9);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigStepDelay',clk);
clk=quadrant(10);

tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigStepDelay',clk);

clk=quadrant(11);
tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigStepDelay',clk);
%
temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigTimeDelay');
delayk1=temp.value(n)-179000;
temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigTimeDelay');
delayk2=temp.value(n)-179000;
temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigTimeDelay');
delayk3=temp.value(n)-179000;
temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigTimeDelay');
delayk4=temp.value(n)-179000;

fprintf('injection sur quart %d \n',m)
fprintf('délais Kickers = %g %g %g %g\n',delayk1,delayk2,delayk3,delayk4)
fprintf('***** OK *********\n')

