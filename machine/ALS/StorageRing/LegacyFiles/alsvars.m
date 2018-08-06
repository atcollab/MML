function  alsvars(MODE)
% function  alsvars(SR_MODE)
%
% Creates all the variables necessary for the database access
% to the storage ring.  All variables are global, use the
% function alsglobe to make them accessible to your function.
% SR_MODE can be a filename or 0 = Interactive method
%                              1 = 1.9 GeV multi-bunch
%                              2 = 1.5 GeV multi-bunch
%                              3 = 1.9 GeV 2-bunch
%									  4 = 1.9 GeV nu_y = 9.2
%

% RF Freq / mean(arc HCMs) =  -.0016 MHz / amps

% Updated IDlist to include EPU(11,2), T. Scarvie, 2-16-05

% Changed to work with new middle layer, T.Scarvie, 5-2-05

global GLOBAL_SR_GEV
global GLOBAL_SR_GEV_INJECTION
global GLOBAL_ALSDATA_DIRECTORY
global GLOBAL_SR_MODE
global GLOBAL_SR_MODE_TITLE
global GLOBAL_SR_MODE_DIR
global GLOBAL_SR_MODE_FILE
global GLOBAL_SR_STATE
global GLOBAL_SR_GOLDENPAGE_FILE
global GLOBAL_SR_PRODUCTION_FILE
global GLOBAL_SR_INJECTION_FILE
global GLOBAL_SR_SMATRIX_FILE
global GLOBAL_SR_SMATRIX_CHICANE_FILE
global GLOBAL_SR_SMATRIX_RFMO_FILE
global GLOBAL_SR_SMATRIX_BSC_FILE
global GLOBAL_SR_RAMPUP_FILE
global GLOBAL_SR_RAMPDN_FILE
global GLOBAL_SR_MASTERRAMP_FILE
global GLOBAL_SR_GOLDEN_TUNE
global GLOBAL_SR_TUNE_MATRIX
global GLOBAL_SR_GOLDEN_CHROMATICITY
global GLOBAL_SR_CHROMATICITY_MATRIX
% Mtune= GLOBAL_SR_TUNE_MATRIX;
global GLOBAL_SR_BSC_RAMPRATE

% global GeV
% global Xgolden Ygolden
% global Sxmat Symat SIDxmat SIDymat
% global BPMs
% global BPMlist BPMlist1278
% global BPMelem BPMelem1278
% global elem18 elem27 elem36 elem45 BSCelem45
% global IDBPMlist IDBPMelem IDBPMs
% global Xoffset Yoffset
% global IDXoffset IDYoffset IDXgolden IDYgolden
% global BBPMlist BBPMelem BBPMs
% global BXoffset BYoffset BXgolden BYgolden
% global VCMs VCMelem VCMlist CMelem1278
% global HCMs HCMelem HCMlist CMlist1278
% global QFs QFlist
% global QDs QDlist
% global IDs IDlist
% global BENDs QFAs
% global SectorLength


% Input checking
% File method for operational modes
GLOBAL_SR_STATE = 0;

Pathname = getfamilydata('Directory','OpsData');
%Pathname = '\\Als-filer\als\physbase\matlab2004\acceleratorcontrol\machine\alsopsdata';
%Pathname = '/home/als/physbase/matlab2004/acceleratorcontrol/machine/alsopsdata/';


% % Set in setoperationalmode
% if nargin < 1
%    GLOBAL_SR_MODE = menu('Storage Ring Operational Mode?','OBSOLETE!! 1.9 GeV Multi-Bunch', ...
%       '1.5 GeV Multi-Bunch','   1.9 GeV Two Bunch  ','   1.9 GeV nu_y = 9.20  ','Input Mode From A File');
%    if GLOBAL_SR_MODE == 5
%       GLOBAL_SR_MODE = 0;
%    end
%    MODE = GLOBAL_SR_MODE;
% else
%    if isstr(MODE)
%       GLOBAL_SR_MODE = 0;
%    else
%       GLOBAL_SR_MODE = MODE;
%       if isempty(GLOBAL_SR_MODE)
%          error('Input mode number was empty.');
%       end
%       GLOBAL_SR_MODE = round(GLOBAL_SR_MODE);
%    end
% end

if isempty(GLOBAL_SR_MODE)
    error('Not a good way to exit alsvars.  You will probably want to rerun alsinit (or alsvars).');
end

try
    if GLOBAL_SR_MODE == 1
        StartFlag = questdlg(str2mat('Are you sure that you want to use this lattice?','1.9 GeV, nu_y = 9.20 is now the default'),'1.9 GeV Lattice Setup','Yes','No','No');
        if strcmp(StartFlag,'No')
            disp('  Lattice setup stopped. Please rerun alsinit, alsvars, or change operational mode again!');
            return
        end
    end

    if GLOBAL_SR_MODE == 0
        if isstr(MODE)
            GLOBAL_SR_MODE_FILE = MODE;
        else
            % Load from a file
            [GLOBAL_SR_MODE_FILE, Pathname] = uigetfile('*.txt', 'Choose The Desired Storage Ring Mode File.', getfamilydata('Directory','OpsData'));
            if GLOBAL_SR_MODE_FILE == 0
                disp('  ALSVARS canceled.'); disp(' ');
                return
            end
            GLOBAL_SR_MODE_DIR = '';
            %fprintf('  Loading parameters from file %s.\n', GLOBAL_SR_MODE_FILE);
        end
    elseif GLOBAL_SR_MODE == 1
        % 1.9 GeV storage ring operation, low tune
        GLOBAL_SR_MODE_DIR = ['LowTune', filesep];
        GLOBAL_SR_MODE_FILE = '19srmode.txt';
    elseif GLOBAL_SR_MODE == 2
        % 1.5 GeV storage ring operation
        GLOBAL_SR_MODE_DIR = ['1_5HighTune', filesep];
        GLOBAL_SR_MODE_FILE = '15nuy9srmode.txt';
    elseif GLOBAL_SR_MODE == 3
        % 1.9 GeV two bunch storage ring operation
        GLOBAL_SR_MODE_DIR = ['TwoBunch', filesep];
        GLOBAL_SR_MODE_FILE = '19tbfbsrmode.txt';
    elseif GLOBAL_SR_MODE == 4
        % 1.9 GeV multi bunch storage ring operation, nu_y = 9.2
        GLOBAL_SR_MODE_DIR = ['HighTune', filesep];
        GLOBAL_SR_MODE_FILE = '19nuy9srmode.txt';
    else
        error('Problem choosing mode file in ALSVARS.')
    end


    % Load SR mode file
    [fid, err] = fopen([Pathname, GLOBAL_SR_MODE_FILE],'rt');
    if fid < 0
        fprintf('\n  %s\n  ALSVARS canceled due to SR mode file problem.\n\n', err);
        return
    end

    while 1
        tline = fgetl(fid);

        if ~ischar(tline), break, end

        if isempty(tline)
            % blank
        elseif tline(1) == '#'
            % Comment
        elseif findstr('SR_GOLDEN_CHROMATICITY_X',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            SR_GOLDEN_CHROMATICITY_X = sscanf(tline,'%f',1);
        elseif findstr('SR_GOLDEN_CHROMATICITY_Y',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            SR_GOLDEN_CHROMATICITY_Y = sscanf(tline,'%f',1);
        elseif findstr('SR_GOLDEN_TUNE_X',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            SR_GOLDEN_TUNE_X = sscanf(tline,'%f',1);
        elseif findstr('SR_GOLDEN_TUNE_Y',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            SR_GOLDEN_TUNE_Y = sscanf(tline,'%f',1);
        elseif findstr('ALSDATA_DIRECTORY',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_ALSDATA_DIRECTORY = sscanf(tline,'%s',1);
        elseif findstr('SR_GOLDENPAGE_FILE',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_SR_GOLDENPAGE_FILE = sscanf(tline,'%s',1);
        elseif findstr('SR_SMATRIX_RFMO_FILE',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_SR_SMATRIX_RFMO_FILE = sscanf(tline,'%s',1);
        elseif findstr('SR_SMATRIX_BSC_FILE',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_SR_SMATRIX_BSC_FILE = sscanf(tline,'%s',1);
        elseif findstr('SR_SMATRIX_CHICANE_FILE',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_SR_SMATRIX_CHICANE_FILE = sscanf(tline,'%s',1);
        elseif findstr('SR_SMATRIX_FILE',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_SR_SMATRIX_FILE = sscanf(tline,'%s',1);
        elseif findstr('SR_MASTERRAMP_FILE',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_SR_MASTERRAMP_FILE = sscanf(tline,'%s',1);
        elseif findstr('SR_RAMPDN_FILE',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_SR_RAMPDN_FILE = sscanf(tline,'%s',1);
        elseif findstr('SR_RAMPUP_FILE',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_SR_RAMPUP_FILE = sscanf(tline,'%s',1);
        elseif findstr('SR_INJECTION_FILE',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_SR_INJECTION_FILE = sscanf(tline,'%s',1);
        elseif findstr('SR_PRODUCTION_FILE',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_SR_PRODUCTION_FILE = sscanf(tline,'%s',1);
        elseif findstr('SR_MODE_TITLE ',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)+1) = [];
            GLOBAL_SR_MODE_TITLE = tline;
        elseif findstr('SR_GEV_INJECTION',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_SR_GEV_INJECTION = sscanf(tline,'%f',1);
        elseif findstr('SR_GEV',tline)
            tmp = sscanf(tline,'%s',1);
            tline(1:length(tmp)) = [];
            GLOBAL_SR_GEV = sscanf(tline,'%f',1);
        end
    end

    fclose(fid);
    GLOBAL_SR_GOLDEN_CHROMATICITY = [SR_GOLDEN_CHROMATICITY_X; SR_GOLDEN_CHROMATICITY_Y];
    GLOBAL_SR_GOLDEN_TUNE = [SR_GOLDEN_TUNE_X; SR_GOLDEN_TUNE_Y];
catch
   fprintf('\n   Problem choosing mode file in ALSVARS.\n\n')
end


% % Change to PC directory name if needed
% if strcmp(computer,'PCWIN') == 1
% 	% Change to SUN directory
% 	i = findstr(GLOBAL_ALSDATA_DIRECTORY,'/home/als/physbase/');
% 	if ~isempty(i)
% 		GLOBAL_ALSDATA_DIRECTORY(i:i+18) = [];
% 		GLOBAL_ALSDATA_DIRECTORY = ['\\Als-filer\physbase\',GLOBAL_ALSDATA_DIRECTORY];
% 	end
%
% 	i = findstr(GLOBAL_ALSDATA_DIRECTORY,'/');
% 	if ~isempty(i)
% 		GLOBAL_ALSDATA_DIRECTORY(i) = '\';
% 	end
% else
%    % Mode file is already in SUN directory format
% end


% Get from new middle layer
GLOBAL_SR_GOLDEN_TUNE = getgolden('TUNE');
GLOBAL_SR_GOLDEN_CHROMATICITY = getgolden('CHROMATICITY');
GLOBAL_SR_GEV = getfamilydata('Energy');
GLOBAL_SR_GEV_INJECTION = getfamilydata('InjectionEnergy');

GLOBAL_ALSDATA_DIRECTORY = getfamilydata('Directory','DataRoot');
i = findstr(GLOBAL_ALSDATA_DIRECTORY, filesep);
GLOBAL_ALSDATA_DIRECTORY = GLOBAL_ALSDATA_DIRECTORY(1:i(end-1));



fprintf('   SR mode title: %s (alsvars)\n' , GLOBAL_SR_MODE_TITLE);
fprintf('   SR mode  file: %s%s%s (alsvars)\n', GLOBAL_ALSDATA_DIRECTORY, GLOBAL_SR_MODE_DIR, GLOBAL_SR_MODE_FILE);
%fprintf('   Injection file: %s%s (alsvars)\n', GLOBAL_ALSDATA_DIRECTORY, GLOBAL_SR_INJECTION_FILE);
%fprintf('  Production file: %s%s (alsvars)\n', GLOBAL_ALSDATA_DIRECTORY, GLOBAL_SR_PRODUCTION_FILE);
fprintf('   Goldenpage file: %s%s%s (alsvars)\n', GLOBAL_ALSDATA_DIRECTORY, GLOBAL_SR_MODE_DIR, GLOBAL_SR_GOLDENPAGE_FILE);


% Common data for all SR states

% Remnant of old globals that should get fazed out!
GeV = GLOBAL_SR_GEV;


% preinitialize Superbend ramprate to a safe value
GLOBAL_SR_BSC_RAMPRATE = 0.4;


% % Arc Sector length [m]
% SectorLength = 16.40;
% Circumference = 12*SectorLength;

% % Generate the various list and element vectors
%
% % IDBPM list
% % WARNING:  if you change this list, you must get another S-matrix!!!!
% IDBPMlist = [
%              1 1
%              1 2
%              2 1
%              2 2
%              3 1
%              3 2
%              4 1
%              4 2
%              5 1
%              5 2
%              6 1
%              6 2
%              7 1
%              7 2
%              8 1
%              8 2
%              9 1
%              9 2
%             10 1
%             10 2
%             11 1
%             11 2
%             12 1
%             12 2];
% IDBPMelem = dev2elem('IDBPMx', IDBPMlist);
%
% IDBPMs = [
%    [12*SectorLength-2.3906;     2.6014]
%  (2-1)*SectorLength + [-2.3906; 2.6014]
%  (3-1)*SectorLength + [-2.3906; 2.6014]
%  (4-1)*SectorLength + [-2.3906; 2.6014]
%  (5-1)*SectorLength + [-2.3906; 2.6014]
%  (6-1)*SectorLength + [-2.3906; 2.6014]
%  (7-1)*SectorLength + [-2.3906; 2.6014]
%  (8-1)*SectorLength + [-2.3906; 2.6014]
%  (9-1)*SectorLength + [-2.3906; 2.6014]
% (10-1)*SectorLength + [-2.3906; 2.6014]
% (11-1)*SectorLength + [-2.3906; 2.6014]
% (12-1)*SectorLength + [-2.3906; 2.6014] ];
%
% BBPMlist = [
%              1 4
%              1 5
%              2 4
%              2 5
%              3 4
%              3 5
%              4 4
%              4 5
%              5 4
%              5 5
%              6 4
%              6 5
%              7 4
%              7 5
%              8 4
%              8 5
%              9 4
%              9 5
%             10 4
%             10 5
%             11 4
%             11 5
%             12 4
%             12 5];
% BBPMelem = dev2elem('BBPMx', BBPMlist);
%
% BBPMSectorS=[
% 7.59
% 8.81];
%
% % Insertion device list
% IDlist = [
%    4 1
%    5 1
%    7 1
%    8 1
%    9 1
%    10 1
% %   11 1    VME crate for IDL not connected to network, yet.
%    11 2
%    12 1];
% IDs = (IDlist(:,1)-1)*SectorLength;
%
%
% % Position information
% BENDSectorS=[
% 5.56  - .87/2
% 8.63  - .87/2
% 11.71 - .87/2];
%
% QFASectorS=[
% 6.75  - .45/2
% 10.10 - .45/2];
%
% BPMSectorS=[
% 3.29
% 4.45
% 6.07
% 7.59
% 8.81
% 10.33
% 11.88
% 13.11];
%
% HCMSectorS = [
%  2.83   % HCM1
%  3.94   % HCM2
%  5.88   % HCSD1
%  6.98   % HCSF1
%  9.42   % HCSF2
% 10.52   % HCSD2
% 12.46   % HCM3
% 13.57]; % HCM4
%
% VCMSectorS = [
%  2.83   % VCM1
%  3.94   % VCM2
%  6.98   % VCSF1
%  9.42   % VCSF2
% 12.46   % VCM3
% 13.57]; % VCM4
%
% QFSectorS = [
%  3.72 - .34/2   % Center of QF1
% 13.02 - .34/2]; % Center of QF2
%
% QDSectorS = [
%  4.34 - .18/2   % Center of QD1
% 12.24 - .18/2]; % Center of QD2
%
%
% BENDs=[];
% QFAs=[];
% BPMs=[];
% BBPMs=[];
% HCMs=[];
% VCMs=[];
% QFs=[];
% QDs=[];
% BPMlist=[];
% BPMlist1278=[];
% list18=[];
% list27=[];
% list36=[];
% list45=[];
% BSClist45=[];
% BPMlist2457=[];
% BPMlist1368=[];
% BPMlist3456=[];
% BPMlist234567=[];
% HCMlist=[];
% VCMlist=[];
% CMlist1278=[];
% CMlist2457=[];
% QFlist=[];
%
% for Sector =1:12
% 	BENDs = [BENDs;
% 	         BENDSectorS+(Sector-1)*SectorLength];
%
% 	QFAs = [QFAs;
% 	        QFASectorS+(Sector-1)*SectorLength];
%
% 	BPMs = [BPMs;
% 	        BPMSectorS+(Sector-1)*SectorLength];
%
% 	BBPMs = [BBPMs;
% 	        BBPMSectorS+(Sector-1)*SectorLength];
%
% 	HCMs = [HCMs;
% 	        HCMSectorS+(Sector-1)*SectorLength];
%
% 	VCMs = [VCMs;
% 	        VCMSectorS+(Sector-1)*SectorLength];
%
% 	QFs  = [QFs;
% 	        QFSectorS+(Sector-1)*SectorLength];
%
% 	QDs  = [QDs;
% 	        QDSectorS+(Sector-1)*SectorLength];
%
% 	BPMlist = [BPMlist;
% 	           Sector 1;
% 	           Sector 2;
% 	           Sector 3;
% 	           Sector 4;
% 	           Sector 5;
% 	           Sector 6;
% 	           Sector 7;
% 	           Sector 8;];
%
% 	BPMlist1278 = [BPMlist1278;
% 	               Sector 1;
% 	               Sector 2;
% 	               Sector 7;
% 	               Sector 8;];
%
% 	list18 = [list18;
% 	          Sector 1;
% 	          Sector 8;];
%
% 	list27 = [list27;
% 	          Sector 2;
% 	          Sector 7;];
%
% 	list36 = [list36;
% 	          Sector 3;
% 	          Sector 6;];
%
% 	list45 = [list45;
% 	          Sector 4;
% 	          Sector 5;];
%
%    if (Sector == 4) | (Sector == 8) | (Sector == 12)
% 	   BSClist45 = [BSClist45;
% 	          Sector 4;
%              Sector 5;];
%    end
%
% 	BPMlist2457 = [BPMlist2457;
%  	               Sector 2;
% 	               Sector 4;
% 	               Sector 5;
% 	               Sector 7;];
%
%
% 	BPMlist1368 = [BPMlist1368;
% 	               Sector 1;
% 	               Sector 3;
% 	               Sector 6;
% 	               Sector 8;];
%
% 	BPMlist3456 = [BPMlist3456;
% 	               Sector 3;
% 	               Sector 4;
% 	               Sector 5;
% 	               Sector 6;];
%
% 	BPMlist234567 = [BPMlist234567;
% 	                 Sector 2;
% 	                 Sector 3;
% 	                 Sector 4;
% 	                 Sector 5;
% 	                 Sector 6;
% 	                 Sector 7;];
%
% 	HCMlist = [HCMlist;
% 	           Sector 1;
% 	           Sector 2;
% 	           Sector 3;
% 	           Sector 4;
% 	           Sector 5;
% 	           Sector 6;
% 	           Sector 7;
% 	           Sector 8;];
%
% 	VCMlist = [VCMlist;
% 	           Sector 1;
% 	           Sector 2;
% 	           Sector 4;
% 	           Sector 5;
% 	           Sector 7;
% 	           Sector 8;];
%
% 	CMlist1278 = [CMlist1278;
% 	              Sector 1;
% 	              Sector 2;
% 	              Sector 7;
% 	              Sector 8;];
%
% 	CMlist2457 = [CMlist2457;
%  	              Sector 2;
% 	              Sector 4;
% 	              Sector 5;
% 	              Sector 7;];
%
% 	QFlist = [QFlist;
% 	          Sector 1;
% 	          Sector 2;];
% end
%
% QDlist = QFlist;
%
% elem18 = dev2elem('BPMx', list18);
% elem27 = dev2elem('BPMx', list27);
% elem36 = dev2elem('BPMx', list36);
% elem45 = dev2elem('BPMx', list45);
% BSCelem45 = dev2elem('BPMx', BSClist45);
%
%
% % Remove correctors in sector 1 & 12
% [nrows,ncols]=size(HCMlist); HCMlist=HCMlist(2:nrows-1,:); HCMs=HCMs(2:nrows-1,:);
% [nrows,ncols]=size(VCMlist); VCMlist=VCMlist(2:nrows-1,:); VCMs=VCMs(2:nrows-1,:);
% [nrows,ncols]=size(CMlist1278); CMlist1278=CMlist1278(2:nrows-1,:);
%
% % Convert to elem
% BPMelem=dev2elem('BPMx', BPMlist);
% BPMelem1278=dev2elem('BPMx', BPMlist1278);
% BPMelem1368=dev2elem('BPMx', BPMlist1368);
% BPMelem234567=dev2elem('BPMx', BPMlist234567);
%
% HCMelem=dev2elem('HCM', HCMlist);
% VCMelem=dev2elem('VCM', VCMlist);
%
% CMelem1278=dev2elem('HCM', CMlist1278);
% CMelem2457=dev2elem('VCM', CMlist2457);
%
% BPMs1278 = BPMs(BPMelem1278);
%
%
%
% % Golden and offset orbits
%
% % BPMs
% Xgolden = getgoldenorbit('BPMx');
% Ygolden = getgoldenorbit('BPMy');
%
% Xoffset = getoffsetorbit('BPMx');
% Yoffset = getoffsetorbit('BPMy');
%
% % IDBPMS
% IDXgolden = zeros(24,1);
% IDXgolden(IDBPMelem,:) = getgoldenorbit('IDBPMx');
%
% IDYgolden = zeros(24,1);
% IDYgolden(IDBPMelem,:) = getgoldenorbit('IDBPMy');
%
% IDXoffset = zeros(24,1);
% IDXoffset(IDBPMelem,:) = getoffsetorbit('IDBPMx');
%
% IDYoffset = zeros(24,1);
% IDYoffset(IDBPMelem,:) = getoffsetorbit('IDBPMy');
%
% % BBPMS
% BXgolden = zeros(24,1);
% BXgolden(BBPMelem,:) = getgoldenorbit('BBPMx');
%
% BYgolden = zeros(24,1);
% BYgolden(BBPMelem,:) = getgoldenorbit('BBPMy');
%
% BXoffset = zeros(24,1);
% BXoffset(BBPMelem,:) = getoffsetorbit('BBPMx');
%
% BYoffset = zeros(24,1);
% BYoffset(BBPMelem,:) = getoffsetorbit('BBPMy');
%
%
%
% % Chromaticity matrix at 1.5 GeV,  delChro = Mchro * [delSF;delSD]
% % GLOBAL_SR_CHROMATICITY_MATRIX =  [ 0.1500   -0.0520
% %                                   -0.0233    0.2220];
% % GLOBAL_SR_CHROMATICITY_MATRIX = (1.5/GLOBAL_SR_GEV) * GLOBAL_SR_CHROMATICITY_MATRIX;
% % inv(Mchro) = [6.9188 1.6206;
% %                .7272 4.6748];
%
% % Chromaticity matrix at 1.9 GeV,  delChro = Mchro * [delSF;delSD]		(2002-02-19)
% GLOBAL_SR_CHROMATICITY_MATRIX =  [ 0.0876   -0.0269
%                                   -0.0340    0.1689];
% GLOBAL_SR_CHROMATICITY_MATRIX = (1.9/GLOBAL_SR_GEV) * GLOBAL_SR_CHROMATICITY_MATRIX;
%
%
% % Transfer matrix - Current to Tune at 1.5 GeV,  delTune = Mtune * [delQF;delQD]
% % Mtune = [ 0.1791   -0.0260
% %          -0.1390    0.1729];      % 8/16/94
% % Mtune = (1.5/GLOBAL_SR_GEV) * Mtune;
%
% % Transfer matrix - Current to Tune at 1.9 GeV,  delTune = Mtune * [delQF;delQD]		(2002-02-19)
% Mtune = [ 0.1944   -0.0286
% 		   -0.1182    0.1526];
% Mtune = (1.9/GLOBAL_SR_GEV) * Mtune;
% GLOBAL_SR_TUNE_MATRIX = Mtune;
%
%
%
% % Load S-matrix
%
% % Should use getsmatelements !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Sx = getsmatelements('BPMx', BPMlist, 'HCM', HCMlist);
% Sy = getsmatelements('BPMy', BPMlist, 'VCM', VCMlist);
%
% % Change S-matrix to 96x96
% Sxmat=zeros(96,96);
% Sxmat(:,HCMelem)=Sx;
% Symat=zeros(96,96);
% Symat(:,VCMelem)=Sy;
%
% SIDx = getsmatelements('IDBPMx', IDBPMlist, 'HCM', HCMlist);
% SIDy = getsmatelements('IDBPMy', IDBPMlist, 'VCM', VCMlist);
%
% SIDxmat = zeros(24,96);
% SIDxmat(IDBPMelem, HCMelem) = SIDx;
% SIDymat = zeros(24,96);
% SIDymat(IDBPMelem, VCMelem) = SIDy;
%
%
%
% % ALS Distances, BPMs, BENDs, QFAs, ...
% load([GLOBAL_ALSDATA_DIRECTORY,'als_s']);
%
%
%
%
%
% % Load Beta & Phase advance
% %[BetaX, BetaY] = betadata;
% %[PhiX, PhiY] = phidata;
%
%
% % Load BPM standard deviation data (4-8-96 data, 375 averages in BPMs)
% %  load([GLOBAL_ALSDATA_DIRECTORY,'bpmstd']);
%
%
% % Load Dmat
% %if Dmatopt == 1
% %  disp('  D-matrix without sextupoles.');
% %  load([GLOBAL_ALSDATA_DIRECTORY,'dmatnos']);
% %
% %  % Change S-matrix to 96x96
% %  Dxmat=zeros(96,96);
% %  Dxmat(BPMelem, HCMelem) = Dx;
% %
% %  Dymat=zeros(96,96);
% %  Dymat(BPMelem, VCMelem) = Dy;
% %elseif Dmatopt == 0
% %  disp('  D-matrix with sextupoles.');
% %  load([GLOBAL_ALSDATA_DIRECTORY,'dm10-25']);
% %
% %  % Change S-matrix to 96x96
% %  Dxmat=zeros(96,96);
% %  Dxmat(BPMelem, HCMelem) = Dx;
% %
% %  Dymat=zeros(96,96);
% %  Dymat(BPMelem, VCMelem) = Dy;
% %end
%
