function [tau, dtau, DCCT,tout] = adlifetime(varargin)
%adlifetime - Measures the lifetime using an exponential least squares fit
%to beam current with adaptive data acquisition to guaranteer fixed error
%bar. 
%  [tau, dtau, DCCT,tout] = adlifetime
%  [tau, dtau, DCCT,tout] = adlifetime(t),   tout is a vector of time in
%  seconds with at least 3 elements. 
%  [tau, dtau, DCCT,tout] = adlifetime(err),  err is a scalar, fractional error
%  bar err = Delta_tau/tau
%
%  OUTPUTS
%  1. tau  = Computed lifetime [hours]
%  2. tout = original time vector
%  3. DCCT = Beam current vector [mAmps] using getdcct at the times defined in t
%  4. dtau = error bar for tau [hours]
%modified by Xiaobiao Huang from scraperlifetime.m written by Jeff Corbett
%  
plotflag=0;
dtau_tau = 0.02;  %default
minI0 = 0.1; %mA, below 0.1mA we won't measure lifetime
maxT = 180;  %seconds, we won't measure more than maxT seconds

if nargin == 1
    t = varargin{1};
    if length(t)>=3
        %with specified time points
        disp(['   Monitoring beam current for ', num2str(t(end)), ' seconds']);
        t=t(:);
        t_start = gettime;
        for j = 1:length(t)
            disp(['time ' num2str(j) ' of ' num2str(length(t))])
            T = t(j)-(gettime-t_start);
            if T > 0
                pause(T);
            end
            tout(j,1) = gettime - t_start;
            DCCT(j,1) = getdcct;
        end 
        [I0,tau, dtau] = fit4lifetime(tout, DCCT);
        if plotflag
        figure
        plot(tout,DCCT,'*'); hold on
        plot(tout,I0*(1-(tout)/tau/60/60))
        title([num2str(I0) '  ' num2str(tau) '  ' num2str(dtau)])
        end

        return %done
        
    elseif length(t) == 1
        dtau_tau = t;
        if (t<=0) || (t>=1)
           error('wrong error bar')
        elseif t>0.1
            warning('error bar too large');
        end
        
    end
end
if getdcct < minI0
   
    error('no beam');
end

blocksize = 20;
t = 1:blocksize;  
t=t(:);
t_start = gettime;
N = 0;
while 1
    for j = 1:length(t)
        T = t(j)-(gettime-t_start);
        if T > 0
             pause(T);
         end
         tout(j+N,1) = gettime - t_start;
         DCCT(j+N,1) = getdcct;
    end 
    [I0,tau, dtau] = fit4lifetime(tout, DCCT);
    if tau<=0
         disp('   Life time measurement is inaccurate!')
        %break
        if N==0
            N = N + blocksize;
            t = t + blocksize;
        else
            break;
        end
    elseif (dtau/tau < dtau_tau) || tau < 0.2 
        break %good data
    else
        disp([tau, dtau])
        if (getdcct > minI0) && (t(end) <maxT)
            N = N + blocksize;
            t = t + blocksize;
        else
            break; 
        end
    end
end
disp(['takes ' num2str(t(end)) ' seconds']);

if plotflag
        figure
        plot(tout,DCCT,'*'); hold on
        plot(tout,I0*(1-(tout)/tau/60/60))
        title([num2str(I0) '  ' num2str(tau) '  ' num2str(dtau)])
end


%% routine to fit DCCT-Time data to obtain lifetime and error bar

function [I0,tau, dtau] = fit4lifetime(tout, DCCT)
% LS fit to exponential (note log)
y=log(DCCT);
X=[ones(size(tout)) tout];

C = inv(X'*X);  %covariance matrix
B = C*X'*y;     % Least squares fit
sgm = sqrt(diag(C));

I0=exp(B(1));
tau=(-1/B(2))/60/60;    % In hours
chi2 = (y - X*B)'*(y - X*B);

df = length(y)-2;
dtau = tau*abs(sgm(2)/B(2))*sqrt(chi2/df);  %hours
    
if isnan(tau)  || (tau<=0)
    disp('   Life time measurement is inaccurate!')
    tau = 0; 
    dtau = 0;

elseif tau>1         % linear fit when lifetime > 1 hr
    % LS fit to short term exponential
    y=DCCT;
    X=[ones(size(tout))  tout];   %note reversal in design matrix relative to exponential fit
    
    C = inv(X'*X);
    B = C*X'*y;     % Least squares fit
    sgm = sqrt(diag(C));
    
    I0=B(1);
    tau=(-B(1)/B(2))/60/60;    % In hours

    chi2 = (y - X*B)'*(y - X*B);
    dI0 = sgm(1)*sqrt(chi2);
    dtau = tau*sqrt( (sgm(1)/B(1))^2 + (sgm(2)/B(2))^2)*sqrt(chi2/df); 
   
    if isnan(tau)
        disp('   Life time measurement is inaccurate!')
        tau = 0
    end
end
