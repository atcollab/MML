ch1 = mcaopen('SR00TRG01:FILL_CMD');
ch2 = mcaopen('SR00EVR01:INJ_START_BUCKET_SP');
ch3 = mcaopen('SR07BM01FPM01:FILL_PATTERN_WAVEFORM_MONITOR');
fpm_start = mcaget(ch3)

bucket_number = 1;
mcaput(ch2,bucket_number);
for i=1:1
    mcaput(ch1,3);
    pause(2);
end
pause(1)
fpm_stop = mcaget(ch3);

fpm_dif = fpm_stop - fpm_start;
figure(88)
bar(fpm_dif)

mcaclose(ch1)
mcaclose(ch2)
mcaclose(ch3)