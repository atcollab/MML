function epsilon_RF = physics_RFacceptance(VRF,alpha,rho,E,h)
% PHYSICS_RFACCEPTANCE - Computes RF acceptance
%
%  INPUTS
%  1. VRF - RF voltage in kV
%  2. alpha - Momentum compaction factor
%  3. rho - Curvature radius in m
%  4. E - Energy in GeV  
%  5. h - Harmonic number
% 
%  OUPUTS
%  1. epsilon_RF - RF acceptance
%
%  EXAMPLES
%  1. physics_RFacceptance(4000,getmcf('Model'),5.36,2.75,416)
%     is 0.057 for SOLEIL in the linear approximation
%
%  See Also  physics_RFacceptance, physics_quatumlifetime,
%  physics_energyloss

%
%  Written by Laurent S. Nadolski


U0 = physics_energyloss(E,rho); % energyloss per turn in keV
q = VRF./U0;

epsilon_RF = sqrt(2/(pi*alpha*h)*(U0*1e-6./E).*(sqrt(q.*q-1)-acos(1./q)));

