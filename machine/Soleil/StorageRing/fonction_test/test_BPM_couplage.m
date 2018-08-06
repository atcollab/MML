%% ceci est sauvagement copié de nombre d'onde Booster !!!

Xval(1:nbpoints) = handles.X(istart:iend);
Xfft     = fft(Xval,nbpoints);
PXfft    = Xfft.* conj(Xfft) / nbpoints;
PXfft([1 2 nbpoints]) = 0; %% ???
% skip points ????
n1 = int16(nbpoints/20)
n2 = int16(nbpoints-n1)
%%
frev = 1.91414; % MHz

mx    = max(PXfft(n1:n2));
nux   = (find(PXfft==max(PXfft(n1:n2)))-1)/ nbpoints;
fnux  = (1-nux)*frev;
f352x = (nux)*frev + 352.183; % Frf
f = (1:nbpoints)/nbpoints;
hplot1 = plot(handles.Onde_X,f,PXfft(1:(nbpoints)));