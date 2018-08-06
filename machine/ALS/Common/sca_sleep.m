function sca_sleep(Delay)
% sca_sleep(Delay [sec])
% Returns after Delay seconds (uses Matlab pause with the 
% exception that negative delays and [] are ignored).

% Written by Greg Portmann


if Delay > 0 & ~isempty(Delay)
    pause(Delay);
end