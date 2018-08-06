function write_goldenorbit_ffb_2planes(Plane, GoldenOrbit, BPMlist)
%WRITE_GOLDENORBIT_FFTB_2PLANES - Sets the BPM setpoints which are used by the fast feedback system
%  write_goldenorbit_ffb_2planes(Plane, GoldenOrbit, BPMlist)
%
%  Christoph Steier, August 2002
%
%  6-19-06 T.Scarvie, modified to work with new Matlab Middle Layer
%
% 2013-01-02 C. Steier, simplified code (faster) sinced distinction between
% straight and arc BPMs is not necessary anymore


if nargin ~= 3
    error('write_goldenorbit_ffb_2planes needs 3 input arguments');
end

if Plane == 1
    ChannelName = family2channel('BPMx',BPMlist);
elseif Plane == 2
    ChannelName = family2channel('BPMy',BPMlist);
else
    error('Unknown plane.');
end

% for loop=size(ChannelName,1):-1:1
%     if strfind(ChannelName(loop,:),':')
%         ChannelName(loop,:)=[];
%         GoldenOrbit(loop)=[];
%     end
% end

% Change to setpoint
ChannelName(:,end-2) = 'C'; 

% As of 2010, all sectors have XT and YT channels in all arcs (and are
% located on FFB crates) - Csteier, 2010-02-25

setpvonline(ChannelName, GoldenOrbit);


