clear all
spear3quadresp;
num=4;
bpmelem = FINDCELLS(FAMLIST, 'FamName', 'BPM');
bpind=FAMLIST{bpmelem}.KidsList(1);
v6= 0.001*[1 0 0 0 0 0];    %1.0 mm offset
THERING{num} = setfield(THERING{num},'T1',v6);
THERING{num} = setfield(THERING{num},'T2',-v6);
orbit=findorbit(THERING,0,1:length(THERING));         %row vector (columns)
%plot(orbit(1,1:10))
disp([THERING{num}.FamName ' ' num2str(orbit(1,bpind))]);

v6= 0.001*[0 0 0 0 0 0];    %1.0 mm offset
THERING{num} = setfield(THERING{num},'T1',v6);
THERING{num} = setfield(THERING{num},'T2',-v6);


