%buckets=[1:16 281:296]

fprintf('Bucket loading is controlled directly by this program\n');
setpv('SR01C___TIMING_AC11',0);
setpv('SR01C___TIMING_AC13',0);

while 1
    for buckets=[1:1:16 281:1:296]
        setpv('SR01C___TIMING_AC08', buckets)
        fprintf('SR01C___TIMING_AC08 = %i\n', buckets)
        pause(1.4)
    end
end
