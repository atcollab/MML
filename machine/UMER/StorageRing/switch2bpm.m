function switch2bpm(bpm_number)
% Selects a bpm on the cytec multiplexor board
%
% INPUT:
%   bpm_number - the number of the bpm being selected. e.g. 4 for bpm 4
%
%
% Written October 2017
% By Levon

ad = getad;
if ~ad.simFlag
    cytec_mux_controller(num2str(bpm_number));
end


end