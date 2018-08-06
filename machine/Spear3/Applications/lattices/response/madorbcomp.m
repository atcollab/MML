%compare quadrupole and dipole offset to MAD
%MAD files are generated as per SPEAR 3/book 5 p 46
%ealign,qf[1],dx=0.001,dy=0.000
%putorbit,filename=
clear all;
spear3quadresp;
fprintf('Number of families: %g\n',length(FAMLIST));


bpmelem = FINDCELLS(FAMLIST, 'FamName', 'BPM');
qfelem  = FINDCELLS(FAMLIST, 'FamName', 'QF');
b34elem = FINDCELLS(FAMLIST, 'FamName', 'B34');

%HORIZONTAL: kick first QF magnet
%get orbit, return kick
qf_xmat=[];
   v6= 0.001*[1 0 0 0 0 0];    %1.0 mm offset
   kk=FAMLIST{qfelem}.KidsList(1);
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
   disp(['calculating closed x-orbit for family... ' char(FAMLIST{qfelem}.FamName)...
        ' element number... ' num2str(1)...
         '/' num2str(FAMLIST{qfelem}.NumKids)]); 
   orbit=findorbit(THERING,0,1:length(THERING));         %row vector (columns)
   qf_xmat=[orbit(1,FAMLIST{bpmelem}.KidsList)];            %(slow)               %add new row each time
   v6= [0 0 0 0 0 0];    %zero offset
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
   save qf_xmat qf_xmat;

%VERTICAL: kick first QF magnet
%get orbit, return kick
qf_ymat=[];
   v6= 0.001*[0 0 1 0 0 0];    %1.0 mm offset
   kk=FAMLIST{qfelem}.KidsList(1);
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
   disp(['calculating closed y-orbit for family... ' char(FAMLIST{qfelem}.FamName)...
        ' element number... ' num2str(1)...
         '/' num2str(FAMLIST{qfelem}.NumKids)]); 
   orbit=findorbit(THERING,0,1:length(THERING));         %row vector (columns)
   qf_ymat=[orbit(3,FAMLIST{bpmelem}.KidsList)];            %(slow)               %add new row each time
   v6= [0 0 0 0 0 0];    %zero offset
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
   save qf_ymat qf_ymat;

%HORIZONTAL: kick first B34 magnet
%get orbit, return kick
b34_xmat=[];
   v6= 0.001*[1 0 0 0 0 0];    %1.0 mm offset
   kk=FAMLIST{b34elem}.KidsList(1);
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
   disp(['calculating closed x-orbit for family... ' char(FAMLIST{b34elem}.FamName)...
        ' element number... ' num2str(1)...
         '/' num2str(FAMLIST{qfelem}.NumKids)]); 
   orbit=findorbit(THERING,0,1:length(THERING));         %row vector (columns)
   b34_xmat=[orbit(1,FAMLIST{bpmelem}.KidsList)];            %(slow)               %add new row each time
   v6= [0 0 0 0 0 0];    %zero offset
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
   save b34_xmat b34_xmat;

%VERTICAL: kick first B34 magnet
%get orbit, return kick
b34_ymat=[];
   v6= 0.001*[0 0 1 0 0 0];    %1.0 mm offset
   kk=FAMLIST{b34elem}.KidsList(1);
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
   disp(['calculating closed y-orbit for family... ' char(FAMLIST{b34elem}.FamName)...
        ' element number... ' num2str(1)...
         '/' num2str(FAMLIST{qfelem}.NumKids)]); 
   orbit=findorbit(THERING,0,1:length(THERING));         %row vector (columns)
   b34_ymat=[orbit(3,FAMLIST{bpmelem}.KidsList)];            %(slow)               %add new row each time
   v6= [0 0 0 0 0 0];    %zero offset
   THERING{kk} = setfield(THERING{kk},'T1', v6);
   THERING{kk} = setfield(THERING{kk},'T2',-v6);
   save b34_ymat b34_ymat;