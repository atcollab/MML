function orbitgui(varargin)
    warning('orbitgui is deprecated. Please use setorbitgui instead.\nIf you really want to use orbitgui, run orbitgui(1)', '');
    if nargin
        run('/asp/usr/middleLayer/applications/orbit/asp/orbitgui.m');
    end
end