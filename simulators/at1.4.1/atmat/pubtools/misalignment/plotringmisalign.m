function varargout = plotringmisalign(varargin)
% PLOTRINGMISALIGN(['-thering']) will scan THERING and plot the misalignments that have
% been distributed around the ring (transverse only).
%

global THERING

if ~exist('THERING','var')
    disp('Please load the model first');
    return
end

mis = getappdata(0,'MisalignData');

if isempty(mis) | (nargin > 0 & strcmpi(varargin{1},'-thering'))
    disp('Determining misalignment directly from THERING');
    % get the SPos data
    TD3 = twissring(THERING,0,1:length(THERING)+1);
    S3 = cat(2,TD3.SPos);

    T = zeros(2,length(THERING)+1);
    for i=1:length(THERING)
        if isfield(THERING{i},'T2')
            T(:,i) = THERING{i}.T2([1 3]);
        end
    end
    T(:,end) = T(:,1);
else
    S3 = mis.applied(mis.currseed).spos;
    T = cat(1,mis.applied(mis.currseed).deltax,mis.applied(mis.currseed).deltay);
end

figure; 
subplot(2,2,1);
plot(S3,T(1,:)); 
title('Horizontal Misalignment');
if std(T(1,:)) > 0; axis([0 216 min(T(1,:))*1.1 max(T(1,:))*1.1]); end;
subplot(2,2,2);
plot(S3,T(2,:)); 
title('Vertical Misalignment');
if std(T(2,:)) > 0; axis([0 216 min(T(2,:))*1.1 max(T(2,:))*1.1]); end;
plotelementsat
subplot(2,2,3);
hist(T(1,find(T(1,:) ~= 0)));
title('Historgram (horizontal)');
subplot(2,2,4);
hist(T(2,find(T(2,:) ~= 0)));
title('Historgram (vertical)');
