function [image_out] = snap(cam_name,varargin)

error('snap is deprecated. Use getcameradata instead.');

% SNAP
%
% Snaps an image from a CCD camera, specified by string c
%
%function [image] = snap(cam_name)

if nargin > 1 && strcmpi(varargin{1},'plot')
    plotimage = 1;
else
    plotimage = 0;
end
    
%cam_name = c
%c = cam_name;




% disp('starting snap')
% open CA to camera PVs
h1 = getpv([cam_name ':HEIGHT_MONITOR']);
h2 = getpv([cam_name ':WIDTH_MONITOR']);
h3 = getpv([cam_name ':DATA_MONITOR']);
h4 = getpv([cam_name ':EUID_MONITOR']);
h5 = getpv([cam_name ':ISO_STATUS']);
h6 = getpv([cam_name ':COUNTER_MONITOR']);
h7 = getpv([cam_name ':BPP_MONITOR']);
h8 = getpv([cam_name ':TRIGGER_MODE_STATUS']);
h9 = getpv([cam_name ':TRIGGER_ON_OFF_STATUS']);
h10 = getpv([cam_name ':TRIGGER_DELAY_MONITOR']);
h11 = getpv([cam_name ':FRAMERATE_STATUS']);
h12 = getpv([cam_name ':MODE_STATUS']);
h13 = getpv([cam_name ':SHUTTER_MONITOR']);
h14 = getpv([cam_name ':SHUTTER_MODE_STATUS']);
h15 = getpv([cam_name ':EXPOSURE_MONITOR']);
h16 = getpv([cam_name ':EXPOSURE_MODE_STATUS']);
h17 = getpv([cam_name ':GAIN_MONITOR']);
h18 = getpv([cam_name ':GAIN_MODE_STATUS']);
h19 = getpv([cam_name ':WOFFSET_MONITOR']);
h20 = getpv([cam_name ':HOFFSET_MONITOR']);
h21 = getpv([cam_name ':BRIGHTNESS_MONITOR']);
h22 = getpv([cam_name ':BRIGHTNESS_MODE_STATUS']);
%h23 = getpv([cam_name ':XP_MONITOR']);
%h24 = getpv([cam_name ':YP_MONITOR']);

% get the PV through CA
height = (h1);
width = (h2);
iso_status = (h5);
% pre allocate memory
data = zeros(1,786432);
if iso_status == 0
    setpv([cam_name ':ISO_STATUS'],1);
    data = h3;
    setpv([cam_name ':ISO_STATUS'],0);
else
    data =h3;
end
euid = h4;

counter = h6;
BPP = h7;
trigger_mode = h8;
trigger_on_off = h9;
trigger_delay = h10;
framerate_status = h11;
mode1 = h12;
shutter_monitor = h13;
shutter_mode = h14;
exposure_monitor = h15;
exposure_mode = h16;
gain_monitor = h17;
gain_mode = h18;
WOFFSET = h19;
HOFFSET = h20;
brightness_monitor = h21;
brightness_mode = h22;
% XP = h23;
% YP = h24;




% change single row vector to 2-D matrix:
x=reshape(data, width, height);

image_out = x';

if plotimage
    % intensity of RGB high
    figure(61);

    % imagesc(x);
    imagesc(x');
    colormap gray;
end




% fprintf('height is %g pixels.\nwidth is %g pixels.\neiud is %s.\n',height,width,euid)
% fprintf('counter is %g.\ntrigger_mode is %g.\n',counter,trigger_mode)
% if framerate_status == 0
%     fprintf('framerate is 1.875.\n')
% elseif framerate_status == 1
%     fprintf('framerate is 3.75.\n')
% elseif framerate_status == 2
%     fprintf('framerate is 7.5.\n')
% elseif framerate_status == 3
%     fprintf('framerate is 15.\n')
% elseif framerate_status == 4
%     fprintf('framerate is 35.\n')
% elseif framerate_status == 5
%     fprintf('framerate is 60.\n')
% end;
% if iso_status == 1
%     fprintf('iso is on.\n')
% else
%     fprintf('iso is off.\n')
% end
% if trigger_on_off == 1
%     fprintf('trigger is on.\n')
% else
%     fprintf('trigger is off.\n')
% end;
% fprintf('trigger_delay is %g.\n',trigger_delay)
% fprintf('mode1 is %g.\nshutter_monitor is %g.\nshutter_mode is %g.\n',mode1,shutter_monitor,shutter_mode)
% fprintf('exposure_monitor is %g.\nexposure_mode is %g.\ngain_monitor.\n',exposure_monitor,exposure_mode,gain_monitor)
% fprintf('WOFFSET is %g.\nHOFFSET is %g.\nbrightness_monitor is %g.\n',WOFFSET,HOFFSET,brightness_monitor)
% %fprintf('brightness_mode is %g.\nXP is %g.\nYP is %g.\nBPP is %g.\n',brightness_mode,XP,YP,BPP)
% fprintf('brightness_mode is %g.\nBPP is %g.\n',brightness_mode,BPP)


%if isnan(XP)
%    fprintf('***** Question Everything. NaN. *****\n');
%end
%if isnan(YP)
%    fprintf('***** Don''t believe everything you read. NaN. *****\n');
%end

% disp('snap finished')
