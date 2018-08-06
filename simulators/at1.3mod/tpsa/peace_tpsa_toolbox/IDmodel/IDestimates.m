function SWLS260 = IDestimates
% SWLS modelling I=260 Amp
% Fit curve to data where user chooses equation to fit.

clear all

% Define function and starting point of fitting routine.
fun = @IDfun

IB = xlsread('IB260Amp.xls');
s = IB(:,1);
slength = length(s);
By = IB(:,2);

% Use rand(1,length(parms)) as starting points
%Starting = rand(1,9);
%Starting = [1.9091   -0.0893    0.6686    0.2576    1.6510    0.7628    1.4686    0.4773    0.4803];
Starting = [2.69750990129350   0.11156219231122   0.83014272990504   1.58685220452884 ... 
            1.69576563222000   1.12504653825173   0.35049792770232  -0.10980809145103   -0.15166442029769] % 1.0e-10/1.0e-15
%Starting = [1.6561   -8.1654   22.1827  -28.5963   29.4686  -21.4069   15.1897     -5.9817    2.9664];

% Now, we can call FMINSEARCH:
%options = optimset('fminsearch');   % Use FMINSEARCH defaults 
options = optimset('Display','iter','TolFun',1e-15,'TolX',1e-10);
SWLS260 = fminsearch(fun, Starting, options, s, By);

% To check the fit
plot(s,By,'*','MarkerSize',2)
hold on
plot(s,SWLS260(2)*cos(SWLS260(1)*s)+ ...
       SWLS260(3)*cos(3*SWLS260(1)*s)+ ...
       SWLS260(4)*cos(5*SWLS260(1)*s)+ ...
       SWLS260(5)*cos(7*SWLS260(1)*s)+ ...
       SWLS260(6)*cos(9*SWLS260(1)*s)+ ...
       SWLS260(7)*cos(11*SWLS260(1)*s)+ ...
       SWLS260(8)*cos(13*SWLS260(1)*s)+ ...
       SWLS260(9)*cos(15*SWLS260(1)*s),'r')
xlabel('s')
ylabel('By(s)')
title(['Fitting to function ', func2str(fun)]);
legend('By', ['fit using ', func2str(fun)])
hold off
% 
% ----------------------------------------------------------
%
function sse = IDfun(params, s, By)
% Accepts curve parameters as inputs, and outputs fitting the
% error for the equation y = A * exp(-lambda * t);
ks = params(1)
B1 = params(2);
B3 = params(3);
B5 = params(4);
B7 = params(5);
B9 = params(6);
B11 = params(7);
B13 = params(8);
B15 = params(9);
 
Fitted_Curve = B1 .* cos(ks*s) + ...
               B3 .* cos(3*ks*s) + ...
               B5 .* cos(5*ks*s) + ...
               B7 .* cos(7*ks*s) + ...
               B9 .* cos(9*ks*s) + ...
               B11 .* cos(11*ks*s) + ...
               B13 .* cos(13*ks*s) + ...
               B15 .* cos(15*ks*s);
Error_Vector = Fitted_Curve - By;

% When curve fitting, a typical quantity to minimize is the sum of squares error
sse = sum(Error_Vector .^ 2);