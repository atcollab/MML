function gen_bpm_noise()
% Generates bpm background noise. Files can be found in
% data/bpm_background_noise
%
% Notes:
% 
%

% grab data from all bpms
bpms = get_bpms(1,1);

fpath=which('path_bpm_background_noise');
fpath = fpath(1:end-27);

save([fpath,'bpm_noise','.mat'],'bpms');

% -- save time-stamped noise as well
fileID = fopen([fpath,'bpm_noise.txt'],'a');
fprintf(fileID,['bpm noise taken on ',datestr(clock,0),'\n']);
fclose(fileID);

display(['Saved under Data/bpm_background_noise/','bpm_noise']);



