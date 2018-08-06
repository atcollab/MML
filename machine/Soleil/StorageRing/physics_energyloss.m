function U0 = physics_energyloss(E,rho)
%  PHYSICS_ENERGYLOSS - Computed energy loss per turn
%
%  INPUTS
%  1. E - Energy in GeV
%  2. rho - Curvature radius in meters 
%
%  OUPUTS
%  1. U0 - Energy loss per turn in keV
%
%  EXAMPLES
%  1. physics_energyloss(2.75,5.36)
%
%  See Also  

%
% Written by Laurent S. Nadolski
%
% rho 12.376 m for Booster
% rho 5.360 m for storage ring

U0 = 88.5*power(E,4)/rho;
