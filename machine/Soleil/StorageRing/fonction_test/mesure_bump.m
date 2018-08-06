% mesure fermeture bump
% depend de 8 parametres : Voltage et délais des 4 kickers
delai0 =31522324; ddelai=1;    k=10; % stepclk (5.6 ns)
voltage0=4000;    dvoltage=10 ; k=10; % en volt
r=1.05;
r=1.05;
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',delai0-4+1);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',delai0+0);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',delai0+1-1);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',delai0-1);
    tango_write_attribute2('ANS-C01/EP/AL_K.1', 'voltage',(4130*r));
    tango_write_attribute2('ANS-C01/EP/AL_K.2', 'voltage',(3980*r));
    tango_write_attribute2('ANS-C01/EP/AL_K.3', 'voltage',(4080*r));
    tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',(4000*r));
    
    
test=0;
n=1
% lecture délais kicker
    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay');
    delais1=temp.value(n);
    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay');
    delais2=temp.value(n);
    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay');
    delais3=temp.value(n);
    temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay');
    delais4=temp.value(n);
 % lecture voltage kicker  
    temp=tango_read_attribute2('ANS-C01/EP/AL_K.1', 'voltage');
    voltage1=temp.value(n);
    temp=tango_read_attribute2('ANS-C01/EP/AL_K.2', 'voltage');
    voltage2=temp.value(n);
    temp=tango_read_attribute2('ANS-C01/EP/AL_K.3', 'voltage');
    voltage3=temp.value(n);
    temp=tango_read_attribute2('ANS-C01/EP/AL_K.4', 'voltage');
    voltage4=temp.value(n);
    vector=[voltage1 voltage2 voltage3 voltage4]
    
    
%   Test
if (test==1)
    
    % set delai0 and voltage0    
    
%     for i=1:20
%         tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');pause(2);
%         temp=tango_read_attribute2('ANS-C01/DG/BPM.2', 'XPosDD');
%         x=temp.value;x2=x.*x;amp=std(x2,1);amp=sqrt(amp);
%         fprintf('amplitude =  %g\n',amp)
%     end
%     % kicker 1
%     fprintf('Scan kicker4 voltage\n')
%     k1_timing=[]; xk1_timing=[];
%     for i=-k:k
%         delai=delai0-1  +i*ddelai;
%         tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',delai); pause(2);
%         tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');pause(2)
%         temp=tango_read_attribute2('ANS-C01/DG/BPM.2', 'XPosDD');
%         x=temp.value;x2=x.*x;amp=std(x2,1);amp=sqrt(amp);
%         k1_timing=[k1_timing delai];
%         xk1_timing=[xk1_timing,amp];
%         timing=delai-(delai0-1);
%         fprintf('timing amplitude = %g  %g\n',timing,amp)
%     end
    
%     fprintf('Scan kicker1 voltage\n')
%     k1_voltage=[]; xk1_voltage=[];
%     for i=-k:k
%         voltage=4000+i*dvoltage;
%         tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',voltage);pause(2)
%         tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');pause(2)
%         temp=tango_read_attribute2('ANS-C01/DG/BPM.2', 'XPosDD');
%         x=temp.value;x2=x.*x;amp=std(x2,1);amp=sqrt(amp);
%         k1_voltage=[k1_voltage voltage];
%         xk1_voltage=[xk1_voltage,amp];
%         fprintf('voltage amplitude = %g  %g\n',voltage,amp)
%     end
%  
    
    
end



    
    
    
    

