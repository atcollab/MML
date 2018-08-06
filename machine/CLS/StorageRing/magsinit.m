function magsinit
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/magsinit.m 1.2 2007/03/02 09:03:23CST matiase Exp  $
% ----------------------------------------------------------------------------------------------


for i = 1:12
    % Horizontal
    AO{3}.Monitor.ChannelNames (4*(i-1)+1,:) = sprintf('OCH14%02d-01:adc  ', i);
    AO{3}.Setpoint.ChannelNames(4*(i-1)+1,:) = sprintf('OCH14%02d-01:dac  ', i);
    
    AO{3}.Monitor.ChannelNames (4*(i-1)+2,:) = sprintf('SOA14%02d-01:X:adc', i);
    AO{3}.Setpoint.ChannelNames(4*(i-1)+2,:) = sprintf('SOA14%02d-01:X:dac', i);
    
    AO{3}.Monitor.ChannelNames (4*(i-1)+3,:) = sprintf('SOA14%02d-02:X:adc', i);
    AO{3}.Setpoint.ChannelNames(4*(i-1)+3,:) = sprintf('SOA14%02d-02:X:dac', i);

    AO{3}.Monitor.ChannelNames (4*(i-1)+4,:) = sprintf('OCH14%02d-02:adc  ', i);
    AO{3}.Setpoint.ChannelNames(4*(i-1)+4,:) = sprintf('OCH14%02d-02:dac  ', i);
    
    AO{3}.DeviceList  = [AO{3}.DeviceList; [i 1;i 2;i 3;i 4]];

    % AO{3}.Monitor.HW2PhysicsParams(4*(i-1)+1,:) = HCMGain1;
    % AO{3}.Monitor.Physics2HWParams(4*(i-1)+1,:) = HCMGain1;
    % AO{3}.Setpoint.HW2PhysicsParams(4*(i-1)+1,:) = HCMGain2;         
    % AO{3}.Setpoint.Physics2HWParams(4*(i-1)+1,:) = HCMGain2; 
    % AO{3}.Monitor.HW2PhysicsParams(4*(i-1)+2,:) = HCMGain1;
    % AO{3}.Monitor.Physics2HWParams(4*(i-1)+2,:) = HCMGain1;
    % AO{3}.Setpoint.HW2PhysicsParams(4*(i-1)+2,:) = HCMGain2;         
    % AO{3}.Setpoint.Physics2HWParams(4*(i-1)+2,:) = HCMGain2; 
    % AO{3}.Monitor.HW2PhysicsParams(4*(i-1)+3,:) = HCMGain1;
    % AO{3}.Monitor.Physics2HWParams(4*(i-1)+3,:) = HCMGain1;
    % AO{3}.Setpoint.HW2PhysicsParams(4*(i-1)+3,:) = HCMGain2;         
    % AO{3}.Setpoint.Physics2HWParams(4*(i-1)+3,:) = HCMGain2; 
    % AO{3}.Monitor.HW2PhysicsParams(4*(i-1)+4,:) = HCMGain1;
    % AO{3}.Monitor.Physics2HWParams(4*(i-1)+4,:) = HCMGain1;
    % AO{3}.Setpoint.HW2PhysicsParams(4*(i-1)+4,:) = HCMGain2;         
    % AO{3}.Setpoint.Physics2HWParams(4*(i-1)+4,:) = HCMGain2; 

    AO{3}.Setpoint.Range(4*(i-1)+1:4*(i-1)+4,1) = -inf;
    AO{3}.Setpoint.Range(4*(i-1)+1:4*(i-1)+4,2) =  inf;
    AO{3}.Setpoint.Tolerance(4*(i-1)+1:4*(i-1)+4,1) = ToleranceInCounts;
    AO{3}.Setpoint.Resp(4*(i-1)+1:4*(i-1)+4,1) = .1/1000;   % /1000 for radian units

    
    % Vertical
    AO{4}.Monitor.ChannelNames (4*(i-1)+1,:) = sprintf('OCV14%02d-01:adc  ', i);
    AO{4}.Setpoint.ChannelNames(4*(i-1)+1,:) = sprintf('OCV14%02d-01:dac  ', i);
    
    AO{4}.Monitor.ChannelNames (4*(i-1)+2,:) = sprintf('SOA14%02d-01:Y:adc', i);
    AO{4}.Setpoint.ChannelNames(4*(i-1)+2,:) = sprintf('SOA14%02d-01:Y:dac', i);
    
    AO{4}.Monitor.ChannelNames (4*(i-1)+3,:) = sprintf('SOA14%02d-02:Y:adc', i);
    AO{4}.Setpoint.ChannelNames(4*(i-1)+3,:) = sprintf('SOA14%02d-02:Y:dac', i);

    AO{4}.Monitor.ChannelNames (4*(i-1)+4,:) = sprintf('OCV14%02d-02:adc  ', i);
    AO{4}.Setpoint.ChannelNames(4*(i-1)+4,:) = sprintf('OCV14%02d-02:dac  ', i);
    
    AO{4}.DeviceList  = [AO{4}.DeviceList; [i 1;i 2;i 3;i 4]];
    
    % AO{4}.Monitor.HW2PhysicsParams(4*(i-1)+1,:) = HCMGain1;
    % AO{4}.Monitor.Physics2HWParams(4*(i-1)+1,:) = HCMGain1;
    % AO{4}.Setpoint.HW2PhysicsParams(4*(i-1)+1,:) = HCMGain2;         
    % AO{4}.Setpoint.Physics2HWParams(4*(i-1)+1,:) = HCMGain2; 
    % AO{4}.Monitor.HW2PhysicsParams(4*(i-1)+2,:) = HCMGain1;
    % AO{4}.Monitor.Physics2HWParams(4*(i-1)+2,:) = HCMGain1;
    % AO{4}.Setpoint.HW2PhysicsParams(4*(i-1)+2,:) = HCMGain2;         
    % AO{4}.Setpoint.Physics2HWParams(4*(i-1)+2,:) = HCMGain2; 
    % AO{4}.Monitor.HW2PhysicsParams(4*(i-1)+3,:) = HCMGain1;
    % AO{4}.Monitor.Physics2HWParams(4*(i-1)+3,:) = HCMGain1;
    % AO{4}.Setpoint.HW2PhysicsParams(4*(i-1)+3,:) = HCMGain2;         
    % AO{4}.Setpoint.Physics2HWParams(4*(i-1)+3,:) = HCMGain2; 
    % AO{4}.Monitor.HW2PhysicsParams(4*(i-1)+4,:) = HCMGain1;
    % AO{4}.Monitor.Physics2HWParams(4*(i-1)+4,:) = HCMGain1;
    % AO{4}.Setpoint.HW2PhysicsParams(4*(i-1)+4,:) = HCMGain2;         
    % AO{4}.Setpoint.Physics2HWParams(4*(i-1)+4,:) = HCMGain2; 
    

    AO{4}.Setpoint.Range(4*(i-1)+1:4*(i-1)+4,1) = -inf;
    AO{4}.Setpoint.Range(4*(i-1)+1:4*(i-1)+4,2) =  inf;
    AO{4}.Setpoint.Tolerance(4*(i-1)+1:4*(i-1)+4,1) = ToleranceInCounts;
    AO{4}.Setpoint.Resp(4*(i-1)+1:4*(i-1)+4,1) = .1/1000;   % /1000 for radian units
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/magsinit.m  $
% Revision 1.2 2007/03/02 09:03:23CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------

