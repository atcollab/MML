function [X Z] = getbpmBN(varargin)
% GETBPMBN - get injection or extraction BPM in Booster normal mode
%   
%
%  INPUTS
%  1. Injection - Orbit at injection {Default}
%     Extraction - Orbit at extraction
%  2. Display - Displays orbit {Default}
%     NoDisplay
%
%  OUTPUTS
%  1. X - Horizontal orbit
%  2. Z - Vertical orbit
%
%

%
%  Written By Laurent S. Nadolski


InjectionFlag = 1;
DisplayFlag = 1;

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin2 = {varargin2{:} varargin{i}};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin2 = {varargin2{:} varargin{i}};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Injection')
        InjectionFlag = 1;
    elseif strcmpi(varargin{i},'Extraction')
        InjectionFlag = 0;
    end
end


if (InjectionFlag)
    Rep = tango_read_attribute2('BOO/DG/BPM-MANAGER','xInj');
    X = Rep.value;

    Rep = tango_read_attribute2('BOO/DG/BPM-MANAGER','zInj');
    Z = Rep.value;
    stitle=('Booster orbit at injection');
else
    Rep = tango_read_attribute2('BOO/DG/BPM-MANAGER','xExt');
    X = Rep.value;

    Rep = tango_read_attribute2('BOO/DG/BPM-MANAGER','zExt');
    Z = Rep.value;
    stitle=('Booster orbit at extraction');
end

if DisplayFlag
    figure(102);   
    posvect = getspos('BPMx');
    h1 = subplot(7,1,[1 3]);    
    plot(posvect, X,'r.-');
    grid on
    ylabel('X (mm)');
    axis([0 getcircumference -4 4]);
    title(stitle);

    h2 = subplot(7,1,4);
    drawlattice; hold on;
    set(h2,'XTick',[],'YTick',[]);
    
    h3 = subplot(7,1,[5 7]);
    plot(posvect, Z,'b.-');
    grid on       
    xlabel('s (mm)')
    ylabel('Z (mm)'); 

    % links axes
    linkaxes([h1 h2 h3],'x');  
    addlabel(1,0,datestr(clock));
        
end
