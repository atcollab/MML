function [p,f]=idbpmnoisefloor0(Input1, Dim, IntFlag, SquareRootFlag, fmin, fmax, LineColor, Gain)
% idbpmfloornoisefloor0(Input1 {50}, Dim {1}, IntFlag {0}, SquareRootFlag {0}, , fmin, fmax, LineColor {'k'}, Gain{1})
%   Noise floor in the straight sections IDBPMs.  The data for this function was measured on
%   IDBPM(9,2) using a low noise 500 megahertz signal generator.
%
%   Input1 = 50, 500, 5000 Hz rangs
%   Dim = 1 horizontal, 2 vertical
%   IntFlag = 0 PSD, else integrated PSD
%   SquareRootFlag = 0 [mm^s] , else [mm]
%   fmin, fmax
%   LineColor
%   Gain = 1000 microns, 1 mm, .001 meters (measured data is in mm)
% 

DirStart = pwd;
gotodata;
cd ..
cd ..
cd srdata
cd idbpm
cd NoiseFloor

Uwindow = .66666666666666667;  %?????????????????????????????

if nargin < 1
   Input1 = 50;
end
if nargin < 2
   Dim = 1;  % horizontal
end
if nargin < 3
   IntFlag = 0;
end
if nargin < 4
   SquareRootFlag = 0;
end
if nargin < 5
   fmin = 0;
end
if nargin < 6
	fmax = 1e10;
end
if nargin < 7
   LineColor = 'k';
end
if nargin < 8
   Gain = 1 % mm
end


if Input1 == 50
   load 92bpm1c
   f=f1*(0:length(Fd1)-1);
   T = 1/f1;          % Time buffer length

   if Dim == 1
      % X
      P = Fd1;
   else
      % Y
      P = Fd2;
   end
elseif Input1 == 500
   load 92bpm1b
   f=f1*(0:length(Fd1)-1);
   T = 1/f1;          % Time buffer length
   
   if Dim == 1
      % X
      P = Fd1;
   else
      % Y
      P = Fd2;
   end
elseif Input1 == 5000
   load 92bpm1a
   f=f1*(0:length(Fd1)-1);
   T = 1/f1;          % Time buffer length

   if Dim == 1
      % X
      P = Fd1;
   else
      % Y
      P = Fd2;
   end
else
   error;
end


[ii] = find(f>=fmin);
Imin = ii(1);
for i=1:Imin
  P(i) = 0;
end

[ii] = find(f<=fmax);
Imax = max(ii);

f=f(Imin:Imax);
P=P(Imin:Imax);

%Nstart = 3;
%f=f(Nstart:end);
%P=P(Nstart:end);


% microns
if IntFlag 
	if SquareRootFlag
        Pint=Gain*sqrt(cumsum(Uwindow*P(end:-1:1)));
    else
        Pint=Gain*Gain*cumsum(Uwindow*P(end:-1:1));
    end
    loglog(f(end:-1:1), Pint, LineColor);
else
    if SquareRootFlag
        p = Gain*sqrt(T*Uwindow*P);
        loglog(f, Gain*sqrt(T*Uwindow*P), LineColor);
    else
        p = Gain*Gain*T*Uwindow*P;
        loglog(f, Gain*Gain*T*Uwindow*P, LineColor);
    end
end


feval('cd', DirStart);

