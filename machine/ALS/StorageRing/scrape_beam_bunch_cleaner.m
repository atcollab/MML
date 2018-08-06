function scrape_beam_bunch_cleaner

% This function scrapes out the storage ring beam to a inputted level (0mA is default)
% 
% The vertical machine tune must be correct (very close to 0.25)
%
% 7-11-2016, T.Scarvie

% initialize X bunch cleaner
setpv('IGPF:TFBX:CLEAN:TUNE', 0.75);
setpv('IGPF:TFBX:CLEAN:SPAN', 0.02);
setpv('IGPF:TFBX:CLEAN:PERIOD', 23000.0);
setpv('IGPF:TFBX:CLEAN:PERIOD', 23000.0);
setpvonline('IGPF:TFBX:CLEAN:PATTERN', '!');

for amp = 0.4:.01:1;
    setpv('IGPF:TFBX:CLEAN:AMPL',amp);
    while getpv('SR05S___DCCTDI_AM00')<0.1
        
