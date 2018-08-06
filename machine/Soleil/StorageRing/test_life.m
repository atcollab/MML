
for k =1:1000, 
    LifeTime = measlifetime(60,'Display'); 
    if getdcct < 0.1
        disp('Inject first');
        tango_write_attribute2('ANS/DG/PUB-LifeTime','string_scalar',[num2str(0,4) ' h']);
    else
        tango_write_attribute2('ANS/DG/PUB-LifeTime','string_scalar',[num2str(LifeTime,4) ' h']);
        tango_write_attribute2('ANS/DG/PUB-LifeTime','double_scalar',LifeTime);
    end
   
    
end
 tango_write_attribute2('ANS/DG/PUB-LifeTime','string_scalar',[num2str(-1,4) ' h']);

 