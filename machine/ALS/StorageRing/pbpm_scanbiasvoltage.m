
clear
x = getx;
y = gety;


LocalFlag = 0;

Range = 100e-6;  %input('Input range? ');  %100e-06;
RangeString = '100 uA';

TimeStamp = clock;
DCCT = getdcct;

BiasVoltage = [0 -2 -4 -8 -12 -16 -20 -25 -30 -35 -40 -50 -60 -70 -80 -100 -125 -150 -175 -200]


for i = 1:length(BiasVoltage)

    fprintf('\n\n   %2d.  Set the bias Voltage to %.1f volts then hit return\n\n', i, BiasVoltage(i));
    pause;
    pause(4);

    try
        % Get data
        if LocalFlag
            [d1,d2,d3,d4] = siglabgetpbpm(1,1);
            pBPM(:,i) = [mean(d1); mean(d2); mean(d3); mean(d4);];
        else
            pBPM(:,i) = getpbpm;
        end
    catch
        % Try 1 more time
        pause(.5);
        if LocalFlag
            [d1,d2,d3,d4] = siglabgetpbpm(1,1);
            pBPM(:,i) = [mean(d1); mean(d2); mean(d3); mean(d4);];
        else
            pBPM(:,i) = getpbpm;
        end
    end
end


save biasvoltagescan_data1


pbpm_plotbiasscan;


%plot(BiasVoltage, pBPM, '.-');
%grid on;
%xlabel('Bias Voltage');
%ylabel('Blade Voltage');
%title('Bias Voltage Scan');
