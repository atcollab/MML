function rampe = getrampRF(varargin)
% GETRFRAMP - Reads RF ramp for Booster ring
%
%  See Also setrframp

%
%  Written by Laurent S. Nadolski

DisplayFlag = 1;
devName = 'BOO/RF/SAO.1';

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoArchive')
        ArchiveFlag = O;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Archive')
        ArchiveFlag = 1;
        varargin(i) = [];
    end
end

val = tango_get_properties2(devName,{'Channel0WaveForm'});
rampe = str2double(val.value);

if DisplayFlag
    figure
    plot(rampe*100)
    grid on
    ylabel('RF voltage (kV)');
    xlabel('Point number')
    title('RF ramp')
    addlabel(1,0,sprintf('%s', datestr(clock)));
end
