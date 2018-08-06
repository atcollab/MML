function makeramptable(Data, FileName)

if nargin < 1
    Data = [linspace(0,5,100) linspace(5,0,100)];
end

if nargin < 2
    FileName = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_current/RampTableQD.txt';
end


Period = 1.5;
Gain = 10;
Offset = 5;


fid = fopen(FileName,'w');
if fid == -1
    fprintf('   File open error.\n');
    return;
end


fprintf(fid, '%f\n', 1/Period);
fprintf(fid, '%f\n', Gain);
fprintf(fid, '%f\n', Offset);


for i = 1:length(Data)
    Val(i) = 2*2047*(Data(i) - Offset)/Gain;
end

if any(Val>2047)
    error('Over the maximum bit limit');
end
if any(Val<-2047)
    error('Under the maximum bit limit');
end

for i = 1:length(Data)
    fprintf(fid, '%.0f\n', Val(i));
end

fclose(fid);
