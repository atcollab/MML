function ramp = readramp3Hz(varargin)
%READRAMP3HZ - Read a binary ramp input file for SLS 3Hz Powersupplies
% 
% INPUTS
% 1. Filename {optional}
% 
% OUPUTS
% 1. Ramp - Booster ramp read from binary file 
%
% See also write_ramp3Hz

%
% Written by Laurent S. Nadolski

%% Default flags
DisplayFlag = 1;
AbcissaUnit = 80; % 80us - range from 80us upto 100ms

% Parse input options
InputFlags = {};
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end

if isempty(varargin)
    [filename, pathname] = uigetfile({'*.bin'}, 'Pick a file');
    filename = [pathname filename];
else
    filename= varargin{1};
    if ~exist(filename,'file')
        error('Filename does not exist')
    end
end

fid = fopen(filename, 'r');

%Lit l'entete de 4 octets : nombre de points
entete = fread(fid,1,'int32=>int32');
%% 12500 points (50 000 octets) : 4 octets en virgule flotante
ramp = fread(fid,12500,'float32=>float32');
%% 4 octets de fin de fichiers
fin  = fread(fid,'float32=>float32');
fclose(fid);

x = (0:12499)*AbcissaUnit*1e-6;

if (DisplayFlag)
    plot(x,ramp)
    grid on
    title('Rampe Booster')
    xlabel('Time (s)')
    ylabel('Amplitude')
end