function monAbpm(family,bpm)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/monAbpm.m 1.2 2007/03/02 09:03:25CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% monAbpm(family,bpm)
%   FAMILY: BPMx or BPMy
%   BPM:    1 thru 48
% ----------------------------------------------------------------------------------------------

fprintf('Acquiring data for %s bpm # %d\n',family,bpm);
total = 0;
data = (1:180);
sum = 0;

for i=1:180
    x=getam(family);
    data(i) = x(bpm);
    sum = sum + data(i);
    total = total + (data(i) * data(i));
    pause(0.5);
end

fprintf('Acquiring COMPLETE for %s bpm # %d\n',family,bpm);
figure;plot(data);
stDev=std(data);
xlabel(sprintf('sd = %20.20f',stDev));

    
% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/monAbpm.m  $
% Revision 1.2 2007/03/02 09:03:25CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------

