function generate_hwinit(filename)

% This function generates some of the more basic and repetitious aspects of
% creating an init file.
%
% Notes: When generating the string elements in the definitions below, they
% have to be all the same length. If the actual string is short you have to
% padd it with spaces.
%
% Eugene
filename = 'hwinit';
skeleton_filename = 'hwinit_skeleton.m';

if ~exist('filename','var')
    disp('Use: generate_hwinit([filaname]).');
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

% Define some basic parameters and formatting.
n_cell = 14;
zeropad = 3;
namepad = 8;
chanpad = 24;
line = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ION PUMP CONTROLLERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% name      channel name            status  device  el
% vp={
% '1vp1    '  'SR-001-VP1              '  1   [1,1]   1;...
while isempty(strfind(upper(line),'INSERT IPC HERE'))
    if feof(fin)
        error('Unexpected eof while looking for ''INSERT IPC HERE''')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('IPC\n');

n_percell = 3;
ionPumpFile = 'ionpumps.csv'; % File where PVs for ion pumps are stored.
pumpPVs = textread(ionPumpFile,'%s');

ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    name = [num2str(cell) 'IPC' num2str(el_number)]; name = strpad(name, namepad);
    chname = pumpPVs{(cell-1)*n_percell + i}; chname = strpad(chname, chanpad);  % Skip the status pv names
    stat = 1;
    fprintf(fid,'''%s''\t''%s''\t%d\t[%d,%d]\t%d\t; ...\n',...
              name,chname,stat,cell,el_number,i);
end

while isempty(strfind(upper(line),'INSERT IPC POSITION'))
    if feof(fin)
        error('Unexpected eof while looking for ''INSERT IPC POSITION''')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';

% The position of VP has to be in a column vector
% base_ipc_positions_per_cell = [0 1.45 4.7661 6.1822 6.9983 8.6144 10.0305 11.3466 12.6627 13.9788];
base_ipc_positions_per_cell = [0 6.9983 10.0305];
fprintf(fid,'AO.IPC.Position = [');
for i=1:n_cell
    fprintf(fid,'%6.2f ', (i-1)*(216/n_cell) + base_ipc_positions_per_cell);
    if i ~= n_cell
        fprintf(fid,'\t...\n\t\t');
    else
        fprintf(fid,'\t]'';\n');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GAUGE CONTROLLERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% name      channel name            status  device  el
% vp={
% '1vp1    '  'SR-001-VP1              '  1   [1,1]   1;...
while isempty(strfind(upper(line),'INSERT GC HERE'))
    if feof(fin)
        error('Unexpected eof while looking for ''INSERT GC HERE''')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';
fprintf('GC\n');

n_percell = 5;
ionPumpFile = 'gauges.csv'; % File where PVs for ion pumps are stored.
pumpPVs = textread(ionPumpFile,'%s');

ntotal = n_percell*n_cell;
for i=1:ntotal
    cell = ceil(i/n_percell);
    el_number = mod(i,n_percell);
    if el_number == 0 el_number = n_percell; end
    name = [num2str(cell) 'GC' num2str(el_number)]; name = strpad(name, namepad);
    chname = pumpPVs{(cell-1)*n_percell + i}; chname = strpad(chname, chanpad); % Skip the status pv names
    stat = 1;
    fprintf(fid,'''%s''\t''%s''\t%d\t[%d,%d]\t%d\t; ...\n',...
              name,chname,stat,cell,el_number,i);
end

while isempty(strfind(upper(line),'INSERT GC POSITION'))
    if feof(fin)
        error('Unexpected eof while looking for ''INSERT GC POSITION''')
    end
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
line = '';

% The position of VP has to be in a column vector
% base_ipc_positions_per_cell = [0 1.45 4.7661 6.1822 6.9983 8.6144 10.0305 11.3466 12.6627 13.9788];
base_ipc_positions_per_cell = [10.0305-0.1, 10.0305, 10.0305+0.1, 12.6627-0.1, 12.6627];
fprintf(fid,'AO.GC.Position = [');
for i=1:n_cell
    fprintf(fid,'%6.2f ', (i-1)*(216/n_cell) + base_ipc_positions_per_cell);
    if i ~= n_cell
        fprintf(fid,'\t...\n\t\t');
    else
        fprintf(fid,'\t]'';\n');
    end
end

% Continue to the end of the skeleton file
while ~feof(fin)
    fprintf(fid,'%s',line);
    line = fgets(fin);
end
fprintf(fid,'%s',line);

fclose(fid);
fclose(fin);
disp('Finished updating hwinit')


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