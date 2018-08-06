
function [table]=X_energy_beat1
% get spurious x fluctuation at BPM.NOD
% give rms value over all the buffer

table=[];
for i=1:5000

    temp=tango_read_attribute2('ANS-C13/DG/BPM.NOD','XPosDD'); X=temp.value;
    temp=tango_read_attribute2('ANS-C03/DG/DCCT','current');anscur=temp.value;
   
    Xrms=std(X(1:6000));
    fprintf('I = %g  X rms = %g  µm  \n',anscur,Xrms*1000)
    
    table=[table ; anscur  Xrms*1000];
    plot(table(:,1),table(:,2));xlabel('Cur');ylabel('Xrms µm')
    pause(1)
end

%plot(table(:,1),table(:,2))