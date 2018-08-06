function deltaQ=step_tune_config_file(deltanux,deltanuy)
% deltaQ=step_tune_config_file(deltanux,deltanuy)
%
% This routine can be used to modify the machine configuration file that is used by the tune compensation in srcontrol
%
% Warning: This routine should only be used by an expert!
%
% Christoph Steier, 2013-04-19

deltaQ=[0;0];

if nargin~=2
    error('Need two input arguments: deltanux and deltanuy! Exiting ...');
end

if (abs(deltanux)>0.1) || (abs(deltanuy)>0.1)
    error('Requested tune change is larger than advisable! Exiting ...');
end
  
warning('step_tune_config_file: This routine should only be used by an EXPERT USER. It has the potential to corrupt srcontrol lattice configuration files');
warning('If you really want to execute this routine, edit the code file and comment out the return statement after this line');

%return

gotobase

cd ..
cd StorageRingOpsData
cd TwoBunch

tuner=gettuneresp;

load GoldenConfig_TwoBunch.mat

deltaQ=inv(tuner)*[deltanux;deltanuy]

MachineConfigStructure.QF.Setpoint.Data=MachineConfigStructure.QF.Setpoint.Data+deltaQ(1);
MachineConfigStructure.QD.Setpoint.Data=MachineConfigStructure.QD.Setpoint.Data+deltaQ(2);
MachineConfigStructure.QF.Monitor.Data=MachineConfigStructure.QF.Monitor.Data+deltaQ(1);
MachineConfigStructure.QD.Monitor.Data=MachineConfigStructure.QD.Monitor.Data+deltaQ(2);

prod=getproductionlattice;

figure
subplot(2,1,1)
bar([MachineConfigStructure.QF.Setpoint.Data-prod.QF.Setpoint.Data MachineConfigStructure.QF.Setpoint.Data-getsp('QF')]);
subplot(2,1,2)
bar([MachineConfigStructure.QD.Setpoint.Data-prod.QD.Setpoint.Data MachineConfigStructure.QD.Setpoint.Data-getsp('QD')]);

disp('Last Chance to not save lattice file - Hit CTRL-C now to abort or return to continue');
pause;

save GoldenConfig_TwoBunch.mat MachineConfigStructure
return