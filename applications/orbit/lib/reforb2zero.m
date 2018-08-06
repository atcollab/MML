%=============================================================
function varargout=RefOrb2Zero(varargin)
%=============================================================
%load zeros into reference orbit and associated fields
bpm     =varargin{1};

for ii=1:2                      %horizontal and vertical
ntbpm=length(bpm(ii).name(:,ii));
bpm(ii).iref=(1:ntbpm)';        %indices for reference orbit
bpm(ii).ref =zeros(ntbpm,1);    %reference orbit values
bpm(ii).des=bpm(ii).ref;        %desired orbit values
bpm(ii).abs=bpm(ii).ref;        %used for plotting wrt reference orbit
end

varargout{1}=bpm;
