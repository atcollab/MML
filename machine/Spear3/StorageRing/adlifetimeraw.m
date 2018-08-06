function [tau, dtau, DCCT, tout] = adlifetimeraw(varargin)
%measure lifetime from raw DCCT data
%
%  [tau, dtau, DCCT, tout] = adlifetimeraw
%  [tau, dtau, DCCT, tout] = adlifetimeraw(T),   T>1 is a scalar in seconds
%  [tau, dtau, DCCT, tout] = adlifetimeraw(err),  err<1 is a scalar, fractional error
%  bar err = Delta_tau/tau
%
%  OUTPUTS
%  1. tau  = Computed lifetime [hours]
%  2. tout = original time vector
%  3. DCCT = Beam current vector [mAmps] using getdcct at the times defined in t
%  4. dtau = error bar for tau [hours]

plotflag=0;
dtau_tau = 0.02;  %default
minI0 = 0.1; %mA, below 0.1mA we won't measure lifetime
maxT = 180;  %seconds, we won't measure more than maxT seconds

if nargin == 1
    T = varargin{1};
    if T>1
        %with specified total time in seconds
        disp(['   Monitoring beam current for ', num2str(T), ' seconds']);

        [DCCT, tout] = getrawdcct(T);
        [I0,tau, dtau] = fit4lifetime(tout-tout(1), DCCT);
        if plotflag
            figure
            plot(tout,DCCT,'*'); hold on
            plot(tout,I0*(1-(tout-tout(1))/tau/60/60))
            title([num2str(I0) '  ' num2str(tau) '  ' num2str(dtau)])
        end

        return %done
        
    else
        dtau_tau = varargin{1};
        if (dtau_tau<=0) 
           error('wrong error bar')
        elseif dtau_tau>0.1
            warning('error bar too large');
        end
        
    end
end
if getdcct < minI0
   % error('no beam');
end

blocksize = 20;
t_start = gettime;
N = 0;
DCCT = [];
tout = [];
while 1
    [nDCCT, ntout] = getrawdcct(blocksize);
    DCCT=[DCCT; nDCCT];
    tout=[tout; ntout];
    
    [I0,tau, dtau] = fit4lifetime(tout-tout(1), DCCT);
    if tau<=0
        %
        %break
        if N==0
            N = N + blocksize;
        else
            disp('   Life time measurement is inaccurate!')
            break;
        end
    elseif (dtau/tau < dtau_tau) || tau < 0.2 
        break %good data
    else
        disp([tau, dtau])
        if (getdcct > minI0) && (N < maxT)
           N = N + blocksize; %try again
        else
            break; 
        end
    end
end
disp(['takes ' num2str(tout(end)-tout(1)) ' seconds']);

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
