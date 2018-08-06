function WF = bunchcleanerwaveform(Offset)

if nargin < 1
    Offset = 0;
end

% Golden waveform
WF = [(1:328)' [-1*ones(328/2,1); 1*ones(328/2,1)]];

%WF = [(1:328)' (1:328)'];

Offset = rem(Offset,328);

if Offset < 0
    WF(:,2) = [WF(Offset+1:328,2); WF(1:Offset,2)];
elseif Offset > 0
    Offset = abs(Offset);
    WF(:,2) = [WF(328-Offset:328,2); WF(1:328-Offset-1,2)];
end



