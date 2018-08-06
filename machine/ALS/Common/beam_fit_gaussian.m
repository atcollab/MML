function [Sigmahat, bhat, Ahat, Offsethat, r, yhat] = beam_fit_gaussian(x, y)

PlotFlag = 1;
MaxIter = 4;

if nargin < 2
    A = 2.1234;
    Sigma = .25;
    b = 3.1;
    Offset = .01;
    x = (0:.01:7)';
    y = A * exp(-1*(x-b).^2 / (2*Sigma^2)) + Offset;
end

% ln(y-Offset) = ln A - (x-b)^2 /(2 sigma^2)
% ln(y-Offset) = ln A - (x^2-2xb+b^2) /(2 sigma^2)
% ln(y-Offset) =  (-1/(2 sigma^2)) * x^2 + (b/sigma^2) * x + ln A - b^2/(2 sigma^2)

if 1
    % Matlab curve fit
    Offsethat = min(y);
    y = y - Offsethat;
    %xx = XLim(1):XLim(2);
    [ymax, ii] = max(y);
    x_reduced = find(y > ymax/4);
    f = fit(x(x_reduced), y(x_reduced), 'gauss1');

    yhat = f.a1 .* exp(-1*((x-f.b1) ./ f.c1).^2) + Offsethat;
    
    Sigmahat = f.c1/sqrt(2);
    bhat = f.b1;
    Ahat = f.a1;
    r = NaN;
else
    if PlotFlag
        figure(1);
        clf reset
        plot(x, y);
    end
    
    
    % Starting point
    Offsethat = min(y);
    [Sigmahat, bhat, Ahat, yhat] = LSFit(x, y - Offsethat, PlotFlag);
    yhat = Ahat * exp(-1*(x-bhat).^2 / (2*Sigmahat^2)) + Offsethat;
    r = sum(abs(y-yhat));
    
    for i = 1:MaxIter
        % Compute Jacobian
        Delta = (max(y)-min(y))/10000;
        [Sigmahat1, bhat1, Ahat1, yhat1] = LSFit(x, y - (Offsethat+Delta), 0);
        yhat1 = Ahat1 * exp(-1*(x-bhat1).^2 / (2*Sigmahat1^2)) + (Offsethat+Delta);
        r1 = sum(abs(y-yhat1));
        
        J = (r1-r) / Delta;
        dOffset = -1*r / J;
        Offsethat = Offsethat + dOffset;
        
        [Sigmahat, bhat, Ahat, yhat] = LSFit(x, y - Offsethat, PlotFlag);
        yhat = Ahat * exp(-1*(x-bhat).^2 / (2*Sigmahat^2)) + Offsethat;
        r = sum(abs(y-yhat));
    end
end

%for i = 1:1
%   r1 = LSFit(x, y);
%end


function [Sigmahat, bhat, Ahat, yhat] = LSFit(x, y, PlotFlag)

% First cut the data so small numbers don't dominate the fit
logy = log(y);
ii = find(logy > -2.0);
logy = logy(ii);
x = x(ii);

X = [ones(length(x),1) x x.^2];

b = inv(X'*X)*X' * logy;
lnyhat = X * b;
yhat = exp(lnyhat);

Sigmahat = sqrt(-1 / (2*b(3)));
bhat     = b(2) *Sigmahat^2;
Ahat     = exp(b(1) + bhat^2/(2*Sigmahat^2));

if PlotFlag
    hold on
    plot(x, yhat, '--', 'color', nxtcolor);
    hold off
end

%Res = sum(y-yhat)/length(y)
%Res = sum(abs(lnyhat-log(y)))

