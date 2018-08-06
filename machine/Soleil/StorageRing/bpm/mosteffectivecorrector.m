function delcm = mosteffectivecorrector(varargin)
%MOSTEFFECTIVECORRECTOR - Correction using most effective corrector
%
%  INPUTS
%  1. plane of correction - 1 {Default} means Horizontal plane
%                           2 means vertical planes 
%
%  OUTPUTS
%  2. delcm - Corrector strengths from direct orbit correction
%
%  See Also setorbit

%
%  Written by Laurent S. Nadolski

BPMFamily = {'BPMx', 'BPMz'};
CMFamily  = {'HCOR', 'VCOR'};

DisplayFlag = 1;

% Input Parser
if isempty(varargin)
    plane = 1;
else
    plane = varargin{1}
    if plane > 1
        plane = 2;
    else
        plane = 1;
    end
end

%
Xgoal = getgolden(BPMFamily{plane});

%%
R0 = getbpmresp('Struct');

R = R0(plane,plane).Data;
HCORlist = R0(plane,plane).Actuator.DeviceList;

Rinv = pinv(R);

%%
X0 = getam(BPMFamily{plane});

X0std = std(X0);

delcm = -Rinv*(X0-Xgoal);

X = X0(:,ones(56,1));

% get index of most effective corrector and reduction factor
[val idx] = min(std(X+R*diag(delcm)));


if DisplayFlag
    figure(2001)
    subplot(2,1,1)
    bar(delcm)
    xlabel('Corrector number');
    ylabel('Corrector Strength [A]');
    title(sprintf('Most effective corrector using %s Family',CMFamily{plane}));
    subplot(2,1,2)
    plot(X0,'b'); hold on;
    theta = zeros(56,1);
    theta(idx) = delcm(idx);
    plot(X0+R*theta,'r'); hold off;
    xlabel('BPM number')
    ylabel(' Close orbit [mm]')
    legend('Before correction','Prediction')
end

CORlist =  R0(plane,plane).Actuator.DeviceList;
fprintf('Most effective corrector is HCOR [%d %d] (%f A): orbit reduction by %f mm rms\n', ...
    CORlist(idx,:), delcm(idx), X0std-val)

reply = input('Do you want to apply correction? Y/N [N]: ', 's');

switch reply
    case 'Y'
        stepsp(CMFamily{plane},delcm(idx), CORlist(idx,:));       
    otherwise
        return;
end


%%
