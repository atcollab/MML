% profil de perte

function [estimates, model] = fitprofil(xdata, ydata)
% Call fminsearch with a random starting point.
start_point = [1 2]; % sig et zb
model = @expfun;
estimates = fminsearch(model, start_point);
% expfun accepts curve parameters as inputs, and outputs sse,
% the sum of squares error for A * exp(-lambda * xdata) - ydata, 
% and the FittedCurve. FMINSEARCH only needs sse, but we want to 
% plot the FittedCurve at the end.
    function [sse, FittedCurve] = expfun(params)
        sig = params(1);
        zb  = params(2);
        z0m =5;
        z   =xdata
        for z0=-z0m:1:z0m
           gauss=exp(-0.5*((z-z0-zb)/sig).^2);
           profil=profil + gauss;
        end
        
        FittedCurve = profil;
        ErrorVector = FittedCurve - ydata;
        sse = sum(ErrorVector .^ 2);
    end
end


