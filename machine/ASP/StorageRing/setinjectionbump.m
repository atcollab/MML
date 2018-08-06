function setinjectionbump(injoffset,varargin)
%
% SETINJECTIONBUMP(INJOFFSET,[angle]) will set the kickers to creates a local
% injection bump INJOFFSET mm from the beam axis. This uses the model to
% calculate the beam kicker response matrix in order to set the bumps. The
% angle is optional and defined in mradians.
%
% eg. setinjectionbump(-10)
%
% will set the injection bupm -10 mm from the beam axis.
%
% Requires that the Accelerator Objects be defined already by running the
% AOINIT file and also requires that the units be in physics units.

switch2physics;
switch2sim;
setradiation off; 
setcavity off;


bpm = getam('BPMx',elem2dev('BPMx',[1 8:91 98]),'Struct');
bpm.Data(:) = 0;
bpmfamily = 'BPMx';
bpmdevlist = elem2dev('BPMx',[1 8:91 98]);
% BPMWeight = [1; ones(size(bpm.DeviceList,1)-2,1)*1; 1];
% Select "correctors".
cmfamily = 'KICK';
cmdevlist = getfamilydata('KICK','DeviceList');
cm = getsp('KICK','Struct','Online');
cm.Data(:) = 0;
Niter = 1;
SVDIndex = 'All';

% Calculate the offsets necessary at each bpm given the offset and angle
% input by the user.
if nargin > 1
    inangle = varargin{1};
else
    inangle = 0;
end

% Distance between the BPMs in the in the injection straight.
L = 2.3041;
injoffset_bpm01 = injoffset*1e-3 + L*sin(inangle*1e-3)
injoffset_bpm98 = injoffset*1e-3 - L*sin(inangle*1e-3)

% if abs(injoffset) >= 10
%     % Take in two steps
%     goalorbit = [injoffset_bpm01; zeros(83,1); injoffset_bpm98];
%     goalorbit = [injoffset_bpm01; zeros(size(bpm.DeviceList,1)-2,1); injoffset_bpm98];
%     cc = setorbit(goalorbit, bpmfamily, bpmdevlist, cmfamily, cmdevlist, Niter, SVDIndex, 'ModelResp','ModelDisp','NoSetSP');
% else
    % Define goal orbit
    goalorbit = [injoffset_bpm01; zeros(size(bpm.DeviceList,1)-2,1); injoffset_bpm98];
    cc = setorbit(goalorbit, bpm, cm, Niter, SVDIndex, 'ModelResp','ModelDisp','SetSP','Model');
%     setsp(physics2hw(cc.CM),'Model');
% end

% switch2online
