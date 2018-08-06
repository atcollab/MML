function monitor_SR06U_VCM2_and_SR11U_VCM2_and_SR05C_VCM2

fprintf('\nMonitoring SR06U___VCM2 and SR11U___VCM2 and SR05C___VCM2 - if one goes off this routine will turn it on and reset last setpoint...\n');

while 1
    vcm62u_sp = getpv('SR06U___VCM2J__AC00');
    vcm112u_sp = getpv('SR11U___VCM2J__AC00');
    vcm52_sp = getpv('SR05C___VCM2___AC01');
    vcm52T_sp = getpv('SR05C___VCM2T__AC10');

    if getpv('SR06U___VCM2___BC22')==0
        setpv('SR06U___VCM2___BC22',1);
        a = clock;datestr = date;
        fprintf('\n%s %d:%d:%.0f\n', datestr, a(4), a(5), a(6));
        fprintf('SR06U___VCM2 went off! Turned it back on.\n');
        pause(0.5)
        setpv('SR06U___VCM2___AC10',vcm62u_sp);
        fprintf('\nReset SR06U___VCM2 to setpoint before it was off.\n');
        fprintf('Monitoring SR06U___VCM2 and writing proper value to DAC...\n');
        fprintf('\n');
        soundquestion;soundquestion;
    end
    
    if getpv('SR11U___VCM2___BC22')==0
        setpv('SR11U___VCM2___BC22',1);
        a = clock;datestr = date;
        fprintf('\n%s %d:%d:%.0f\n', datestr, a(4), a(5), a(6));
        fprintf('SR11U___VCM2 went off! Turned it back on.\n');
        pause(0.5)
        setpv('SR11U___VCM2___AC10',vcm112u_sp);
        fprintf('\nReset SR11U___VCM2 to setpoint before it was off.\n');
        fprintf('Monitoring SR11U___VCM2 and writing proper value to DAC...\n');
        fprintf('\n');
        soundquestion;soundquestion;
    end

    if getpv('SR05C___VCM2___BC18')==0
        setpv('SR05C___VCM2___BC18',1);
        a = clock;datestr = date;
        fprintf('\n%s %d:%d:%.0f\n', datestr, a(4), a(5), a(6));
        fprintf('SR05C___VCM2 went off! Turned it back on.\n');
        pause(0.5)
        setpv('SR05C___VCM2___AC01',vcm52_sp);
        setpv('SR05C___VCM2T__AC10',vcm52T_sp);
        fprintf('\nReset SR05C___VCM2 and VCM2T to setpoints before it was off.\n');
        fprintf('Monitoring SR05C___VCM2 and writing proper value to SP...\n');
        fprintf('\n');
        soundquestion;soundquestion;
    end
    
    pause(.1)
end