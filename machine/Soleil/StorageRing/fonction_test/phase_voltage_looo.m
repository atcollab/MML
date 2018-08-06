% Controle Phase et Voltage RF
% Test

%av=2.83;
av=1.1667;
bv=650;
ap=0;
bp=0;



for i=1:10000
    temp=tango_read_attribute2('ANS-C03/DG/DCCT','current');
    current=temp.value(1);
    voltage=av*current + bv;
    phase=ap*current + bp;
    tango_write_attribute2('ANS-C03/RF/LLE.1','voltageRF',voltage);
    %tango_write_attribute2('ANS-C03/RF/LLE.1','phaseCavity',phase);
    tango_write_attribute2('ANS-C03/RF/LLE.2','voltageRF',voltage);
    %tango_write_attribute2('ANS-C03/RF/LLE.2','phaseCavity',phase);
    temp=tango_read_attribute2('ANS-C03/RF/LLE.1','voltageRF');
    voltage1=temp.value(1);
    temp=tango_read_attribute2('ANS-C03/RF/LLE.2','voltageRF');
    voltage2=temp.value(1);
    fprintf('Courant=%g  V1=%g,   V2=%g,\n', current,voltage1,voltage2)
    pause(5)
end

% temp=tango_read_attribute2('ANS-C03/RF/LLE.1','phaseCavity');
% phase1=temp.value(1);
% temp=tango_read_attribute2('ANS-C03/RF/LLE.2','phaseCavity');
% phase2=temp.value(1);