function monitor_SR11U_Q2_and_VCM2

fprintf('\nMonitoring SR11U___Q2 and SR11U___VCM2 and writing proper value to DAC...\n');

while 1
    setpv('SR11U___Q2_____AC10',getpv('SR11U___Q2J____AC01'));
    setpv('SR11U___VCM2___AC10',getpv('SR11U___VCM2J__AC00'));

    if getpv('SR11U___Q2_____BC22')==0
        setpv('SR11U___Q2_____BC22',1);
        a = clock;datestr = date;
        fprintf('\n%s %d:%d:%.0f\n', datestr, a(4), a(5), a(6));
        fprintf('SR11U___Q2 went off! Turned it back on.\n');
        fprintf('\nMonitoring SR11U___Q2 and SR11U___VCM2 and writing proper value to DAC...\n');
        fprintf('\n');
        soundquestion;soundquestion;
    end
    
    if getpv('SR11U___VCM2___BC22')==0
        setpv('SR11U___VCM2___BC22',1);
        a = clock;datestr = date;
        fprintf('\n%s %d:%d:%.0f\n', datestr, a(4), a(5), a(6));
        fprintf('SR11U___VCM2 went off! Turned it back on.\n');
        fprintf('\nMonitoring SR11U___Q2 and SR11U___VCM2 and writing proper value to DAC...\n');
        fprintf('\n');
        soundquestion;soundquestion;
    end
    
    pause(.1)
end