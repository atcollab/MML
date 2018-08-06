function bpms = load_bpm_noise()
% loads bpm background noise and returns the list of bpms
%
% Notes:
% 
%

fpath=which('path_bpm_background_noise');
fpath = fpath(1:end-27);
load([fpath,'bpm_noise','.mat'],'bpms');





