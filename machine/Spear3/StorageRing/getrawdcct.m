function [dcct, t] = getrawdcct(varargin)
%[cur, t] = getrawdcct
%[cur, t] = getrawdcct(T), T is an integer, total time in seconds
%acquire SPEAR DCCT raw data and timebase with labca
%
T = 1;
if nargin>=1
    T = round(varargin{1});
    if T<1
        T=1;
        warning('total measure time set to 1 second');
    end
end

Nmax=30;
dcct = [];
t = [];
ii=0;
%for ii=1:T
while ii<T
    count = 0;
    while count<Nmax
        count = count + 1;
        
        [cur,estamp_1]=lcaGet('SPEAR:DcctTrace.VAL');
        [timebase,estamp_2]=lcaGet('SPEAR:DcctTrace.TVAL');
        ic=find(cur); cur=cur(ic);
        %it=find(timebase); timebase=timebase(it); %-timebase(1);

        if estamp_1==estamp_2
            timebase = timebase(ic);
            dcct = [dcct, cur];
            t = [t, timebase];
            pause(0.7);
            ii=ii+1;
%            ii
            break;
        else 
            pause(.7);
        end
    end
end
t = t';
dcct = dcct';

