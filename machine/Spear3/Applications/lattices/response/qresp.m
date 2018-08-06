%compute horizontal and vertical quadrupole response matrix
%at BPM locations by quadrupole alignments and dipole alignments
%note that horizontal dipole alignment accomplished by changing ByError
% (see BendLinearOffsetPass)
%response matrices are stored by groups of families (QF, QD,... BEND, B34)
%data is stored in qxmat.mat, qymat.mat
spear3quadresp;   %BendLinearOffsetPass for dipoles
fprintf('Number of families: %g\n',length(FAMLIST));


apelem  = FINDCELLS(FAMLIST, 'FamName', 'AP');
corelem = FINDCELLS(FAMLIST, 'FamName', 'CORR');
bpmelem = FINDCELLS(FAMLIST, 'FamName', 'BPM');
dc1elem = FINDCELLS(FAMLIST, 'FamName', 'DC1');
dc2elem = FINDCELLS(FAMLIST, 'FamName', 'DC2');
dc3elem = FINDCELLS(FAMLIST, 'FamName', 'DC3');
dc4elem = FINDCELLS(FAMLIST, 'FamName', 'DC4');
dc5elem = FINDCELLS(FAMLIST, 'FamName', 'DC5');
dc6elem = FINDCELLS(FAMLIST, 'FamName', 'DC6');
dm1elem = FINDCELLS(FAMLIST, 'FamName', 'DM1');
dm2elem = FINDCELLS(FAMLIST, 'FamName', 'DM2');
dm3elem = FINDCELLS(FAMLIST, 'FamName', 'DM3');
dm4elem = FINDCELLS(FAMLIST, 'FamName', 'DM4');
dm5elem = FINDCELLS(FAMLIST, 'FamName', 'DM5');
dm6elem = FINDCELLS(FAMLIST, 'FamName', 'DM6');
dm7elem = FINDCELLS(FAMLIST, 'FamName', 'DM7');
dm8elem = FINDCELLS(FAMLIST, 'FamName', 'DM8');
dm9elem = FINDCELLS(FAMLIST, 'FamName', 'DM9');
dm10elem= FINDCELLS(FAMLIST, 'FamName', 'DM10');
qfelem  = FINDCELLS(FAMLIST, 'FamName', 'QF');
qdelem  = FINDCELLS(FAMLIST, 'FamName', 'QD');
qfcelem = FINDCELLS(FAMLIST, 'FamName', 'QFC');
qdxelem = FINDCELLS(FAMLIST, 'FamName', 'QDX');
qfxelem = FINDCELLS(FAMLIST, 'FamName', 'QFX');
qdyelem = FINDCELLS(FAMLIST, 'FamName', 'QDY');
qfyelem = FINDCELLS(FAMLIST, 'FamName', 'QFY');
qdzelem = FINDCELLS(FAMLIST, 'FamName', 'QDZ');
qfzelem = FINDCELLS(FAMLIST, 'FamName', 'QFZ');
sfelem  = FINDCELLS(FAMLIST, 'FamName', 'SF');
sdelem  = FINDCELLS(FAMLIST, 'FamName', 'SD');
sfielem = FINDCELLS(FAMLIST, 'FamName', 'SFI');
sdielem = FINDCELLS(FAMLIST, 'FamName', 'SDI');
bndelem = FINDCELLS(FAMLIST, 'FamName', 'BND');
b34elem = FINDCELLS(FAMLIST, 'FamName', 'B34');
%HORIZONTAL
%kick each quad in turn
%get orbit, return kick
%9 quad families (QF/QD/QFC/QDX/QFX/QDY/QFY/QDZ/QFZ)
%2 dipole families (BND/B34)
%=================================================
%   HORIZONTAL QUADRUPOLE RESPONSE
%=================================================
qxmat=[];
famindx=1;
magindx={};
for ii=qfelem:qfzelem           %loop over quad families
  magindx{famindx}=FAMLIST{ii};
  famindx=famindx+1;
  for jj=1:FAMLIST{ii}.NumKids  %loop over elements in families
   kk=FAMLIST{ii}.KidsList(jj);
   v6= 0.001*[1 0 0 0 0 0];    %1.0 mm offset

   THERING{kk} = setfield(THERING{kk},'T1',v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
   disp(['calculating closed x-orbit for family... ' char(FAMLIST{ii}.FamName)...
        ' element number... ' num2str(jj)...
         '/' num2str(FAMLIST{ii}.NumKids)]); 
   orbit=findorbit(THERING,0,1:length(THERING));         %row vector (columns)
   qxmat=[qxmat;orbit(1,FAMLIST{bpmelem}.KidsList)];    %(slow)               %add new row each time
   v6= [0 0 0 0 0 0];    %zero offset
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
  end
end

%=================================================
%   HORIZONTAL DIPOLE RESPONSE
%=================================================
for ii=bndelem:b34elem          %loop over dipole families
  magindx{famindx}=FAMLIST{ii};
  famindx=famindx+1;
  for jj=1:FAMLIST{ii}.NumKids  %loop over elements in families
   kk=FAMLIST{ii}.KidsList(jj);
   v6= 0.001*[1 0 0 0 0 0];    %1.0 mm offset
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
   disp(['calculating closed x-orbit for family... ' char(FAMLIST{ii}.FamName)...
        ' element number... ' num2str(jj)...
         '/' num2str(FAMLIST{ii}.NumKids)]); 
   orbit=findorbit(THERING,0,1:length(THERING));         %row vector (columns)
   qxmat=[qxmat;orbit(1,FAMLIST{bpmelem}.KidsList)];       %(slow)               %add new row each time
   v6= [0 0 0 0 0 0];    %zero offset
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
  end
end
xcomment='x-response to 1 mm horizontal magnet displacements.';
xcomment=[xcomment 'column arrangment according to magindx']; 
timestamp=datestr(now,0);
qxmat=qxmat';
save qxmat xcomment timestamp magindx qxmat;


%=================================================
%   VERTICAL QUADRUPOLE RESPONSE
%=================================================
qymat=[];
famindx=1;
magindx={};
for ii=qfelem:qfzelem           %loop over quad families
  magindx{famindx}=FAMLIST{ii};
  famindx=famindx+1;
  for jj=1:FAMLIST{ii}.NumKids  %loop over elements in families
   kk=FAMLIST{ii}.KidsList(jj);
   v6= 0.001*[0 0 1 0 0 0];    %1.0 mm offset
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
   disp(['calculating closed y-orbit for family... ' char(FAMLIST{ii}.FamName)...
        ' element number... ' num2str(jj)...
         '/' num2str(FAMLIST{ii}.NumKids)]); 
   orbit=findorbit(THERING,0,1:length(THERING));         %row vector (columns)
   qymat=[qymat;orbit(3,FAMLIST{bpmelem}.KidsList)];    %(slow)               %add new row each time
   v6= [0 0 0 0 0 0];    %zero offset
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
  end
end

%=================================================
%   VERTICAL DIPOLE RESPONSE
%=================================================
for ii=bndelem:b34elem          %loop over dipole families
  magindx{famindx}=FAMLIST{ii};
  famindx=famindx+1;
  for jj=1:FAMLIST{ii}.NumKids  %loop over elements in families
   kk=FAMLIST{ii}.KidsList(jj);
   v6= 0.001*[0 0 1 0 0 0];    %1.0 mm offset
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
   disp(['calculating closed y-orbit for family... ' char(FAMLIST{ii}.FamName)...
        ' element number... ' num2str(jj)...
         '/' num2str(FAMLIST{ii}.NumKids)]); 
   orbit=findorbit(THERING,0,1:length(THERING));         %row vector (columns)
   qymat=[qymat;orbit(3,FAMLIST{bpmelem}.KidsList)];    %(slow)               %add new row each time
   v6= [0 0 0 0 0 0];    %zero offset
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
  end
end
ycomment='y-response to 1 mm vertical magnet displacements.';
ycomment=[ycomment 'column arrangment according to magindx']; 
%timestamp=datestr(now,0);
qymat=qymat';
save qymat ycomment timestamp magindx qymat;