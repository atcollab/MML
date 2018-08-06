function [q]=thetune(dp)
global THERING;
RING = THERING;
L = length(RING);
spos = findspos(RING,1:L+1);
[TD, tune] = twissring(RING,dp,1:(length(RING)+1));
q = tune;
