function setcyclecurve(dev_name, curve)
% SETCYCLECURVE - Set curve for cycling magnet in Dserver
%
%  INPUTS
%  1. dev_name - Tango sequencer device name
%  2. curve  - nx2 vector current versus times
%
%  EXAMPLES
%  1. setcyclecurve('LT1/AE/cycleCH.2', curve);
%  2. setcyclecurve({'LT1/tests/currentCH.1','LT1/AE/cycleCH.2'}, {curve1, curve2});
%
%  NOTES
%  1. Inputs can by cells of dev_name and cells of curves
%  2. Tango specific
%
%  See Also getcyclecurve, magnetcycle, LT1cycling, Ringcycling,cyclingcommand

%
% Written by Laurent S. Nadolski

if iscell(dev_name)
    for k = 1:length(dev_name),
        setcyclecurve(dev_name{k}, curve{k});        
    end
else
    
    dev_name
    % Get size of sequence
    len = tango_get_properties2(dev_name,{'SequenceSize'});

    % Needed in order if Fault state
    state = tango_state2(dev_name);
    if ~strcmpi(state, 'INIT')
        dips('INIT')
        tango_command_inout2(dev_name, 'Init');
    end

    if str2double(len.value{:}) ~= size(curve,1)
        % Modify size of the sequence
        prop.name = 'SequenceSize';
        prop.value = {num2str(size(curve,1))};
        tango_put_properties2(dev_name,prop);
        % Needed in order to take into account modification
        tango_command_inout2(dev_name, 'Init');
    end

    % Load the curve into Dserver : attribute part and time part
    tic
    tango_command_inout2(dev_name,'LoadSequenceValues', curve(:,1)');
    tango_command_inout2(dev_name,'LoadWaitingTimes', curve(:,2)');
    toc
end