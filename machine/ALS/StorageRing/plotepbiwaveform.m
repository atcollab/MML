function EPBI = plotepbiwaveform(EPBI, Sector)
%PLOTEPBIWAVEFORM 
%
%  See also getepbiwaveform publish_epbi
 
%  Written by Greg Portmann


% Here's the waveform general info:
% * 1250 points
% * points 1 to 1000 are before the trip, 1001 to 1250 are after
% * 50 Hz sampling (20 msec) not effected by the throttle
% * the timestamp corresponds to the last point


if nargin < 1 || isempty(EPBI)
    % Get data
    EPBI = getepbiwaveform;
end
if nargin < 2
    SectorNames = fieldnames(EPBI);
else
    if isnumeric(Sector)
        for i = 1:length(Sector)
            SectorNames{i} = sprintf('Sector%d', Sector(i));
        end
    end
end


ifig = 0;
for i = 1:length(SectorNames)
    
    SubSector = fieldnames(EPBI.(SectorNames{i}));
    
    for j = 1:length(SubSector)
        d = EPBI.(SectorNames{i}).(SubSector{j});
        
        %Throttle = d.Throttle;
        %T = Throttle/50;  % 50 Hz max
        T = 1/50;  % 50 Hz max (no throttle on the waveform?)
        
        TCTimeStamp = d.TimeStamp(1,1);
        
        ifig = ifig + 1;
        figure(ifig)
        clf reset
        N = size(d.WF,2);
        t = T * (0:N-1);
        %t = 1:N;
        plot(t, d.WF);
        xlabel('Time [Seconds]');
        title(sprintf('%s %s',SectorNames{i},SubSector{j}));
        addlabel(1, 0, sprintf(datestr(TCTimeStamp,31)));
        
        for ii = 1:size(d.WF,1)
            TCLabel = d.Label{ii};
            TCLimit = d.Limit(ii);
            TCMax   = max(d.WF(ii,:));
            
            %fprintf('  %s TC limit is %.3f max in waveform is %.3f\n', TCLabel, TCLimit, TCMax);
            if TCMax >= TCLimit
                fprintf('  %s TC exceeded the limit of %.3f max (waveform max %.3f)\n', TCLabel, TCLimit, TCMax);
            elseif TCMax >= TCLimit-.5
                fprintf('  %s TC is with .5 degrees of exceeded the limit of %.3f max (waveform max %.3f)\n', TCLabel, TCLimit, TCMax);
            elseif TCMax >= TCLimit-1
                fprintf('  %s TC is with 1 degree of exceeded the limit of %.3f max (waveform max %.3f)\n', TCLabel, TCLimit, TCMax);
            end
        end
    end
end




% ifig = ifig + 1;
% figure(ifig)
% clf reset
% N = size(EPBI.(SectorNames{i}).Lower.WF,2);
% t = T * (0:N-1);
% plot(t, EPBI.(SectorNames{i}).Lower.WF);
% title(sprintf('%s Lower',SectorNames{i}));
% xlabel('Time [milliseconds]');
% addlabel(1, 0, sprintf(datestr(EPBI.(SectorNames{i}).Lower.WF_TimeStamp(1,1),31)));
% 
% for ii = 1:size(EPBI.(SectorNames{i}).Lower.WF,1);
%     TCLabel   = EPBI.(SectorNames{i}).Lower.Label{ii};
%     TCLimit   = EPBI.(SectorNames{i}).Lower.Limit(ii);
%     TCMax = max(EPBI.(SectorNames{i}).Lower.WF(ii,:));
%     
%     %fprintf('  %s TC limit is %.3f max in waveform is %.3f\n', TCLabel, TCLimit, TCMax);
%     if TCMax >= TCLimit
%         fprintf('  %s TC exceeded the limit of %.3f max (waveform max %.3f)\n', TCLabel, TCLimit, TCMax);
%     elseif TCMax >= TCLimit-.5
%         fprintf('  %s TC is with .5 degrees of exceeded the limit of %.3f max (waveform max %.3f)\n', TCLabel, TCLimit, TCMax);
%     elseif TCMax >= TCLimit-1
%         fprintf('  %s TC is with 1 degree of exceeded the limit of %.3f max (waveform max %.3f)\n', TCLabel, TCLimit, TCMax);
%     end
% end
% 
% 
% ifig = ifig + 1;
% figure(ifig)
% clf reset
% N = size(EPBI.(SectorNames{i}).IG.WF,2);
% t = T * (0:N-1);
% plot(t, EPBI.(SectorNames{i}).IG.WF);
% title(sprintf('%s IG',SectorNames{i}));
% xlabel('Time [milliseconds]');
% addlabel(1, 0, sprintf(datestr(EPBI.(SectorNames{i}).IG.WF_TimeStamp(1,1),31)));
% 
% for ii = 1:size(EPBI.(SectorNames{i}).IG.WF,1);
%     TCLabel   = EPBI.(SectorNames{i}).IG.Label{ii};
%     TCLimit   = EPBI.(SectorNames{i}).IG.Limit(ii);
%     TCMax = max(EPBI.(SectorNames{i}).IG.WF(ii,:));
%     
%     %fprintf('  %s TC limit is %.3f max in waveform is %.3f\n', TCLabel, TCLimit, TCMax);
%     if TCMax >= TCLimit
%         fprintf('  %s TC exceeded the limit of %.3f max (waveform max %.3f)\n', TCLabel, TCLimit, TCMax);
%     elseif TCMax >= TCLimit-.5
%         fprintf('  %s TC is with .5 degrees of exceeded the limit of %.3f max (waveform max %.3f)\n', TCLabel, TCLimit, TCMax);
%     elseif TCMax >= TCLimit-1
%         fprintf('  %s TC is with 1 degree of exceeded the limit of %.3f max (waveform max %.3f)\n', TCLabel, TCLimit, TCMax);
%     end
% end