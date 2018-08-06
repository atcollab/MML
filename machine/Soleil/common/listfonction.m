
return;

%% Fonctions

soleilinit : initialise le middleware
getall : cree les proxy vers tous les aimants

solorbit
soleilelementicons

%% manipulation de AO
%Accelerator Object
showfamily('BPMx') affiche l'objet
getfamilytype
getao
setao
getad
setad

%% changer de model
switch2online
switch2sim
switch2physics
switch2hw

% Configuration
sim2machine

%tune
tune2sim
tune2online
tune2manual
gettune
settune

%RF
setrf
getrf
sweepenergy
sweepenergy2

physics2hw
hw2physics
amp2k
k2amp
gev2bend  % beam energy to bend current

getbpmnames

getfamilylist
getlist

getphysdata
setphysdata

family2dev
getfamilydata

%measurements
measbpmresp
measbpmsigma
measdisp
measdispresp
measchro
measchroresp
measlifetime
measrate
measrespmat
meastuneresp

%%% BPM 
getx: get H bpms
getz: get V bpms
soleilbpms
getxsoleil
getzsoleil
getbpmsoleil

checklimits

%% ANNEAU
getenergy: get energy
getbrho: get brho
bend2gev

physics2hw Converts from 'Physics' units to 'Hardware' units

% transformation
tango2dev
tango2common
tango2family

A modifier:
k2amp
magnetcoeeficients

%utiliser pat configgui
getmachineconfig

makephysdata : modifier chro et tune

%% GUI ou IHM
srsetup
plotfamily
solorbit
configgui

%%% Fonctions pour se simplifier la vie sous matlab
xaxis
xaxiss
yaxis
yaxiss
sleep
popplot
appendtimestamp
gotodirectory
