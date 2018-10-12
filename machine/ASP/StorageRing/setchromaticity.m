function varargout = setchromaticity(varargin)
% SETCHROMATICITY([CHROMX CHROMY],[SFAval SDAval],Mode,'fitonly')
%
% Uses the model to determine how to set the sextupolesn (SFB and SDB) to get the desired
% chromaticity. If SFAval and SDAval is supplies (in PHYSICS units) then
% these will values will be used in the model and also applied to the
% machine.
%
% CHROMX, CHROMY   - horizontal and vertical chromacitity
% SFAval, SDAval   - desired setpoint for SFA and SDA in PHYSICS units (optional)
% Mode             - lattice selection (optional).
% 'fitonly'        - if fit only specified then don't set.
%
%                   Frequency: 499.67163 [MHz]
% Operational setpoint as of 23/01/2014: 
%               setchromaticity ([3.5 13], [15.9 -17.3])
%
% ET

fitonly = 0;
for i=1:nargin
    if ischar(varargin{i})
        switch varargin{i}
            case 'fitonly'
                fitonly = 1;
        end
    end
end
if nargin > 0
    chromx = varargin{1}(1);
    chromy = varargin{1}(2);
else
    error('See usage of SETCHROMATICITY');
end

if nargin > 1
    sfa = varargin{2}(1);
    sda = varargin{2}(2);
else
    sfa = getsp('SFA',1,'physics');
    sda = getsp('SDA',1,'physics');
end

ModeCell = {'User mode 0.1 m dispersion',
    'Low Alpha -0.7 m dispersion'
    'Low Alpha -0.88 m dispersion'
    'User mode 0.0 m dispersion'
    'User mode 0.24 m dispersion'
    '7-fold lattice'
    'Use current THERING'};
if nargin > 2 && isnumeric(varargin{3})
    ButtonName = varargin{3};
    OKFlag = 1;
else
    [ButtonName, OKFlag] = listdlg('Name','Set Chromaticity','PromptString','Currently used lattice?', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [350 125]);
    % OKFlag = 1;
    % ButtonName = 2;
end

if ~OKFlag
    disp('Nothing done. Exiting setchromaticity.');
    return
else
    fprintf('Using lattice: %s\n',ModeCell{ButtonName});
end

global THERING
OLDTHERING = THERING;

switch ButtonName
    case 1
        assr4_modbend;
%         fittunedisp2([13.29 5.216 0.0],'QFA','QDA','QFB',1); % Eugene 16/5/2010 removed to optimise speed for sextupole scan.
%         fittunedisp2([13.29 5.216 0.096],'QFA','QDA','QFB',1); % Eugene
%         16/5/2010 removed to optimise speed for sextupole scan.
        ind = findcells(THERING,'FamName','QFA');
        THERING = setcellstruct(THERING,'PolynomB',ind,1.7712776,2);
        THERING = setcellstruct(THERING,'K',ind,1.7712776);
        ind = findcells(THERING,'FamName','QDA');
        THERING = setcellstruct(THERING,'PolynomB',ind,-1.0565061,2);
        THERING = setcellstruct(THERING,'K',ind,-1.0565061);
        ind = findcells(THERING,'FamName','QFB');
        THERING = setcellstruct(THERING,'PolynomB',ind,1.5324321,2);
        THERING = setcellstruct(THERING,'K',ind,1.5324321);
    case 2
        setoperationalmode(7);
        fittunedisp2([13.29 5.20 -0.7],'QFA','QDA','QFB',1);
    case 3
        setoperationalmode(9);
        fittunedisp2([13.29 5.216 -0.88],'QFA','QDA','QFB',1);
    case 4
        assr4_modbend;
        fittunedisp2([13.289 5.205 0],'QFA','QDA','QFB',1);
    case 5
        assr4_modbend;
        fittunedisp2([13.29 5.216 0.24],'QFA','QDA','QFB',1);
    case 6
        setoperationalmode(10);
    case 7
        % do nothing; use current lattice

end

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
% THERING = setcellstruct(THERING,'PolynomB',sind(:,1),15.6*1.014,3);
% THERING = setcellstruct(THERING,'PolynomB',sind(:,2),-16.6*1.014,3);

THERING = setcellstruct(THERING,'PolynomB',sind(:,1),sfa*1.014,3);
THERING = setcellstruct(THERING,'PolynomB',sind(:,2),sda*1.014,3);

THERING = setcellstruct(THERING,'PolynomB',sind(:,3),7.54467314*1.014,3);
THERING = setcellstruct(THERING,'PolynomB',sind(:,4),-8.21721*1.014,3);

% THERING = setcellstruct(THERING,'PolynomB',sind(:,1),getsp('SFA',[1 1],'physics')*1.014,3);
% THERING = setcellstruct(THERING,'PolynomB',sind(:,2),getsp('SDA',[1 1],'physics')*1.014,3);
% THERING = setcellstruct(THERING,'PolynomB',sind(:,3),getsp('SFB',[1 1],'physics')*1.014,3);
% THERING = setcellstruct(THERING,'PolynomB',sind(:,4),getsp('SDB',[1 1],'physics')*1.014,3);

fitchrom2([chromx chromy],'SFB','SDB');


sfaind = findcells(THERING,'FamName','SFA');
sdaind = findcells(THERING,'FamName','SDA');
sfbind = findcells(THERING,'FamName','SFB');
sdbind = findcells(THERING,'FamName','SDB');

modelSFA = physics2hw('SFA','Setpoint',getcellstruct(THERING,'PolynomB',sfaind(1),3)/1.014);
modelSDA = physics2hw('SDA','Setpoint',getcellstruct(THERING,'PolynomB',sdaind(1),3)/1.014);

modelSFB = physics2hw('SFB','Setpoint',getcellstruct(THERING,'PolynomB',sfbind(1),3)/1.014);
modelSDB = physics2hw('SDB','Setpoint',getcellstruct(THERING,'PolynomB',sdbind(1),3)/1.014);


THERING = OLDTHERING;

if ~fitonly
    %Slowly ramp up to new setpoint
    curSFA = getsp('SFA',[1 1],'Hardware');
    curSDA = getsp('SDA',[1 1],'Hardware');
    curSFB = getsp('SFB',[1 1],'Hardware');
    curSDB = getsp('SDB',[1 1],'Hardware');

    for j=1:5
        setsp('SFA',curSFA + (modelSFA - curSFA)*j/5,'Hardware');
        setsp('SDA',curSDA + (modelSDA - curSDA)*j/5,'Hardware');
        setsp('SFB',curSFB + (modelSFB - curSFB)*j/5,'Hardware');
        setsp('SDB',curSDB + (modelSDB - curSDB)*j/5,'Hardware');
        %     pause(0.2);
    end
    disp('Done. Chromaticity set.');
end

if nargout > 0
    varargout{1} = [mean(modelSFA) mean(modelSDA) mean(modelSFB) mean(modelSDB)];
end

