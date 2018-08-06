% set synchro

%cas='classique'
cas='spécial';


% délai messages
precharge=0;
inj      =32000;
soft     =32000+0.522;

% délai LT1 
delay(1)=0.1;
delay(2)=78.1;
delay(3)=79.5;
delay(4)=75.5;
delay(5)=79.5;
delay(6)=78.1;
% délai BOO
delay(7)=51.0;
delay(8)=79.56;  % réglé sur 79.56 (longeur de cable)
delay(9)=75.0;
delay(10)=75.0;    

delay(11)=0;
% délai alim boo
dt=1000;
alim(1)=dt;
alim(2)=dt-210;
alim(3)=dt-200;
alim(4)=dt;
alim(5)=dt;
alim(6)=dt;

% pause
tout = 0.5;

if strcmp( cas, 'classique')
    
    action = 'Synchro classique chargée';
    
elseif strcmp( cas, 'spécial')
   
    delay=delay+inj-dt;
    delay(11)=0;  % spécial DCCT sur alim et soft
    soft=dt+0.522;
    inj=dt;         % 980 le 23 avril
    action = 'Synchro spécial chargée';
    
else
    
   disp('Rien chargé')
   return
   
end

% délai messages
tango_write_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay',precharge); pause(tout);
tango_write_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay',inj); pause(tout);
tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay',soft); pause(tout);

% délai LT1 
tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmTimeDelay',delay(1)); pause(tout);
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay',delay(2)); pause(tout);
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay',delay(3)); pause(tout);
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay',delay(4)); pause(tout);
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay',delay(5)); pause(tout);
tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay',delay(6)); pause(tout);

% délai BOO
tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigTimeDelay',delay(7)); pause(tout);
tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigTimeDelay',delay(8));    pause(tout);
tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigTimeDelay',delay(9)); pause(tout);
tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigTimeDelay',delay(9)); pause(tout);
%tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btc.trigTimeDelay',delay(9)); pause(tout);
%tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btb.trigTimeDelay',delay(9)); pause(tout);
%tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'NODTimeDelay',delay(10)); pause(tout);
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay',delay(11)); pause(tout);

% délai alim boo
tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay',alim(1));pause(tout);
tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay',alim(2));pause(tout);
tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay',alim(3));pause(tout);
tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay',alim(4));pause(tout);
tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay',alim(5));pause(tout);
%tango_write_attribute2('BOO/SY/LOCAL.RF.1'  , 'rfTimeDelay',alim(6));pause(tout);

disp(action)