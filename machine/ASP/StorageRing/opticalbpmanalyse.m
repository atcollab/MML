
if 0
 time = 1:3600;

 pos = getpv({'SR07BM01PSD01:XPOS_MONITOR' 'SR07BM01PSD01:YPOS_MONITOR' 'SR01BPM07:SA_X_MONITOR' 'SR01BPM07:SA_Y_MONITOR'},time);
 xposopt = cell2mat(pos(1));
 yposopt = cell2mat(pos(2));
 xposlib = cell2mat(pos(3));
 yposlib = cell2mat(pos(4));
 
 now = clock;
 filesave = ['/asp/usr/commissioning/instabilities/' datestr(now,'yyyy-mm-dd') '-' num2str(now(4)) '-' num2str(now(5)) '-' num2str(fix(now(6)))];
 fprintf('Data saved to: %s\n',filesave);
 save(filesave, 'xposopt', 'yposopt', 'xposlib', 'yposlib', 'time');
end

 xpos = xposopt;
 ypos = yposopt;
 
 xpos = xpos - mean(xpos);
 ypos = ypos - mean(ypos);
 
 xpos = xpos/max(xpos);
 ypos = ypos/max(ypos);

% xpos = sin(time);
% ypos = sin(time).*sin(0.1*time);

xpos_fft = fft(xpos);
ypos_fft = fft(ypos);

figure;

subplot(2,2,1)
plot(time,xpos,'b*-')
title('X position')
xlabel('seconds')
ylabel('beam position')
hold on;

subplot(2,2,3)
plot(time(1:end/2)/length(time),xpos_fft(1:end/2).*conj(xpos_fft(1:end/2)),'b*-');
title('FFT of X position')
xlabel('Hz')
hold on;

subplot(2,2,2)
plot(time,ypos,'b*-')
title('Y position')
xlabel('seconds')
ylabel('beam position')
hold on;

subplot(2,2,4)
plot(time(1:end/2)/length(time),ypos_fft(1:end/2).*conj(ypos_fft(1:end/2)),'b*-');
title('FFT of Y position')
xlabel('Hz')
hold on;

xpos = xposlib;
ypos = yposlib;
 
 xpos = xpos - mean(xpos);
 ypos = ypos - mean(ypos);
 
 xpos = xpos/max(xpos);
 ypos = ypos/max(ypos);

% xpos = sin(time);
% ypos = sin(time).*sin(0.1*time);

xpos_fft = fft(xpos);
ypos_fft = fft(ypos);

subplot(2,2,1)
plot(time,xpos,'r*-')
title('X position')
xlabel('seconds')
ylabel('beam position')


subplot(2,2,3)
plot(time(1:end/2)/length(time),xpos_fft(1:end/2).*conj(xpos_fft(1:end/2)),'r*-');
title('FFT of X position')
xlabel('Hz')


subplot(2,2,2)
plot(time,ypos,'r*-')
title('Y position')
xlabel('seconds')
ylabel('beam position')


subplot(2,2,4)
plot(time(1:end/2)/length(time),ypos_fft(1:end/2).*conj(ypos_fft(1:end/2)),'r*-');
title('FFT of Y position')
xlabel('Hz')
legend('optical BPM','Button BPM');

