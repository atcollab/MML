function [GapsLongitudinal, Gaps, HCMtable1, HCMtable2, VCMtable1, VCMtable2] = fftableepu(Sector, GeVnum)
% [GapsLongitudinal, Gaps, HCMtable1, HCMtable2, VCMtable1, VCMtable2] = fftableepu(Sector, GeV)
%
%   This function gets the feed forward tables.
%
%   Sector = the storage ring sector number for that insertion device
%   GeV    = the storage ring energy (1.0, 1.3, 1.5, 1.9)
%
%   If no input auguments are used, a dialog box will allow one
%   to choose any feed forward table.  Table are grouped in directories
%   according and energy and the date the file was generated.  The most
%   recent table is located in w:\public\matlab\gaptrack.
%

GapsLongitudinal =[]; Gaps =[]; HCMtable1 =[]; HCMtable2 =[]; VCMtable1 =[]; VCMtable2 =[];

tableQ = [];

if nargin == 0
    % Load the data tables
    CurrentDir = pwd;
    gotoffdata;
    [Datafn, DirStr] = uigetfile('*.mat', 'Choose the desired feed forward file.');
    cd(CurrentDir);
    if Datafn == 0
        disp('   Function canceled.');
        disp(' ');
    else
        load([DirStr, Datafn]);
    end
    return
end
if nargin < 2
    global GLOBAL_SR_GEV
    GeVnum = GLOBAL_SR_GEV;
end
if nargin < 3
    DirStr = getfamilydata('Directory','DataRoot');
    i = findstr(DirStr,filesep);
    DirStr = DirStr(1:i(end-2));
    DirStr = fullfile(DirStr, 'srdata', 'gaptrack', filesep);
end

if size(Sector,2) == 1
    Sector = [Sector 1];
end
GeVstr = sprintf('%.1f',GeVnum);


Datafn = sprintf('epu%02dd%dm0e%c%c.mat', Sector(1,:), GeVstr(1), GeVstr(3));  % Parallel mode (circular/eliptical mode)
%Datafn = sprintf('epu%02dm1e%c%c.mat', Sector, GeVstr(1), GeVstr(3)); % Anti-parallel mode (linear mode)
%Datafn = sprintf('epu%02de%c%c.mat', Sector, GeVstr(1), GeVstr(3));   % Old file name


Datafn = [DirStr, Datafn];
if exist(Datafn,'file')
    % OK
else
    Datafn = upper(Datafn);
    if ~exist(Datafn,'file')
        fprintf('\n   %s feed forward file not found.\n\n', Datafn);
        tableX = []; tableY = [];
        return
    end
end

load(Datafn);

