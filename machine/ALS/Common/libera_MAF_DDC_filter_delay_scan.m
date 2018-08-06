
clc;
clear variables;
close all;

rmsx = [];
rmsy = [];
delay=0;
K=10^-3;
DELAY_ARRAY = [];
N_tbt=10000;
ip='10.0.1.103';
% text5=['ALBA SR 1_82 MAF DDC 33dc delay filter scan'];
text5=['ALS SR 77 1.82 MAF DDC delay filter scan'];
machine_design_name = 'als_sr_77_MAF';
machine_DDC_decimation = 77;
fill_pattern_percent = 30;
start_delay=0;
step = 2;
stop_delay = machine_DDC_decimation-1;
length= floor(fill_pattern_percent * machine_DDC_decimation/100); %23;

% setting length
command_set_length_Libera = ['c:\Rexec\rexec -n -l test -p libera1 ',ip,' "echo "MAFLength ',num2str(length),'" |/opt/bin/libera -s"'];
dos(command_set_length_Libera);  

% delay_range = [(0:10) (80:106)];
% delay_range = [0:76];
% for delay = delay_range
for delay=start_delay:step:stop_delay

    delay
    % setting delay
    command_set_delay_Libera = ['c:\Rexec\rexec -n -l test -p libera1 ',ip,' "echo "MAFDelay ',num2str(delay),'" |/opt/bin/libera -s"'];
    dos(command_set_delay_Libera);  

    % acquisition
    pause(2);
    B=0;
    N=2000;    
%     text=['c:\Rexec\rexec -n -l test -p libera1 ',ip,' "/opt/bin/libera -0 -b ',num2str(N_tbt),' >/devel/tmp/testni/tbt_data " '];
    file_name=['tbt_data'];
 
    command_get_data_Libera=['c:\Rexec\rexec -n -l test -p libera1 ',ip,' "/opt/bin/libera -0 -b ',num2str(N),' >/mnt/tmp/testni/tbt_data "'];
    dos(command_get_data_Libera);
    cd c:\testni\tmp\testni;
    fd=fopen(file_name);
    B= fread(fd,[8,N],'int32');
    fclose(fd); 
    
    rmsX_coord = K*std(B(5,:));
    rmsY_coord = K*std(B(6,:));

    rmsx=[rmsx,rmsX_coord];
    rmsy=[rmsy,rmsY_coord];
    DELAY_ARRAY=[DELAY_ARRAY,delay];
end




figure(1)
plot(DELAY_ARRAY,rmsx)
hold on;
plot(DELAY_ARRAY,rmsy,'r')
xlabel(['MAF DDC filter delay setting @ ' num2str(fill_pattern_percent) '% input signal duty cycle']);
ylabel('X & Y rms [um] @ TBT data');
[min_value min_index] = min(rmsx);
title({text5; ['  MIN rmsX: ' num2str(min(rmsx)) ' rmsY: ' num2str(min(rmsy)) '   AT ' num2str(DELAY_ARRAY(min_index)) ]});
set(gcf,'Color','w')
grid on;
saveas(gcf,[machine_design_name '__' num2str(fill_pattern_percent) '_percent_fill.fig']);



