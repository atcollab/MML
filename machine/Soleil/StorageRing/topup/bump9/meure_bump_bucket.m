%

%[clk1,clk2]=get_start_clk;
clk1=0;
clk2=1686;
 
xx=[];

fprintf('*************************\n')
for i=0:32:416
    
    bunch=0;
    [dtour,dpaquet]=bucketnumber(bunch); 
    clk_soft=int32(clk2+dtour);
    tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk_soft);
     
    pause(1)
    tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
    pause(1)
    
    temp=tango_read_attribute2('ANS-C01/DG/BPM.2','XPosDD');
    X=temp.value;
    X=X(1:50);
    X=X-mean(X);
    Xmin=min(X);
    Xmax=max(X);
    
    xx=[xx (Xmax-Xmin)/2];
    
    figure(5)
    plot(X,'-ob')
    txt=strcat('Visé =',num2str(bunch) ,'    Xmin=',num2str(Xmin),'   Xmax=',num2str(Xmax));
    legend(txt)
    grid on
    ylim([ -1  1])
    fprintf('Visé = %d    Ecart max = %g  µm\n',bunch,(Xmax-Xmin)*1000);
    
end

figure(6)
plot(xx,'-ob')
grid on
ylim([0  1])
