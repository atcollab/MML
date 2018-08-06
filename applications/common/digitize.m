function yout = digitize(y,q)
%DIGITIZE - Digitize a signal 
% yout = digitize(y,q)
% q - quantization step
%

r = rem(y,q);
addone = round(r/q);

%yout = y - r;               % Fix lower
yout = y - r + addone*q;     % Round


%[y;yout;yout1]
%[y;yout;addone;r]

