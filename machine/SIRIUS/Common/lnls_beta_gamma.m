function [beta, gamma, b_rho] = lnls_beta_gamma(energy)
% lnls_beta_gamma: calculates particle energy derived quantities
%
% Units:
% energy  [GeV]
% b_rho   [T.m]

const = lnls_constants;
gamma = energy / (const.E0/1000);
beta  = sqrt(1 - 1/gamma^2);
b_rho = 1e9 * (beta * energy / const.c);
