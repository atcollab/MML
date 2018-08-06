function monbpmhistory(varargin)
% monbpmhistory - Read historybuffer of all the BPMs
%

%%
if isempty(varargin)    
    devName = family2tangodev('BPMx');
else
    devName = family2tangodev('BPMx',varargin{:});
end

%%
Xpos = [];
Zpos = [];
Xrmspos = [];
Zrmspos = [];

for k = 1:length(devName),
    %rep = tango_read_attributes(devName{k},{'XPosSAHistory','ZPosSAHistory','XRMSPosSA','ZRMSPosSA'});
    rep = tango_read_attributes(devName{k},{'XPosSAHistory','ZPosSAHistory'});
    Xpos(:,k) = rep(1).value;
    Zpos(:,k) = rep(2).value;
end

Xrmspos = std(Xpos);
Zrmspos = std(Zpos);

xtime = (1:size(Xpos,1))/10;
%%
figure
subplot(2,2,1)
plot(xtime, Xpos-repmat(Xpos(1,:),size(Xpos,1),1))
xaxis([1 size(Xpos,1)/10])
ylabel('DX (mm)')
xlabel('time [s]')
grid on
subplot(2,2,2)
plot(Xrmspos)
xaxis([0 size(Xpos,2)+1])
ylabel('Xrms (mm)')
xlabel('BPM number')
grid on
subplot(2,2,3)
plot(xtime, Zpos-repmat(Zpos(1,:),size(Zpos,1),1))
xaxis([1 size(Xpos,1)/10])
ylabel('DZ (mm)')
xlabel('time [s]')
grid on
subplot(2,2,4)
plot(Zrmspos)
xaxis([0 size(Xpos,2)+1])
ylabel('Zrms (mm)')
xlabel('BPM number')
grid on

addlabel(datestr(tango_shift_time(rep(2).time)))