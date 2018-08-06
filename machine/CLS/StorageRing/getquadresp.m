function [Xresp, Yresp] = getquadresp(kickVal)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/getquadresp.m 1.2 2007/03/02 09:02:22CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% [Xresp, Yresp] = GETQUADRESP(KICKVAL)
% This measures the responses in the horizontal and vertical direction due
% to changes in the strengths of the quadrupoles. Where KICKVAL [DAC] is the
% strength of the change in the quadrupole in DAC.
% ----------------------------------------------------------------------------------------------


[tmp timeout error] = getam('QFA');
if error
    disp('Problem getting data from the QFA')
    return
else
    numA = length(tmp);
end
[tmp timeout error] = getam('QFB');
if error
    disp('Problem getting data from the QFB')
    return
else
    numB = length(tmp);
end
[tmp timeout error] = getam('QFC');
if error
    disp('Problem getting data from the QFC')
    return
else
    numC = length(tmp);
end
totalquads = numA + numB + numC;
% totalquads = numC;

tempY = [];
Yresp = zeros(48,totalquads);
Xresp = zeros(48,totalquads);
tempYmon = [];
tempXmon = [];
initA = getsp('QFA');
initB = getsp('QFB');
initC = getsp('QFC');
avgOverTurns = 5;
wait_per_quad = 4.0;  % seconds
wait_per_sample = 0.1; % seconds

numquadsdone = 0;
for i=1:numA
    fprintf('measuring QFA %d\n',i);
    tempXmon = getx;
    tempYmon = gety;

    setpv('QFA','Setpoint',initA(i) + kickVal,i);
    pause(wait_per_quad);

    tmpx = 0;
    tmpy = 0;
    for j=1:avgOverTurns
        tmpx = tmpx + ((tempXmon - getx) / kickVal);
        pause(wait_per_sample)
        tmpy = tmpy + ((tempYmon - gety) / kickVal);
        pause(wait_per_sample);
    end
    numquadsdone = numquadsdone + 1;
    Xresp(:,numquadsdone) =  tmpx/avgOverTurns;
    Yresp(:,numquadsdone) =  tmpy/avgOverTurns;
    
    %set quadrupole back to original setting
    setpv('QFA','Setpoint',initA(i),i);
    pause(wait_per_quad);
end

for i=1:numB
    fprintf('measuring QFB %d\n',i);
    tempXmon = getx;
    tempYmon = gety;

    setpv('QFB','Setpoint',initB(i) + kickVal,i);
    pause(wait_per_quad);

    tmpx = 0;
    tmpy = 0;
    for j=1:avgOverTurns
        tmpx = tmpx + ((tempXmon - getx) / kickVal);
        pause(wait_per_sample)
        tmpy = tmpy + ((tempYmon - gety) / kickVal);
        pause(wait_per_sample);
    end
    numquadsdone = numquadsdone + 1;
    Xresp(:,numquadsdone) =  tmpx/avgOverTurns;
    Yresp(:,numquadsdone) =  tmpy/avgOverTurns;
    
    %set quadrupole back to original setting
    setpv('QFB','Setpoint',initB(i),i);
    pause(wait_per_quad);
end

for i=1:numC
    fprintf('measuring QFC %d\n',i);
    tempXmon = getx;
    tempYmon = gety;

    setpv('QFC','Setpoint',initC(i) + kickVal,i);
    pause(wait_per_quad);

    tmpx = 0;
    tmpy = 0;
    for j=1:avgOverTurns
        tmpx = tmpx + ((tempXmon - getx) / kickVal);
        pause(wait_per_sample)
        tmpy = tmpy + ((tempYmon - gety) / kickVal);
        pause(wait_per_sample);
    end
    numquadsdone = numquadsdone + 1;
    Xresp(:,numquadsdone) =  tmpx/avgOverTurns;
    Yresp(:,numquadsdone) =  tmpy/avgOverTurns;
    
    %set quadrupole back to original setting
    setpv('QFC','Setpoint',initC(i),i);
    pause(wait_per_quad);
end

% Resort quadrupoles A and B so we group the quadrupoles by cell. Ie where
% before we had AAAAA....BBBBB we now want ABBAABBAABBAABBA.
% tempx = zeros(48,48);
% tempy = zeros(48,48);
% 
% tempx(:,[1:4:48]) = Xquadresp3(:,([1:12]*2-1));
% tempx(:,[4:4:48]) = Xquadresp3(:,([1:12]*2));
% tempx(:,[3:4:48]) = Xquadresp3(:,24+([1:12]*2));
% tempx(:,[2:4:48]) = Xquadresp3(:,24+([1:12]*2 - 1));
% 
% tempy(:,[1:4:48]) = Yquadresp3(:,([1:12]*2-1));
% tempy(:,[4:4:48]) = Yquadresp3(:,([1:12]*2));
% tempy(:,[3:4:48]) = Yquadresp3(:,24+([1:12]*2));
% tempy(:,[2:4:48]) = Yquadresp3(:,24+([1:12]*2 - 1));

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/getquadresp.m  $
% Revision 1.2 2007/03/02 09:02:22CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
