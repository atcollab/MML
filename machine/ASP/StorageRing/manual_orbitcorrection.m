X = getam('BPMx');

% Rx = measbpmresp('BPMx','HCM','Model','Bipolar','Archive','Numeric','FixedPathLength','Linear');
Rx = getrespmat('BPMx','HCM','');

Ivec = 1:30;
[U,S,V] = svd(Rx,0);

deltarads = -V(:,Ivec)*S(Ivec,Ivec)^-1*U(:,Ivec)'*X;
deltaamps = physics2hw('HCM','Setpoint',deltarads);
currhcm = getsp('HCM','Hardware');
newhcm = deltaamps + currhcm;

figure; plot(newhcm);

Nsteps = 10;
j = 0
while j <= Nsteps
    usrresp = questdlg(sprintf('Orbit correction iteration = %d / %d',j,Nsteps),...
        'Orbit Correction','Continue','Backstep','Finished','Continue');
    switch usrresp
        case 'Continue'
            j = j + 1;
        case 'Backstep'
            j = j - 1;
        case 'Finished'
            break;
        case ''
    end
    setsp('HCM',currhcm + deltaamps.*(j/Nsteps),'Hardware');
end
