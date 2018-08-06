function Flag = iscontrolroom
%ISCONTROLROOM - Determines wether Matlab is run in the controlroom

%
% Written by Laurent S. Nadolski

% Test is done on the HOME variable to determine wether we are in the controlroom
Flag = strcmp(getenv('HOME'), '/home/operateur');
