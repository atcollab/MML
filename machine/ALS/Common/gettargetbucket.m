function [TargetBucket, NumberGunBunches, Ts, TargetBucketPV] = gettargetbucket

if getpv('SR01C___TIMING_AC11') == 0 && getpv('SR01C___TIMING_AC13') == 0
    % Manual mode
    TargetBucketPV = 'SR01C___TIMING_AM08';
else
    % Table mode
    TargetBucketPV = 'SR01C___TIMING_AM14';
end

[TargetBucket, ~, Ts] = getpv(TargetBucketPV);

GunWidth = getpv('GTL_____TIMING_AC02');
if GunWidth == 12
    NumberGunBunches = 1;
elseif GunWidth == 20
    NumberGunBunches = 2;
elseif GunWidth == 28
    NumberGunBunches = 3;
elseif GunWidth == 36
    NumberGunBunches = 4;
else
    NumberGunBunches = [];
end
