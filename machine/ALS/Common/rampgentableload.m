%RAMPGENTABLELOAD - Load a ramp table to a mini-IOC
%  rampgentableload(Waveform, IOCName, Channel, Comment, egul, eguf)
%
%  Compile: Unix
%           >> mex rampgentableload.c
%
%           Windows aren't working (compile on a machine with visual C & changed errno to h_errno!)
%           >> mex -DWINDOWS rampgentableload.c
%
%  See also setboosterrampsd, setboosterramprf
