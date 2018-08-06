% This program is supposed to read the x position of the beam in the
% dispersion regions with different current values to get a measure of the
% real machine impedance.

%take data from the non-dispersive regions as well to find the effect of
%BPM current dependance.

clear bpm*position;
clear current;
clear combined*;

sector = [1:14]';

bpm1 = ones(14,1);
bpm2 = 2*ones(14,1);
bpm3 = 3*ones(14,1);
bpm4 = 4*ones(14,1);
bpm5 = 5*ones(14,1);
bpm6 = 6*ones(14,1);
bpm7 = 7*ones(14,1);

devlist1 = [sector bpm1];
devlist2 = [sector bpm2];
devlist3 = [sector bpm3];
devlist4 = [sector bpm4];
devlist5 = [sector bpm5];
devlist6 = [sector bpm6];
devlist7 = [sector bpm7];

for (n=1:100)
    bpm1position = getam('BPMx', [sector bpm1]);
    bpm2position = getam('BPMx', [sector bpm2]);
    bpm3position = getam('BPMx', [sector bpm3]);
    bpm4position = getam('BPMx', [sector bpm4]);
    bpm5position = getam('BPMx', [sector bpm5]);
    bpm6position = getam('BPMx', [sector bpm6]);
    bpm7position = getam('BPMx', [sector bpm7]);
    
    
    current(n) = getpv('SR11BCM01:CURRENT_MONITOR');
    
    combined1(:,n) = [ bpm1position ];
    combined2(:,n) = [ bpm2position ];
    combined3(:,n) = [ bpm3position ];
    combined4(:,n) = [ bpm4position ];
    combined5(:,n) = [ bpm5position ];
    combined6(:,n) = [ bpm6position ];
    combined7(:,n) = [ bpm7position ];
   %pause(0.1) 
end
subplot(4,2,1); plot(current(:),combined1(1:14,:))
subplot(4,2,2); plot(current(:),combined2(1:14,:))
subplot(4,2,3); plot(current(:),combined3(1:14,:))
subplot(4,2,4); plot(current(:),combined4(1:14,:))
subplot(4,2,5); plot(current(:),combined5(1:14,:))
subplot(4,2,6); plot(current(:),combined6(1:14,:))
subplot(4,2,7); plot(current(:),combined7(1:14,:))



