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
%merge dipole lists, sort
ndipole=FAMLIST{b34elem}.NumKids+FAMLIST{bndelem}.NumKids;
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



numfam=length(FAMLIST);
fprintf('Number of families: %g\n',numfam);
for ii=1:numfam;
%fnames{ii,:)=char(FAMLIST{ii}.FamName);
[fnames{ii}] = DEAL(FAMLIST{ii}.FamName);
fprintf('%d %s\n',ii, char(fnames(ii)));
end

fnames=char(fnames);
for ii=1:numfam
  if strcmp(fnames(ii,:),'AP  ')==1 apelem=ii;   end
  if strcmp(fnames(ii,:),'CORR')==1 corelem=ii;  end
  if strcmp(fnames(ii,:),'BPM ')==1 bpmelem=ii;  end
  if strcmp(fnames(ii,:),'DC1 ')==1 dc1elem=ii;  end
  if strcmp(fnames(ii,:),'DC2 ')==1 dc2elem=ii;  end
  if strcmp(fnames(ii,:),'DC3 ')==1 dc3elem=ii;  end
  if strcmp(fnames(ii,:),'DC4 ')==1 dc4elem=ii;  end
  if strcmp(fnames(ii,:),'DC5 ')==1 dc5elem=ii;  end
  if strcmp(fnames(ii,:),'DC6 ')==1 dc6elem=ii;  end
  if strcmp(fnames(ii,:),'DM1 ')==1 dm1elem=ii;  end
  if strcmp(fnames(ii,:),'DM2 ')==1 dm2elem=ii;  end
  if strcmp(fnames(ii,:),'DM3 ')==1 dm3elem=ii;  end
  if strcmp(fnames(ii,:),'DM4 ')==1 dm4elem=ii;  end
  if strcmp(fnames(ii,:),'DM5 ')==1 dm5elem=ii;  end
  if strcmp(fnames(ii,:),'DM6 ')==1 dm6elem=ii;  end
  if strcmp(fnames(ii,:),'DM7 ')==1 dm7elem=ii;  end
  if strcmp(fnames(ii,:),'DM8 ')==1 dm8elem=ii;  end
  if strcmp(fnames(ii,:),'DM9 ')==1 dm9elem=ii;  end
  if strcmp(fnames(ii,:),'DM10')==1 dm10elem=ii; end
  if strcmp(fnames(ii,:),'QF  ')==1 qfelem=ii;   end
  if strcmp(fnames(ii,:),'QD  ')==1 qdelem=ii;   end
  if strcmp(fnames(ii,:),'QFC ')==1 qfcelem=ii;  end
  if strcmp(fnames(ii,:),'QDX ')==1 qdxelem=ii;  end
  if strcmp(fnames(ii,:),'QFX ')==1 qfxelem=ii;  end
  if strcmp(fnames(ii,:),'QDY ')==1 qdyelem=ii;  end
  if strcmp(fnames(ii,:),'QFY ')==1 qfyelem=ii;  end
  if strcmp(fnames(ii,:),'QDZ ')==1 qdzelem=ii;  end
  if strcmp(fnames(ii,:),'SF  ')==1 sfelem=ii;   end
  if strcmp(fnames(ii,:),'SD  ')==1 sdelem=ii;   end
  if strcmp(fnames(ii,:),'SFI ')==1 sfielem=ii;  end
  if strcmp(fnames(ii,:),'SDI ')==1 sdielem=ii;  end
  if strcmp(fnames(ii,:),'BND ')==1 bndelem=ii;  end
  if strcmp(fnames(ii,:),'B34 ')==1 b34elem=ii;  end
end
