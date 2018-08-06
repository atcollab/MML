function setrampRF(varargin)
% SETRFRAMP - Loads a new AC ramp the the RF voltage
%
%  INPUTS
%  1. AC ramp maximum between 0 and 5 in kV
%        0 means 0 kV
%        5 means mean 500 kV at maximum 
%
%  NOTES
%  1. do not forget the DC value which is added
%
%
%  See Also getrframp

%
%  Written by Laurent S. Nadolski

DisplayFlag = 1;
devName = 'BOO/RF/SAO.1';

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = O;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoArchive')
        ArchiveFlag = O;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Archive')
        ArchiveFlag = 1;
        varargin(i) = [];
    end
end

if isempty(varargin)
    disp('Missing factor exiting ...')
    return;
else
    factor = varargin{1};
    if factor > 8
        error('Too large')
    end
end

rampe = getrframp('NoDisplay');

figure

plot(rampe*100)

rampe2 = rampe/2;
rampe2= rampe/max(rampe)*factor;

hold on
plot(rampe2*100,'r.')
hold off
legend('Old RF voltage Ramp','New RF voltage ramp')
grid on
ylabel('RF voltage (kV)');
title('RF ramp')
addlabel(1,0,sprintf('%s', datestr(clock)));


reply = input('Do you want to apply this ramp? Y/N [N]: ','s');

if isempty(reply)
    reply = 'N';
end

switch reply
    case 'Y'    
        % build the property
        prop.name = 'Channel0WaveForm';
        prop.value = {num2str(rampe2)};

        for k=1:100
            prop.value{k} = num2str(rampe2(k));
        end

        % write the new ramp
        tango_command_inout2(devName, 'Stop');
        tango_put_properties2(devName,prop)
        tango_command_inout2(devName, 'Init');
        tango_command_inout2(devName, 'Start');
        
    otherwise
        disp('Ramp not applied')
end
