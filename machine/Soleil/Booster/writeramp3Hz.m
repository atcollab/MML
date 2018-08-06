function writeramp3Hz(varargin)
%WRITERAMP3HZ - Write a binary ramp input file for SLS 3Hz Powersupplies
% 
% INPUTS
% 1. ramp - 1D numeric ramp 
% 2. Filename {optional}
% 
% OUPUTS
% 
% NOTES
% 1. Time vector is not specified for it is a Tango property of 3Hz
% powersupply dserver
%
% See also read_ramp3Hz

%
% Written by Laurent S. Nadolski

%
% TODO: directory to saved data

% % Exemple de rampe de nb points
% nb = 5000;
% data1=zeros(1,12500);
% t=(0:nb-1)/nb;
% data1(1,1:nb) = cos(pi*(t-1/2)).*cos(2*pi*(t-1/4));

if isempty(varargin)
  error('Missing argument');
end

data1 = varargin{1};
varargin{1} = [];

if isempty(varargin)
    [filename, pathname] = uigetfile({'*.bin'}, 'Saved file');
    filename = [pathname filename];
else
    filename= varargin{2};
    if ~exist(filename,'file')
        error('Filename does not exist')
    end
end

fid = fopen(filename, 'wb');
%Nombre de points utilisé dans la rampe
% 'A0 0F 00 00'
fwrite(fid, hex2dec('A00F0000'),'uint32','b');
%fwrite(fid, int32(4000),'int32');
%% 12500 points (50000 octets) : 4 octets en virgule flotante
fwrite(fid, data1,'float32');
%% 4 octets de fin de fichiers
% 'FF FF FF FF'
%fwrite(fid, int64(4.294967295000000e+09),'uint32');
fwrite(fid, hex2dec('FFFFFFFF'),'uint32','b');
fclose(fid);
