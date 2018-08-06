% mettre synchro OFF
n=1    ;
% les 4 tours (2 coups par tours)
dt=[13 13 13 -39];

%dt=[13 13 -26];
%dt=[13  -13];




% le meme tour 8 fois - reiterer 'run' pour changer de quart
% dt=[13 0 0 0];

% writeattribute('BOO/AE/dipole/current',545);
% writeattribute('BOO/AE/QF/current',201.7677);
% writeattribute('BOO/AE/QD/current',162.611);
% pause(5)
 
for kt=1:1
  
for i=1:4

    for j=1:10
        tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
        pause(0.6)
    end

    tout=184/2*dt(i);

    temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigStepDelay');
    clk=temp.value(n)+tout;
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigStepDelay',clk);

    temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigStepDelay');
    clk=temp.value(n)+tout;
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigStepDelay',clk);

    temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigStepDelay');
    clk=temp.value(n)+tout;
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigStepDelay',clk);

    temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigStepDelay');
    clk=temp.value(n)+tout;
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigStepDelay',clk);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay');
    clk=temp.value(n)+tout;
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',clk);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay');
    clk=temp.value(n)+tout;
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',clk);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay');
    clk=temp.value(n)+tout;
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',clk);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay');
    clk=temp.value(n)+tout;
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',clk);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigStepDelay');
    clk=temp.value(n)+tout;
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigStepDelay',clk);

    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigStepDelay');
    clk=temp.value(n)+tout;
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigStepDelay',clk);


%     temp=tango_read_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigStepDelay');
%     clk=temp.value(n)+tout;
%     tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigStepDelay',clk);
    %
    %

end

end

fprintf('*********************************\n')

%  pause(2)
%  writeattribute('BOO/AE/QD/current',062.611);
%  writeattribute('BOO/AE/QF/current',101.7677);
%  writeattribute('BOO/AE/dipole/current',345);

% temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctStepDelay',clk);
%

% temp=tango_read_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
%
% temp=tango_read_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
% temp=tango_read_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigStepDelay',clk);
%
%





% temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'spareStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareStepDelay',clk);
%
% temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvStepDelay',clk);
%
% temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctStepDelay');
% clk=temp.value(n)+tout
%
%
% temp=tango_read_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigStepDelay');
% clk=temp.value(n)+tout
% tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigStepDelay',clk);






