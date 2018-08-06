function [x, ATindex, LostBeam] = linepass1turn(x0, Family0, DeviceList0, Family, DeviceList)
%LINEPASS1TURN - Track particle forward or backwards in one turn of the ring
%  [x, ATIndex] = linepass1turn(x0, Family, DeviceList)
%  [x, ATIndex] = linepass1turn(x0, ATIndex)
%
%  INPUTS
%  1. x0 - 6-component column vector {Default: [.001 0 .001 0 0]'}
%          Initial particle launch condition at the start of the ring (see ringpass)
%          AT units are meters & radians.
%  2. Location to measure turns: Family / DeviceList  {Default: 'BPMx'}
%                                  or
%                                ATIndex
%
%     NOTE: Family can be a MiddlyLayer family or AT family.
%           If using at AT family, then DeviceList is an index array (see family2atindex).   
%
%  OUTPUTS
%  1. x - Single turn data (6 x BPM Number)
%  2. ATIndex - AT index vector 
%
%  EXAMPLES
%  1. Get the starting coordinates for a kick at HCM[7 1]
%     x = linepass1turn([.001 0 .001 0 0 0]', HCM, [7 1], 1);
%
%  See also getturns
%
%  Note: this function is still under development!!!

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
    % 1 mm starting offset
    x0 = [.001 0, 0.001, 0, 0, 0]';
end

x0 = x0(:);
if size(x0,1) == 4
    x0 = [x0; 0; 0];
elseif size(x0,1) ~= 6
    error('x0 must be a 4x1 or 6x1 vector.');
end

if nargin < 2
    Family0 = [];
end
if isempty(Family0)
    Family0 = 'BPMx';
end
if nargin < 3
    DeviceList0 = [];
end

if nargin < 4
    Family = [];
end
if isempty(Family)
    Family = 'BPMx';
end
if nargin < 5
    DeviceList  = [];
end


% Get AT index
if ischar(Family0)
    ATindex0 = family2atindex(Family0, DeviceList0);
    % Watch for split magnets
    if size(ATindex0,2) > 1
        ATindex0 = ATindex0(:,1);
    end
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
else
    % AT index was input directly
    ATindex0 = Family0;
    ATindex = DeviceList0;
end

if any(size(ATindex0) ~= [1 1])
    error('DeviceList0 must be one location.');
end


ATindex = ATindex(:)';
if isempty(ATindex)
    error('AT index empty.');
end


% Propagrate single turn data around the ring
% xAllBPMs (6 x BPM Number)

% Find forward and backward BPMs
iForward  = find(ATindex >= ATindex0);
iBackward = find(ATindex < ATindex0);

x = [];
if ~isempty(iForward)
    Index = ATindex(iForward) - ATindex0 + 1;
    x = linepass(THERING([ATindex0:ATindex(iForward(end))]), x0, Index);
end

if ~isempty(iBackward)
    if x0(5)~=0 | x0(6)~=0
        fprintf('   WARNING: x0(5) & x0(6) must be zero for propagating backwards in the ring to work correctly.\n');
    end
    
    x0neg = x0;
    x0neg([2 4]) = -x0neg([2 4]);

    IndexBack = [ATindex(iBackward):ATindex0]-1;
    IndexBack(1) = [];
    
    %Index = ATindex0-IndexBack;
    ATIndexBack = ATindex(iBackward);
    Index = ATindex0 - ATIndexBack + 1;
    Index = Index(end:-1:1);

    xb = linepass(THERING(IndexBack(end:-1:1)), x0neg, Index);
    xb([2 4],:) = -xb([2 4],:);


    x = [xb(:,end:-1:1) x];
end

