function clsAvOrbit(family,numSamples)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsAvOrbit.m 1.2 2007/03/02 09:03:02CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%  clsAvOrbit(plane, numSamples)
%   example:
%           >>clsAvOrbit('BPMx',50);
%                    family = 'BPMx'     - for the horizontal orbit , 'BPMy'
%                                         for the vertical
%                    numSamples = 50 - this will take teh average of 50 horizontal orbits at 1/second 
%
% ----------------------------------------------------------------------------------------------

x=zeros(1,48)';
 fprintf('Reading orbit:\n');
for i=1:numSamples
    x=x + getam(family);
      pause(1.);
    fprintf('.');
end
y=zeros(1,48)';
 fprintf('\nReading orbit:\n');
for i=1:numSamples
    y=y + getam(family);
   pause(1.);
    fprintf('.');
end
av=(x-y)/numSamples;
fprintf('\n\nMeasurement complete ');

figure;
plot(av);

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsAvOrbit.m  $
% Revision 1.2 2007/03/02 09:03:02CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
