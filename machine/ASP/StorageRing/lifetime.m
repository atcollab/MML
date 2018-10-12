function [lifetdcct error] = lifetime(timetaken,varargin)
%[lifetime error] = lifetime(time taken in seconds,varargin)
%
%This function returns the lifetime and error calculated over
%the time given as an input in seconds
%
%It is also possible to specify a process variable to use to find the
%lifetime
%
%If you use 'sum' as the second input then it will sum over a number of
%BPMs as you edit in the code below.
%
%Written by Martin Spencer
% Modified 18-12-2007 ET

if nargin == 1
    % Default to only using the DCCT
    monitor = 'SR11BCM01:CURRENT_MONITOR';
    usebpm = 0;
elseif nargin == 2
    % Use the SA data of the BPMs 
    monitor = 'SA_SIGNAL.Sum';
    usebpm = 1;
else
    return
end

tic
if usebpm == 1
    % Select the BPMs of interest here or leave empty and will select all
    % BPMs. 
    % The measurements seems to indicate that there are some BPMs that are
    % noisier than others. If you just chose the quiet ones the results are
    % comparable to the DCCT.
%     deviceList = getlist('BPMx',[1:7:98]');
    deviceList = getlist('BPMx');
%     [rawdata tout] = getlibera(monitor,deviceList,[1:timetaken]);
    [rawdata, tout] = srbpm.getfield(monitor,deviceList,[1:0.25:timetaken]);
    
    rawdata = squeeze(rawdata);
    
    % Normalise before averaging across all BPMs
    bpmdata = rawdata./repmat(rawdata(:,end),1,size(rawdata,2));
    data = mean(bpmdata);

else
	[data, tout] = getpv(monitor,[1:timetaken]);
end
t = toc;

data = squeeze(data/data(end)); %normalise

if usebpm
    figure(23); clf;
    set(gcf,'Position',[ 122  656  985  625])
else
    figure(22); clf;
    set(gcf,'Position',[ 122  656  985  625])
end
plot(tout,data,'r*-');
hold on;

%p = polyfit([1:Ns]*0.1,a(1,:),1);
%f = polyval(p,[1:Ns]*0.1);
%plot([1:Ns]*0.1,f,'b');

[p1 s] = polyfit(tout,data,1);
[f1 delta] = polyval(p1,tout,s);
plot(tout,f1,'b');
grid on;
xlabel('Time (s)');

meandelta = mean(delta);

%lifetdcct = -((t)/(3600))/log(f1(end)/f1(1));
%lifetmax = -((t)/(3600))/log((f1(end)-meandelta)/(f1(1)+meandelta));
%lifetmin  = -((t)/(3600))/log((f1(end)+meandelta)/(f1(1)-meandelta));
%error = abs(lifetmax-lifetmin)/2;

lifetdcct = (f1(end)/(f1(1)-f1(end)))*(t/3600);
grad = (f1(1)-f1(end))/(t/3600);
gradmax = ((f1(1)+meandelta)-(f1(end)-meandelta))/(t/3600);
gradmin = ((f1(1)-meandelta)-(f1(end)+meandelta))/(t/3600);
graderror = abs(gradmax-gradmin)/2;
properror = graderror/grad;
error = lifetdcct*properror;


% temp = ['The lifetime is: ' num2str(lifetdcct) ' hours. With a error of about: ' num2str(error) ' hours. Time taken: ' num2str(t) ' seconds.'];

temp = sprintf('The lifetime is: %5.2f Hr; approx. error: %5.2f Hr. Time taken: %4.1f seconds',...
    lifetdcct, error, t);

if usebpm
    ylabel('BPM sum (Normalised)');
else
    ylabel('DCCT (Normalised)');
end
title(temp);
disp(temp);

hold off;


%% Old Version
% function [lifetdcct error] = lifetime(timetaken,varargin);
% %[lifetime error] = lifetime(time taken in seconds,varargin)
% %
% %This function returns the lifetime and error calculated over
% %the time given as an input in seconds
% %
% %It is also possible to specify a process variable to use to find the
% %lifetime
% %
% %If you use 'sum' as the second input then it will sum over a number of
% %BPMs as you edit in the code below.
% %
% %Written by Martin Spencer
% 
% 
% %bpmsasum(1,:) = 'SR01BPM01:SA_S_MONITOR';
% %bpmsasum(2,:) = 'SR02BPM01:SA_S_MONITOR';
% flag=0;
% if nargin == 1
%     monitor = 'SR11BCM01:CURRENT_MONITOR';    
% elseif nargin == 2 
%     if ~strcmp('sum',varargin{1})
%         monitor = varargin{1};
%     else
%         flag =1;
%     end 
% end
% 
% if flag == 1;
%     % Select the BPMs of interest here or leave empty and will select all
%     % BPMs.
% %     deviceList = [];
% %     [data tout] = getlibera('SA_SUM_MONITOR',deviceList,[1:timetaken])
%     
%     count=1;
%     for(i=[1:2 4:10 12:14]) %sector numbers to sum over!!!
%         for(j=1:7) %bpm numbers to sum over!!!!       
%             if(0)            
%             elseif i >= 10
%                  bpmsasum(count,:) = ['SR' num2str(i) 'BPM0' num2str(j) ':SA_SUM_MONITOR'];
%             elseif i<10
%                  bpmsasum(count,:) = ['SR0' num2str(i) 'BPM0' num2str(j) ':SA_SUM_MONITOR'];
%             end 
%             count = count+1;
%         end
%     end
% end
% %dcct = 'SR11BCM01:TT_S_MONITOR';
% 
% if nargin > 1
%     Ns = timetaken*10;
% else
%     Ns = timetaken;
% end
% 
% a = zeros(2,Ns);
% tic;
% for(i=1:Ns);
% 
%     if flag == 1
%         for(j=1:count-1)
%             s(j) = getpv(bpmsasum(j,:));
%         end
%         d = mean(s);
%     else
%         d = getpv(monitor);
%     end
% 
%     a(2,i)=d;
%     if(nargin > 1)
%         pause(0.1)
%     else
%         pause(1)
%     end    
% end;
% t=toc;
% 
% %a(1,:) = a(1,:)/a(1,end); %normalise
% a(2,:) = a(2,:)/a(2,end); %normalise
% 
% figure(22);
% clf;
% %plot([1:Ns]*0.1,a(1,:),'b*-');
% %hold on;
% plot([1:Ns]*0.1,a(2,:),'r*-');
% hold on;
% 
% %p = polyfit([1:Ns]*0.1,a(1,:),1);
% %f = polyval(p,[1:Ns]*0.1);
% %plot([1:Ns]*0.1,f,'b');
% 
% [p1 s] = polyfit([1:Ns]*0.1,a(2,:),1);
% [f1 delta] = polyval(p1,[1:Ns]*0.1,s);
% plot([1:Ns]*0.1,f1,'b');
% 
% meandelta = mean(delta);
% 
% %lifetdcct = -((t)/(3600))/log(f1(end)/f1(1));
% %lifetmax = -((t)/(3600))/log((f1(end)-meandelta)/(f1(1)+meandelta));
% %lifetmin  = -((t)/(3600))/log((f1(end)+meandelta)/(f1(1)-meandelta));
% %error = abs(lifetmax-lifetmin)/2;
% 
% lifetdcct = (f1(end)/(f1(1)-f1(end)))*(t/3600);
% grad = (f1(1)-f1(end))/(t/3600);
% gradmax = ((f1(1)+meandelta)-(f1(end)-meandelta))/(t/3600);
% gradmin = ((f1(1)-meandelta)-(f1(end)+meandelta))/(t/3600);
% graderror = abs(gradmax-gradmin)/2;
% properror = graderror/grad;
% error = lifetdcct*properror;
% 
% temp = ['The lifetime is: ' num2str(lifetdcct) ' hours. With a error of about: ' num2str(error) ' hours. Time taken: ' num2str(t) ' seconds.'];
% disp(temp);
% 
% hold off;