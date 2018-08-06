%

name='test10'

del1=0;
del2=0;
del3=0;
del4=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp=tango_read_attribute2('ANS-C01/EP/AL_K.1','voltage');
K1=temp.value(2);
temp=tango_read_attribute2('ANS-C01/EP/AL_K.2','voltage');
K2=temp.value(2);
temp=tango_read_attribute2('ANS-C01/EP/AL_K.3','voltage');
K3=temp.value(2);
temp=tango_read_attribute2('ANS-C01/EP/AL_K.4','voltage');
K4=temp.value(2);
bpm.Del_K1=del1;
bpm.Del_K2=del2;
bpm.Del_K3=del3;
bpm.Del_K4=del4;
bpm.Volt_K1=K1;
bpm.Volt_K2=K2;
bpm.Volt_K3=K3;
bpm.Volt_K4=K4;
bpm_name='ANS-C01/DG/BPM.2'; 
bpm.name=bpm_name;


clk1=0;
clk2=1686;
TX=[];TZ=[];
bucket=[];
xx=[];
j=0;
fprintf('*************************\n')
for i=1:10         %0:32:416
    
     bunch=i;
     bucket=[bucket ; bunch]
%     [dtour,dpaquet]=bucketnumber(bunch); 
%     clk_soft=int32(clk2+dtour);
%     tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk_soft);
%      
%     pause(1)
%     tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
%     pause(1)
    
    temp=tango_read_attribute2('ANS-C01/DG/BPM.2','XPosDD');
    X=temp.value;
    X=X(1:50);
    TX=[TX ;X];
    
    X=X-mean(X);
    Xmin=min(X);
    Xmax=max(X);
    xx=[xx (Xmax-Xmin)/2];
    
    temp=tango_read_attribute2('ANS-C01/DG/BPM.2','ZPosDD');
    Z=temp.value;
    Z=Z(1:50);
    TZ=[TZ ;Z];
 
    figure(5)
    plot(X,'-ob')
    txt=strcat('Visé =',num2str(bunch) ,'    Xmin=',num2str(Xmin),'   Xmax=',num2str(Xmax));
    legend(txt)
    grid on
    ylim([ -1  1])
    fprintf('Visé = %d    Ecart max = %g  µm\n',bunch,(Xmax-Xmin)*1000);
    
    

    
end

bpm.bunch=bucket;
bpm.XposDD=TX;
bpm.ZposDD=TZ;
file=strcat(name,'.mat');
save(file, 'bpm');



figure(6)
plot(xx,'-ob')
grid on
ylim([0  1])




    
