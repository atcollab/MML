%local cycle the storage ring quads 5 times

qfa = getsp('QFA');
qda = getsp('QDA');
qfb = getsp('QFB');

for i = 1:5
stepsp('QFA',2);
stepsp('QFA',-2);
stepsp('QFA',-2);
stepsp('QFA',2);

stepsp('QDA',2);
stepsp('QDA',-2);
stepsp('QDA',-2);
stepsp('QDA',2);

stepsp('QFB',2);
stepsp('QFB',-2);
stepsp('QFB',-2);
stepsp('QFB',2);

end

putsp('QFA',qfa);
putsp('QDA',qda);
putsp('QFB',qfb);
