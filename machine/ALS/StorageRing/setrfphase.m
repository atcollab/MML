function RF = setrfphase(RFPhaseGoal)
%SETRFPHASE - Set the RF phase slow loop 
% setrfphase(RFPhaseGoal)
%
%  INPUTS
%  1. RFPhaseGoal - Phase Goal (VVM channel SR03S___RFPHASAAM00)
%
%  OUTPUTS
%  1. RF - Structure of inputs and outputs
%


if nargin < 1
    RF.PhaseGoal = 110;
else
    RF.PhaseGoal = RFPhaseGoal;
end

RF.ThresholdCurrent = 20;  % mA

% Vector voltmeter phase (SR04 ILC via GPIB) (averaged)
Navg = 5;   % Number of averages
T = .5;     % Sample period ???
RF.PhaseVVM = mean(getpvonline('SR03S___RFPHASAAM00',0:T:T*(Navg-1)));

RF.Actuator = .4 * (RF.PhaseGoal - RF.PhaseVVM);    

RF.DCCT = 1000 * getpvonline('SR05W___DCCT2__AM01');

if RF.DCCT > RF.ThresholdCurrent
    setpvonline('SR03S___RIPHLP_AC03', RF.Actuator);
end

