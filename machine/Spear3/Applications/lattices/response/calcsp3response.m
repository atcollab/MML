%calcsp3response
%horizontal and vertical corrector response matrix at BPM locations
%05/08/02 switch to sp3v81cor with corrector method COR =  corrector('COR',0.2,[0 0],'CorrectorPass');
sp3v81cor
THERING=sext_off(THERING);   %turn off sextupoles

%BPM locations
bpmfam = FINDCELLS(FAMLIST, 'FamName', 'BPM');
bpname=getfield(FAMLIST{bpmfam},'FamName');
ntbpm=getfield(FAMLIST{bpmfam},'NumKids');
disp(bpname)
disp(ntbpm)
bpmindx=getfield(FAMLIST{bpmfam},'KidsList')

%corrector locations
corfam = FINDCELLS(FAMLIST, 'FamName', 'COR');
corname=getfield(FAMLIST{corfam},'FamName');
ntcor=getfield(FAMLIST{corfam},'NumKids');
disp(corname)
disp(ntcor)
corindx=getfield(FAMLIST{corfam},'KidsList')

%COR  =	quadrupole('COR' ,0.20,0.0,'QuadLinearPass');
%change passmethod - add first order multipole field if corrector is a quadrupole
% THERING = setcellstruct(THERING,'PassMethod',corindx,'StrMPoleSymplectic4Pass');
% THERING = setcellstruct(THERING,'NumIntSteps',corindx,1);
% THERING = setcellstruct(THERING,'MaxOrder',corindx,1);

%HORIZONTAL
%kick, get orbit, return kick, get orbit
xmat=[];
for kk=1:ntcor
k=corindx(kk);
disp([num2str(kk),'    ',num2str(k)]);

Kick = THERING{k}.KickAngle;
Kick = [0.001 Kick(2)];
THERING{k}.KickAngle = Kick;

   % len=getcellstruct(THERING,'Length',k);
   % poly=1.0/(1000*len);              %...angle=PolynomA/B(1)*length
   % THERING=setcellstruct(THERING,'PolynomB',k,poly,1); %indx=correctors, amps=set, 1= order
orbit=findorbit(THERING,0,1:length(THERING))*1000;    %convert to mm
xmat=[xmat;orbit(1,bpmindx)];                         %add new row each time
   %THERING=setcellstruct(THERING,'PolynomB',k,0,1);
THERING{k}.KickAngle = [0.0 0.0];
end
xmat=xmat' ;  %xmat is now nbpm x ncor
save xmat2 ntbpm bpmindx ntcor corindx xmat;


%VERTICAL
%kick, get orbit, return kick, get orbit
ymat=[];
for kk=1:ntcor
k=corindx(kk);
disp([num2str(kk),'    ',num2str(k)]);

Kick = THERING{k}.KickAngle;
Kick = [Kick(1) 0.001];
THERING{k}.KickAngle = Kick;

    % len=getcellstruct(THERING,'Length',k);
    % poly=1.0/(1000*len);              %...angle=PolynomA/B(1)*length
    % THERING=setcellstruct(THERING,'PolynomA',k,poly,1); %indx=correctors, amps=set, 1= order
orbit=findorbit(THERING,0,1:length(THERING))*1000;    %convert to mm
ymat=[ymat;orbit(3,bpmindx)];                         %add new row each time
    %THERING=setcellstruct(THERING,'PolynomA',k,0,1);
THERING{k}.KickAngle = [0.0 0.0];

end
ymat=ymat' ;  %ymat is now nbpm x ncor
save ymat2 ntbpm bpmindx ntcor corindx ymat;
