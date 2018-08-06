function SR04EPU2_limit_gap_AP_mode

mingapstr = inputdlg('What minimum gap for EPU4-2 in anti-parallel mode?','EPU4-2 Minimum Gap',1,{'30'});
mingap=str2num(mingapstr{1});

fprintf('\n');
fprintf('Monitoring EPU4-2:\n');
fprintf('If device is switched to anti-parallel mode this routine will limit gap to %2d mm minimum\n',mingap);
fprintf('Cntrl-C out of routine and re-run it if you want to change the minimum gap\n');
fprintf('(But ask Physics Group first!)\n');
fprintf('\n');
fprintf('Busy monitoring...');

while 1
    Zmode=getpv('SR04U___ODS2M__DC00');
    Zshift=getpv('SR04U___ODS2PS_AC00');
    if Zmode==1 || Zmode==2
        setpv('sr04u2:opr_grant',0); %disable user gap control (since FF off turns it off anyway)
        setpv('sr04u2:FFEnable:bo',0); %disable FF (sicne current table makes it worse)
        
        setpv('SR04U___GDS2V__AC01',0.5); %set very slow vertical speed (since orbit feedback is doing everything)
        setpv('SR04U___ODS2V__AC01',0.2); %set very slow horizontal speed (since orbit feedback is doing everything)
        
        usergap=getpv('sr04u2:bl_input');
        gap=getpv('SR04U___GDS2PS_AC00');
        
        if usergap<30
            setpv('SR04U___GDS2PS_AC00',mingap);
            setpv('sr04u2:bl_input',mingap);
        else
            if gap<100
                setpv('SR04U___GDS2PS_AC00',usergap);
            end
        end
        if Zmode==2
            setpv('SR04U___ODS2PS_AC00',Zshift);
        end
    else
        setpv('sr04u2:opr_grant',1); %enable user gap control
        setpv('sr04u2:FFEnable:bo',1); %enable FF (current table makes it worse)
        pause(1)
        setpv('SR04U___GDS2V__AC01',3.0); %set default vertical speed
        setpv('SR04U___ODS2V__AC01',7.5); %set default horizontal speed
        %setpv('SR04U___GDS2PS_AC00',getpv('sr04u2:bl_input'));
    end
    pause(0.1)
    if getpv('sr:user_beam')==0
        setpv('SR04U___ODS2M__DC00',0);
        soundtada;
        fprintf('\n\nExiting since shutters have closed...\n');
        fprintf('\nRerun once shutters are open again!\n\n');
        break
    end
end
