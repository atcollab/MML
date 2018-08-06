
function X_energy_beat
% get spurious x fluctuation at BPM.NOD
% give rms value over all the buffer


temp=tango_read_attribute2('ANS-C13/DG/BPM.NOD','XPosDD');
X=temp.value;
figure(1); plot(X);xlabel('tour');xlim([1 length(X)]);ylabel('X mm');grid on
Xrms=std(X);
fprintf('X rms = %g  µm  avec Dispersion=21 cm  sur BPM.NOD \n',Xrms*1000)