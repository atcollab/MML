function [R, Data, DataMM] = bpmresp2loco(R)
%BPMRESP2LOCO - Convert a MML response matrix to LOCO units
%  [R, Data, DataMM] = bpmresp2loco(R)
%  [R, Data, DataMM] = bpmresp2loco('Model')
%  [R, Data, DataMM] = bpmresp2loco('Meas')
%  
%  Using locogui one can export various response matrices to the workspace.
%  Unfortunately, it's a little confusing to compare them the normal MML matrices.
%  LOCO units are the same rotated coordinate system as the MML but the BPMs are
%  in hardware units (converted to mm if that is not the default) and the correctors
%  are in physics units (converted to milliradian if that is not the default).
%  Ie, hopefully this function makes it easier to convert.
%
%  EXAMPLES
%  1. Convert the default BPM response in the MML to LOCO units and
%     compare to the LOCO measured and model response (RespMatMeas/RespMatModel from locogui).
%     [R, BPMRespMML, BPMRespMMLmm] = bpmresp2loco(getbpmresp('Struct'));
%     subplot(2,1,1); 
%     surf(BPMRespMML-RespMatMeas);  title('MML Default - LOCO Measured'); xlabel('BPM #'); ylabel('CM #'); zlabel('[mm/mradian]');
%     subplot(2,1,2); 
%     surf(BPMRespMML-RespMatModel); title('MML Default - LOCO Model');    xlabel('BPM #'); ylabel('CM #'); zlabel('[mm/mradian]');
% 
%  2. Convert the model BPM response to LOCO units:
%     compare to the LOCO measured and model response (RespMatMeas/RespMatModel from locogui).
%     [R, BPMRespModel, BPMRespModelmm] = bpmresp2loco(measbpmresp('Struct','Model'));
%     subplot(2,1,1); 
%     surf(BPMRespModel-RespMatMeas);  title('MML Model - LOCO Measured'); xlabel('BPM #'); ylabel('CM #'); zlabel('[mm/mradian]');
%     subplot(2,1,2); 
%     surf(BPMRespModel-RespMatModel); title('MML Model - LOCO Model');    xlabel('BPM #'); ylabel('CM #'); zlabel('[mm/mradian]');

%  Written by Greg Portmann


if nargin == 0
    R = getbpmresp('Struct','Hardware');
end

if ischar(R)
    if strcmpi(R, 'Model')
        R = measbpmresp('Struct','Hardware','Model');
    elseif strcmpi(R, 'Meas')
        R = getbpmresp('Struct','Hardware');
    else
        error('   BPM response matrix must be structure, like getbpmresp(''Struct'').\n');
    end
elseif ~isstruct(R)
    error('   BPM response matrix must be structure, like getbpmresp(''Struct'').\n');
end


% Convert to hardware units
R = physics2hw(R);


% LOCO delta is mradians
ActHW1   = R(1,1).Actuator;
ActHW2   = ActHW1;
ActHW2.Data = ActHW1.Data + R(1,1).ActuatorDelta;
Act1 = hw2physics(ActHW1);
Act2 = hw2physics(ActHW2);
Delta = Act2.Data - Act1.Data;
Delta = 1000 * Delta;  % Since AT units are radians

% if any(strcmpi(Act1.UnitsString, {'radians', 'radian', 'rad', 'r'}))
%     Delta = 1000 * Delta;
% elseif any(strcmpi(Act1.UnitsString, {'milli-radians', 'milliradians', 'mradians', 'mradian', 'mrad', 'mr'}))
%     % Units are probably milliradians
% else
%     fprintf('   Actuator units need to be milli-radians.  I''m not sure what the actuator are (%s).\n', Act1.UnitsString);    
% end

if any(strcmpi(R(1,1).Monitor.UnitsString, {'m', 'meter', 'meters'}))
    % Convert to mm
    c = 1000;
elseif any(strcmpi(R(1,1).Monitor.UnitsString, {'mm', 'millimeters', 'milli-meters', 'millimeter', 'milli-meter'}))
    % Units are probably millimeters
    c = 1;
else
    c = 1;
    fprintf('   BPM units need to be millimeters.  I''m not sure what the units are (%s).  Answer may be incorrect.\n', R(1,1).Monitor.UnitsString);    
end


% Convert to Hardware / Physics units in mradians
Rmm = R;
for i = 1:size(R(1,1).Data,2)
    R(1,1).Data(:,i) = c * R(1,1).Data(:,i) .* R(1,1).ActuatorDelta(i) ./ Delta(i);
    R(2,1).Data(:,i) = c * R(2,1).Data(:,i) .* R(2,1).ActuatorDelta(i) ./ Delta(i);

    Rmm(1,1).Data(:,i) = c * Rmm(1,1).Data(:,i) .* Rmm(1,1).ActuatorDelta(i);
    Rmm(2,1).Data(:,i) = c * Rmm(2,1).Data(:,i) .* Rmm(2,1).ActuatorDelta(i);
end

R(1,1).Actuator = Act1;
R(2,1).Actuator = Act1;

if isfield(R(1,1).Monitor,'UnitsString') && isfield(R(1,1).Actuator,'UnitsString')
    R(1,1).UnitsString = [ ...
        R(1,1).Monitor.UnitsString , '/', ...
        R(1,1).Actuator.UnitsString];
else
    R(1,1).UnitsString = '';
end
R(2,1).UnitsString = R(1,1).UnitsString;



% LOCO delta is mradians
ActHW1   = R(2,2).Actuator;
ActHW2   = ActHW1;
ActHW2.Data = ActHW1.Data + R(2,2).ActuatorDelta;
Act1 = hw2physics(ActHW1);
Act2 = hw2physics(ActHW2);
Delta = Act2.Data - Act1.Data;
Delta = 1000 * Delta;  % Since AT units are radians

% if any(strcmpi(Act1.UnitsString, {'radians', 'radian', 'rad', 'r'}))
%     Delta = 1000 * Delta;
% elseif any(strcmpi(Act1.UnitsString, {'milli-radians', 'milliradians', 'mradians', 'mradian', 'mrad', 'mr'}))
%     % Units are probably milliradians
% else
%     fprintf('   Actuator units need to be milli-radians.  I''m not sure what the actuator are (%s).\n', Act1.UnitsString);    
% end


% Convert to Hardware / Physics units in mradians
for i = 1:size(R(2,2).Data,2)
    R(2,2).Data(:,i) = c * R(2,2).Data(:,i) .* R(2,2).ActuatorDelta(i) ./ Delta(i);
    R(1,2).Data(:,i) = c * R(1,2).Data(:,i) .* R(1,2).ActuatorDelta(i) ./ Delta(i);

    Rmm(2,2).Data(:,i) = c * Rmm(2,2).Data(:,i) .* Rmm(2,2).ActuatorDelta(i);
    Rmm(1,2).Data(:,i) = c * Rmm(1,2).Data(:,i) .* Rmm(1,2).ActuatorDelta(i);
end

R(2,2).Actuator = Act1;
R(1,2).Actuator = Act1;

if isfield(R(2,2).Monitor,'UnitsString') && isfield(R(2,2).Actuator,'UnitsString')
    R(2,2).UnitsString = [ ...
        R(2,2).Monitor.UnitsString , '/', ...
        R(2,2).Actuator.UnitsString];
else
    R(2,2).UnitsString = '';
end
R(1,2).UnitsString = R(2,2).UnitsString;




Data = [
    R(1,1).Data R(1,2).Data
    R(2,1).Data R(2,2).Data];

DataMM = [
    Rmm(1,1).Data Rmm(1,2).Data
    Rmm(2,1).Data Rmm(2,2).Data];

