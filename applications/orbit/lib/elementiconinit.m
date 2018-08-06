function ElementIconInit(machine);
%initialize element icon data
global THERING SYS
    
dx=0.01;
dx2=0.005;

if strcmp(upper(machine),'SPEAR3')
AO=GetAO;
%THERING=setcellstruct(THERING,'fleld',value,value);

%BPMS
fam='BPMx';
phi=2*pi*[0:0.01:1];
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=ind;
phi=2*pi*[0:0.05:1];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
    THERING{jj}.xpts=cos(phi)/180;      %180 gets horizontal size correct
    THERING{jj}.ypts=(sin(phi)+1.8)/4;  %+1.8)/4 gets vertical size and position correct
    THERING{jj}.color='g';   
    THERING{jj}.elementimage='bpm_1.jpg';
    THERING{jj}.AOFamily=AO{ifam}.FamilyName;
    THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
  end

%Correctors
fam='HCM';
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
dx=0.005;  dx2=0.0015;
dy=0.6; dy2=0.10;
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[0   dx;    dx   dx2;    dx2 dx2; dx2 -dx2; -dx2 -dx2; -dx2 -dx; -dx   0;];
        THERING{jj}.ypts=[1.0 dy;    dy   dy;     dy  dy2; dy2  dy2;  dy2  dy;   dy   dy;  dy 1.0;];
        THERING{jj}.color='k';
        THERING{jj}.elementimage='corrector_1.jpg';
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

%Bends
dx=0.010;
dx2=0.002;
dy=0.85;
dy2=0.1;

fam='B145';   
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[-dx2 -dx;  -dx  dx;     dx   dx2;     dx2  -dx2;];
        THERING{jj}.ypts=[dy2   dy;   dy  dy;     dy   dy2;     dy2   dy2;];
        THERING{jj}.color='b';
        THERING{jj}.elementimage='bend_1.jpg';           %BEND
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
  end


fam='B109';
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[-dx2 -dx;  -dx  dx;     dx   dx2;     dx2  -dx2;];
        THERING{jj}.ypts=[dy2   dy;   dy  dy;     dy   dy2;     dy2   dy2;];
        THERING{jj}.color='b';
        THERING{jj}.elementimage='bend_1.jpg';           %BEND
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
  end

%Horizontally Focusing Quads
dx=0.003;
dy=0.33;

fam='QF';      
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[0 -dx;  -dx   -dx;     -dx   0;     0  dx;   dx  dx; dx 0;];
        THERING{jj}.ypts=[0  dy;   dy  2*dy;    2*dy  3*dy; 3*dy 2*dy; 2*dy dy; dy 0;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

fam='QFC';     
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[0 -dx;  -dx   -dx;     -dx   0;     0  dx;   dx  dx; dx 0;];
        THERING{jj}.ypts=[0  dy;   dy  2*dy;    2*dy  3*dy; 3*dy 2*dy; 2*dy dy; dy 0;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end
 
fam='QFX';     
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[0 -dx;  -dx   -dx;     -dx   0;     0  dx;   dx  dx; dx 0;];
        THERING{jj}.ypts=[0  dy;   dy  2*dy;    2*dy  3*dy; 3*dy 2*dy; 2*dy dy; dy 0;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

fam='QFY';
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[0 -dx;  -dx   -dx;     -dx   0;     0  dx;   dx  dx; dx 0;];
        THERING{jj}.ypts=[0  dy;   dy  2*dy;    2*dy  3*dy; 3*dy 2*dy; 2*dy dy; dy 0;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

fam='QFZ';     
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[0 -dx;  -dx   -dx;     -dx   0;     0  dx;   dx  dx; dx 0;];
        THERING{jj}.ypts=[0  dy;   dy  2*dy;    2*dy  3*dy; 3*dy 2*dy; 2*dy dy; dy 0;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

%Vertically Focusing Quads
dx=0.005;  dx2=0.002;
dy1=0.1; dy=0.33; dy2=0.85;

fam='QD';      
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[-dx -dx2; -dx2   -dx2;    -dx2  -dx;  -dx   dx;    dx  dx2;   dx2  dx2; dx2 dx;   dx   -dx;];
        THERING{jj}.ypts=[dy1    dy;   dy   2*dy;    2*dy  dy2; dy2   dy2;  dy2 2*dy; 2*dy   dy;  dy  dy1;  dy1   dy1;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

fam='QDX';     
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[-dx -dx2; -dx2   -dx2;    -dx2  -dx;  -dx   dx;    dx  dx2;   dx2  dx2; dx2 dx;   dx   -dx;];
        THERING{jj}.ypts=[dy1    dy;   dy   2*dy;    2*dy  dy2; dy2   dy2;  dy2 2*dy; 2*dy   dy;  dy  dy1;  dy1   dy1;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

fam='QDY';     
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[-dx -dx2; -dx2   -dx2;    -dx2  -dx;  -dx   dx;    dx  dx2;   dx2  dx2; dx2 dx;   dx   -dx;];
        THERING{jj}.ypts=[dy1    dy;   dy   2*dy;    2*dy  dy2; dy2   dy2;  dy2 2*dy; 2*dy   dy;  dy  dy1;  dy1   dy1;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

fam='QDZ';     
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[-dx -dx2; -dx2   -dx2;    -dx2  -dx;  -dx   dx;    dx  dx2;   dx2  dx2; dx2 dx;   dx   -dx;];
        THERING{jj}.ypts=[dy1    dy;   dy   2*dy;    2*dy  dy2; dy2   dy2;  dy2 2*dy; 2*dy   dy;  dy  dy1;  dy1   dy1;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

%Horizontally Focusing Sextupoles
dx=0.005;  dx2=0.002;
dy=0.85;

fam='SF';      
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[0 -dx; -dx   dx;    dx2  0;];
        THERING{jj}.ypts=[0  dy;  dy   dy;    dy   0;];
        THERING{jj}.color='y';
        THERING{jj}.elementimage='sextupole_1.jpg';
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
  end


fam='SFI';     
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[0 -dx; -dx   dx;    dx2  0;];
        THERING{jj}.ypts=[0  dy;  dy   dy;    dy   0;];
        THERING{jj}.color='y';
        THERING{jj}.elementimage='sextupole_1.jpg';
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
  end


%Vertically Focusing Sextupoles
dx=0.005;  dx2=0.002;
dy=0.15;

fam='SD';      
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[-dx  0;    0   dx;    dx -dx;];
        THERING{jj}.ypts=[ dy  1.0;  1.0 dy;    dy  dy;];
        THERING{jj}.color='y';
        THERING{jj}.elementimage='sextupole_1.jpg';
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

fam='SDI';     
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[-dx  0;    0   dx;    dx -dx;];
        THERING{jj}.ypts=[ dy  1.0;  1.0 dy;    dy  dy;];
        THERING{jj}.color='y';
        THERING{jj}.elementimage='sextupole_1.jpg';
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

  
%CAVITY
%   fam='RF';
% ifam=isfamily(fam);
% ind=AO{ifam}.AT.ATIndex;
% elemind=[elemind; ind];
%jj=0;
%  for ii=1:size(ind,1)
%   jj=ind(ii);
%         THERING{jj}.xpts=[0 dx2 dx dx2];
%         THERING{jj}.ypts=[0.7 1 0.7 0];
%         THERING{jj}.color='r';
%         THERING{jj}.elementimage='cavity_1.jpg';
%         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
%         THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
%   end
  
elemind=sort(elemind);
SYS.elemind=elemind(:);   %store element indices for display








elseif strcmp(upper(machine),'SPEAR2')
AO=GetAO;

%BPMS
fam='BPMx';
phi=2*pi*[0:0.01:1];
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=ind;
phi=2*pi*[0:0.05:1];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
    THERING{jj}.xpts=cos(phi)/180;      %180 gets horizontal size correct
    THERING{jj}.ypts=(sin(phi)+1.8)/4;  %+1.8)/4 gets vertical size and position correct
    THERING{jj}.color='g';   
    THERING{jj}.elementimage='bpm_1.jpg';
    THERING{jj}.AOFamily=AO{ifam}.FamilyName;
    THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
  end


%Bends
dx=0.010;
dx2=0.002;
dy=0.85;
dy2=0.1;

fam='BEND';   
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[-dx2 -dx;  -dx  dx;     dx   dx2;     dx2  -dx2;];
        THERING{jj}.ypts=[dy2   dy;   dy  dy;     dy   dy2;     dy2   dy2;];
        THERING{jj}.color='b';
        THERING{jj}.elementimage='bend_1.jpg';           %BEND
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
  end



%Horizontally Focusing Quads
dx=0.003;
dy=0.33;

fam='Q1';      
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[0 -dx;  -dx   -dx;     -dx   0;     0  dx;   dx  dx; dx 0;];
        THERING{jj}.ypts=[0  dy;   dy  2*dy;    2*dy  3*dy; 3*dy 2*dy; 2*dy dy; dy 0;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end
 
 
fam='QFA';      
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[0 -dx;  -dx   -dx;     -dx   0;     0  dx;   dx  dx; dx 0;];
        THERING{jj}.ypts=[0  dy;   dy  2*dy;    2*dy  3*dy; 3*dy 2*dy; 2*dy dy; dy 0;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

fam='QFB';     
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[0 -dx;  -dx   -dx;     -dx   0;     0  dx;   dx  dx; dx 0;];
        THERING{jj}.ypts=[0  dy;   dy  2*dy;    2*dy  3*dy; 3*dy 2*dy; 2*dy dy; dy 0;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end
 


fam='QF';     
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[0 -dx;  -dx   -dx;     -dx   0;     0  dx;   dx  dx; dx 0;];
        THERING{jj}.ypts=[0  dy;   dy  2*dy;    2*dy  3*dy; 3*dy 2*dy; 2*dy dy; dy 0;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

%Vertically Focusing Quads
dx=0.005;  dx2=0.002;
dy1=0.1; dy=0.33; dy2=0.85;

fam='Q1';      
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[-dx -dx2; -dx2   -dx2;    -dx2  -dx;  -dx   dx;    dx  dx2;   dx2  dx2; dx2 dx;   dx   -dx;];
        THERING{jj}.ypts=[dy1    dy;   dy   2*dy;    2*dy  dy2; dy2   dy2;  dy2 2*dy; 2*dy   dy;  dy  dy1;  dy1   dy1;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end
 
fam='QDA';      
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[-dx -dx2; -dx2   -dx2;    -dx2  -dx;  -dx   dx;    dx  dx2;   dx2  dx2; dx2 dx;   dx   -dx;];
        THERING{jj}.ypts=[dy1    dy;   dy   2*dy;    2*dy  dy2; dy2   dy2;  dy2 2*dy; 2*dy   dy;  dy  dy1;  dy1   dy1;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end

fam='QD';     
ifam=isfamily(fam);
ind=AO{ifam}.AT.ATIndex;
elemind=[elemind; ind];
jj=0;
  for ii=1:size(ind,1)
    jj=ind(ii);
        THERING{jj}.xpts=[-dx -dx2; -dx2   -dx2;    -dx2  -dx;  -dx   dx;    dx  dx2;   dx2  dx2; dx2 dx;   dx   -dx;];
        THERING{jj}.ypts=[dy1    dy;   dy   2*dy;    2*dy  dy2; dy2   dy2;  dy2 2*dy; 2*dy   dy;  dy  dy1;  dy1   dy1;];
        THERING{jj}.color='r';
        THERING{jj}.elementimage='quadrupole_1.jpg';
        THERING{jj}.AOFamily=AO{ifam}.FamilyName;
        THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
 end


% % % %Horizontally Focusing Sextupoles
% % % dx=0.005;  dx2=0.002;
% % % dy=0.85;
% % % 
% % % fam='SF';      
% % % ifam=isfamily(fam);
% % % ind=AO{ifam}.AT.ATIndex;
% % % elemind=[elemind; ind];
% % % jj=0;
% % %   for ii=1:size(ind,1)
% % %     jj=ind(ii);
% % %         THERING{jj}.xpts=[0 -dx; -dx   dx;    dx2  0;];
% % %         THERING{jj}.ypts=[0  dy;  dy   dy;    dy   0;];
% % %         THERING{jj}.color='y';
% % %         THERING{jj}.elementimage='sextupole_1.jpg';
% % %         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
% % %         THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
% % %   end
% % % 
% % % 
% % % 
% % % 
% % % %Vertically Focusing Sextupoles
% % % dx=0.005;  dx2=0.002;
% % % dy=0.15;
% % % 
% % % fam='SDA';      
% % % ifam=isfamily(fam);
% % % ind=AO{ifam}.AT.ATIndex;
% % % elemind=[elemind; ind];
% % % jj=0;
% % %   for ii=1:size(ind,1)
% % %     jj=ind(ii);
% % %         THERING{jj}.xpts=[-dx  0;    0   dx;    dx -dx;];
% % %         THERING{jj}.ypts=[ dy  1.0;  1.0 dy;    dy  dy;];
% % %         THERING{jj}.color='y';
% % %         THERING{jj}.elementimage='sextupole_1.jpg';
% % %         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
% % %         THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
% % %  end
% % % 
% % % fam='SDB';     
% % % ifam=isfamily(fam);
% % % ind=AO{ifam}.AT.ATIndex;
% % % elemind=[elemind; ind];
% % % jj=0;
% % %   for ii=1:size(ind,1)
% % %     jj=ind(ii);
% % %         THERING{jj}.xpts=[-dx  0;    0   dx;    dx -dx;];
% % %         THERING{jj}.ypts=[ dy  1.0;  1.0 dy;    dy  dy;];
% % %         THERING{jj}.color='y';
% % %         THERING{jj}.elementimage='sextupole_1.jpg';
% % %         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
% % %         THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
% % %  end

  
%CAVITY
%   fam='RF';
% ifam=isfamily(fam);
% ind=AO{ifam}.AT.ATIndex;
% elemind=[elemind; ind];
%jj=0;
%  for ii=1:size(ind,1)
%   jj=ind(ii);
%         THERING{jj}.xpts=[0 dx2 dx dx2];
%         THERING{jj}.ypts=[0.7 1 0.7 0];
%         THERING{jj}.color='r';
%         THERING{jj}.elementimage='cavity_1.jpg';
%         THERING{jj}.AOFamily=AO{ifam}.FamilyName;
%         THERING{jj}.AODevice=AO{ifam}.DeviceList(ii,:);
%   end
  
elemind=sort(elemind);
SYS.elemind=elemind(:);   %store element indices for display







else   %%%%%%%%%%%%%%%%            other machines           %%%%%%%%%%%%%%%%%%%
    
%loop through families assigning icon properties and image file name
for ii=1:length(THERING)
    elemtype=THERING{ii}.FamName;
    switch elemtype(1)
    case 'A'    %...APERTURE, vertical bar
        THERING{ii}.xpts=[0 0 dx/2 dx/2];
        THERING{ii}.ypts=[0 1 1 0];
        THERING{ii}.color='r';
        THERING{ii}.elementimage='aperture_1.jpg';
  
    case 'D'    %...DRIFT, horizontal bar
        THERING{ii}.xpts=[0 0 3*dx 3*dx];
        THERING{ii}.ypts=[0.33 0.66 0.66 0.33];
        THERING{ii}.color='r';
         THERING{ii}.elementimage='drift_1.jpg';
  
    case 'C'    %...CORRECTOR, diamond
        THERING{ii}.xpts=[0 dx2 dx dx2];
        THERING{ii}.ypts=[0.7 1 0.7 0];
        THERING{ii}.color='r';
        THERING{ii}.elementimage='corrector_1.jpg';
  
    case 'Q'    %...QUAD, hexagon
        THERING{ii}.xpts=[0 0 0.015 0.03 0.03 0.015];
        THERING{ii}.ypts=[0.3 0.7 1 0.7 0.3 0];
        THERING{ii}.color='b';
        THERING{ii}.elementimage='quadrupole_1.jpg';
        
    case 'B'    %...BPM or BEND
        THERING{ii}.xpts=[0 0.01 0.02 0.03];        %...default BEND, trapezoid
        THERING{ii}.ypts=[0 0.8 0.8 0];
        THERING{ii}.color='k';
        THERING{ii}.elementimage='bend_1.jpg';%BEND
       
        if length(elemtype)>1                    
            if strcmp(elemtype(1:2),'BP')        %...BPM, circle
                phi=2*pi*[0:0.01:1];
                THERING{ii}.xpts=cos(phi)/150;   %150 gets horizontal size correct
                THERING{ii}.ypts=(sin(phi)+1)/3; %+1)/3 gets vertical size and position correct
                THERING{ii}.color='g';   
         THERING{ii}.elementimage='bpm_1.jpg';   %BPM
           end
        end
        
    case 'S'    %...SEXT
        THERING{ii}.xpts=[dx/2 0 dx dx 0 dx/2 dx/2];
        THERING{ii}.ypts=[0.5 0 0 1 1 0.5 0.5];
        THERING{ii}.color='m';
        THERING{ii}.elementimage='sextupole_1.jpg';
        
    otherwise
        disp(['Warning: element type not found in ElementIconInit' elemtype ]);
        THERING{ii}.xpts=[0 0 0 0];
        THERING{ii}.ypts=[0 0 0 0];
        THERING{ii}.color='k';
        THERING{ii}.elementimage='drift_1.jpg';

    end   %...end of CASE
    
end       %...end of elemtype loop
end
