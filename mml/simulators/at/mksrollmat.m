function R = mksrollmat(PSI)
%MKSROLLMAT - Rotation matrix around s-axis
% M = MKSROLLMAT(PSI) makes a 6-by-6 coordinate transformation matrix
% that transforms 6-by-1 phase space coordinate vector of the PARTICLE
% to a new coord system.  PSI is in radians.
%
% The new system is rotated around the s-axis 
% with respect to the old system by an angle PSI
% POSITIVE PSI corresponds to a CORKSCREW (right) 
% rotation of the ELEMENT. (AT defines 'positive' s-rotation 
% as clockwise, looking in the dirction of the beam)
% 
% The matrix only transforms the transverse (X,PX,Y,PY) coordinates
% 
% |   cos(psi)     0       sin(psi)     0         0       0     |
% |      0     cos(psi)        0      sin(psi)    0       0     |
% |  -sin(psi)     0       cos(psi)     0         0       0     |
% |      0     -sin(psi)       0      cos(psi)    0       0     |
% |      0         0           0        0         1       0     |
% |      0         0           0        0         0       1     |
% 
% In AT, this matrix is used for R1,R2 field of the element 
% data structure in a lattice. Some pass-methods use them
% along with T1 and T2 to includ ELEMENT misalignment
% If a straight ELEMENT (such a quadrupole) is rotated
% by a positive angle PSI (ANTICLOCKWISE)  then 
% R1 = mksrollmat(PSI)
% R2 = mksrollmat(-PSI)
% clockwise (corkscrew aligned with the reference orbit direction)

C = cos(PSI);
S = sin(PSI);
R = diag([ C C C C 1  1 ]);
R(1,3) = S;
R(2,4) = S;
R(3,1) = -S;
R(4,2) = -S;
