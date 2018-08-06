% phase_servo - Phase servo based on waveform data

% phase_servo(dev, bunch_list)
% sys        - device ID
% bunch_list - A list of bunch numbers (1 based) to include

function phase_servo(sys, bunch_list)

prm.root = 'IGPF';

if isempty(sys)
  sys='TEST';
end

prm.sys = sys;
pvnm = [prm.root, ':', prm.sys, ':'];
prm.fpga_rev = lcaGet([pvnm, 'REVISION']);

if (prm.fpga_rev < 3) % iGp8
  mv = [pvnm, 'MEAN'];
else
  prm.acq_unit = 'BRAM';
  mv = [pvnm, prm.acq_unit, ':MEAN'];
end

% Control longitudinal setpoint only for now
ctrls = {[pvnm, 'FBELT:SERVO:SETPT']; [pvnm, 'FBELT:X_PHASE:SETPT']; ...
         [pvnm, 'FBELT:Y_PHASE:SETPT']};

% Clear all EPICS connections to start
lcaClear

prm.h = lcaGet([pvnm, 'HARM_NUM']);

% Generate mask, verify
prm.mask = zeros(prm.h, 1);
prm.mask(bunch_list) = 1;
if (length(prm.mask) ~= prm.h)
  error(sprintf('Bunch mask is %d long instead of %d expected', ...
        length(prm.mask), prm.h));
end
prm.bunch_list = find(prm.mask == 1);

% Base values
ctrl_val0  = lcaGet(ctrls);


cleanupObj = onCleanup(@() lcaPut(ctrls, ctrl_val0));

lcaSetMonitor(mv, prm.h);

int = 0;
while (1)
    lcaNewMonitorWait(mv);
    val = lcaGet(mv);
    % Get offset, gain, limit
    offset = lcaGet([pvnm, 'FBELT:SERVO:OFFSET']);
    gain   = lcaGet([pvnm, 'FBELT:SERVO:GAIN']);
    gain   = gain * (1-2*lcaGet([pvnm, 'FBELT:SERVO:SIGN'], 1, 'double'));
    maxv   = lcaGet([pvnm, 'FBELT:SERVO:MAXDELTA']);
    % Calculate masked average
    avg = mean(val(prm.bunch_list));
    int = int + gain*(avg - offset);
    if (abs(int) > maxv)
      int = sign(int) * maxv;
    end
    lcaPut([pvnm, 'AMP0:OFFSET'], int);
    lcaPut(ctrls, ctrl_val0 + round(int));
end
