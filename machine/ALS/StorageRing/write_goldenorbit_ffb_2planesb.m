function write_goldenorbit_ffb_2planesb(Plane, GoldenOrbit, BPMlist, GoldenOrbit2, BPMlist2)
%WRITE_GOLDENORBIT_FFTB_2PLANESB - Sets the BPM setpoints which are used by the fast feedback system
%  write_goldenorbit_ffb_2planesb(Plane, GoldenOrbit, BPMlist, GoldenOrbit2, BPMlist2)
%
%  Christoph Steier, August 2002
%
%  6-19-06 T.Scarvie, modified to work with new Matlab Middle Layer
%
% 2013-01-02 C. Steier, simplified code (faster) sinced distinction between
% straight and arc BPMs is not necessary anymore


if nargin ~= 5
    error('write_goldenorbit_ffb_2planesb needs 5 input arguments');
end

if Plane == 1
    ChannelName = family2channel('BPMx',BPMlist);
    setpv('BPM', 'XGoldenSetpoint', GoldenOrbit2, BPMlist2);
elseif Plane == 2
    ChannelName = family2channel('BPMy',BPMlist);
    setpv('BPM', 'YGoldenSetpoint', GoldenOrbit2, BPMlist2);
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




