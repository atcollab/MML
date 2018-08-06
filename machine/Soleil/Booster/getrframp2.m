function rampe = getrampRF2(varargin)
% GETRFRAMP2 - Reads RF ramp for Booster ring
%
%  See Also setrframp2

%
%  Written by Laurent S. Nadolski

DisplayFlag = 1;
devName = 'BOO/RF/RAMPETENSION'; % Device avec controle 1er point = dernier point

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

val = tango_read_attribute2(devName,'waveformData');
rampe = val.value;

if DisplayFlag
    figure
    plot(rampe*100)
    grid on
    ylabel('RF voltage (kV)');
    xlabel('Point number')
    title('RF ramp')
    addlabel(1,0,sprintf('%s', datestr(clock)));
end
