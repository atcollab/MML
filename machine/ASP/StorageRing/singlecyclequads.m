qfasp = getsp('QFA');
qfbsp = getsp('QFB');
qdasp = getsp('QDA');

setsp('QFA',0);
setsp('QFB',0);
setsp('QDA',0);

disp('Quads min')
pause(20);

setsp('QFA',160);
setsp('QFB',160);
setsp('QDA',90);

disp('Quads max')

pause(20)

setsp('QFA',qfasp);
setsp('QFB',qfbsp);
setsp('QDA',qdasp);

disp('done');