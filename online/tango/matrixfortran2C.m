function B = matrixfortran2C(A)
%MATRIXFORTRA2C - Convert a matrix from fortran to C format
%
%  INPUTS
%  1. A - Input matrix in matlab (fortran) format
%  2. B - matrix in C format
%
%  NOTES
%  1. This function is a work around a binding BUG for writting a image
%  into TANGO. So Soon to be obsolete

%
%% Writen By Laurent S. Nadolski

%
[n m] = size(A);

B = ones(n*m,1)*NaN;        
for k1 = 1:n,        
    B(1+(k1-1)*m:k1*m) = A(k1:n:end);
end

B = reshape(B,n,m)';