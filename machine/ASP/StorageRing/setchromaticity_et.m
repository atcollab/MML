function varargout = setchromaticity(varargin)
% SETCHROMATICITY([CHROMX CHROMY])

% disp('Warning: this only applies to zero dispersion lattice');
% disp('Warning: will also change setoperatioalmode(1)');

if nargin > 0
    chromx = varargin{1}(1);
    chromy = varargin{1}(2);
else
    error('See usage of SETCHROMATICITY');
end

ModeCell = {'User mode 0.1 m dispersion',
    'Low Alpha -0.5 m dispersion'
    'Low Alpha -0.75 m dispersion'};
[ButtonName, OKFlag] = listdlg('Name','Set Chromaticity','PromptString','Currently used lattice?', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [350 125]);

if ~OKFlag
    disp('Nothing done. Exiting setchromaticity.');
    return
else
    fprintf('Using lattice: %s\n',ModeCell{ButtonName});
end

switch ButtonName
    case 1
        assr4_modbend;
        fittunedisp2([13.29 5.216 0.096],'QFA','QDA','QFB',1);
    case 2
        setoperationalmode(8);
        fittunedisp2([13.29 5.22 -0.5],'QFA','QDA','QFB',1);
    case 3
        setoperationalmode(9);
        fittunedisp2([13.29 5.22 -0.75],'QFA','QDA','QFB',1);
end

global THERING
sind(:,1) = findcells(THERING,'FamName','SFA');
sind(:,2) = findcells(THERING,'FamName','SDA');
% Hack just to make it a little neater, should not really affect the
% results. there are 28 other family of sext but for SFB there are only 14.
sind(:,3) = [findcells(THERING,'FamName','SFB') findcells(THERING,'FamName','SFB')];
sind(:,4) = findcells(THERING,'FamName','SDB');
% Set as close to storage ring settings as possible. These numbers 15.6 and
% -16.6 etc. are taken from the machine using getsp(...,'physics'); So as
% the machine energy is 1.4% less than the design of 3 GeV the values need
% to be multiplied by 1.014 before putting it into the model (model is
% assuming 3 GeV).
THERING = setcellstruct(THERING,'PolynomB',sind(:,1),15.6*1.014,3);
THERING = setcellstruct(THERING,'PolynomB',sind(:,2),-16.9*1.014,3);
THERING = setcellstruct(THERING,'PolynomB',sind(:,3),7.67314*1.014,3);
THERING = setcellstruct(THERING,'PolynomB',sind(:,4),-8.21721*1.014,3);
fitchrom2([chromx chromy],'SFB','SDB');


sfbind = findcells(THERING,'FamName','SFB');
sdbind = findcells(THERING,'FamName','SDB');

modelSFB = physics2hw('SFB','Setpoint',getcellstruct(THERING,'PolynomB',sfbind(1),3)/1.014);
modelSDB = physics2hw('SDB','Setpoint',getcellstruct(THERING,'PolynomB',sdbind(1),3)/1.014);


%Slowly ramp up to new setpoint
curSFB = getsp('SFB',[1 1],'Online','Hardware');
curSDB = getsp('SDB',[1 1],'Online','Hardware');
for j=1:5
    setsp('SFB',curSFB + (modelSFB - curSFB)*j/5,'Hardware','Online');
    setsp('SDB',curSDB + (modelSDB - curSDB)*j/5,'Hardware','Online');
    pause(0.2);
end

disp('Done. Chromaticity set.');
