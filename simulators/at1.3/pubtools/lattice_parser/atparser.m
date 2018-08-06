function [FAMLIST THERING GLOBVAL] = atparser(filename)
%[FAMLIST THERING GLOBVAL] = atparser(filename)
%Read in the lattice file in the formats of MAD8, TRACY, OPA, BETA, or APAP,
% and translate to the AT's FAMLIST, THERING, and GLOBVAL.
%Example:
% TPS_MAD_lattice = init_lattice('TPS24P18K1.mad8');
% [FAMLIST THERING GLOBVAL] = ap2at(TPS_MAD_lattice);
%
% Peace Chang, 2011-12-28
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global AP_DB FAMLIST THERING GLOBVAL
lattice = init_lattice(filename);
[FAMLIST THERING GLOBVAL] = ap2at(lattice);
