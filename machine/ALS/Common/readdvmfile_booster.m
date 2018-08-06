function data = readdvmfile_booster(FileName)

fid = fopen(FileName, 'r');
data.TimeStep = fscanf(fid, '%f', 1);
data.Line2    = fscanf(fid, '%f', 1);
data.Data     = fscanf(fid, '%f %f %f', [3 inf])';
fclose(fid);

