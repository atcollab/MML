% Scan the PT amplitude

% Change to CMOS with more BPM attn to get a big scan range on the PT


%% Setup
%  Gitches the gain and orbit data for some reason?

pt = [0:21 20:-1:0];
Dev = [1 2; 1 4; 1 5; 1 6];

% Turn PT correction on for secctor 1 test BPMs 1,3,4,5
% Note: [1 5] PT is driving all the BPMs here
% Change to CMOS with more BPM attn to get a big scan range on the PT
%setpv('BPMTest', 'Attn', 6, Dev);  % 9? for CMOS, 6 for 600mV 
%setpv('BPMTest', 'PTA', 4, [1 5]);  %  0->Off  1-> CMOS, 2->960mV, 3->780mV, 4->600mV, 5->400mV
%setpv('BPMTest', 'PTB', 4, [1 5]);
%setpv('BPMTest', 'PTAttn', pt(1), [1 5]);


%family2channel('BPMTest', 'PTAttn', Dev);  % PT Attn -> like 'SR01:CC:pt5Atten'
%family2channel('BPMTest', 'Attn', Dev);   % BPM Attn -> like SR01C:BPM1:attenuation

%% 

datestr(clock)

for j = 1:1
    % PT correction
    % 0-> off   3-> Dual  (SR01C:BPM1:autotrim:control)
    setpv('BPMTest', 'PTControl', 3, Dev);
    pause(2);
    for i = 1:length(pt)
        setpv('BPMTest', 'PTAttn', pt(i), [1 5]);
        pause(1);
    end
    
    % Run again with PT correction off
    setpv('BPMTest', 'PTControl', 0, Dev);
    pause(10);
    for i = 1:length(pt)
        setpv('BPMTest', 'PTAttn', pt(i), [1 5]);
        pause(1);
    end
        
end

setpv('BPMTest', 'PTControl', 3, Dev);

datestr(clock)


% Reset
% setpv('BPMTest', 'Attn', 6, Dev); 
% setpv('BPMTest', 'PTA', 2, [1 5]);  %  0->Off  1-> CMOS, 2->960mV
% setpv('BPMTest', 'PTB', 2, [1 5]);
% setpv('BPMTest', 'PTAttn', 0, [1 5]);



