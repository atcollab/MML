function tau_q = physics_quantumlifetime(epsilon_RF,sigma_epsilon,tau_epsilon)
% physics_quantum_lifetime - computes quantum lifetime
%
%  INPUTS
%  1. epsilon_RF - RF acceptance
%  2. sigma_epsilon - Energy spread
%  3. tau_epsilon - Longitudinal damping time
%
%  OUPUTS
%  1. tau_q - Quantum lifetime in s
%
%  See Also ...

%
% Written by Laurent S. Nadolski

xi = power(epsilon_RF,2)/2./power(sigma_epsilon,2);

tau_q = tau_epsilon/2./xi.*exp(xi); 