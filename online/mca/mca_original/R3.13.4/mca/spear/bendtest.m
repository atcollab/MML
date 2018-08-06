
%open corrector connection
hb=mcaopen('spr:M02Q1/ac');
%hb=mcaopen('spr:T04C5/ac');

%ramp dipole up
disp('Step    Status    Initial    Final');
for ii=1:10
    amp_init=mcaget(hb);
    pause(1.0);
    val=amp_init-10;
    stat=mcaput(hb,val);
    pause(1.0);
    amp_finis=mcaget(hb);
    pause(1.0);
    disp([num2str(stat),'       ',num2str(stat),'   ',...
          num2str(amp_init),'   ',num2str(amp_finis)]);
end

clear all;

