
clear

SensitivityRange = 1.0000e-04;
TimeStamp = clock;


for i = 1:1000
    try
        fprintf('   %2d.  Hit return when ready (ctrl-C to stop)\n', i-1);
        pause;
        try
            pBPM(:,i) = getpbpm;
        catch
            pause(.5);
            pBPM(:,i) = getpbpm;
        end
        x(:,i) = getx;
        y(:,i) = gety;
        DCCT(:,i) = getdcct;
    catch
        %break;
    end
end



save dcctscandata_3

pbpm_plotscandcct;
