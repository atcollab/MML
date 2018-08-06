function [tableX, tableY, tableQ] = fftable(Sector, GeVnum, DirStr)
% [tableX, tableY, tableQ] = fftable(Sector, GeV, Directory)
%            or
% [tableX, tableY, tableQ] = fftable
%
%   This function loads a feed forward table.
%
%   Sector    = the storage ring sector number for that insertion device
%   GeV       = the storage ring energy (1.0, 1.3, 1.5, 1.9)
%   Directory = the directory location where the files are located.  To directory "tree"
%               from the root or w:\public\matlab\gaptrack.
%
%   For example, fftable(7,1.5) loads the most recently generated table for sector 7
%   at 1.5 GeV.
%
%   If no input auguments are used, a dialog box will allow one
%   to choose any feed forward table.  Table are grouped in directories
%   according and energy and the date the file was generated.  The most
%   recent table is located in w:\public\matlab\gaptrack.
%


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

if any(Sector(1) == [4 6 11])
    % ????? which one is right
    Datafn = sprintf('id%02dd%de%c%c.mat', Sector(1,:), GeVstr(1), GeVstr(3));
else
    Datafn = sprintf('id%02de%c%c.mat', Sector(1), GeVstr(1), GeVstr(3));
end

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

