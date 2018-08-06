function [SQSFincr, SQSDincr] = step_skew_wave(scale)
% function [SQSFincr, SQSDincr] = step_skew_wave(scale)
%
% Quick and dirty solution to change skew wave for KAC lattice

if isempty(scale) | isnan(scale)
    scale = 0;
end

[SQSFincr, SQSDincr] = set_etaywave_nux1618_nuy925_20skews_skewFF(-scale);
SQSFsp=getpv('SQSF','Setpoint','Physics');
SQSDsp=getpv('SQSD','Setpoint','Physics');

warning('step_skew_wave: This routine should only be used by an EXPERT USER. It has the potential to corrupt srcontrol lattice configuration files');
warning('If you really want to execute this routine, edit the code file and comment out the return statement after this line');

return

setpv('SQSF', 'Setpoint', SQSFsp+SQSFincr, [], 0, 'Physics');
setpv('SQSD', 'Setpoint', SQSDsp+SQSDincr, [], 0, 'Physics');

pause(2);

load GoldenConfig_LowEmittance.mat

MachineConfigStructure.SQSF.Setpoint.Data=getsp('SQSF');
MachineConfigStructure.SQSD.Setpoint.Data=getsp('SQSD');
MachineConfigStructure.SQSF.Monitor.Data=getam('SQSF');
MachineConfigStructure.SQSD.Monitor.Data=getam('SQSD');

save GoldenConfig_LowEmittance.mat
