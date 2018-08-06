function [bpmObject,ErrorFlag] = get_bpm(bpmIndex, turns, NoiseFlag)
% Takes a measurement with a bpm
%
% EXAMPLE:
%   bpm = get_bpm(4,1) - grab 4 turns of data at RC1
%
% INPUT
%   1. bpmIndex - the index of the bpm to measure
%   2. turns - number of turns to measure
%   3. NoiseFlag - flag to subtract out bpm noise (true,1) or not (false,0)
%       default: - 1
%
% OUTPUT
%   1. bpmObject - a structure object containing the following fields
%       bpm - a string of the bpm name
%       X - 1xturns array of x position measurements
%       Y - 1xturns array of y position measurements
%       Xe - 1xturns array of errors in x position measurements
%       Ye - 1xturns array of errors in y position measurements
%       top - 1xturns array of top signal measurement
%       bottom - 1xturns array of bottom signal measurements
%       left - 1xturns array of the left signal measurements
%       right - 1xturns array of right signal measurements
%       sum - 1xturns array of the sum signal measurements
%       scope_data - the full trace from the scope in Mx5 array
%       scope_data_noise - noise trace if requested | optional
%
%   2. ErrorFlag - 1 means error occured. 0 means no errors
%
% Notes:
% Here is a list of all bpm Indexes: [0,1,2,3,5,6,7,8,9,11,12,13,14,15,17]
%                                   IC2,RC1,RC2,...                ..,RC17
%
if nargin < 3
    NoiseFlag = 1;
end

ErrorFlag = 0;

% Grab information from the accelerator object
% if you want to change these do so in 'setoperationmode', not here.
ad = getad; % accelerator object

%simFlag = ad.simFlag;
%if ~simFlag
%    scope = ad.scope; % scope object
%end

rev_time = ad.rev_time; % rev time
scope_vars = ad.scope_var;
t_o = scope_vars(1); %center index
t_oo = scope_vars(2); % center index
window = scope_vars(3); % window of center index
[mx,bx,my,by] = get_bpmcalibration(bpmIndex); % bpm calibration settings

% allocation memory
base_index = zeros(turns,1); % base line signal
center_index = base_index; % center of signal
start_index = base_index; % beginning of center
end_index = base_index; % ending of center

top = base_index;
bottom = base_index;
left = base_index;
right = base_index;
sum = base_index;

x = base_index;
y = base_index;
xe = base_index;
ye = base_index;

% grab data from scope
try
    if ~simFlag
        scope_data = get_scope(bpmIndex,scope);
    else
        scope_data = rand(1000,6);
        %pause(0.1); % simulate time to grab data
    end
    if 0%NoiseFlag - off for now, fix later to work with mml
        bpms = load_bpm_noise();
        BPMS_index = [0,1,2,3,5,6,7,8,9,11,12,13,14,15,17];
        scope_data_noise = bpms{BPMS_index==bpmIndex}.scope_data;
        scope_data(:,2:end) = scope_data(:,2:end) - scope_data_noise(:,2:end);
    end
catch
    ErrorFlag = 1;
    bpmObject = [];
    return
end


%Window has a 20ns length, for a sampling rate of 1ns/pt
% Note that becasue the actual period is 197.39 there will a drif in the
% center of the pulse for large turn_number
% n = 1 is the first time through
%window=40;  %not 40ns nnot 2

% calculate variables from scope_data
for i = 1:turns
    % get scope_data info
    base_index(i)=(t_oo-100) + round((i-1)*rev_time) + (bpmIndex-1)*11;
    center_index(i)=t_o + round((i-1)*rev_time) + (bpmIndex-1)*11;
    start_index(i)=center_index(i)-window/2;
    end_index(i)=center_index(i)+window/2;
    
    % calculate bpm button info
    if ~simFlag
        top(i)=mean(scope_data(start_index(i):end_index(i),2))-mean(scope_data(base_index(i)-window/2:base_index(i)+window/2,2));
        bottom(i)=mean(scope_data(start_index(i):end_index(i),3))-mean(scope_data(base_index(i)-window/2:base_index(i)+window/2,3));
        left(i)=mean(scope_data(start_index(i):end_index(i),4))-mean(scope_data(base_index(i)-window/2:base_index(i)+window/2,4));
        right(i)=mean(scope_data(start_index(i):end_index(i),5))-mean(scope_data(base_index(i)-window/2:base_index(i)+window/2,5));
        sum(i) = top(i)+bottom(i)+left(i)+right(i);
    else
        top(i) = rand;
        bottom(i) = rand;
        left(i) = rand;
        right(i) = rand;
        sum(i) = rand;
    end
    
    % calculate bpm button errors due to averaging above
    N = length(scope_data(start_index(i):end_index(i),2));
    top_error = std(scope_data(start_index(i):end_index(i),2))/sqrt(N);
    bottom_error = std(scope_data(start_index(i):end_index(i),3))/sqrt(N);
    left_error = std(scope_data(start_index(i):end_index(i),4))/sqrt(N);
    right_error = std(scope_data(start_index(i):end_index(i),5))/sqrt(N);
    
    % calculate bpm positions in x and y
    x(i) = (right(i)-left(i))/(left(i)+right(i))*mx + bx;
    y(i) = (top(i)-bottom(i))/(top(i)+bottom(i))*my + by;
    
    % calculate uncertainties in the positions due to averaging in the buttons
    den = sqrt(top_error^2 + bottom_error^2 + left_error^2 + right_error^2);
    numx = sqrt(right_error^2 + left_error^2);
    numy = sqrt(bottom_error^2 + top_error^2);
    xe(i) = abs(x(i))*sqrt((numx/(right(i)-left(i)))^2 +(den/(left(i)+right(i)))^2 );
    ye(i) = abs(y(i))*sqrt((numy/(bottom(i)-top(i)))^2 +(den/(top(i)+bottom(i)))^2 );
end

% create bpm object
if bpmIndex == 0
    name = 'IC2';
else
    name = ['RC',num2str(bpmIndex)];
end
bpmObject.name = name;
bpmObject.X = x;
bpmObject.Y = y;
bpmObject.Xe = xe;
bpmObject.Ye = ye;
bpmObject.top = top;
bpmObject.bottom = bottom;
bpmObject.left = left;
bpmObject.right = right;
bpmObject.sum = sum;
bpmObject.scope_data = scope_data;
if NoiseFlag
    bpmObject.scope_data_noise = scope_data_noise;
end

end
