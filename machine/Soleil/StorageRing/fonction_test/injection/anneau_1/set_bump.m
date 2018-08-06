function set_bump(k)

% mesure fermeture bump
% depend de 8 parametres : Voltage et délais des 4 kickers
delai0 =31522324; ddelai=1;    %k=10; % stepclk (5.6 ns)
voltage0=3000;    dvoltage=10 ; %k=10; % en volt
r=1.4

if k==0  % consignes symetriques
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',delai0);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',delai0);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',delai0);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',delai0);
    tango_write_attribute2('ANS-C01/EP/AL_K.1', 'voltage',(voltage0*r));
    tango_write_attribute2('ANS-C01/EP/AL_K.2', 'voltage',(voltage0*r));
    tango_write_attribute2('ANS-C01/EP/AL_K.3', 'voltage',(voltage0*r));
    tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',(voltage0*r));
elseif (k==1)  % première optimisation 
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',delai0-3);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',delai0+0);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',delai0);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',delai0);
    tango_write_attribute2('ANS-C01/EP/AL_K.1', 'voltage',(3000*r));
    tango_write_attribute2('ANS-C01/EP/AL_K.2', 'voltage',(2960*r));
    tango_write_attribute2('ANS-C01/EP/AL_K.3', 'voltage',(2900*r));
    tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',(2880*r));
elseif (k==2)  % décalage en temps : 0  2  4  et 6 pas, logique de position
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',delai0);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',delai0+2);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',delai0+4);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',delai0+6);
    tango_write_attribute2('ANS-C01/EP/AL_K.1', 'voltage',(3000*r));
    tango_write_attribute2('ANS-C01/EP/AL_K.2', 'voltage',(3000*r));
    tango_write_attribute2('ANS-C01/EP/AL_K.3', 'voltage',(3000*r));
    tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',(3000*r));
    
    
end

3000*r

% test=0;
% n=1:
% % lecture délais kicker
%     temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay');
%     delais1=temp.value(n);
%     temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay');
%     delais2=temp.value(n);
%     temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay');
%     delais3=temp.value(n);
%     temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay');
%     delais4=temp.value(n);
%  % lecture voltage kicker  
%     temp=tango_read_attribute2('ANS-C01/EP/AL_K.1', 'voltage');
%     voltage1=temp.value(n);
%     temp=tango_read_attribute2('ANS-C01/EP/AL_K.2', 'voltage');
%     voltage2=temp.value(n);
%     temp=tango_read_attribute2('ANS-C01/EP/AL_K.3', 'voltage');
%     voltage3=temp.value(n);
%     temp=tango_read_attribute2('ANS-C01/EP/AL_K.4', 'voltage');
%     voltage4=temp.value(n);
%     vector=[voltage1 voltage2 voltage3 voltage4]
    
    

    
    

