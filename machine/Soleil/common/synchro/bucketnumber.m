function [n1 n2] = bucketnumber(num)
%BUCKETNUMBER - Computes n1 n2 for timing system master board for a bucket
%number.
%
%  INPUTS
%  1. num - Bucket number
%
%  OUPUTS
%  1. n1 - number of step for extraction table
%  2. n2 - number of step for linac table
%
%  ALGORITHM
% Table extraction n1 entier compris entre 0 et 51
% Table Linac n2 entier compris entre 0 et 7
% n1 = 0; n2 = 0; injection dans paquet 1 de l'anneau
% n1 = 0; n2 = 1; injection dans paquet 2 de l'anneau

%
%  Written by Laurent S. Nadolski

num = num - 1;
n2 = mod(num,8);
d = fix(num/8);
[u v] = bezout(52,23,d);
n1 = v;

%fprintf('n1 = %d n2 = %d\n', n1, n2)
%fprintf('Injection dans paquet numero %d\n', mod(n1*184,416) + n2 + 1)

%%%%

function [u v] = bezout(a,b,c)
% Resolution de 52 u + 23 v = c
%        ou  encore 416 u + 184 v = 8*c
%        ou  encore de 184 v = 8*c modulo 416
%  Soit travail dans l'ensemble quotient Z/416Z

% ALGORITHME de BEZOUT

a = 52;
b = 23;

u = 1;
v = 0;

s = 0;
t = c;
while b > 0 
    q = fix(a/b);r = rem(a,b);
    a = b; b = r;
    tmp = s;
    s = u - q * s;
    u = tmp; tmp = t;
    t = v - q * t;
    v = tmp;
end
u;
v = mod(v,52);
