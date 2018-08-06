function [ring] = umerbuildsetpoints(file_dir)
%
% INPUT:
%   file_dir - a string of the directory location to the magnet csv file to load.
%
% OUTPUT:
%   ring - a cell array containing struct objects of all elements in UMER
%       struct field:
%           Name - element name
%           Current - current value currently set on element
%           ReadCurrent - read back current from magnets (call set_ring)
%
%
% Created 27 Nov 2016
% Levon D.
%
% NOTES
%
%

ad = getad;

if nargin < 1
    file_dir = [ad.Directory.OpsData,ad.magnetSetpointsfile];
end

% Check to see if .csv is included or not
try
    f_ext = file_dir(end-3:end);
    if ~strcmp(f_ext,'.csv')
        % Check to see if some other extension is used
        if ~strcmp(f_ext(1),'.')
            % No extension, add in csv
            file_dir = strcat(file_dir,'.csv');
        end
    end
catch
    error('something is wrong with your file name!')
end

try
    % grab data in a Nx3 cell array of strings
    % from input file, just grab Names and Currents and Read Currents
    fileID = fopen(file_dir);
    data_input = textscan(fileID,'%s %s %s','Delimiter',',');
    fclose(fileID);
catch
    error('something is wrong with your directory location!')
end

%% Construct thering cell array

N = length(data_input{1})-1; %ignore header
ring = cell(N,1);

for i = 1:N
    
    temp = struct();
    temp.Name = data_input{1}{i+1}; % set magnet name
    temp.Current = str2num(data_input{2}{i+1}); %set magnet current
    try
        temp.ReadCurrent = str2num(data_input{3}{i+1}); % set magnet readcurrent
    catch
        temp.ReadCurrent = str2num(data_input{2}{i+1}); %temporarily set readcurrent to current
    end   
    ring{i} = temp;
end


end