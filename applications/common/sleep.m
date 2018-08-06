function sleep(Delay)
%SLEEP - Same as pause
% sleep(Delay [sec])
%
% Written by Greg Portmann


if Delay > 0 && ~isempty(Delay)
    pause(Delay);
end