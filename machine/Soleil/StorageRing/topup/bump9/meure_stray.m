%

load actif_fullstrayfield.mat;
%stray5  % effet stray actif initiale, sans blindage 


% filtre
a = 1;
n = 100; % nombre de point pour moyenne
b = ones(n,1)/n;

bunch=0;

fprintf('************************* \n')
for i=1:1
    
   
    %tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
     pause(1)
    
    temp=tango_read_attribute2('ANS-C01/DG/BPM.2','XPosDD');
    X=temp.value;
    temp=tango_read_attribute2('ANS-C01/DG/BPM.2','ZPosDD');
    Z=temp.value;
    Z=Z-mean(Z);
    
    t=double(0:3300/1.2);
    sept=0.1*sin(t*1.2/3300*pi);
    plot((t+1400)/1.2,sept,'-k'); hold on
    
    
   % plot( filter(b,a,stray0),'-k') ; hold on
   % plot(reverse(filter(b,a,reverse(stray3))),'-k') ;  hold on
    plot((filter(b,a,(stray5))),'-b') ;  
    plot((filter(b,a,(stray2))),'-r'); hold off
  
    
    legend('septum','stray5','stray2')
    grid on
    
    
end