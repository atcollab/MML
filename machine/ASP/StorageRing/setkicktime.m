% 
% k1 = mcaopen('SR00PDG01:CHANNEL_A_SP');
% k2 = mcaopen('SR00PDG01:CHANNEL_B_SP');
% k3 = mcaopen('SR00PDG01:CHANNEL_C_SP');
% k4 = mcaopen('SR00PDG01:CHANNEL_D_SP');


delta_t = 0.60114519 + 0.4e-6;       %   - 0.6e-6;0.601145790
fprintf('%20.8g\n',delta_t);

mcaput(k1,delta_t);
mcaput(k2,delta_t);
mcaput(k3,delta_t);
mcaput(k4,delta_t);


% mcaclose(k1);
% mcaclose(k2);
% mcaclose(k3);
% mcaclose(k4);
% 
