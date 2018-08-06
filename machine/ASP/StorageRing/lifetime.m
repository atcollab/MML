function [lifetdcct error] = lifetime(timetaken,varargin);
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


%bpmsasum(1,:) = 'SR01BPM01:SA_S_MONITOR';
%bpmsasum(2,:) = 'SR02BPM01:SA_S_MONITOR';
flag=1;
if nargin == 1
    monitor = 'SR11BCM01:CURRENT_MONITOR';    
elseif nargin == 2 
    if ~strcmp('sum',varargin{1})
        monitor = varargin{1};
    else
        flag =1;
    end 
end

if flag == 1;
    count=1;
    for(i=1:1) %sector numbers to sum over!!!
        for(j=1:1) %bpm numbers to sum over!!!!       
            if(0)            
            elseif i >= 10
                 bpmsasum(count,:) = ['SR' num2str(i) 'BPM0' num2str(j) ':SA_SUM_MONITOR'];
            elseif i<10
                 bpmsasum(count,:) = ['SR0' num2str(i) 'BPM0' num2str(j) ':SA_SUM_MONITOR'];
            end 
            count = count+1;
        end
    end
end
%dcct = 'SR11BCM01:TT_S_MONITOR';

if nargin > 1
    Ns = timetaken*10;
else
    Ns = timetaken;
end

a = zeros(2,Ns);
tic;
for(i=1:Ns);

    if flag == 1
        for(j=1:count-1)
            s(j) = getpv(bpmsasum(j,:));
        end
        d = mean(s);
    else
        d = getpv(monitor);
    end

    a(2,i)=d;
    if(nargin > 1)
        pause(0.1)
    else
        pause(1)
    end    
end;
t=toc;

%a(1,:) = a(1,:)/a(1,end); %normalise
a(2,:) = a(2,:)/a(2,end); %normalise

figure;
clf;
%plot([1:Ns]*0.1,a(1,:),'b*-');
%hold on;
plot([1:Ns]*0.1,a(2,:),'r*-');
hold on;

%p = polyfit([1:Ns]*0.1,a(1,:),1);
%f = polyval(p,[1:Ns]*0.1);
%plot([1:Ns]*0.1,f,'b');

[p1 s] = polyfit([1:Ns]*0.1,a(2,:),1);
[f1 delta] = polyval(p1,[1:Ns]*0.1,s);
plot([1:Ns]*0.1,f1,'b');

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

temp = ['The lifetime is: ' num2str(lifetdcct) ' hours. With a error of about: ' num2str(error) ' hours. Time taken: ' num2str(t) ' seconds.'];
disp(temp);

hold off;