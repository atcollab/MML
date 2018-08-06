function sigmaL = physics_bunchlength(eVRF,E,rho)
%  PHYSICS_bunchlength - Compute bunch length
%
%  INPUTS
%  1. E - Energy in GeV
%  2. eVRF - RF voltage in keV
%  3. rho - Curvature radius in meters 
%
%  OUPUTS
%  1. sigmaL - bunch length
%
%  EXAMPLES
%  1. physics_bunchlength(4000,2.75,5.36)
%
%  See Also  physics_RFacceptance, physics_quantumlifetime,
%  physics_energyloss, physics_synchronousphase

%
% Written by Laurent S. NAdolski
%
% rho 12.376 m for Booster
% rho 5.360  m for storage ring

% plot(1000:4000,physics_bunchlength(1000:4000,2.739,5.36)/2.99792458e8*1e12*2.35); grid on
% xlabel('VRF [kV]')
% ylabel('sigmaL FWHM (ps)')

h     = getharmonicnumber;
alpha = 4.5e-4; %getmcf('Model');
OmegaRF = 2*pi*getrf('Model','Physics');
OmegaRF2 = OmegaRF*OmegaRF;
c = 2.99792458e8; 
sigmaEoE = 1.016e-3;
cosPhis = cos(physics_synchronousphase(eVRF,E,rho));
sigmaL = sqrt(2*pi*alpha*h*c*c./cosPhis/OmegaRF2./eVRF/1e-6*E)*sigmaEoE;
