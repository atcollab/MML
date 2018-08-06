function hcm2zero(varargin)
%HCM2ZERO - Set horizontal corrector strengths to zero
%  hcm2zero(fraction, nstep)
%
%  INPUTS
%  1. fract - fraction of corrector strength to put to zero
%            {1} means correctors set to zero
%             0.5 means half of the corrector strength set to zero
%  2. nstep - number of step for zeroing correctors {Default: 5}
%  3. Optional - 'Interactive' Wait for user for each step {Default}
%                'NoInteractive' pause 0.2 s for each step     
%
%  See also vcm2zero, vcm2golden, hcm2golden

%  Written by Greg Portmann
%  Adapted by Laurent S. Nadolski

InteractiveFlag = 1;

% Input Parser
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Interactive')
        InteractiveFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoInteractive')
        InteractiveFlag = 0;
        varargin(i) = [];
    end
end
        
HCORFamily = gethcmfamily;

if length(varargin) < 1
    fract = 1;
else
    fract = varargin{1};
end

if length(varargin) < 2
    nstep = 5;
else
    nstep = varargin{2};
end


setpt = fract * getsp(HCORFamily);

for k = 1:nstep,
    setsp(HCORFamily, (1-k/nstep)*setpt, [], -1);    
    if InteractiveFlag
        disp(['   Step ' num2str(k) ' of ' num2str(nstep) ' Hit Return key to continue (Ctrl-C to stop)']);
        pause;
    else
        pause(0.2)
    end
end
