% Mini Script that cycles all Quads by n Amps.

n = + 0.5
sp1 = getsp('QFA');
sp2 = sp1 +n;
setsp('QFA',sp2,[1:28]');
sp3 = getsp('QFB');
sp4 = sp3 +n;
setsp('QFB',sp4,[1:28]');
sp5 = getsp('QDA');
sp6 = sp5 +n;
setsp('QDA',sp6,[1:28]');





