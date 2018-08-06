function [image_out] = snap(cam_name,varargin)
% SNAP
%
% Snaps an image from a CCD camera

%function [cam_name] = snap(c)

if nargin > 1 && strcmpi(varargin{1},'plot')
    plotimage = 1;
else
    plotimage = 0;
end
    
%cam_name = c
%c = cam_name;




disp('starting snap')
% open CA to camera PVs
h1 = mcaopen([cam_name ':HEIGHT_MONITOR']);
h2 = mcaopen([cam_name ':WIDTH_MONITOR']);
h3 = mcaopen([cam_name ':DATA_MONITOR']);
h4 = mcaopen([cam_name ':EUID_MONITOR']);
h5 = mcaopen([cam_name ':ISO_STATUS']);
h6 = mcaopen([cam_name ':COUNTER_MONITOR']);
h7 = mcaopen([cam_name ':BPP_MONITOR']);
h8 = mcaopen([cam_name ':TRIGGER_MODE_STATUS']);
h9 = mcaopen([cam_name ':TRIGGER_ON_OFF_STATUS']);
h10 = mcaopen([cam_name ':TRIGGER_DELAY_MONITOR']);
h11 = mcaopen([cam_name ':FRAMERATE_STATUS']);
h12 = mcaopen([cam_name ':MODE_STATUS']);
h13 = mcaopen([cam_name ':SHUTTER_MONITOR']);
h14 = mcaopen([cam_name ':SHUTTER_MODE_STATUS']);
h15 = mcaopen([cam_name ':EXPOSURE_MONITOR']);
h16 = mcaopen([cam_name ':EXPOSURE_MODE_STATUS']);
h17 = mcaopen([cam_name ':GAIN_MONITOR']);
h18 = mcaopen([cam_name ':GAIN_MODE_STATUS']);
h19 = mcaopen([cam_name ':WOFFSET_MONITOR']);
h20 = mcaopen([cam_name ':HOFFSET_MONITOR']);
h21 = mcaopen([cam_name ':BRIGHTNESS_MONITOR']);
h22 = mcaopen([cam_name ':BRIGHTNESS_MODE_STATUS']);
%h23 = mcaopen([cam_name ':XP_MONITOR']);
%h24 = mcaopen([cam_name ':YP_MONITOR']);

% get the PV through CA
height = mcaget(h1);
width = mcaget(h2);
iso_status = mcaget(h5);
if iso_status == 0
    mcaput(h5,1);
    data = mcaget(h3);
    mcaput(h5,0);
else
    data =mcaget(h3);
end
euid = mcaget(h4);

counter = mcaget(h6);
BPP = mcaget(h7);
trigger_mode = mcaget(h8);
trigger_on_off = mcaget(h9);
trigger_delay = mcaget(h10);
framerate_status = mcaget(h11);
mode1 = mcaget(h12);
shutter_monitor = mcaget(h13);
shutter_mode = mcaget(h14);
exposure_monitor = mcaget(h15);
exposure_mode = mcaget(h16);
gain_monitor = mcaget(h17);
gain_mode = mcaget(h18);
WOFFSET = mcaget(h19);
HOFFSET = mcaget(h20);
brightness_monitor = mcaget(h21);
brightness_mode = mcaget(h22);
% XP = mcaget(h23);
% YP = mcaget(h24);




% change single row vector to 2-D matrix:
x=reshape(data, width, height);

image_out = x';

if plotimage
    % intensity of RGB high
    figure(666);

    % imagesc(x);
    imagesc(x');
    colormap gray;
end

% close CA
mcaclose(h1)
mcaclose(h2)
mcaclose(h3)
mcaclose(h4)
mcaclose(h5)
mcaclose(h6)
mcaclose(h7)
mcaclose(h8)
mcaclose(h9)
mcaclose(h10)
mcaclose(h11)
mcaclose(h12)
mcaclose(h13)
mcaclose(h14)
mcaclose(h15)
mcaclose(h16)
mcaclose(h17)
mcaclose(h18)
mcaclose(h19)
mcaclose(h20)
mcaclose(h21)
mcaclose(h22)
% mcaclose(h23)
% mcaclose(h24)



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

disp('snap finished')
