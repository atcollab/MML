function mcadebug(onoff)
%MCADEBUG     - Enable/disable debugging
%
% Used only for development, not user-callable.
if onoff
    mca(9999, 1);
else
    mca(9999);
end

