%horizontal and vertical response matrix at BPM locations
%by changing corrector strengths
sp3v81resp
%BPM locations
bpmfam = FINDCELLS(FAMLIST, 'FamName', 'BPM');
bpname=FAMLIST{bpmfam}.FamName;
ntbpm=FAMLIST{bpmfam}.NumKids;
disp(bpname);
disp(ntbpm);
BPMI=FAMLIST{bpmfam}.KidsList;

%corrector locations/number 2 in family list
CORiAT = findcells(THERING,'FamName','COR');
THERING = setcellstruct(THERING,'PassMethod',CORiAT,'StrMPoleSymplectic4Pass');
THERING = setcellstruct(THERING,'NumIntSteps',CORiAT,1);
THERING = setcellstruct(THERING,'MaxOrder',CORiAT,1);

corfam = FINDCELLS(FAMLIST, 'FamName', 'COR');
corname=FAMLIST{corfam}.FamName;
ntcor=FAMLIST{corfam}.NumKids;
disp(corname);
disp(ntcor);
CORI=FAMLIST{corfam}.KidsList;

%kick all correctors for data save 
cors=[1 3 4];   %...54 horizontal correctors in 1,3,4 slots
for kk=0:17 indx(3*kk+[1:3])=cors+kk*4; end
CORIX=CORI(indx);  

cors=[1 2 4];   %...54 horizontal correctors in 1,3,4 slots
for kk=0:17 indx(3*kk+[1:3])=cors+kk*4; end
CORIY=CORI(indx);

%HORIZONTAL
%kick, get orbit, return kick, get orbit
xmat=zeros(ntbpm,length(CORI));
for kk=1:length(CORI)
k=CORI(kk);
disp(['Kicking horizontal corrector number: ' num2str(kk)]);
disp(['Horizontal corrector index: ' num2str(k)]);
THERING{k}.PolynomB=0.001/THERING{k}.Length;
kick=THERING{k}.PolynomB*THERING{k}.Length;
disp(['Horizontal corrector kick: ' num2str(kick)]);
orbit=findorbit(THERING,0,BPMI);         %row vector (columns)
THERING{k}.PolynomB=0.0;                  %return kick
xmat(:,kk)=orbit(1,:)';                  %add new row each time
end
save xmat2 ntbpm BPMI ntcor CORI xmat;


%VERTICAL
%kick, get orbit, return kick, get orbit
ymat=zeros(ntbpm,length(CORI));
for kk=1:length(CORI)
k=CORI(kk);
disp(['Kicking vertical corrector number: ' num2str(kk)]);
disp(['Vertical corrector index: ' num2str(k)]);
THERING{k}.PolynomA=0.001/THERING{k}.Length;
kick=THERING{k}.PolynomA*THERING{k}.Length;
disp(['Vertical corrector kick: ' num2str(kick)]);
orbit=findorbit(THERING,0,BPMI);         %row vector (columns)
THERING{k}.PolynomA=0.0;                  %return kick
ymat(:,kk)=orbit(3,:)';                  %add new row each time
end
save ymat2 ntbpm BPMI ntcor CORI ymat;