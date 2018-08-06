% profil de perte

function [estimates, model] = fitprofil(xdata, ydata)
% Call fminsearch with a random starting point.
start_point = [2 -2 10 90]; % sig et zb chambre et amplitude
model = @expfun;
options = optimset('MaxFunEvals',2000);
estimates = fminsearch(model, start_point,options);
% expfun accepts curve parameters as inputs, and outputs sse,
% the sum of squares error for A * exp(-lambda * xdata) - ydata, 
% and the FittedCurve. FMINSEARCH only needs sse, but we want to 
% plot the FittedCurve at the end.
    function [sse, FittedCurve] = expfun(params)
        sig    = params(1);
        zb     = params(2);
        chambre= params(3);
        A      = params(4);
        z   =xdata;
        
        ch=min(abs(chambre-z-zb),abs(-chambre-z-zb));
        for i=1:length(z)
            x=z(i);
            if (x+zb)>chambre
                ch(i)=0;
            elseif (x+zb)<-chambre
                ch(i)=0;
            end
        end
        profil=erf(ch/sqrt(2)/sig);
        FittedCurve = A*(profil);
        ErrorVector = FittedCurve - ydata;
        sse = sqrt(sum(ErrorVector .^ 2))/length(z);
    end
end


