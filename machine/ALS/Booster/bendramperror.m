clear

% High frequency poles for the compensation
Fc = 1000;


%\\Als-filer\physdata\matlab\srdata\powersupplies\BQFQD_ramping_20070109 
%FileName = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070109/coordinated_ramp_B_QF_QD_20070109_4kHz_55.txt';
%FileName = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070109/coordinated_ramp_B_QF_QD_20070109_4kHz_69.txt'
%FileName = uigetfile('*.mat', 'Pick a ramp file', '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070109/');


for i = 1:69
    if i == 51
    else
        if ispc
            FileName = sprintf('C:\\greg\\Matlab\\machine\\ALS\\BoosterData\\123INJ\\PowerSupplies\\BQFQD_ramping_20070109\\coordinated_ramp_B_QF_QD_20070109_4kHz_%d.txt', i);
        else
            FileName = sprintf('/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070109/coordinated_ramp_B_QF_QD_20070109_4kHz_%d.txt', i);
        end
        
        fid = fopen(FileName,'r');
        f = fscanf(fid, '%f\n', 1);
        N = fscanf(fid, '%f\n', 1);
        D = fscanf(fid, '%f %f %f', [3 inf]);
        D = D';
        fclose(fid);

    end

    QF(:,i)   =  60 * D(:,3);  %  60->New Quad, 48->Old Quad
    QD(:,i)   =  60 * D(:,1);  %  60->New Quad, 48->Old Quad
    BEND(:,i) =  80 * D(:,3);  % 125->New BEND, 80->Old BEND

end

% Cut the Data
%Data = Data(2000:end,:);

fs = 4000;
t = (0:(size(BEND,1)-1)) / fs;


% Goal 
%QFratio = QF ./ BEND; 
%QDratio = QD ./ BEND;

figure(1);
clf reset
plot(t,BEND);
xlabel('Time [Seconds]');
ylabel('Booster BEND Current [Amps]');
axis([0 1.05 -10 650]);


%% Remove timing jitter

BEND1 =  10;
BEND2 = 100;
BEND3 = 200;
BEND4 = 300;
BEND5 = 400;
BEND6 = 500;
BEND7 = 600;
j1 = min(find(BEND(2500:end,69)>BEND1)) + 2500 - 1;
j2 = min(find(BEND(2500:end,69)>BEND2)) + 2500 - 1;
j3 = min(find(BEND(2500:end,69)>BEND3)) + 2500 - 1;
j4 = min(find(BEND(2500:end,69)>BEND4)) + 2500 - 1;
j5 = min(find(BEND(2500:end,69)>BEND5)) + 2500 - 1;
j6 = min(find(BEND(2500:end,69)>BEND6)) + 2500 - 1;
j7 = min(find(BEND(2500:end,69)>BEND7)) + 2500 - 1;

%figure(3);
%clf reset
for i = 1:69
    j = min(find(BEND(2500:end,i)>BEND1)) + 2500 - 1;
    dBEND = BEND(j,i) - BEND(j1,69);
    r = (BEND(j+10,i) - BEND(j-10,i)) / .25e-3 / 20;
    Jitter1 = t(j) - t(j1) - dBEND/r;

    j = min(find(BEND(2500:end,i)>BEND2)) + 2500 - 1;
    dBEND = BEND(j,i) - BEND(j2,69);
    r = (BEND(j+10,i) - BEND(j-10,i)) / .25e-3 / 20;
    Jitter2 = t(j) - t(j2) - dBEND/r;

    j = min(find(BEND(2500:end,i)>BEND3)) + 2500 - 1;
    dBEND = BEND(j,i) - BEND(j3,69);
    r = (BEND(j+10,i) - BEND(j-10,i)) / .25e-3 / 20;
    Jitter3 = t(j) - t(j3) - dBEND/r;    

    j = min(find(BEND(2500:end,i)>BEND4)) + 2500 - 1;
    dBEND = BEND(j,i) - BEND(j4,69);
    r = (BEND(j+10,i) - BEND(j-10,i)) / .25e-3 / 20;
    Jitter4 = t(j) - t(j4) - dBEND/r;

    j = min(find(BEND(2500:end,i)>BEND5)) + 2500 - 1;
    dBEND = BEND(j,i) - BEND(j5,69);
    r = (BEND(j+10,i) - BEND(j-10,i)) / .25e-3 / 20;
    Jitter5 = t(j) - t(j5) - dBEND/r;

    j = min(find(BEND(2500:end,i)>BEND6)) + 2500 - 1;
    dBEND = BEND(j,i) - BEND(j6,69);
    r = (BEND(j+10,i) - BEND(j-10,i)) / .25e-3 / 20;
    Jitter6 = t(j) - t(j6) - dBEND/r;

    j = min(find(BEND(2500:end,i)>BEND7)) + 2500 - 1;
    dBEND = BEND(j,i) - BEND(j7,69);
    r = (BEND(j+5,i) - BEND(j-5,i)) / .25e-3 / 10;
    Jitter7 = t(j) - t(j7) - dBEND/r;

    fprintf(' dBEND = %f\n', r*.25-3*10);
    
    Jitter(:,i) = [Jitter1;Jitter2;Jitter3;Jitter4;Jitter5;Jitter6;Jitter7];
    
    %plot(t-mean(Jitter(:,i)), BEND(:,i));
    %plot(t-Jitter(1,i), BEND(:,i),'-');
    %plot(t, BEND(:,i),'-');
    %hold on;
end

%hold off
%xlabel('Time [Seconds]');
%ylabel('Booster BEND Current [Amps]');
%axis([0 1.05 -10 650]);


figure(2);
clf reset
plot(Jitter'*1000);
xlabel('Ramp Number');
ylabel('Booster BEND Timing Offset [msec]');
legend('@10 Amps', '@100 Amps', '@200 Amps', '@300 Amps', '@400 Amps', '@500 Amps', '@600 Amps');



