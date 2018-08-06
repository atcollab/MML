function settargetbucket(BucketNumber, SingleBunchFlag)
% How to target a single bucket

% To do;
%

if nargin < 1
    BucketNumber = 318;
end

if nargin < 2
    SingleBunchFlag = 1;
end


% ns
if SingleBunchFlag
    % Single gun bunch
    gunwidth = 12;
else
    % 4 gun bunches
    gunwidth = 36;
end


% Switching bucket loading from table mode to direct bucket control
%fprintf('Bucket loading is controlled directly by this program\n');
setpv('SR01C___TIMING_AC11', 0);
setpv('SR01C___TIMING_AC13', 0);

%fprintf('Filling bucket %d\n', BucketNumber);
setpv('SR01C___TIMING_AC08', BucketNumber);

if SingleBunchFlag
    %fprintf('Setting gun width to %d ns\n', gunwidth);
    setpv('GTL_____TIMING_AC02', gunwidth+1);  % ???
    pause(2);                                  % ???
    setpv('GTL_____TIMING_AC02', gunwidth);
else
end


%fprintf('Setting booster injection field trigger to %d for single bunch (delta = %d)\n',start_inj_trig+injtrigdelta,injtrigdelta);
%setpv('BR1_____TIMING_AC00',start_inj_trig+injtrigdelta);


