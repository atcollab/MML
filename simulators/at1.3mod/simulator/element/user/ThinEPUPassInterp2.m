function ZI = ThinEPUPassInterp2(X, Y, Z, XI, YI, method, varargin)

% ZI = INTERP2(X,Y,Z,XI,YI) interpolates to find ZI, the values of the


if isnan(XI)
    ZI = NaN;
    %fprintf('ThinEPUPassInterp2: XI input is NaN\n');
    return;
end
if isnan(YI)
    ZI = NaN;
    %fprintf('ThinEPUPassInterp2: YI input is NaN\n');
    return;
end
% if any(XI>max(max(X)))
%     ZI = NaN;
%     %fprintf('ThinEPUPassInterp2: XI (%f) is out of bound\n', XI);
%     return;
% end
% if any(YI>max(max(Y)))
%     ZI = NaN;
%     %fprintf('ThinEPUPassInterp2: YI (%f) is out of bound\n', YI);
%     return;
% end
% if any(XI<min(min(X)))
%     ZI = NaN;
%     %fprintf('ThinEPUPassInterp2: XI (%f) is out of bound\n', XI);
%     return;
% end
% if any(YI<min(min(Y)))
%     ZI = NaN;
%     %fprintf('ThinEPUPassInterp2: YI (%f) is out of bound\n', YI);
%     return;
% end

ZI = interp2(X, Y, Z, XI, YI, method);