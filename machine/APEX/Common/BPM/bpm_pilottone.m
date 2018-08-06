
% Pilot tone setup
Setup.PT.State = 1;           % Pilot tone on (1) or off (0)
Setup.PT.Attn = 80;          % 0 to 127
%Setup.PT.FrequencyCode = '-1/2';
Setup.PT.FrequencyCode = '0.0';
%Setup.PT.FrequencyCode = '+1/2';
setpilottone(Setup.PT);

% Set pilot tone magnitude (attenuator for NSLS2 PT)
tcp_write_reg(34, Setup.PT.Attn);

