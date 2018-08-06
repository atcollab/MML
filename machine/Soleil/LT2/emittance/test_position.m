function test = test_position(pos,ref,delta)

test=0;
if pos<(ref+delta)&pos>(ref-delta)
    test=1;
    return
else
    errordlg('il y a un pb avec les axes !','Erreur');  
end