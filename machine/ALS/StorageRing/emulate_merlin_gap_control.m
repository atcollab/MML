% emulate_merlin_gap_control
%

while 1
    [ffenable,gapenable]=getff([4 2]);
    if ffenable && gapenable
        if abs(getid([4 2])-getusergap([4 2]))>0.001
            setid([4 2],getusergap([4 2]));
        end
        pause(1);
    end
end