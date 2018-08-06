% mettre synchro OFF
n=1    ;
m=1 ;

clear clk
% les 4 tours (2 coups par tours)
dt=[13 13 13 -39];
% le meme tour 8 fois - reiterer 'run' pour changer de quart
% dt=[13 0 0 0];



    temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigStepDelay');
    clk(m,1)=temp.value(n);

    temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigStepDelay');
    clk(m,2)=temp.value(n);

    temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigStepDelay');
    clk(m,3)=temp.value(n);

    temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigStepDelay');
    clk(m,4)=temp.value(n);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay');
    clk(m,5)=temp.value(n);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay');
    clk(m,6)=temp.value(n);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay');
    clk(m,7)=temp.value(n);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay');
    clk(m,8)=temp.value(n);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigStepDelay');
    clk(m,9)=temp.value(n);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigStepDelay');
    clk(m,10)=temp.value(n);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigStepDelay');
    clk(m,11)=temp.value(n);
    %
    %



% temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C13/SY/LOCAL.DG.1', 'dcctStepDelay',clk);
%

% temp=tango_read_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
%
% temp=tango_read_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
%





% temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'spareStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('ANS/SY/LOCAL.SDC.1', 'spareStepDelay',clk);
%
% temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('LT2/SY/LOCAL.DG.1', 'mrsvStepDelay',clk);
%
% temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctStepDelay');
% clk=temp.value(n)+tout
%
%
% temp=tango_read_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute('LT2/SY/LOCAL.DG.2', 'bpm.trigStepDelay',clk);






