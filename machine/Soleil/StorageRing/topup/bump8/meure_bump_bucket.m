%

%[clk1,clk2]=get_start_clk;

% clk2=2258;
 bunch=0
% [dtour,dpaquet]=bucketnumber(bunch); 
% clk_soft=int32(clk2+dtour);
%tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk_soft);
 
fprintf('*************************')
for i=1:200
    
   
    tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
    pause(2)
    
    temp=tango_read_attribute2('ANS-C01/DG/BPM.2','XPosDD');
    X=temp.value;
    X=X(1:50);
    X=X-mean(X);
    Xmin=min(X);
    Xmax=max(X);

    plot(X,'-ob')
    txt=strcat('Xmin=',num2str(Xmin),'   Xmax=',num2str(Xmax));
    legend(txt)
    grid on
    ylim([ -1  1])
    fprintf('Visé = %d    Ecart max = %g  µm\n',bunch,(Xmax-Xmin)*1000);
    
end