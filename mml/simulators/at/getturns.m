function [xAllBPMs, ATindex, LostBeam] = getturns(x0, N, Family, DeviceList)
%GETTURNS - Single particle tracking for multiple turns
%
%  [x, ATIndex, LostBeam] = getturns(x0, N, Family, DeviceList)
%  [x, ATIndex, LostBeam] = getturns(x0, N, ATIndex)
%
%  INPUTS
%  1. x0 - 6-component column vector
%          Initial particle launch condition at the start of the ring (see ringpass)
%          AT units are meters & radians. {Default: getpvmodel('LaunchVector')}
%  2. N - Number of turns {Default: 1024}
%  3. Location to measure turns: Family / DeviceList  {Default: gethbpmfamily}
%                                  or
%                                ATIndex
%
%     NOTE: Family can be a MiddlyLayer family or AT family.
%           If using at AT family, then DeviceList is an index array (see family2atindex).   
%
%  OUTPUTS
%  1. x - Multiple turn data (BPM Number x N turns x 6)
%     Note: 1. The initial condition is included in the first turn.
%           2. Use squeeze to reduce dimensions.  Matlab automatically squeezes the last
%              dimension, ie, x(:,:,BPMnumber) will be a 2-dim matrix if BPMnumber is a scalar.
%  2. ATIndex - AT index vector 
%  3. LostBeam - 1 if particle is lost, else 0 
%
%  EXAMPLES
%  1. Get 1024 turns at BPMx(1,2) and BPMx(1,4) and plot the horizontal position FFT for BPMx(1,2)
%     [x, ATIndex, LostBeam] = getturns([.001 0, 0.001, 0, 0, 0]', 1024, 'BPMx', [1 2;1 4]);
%     multiturnfft(x(1,:,1));
%  2. Get 1024 turns at AT-index 1,2,10
%     [x, ATIndex, LostBeam] = getturns([.001 0, 0.001, 0, 0, 0]', 1024, [1 2 10]);
%  3. Get first turn at all AT indices
%     [x, ATIndex, LostBeam] = getturns([.001 0, 0.001, 0, 0, 0]', 1, 'All');
%
%  See also multiturnfft, linepass

%  Written by Greg Portmann


global THERING
if isempty(THERING)
    error('THERING is not defined.');
end


% AT units meters & radians
if nargin < 1
    x0 = [];
end
if isempty(x0)
    x0 = getpvmodel('LaunchVector');
    if isempty(x0)
        % 1 mm starting offset
        x0 = [0 0 0 0 0 0]';
    end
end

x0 = x0(:);
if size(x0,1) ~= 6
    error('x0 must be a 6x1 vector.');
end

if nargin < 2
    N = [];
end
if isempty(N)
    N = 1024;
end

if nargin < 3
    Family = [];
end
if isempty(Family)
    Family = gethbpmfamily;
end

if nargin < 4
    DeviceList = [];
end


% Get AT index
if ischar(Family)
    ATindex = family2atindex(Family, DeviceList);
    % Watch for split magnets
    if size(ATindex,2) > 1
        ATindex = ATindex(:,1);
    end
else
    % AT index was input directly
    ATindex = Family;
end
ATindex = ATindex(:)';
if isempty(ATindex)
    error('AT index empty.');
end

% Get single turn data
if N == 1
    x = x0;
    LostBeam = 0;
else
    [x, LostBeam] = ringpass(THERING, x0, N-1);  % 'reuse' seems to cause errors
    x = [x0 x];
    if LostBeam
        fprintf('   Beam was lost\n');
        xAllBPMs = [];
        return
    end
end


% Propagate single turn data around the ring
for iturn = 1:size(x,2)
    % if iturn == 1
    % xAllBPMs (BPM Number x N turns x 6)
    [xAllBPMs(:,iturn,:)] = linepass(THERING, x(:,iturn), ATindex)';
    
    % xAllBPMs (6 x N turns x BPM Number)
    %[xAllBPMs(:,iturn,:)] = linepass(THERING, x(:,iturn), ATindex);
    % else
    % [xAllBPMs(:,iturn,:)] = linepass(THERING, x(:,iturn), ATindex, 'reuse');
    % end
end





