function generate_init(filename)

% This function generates some of the more basic and repetitious aspects of
% creating an init file.
%
% Notes: When generating the string elements in the definitions below, they
% have to be all the same length. If the actual string is short you have to
% padd it with spaces.
%
% Eugene
% ETan 14/12/04 Changed family names to coincide with controls definition
% of families.
% ETan 30/09/05 Added skew quads (SQ) and updated fields to be printed for
% version 4 of the lattice and ao init file. Cleaned up some of the fields
% to remove some redudent info that was left over from SPEAR that we don't
% use.
% ETan 01/06/06 Updating for new naming convention and the addition of
% other elements such as FTBPM (first turn bpm). Also removed some fields
% that are generated, eg range. At ASP most ranges are constant so no need
% for individual assignment. Removed DeltaResp and moved assignment to the
% end of the AO element definitions. This is for use with version 5 of the
% init skeleton file.

filename = 'aspinit';
skeleton_filename = 'aspinit_v5skeleton.m';

if ~exist('filename','var')
    disp('Use: generate_init([filaname]).');
    return
end

[fin,message]=fopen(skeleton_filename,'r');
if fin==-1
  disp(['   WARNING: Unable to open file :' skeleton_filename]);
  disp(message);
  return
end
disp(['   Reading skeleton file: ' skeleton_filename]);
skeleton_dir = fileparts(which(skeleton_filename));

filename = appendtimestamp(filename, now);
[fid,message]=fopen(fullfile(skeleton_dir,[filename '.m']),'w');
if fid==-1
  disp(['   WARNING: Unable to open file :' filename '.m']);
  disp(message);
  return
end
disp(['   Writing init file to: ' filename '.m']);

% Some basic parameters
n_cell = 14;         % Number of repeated sectors
zeropad = 3;         % zero padding for numbers works eqally well with %03d
namepad = 8;         % space padding for common names
chanpad = 25;        % space padding for channel names

line = '';

% Read and insert comment line to tell that the init file "parameters" have
% been generated from which version of the "skeleton" file.
while isempty(strfind(line,'% === Generated from ==='))
    if feof(fin)
        error('Unexpected eof while looking for "generated by" header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
fprintf(fid,'%s',line);
fprintf(fid,'%% %s\n',skeleton_filename);
line = fgets(fin);

% BPM
% x-name       x-chname       xstat y-name       y-chname     ystat DevList  Elem
% bpm={
% '1BPMx1  '	'SR01BPM01:H             '	1	'1BPMy1  '	'SR01BPM01:V             '	1	[1,1]	1; ...
while isempty(strfind(upper(line),'INSERT BPM HERE'))
    if feof(fin)
        error('Unexpected eof while looking for BPM header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('BPMs\n');
n_percell = 7;
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    xname = sprintf('%dBPMx%d',cell,el_number); xname = strpad(xname, namepad);
    xchname = sprintf('SR%02dBPM%02d:SA_HPOS_MONITOR',cell,el_number); xchname = strpad(xchname, chanpad);
    yname = sprintf('%dBPMy%d',cell,el_number); yname = strpad(yname, namepad);
    ychname = sprintf('SR%02dBPM%02d:SA_VPOS_MONITOR',cell,el_number); ychname = strpad(ychname, chanpad);
    xstat = 1; ystat = 1;
    fprintf(fid,'''%s''\t''%s''\t%d\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t; ...\n',...
              xname,xchname,xstat,yname,ychname,ystat,cell,el_number,i);
end

% BPM
% x-name       x-chname       xstat y-name       y-chname     ystat DevList  Elem
% bpm={
% '1BPMx1  '	'SR01BPM01:H             '	1	'1BPMy1  '	'SR01BPM01:V             '	1	[1,1]	1; ...
while isempty(strfind(upper(line),'INSERT FT HERE'))
    if feof(fin)
        error('Unexpected eof while looking for FT header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('FT BPMs\n');
n_percell = 7;
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    xname = sprintf('%dFTx%d',cell,el_number); xname = strpad(xname, namepad);
    xchname = sprintf('SR%02dBPM%02d:FT_HPOS_MONITOR',cell,el_number); xchname = strpad(xchname, chanpad);
    yname = sprintf('%dBPMy%d',cell,el_number); yname = strpad(yname, namepad);
    ychname = sprintf('SR%02dBPM%02d:FT_VPOS_MONITOR',cell,el_number); ychname = strpad(ychname, chanpad);
    xstat = 1; ystat = 1;
    fprintf(fid,'''%s''\t''%s''\t%d\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t; ...\n',...
              xname,xchname,xstat,yname,ychname,ystat,cell,el_number,i);
end


% Correctors
% 
% NOTE: CHANGED THE STRUCTURE OF THE DEFINITION OF THE CORRECTRO MAGNETS.
% SPEAR USES INDIVIDUAL CORRECTORS THAT CAN BE CONFIGURED TO BE USED AS
% EITHER HORIZONTAL OR VERTICAL CORRECTORS. ASP CORRECTORS ARE BUILT INTO
% THE SEXTUPOLES AND ARE EFFICEVELY FIXED. THERE ARE 42 HORIZONTAL
% CORRECTORS AND 56 VERTICAL CORRECTORS.
%
% HW in ampere, Physics in radian. Respmat settings below AO definitions.
% x-common          x-monitor                 x-setpoint         stat devlist elem tol
% cor={
%  '1CX1    ' 'SR01CPS01:CURRENT_MONITOR' 'SR01CPS01:CURRENT_SP'  1  
%  '1CY1    ' 'SR01CPS02:CURRENT_MONITOR' 'SR01CPS02:CURRENT_SP'  1   [1 ,1]  1  0.750 ; ...

while isempty(strfind(upper(line),'INSERT HCM HERE'))
    if feof(fin)
        error('Unexpected eof while looking for HCM header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('HCM\n');

n_percell = 3;
vec = [1 5 9];
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    xname = [num2str(cell) 'HCM' num2str(el_number)]; xname = strpad(xname, namepad);
    xmon = sprintf('SR%02dCPS%02d:CURRENT_MONITOR',cell, vec(el_number)); xmon = strpad(xmon, chanpad);
    xset = sprintf('SR%02dCPS%02d:CURRENT_SP',cell, vec(el_number)); xset = strpad(xset, chanpad);
    xstat = 1;
    % Range in amps and the response amplitude kicks are in radians.
    tol = 1;
    fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t%5.3f\t; ...\n',...
              xname,xmon,xset,xstat,cell,el_number,i,tol);
end

while isempty(strfind(upper(line),'INSERT VCM HERE'))
    if feof(fin)
        error('Unexpected eof while looking for VCM header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('VCM\n');

n_percell = 4;
vec = [2 4 6 7];
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    yname = [num2str(cell) 'VCM' num2str(el_number)]; yname = strpad(yname, namepad);
    ymon = sprintf('SR%02dCPS%02d:CURRENT_MONITOR',cell, vec(el_number)); ymon = strpad(ymon, chanpad);
    yset = sprintf('SR%02dCPS%02d:CURRENT_SP',cell, vec(el_number)); yset = strpad(yset, chanpad);
    ystat = 1;
    % Range in amps and the response amplitude kicks are in radians.
    tol = 1;
    fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t%5.3f\t; ...\n',...
              yname,ymon,yset,ystat,cell,el_number,i,tol);
end


% Magnets
%common           desired                   monitor              setpoint           stat devlist elem   scalefactor    range    tol   respkick
% bend={
%  '1BEND1    '    'SR-BD:CurrSetptDes '    'SR-BD:Curr    '    'SR-BD:CurrSetpt  '  1   [1 ,1]  1         1.0        [0, 500] 0.050   0.05     ; ...
while isempty(strfind(upper(line),'INSERT BEND HERE'))
    if feof(fin)
        error('Unexpected eof while looking for BEND header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('BEND\n');
n_percell = 2;
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    name = [num2str(cell) 'BEND' num2str(el_number)]; name = strpad(name, namepad);
    monitor = 'SR00DPS01:CURRENT_MONITOR'; monitor = strpad(monitor, chanpad);
    setpoint= 'SR00DPS01:CURRENT_SP'; setpoint = strpad(setpoint, chanpad);
    stat = 1;
    scalefactor_tol = '1.0 0.05';
    fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t%s\t; ...\n',...
              name,monitor,setpoint,stat,cell,el_number,i,scalefactor_tol);
end

%common         desired                    monitor               setpoint            stat devlist  elem  scalefactor    range    tol  respkick
% qf={
%  '2QF1    '    'MS1-QF:CurrSetptDes  '    'MS1-QF:Curr     '    'MS1-QF:CurrSetpt   '  1   [2 ,1]    1   qf1to6factor   [0, 500] 0.050  0.05; ...
while isempty(strfind(upper(line),'INSERT QFA HERE'))
    if feof(fin)
        error('Unexpected eof while looking for QFA header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('QFA\n');
n_percell = 2;
vec = [1 6];
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    name = [num2str(cell) 'QFA' num2str(el_number)]; name = strpad(name, namepad);
    monitor = sprintf('SR%02dQPS%02d:CURRENT_MONITOR',cell, vec(el_number)); monitor = strpad(monitor, chanpad);
    setpoint = sprintf('SR%02dQPS%02d:CURRENT_SP',cell, vec(el_number)); setpoint = strpad(setpoint, chanpad);
    stat = 1;
    scalefactor_tol = '1.0  0.05';
    fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t%s\t; ...\n',...
              name,monitor,setpoint,stat,cell,el_number,i,scalefactor_tol);
end
while isempty(strfind(upper(line),'INSERT QDA HERE'))
    if feof(fin)
        error('Unexpected eof while looking for QDB header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('QDA\n');
n_percell = 2;
vec = [2 5];
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    name = [num2str(cell) 'QDA' num2str(el_number)]; name = strpad(name, namepad);
    monitor = sprintf('SR%02dQPS%02d:CURRENT_MONITOR',cell, vec(el_number)); monitor = strpad(monitor, chanpad);
    setpoint = sprintf('SR%02dQPS%02d:CURRENT_SP',cell, vec(el_number)); setpoint = strpad(setpoint, chanpad);
    stat = 1;
    scalefactor_tol = '1.0  0.05';
    fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t%s\t; ...\n',...
              name,monitor,setpoint,stat,cell,el_number,i,scalefactor_tol);
end
while isempty(strfind(upper(line),'INSERT QFB HERE'))
    if feof(fin)
        error('Unexpected eof while looking for QFB header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('QFB\n');
n_percell = 2;
vec = [3 4];
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    name = [num2str(cell) 'QFB' num2str(el_number)]; name = strpad(name, namepad);
    monitor = sprintf('SR%02dQPS%02d:CURRENT_MONITOR',cell, vec(el_number)); monitor = strpad(monitor, chanpad);
    setpoint = sprintf('SR%02dQPS%02d:CURRENT_SP',cell, vec(el_number)); setpoint = strpad(setpoint, chanpad);
    stat = 1;
    scalefactor_tol = '1.0  0.05';
    fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t%s\t; ...\n',...
              name,monitor,setpoint,stat,cell,el_number,i,scalefactor_tol);
end

% Sextupole
while isempty(strfind(upper(line),'INSERT SFA HERE'))
    if feof(fin)
        error('Unexpected eof while looking for SFA header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('SFA\n');
n_percell = 2;
vec = [1 7];
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    name = [num2str(cell) 'SFA' num2str(el_number)]; name = strpad(name, namepad);
    monitor = sprintf('SR%02dSPS%02d:CURRENT_MONITOR',cell, vec(el_number)); monitor = strpad(monitor, chanpad);
    setpoint = sprintf('SR%02dSPS%02d:CURRENT_SP',cell, vec(el_number)); setpoint = strpad(setpoint, chanpad);
    stat = 1;
    scalefactor_tol = '1.0  0.05';
    fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t%s\t; ...\n',...
              name,monitor,setpoint,stat,cell,el_number,i,scalefactor_tol);
end
while isempty(strfind(upper(line),'INSERT SDA HERE'))
    if feof(fin)
        error('Unexpected eof while looking for SDA header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('SDA\n');
n_percell = 2;
vec = [2 6];
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    name = [num2str(cell) 'SDA' num2str(el_number)]; name = strpad(name, namepad);
    monitor = sprintf('SR%02dSPS%02d:CURRENT_MONITOR',cell, vec(el_number)); monitor = strpad(monitor, chanpad);
    setpoint = sprintf('SR%02dSPS%02d:CURRENT_SP',cell, vec(el_number)); setpoint = strpad(setpoint, chanpad);
    stat = 1;
    scalefactor_tol = '1.0  0.05';
    fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t%s\t; ...\n',...
              name,monitor,setpoint,stat,cell,el_number,i,scalefactor_tol);
end
while isempty(strfind(upper(line),'INSERT SDB HERE'))
    if feof(fin)
        error('Unexpected eof while looking for SDB header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('SDB\n');
n_percell = 2;
vec = [3 5];
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    name = [num2str(cell) 'SDB' num2str(el_number)]; name = strpad(name, namepad);
    monitor = sprintf('SR%02dSPS%02d:CURRENT_MONITOR',cell, vec(el_number)); monitor = strpad(monitor, chanpad);
    setpoint = sprintf('SR%02dSPS%02d:CURRENT_SP',cell, vec(el_number)); setpoint = strpad(setpoint, chanpad);
    stat = 1;
    scalefactor_tol = '1.0  0.05';
    fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t%s\t; ...\n',...
              name,monitor,setpoint,stat,cell,el_number,i,scalefactor_tol);
end
while isempty(strfind(upper(line),'INSERT SFB HERE'))
    if feof(fin)
        error('Unexpected eof while looking for SFB header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('SFB\n');
n_percell = 1;
vec = [4];
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    name = [num2str(cell) 'SFB' num2str(el_number)]; name = strpad(name, namepad);
    monitor = sprintf('SR%02dSPS%02d:CURRENT_MONITOR',cell, vec(el_number)); monitor = strpad(monitor, chanpad);
    setpoint = sprintf('SR%02dSPS%02d:CURRENT_SP',cell, vec(el_number)); setpoint = strpad(setpoint, chanpad);
    stat = 1;
    scalefactor_tol = '1.0  0.05';
    fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t%s\t; ...\n',...
              name,monitor,setpoint,stat,cell,el_number,i,scalefactor_tol);
end

% skew quadrupoles
while isempty(strfind(upper(line),'INSERT SKQ HERE'))
    if feof(fin)
        error('Unexpected eof while looking for SKQ header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('SKQ\n');
n_percell = 2;
vec = [3 8];
ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    yname = [num2str(cell) 'SKQ' num2str(el_number)]; yname = strpad(yname, namepad);
    ymon = sprintf('SR%02dCPS%02d:CURRENT_MONITOR',cell, vec(el_number)); ymon = strpad(ymon, chanpad);
    yset = sprintf('SR%02dCPS%02d:CURRENT_SP',cell, vec(el_number)); yset = strpad(yset, chanpad);
    ystat = 1;
    % Range in amps and the response amplitude kicks are in radians.
    tol = '1';
    fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t%s\t; ...\n',...
              yname,ymon,yset,ystat,cell,el_number,i,tol);
end

% Kickers
%common        monitor                  setpoint                stat  devlist elem range    tol
% kickeramp={ 
%  'KICK1     '    'SR-014-K1:PulseAmpl  '     'SR-014-K1:PulseAmplSetpt  '  1   [1  ,1]  1  [0 9]  0.10 ; ...
%  'KICK2     '    'SR-014-K2:PulseAmpl  '     'SR-014-K2:PulseAmplSetpt  '  1   [1  ,2]  2  [0 9]  0.10 ; ...
%  'KICK3     '    'SR-001-K3:PulseAmpl  '     'SR-001-K3:PulseAmplSetpt  '  1   [1  ,3]  3  [0 9]  0.10 ; ...
%  'KICK4     '    'SR-001-K4:PulseAmpl  '     'SR-001-K4:PulseAmplSetpt  '  1   [1  ,4]  4  [0 9]  0.10 ; ...
%   };
while isempty(strfind(upper(line),'INSERT KICKERS HERE'))
    if feof(fin)
        error('Unexpected eof while looking for SFB header.')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('KICKERS\n');
n_kickers = 4;
sec = [14 1 1 2];
vec = [1 1 2 1];
for i=1:n_kickers
    name = ['KICK' num2str(i)]; name = strpad(name, namepad);
    monitor  = sprintf('SR%02dKPS%02d:VOLTAGE_MONITOR',sec(i), vec(i)); monitor = strpad(monitor, chanpad);
    setpoint = sprintf('SR%02dKPS%02d:VOLTAGE_SP',sec(i), vec(i)); setpoint = strpad(setpoint, chanpad);
    stat = 1;
    tol = '0.10';
    fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t[%d,%d]\t%d\t%s\t; ...\n',...
              name,monitor,setpoint,stat,1,i,i,tol);
end


% Continue to the end of the skeleton file
while ~feof(fin)
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
fprintf(fid,'%s',line);

fclose(fid);
fclose(fin);
disp(['Finished updating ' filename])


%========================================
function str = padzeros(val, charlen)

numstring = num2str(val);
diff = charlen - length(numstring);
temp = ' ';
temp(1:charlen) = ' ';
if diff > 0
    temp(1:diff) = '0';
    temp(diff+1:charlen) = numstring;
elseif diff == 0
    temp = numstring;
elseif diff < 0
    error(['Increase ''zeropad'' by at least: ' num2str(abs(diff))]);
end

str = temp;


%========================================
function str = strpad(instring, charlen)

diff = charlen - length(instring);
temp = ' ';
temp(1:charlen) = ' ';

if diff > 0
    temp(1:end-diff) = instring;
elseif diff == 0
    temp = instring;
elseif diff < 0
    error(['Increase ''space padding'' for names and channel names by at least: ' num2str(abs(diff))]);
end

str = temp;