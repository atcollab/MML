function monitor_SR06U_VCM2

fprintf('\nMonitoring SR06U___VCM2 - if it goes off will turn on and reset last setpoint...\n');

while 1
    sp = getpv('SR06U___VCM2J__AC00');

    if getpv('SR06U___VCM2___BC22')==0
        setpv('SR06U___VCM2___BC22',1);
        a = clock;datestr = date;
        fprintf('\n%s %d:%d:%.0f\n', datestr, a(4), a(5), a(6));
        fprintf('SR06U___VCM2 went off! Turned it back on.\n');
        pause(1)
        setpv('SR06U___VCM2___AC10',sp);
        fprintf('\nReset SR06U___VCM2 to setpoint before it was off.\n');
        fprintf('\nMonitoring SR06U___VCM2 and writing proper value to DAC...\n');
        fprintf('\n');
        soundquestion;soundquestion;
    end
    
    pause(.1)
end