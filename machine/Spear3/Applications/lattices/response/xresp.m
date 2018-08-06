%measure horizontal response matrix at QF locations
%by changing vertical field on dipole magnets

%half dipole locations
Bname=getfield(FAMLIST{28}.FamName);
Bnum=getfield(FAMLIST{28}.NumKids);
disp(Bname);
disp(Bnum);
Bloc=getfield(FAMLIST{28}.KidsList);

%full dipole locations
BBname=getfield(FAMLIST{27}.FamName);
BBnum=getfield(FAMLIST{27}.NumKids);
disp(BBname);
disp(BBnum);
BBloc=getfield(FAMLIST{27}.KidsList);

%merge lists, sort
ncx=Bnum+BBnum;
cxloc=sort([Bloc BBloc]);

%get QF locations to evaluate orbit
QFlist=[16,17,18,21,22];
Qloc=[];
QFloc=[];
nqffam=5;
nqf=0;
for kk=1:nqffam
k=QFlist(kk);
Qname=getfield(FAMLIST{k}.FamName);
Qnum=getfield(FAMLIST{k}.NumKids);
nqf=nqf+Qnum;
%disp(Qname);
%disp(Qnum);
Qloc=getfield(FAMLIST{k}.KidsList);
QFloc=[QFloc Qloc];
end
QFloc=sort(QFloc);

%kick, get orbit, return kick, get orbit
xmat=[];
spos=findspos(THERING,1:length(THERING));
disp(ncx);
for kk=1:ncx
k=cxloc(kk);
disp(kk);
THERING{k}=setfield(THERING{k},'ByError',0.001);    %set
getfield(THERING{k}.ByError);
orbit=findorbit(THERING,0,1:length(THERING));       %row vector (columns)
%size(orbit(1,QFloc));
%plot(spos,orbit(1,:));
%hold on;
%plot(spos(QFloc),orbit(1,QFloc),'x');

xmat=[xmat;orbit(1,QFloc)];                         %add new row each time
THERING{k}=setfield(THERING{k},'ByError',0.0);      %return
getfield(THERING{k}.ByError);
%hold on;
%orbit=findorbit(THERING,0,1:length(THERING));
%plot(spos,orbit(1,:));
end
xmat=xmat'   %xmat is now nbpm x ncor
save bymat nqf QFloc ncx cxloc xmat
