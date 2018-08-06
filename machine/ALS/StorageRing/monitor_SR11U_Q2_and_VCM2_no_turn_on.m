function monitor_SR11U_Q2_and_VCM2_no_turn_on

fprintf('\nMonitoring SR11U___Q2 and SR11U___VCM2 and alarming if off or J not writing to DAC\n');

while 1
    if getpv('SR11U___Q2_____AC10')-getpv('SR11U___Q2J____AC01')>.1;
        a = clock;datestr = date;
        fprintf('\n%s %d:%d:%.0f\n', datestr, a(4), a(5), a(6));
        fprintf('SR11U___Q2J ~= SR11U___Q2 DAC.\n');
        fprintf('\nMonitoring SR11U___Q2 and SR11U___VCM2\n');
        fprintf('\n');
        soundquestion;soundquestion;
    end
    
    if getpv('SR11U___VCM2___AC10')-getpv('SR11U___VCM2J__AC00')>.1;
        a = clock;datestr = date;
        fprintf('\n%s %d:%d:%.0f\n', datestr, a(4), a(5), a(6));
        fprintf('SR11U___VCM2J ~= SR11U___VCM2 DAC.\n');
        fprintf('\nMonitoring SR11U___Q2 and SR11U___VCM2\n');
        fprintf('\n');
        soundquestion;soundquestion;
    end
    

    if getpv('SR11U___Q2_____BC22')==0
        a = clock;datestr = date;
        fprintf('\n%s %d:%d:%.0f\n', datestr, a(4), a(5), a(6));
        fprintf('SR11U___Q2 went off.\n');
        fprintf('\nMonitoring SR11U___Q2 and SR11U___VCM2\n');
        fprintf('\n');
        soundquestion;soundquestion;
    end
    
    if getpv('SR11U___Q2_____BM16')==0
        a = clock;datestr = date;
        fprintf('\n%s %d:%d:%.0f\n', datestr, a(4), a(5), a(6));
        fprintf('SR11U___Q2 boolean on/off monitor went off.\n');
        fprintf('\nMonitoring SR11U___Q2 and SR11U___VCM2\n');
        fprintf('\n');
        soundquestion;soundquestion;
    end
    
    if getpv('SR11U___VCM2___BC22')==0
        a = clock;datestr = date;
        fprintf('\n%s %d:%d:%.0f\n', datestr, a(4), a(5), a(6));
        fprintf('SR11U___VCM2 went off.\n');
        fprintf('\nMonitoring SR11U___Q2 and SR11U___VCM2\n');
        fprintf('\n');
        soundquestion;soundquestion;
    end
    
    if getpv('SR11U___VCM2___BM16')==0
        a = clock;datestr = date;
        fprintf('\n%s %d:%d:%.0f\n', datestr, a(4), a(5), a(6));
        fprintf('SR11U___VCM2 boolean on/off monitor went off.\n');
        fprintf('\nMonitoring SR11U___Q2 and SR11U___VCM2\n');
        fprintf('\n');
        soundquestion;soundquestion;
    end
    
    pause(.1)
end