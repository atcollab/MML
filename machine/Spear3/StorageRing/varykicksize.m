[N,T] = getbpmaverages;
MinCurrent = 13;
NewDir = 'R:\Controls\matlab\spear3data\User\Loco\2004-05-05';

    fprintf('   Measuring dispersion\n');
    [Dx, Dy, FileName] = measdisp('Struct','Archive');
    copyfile([FileName, '.mat'], NewDir);
    fprintf('   Measuring BPM sigma\n');
    [BPMx, BPMy, FileName] = monbpm(0:T:3*60, 'Struct', 'Archive');
    copyfile([FileName, '.mat'], NewDir);
    fprintf('   BPM noise measurement complete\n\n');

fprintf('   Measuring response matrix 1 of 8\n');
R = measbpmresp('BPMx',[],'BPMy',[],'HCM',[],'VCM',[],1*ones(length(getsp('HCM')),1),2*ones(length(getsp('VCM')),1),'Archive','R:\Controls\matlab\spear3data\User\Loco\2004-05-05\R1');
    if getdcct < MinCurrent
        fprintf('   LOCO measurement stopped due to beam current < %f mAmps\n', MinCurrent);
        return
    end
fprintf('   Measuring response matrix 2 of 8\n');
R = measbpmresp('BPMx',[],'BPMy',[],'HCM',[],'VCM',[],2*ones(length(getsp('HCM')),1),4*ones(length(getsp('VCM')),1),'Archive','R:\Controls\matlab\spear3data\User\Loco\2004-05-05\R2');
    if getdcct < MinCurrent
        fprintf('   LOCO measurement stopped due to beam current < %f mAmps\n', MinCurrent);
        return
    end
fprintf('   Measuring response matrix 3 of 8\n');
R = measbpmresp('BPMx',[],'BPMy',[],'HCM',[],'VCM',[],3*ones(length(getsp('HCM')),1),6*ones(length(getsp('VCM')),1),'Archive','R:\Controls\matlab\spear3data\User\Loco\2004-05-05\R3');
    if getdcct < MinCurrent
        fprintf('   LOCO measurement stopped due to beam current < %f mAmps\n', MinCurrent);
        return
    end
fprintf('   Measuring response matrix 4 of 8\n');
R = measbpmresp('BPMx',[],'BPMy',[],'HCM',[],'VCM',[],4*ones(length(getsp('HCM')),1),8*ones(length(getsp('VCM')),1),'Archive','R:\Controls\matlab\spear3data\User\Loco\2004-05-05\R4');
    if getdcct < MinCurrent
        fprintf('   LOCO measurement stopped due to beam current < %f mAmps\n', MinCurrent);
        return
    end
fprintf('   Measuring response matrix 5 of 8\n');
R = measbpmresp('BPMx',[],'BPMy',[],'HCM',[],'VCM',[],5*ones(length(getsp('HCM')),1),10*ones(length(getsp('VCM')),1),'Archive','R:\Controls\matlab\spear3data\User\Loco\2004-05-05\R5');
    if getdcct < MinCurrent
        fprintf('   LOCO measurement stopped due to beam current < %f mAmps\n', MinCurrent);
        return
    end
fprintf('   Measuring response matrix 6 of 8\n');
R = measbpmresp('BPMx',[],'BPMy',[],'HCM',[],'VCM',[],6*ones(length(getsp('HCM')),1),12*ones(length(getsp('VCM')),1),'Archive','R:\Controls\matlab\spear3data\User\Loco\2004-05-05\R6');
    if getdcct < MinCurrent
        fprintf('   LOCO measurement stopped due to beam current < %f mAmps\n', MinCurrent);
        return
    end
fprintf('   Measuring response matrix 7 of 8\n');
R = measbpmresp('BPMx',[],'BPMy',[],'HCM',[],'VCM',[],8*ones(length(getsp('HCM')),1),16*ones(length(getsp('VCM')),1),'Archive','R:\Controls\matlab\spear3data\User\Loco\2004-05-05\R8');
    if getdcct < MinCurrent
        fprintf('   LOCO measurement stopped due to beam current < %f mAmps\n', MinCurrent);
        return
    end
fprintf('   Measuring response matrix 8 of 8\n');
R = measbpmresp('BPMx',[],'BPMy',[],'HCM',[],'VCM',[],10*ones(length(getsp('HCM')),1),20*ones(length(getsp('VCM')),1),'Archive','R:\Controls\matlab\spear3data\User\Loco\2004-05-05\R10');


    if getdcct < MinCurrent
        fprintf('   LOCO measurement stopped due to beam current < %f mAmps\n', MinCurrent);
        return
    end
    fprintf('   Measuring dispersion\n');
    [Dx, Dy, FileName] = measdisp('Struct','Archive');
    copyfile([FileName, '.mat'], NewDir);
    fprintf('   Measuring BPM sigma\n');
    [BPMx, BPMy, FileName] = monbpm(0:T:3*60, 'Struct', 'Archive');
    copyfile([FileName, '.mat'], NewDir);
    fprintf('   BPM noise measurement complete\n\n');
